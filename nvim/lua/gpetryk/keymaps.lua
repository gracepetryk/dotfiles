local map = require("gpetryk.map").map

map('n', 'x', '"_x')
map('n', 'd', '"_d')
map('n', 'D', 'd')
map('n', 'DD', 'dd')

map('i', 'jj', '<Esc>')

map('n', '<leader>w', '<C-w>w')

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

-- debugger mappings

local dap = function() return require('dap') end
local dapui = function() return require('dapui') end

local function open_debugger()
  dapui().open({})
end

local function close_debugger()
  dapui().close({})
  dap().terminate()
  dap().repl.close()
end

map('n', '<C-b>', function() dap().toggle_breakpoint() end)
map('n', '<Leader>tc', function() dap().run_to_cursor() end)
map('n', '<Leader><Leader>d', open_debugger)
map('n', '<Leader><Leader>c', close_debugger)

map('n', '<Leader>di', '"zyiw :lua require"dapui".eval("<C-R>z")<CR>h')
map('v', '<Leader>di', '"zy :lua require"dapui".eval("<C-R>z")<CR>h')

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
