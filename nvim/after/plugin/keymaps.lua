local map = require("gpetryk.map").map

map('n', 'x', '"_x')
map('i', 'jj', '<Esc>')
map('i', ';;', '<Right>')
map('i', 'hh', '<Left>')
map('n', 'd', '"_d')
map('n', 'D', 'd')
map('n', 'DD', 'dd')

map('n', '<leader>w', '<C-w>w')

map('n', '<A-S-Tab>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-Tab>', '<Cmd>BufferNext<CR>', opts)
