if vim.b.did_lua_ftplugin then
  return
end

vim.b.did_lua_ftplugin = 1
local has_view, _ = pcall(vim.cmd.loadview)

local function reset_folds()
  require('ufo').closeFoldsWith(1)
  -- vim.cmd("normal! m'")
  -- vim.cmd('silent! keeppatterns keepjumps g|/\\*\\*|silent! foldopen')
  -- vim.cmd("normal! ''")
end

vim.keymap.set('n', 'zx', function ()
  reset_folds()
end)
