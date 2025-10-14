vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = {
        {
          fileMatch = {'/tsconfig.json', '/tsconfig.*.json'},
          url = 'https://www.schemastore.org/tsconfig.json'
        },
        {
          fileMatch = {'pyrightconfig.json'},
          url = 'https://raw.githubusercontent.com/microsoft/pyright/main/packages/vscode-pyright/schemas/pyrightconfig.schema.json'
        },

      }
    }
  }
})

vim.lsp.enable('jsonls')
