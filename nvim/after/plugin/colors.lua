require('rose-pine').setup({
  dark_variant = 'main',
  disable_italics = false,
  highlight_groups = {
    FloatBorder = { fg = 'muted', bg = 'base' },
    TelescopeBorder = { fg = 'muted', bg = 'base' },
    LspSignatureActiveParameter = { fg = 'gold' },
    TreeSitterContext = { bg = 'foam', blend = 5 },
    Type = { fg = 'rose' },
    ['@variable'] = { fg = 'text' },
  }
})

vim.cmd.colorscheme('rose-pine')
