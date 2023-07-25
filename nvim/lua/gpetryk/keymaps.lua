local map = require("gpetryk.map").map

map('i', '<C-c>', '<Esc>')
map('i', '<Esc>', '<C-c>') -- in case something goes wrong

-- don't fat finger macros
map('n', 'q', '')
map('n', 'Q', 'q')

map('x', 'p', 'p:let @@=@0<CR>')

-- why would u ever want to yank a single character
map('n', 'x', '"_x')

-- fast paste from yank register
map('n', '[p', '"0p')
map('n', '[P', '"0P')

-- system clipboard
map({'n', 'x'}, '<leader>y', '"+y')
map({'n', 'x'}, '<leader>p', '"+p')
map({'n', 'x'}, '<leader>P', '"+P')

-- paste UUID
map('n', 'U',function ()
  vim.cmd.py3('import uuid')
  local uuid = vim.fn.py3eval('str(uuid.uuid4())')

  vim.api.nvim_paste(uuid, false, -1)
end)

map('n', '<A-o>', '<C-w>w')
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')

map('n', '<leader>vs', vim.cmd.vsplit)

map('x', 'J', ":m '>+1<CR>gv=gv")
map('x', 'K', ":m '<-2<CR>gv=gv")

--one line scrolling

map({ 'n', 'i', 'x'}, '<ScrollWheelUp>', '<C-y>')
map({ 'n', 'i', 'x'}, '<ScrollWheelDown>', '<C-e>')

-- center half page scrolls
map({ 'n', 'x' }, '<C-u>', '<C-u>zz')
map({ 'n', 'x' }, '<C-d>', '<C-d>zz')

-- center search
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

--qflist/loclist
map('n', '<C-n>', ':cn<CR>')
map('n', '<C-p>', ':cp<CR>')

-- signature help
map({'i', 'n'}, '<C-k>', function () vim.lsp.buf.signature_help() end)

-- load current dir session
map({'n'}, '<leader>ls', ':SessionManager load_current_dir_session<CR>')

-- gd in help
map('n', 'gd', '<C-]>')
