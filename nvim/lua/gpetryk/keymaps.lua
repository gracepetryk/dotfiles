local map = require("gpetryk.map").map

map('i', '<C-c>', '<Esc>') -- if InsertLeave fails in an autocmd im fucked but I love my insertleave cmd

-- don't fat finger macros
map('n', 'q', '')
map('n', 'Q', '')
map('n', '`', 'q')

-- restore the yank register after change/delete
map('n', 'd', ':set opfunc=v:lua.gpetryk.delete_restore_yank<CR>g@')
map('n', 'c', ':set opfunc=v:lua.gpetryk.change_restore_yank<CR>g@')

-- x means cut d means delete
map('n', 'x', 'd')
map('n', 'xx', 'dd')

-- old cut go away
map('n', 'X', '"_x')

if _G.gpetryk == nil then
  _G.gpetryk = {}
end

_G.gpetryk.motion_select = function (command, flags)
  local start_mark = vim.api.nvim_buf_get_mark(0, "[")
  local end_mark = vim.api.nvim_buf_get_mark(0, "]")

  vim.api.nvim_win_set_cursor(0, start_mark)
  vim.api.nvim_feedkeys('v', 'nx', false)
  vim.api.nvim_win_set_cursor(0, end_mark)

  vim.api.nvim_feedkeys(command, flags, false)
end

_G.gpetryk.delete_restore_yank = function ()
  _G.gpetryk.motion_select('d', 'nx')
  vim.fn.setreg('', vim.fn.getreg('0'))
end

_G.gpetryk.change_restore_yank =  function ()
  _G.gpetryk.motion_select('c', 'n')

  vim.api.nvim_create_autocmd('InsertLeavePre', {
    once = true,
    callback =  function()
      vim.fn.setreg('', vim.fn.getreg('0'))
    end
  })
end

-- restore yank register after dd/cc
map('n', 'dd', 'dd:let @@=@0<CR>')
map('n', 'cc', 'cc:let @@=@0<CR>')

-- system clipboard
map({'n', 'x'}, '<leader>y', '"*y')
map({'n', 'x'}, '<leader>p', '"*p')
map({'n', 'x'}, '<leader>P', '"*P')

-- paste UUID
map('n', 'U',function ()
  local cur = vim.api.nvim_win_get_cursor(0)
  local row = cur[1]
  local col = cur[2]

  vim.cmd.py3('import uuid')
  local uuid = vim.fn.py3eval('str(uuid.uuid4())')

  vim.api.nvim_buf_set_text(0, row - 1, col + 1, row - 1, col + 1, {uuid})
  vim.api.nvim_win_set_cursor(0, {row, col + string.len(uuid)})
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
