local fzf = require("fzf-lua")

local function to_buffers()
  fzf.buffers({ query = fzf.get_last_query() })
end

local frecency = require("fzf-lua-frecency")

fzf.setup({
  ui_select = {},
  files = {
    actions = { ["ctrl-a"] = to_buffers },
  },
  grep = {
    -- fzf-lua's default, plus skipping .git now that hidden files are searched
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git' -e",
    hidden = true,
  },
  buffers = {
    actions = {
      ["ctrl-a"] = function()
        frecency.frecency({ query = fzf.get_last_query() })
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

vim.keymap.set("n", "<leader>fa", frecency.frecency)

vim.keymap.set("n", "<leader>FA", function()
  fzf.files({ hidden = true, no_ignore = true })
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
