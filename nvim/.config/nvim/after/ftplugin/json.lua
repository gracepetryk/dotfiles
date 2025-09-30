vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = {'/tsconfig.json', '/tsconfig.*.json'},
          url = 'https://www.schemastore.org/tsconfig.json'
        },
      }
    }
  }
})

vim.lsp.enable('jsonls')
