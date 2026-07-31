local builtin = require("telescope.builtin")
local actions_mt = require("telescope.actions.mt")

M = {}
M.post_select = function(prompt_bufnr)
  vim.cmd("silent! normal zOzz")
end
M = actions_mt.transform_mod(M)

require("telescope").load_extension("ui-select") -- make telescope default picker
require("telescope").load_extension("fzf")

vim.keymap.set("n", "<leader>ff", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, {})
vim.keymap.set("n", "<leader>FR", builtin.pickers, {})
vim.keymap.set("n", "<leader>fid", ":Telescope live_grep glob_pattern=")
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
vim.keymap.set("n", "<leader>t", builtin.builtin)

-- unmap default gr* keymaps
for _, m in ipairs(vim.api.nvim_get_keymap("n")) do
  if m.lhs:match("^gr") then
    pcall(vim.keymap.del, "n", m.lhs)
  end
end

local function map_lsp(keymap, fn)
  vim.keymap.set("n", keymap, fn, {})
  vim.keymap.set("n", "<leader>" .. keymap, function()
    vim.cmd.only()
    vim.cmd.vsplit()
    vim.schedule(function()
      vim.cmd.wincmd("l")
      fn({ reuse_win = false })
    end)
  end, {})
end

map_lsp("gr", builtin.lsp_references)
map_lsp("gi", builtin.lsp_implementations)
map_lsp("gd", builtin.lsp_definitions)
map_lsp("gt", builtin.lsp_type_definitions)

vim.keymap.set("n", "<leader>fw", builtin.grep_string, {})
vim.keymap.set("x", "<leader>fw", function()
  vim.api.nvim_feedkeys('"9y', "nx", true)
  local search = vim.fn.getreg("9")
  builtin.grep_string({ search = search })
end)

vim.keymap.set("n", "<leader>FA", function()
  builtin.find_files({
    find_command = {
      "rg",
      "--files",
      "--hidden",
      "--no-ignore",
      "--no-config",
    },
  })
end, {})

vim.keymap.set("n", "<leader>fg", function()
  builtin.live_grep({
    additional_args = {
      "--hidden",
    },
    glob_pattern = {
      "!.git",
      "!node_modules",
    },
  })
end)

vim.keymap.set("n", "<leader>FG", function()
  builtin.live_grep({
    find_command = {
      "rg",
      "--hidden",
      "--no-ignore",
      "--no-config",
    },
  })
end, {})

vim.keymap.set("n", "<leader>gf", function()
  builtin.find_files({ default_text = vim.fn.expand("<cfile>") })
end)

local function open_picker_with_current_search(picker)
  return function(prompt_bufnr)
    local state = require("telescope.actions.state")
    local actions = require("telescope.actions")

    local search = state.get_current_line()
    actions.close(prompt_bufnr)
    picker({ default_text = search })
  end
end

-- File picker that ranks open buffers up by boosting their match score rather
-- than bucketing them ahead of everything. Ignored files are neither searched
-- nor listed until the tracked files run short of good matches.
local IGNORED_PASS = 2

-- The second pass repeats the first with --no-ignore, so it contributes only
-- the ignored files; paths already emitted by the first pass are dropped. It
-- runs at most once per picker, and only if the prompt asks for it.
local FIND_COMMANDS = {
  { "rg", "--files", "--hidden", "-g", "!.git", "-g", "!node_modules" },
  { "rg", "--files", "--hidden", "--no-ignore", "-g", "!.git", "-g", "!node_modules" },
}

local function listed_buffer_paths()
  local paths = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        paths[vim.fs.normalize(vim.fn.fnamemodify(name, ":p"))] = true
      end
    end
  end
  return paths
end

-- Marker column ahead of the file icon. Both values are the same width so the
-- icons stay lined up whether or not a file is open.
local OPEN_BUFFER_MARK = "+ "
local NO_MARK = "  "

