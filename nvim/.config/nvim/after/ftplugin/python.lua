vim.opt_local.formatoptions = 'cqjlr2'

vim.cmd.compiler('pylint')
vim.opt_local.makeprg="{ flake8 --format pylint; pyright \\| grep -E '\\.py:\\d+:' \\| sed 's/^ *//g' \\| sed 's/ - \\(.\\).*:/:\\1:/'; }"
