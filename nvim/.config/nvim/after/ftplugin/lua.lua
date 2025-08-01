local lazydev = require('lazydev')
vim.opt.formatoptions = 'cqjl'

vim.lsp.config('lua_ls', {
    root_dir = function(bufnr, on_dir)
        -- attach to existing workspace if possible
        local ws = lazydev.find_workspace(bufnr)
        if ws ~= nil then
            return on_dir(ws)
        end

        -- fallback to default (luarc, git, …)
        return on_dir(nil)
    end
})

vim.lsp.enable('lua_ls')
