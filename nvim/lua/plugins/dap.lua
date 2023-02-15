local dap = require("dap")
local map = require("gpetryk.map").map

-- debugger mappings

local function open_debugger()
  require('dapui').open({})
end

local function close_debugger()
  require('dapui').close({})
  require('dap').terminate()
  require('dap').repl.close()
end

map('n', '<C-b>', function() require('dap').toggle_breakpoint() end)
map('n', '<Leader>tc', function() require('dap').run_to_cursor() end)
map('n', '<Leader><Leader>d', open_debugger)
map('n', '<Leader><Leader>c', close_debugger)

map('n', '<Leader>di', '"zyiw :lua require"dapui".eval("<C-R>z")<CR>h')
map('v', '<Leader>di', '"zy :lua require"dapui".eval("<C-R>z")<CR>h')

dap.adapters.python = {

  type = 'server',
  port = 5678
}

dap.configurations.python = {
  {
    name = "Python: Remote Attach",
    type = "python",
    request = "attach",
    connect = {
      host = "0.0.0.0",
      port = 5678,
    },
    pathMappings = {
      {
        localRoot = "${workspaceFolder}",
        remoteRoot = "."
      }
    },
    justMyCode = true,
    logToFile = true
  }
}
