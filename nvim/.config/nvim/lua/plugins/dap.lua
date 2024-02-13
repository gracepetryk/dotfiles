local dap = require("dap")
local map = require("gpetryk.map").map

local res, local_config = pcall(function() return require('local') end)

if not res then
  local_config = {}
end

local function find_tab(label)
  for _, tab_no in pairs(vim.api.nvim_list_tabpages()) do
    local _, tab_label = pcall(vim.api.nvim_tabpage_get_var, tab_no, 'label')
    if tab_label == label then
      return tab_no
    end
  end

  return nil
end

local function open_debugger()
  local debug_tab_no = find_tab('Debug')
  local curs = vim.api.nvim_win_get_cursor(0)

  if debug_tab_no ~= nil then
    local current_buf_no = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_current_tabpage(debug_tab_no)

    -- move to code window
    vim.cmd.wincmd('l')
    vim.cmd.wincmd('k')

    vim.api.nvim_set_current_buf(current_buf_no)
    vim.cmd("normal! m'")
    vim.api.nvim_win_set_cursor(0, curs)
    return
  end

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
map('n', '<Leader>d', open_debugger)
map('n', '<Leader>c', close_debugger)

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

dap.configurations.python = vim.list_extend({
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
    program = "${file}",
    cwd = "${workspaceFolder}",
    justMyCode = false
  }
}, local_config.dap_configurations.python)
