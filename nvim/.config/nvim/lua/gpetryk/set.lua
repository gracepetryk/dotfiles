vim.g.mapleader = " "

vim.opt_global.errorbells = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.updatetime = 100

vim.opt_global.scrolloff = 10

vim.opt_global.hlsearch = false
vim.opt_global.incsearch = true

vim.opt_global.laststatus = 2

vim.opt_global.ignorecase = true
vim.opt_global.smartcase = true

vim.opt_global.colorcolumn = '92'
vim.opt_global.cursorline = true

vim.opt_global.tabstop = 4
vim.opt_global.softtabstop = 4
vim.opt_global.shiftwidth = 4
vim.opt_global.expandtab = true

vim.opt_global.termguicolors = true

vim.opt_global.wrap = false

vim.opt_global.swapfile = false

vim.opt_global.textwidth = 90
vim.opt_global.formatoptions = 'cqjl'

vim.opt_global.spelllang = 'en_us'
vim.opt_global.spellsuggest = '10'

vim.opt_global.winborder = 'rounded'

-- enable .nvim.lua files
vim.opt_global.exrc=true

-- pop up menu height
vim.opt_global.pumheight = 15
vim.opt_global.previewheight = 20

vim.opt.sessionoptions="blank,buffers,curdir,tabpages,winsize,winpos,terminal,localoptions,folds"
vim.opt.viewoptions="cursor,curdir"

vim.g.omni_sql_no_default_maps = 1

vim.g.loaded_tar = 0

vim.opt.foldtext=""

vim.o.foldcolumn='auto'
vim.o.fillchars='fold: ,foldclose:,foldopen:,foldsep: '
vim.o.foldopen='block,hor,mark,percent,quickfix,search,tag,undo,jump'
vim.o.foldenable=true
vim.o.foldlevel=99
vim.o.foldlevelstart=99

if not pcall(function () vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. '/bin/python' end) then
  vim.g.loaded_python3_provider = 0
end
