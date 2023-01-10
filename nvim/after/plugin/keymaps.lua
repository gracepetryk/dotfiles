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

local dap = require('dap')
local dapui = require('dapui')

local function open_debugger()
  dap.continue()
  dapui.open({})
end

local function close_debugger()
  dapui.close({})
  dap.terminate()
  dap.repl.close()
end

map('n', '<Leader>b', dap.toggle_breakpoint)
map('n', '<Leader>tc', dap.run_to_cursor)
map('n', '<Leader><Leader>d', open_debugger)
map('n', '<Leader><Leader>c', close_debugger)

map('n', '<Leader>di', '"zyiw :lua require"dapui".eval("<C-R>z")<CR>h')
map('v', '<Leader>di', '"zy :lua require"dapui".eval("<C-R>z")<CR>h')

--one line scrolling

map({'n','i','v','x'}, '<ScrollWheelUp>', '<C-y>')
map({'n','i','v','x'},'<ScrollWheelDown>','<C-e>')

-- leap

require('leap').add_default_mappings()
