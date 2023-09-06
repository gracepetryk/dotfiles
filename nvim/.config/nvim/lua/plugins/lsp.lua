require('mason').setup()

-- lua lsp
require('neodev').setup({
  override = function(root_dir, library)
    library.enabled = true
    library.plugins = true
  end,
})
local lspconfig = require('lspconfig')

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
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local bufopts = { noremap = true, silent = true }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>fm', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.keymap.set('n', 'L', vim.lsp.buf.hover, bufopts)

    local diagnostic_float_opts = {
      focusable = false,
      border = 'single',
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }

    vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float(nil, diagnostic_float_opts) end, bufopts)
  end
})


vim.keymap.set({ 'i', 'n' }, '<C-k>', vim.lsp.buf.signature_help)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = 'single',
  }
)
vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
  local bufnr, winnr = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border='single',
    max_height = 20,
    max_width = 120,
    wrap_at = 120,
    anchor_bias = 'above'
  })(...)

  if vim.fn.line('$', winnr) > 1 and string.sub(vim.api.nvim_buf_get_lines(bufnr, 1, 2, false)[1], 1, 3) ~= '─' then
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.fn.appendbufline(bufnr, 1, string.rep('─', vim.api.nvim_win_get_width(winnr)))

    local win_height = vim.api.nvim_win_get_height(winnr)
    vim.print(win_height)
    if win_height < 20 then
      vim.api.nvim_win_set_height(winnr, win_height + 1)
    end
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  end

  if require('cmp').visible() and require('cmp').core then
    require('cmp').close()
  end

  return bufnr, winnr
end

require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({})
  end,

  ['lua_ls'] = function ()
    lspconfig['lua_ls'].setup({
      settings = {
        Lua = {
          workspace = {
            checkThirdParty = false,
          }
        }
      }
    })
  end,
  ['pyright'] = function()
    lspconfig['pyright'].setup({
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "onlyOpenFiles",
            useLibraryCodeForTypes = true,
            diagnosticSeverityOverrides = {
              reportGeneralTypeIssues = "warning",
              reportOptionalMemberAccess =  "information",
              reportOptionalSubscript = "information",
            }
          },
          venvPath = "/Users/GPetryk/.pyenv/versions",
        }
      }
    })
  end,

  ['emmet_ls'] = function()
    lspconfig['emmet_ls'].setup({
      filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby" }
    })
  end,

  ['html'] = function()
    lspconfig['html'].setup({
      filetypes = { 'html', 'htmldjango' }
    })
  end,
})
