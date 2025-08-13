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

vim.lsp.enable('ty')
vim.lsp.enable('ruff')
