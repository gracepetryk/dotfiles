require('rose-pine').setup({
  dark_variant = 'moon',
  disable_float_background = true,
  groups = {
    background = '#191724',

  },

  highlight_groups = {
    LspSignatureActiveParameter = { fg = 'gold' },
    CursorLine = { bg = '#242331' },
    ColorColumn = { link = 'CursorLine' },

    StatusLine = { fg = 'foam', bg = 'foam', blend = 15 },
  }
})

vim.cmd.colorscheme('rose-pine')

