local dap = require('dap')
local java = require('java')

local function setup_listener()
    dap.listeners.after['event_terminated']['gpetryk'] = function(session, body)
        java.test.view_last_report()
        dap.listeners.after['event_terminated']['gpetryk'] = nil
    end
end

vim.api.nvim_create_user_command('JavaTestRunCurrentMethod', function (_)
    setup_listener()
    java.test.debug_current_method()
end, {})

vim.api.nvim_create_user_command('JavaTestRunCurrentClass', function (_)
    setup_listener()
    java.test.debug_current_class()
end, {})
