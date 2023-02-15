local map = require("gpetryk.map").map

map('n', 'x', '"_x')
map('n', 'DD', '"_dd')

map('i', 'jj', '<Esc>')

map('n', '<leader>w', '<C-w>w')
map('n', '<A-w>', '<C-w>w')
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')

map('n', '<A-S-Tab>', '<Cmd>BufferPrevious<CR>')
map('n', '<A-Tab>', '<Cmd>BufferNext<CR>')


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

map('n', '<Leader>v', toggle_vtext)

--one line scrolling

map({'n','i','v','x'}, '<ScrollWheelUp>', '<C-y>')
map({'n','i','v','x'},'<ScrollWheelDown>','<C-e>')

--qflist/loclist

map('n', '}', ':cn<CR>')
map('n', '{', ':cp<CR>')
map('n', '<C-]>', ':lnext<CR>')
map('n', '<C-[>', ':lprev<CR>')

-- harpoon
map('n', '<leader>b', require('harpoon.ui').toggle_quick_menu)
map('n', '<leader>m', require('harpoon.mark').add_file)
map('n', '<A-1>', function() require('harpoon.ui').nav_file(1) end)
map('n', '<A-2>', function() require('harpoon.ui').nav_file(2) end)
map('n', '<A-3>', function() require('harpoon.ui').nav_file(3) end)
map('n', '<A-4>', function() require('harpoon.ui').nav_file(4) end)
map('n', '<A-5>', function() require('harpoon.ui').nav_file(5) end)
map('n', '<A-6>', function() require('harpoon.ui').nav_file(6) end)
map('n', '<A-7>', function() require('harpoon.ui').nav_file(7) end)
map('n', '<A-8>', function() require('harpoon.ui').nav_file(8) end)
map('n', '<A-9>', function() require('harpoon.ui').nav_file(9) end)
