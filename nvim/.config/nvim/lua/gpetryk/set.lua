vim.g.mapleader = " "

vim.o.errorbells = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.updatetime = 100

vim.o.scrolloff = 10

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.laststatus = 2

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.colorcolumn = '92'
vim.o.cursorline = true

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.termguicolors = true

vim.o.wrap = false

vim.o.swapfile = false

vim.o.textwidth = 90
vim.o.formatoptions = 'cqjl'

vim.o.spelllang = 'en_us'
vim.o.spellsuggest = '10'

vim.o.winborder = 'rounded'

-- enable .nvim.lua files
vim.o.exrc=true

-- pop up menu height
vim.o.pumheight = 15
vim.o.previewheight = 20

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
