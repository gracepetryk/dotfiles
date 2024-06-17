require('mason').setup()
local lspconfig = require('lspconfig')

local res, local_config = pcall(require, 'local')

if not res then
  local_config = {node_modules_path = ''}
end

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
      signs = {
        text = {
          [vim.diagnostic.severity.INFO] = '',
          [vim.diagnostic.severity.HINT] = '',
        },
      },
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
  settings = {
    Lua = {
      diagnostics = {
        missing_parameters = false
      }
    }
  },
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

-- If you are using mason.nvim, you can get the ts_plugin_path like this
local mason_registry = require('mason-registry')
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
local ts_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/typescript/lib'

lspconfig.tsserver.setup {
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}

-- No need to set `hybridMode` to `true` as it's the default value
lspconfig.volar.setup {
  init_options = {
    typescript = {
      tsdk = ts_path
    }
  }
}

lspconfig.eslint.setup({})

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
          reportAttributeAccessIssue = "information",
          reportUnnecessaryTypeIgnoreComment = "warning"
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

lspconfig['efm'].setup({
  settings = {
    rootMarkers={".git/"},
    languages = {
      python = {
        require('efmls-configs.linters.flake8')
      }
    }
  }
})

vim.cmd('LspStart')
