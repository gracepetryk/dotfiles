require("gpetryk.set")

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
