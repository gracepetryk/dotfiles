vim.g.mapleader = " "

vim.opt.errorbells = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.updatetime = 100

vim.opt.scrolloff = 10

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.laststatus = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes:1'
vim.opt.colorcolumn = '91'

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.termguicolors = true

vim.opt.wrap = false

vim.opt.swapfile = false

vim.opt.textwidth = 90
vim.opt.formatoptions = 'cqjl'

vim.opt.guicursor = ''

vim.opt.spelllang = 'en_us'
vim.opt.spellsuggest = '10'

-- pop up menu height
vim.opt.pumheight = 15
vim.opt.previewheight = 20

vim.g.omni_sql_no_default_maps = 1

vim.g.loaded_tar = 0

if not pcall(function () vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. '/bin/python' end) then
  vim.g.loaded_python3_provider = 0
end
