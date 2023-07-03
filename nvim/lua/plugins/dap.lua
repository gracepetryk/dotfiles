local dap = require("dap")
local map = require("gpetryk.map").map

-- debugger mappings

local function open_debugger()
  vim.cmd.tabnew('%')
  require('dapui').open({})
  vim.api.nvim_input('<C-o>')
end

local function close_debugger()
  require('dapui').close({})
  require('dap').terminate()
  require('dap').repl.close()
  vim.cmd.tabclose()
end

map('n', '<C-b>', function() require('dap').toggle_breakpoint() end)
map('n', '<Leader>tc', function() require('dap').run_to_cursor() end)
map('n', '<Leader><Leader>d', open_debugger)
map('n', '<Leader><Leader>c', close_debugger)

map('n', '<Leader>di', '"zyiw :lua require"dapui".eval("<C-R>z")<CR>h')
map('v', '<Leader>di', '"zy :lua require"dapui".eval("<C-R>z")<CR>h')

dap.adapters = {
  python_remote = {
    type = 'server',
    port = 5678
  },
  python_local = {
    type = 'server',
    port = 7890
  }
}

dap.configurations.python = {
  {
    name = "Python: Remote Attach (sandbox)",
    type = "python_remote",
    request = "attach",
    connect = {
      host = "0.0.0.0",
      port = 5678,
    },
    pathMappings = {
      {
        localRoot = "${workspaceFolder}",
        remoteRoot = "/var/de-sandbox/apps/edde"
      },
    },
    justMyCode = true,
    logToFile = true
  },
  {
    name = "Python: Remote Attach (local)",
    type = "python_local",
    request = "attach",
    connect = {
      host = "0.0.0.0",
      port = 7890,
    },
    justMyCode = true,
    logToFile = true
  }
}
