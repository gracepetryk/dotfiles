local map = require("gpetryk.map").map
local unnamed_register = require('gpetryk.unnamed_register')

map('i', '<C-c>', '<Esc>')
map('i', '<Esc>', '<C-c>') -- in case something goes wrong

-- don't fat finger macros
map('n', 'q', '')
map('n', 'Q', '')
map('n', '`', 'q')

-- restore the unnamed register after change/delete
_G.gpetryk.delete_restore_unnamed = unnamed_register.delete_restore_unnamed
_G.gpetryk.change_restore_unnamed = unnamed_register.change_restore_unnamed
map('n', 'd', ':set opfunc=v:lua.gpetryk.delete_restore_unnamed<CR>g@')
map('n', 'c', ':set opfunc=v:lua.gpetryk.change_restore_unnamed<CR>g@')

-- restore yank register after dd/cc
map('n', 'dd', 'dd:let @@=@0<CR>')
map('n', 'cc', 'cc<C-o>:let@@=@0<CR>')

-- X means cut d means delete
map('n', 'X', 'd')
map('n', 'XX', 'dd')

-- why would u ever want to yank a single character
map('n', 'x', '"_x')

-- system clipboard
map({'n', 'x'}, '<leader>y', '"*y')
map({'n', 'x'}, '<leader>p', '"*p')
map({'n', 'x'}, '<leader>P', '"*P')

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

map('n', '}', ':cn<CR>')
map('n', '{', ':cp<CR>')

-- end of previous word
map('n', 'E', 'ge')

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
map('n', '<A-0>', function() require('harpoon.ui').nav_file(10) end)

-- autoclose parens/quotes/etc
-- local b = require('gpetryk.brackets')
-- 
-- map('i', '(', function() b.insert_pair('(') end)
-- map('i', ')', function() b.insert_closing(')') end)
-- 
-- map('i', '{', function() b.insert_pair('{') end)
-- map('i', '}', function() b.insert_closing('}') end)
-- 
-- map('i', '[', function() b.insert_pair('[') end)
-- map('i', ']', function() b.insert_closing(']') end)
-- 
-- map('i', '"', function() b.insert_quote('"') end)
-- map('i', "'", function() b.insert_quote("'") end)

-- signature help
map({'i', 'n'}, '<C-k>', function () vim.lsp.buf.signature_help() end)

-- illuminate
map({'n'}, '<A-n>', function() require('illuminate').goto_next_reference() end)
map({'n'}, '<A-N>', function() require('illuminate').goto_prev_reference() end)

-- load current dir session
map({'n'}, '<leader>ls', ':SessionManager load_current_dir_session<CR>')
