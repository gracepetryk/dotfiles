local dap = require("dap")
require("dapui").setup({
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        {id = "breakpoints", size = 0.1 },
        "stacks",
        "watches",
        { id = "scopes", size = 0.4 },
      },
      size = 60, -- 60 columns
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
})

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

-- completions

require("cmp").setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})
