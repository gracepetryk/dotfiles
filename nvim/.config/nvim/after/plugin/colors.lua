---@diagnostic disable-next-line: missing-fields
require('grace-rose-pine').setup({
  dark_variant = 'main',
  disable_italics = false,
  ---@diagnostic disable-next-line: missing-fields
  groups = {
    git_add = 'moss',
    git_stage = 'moss',
  },
  highlight_groups = {
    NormalFloat = { bg = 'surface' },
    Folded = { bg = 'surface', fg = 'muted' },
    TreeSitterContext = { bg = 'overlay', blend = 40 },
    ColorColumn = { bg = 'overlay', blend = 40 },
    StatusLine = { bg = 'overlay' },
    IlluminatedWordText = { bg = 'highlight_med', blend = 60 },
    IlluminatedWordRead = { link = 'IlluminatedWordText' },
    IlluminatedWordWrite = { link = 'IlluminatedWordText' },
    PMenu = { bg = 'float' },
    markdownBoldItalic = { fg = 'foam', bold=true, italic=true },
    SignatureMarkText = { fg = 'muted' },
    ['@type'] = { fg = 'moss' },
    ['@constructor'] = { fg = 'moss' },
    ['Function'] = { fg = 'iris', nocombine=true },
    ['@function.builtin'] = { fg = 'iris', italic = true },
    ['@method'] = { link = '@function' },
    ['@attribute'] = { link = '@function' },
    ['@keyword.return'] = { fg = 'love', bold=true },
    ['@lsp.type.keyword'] = { link = '@keyword' },
    ['@parameter'] = { fg = 'foam', italic=true },
    ['Boolean'] = { fg = 'gold' },
    ['String'] = { fg = 'fall' },
    ['@variable'] = { fg = 'text' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.formatSpecifier'] = { link = '@punctuation' },
    ['@variable.builtin'] = { fg = 'foam', bold=true, nocombine=true },
    ['@field'] = { fg = 'rose', nocombine=true },
    ['@property'] = { link='@field' },
    ['@lsp.type.keyword.rust'] = {}
  }
})

vim.cmd.colorscheme('grace-rose-pine')

require('colorizer').setup({
  filetypes = { '*', '!vim' },
  user_default_options = {
    mode = 'virtualtext',
    names = false
  }
})
