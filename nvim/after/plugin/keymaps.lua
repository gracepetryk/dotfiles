local map = require("gpetryk.map").map

map('n', 'x', '"_x')
map('i', 'jj', '<Esc>')
map('i', ';;', '<Right>')
map('i', 'hh', '<Left>')
map('n', 'd', '"_d')
map('n', 'D', 'd')

vim.g['floaterm_keymap_toggle'] = "<leader>ft"
