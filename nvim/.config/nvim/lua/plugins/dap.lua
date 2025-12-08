local dap = require("dap")
local map = require("gpetryk.map").map

local local_config = require('local')

if not res then
  local_config = {dap_configurations = { python = {}}}
end

map('n', '<C-b>', function() require('dap').toggle_breakpoint() end)
map('n', '<C-S-B>', function() require('dap').toggle_breakpoint(vim.fn.input('condition: ')) end)
map('n', '<Leader>rc', function() require('dap').run_to_cursor() end)
map('n', '<Leader>d', require('dap-view').open)
map('n', '<Leader>c', require('dap-view').close)


dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = os.getenv('VIRTUAL_ENV') .. '/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      }
    })
  end
end

dap.adapters.lldb = {
  type = 'executable',
  command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
  name = 'lldb'
}

dap.configurations = vim.tbl_deep_extend('force', dap.configurations, {
  python = {
    {
      name = "Python: Local Attach (port 7890)",
      type = "python",
      request = "attach",
      connect = {
        host = "0.0.0.0",
        port = 7890,
      },
      justMyCode = false,
      logToFile = true
    },
    {
      name = "Python: Launch",
      type = "python",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      justMyCode = false
    }
  },
  rust = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},

      -- 💀
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      -- runInTerminal = false,
    },
  }
}, local_config.dap_configurations)

return {}
