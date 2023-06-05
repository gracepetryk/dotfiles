require('grace-rose-pine').setup({
  dark_variant = 'main',
  disable_italics = false,
  groups = {
    git_add = 'moss',
    git_stage = 'moss',
  },
  highlight_groups = {
    FloatBorder = { fg = 'muted', bg = 'base' },
    TelescopeBorder = { fg = 'muted', bg = 'base' },
    LspSignatureActiveParameter = { fg = 'love' },
    TreeSitterContext = { bg = 'foam', blend = 5 },
    IlluminatedWordText = { bg = 'highlight_med', blend=50 },
    IlluminatedWordRead = { link = 'IlluminatedWordText' },
    IlluminatedWordWrite = { link = 'IlluminatedWordText' },
    NoiceVirtualText = { fg = 'muted' },
    ['@type'] = { fg = 'moss' },
    ['@type.qualifier'] = { fg = 'pine' },
    ['@constructor'] = { fg = 'moss' },
    ['Function'] = { fg = 'iris', nocombine=true },
    ['@function.builtin'] = { fg = 'iris', italic = true },
    ['@method'] = { link = '@function' },
    ['@attribute'] = { link = '@function' },
    ['@keyword.return'] = { fg = 'love', bold=true },
    ['@lsp.type.keyword'] = {},
    ['@parameter'] = { fg = 'foam', italic=true },
    ['Boolean'] = { fg = 'gold' },
    ['String'] = { fg = 'fall' },
    ['@variable'] = { fg = 'text' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.formatSpecifier'] = { link = '@punctuation' },
    ['@variable.builtin'] = { fg = 'foam', bold=true, nocombine=true },
    ['@field'] = { fg = 'rose', nocombine=true },
    ['@property'] = { link='@field' },
    ['@constant.builtin'] = { fg = 'gold' },
  }
})

vim.cmd.colorscheme('grace-rose-pine')
