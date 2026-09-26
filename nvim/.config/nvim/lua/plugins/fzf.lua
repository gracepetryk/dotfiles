local fzf = require("fzf-lua")
local fzf_files = require("plugins.fzf_files")
local find_files = fzf_files.find_files

-- --ignore-case rather than fzf-lua's --smart-case default
local RG_OPTS = "--column --line-number --no-heading --color=always --ignore-case --max-columns=4096"

local function exclude_globs(dirs)
  return table.concat(
    vim.tbl_map(function(dir)
      return "-g " .. vim.fn.shellescape("!" .. dir)
    end, dirs),
    " "
  )
end

fzf.setup({
  ui_select = {},
  files = {
    actions = {
      ["ctrl-a"] = function()
        fzf.buffers({ query = fzf.get_last_query() })
      end,
    },
  },
  grep = {
    rg_opts = RG_OPTS .. " " .. exclude_globs(fzf_files.EXCLUDED_DIRS) .. " -e",
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
  fzf.live_grep({ no_ignore = true, rg_opts = RG_OPTS .. " " .. exclude_globs({ ".git" }) .. " -e" })
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
