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
    LspSignatureActiveParameter = { fg = 'gold' },
    TreeSitterContext = { bg = 'foam', blend = 5 },
    ['@type'] = { fg = 'moss' },
    ['@type.qualifier'] = { fg = 'pine' },
    ['@constructor'] = { fg = 'moss' },
    ['Function'] = { fg = 'iris' },
    ['@method'] = { link = '@function' },
    ['@function.builtin'] = { link = 'Function' },
    ['@keyword.return'] = { fg = 'love', bold=true },
    ['@parameter'] = { fg = 'rose', italic=true },
    ['Boolean'] = { fg = 'gold' },
    ['String'] = { fg = '#f0a88b' },
    ['@variable'] = { fg = 'text' },
    ['@variable.builtin'] = { fg = 'foam', bold=true, nocombine=true },
    ['@field'] = { fg = 'foam', nocombine=true },
    ['@property'] = { link='@field' },
    ['@constant.builtin'] = { fg = 'gold' },
  }
})

vim.cmd.colorscheme('grace-rose-pine')
