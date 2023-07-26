local cmp = require('cmp')

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
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.keymap.set('n', 'L', vim.lsp.buf.hover, bufopts)

    local diagnostic_float_opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }

    vim.keymap.set('n', '<leader>e', function() vim.diagnostic.open_float(nil, diagnostic_float_opts) end, bufopts)
  end
})


local sig_help_winnr

vim.keymap.set({ 'i', 'n' }, '<C-k>', function()
  -- don't enter window in insert mode

  if vim.api.nvim_get_mode().mode == 'n' then
    vim.lsp.buf.signature_help()
    return
  end

  local sig_help_was_open, _ = pcall(vim.api.nvim_win_close, sig_help_winnr, false)

  if not sig_help_was_open then
    vim.lsp.buf.signature_help()
  end
end)

vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
  if cmp.visible then
    cmp.close()
  end

  local bufnr, winnr = vim.lsp.with(vim.lsp.handlers.signature_help, {
    max_height = math.max(vim.opt.scrolloff._value, vim.fn.winline() - 1),
    anchor_bias = 'south'
  })(...)

  sig_help_winnr = winnr

  local function callback(cmp_table)
    local cmp_top = cmp_table.window.entries_win.style.row
    local current_line = vim.fn.winline()

    local status, sig_win_pos = pcall(vim.api.nvim_win_get_position, winnr)

    if not status then
      return
    end

    local sig_top = sig_win_pos[1]

    if (sig_top > current_line and cmp_top > current_line) or (sig_top < current_line and cmp_top < current_line) then
      pcall(function() vim.api.nvim_win_close(winnr, false) end)
    end

    cmp.event:off('menu_opened', callback)
  end

  cmp.event:on('menu_opened', callback)

  return bufnr, winnr
end

require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({})
  end,

  ['pyright'] = function()
    lspconfig['pyright'].setup({
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "onlyOpenFiles",
            useLibraryCodeForTypes = true,
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
vim.print()
