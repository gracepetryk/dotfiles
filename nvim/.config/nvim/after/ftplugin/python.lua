vim.opt_local.formatoptions = 'cqjlr2'

vim.cmd.compiler('pylint')
vim.opt_local.makeprg='flake8 --format pylint'

