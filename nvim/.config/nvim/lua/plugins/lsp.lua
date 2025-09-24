require('mason').setup()

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
    vim.keymap.set('n', '<leader>i', function ()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end)
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


    ---@param diagnostic vim.Diagnostic
    local function fmt_vtext(diagnostic)
      local second_newline, _ = diagnostic.message:find('\n.*\n', 1, false)
      return string.format('%s: %s',
        diagnostic.code,
        diagnostic.message:sub(1, second_newline or -1)
      )
    end

    ---@type integer?
    local winid

    local function open_diag_float()
      vim.api.nvim_exec_autocmds("CursorMoved", {pattern = '*'})
      _, winid = vim.diagnostic.open_float()
      vim.api.nvim_set_option_value('linebreak', true, {scope='local', win=winid})
    end


    local function close_diagnostics()
        vim.diagnostic.config({virtual_lines = false})
        if winid and vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, false)
        end
    end

    local function open_current_line_vtext()
        if winid and vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, false)
        end
        vim.diagnostic.config({virtual_lines = {format = fmt_vtext, current_line = true}})
    end

    local function open_all_vtext()
        if winid and vim.api.nvim_win_is_valid(winid) then
          vim.api.nvim_win_close(winid, false)
        end
        vim.diagnostic.config({virtual_lines = {format = fmt_vtext, current_line = false}})
    end

    vim.keymap.set('n', '<C-e>', open_diag_float)

    --- weird state machine thing to manage diagnostic floating text hiding + the
    --- diagnostic floating window
    require('gpetryk.map').cycle('n', '<leader>e', {
      close_diagnostics,
      open_current_line_vtext,
      open_diag_float
    })

    require('gpetryk.map').cycle('n', '<leader>E', {
      close_diagnostics,
      open_all_vtext,
    })

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
          [vim.diagnostic.severity.INFO] = 'DiagnosticVirtualTextInfo',
        }
      },
      underline = {
        severity = {
          min = vim.diagnostic.severity.HINT
        }
      },
      -- virtual_text = true,
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
vim.lsp.config('volar', {
  init_options = {
    typescript = {
      tsdk = ts_path
    }
  }
})

-- if vim.fn.executable('eslint') == 1 then
--   vim.lsp.config('efm', {
--     filetypes = { 'javascript', 'typescript' },
--     root_markers = { 'package.json' },
--     settings = {
--       rootMarkers={"package.json"},
--       languages = {
--         javascript = {
--           vim.tbl_extend('keep', {
--             lintCommand='eslint --no-color --format stylish --stdin-filename "${INPUT}" --stdin',
--           }, require('efmls-configs.linters.eslint'))
--         }
--       }
--     }
--   })
-- 
--   vim.lsp.enable('efm')
-- end

vim.lsp.config('emmet_ls', {
  filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "xml" }
})

vim.lsp.config('html', {
  filetypes = { 'html', 'htmldjango' }
})
