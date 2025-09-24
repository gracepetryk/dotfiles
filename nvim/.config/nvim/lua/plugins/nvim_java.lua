local java = require('java')
local dap = require('dap')

java.setup({spring_boot_tools = { enable = false }})

vim.lsp.config('jdtls', {
  -- @param client vim.lsp.Client
  -- @param bufnr integer
  -- on_attach = function(client, bufnr)
  --   require('ufo').enableFold(bufnr)
  -- end,
  settings = {
    java = {
      inlayHints = {
        parameterNames = {
          enabled = "all"
        }
      }
    }
  }
})

vim.lsp.enable('jdtls')

local function setup_listener()
  dap.listeners.after['event_terminated']['gpetryk'] = function(session, body)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once=true,
      callback = function ()
        vim.keymap.set('n', 'q', ':bw<CR>', {buffer = true})
      end
    })
    java.test.view_last_report()
    dap.listeners.after['event_terminated']['gpetryk'] = nil
  end
end


vim.api.nvim_create_user_command('JavaTestRunCurrentMethod', function (_)
  setup_listener()
  java.test.run_current_method()
end, {})

vim.api.nvim_create_user_command('JavaTestRunCurrentClass', function (_)
  setup_listener()
  java.test.run_current_class()
end, {})


-- poke ufo
vim.api.nvim_create_autocmd('LspAttach', {
  once=true,
  callback= function ()
    vim.defer_fn(function ()
      local bufs = vim.fn.getbufinfo()

      for _, buf in ipairs(bufs) do
        vim.api.nvim_exec_autocmds('BufWinEnter', {buffer=buf.bufnr})
      end
    end, 2000)
  end
})
