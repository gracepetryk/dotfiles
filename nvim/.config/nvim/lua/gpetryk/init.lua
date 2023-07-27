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
require("gpetryk.tabline")
require("gpetryk.autosave")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd('BufWritePre', {
  callback = function ()
    local line = vim.fn.line('.')
    local col = vim.fn.col('.')

    vim.cmd('%s/\\s\\+$//e') -- trailing whitespace

    -- blank lines at end of file
    --
    -- G: bottom of file
    -- o: new line in case there is no empty line at end of file
    -- V: enter visual line mode
    -- ?.: search backwards for the first non-newline character
    -- j: go down one line
    -- d: delete all selected lines
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('Go<Esc>V?.<CR>jd', true, false, true), 'nx', false)

    vim.fn.cursor({line, col})
    -- vim.cmd[[ normal! zz ]]
  end
})

vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_template = '<author> • <date> • <summary>'
vim.g.gitblame_message_when_not_committed = 'Not Committed Yet'
vim.g.gitblame_date_format = '%r'
