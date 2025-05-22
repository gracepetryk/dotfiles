require("gpetryk.set")
require("gpetryk.abbrev")


require("lazy").setup("gpetryk.lazy", {
  dev = {
    path = "~/dotfiles/nvim/plugins"
  },
  change_detection = {
    enabled=true,
    notify=false
  },
  lockfile = vim.fn.stdpath('config') .. "/.lazy-lock.json"
})


require("gpetryk.keymaps")
require("gpetryk.autosave")
require("gpetryk.commands")

local yank_group = vim.api.nvim_create_augroup('HighlightYank', {})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function ()
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')

    vim.cmd('%s/\\s\\+$//e') -- trailing whitespace
    vim.fn.cursor({line, col})
  end
})

-- save folds
local fold_group = vim.api.nvim_create_augroup('SaveFolds', {})
vim.api.nvim_create_autocmd('BufWinLeave', {
  group=fold_group,
  command='silent! mkview'
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group=fold_group,
  command='silent! loadview'
})


vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern={"[^l]*"},
  callback=function ()
    vim.cmd.cwindow()
  end,
  nested=true
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  pattern={"l*"},
  callback=function ()
    vim.cmd.lwindow()
  end,
  nested=true
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback=function ()
    if (vim.opt_local.buftype:get() == 'quickfix' and vim.w.qflist_created == nil) then
      vim.w.qflist_created = 1
      vim.defer_fn(function ()
        vim.cmd.wincmd('p')
      end, 20)
    end
  end
})

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function ()
    -- create a blank window to avoid the file jumping to the right when nvim-tree
    -- finishes loading
    local new_buf = vim.api.nvim_create_buf(false, false)
    local current_win = vim.api.nvim_get_current_win()
    local new_win = vim.api.nvim_open_win(new_buf, true, {
      split = 'left',
    })

    vim.cmd.wincmd('H') -- move to far left
    vim.cmd('vert resize 30') -- set size
    vim.api.nvim_set_current_win(current_win)

    vim.defer_fn(function ()
      local nt = require('nvim-tree.api')
      nt.tree.toggle({winid = new_win, find_file = true, focus = false})
    end, 200)
  end
})
