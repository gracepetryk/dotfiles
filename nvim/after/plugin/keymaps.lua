local map = require("gpetryk.map").map

map('n', 'x', '"_x')
map('i', 'jj', '<Esc>')
map('i', ';;', '<Right>')
map('i', 'hh', '<Left>')
map('n', 'd', '"_d')
map('n', 'D', 'd')

map('t', '<Esc>', '<C-\\><C-n>:FloatermToggle<CR>')
map('n', '<leader>t', ':FloatermToggle<CR>')
