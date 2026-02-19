vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/compose-spec/compose-go/master/schema/compose-spec.json"] = "docker-compose.yml",
      },
    },
  },
})

vim.lsp.start(vim.lsp.config.yamlls)
