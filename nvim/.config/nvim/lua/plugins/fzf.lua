local fzf = require("fzf-lua")

-- --ignore-case rather than fzf-lua's --smart-case default
local RG_OPTS = "--column --line-number --no-heading --color=always --ignore-case --max-columns=4096"

local function to_buffers()
  fzf.buffers({ query = fzf.get_last_query() })
end

--- Files under cwd, frecently used ones first in score order, whatever else
--- the query matches.
local function find_files(opts)
  require("fzf-lua-frecency").frecency(vim.tbl_deep_extend("force", {
    cwd_only = true,
    actions = { ["ctrl-a"] = to_buffers },
  }, opts or {}))
end

fzf.setup({
  ui_select = {},
  files = {
    actions = { ["ctrl-a"] = to_buffers },
  },
  grep = {
    rg_opts = RG_OPTS .. " -g '!.git' -g '!node_modules' -e",
    hidden = true,
  },
  buffers = {
    actions = {
      ["ctrl-a"] = function()
        find_files({ query = fzf.get_last_query() })
      end,
    },
  },
})

-- tracks scores from BufEnter, so it has to run before the first picker does
require("fzf-lua-frecency").setup()

vim.keymap.set("n", "<leader>ff", fzf.buffers)
vim.keymap.set("n", "<leader>fh", fzf.helptags)
vim.keymap.set("n", "<leader>fr", fzf.resume)
vim.keymap.set("n", "<leader>/", fzf.blines)
vim.keymap.set("n", "<leader>t", fzf.builtin)

vim.keymap.set("n", "<leader>fa", function()
  find_files()
end)

vim.keymap.set("n", "<leader>FA", function()
  fzf.files({ hidden = true, no_ignore = true })
end)

vim.keymap.set("n", "<leader>gf", function()
  fzf.files({ query = vim.fn.expand("<cfile>") })
end)

vim.keymap.set("n", "<leader>fg", fzf.live_grep)

vim.keymap.set("n", "<leader>FG", function()
  fzf.live_grep({ no_ignore = true, rg_opts = RG_OPTS .. " -g '!.git' -e" })
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

--- Maps `keymap` to the LSP picker `fn`, and `<leader>keymap` to the same
--- picker opened from a fresh vertical split.
local function map_lsp(keymap, fn)
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

map_lsp("gr", fzf.lsp_references)
map_lsp("gi", fzf.lsp_implementations)
map_lsp("gd", fzf.lsp_definitions)
map_lsp("gt", fzf.lsp_typedefs)
