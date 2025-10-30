local map = require("gpetryk.map").map

-- make a normal mode remap that is dot-repeatable using vim-repeat plugin
local function normalRepeatableMap(binding, func)
  -- map unique Plug mapping using tostring of function
  local mapName = "<Plug>" .. tostring(func):gsub("function: ", "")
  -- mapping including vim-repeat magic
  local repeatMap = mapName .. [[:silent! call repeat#set("\]] .. mapName .. [[", v:count)<CR>]]

  map('n', mapName, func)
  map('n', binding, repeatMap)
end

map('i', '<C-c>', '<Esc>')
map('i', '<Esc>', '<C-c>') -- in case something goes wrong

map('n', 's', '&&')

map('n', 'gp', '`Pv`p') -- visual on the last pasted area
map('n', 'gP', '`PV`p') -- visual line on the last pasted area
map('n', 'go', '`>')
map('n', 'gO', '`<')

-- don't fat finger macros
-- map('n', 'q', '')
-- map('n', 'Q', 'q')

map({'n', 'x'}, 'p', "p`[mP`]mp")
map({'n', 'x'}, 'P', "P`]mp`[mP")

map('x', 'p', 'p:let @@=@0<CR>', { remap = true })
-- why would u ever want to yank a single character
map('n', 'x', '"_x')

-- fast paste from yank register
map('n', '[p', '"0p', { remap = true })
map('n', '[P', '"0P', { remap = true })

-- system clipboard
map({ 'n', 'x' }, '<leader>y', '"+y')
map({ 'n', 'x' }, '<leader>p', '"+p', { remap = true })
map({ 'n', 'x' }, '<leader>P', '"+P', { remap = true })

-- paste UUID
map('n', 'U', function()
  vim.cmd.py3('import uuid')
  local uuid = vim.fn.py3eval('str(uuid.uuid4())')

  vim.api.nvim_paste(uuid, false, -1)
end)

map('n', '<A-o>', '<C-w>w')
map('n', '<A-h>', '<C-w>h')
map('n', '<A-j>', '<C-w>j')
map('n', '<A-k>', '<C-w>k')
map('n', '<A-l>', '<C-w>l')

map('n', '<C-l>', ':tabnext<CR>')
map('n', '<C-h>', ':tabprev<CR>')

map('n', '<leader>vs', vim.cmd.vsplit)

map('n', 'gJ', 'Jx')

map('x', '<leader>j', 'J:s/ \\./\\./g<CR>')

map('x', 'J', ":m '>+1<CR>gv=gv")
map('x', 'K', ":m '<-2<CR>gv=gv")

--one line scrolling

map({ 'n', 'i', 'x' }, '<ScrollWheelUp>', '<C-y>')
map({ 'n', 'i', 'x' }, '<ScrollWheelDown>', '<C-e>')

local function big_jump(key)
  local jump_size = math.floor(vim.api.nvim_win_get_height(0) / 3)

  vim.cmd('normal! ' .. jump_size .. key)
end

map({ 'n', 'x' }, '<C-u>', function () big_jump('k') end)
map({ 'n', 'x' }, '<C-d>', function () big_jump('j') end)

-- center search
map('n', 'n', function ()
  vim.api.nvim_feedkeys('nzz', 'ntx', false)
end)
map('n', 'N', function ()
  vim.api.nvim_feedkeys('Nzz', 'ntx', false)
end)

--qflist/loclist
map('n', '<C-n>', ':cn<CR>')
map('n', '<C-p>', ':cp<CR>')
map('n', '<C-CR>', ':cc<CR>')

map('n', '<A-n>', ':lnext<CR>')
map('n', '<A-p>', ':lprev<CR>')

-- map('i', '<C-y>', function ()
--   vim.g.disable_cmp = true
--   vim.api.nvim_feedkeys('', 'n', false)
--
--   vim.api.nvim_create_autocmd({ 'InsertLeave' } , {
--     callback = function ()
--       vim.g.disable_cmp = false
--     end
--   })
-- end)

vim.keymap.set('n', '<C-s>', ':set spell!<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<S-CR>', '\\<cmd>sleep 10ms<CR><CR>')
vim.keymap.set('t', '<C-w>h', function() vim.cmd.wincmd('h') end)
vim.keymap.set('t', '<C-w>l', function() vim.cmd.wincmd('l') end)
vim.keymap.set('t', '<C-w>j', function() vim.cmd.wincmd('j') end)
vim.keymap.set('t', '<C-w>k', function() vim.cmd.wincmd('k') end)
vim.keymap.set('t', '<C-w>o', function() vim.cmd.wincmd('o') end)

vim.api.nvim_create_autocmd('WinEnter', {
  callback = function (args)
    
    if vim.bo.buftype == 'terminal' then
      vim.cmd[[normal! i]]
    end
    
  end
})
