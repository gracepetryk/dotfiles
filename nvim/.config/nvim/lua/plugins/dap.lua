local dap = require("dap")
local map = require("gpetryk.map").map

-- debugger mappings

local function open_debugger()
  vim.api.nvim_tabpage_set_var(0, 'label', 'Edit')
  vim.cmd.tabnew('%')
  vim.api.nvim_tabpage_set_var(0, 'label', 'Debug')

  require('dapui').open({})
  vim.api.nvim_input('<C-o>')
end

local function close_debugger()
  require('dapui').close({})
  require('dap').terminate()
  require('dap').repl.close()

  vim.cmd.tabclose()
  vim.api.nvim_tabpage_set_var(0, 'label', '')
end

map('n', '<C-b>', function() require('dap').toggle_breakpoint() end)
map('n', '<Leader>tc', function() require('dap').run_to_cursor() end)
map('n', '<Leader><Leader>d', open_debugger)
map('n', '<Leader><Leader>c', close_debugger)

map('n', '<Leader>di', '"zyiw :lua require"dapui".eval("<C-R>z")<CR>h')
map('v', '<Leader>di', '"zy :lua require"dapui".eval("<C-R>z")<CR>h')

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
      },
    })
  end
end

dap.configurations.python = {
  {
    name = "Python: Container Attach (port 5678)",
    type = "python",
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
    name = "Python: Local Attach (port 7890)",
    type = "python",
    request = "attach",
    connect = {
      host = "0.0.0.0",
      port = 7890,
    },
    justMyCode = true,
    logToFile = true
  },
  {
    name = "Python: Launch",
    type = "python",
    request = "launch",
    program = "${file}"
  }
}