--- Renders the usual file entry behind a marker saying whether it is already
--- open in a buffer, dimming the ones that only showed up because hidden and
--- ignored files are searched too.
local function display_with_mark(entry)
  local text, style = entry.file_display(entry)
  local mark = entry.open_buffer and OPEN_BUFFER_MARK or NO_MARK
  local display = mark .. text

  local highlights = {}
  if entry.open_buffer then
    table.insert(highlights, { { 0, #OPEN_BUFFER_MARK }, "TelescopeResultsField" })
  end

  -- the file display's own highlights are relative to text, so shift them past
  -- the marker
  for _, item in ipairs(style or {}) do
    table.insert(highlights, { { item[1][1] + #mark, item[1][2] + #mark }, item[2] })
  end

  -- last, so it paints over the devicon colour for the whole row
  if entry.ignored and not entry.open_buffer then
    table.insert(highlights, { { 0, #display }, "Folded" })
  end

  return display, highlights
end

--- Keeps the file entry's own renderer around as `file_display` and puts the
--- marker renderer in its place.
local function with_buffer_mark(entry_maker)
  return function(line)
    local entry = entry_maker(line)
    if not entry then
      return
    end

    entry.file_display = entry.display
    entry.display = display_with_mark

    return entry
  end
end

-- fzf awards 16 points for every matched character before bonuses and gap
-- penalties, so raw_score / (16 * #prompt) reads as a fraction of a clean
-- character-for-character match and stays comparable however long the prompt
-- gets. Measured over a real file list, a match on the file the prompt is after
-- scores 1.51 and up, while a prompt with nothing to land on falls well below:
-- the best "venv" can do against tracked files is 1.03. Hence the cutoff.
local FZF_SCORE_MATCH = 16
local GOOD_MATCH_QUALITY = 1.5

--- How good `score` (fzf's 1 / raw_score) is against a non-empty `prompt`,
--- relative to a clean character-for-character match.
local function match_quality(score, prompt)
  return 1 / (score * FZF_SCORE_MATCH * #prompt)
end

-- A screenful of solid matches is an answer, so the ignored files are only
-- worth the unfiltered walk of the tree once the tracked ones can't produce
-- even this many.
local MIN_GOOD_MATCHES = 10

--- Written by the sorter as it scores, read by the finder: how the tracked
--- files are matching the prompt currently being scored.
local function new_match_quality()
  return { best = nil, good = 0 }
end

--- Whether the tracked files answer `prompt` well enough that the ignored files
--- aren't worth searching. An empty prompt says nothing about match quality, so
--- it counts as good.
local function tracked_matches_are_good(quality, prompt)
  return prompt == "" or quality.good >= MIN_GOOD_MATCHES
end

--- Finder that runs FIND_COMMANDS in order, streaming results as they arrive
--- and tagging each entry as open-in-a-buffer and/or ignored. The ignored pass
--- is held back until `quality` says the tracked files have run short of good
--- matches, since it costs a full unfiltered walk of the tree.
local function two_pass_finder(opts, quality)
  local async = require("plenary.async")
  local async_job = require("telescope.async_job")
  local entry_maker = with_buffer_mark(require("telescope.make_entry").gen_from_file(opts))

  local open_buffers = listed_buffer_paths()
  local results, seen = {}, {}
  local pass, job, stdout = 1, nil, nil

  local function is_open_buffer(path)
    return open_buffers[vim.fs.normalize(opts.cwd .. "/" .. path)] == true
  end

  return setmetatable({
    results = results,
    entry_maker = entry_maker,
    close = function()
      if job then
        job:close()
      end
    end,
  }, {
    __call = function(_, prompt, process_result, process_complete)
      -- the replay puts every entry back through the sorter, so the quality of
      -- the tracked matches is known for this prompt once it finishes
      local stopped = false
      for index = 1, #results do
        async.util.scheduler()
        if process_result(results[index]) then
          stopped = true
          break
        end
      end

      while not stopped and pass <= #FIND_COMMANDS do
        if pass == IGNORED_PASS and tracked_matches_are_good(quality, prompt) then
          break
        end

        if not job then
          local command = FIND_COMMANDS[pass]
          stdout = async_job.LinesPipe()
          job = async_job.spawn({
            command = command[1],
            args = vim.list_slice(command, 2),
            cwd = opts.cwd,
            stdout = stdout,
          })
        end

        for line in stdout:iter(false) do
          -- yield on every line, otherwise the job's stdout stops draining
          async.util.scheduler()
          if line ~= "" and not seen[line] then
            seen[line] = true
            local entry = entry_maker(line)
            if entry then
              entry.index = #results + 1
              entry.open_buffer = is_open_buffer(line)
              entry.ignored = pass == IGNORED_PASS
              results[entry.index] = entry
              process_result(entry)
            end
          end
        end

        job:close()
        job, stdout = nil, nil
        pass = pass + 1
      end

      process_complete()
    end,
  })
end

-- An open buffer scores as if it matched this much better than it did, so it
-- wins when its match is within 1 / BUFFER_BOOST of the best one and loses when
-- it isn't. At 1.05 that means a buffer needs ~95% of the best score to come out
-- on top: enough for a near-tie, not enough to drag a weak match to the front.
local BUFFER_BOOST = 1.05

-- An ignored file shows up once its match is at least this good relative to the
-- best tracked match, so a near-tie is enough to bring it in. Judging it against
-- the other results rather than against a fixed score keeps the cutoff
-- meaningful whatever the prompt is: fzf's raw scores grow with the length of
-- the match, so no constant means the same thing for a two-character prompt and
-- a twenty-character one.
local IGNORED_MIN_QUALITY = 0.9

--- Wraps the configured file sorter: open buffers get a boost, ignored files
--- are dropped unless they clear IGNORED_MIN_QUALITY. Having a file open beats
--- it being ignored, so an ignored file you already have open is shown and
--- ranked like the rest.
local function boosted_sorter(opts, quality)
  local sorter = require("telescope.config").values.file_sorter(opts)
  local scoring_function = sorter.scoring_function
  local start = sorter.start

  -- the finder emits every tracked file before the first ignored one, and
  -- rescoring walks the results in that same order, so the best tracked score
  -- is settled by the time an ignored entry is scored
  sorter.start = function(self, prompt)
    quality.best, quality.good = nil, 0
    if start then
      start(self, prompt)
    end
  end

  sorter.scoring_function = function(self, prompt, line, entry, ...)
    local score = scoring_function(self, prompt, line, entry, ...)
    if score < 0 or not entry then
      return score
    end

    -- fzf hands back 1 / raw_score, so a lower score is the better match and
    -- scaling the raw score means dividing
    if entry.ignored and not entry.open_buffer then
      if quality.best and score * IGNORED_MIN_QUALITY > quality.best then
        return -1
      end
      return score
    end

    -- recorded before the boost, which is a ranking preference rather than
    -- anything to do with how well the file matched
    quality.best = math.min(quality.best or math.huge, score)
    if prompt ~= "" and match_quality(score, prompt) >= GOOD_MATCH_QUALITY then
      quality.good = quality.good + 1
    end

    if entry.open_buffer then
      score = score / BUFFER_BOOST
    end

    return score
  end

  return sorter
end

local function find_files_boosted(opts)
  opts = opts or {}
  opts.cwd = vim.fs.normalize(opts.cwd or vim.uv.cwd())

  local quality = new_match_quality()

  require("telescope.pickers")
    .new(opts, {
      prompt_title = "Find Files",
      finder = two_pass_finder(opts, quality),
      sorter = boosted_sorter(opts, quality),
      previewer = require("telescope.config").values.file_previewer(opts),
      attach_mappings = function(_, map)
        map({ "i", "n" }, "<C-a>", open_picker_with_current_search(builtin.buffers))
        return true
      end,
    })
    :find()
end

vim.keymap.set("n", "<leader>fa", function()
  find_files_boosted()
end)

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-a>"] = require("telescope.actions").nop,
        ["<CR>"] = require("telescope.actions").select_default + M.post_select,
      },
    },
    cache_picker = {
      num_pickers = 100,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--ignore-case",
      "--hidden",
      "--trim",
    },
  },
  pickers = {
    find_files = {
      find_command = {
        "rg",
        "--files",
        "--hidden",
        "-g",
        "!.git",
        "-g",
        "!node_modules",
      },
      mappings = {
        i = {
          ["<C-a>"] = open_picker_with_current_search(builtin.buffers),
        },
        n = {
          ["<C-a>"] = open_picker_with_current_search(builtin.buffers),
        },
      },
    },
    buffers = {
      mappings = {
        i = {
          ["<C-a>"] = open_picker_with_current_search(builtin.find_files),
        },
        n = {
          ["<C-a>"] = open_picker_with_current_search(builtin.find_files),
        },
      },
    },
  },
})

-- telescope doesn't play niceley with 'winborder' yet
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopeFindPre",
  callback = function()
    local old_winborder = vim.o.winborder
    vim.o.winborder = "none"

    vim.api.nvim_create_autocmd("WinLeave", {
      once = true,
      callback = function()
        vim.opt.winborder = old_winborder
      end,
    })
  end,
})
