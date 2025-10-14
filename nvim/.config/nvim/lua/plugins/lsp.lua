require('mason').setup()

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev) --- @diagnostic disable-line
    local mapopts = { noremap = true, silent = true }
    local underline_config = {
        severity = {
          min = vim.diagnostic.severity.WARN
        }
    }

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

    vim.keymap.set('n', '<leader>u', function ()
      if not vim.diagnostic.config().underline then
        vim.diagnostic.config({underline = underline_config})
      else
        vim.diagnostic.config({underline = false})
      end
    end)


    -- ---@param diagnostic vim.Diagnostic
    -- local function fmt_vtext(diagnostic)
    -- end

    -- Split a string into multiple lines, each no longer than max_width
    -- The split will only occur on spaces to preserve readability
    -- @param str string
    -- @param max_width integer
    local function split_line(str, max_width)
      if #str <= max_width then
        return { str }
      end

      local lines = {}
      local current_line = ''

      for word in string.gmatch(str, '%S+') do
        -- If adding this word would exceed max_width
        if #current_line + #word + 1 > max_width then
          -- Add the current line to our results
          table.insert(lines, current_line)
          current_line = word
        else
          -- Add word to the current line with a space if needed
          if current_line ~= '' then
            current_line = current_line .. ' ' .. word
          else
            current_line = word
          end
        end
      end

      -- Don't forget the last line
      if current_line ~= '' then
        table.insert(lines, current_line)
      end

      return lines
    end

    ---@param diagnostic vim.Diagnostic
    local function virtual_lines_format(diagnostic)
      -- Only render hints on the current line
      -- Note this MUST be paired with an autocmd that hides/shows diagnostics to force a re-render
      if diagnostic.severity == vim.diagnostic.severity.HINT and diagnostic.lnum + 1 ~= vim.fn.line '.' then
        return nil
      end

      local win = vim.api.nvim_get_current_win()
      local sign_column_width = vim.fn.getwininfo(win)[1].textoff
      local text_area_width = vim.api.nvim_win_get_width(win) - sign_column_width
      local center_width = 5
      local left_width = 1

      local message = string.format('%s: %s', diagnostic.code, diagnostic.message)

      ---@type string[]
      local lines = {}
      for msg_line in message:gmatch '([^\n]+)' do
        local max_width = text_area_width - diagnostic.col - center_width - left_width
        vim.list_extend(lines, split_line(msg_line, max_width))
      end

      return table.concat(lines, '\n')
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
        vim.diagnostic.config({virtual_lines = {format=virtual_lines_format, current_line = true}})
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
      underline = underline_config,
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

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line duplicate-set-field
vim.lsp.buf.hover = function ()
  hover({
    max_width=100,
  })
end


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


vim.lsp.enable('terraformls')
