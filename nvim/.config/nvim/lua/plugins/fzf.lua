local fzf = require("fzf-lua")

-- git internals that are only noise in search results, in the repo's own .git
-- and in submodules' under .git/modules; the rest (config, info/exclude, real
-- hooks) stays searchable
local GIT_NOISE_GLOBS = vim.tbl_map(function(path)
  return "**/.git/**/" .. path
end, { "objects", "logs", "refs", "packed-refs", "hooks/*.sample" })

--- Formats each git noise glob with `flag_fmt` (e.g. "-g '!%s'") into one
--- string of command line flags.
local function git_noise_flags(flag_fmt)
  return table.concat(
    vim.tbl_map(function(glob)
      return flag_fmt:format(glob)
    end, GIT_NOISE_GLOBS),
    " "
  )
end

local function to_buffers()
  fzf.buffers({ query = fzf.get_last_query() })
end

local frecency = require("fzf-lua-frecency")

-- how many of the matched lines are checked for a scored file
local FRECENT_SCAN_LIMIT = 50

--- Opens the frecency picker, which lists scored files first and then the rest
--- unsorted. fzf keeps that order while one of the first `FRECENT_SCAN_LIMIT`
--- matches is a scored file (those lines start with their score), and sorts by
--- match quality once none are.
---@param opts? table options for `frecency.frecency`
local function frecency_picker(opts)
  -- the picker starts unsorted, as if the query matched a scored file
  local has_frecent_results = true

  -- called by the `result` bind below with the path of a file of all matched
  -- lines; the returned string is run as fzf actions
  _G.FrecencyOnResult = function(frecent_search_exit_code)
    local now_has_frecent = frecent_search_exit_code == 0

    if now_has_frecent == has_frecent_results then
      return ""
    end
    has_frecent_results = now_has_frecent
    return "toggle-sort"
  end

  -- fzf runs inside an nvim terminal, so $NVIM is this session's server
  local on_result = (
    [[%s -q '^ *[0-9]' '{*f}' >/dev/null; %s --server "$NVIM" --headless -u NONE --remote-expr "v:lua.FrecencyOnResult($?)"]]
  ):format(
    vim.fn.shellescape(vim.fn.exepath('rg') or vim.fn.exepath('grep')),
    vim.fn.shellescape(vim.v.progpath)
  )

  frecency.frecency(vim.tbl_deep_extend("force", opts or {}, {
    keymap = {
      fzf = {
        -- toggles like alt-i and `fzf.resume` restart fzf, which starts unsorted again
        start = function()
          has_frecent_results = true
        end,
        result = "transform:" .. on_result,
      },
    },
  }))
end

fzf.setup({
  -- preview below the results so long paths get the full window width
  winopts = { preview = { horizontal="right:45%" }, cursorline = true},
  defaults = { formatter = "path.filename_first" },
  -- `[1] = true` keeps fzf-lua's other default binds
  keymap = {
    -- builtin previewer
    builtin = { [1] = true, ["<M-p>"] = "toggle-preview" },
    -- fzf previewers (bat, git, etc.)
    fzf = { true, ["alt-p"] = "toggle-preview" , ['change'] = 'first'},
  },
  ui_select = {},
  files = {
    actions = { ["ctrl-a"] = to_buffers },
  },
  grep = {
    -- fzf-lua's default, plus skipping git noise now that hidden files are searched
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 "
      .. git_noise_flags("-g '!%s'")
      .. " -e",
    hidden = true,
  },
  buffers = {
    actions = {
      ["ctrl-a"] = function()
        frecency_picker({ query = fzf.get_last_query() })
      end,
    },
  },
})

-- tracks scores from BufEnter, so it has to run before the first picker does;
-- options given here are the defaults for every frecency picker
frecency.setup({
  cwd_only = true,
  actions = { ["ctrl-a"] = to_buffers },
})

vim.keymap.set("n", "<leader>ff", fzf.buffers)
vim.keymap.set("n", "<leader>fh", fzf.helptags)
vim.keymap.set("n", "<leader>fr", fzf.resume)
vim.keymap.set("n", "<leader>/", fzf.blines)
vim.keymap.set("n", "<leader>t", fzf.builtin)

vim.keymap.set("n", "<leader>fa", function()
  frecency_picker()
end)

vim.keymap.set("n", "<leader>FA", function()
  frecency_picker({
    hidden = true,
    no_ignore = true,
    -- frecency's default, minus its blanket `--exclude .git`
    fd_opts = "--color=never --type f --type l " .. git_noise_flags("--exclude '%s'"),
  })
end)

vim.keymap.set("n", "<leader>gf", function()
  fzf.files({ query = vim.fn.expand("<cfile>") })
end)

vim.keymap.set("n", "<leader>fg", fzf.live_grep)

vim.keymap.set("n", "<leader>FG", function()
  fzf.live_grep({ no_ignore = true })
end)

-- live_grep reads globs from the query after " -- ", so this seeds the query
-- with the glob and parks the cursor in front of it for the search term
vim.keymap.set("n", "<leader>fid", function()
  vim.ui.input({ prompt = "Glob: " }, function(glob)
    if not glob or glob == "" then
      return
    end
    fzf.live_grep({
      search = " -- " .. glob,
      no_esc = true,
      keymap = { fzf = { start = "+beginning-of-line" } },
    })
  end)
end)

vim.keymap.set("n", "<leader>fw", fzf.grep_cword)
vim.keymap.set("x", "<leader>fw", fzf.grep_visual)

-- unmap default gr* keymaps
for _, m in ipairs(vim.api.nvim_get_keymap("n")) do
  if m.lhs:match("^gr") then
    pcall(vim.keymap.del, "n", m.lhs)
  end
end

--- Maps `keymap` to the picker `fn`, and `<leader>keymap` to the same picker
--- opened from a fresh vertical split.
local function map_with_vsplit(keymap, fn)
  vim.keymap.set("n", keymap, fn)
  vim.keymap.set("n", "<leader>" .. keymap, function()
    vim.cmd.only()
    vim.cmd.vsplit()
    vim.schedule(function()
      vim.cmd.wincmd("l")
      fn({ reuse_win = false })
    end)
  end)
end

map_with_vsplit("gr", fzf.lsp_references)
map_with_vsplit("gi", fzf.lsp_implementations)
map_with_vsplit("gd", fzf.lsp_definitions)
map_with_vsplit("gt", fzf.lsp_typedefs)
