vim.opt_local.formatoptions = 'cqjlr2'

vim.opt_local.makeprg="flake8"
vim.opt_local.errorformat="%f:%l:%c: %t%n %m"

vim.lsp.config('ty', {
  settings = {
    ty = {
      experimental = {
        rename = true,
      },
    },
  },
})


vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

-- local function reset_folds()
--   require('ufo').openFoldsExceptKinds({'function_definition'})
-- end
-- 
-- local has_view, _ = pcall(vim.cmd.loadview)
-- 
-- if not has_view then
--   require('ufo') -- ensure ufo is loaded and has time to cache treesitter results
--   vim.defer_fn(reset_folds, 300) -- wait for treesitter
-- end
-- 
-- vim.keymap.set('n', 'zx', function ()
--   reset_folds()
--   vim.cmd('silent! normal zOzz')
-- end)
