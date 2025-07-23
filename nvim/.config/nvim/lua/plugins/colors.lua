--@diagnostic disable-next-line: missing-fields
require('rose-pine').setup({
  dark_variant = 'main',
  ---@diagnostic disable-next-line: missing-fields
  groups = {
    git_add = 'moss',
    git_stage = 'moss',
  },
  highlight_groups = {
    TelescopeNormal = { fg = 'subtle', bg = 'surface' },
    Folded = { bg = 'surface', fg = 'muted' },
    StatusLine = { bg = 'overlay' },
    BlinkCmpDocBorder = { link = 'FloatBorder' },
    BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
    BlinkCmpDocSeparator = { link = 'FloatBorder' },
    NvimTreeIndentMarker = { fg = 'muted' },
    NvimTreeFolderName = { fg = 'pine'},
    NvimTreeFolderIcon = { fg = 'muted'},
    NvimTreeExecFile = { fg = 'love' },
    ['@boolean'] = { fg = 'gold' },
    ['@constructor'] = { fg = 'moss' },
    ['@comment'] = { fg = 'muted' },
    ['@function'] = { fg = 'iris', nocombine = true },
    ['@function.builtin'] = { fg = 'iris', bold = true, nocombine = true },
    ['@function.call'] = { fg = 'iris', italic = true, nocombine = true },
    ['@function.method'] = { link = '@function' },
    ['@function.method.call'] = { link = '@function.call' },
    ['@keyword.return'] = { fg = 'love' },
    ['@keyword.throw'] = { fg = 'love' },
    ['@lsp.mod.declaration'] = { underline = true },
    ['@lsp.type.formatSpecifier'] = { link = '@punctuation' },
    ['@lsp.type.keyword'] = { link = '@keyword' },
    ['@lsp.type.keyword.rust'] = {},
    ['@lsp.type.method.lua'] = { link = '@function.method', italic = true },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@parameter'] = { fg = 'rose', italic=true },
    ['@string'] = { fg = 'fall' },
    ['@string.special.url'] = { link = '@string' },
    ['@string.special.url.comment'] = { link = '@comment' },
    ['@type'] = { fg = 'moss' },
    ['@type.builtin.python'] = { fg = 'moss' },
    ['@variable'] = { fg = 'text', italic=false },
    ['@variable.builtin'] = { fg='love', bold = false },
    ['@variable.member'] = { fg = 'foam', italic=false },
    ['@variable.parameter'] = { link = '@parameter' },
    ['@lsp.type.comment'] = { link = '@comment' }
  }
})

vim.cmd.colorscheme('rose-pine')
