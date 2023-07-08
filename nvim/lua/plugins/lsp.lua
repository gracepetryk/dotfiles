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
  callback = function (ev)
    local bufopts = { noremap = true, silent = true}

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

    local function hover_state_machine(key)
      local states = {
        -- 0 indexed for sane wrapping with modulo
        [0] = { action = vim.lsp.buf.hover, reset_events = nil },
        [1] = { action = vim.lsp.buf.hover, reset_events = {"CursorMoved", "InsertEnter", "FocusLost"} }, -- enter hover
        [2] = { action = vim.cmd.close, reset_hook = {"WinEnter"}, reset_events = {"BufLeave"} } -- leave hover
      }

      local states_len = vim.tbl_count(states)

      local function prepare_state(iter)

        local next_iter = (iter + 1) % states_len
        local current_state = states[iter]

        local lsp_hover = vim.api.nvim_create_augroup('lsp_hover', {clear = true})

        local function register_reset_autocmd()
          vim.api.nvim_create_autocmd(current_state.reset_events, {
            group = lsp_hover,
            once = true,
            callback = function () vim.keymap.set('n', key, prepare_state(0)) end
          })
          vim.g.reset_events = current_state.reset_events
        end


        if current_state.reset_events ~= nil then
          -- lsp requests are async so we want to avoid setting up reset autocmds until
          -- we're ready
          if current_state.reset_hook ~= nil then
            vim.api.nvim_create_autocmd(current_state.reset_hook, {
              group = lsp_hover,
              once = true,
              callback = register_reset_autocmd
            })
          else
            register_reset_autocmd()
          end
        end

        local function execute_state()
          vim.api.nvim_clear_autocmds({group = 'lsp_hover'})
          current_state.action()

          local next_state_callback = prepare_state(next_iter)
          vim.keymap.set('n', key, next_state_callback)
        end

        return execute_state
      end

      return prepare_state(0)
    end
    vim.keymap.set('n', 'L', hover_state_machine('L'), bufopts)

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



vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'none'})

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
            useLibraryCodeForTypes = false,
            venvPath = "/Users/GPetryk/.pyenv/versions",
            venv = "development"
          }
        }
      }
    })
  end,

  -- lspconfig['solargraph'].setup({})
  ['emmet_ls'] = function()
    lspconfig['emmet_ls'].setup({
      filetypes = { "html", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby" }
    })
  end,

  ['html'] = function()
    lspconfig['html'].setup({
      filetypes = {'html', 'htmldjango'}
    })
  end,
})
