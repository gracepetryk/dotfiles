local dap = require("dap")
require("dapui").setup(
{
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
}
)

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
