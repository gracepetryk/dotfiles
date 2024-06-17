local map = require("gpetryk.map").map

map('i', '<C-c>', '<Esc>')
map('i', '<Esc>', '<C-c>') -- in case something goes wrong

-- swap line/character mark navigation
map({'n', 'x'}, "'", "m")
map({'n', 'x'}, "m", "'")

map('n', 'm,', "'<")
map('n', 'm.', "'>")

map('n', 'gp', '`Pv`p') -- visual on the last pasted area
map('n', 'gP', '`PV`p') -- visual line on the last pasted area
map('n', 'go', '`>')
map('n', 'gO', '`<')

-- don't fat finger macros
map('n', 'q', '')
map('n', 'Q', 'q')

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
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

--qflist/loclist
map('n', '<C-n>', ':cn<CR>')
map('n', '<C-p>', ':cp<CR>')

-- load current dir session
map({ 'n' }, '<leader>ls', ':SessionManager load_current_dir_session<CR>')

map('i', '<C-y>', function ()
  vim.g.disable_cmp = true
  vim.api.nvim_feedkeys('', 'n', false)

  vim.api.nvim_create_autocmd({ 'InsertLeave' } , {
    callback = function ()
      vim.g.disable_cmp = false
    end
  })
end)

-- LuaSnip
local ls = nil
map({ 'i', 's' }, '<Tab>', function()
  if ls == nil then
    ls = require('luasnip')
  end

  if ls.choice_active() then
    require('luasnip.extras.select_choice')()
  elseif ls.expand_or_locally_jumpable() then
    ls.expand_or_jump()
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<Tab>', true, false, true),
      'nt',
      true
    )
  end
end)

map({ 'i', 's' }, '<S-Tab>', function()
  ls.jump(-1)
end)

map('n', '<C-s>', ':set spell!<CR>')
