-- https://github.com/folke/tokyonight.nvim/issues/52#issuecomment-857759344
-- vim.api.nvim_exec([[
-- augroup MyColors
-- 	autocmd!
-- 	autocmd ColorScheme * highlight LineNr guifg=#5081c0   | highlight CursorLineNR guifg=#FFba00
-- augroup END
-- ]], false)  
--

vim.cmd[[colorscheme vscode]]
vim.cmd[[hi TreesitterContextBottom gui=underline guisp=Grey]]

vim.cmd[[highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080]]
-- blue
vim.cmd[[highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6]]
vim.cmd[[highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch]]
-- light blue
vim.cmd[[highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE]]
vim.cmd[[highlight! link CmpItemKindInterface CmpItemKindVariable]]
vim.cmd[[highlight! link CmpItemKindText CmpItemKindVariable]]
-- pink
vim.cmd[[highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0]]
vim.cmd[[highlight! link CmpItemKindMethod CmpItemKindFunction]]
-- front
vim.cmd[[highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4]]
vim.cmd[[highlight! link CmpItemKindProperty CmpItemKindKeyword]]
vim.cmd[[highlight! link CmpItemKindUnit CmpItemKindKeyword]]
