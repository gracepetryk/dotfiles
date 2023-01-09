require('lualine').setup({
  sections = {
    lualine_b = {
      'branch',
      'diff',
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1
      },
    }
  }
})
