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

local function open_debugger()
  require('dap').continue()
  require('dapui').open({})
end

local function close_debugger()
  require('dapui').close({})
  require('dap').repl.close()
end

map('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
map('n', '<Leader>d', open_debugger)
map('n', '<Leader>c', close_debugger)

