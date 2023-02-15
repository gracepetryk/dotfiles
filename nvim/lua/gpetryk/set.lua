vim.opt.errorbells = false

vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.updatetime = 100

vim.opt.scrolloff = 10

vim.opt.hlsearch = false
vim.opt.incsearch = true


vim.g.mapleader = " "

vim.opt.laststatus = 3

function hlwinbar()
  if (vim.api.nvim_get_current_win() == vim.g.statusline_winid) then
    hl = "%#StatusLine#"
  else
    hl = "%#StatusLineNC#"
  end

  return hl .. "%f"
end

vim.opt.winbar = '%!luaeval("hlwinbar()")'

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes:2'
