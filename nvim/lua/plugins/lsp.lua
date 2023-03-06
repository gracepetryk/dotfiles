require('mason').setup()

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local mapopts = { noremap = true, silent = true }
vim.keymap.set('n', '<A-[>', vim.diagnostic.goto_prev, mapopts)
vim.keymap.set('n', '<A-]>', vim.diagnostic.goto_next, mapopts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, mapopts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap = true, silent = true}
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'L', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

vim.g.diagnostic_float_opts = {
  focusable = false,
  close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  border = 'rounded',
  source = 'always',
  prefix = ' ',
  scope = 'cursor',
}

vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float(nil, vim.g.diagnostic_float_opts) end, bufopts)

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
  }
)


require('lspconfig')['pyright'].setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "onlyOpenFiles",
        useLibraryCodeForTypes = true,
        stubPath = "/Users/GPetryk/typings"
      }
    }
  }
})


require('lspconfig')['lua_ls'].setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

require('lspconfig')['solargraph'].setup({})
require('lspconfig')['bashls'].setup({})
require('lspconfig')['tsserver'].setup({})
