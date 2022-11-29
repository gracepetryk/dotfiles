-- https://github.com/folke/tokyonight.nvim/issues/52#issuecomment-857759344
vim.api.nvim_exec([[
augroup MyColors
	autocmd!
	autocmd ColorScheme * highlight LineNr guifg=#5081c0   | highlight CursorLineNR guifg=#FFba00
augroup END
]], false)  

vim.cmd[[colorscheme tokyonight-storm]]

