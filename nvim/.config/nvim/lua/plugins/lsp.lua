require('mason').setup()
local lspconfig = require('lspconfig')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufopts = { noremap = true, silent = true }
    vim.keymap.set('n', '<A-[>', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', '<A-]>', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'L', vim.lsp.buf.hover, bufopts)
    vim.keymap.set({ 'i', 'n' }, '<C-k>', vim.lsp.buf.signature_help)


    vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float(nil, { border = 'single' }) end, bufopts)

    vim.diagnostic.config({
      signs = false,
      severity_sort = true,
      virtual_text = false,
      float = {
        format = function (diagnostic)
          return string.format('%s [%s]', diagnostic.message, diagnostic.code)
        end
      }
    })
  end
})
vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  virtual_text = false,
  float = {
    format = function (diagnostic)
      return string.format('%s [%s]', diagnostic.message, diagnostic.code)
    end
  }
})


vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    border = 'single',
  }
)
vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
  local bufnr, winnr = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'single'
  })(...)

  if require('cmp').visible() and require('cmp').core then
    require('cmp').close()
  end

  return bufnr, winnr
end


lspconfig['lua_ls'].setup({
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_list_runtime_paths()
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
})

lspconfig['pyright'].setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "onlyOpenFiles",
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportArgumentType = "warning",
          reportOptionalMemberAccess =  "information",
          reportOptionalSubscript = "information",
        }
      },
      venvPath = "/Users/GPetryk/.pyenv/versions",
    }
  }
})

lspconfig['emmet_ls'].setup({
  filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby" }
})

lspconfig['html'].setup({
  filetypes = { 'html', 'htmldjango' }
})

vim.cmd('LspStart')
