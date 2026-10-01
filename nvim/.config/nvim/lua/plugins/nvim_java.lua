local java = require("java")
local dap = require("dap")
local log = require('java-core.utils.log2')

java.setup({
  spring_boot_tools = { enable = false },
  log = {
    use_console = false,
    level = 'info'
  }
})

vim.print('setup')

vim.lsp.config("jdtls", {
  -- @param client vim.lsp.Client
  -- @param bufnr integer
  -- on_attach = function(client, bufnr)
  --   require('ufo').enableFold(bufnr)
  -- end,
  root_markers = { ".git" },
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-17',
            path = '/opt/homebrew/Cellar/openjdk@17/17.0.20.1/libexec/openjdk.jdk/Contents/Home',
            default=true
          }
        }
      },
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
      format = {
        insertSpaces = true,
      },
    },
  },
})

vim.print("enabling java")
vim.lsp.enable("jdtls")

-- vim.lsp.start(vim.lsp.config.jdtls)

local function setup_listener()
  dap.listeners.after["event_terminated"]["gpetryk"] = function(session, body)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      callback = function()
        vim.keymap.set("n", "q", ":bw<CR>", { buffer = true })
      end,
    })
    session.config.classPaths = #session.config.classPaths
    -- vim.schedule_wrap(vim.print)(vim.inspect(session.config))
    java.test.view_last_report()
    log.info('would have shown report here')
    dap.listeners.after["event_terminated"]["gpetryk"] = nil
  end
end

vim.api.nvim_create_user_command("JavaTestRunCurrentMethod", function(_)
  -- setup_listener()
  java.test.run_current_method()
  log.info()
end, {})

vim.api.nvim_create_user_command("JavaTestRunCurrentClass", function(_)
  setup_listener()
  java.test.run_current_class()
end, {})

-- poke ufo
vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      local bufs = vim.fn.getbufinfo()

      for _, buf in ipairs(bufs) do
        vim.api.nvim_exec_autocmds("TextChanged", { buffer = buf.bufnr })
      end
    end, 2000)
  end,
})
