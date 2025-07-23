require('mason').setup()
local lspconfig = require('lspconfig')

local res, local_config = pcall(require, 'local')

if not res then
  local_config = {node_modules_path = ''}
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local telescope = require('telescope.builtin')
    local mapopts = { noremap = true, silent = true }

    vim.keymap.set('n', '<A-]>', function ()
      vim.diagnostic.jump({count=1})
    end, mapopts)

    vim.keymap.set('n', '<A-[>', function ()
      vim.diagnostic.jump({count=-1})
    end, mapopts)

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, mapopts)

    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, mapopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, mapopts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, mapopts)
    vim.keymap.set('n', 'L', vim.lsp.buf.hover, mapopts)
    vim.keymap.set({'n', 'i'}, '<C-k>', function()
      -- toggle signature help
      local focus_id = 'textDocument/signatureHelp'
      local bufnr = vim.api.nvim_get_current_buf()

      local open_winnr = nil

      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.w[win][focus_id] == bufnr then
          open_winnr = win
        end
      end

      if open_winnr then
        vim.api.nvim_win_close(open_winnr, false)
      else
        vim.lsp.buf.signature_help({border = 'rounded'})
      end
    end, mapopts)


    vim.diagnostic.config({
      underline = {
        severity = {
          min = vim.diagnostic.severity.WARN
        }
      },
      severity_sort = true,
      float = {
        format = function (diagnostic)
          return string.format('%s [%s]', diagnostic.message, diagnostic.code)
        end
      }
    })
  end
})

-- If you are using mason.nvim, you can get the ts_plugin_path like this
local mason_registry = require('mason-registry')
local vue_language_server_path = vim.fn.expand('$MASON/packages/vue-language-server') .. '/node_modules/@vue/language-server'
local ts_path = vim.fn.expand('$MASON/packages/vue-language-server') .. '/node_modules/typescript/lib'


-- No need to set `hybridMode` to `true` as it's the default value
lspconfig.volar.setup {
  init_options = {
    typescript = {
      tsdk = ts_path
    }
  }
}

lspconfig.eslint.setup({})

lspconfig['emmet_ls'].setup({
  filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "xml" }
})

lspconfig['html'].setup({
  filetypes = { 'html', 'htmldjango' }
})

vim.lsp.enable('jsonls')
