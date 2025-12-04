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
  }
}, local_config.dap_configurations)

return {}
