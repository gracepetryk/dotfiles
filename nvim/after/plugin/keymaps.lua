local map = require("gpetryk.map").map

map('n', 'x', '"_x')
map('n', 'd', '"_d')
map('n', 'D', 'd')
map('n', 'DD', 'dd')

map('i', 'jj', '<Esc>')

map('n', '<leader>w', '<C-w>w')

map('n', '<A-S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-Tab>', '<Cmd>BufferNext<CR>', opts)


-- Toggle virtual text
vim.g.vtext_enabled = false
local function toggle_vtext()
    if vim.g.vtext_enabled then
        vim.diagnostic.config({virtual_text = false})
        vim.g.vtext_enabled = false
    else
        vim.diagnostic.config({virtual_text = true})
        vim.g.vtext_enabled = true
    end
end
        
map('n', '<Leader>v', ':lua toggle_vtext()<CR>')

