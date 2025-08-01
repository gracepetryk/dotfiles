require('mason').setup()
local lspconfig = require('lspconfig')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev) --- @diagnostic disable-line
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

    ---@type integer?
    local winid
    vim.keymap.set('n', '<C-e>', function ()
      vim.api.nvim_exec_autocmds("CursorMoved", {pattern = '*'})
      _, winid = vim.diagnostic.open_float()
    end)

    ---@param diagnostic vim.Diagnostic
    local function fmt_vtext(diagnostic)
      local second_newline, _ = diagnostic.message:find('\n.*\n', 1, false)
      return string.format('%s: %s',
        diagnostic.code,
        diagnostic.message:sub(1, second_newline or -1)
      )
    end

    local current_line_cycle = require('gpetryk.map').cycle('n', '<leader>e', {
      function ()
        vim.diagnostic.config({virtual_lines = false})
      end,
      function ()
        if winid and vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, false)
        end
        vim.diagnostic.config({virtual_lines = {format = fmt_vtext, current_line = true}})
      end,
    })

    local last_current_line_state = current_line_cycle.get_state()
    local _ = require('gpetryk.map').cycle('n', '<leader>E', {
      function ()
        current_line_cycle.set_state(last_current_line_state)
      end,
      function ()
        if winid and vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, false)
        end
        vim.diagnostic.config({virtual_lines = {format = fmt_vtext, current_line = false}})
      end
    })

    current_line_cycle.add_hook_fn(function (state)
      last_current_line_state = state
    end)



    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.HINT] = '',
          [vim.diagnostic.severity.INFO] = '',
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = 'DiagnosticVirtualTextError',
          [vim.diagnostic.severity.WARN] = 'DiagnosticVirtualTextWarn',
          [vim.diagnostic.severity.HINT] = 'DiagnosticVirtualTextHint',
          [vim.diagnostic.severity.INFO] = 'DiagnosticVirtualTextInfo',
        }
      },
      underline = {
        severity = {
          min = vim.diagnostic.severity.WARN
        }
      },
      virtual_lines = false,
      severity_sort = true,
      float = {
        format = function (diagnostic)
          return string.format('%s [%s]', diagnostic.message, diagnostic.code)
        end
      }
    })
  end
})

local ts_path = vim.fn.expand('$MASON/packages/vue-language-server') .. '/node_modules/typescript/lib'


-- No need to set `hybridMode` to `true` as it's the default value
lspconfig.volar.setup {
  init_options = {
    typescript = {
      tsdk = ts_path
    }
  }
}

if vim.fn.executable('eslint') == 1 then
  vim.lsp.config('efm', {
    filetypes = { 'javascript', 'typescript' },
    root_markers = { 'package.json' },
    settings = {
      rootMarkers={"package.json"},
      languages = {
        javascript = {
          vim.tbl_extend('keep', {
            lintCommand='eslint --no-color --format stylish --stdin-filename "${INPUT}" --stdin',
          }, require('efmls-configs.linters.eslint'))
        }
      }
    }
  })

  vim.lsp.enable('efm')
end

lspconfig['emmet_ls'].setup({
  filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "xml" }
})

lspconfig['html'].setup({
  filetypes = { 'html', 'htmldjango' }
})

vim.lsp.enable('jsonls')
