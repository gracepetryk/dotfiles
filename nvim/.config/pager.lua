vim.o.number = false
vim.o.list = false
vim.o.showtabline=0
vim.o.foldcolumn="0"
vim.o.laststatus=0
vim.o.ruler = false
vim.o.showcmd = false
vim.o.shortmess = vim.o.shortmess .. 'F'
vim.o.scrolloff=10
vim.opt.clipboard = { 'unnamedplus' }
vim.o.hlsearch = false

vim.cmd.hi('Normal guibg=NONE ctermbg=NONE')
vim.cmd.hi('Visual ctermfg=NONE ctermbg=NONE guibg=#332d41')

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('HighlightYank', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.api.nvim_set_keymap('n', 'q', ':qa!<CR>', {})
vim.defer_fn(function ()
  vim.o.modifiable = true
  vim.cmd[[silent! keeppatterns %s/\_s*\%$//e]]
  vim.api.nvim_input('G')
  vim.o.modifiable = false
end, 200)
