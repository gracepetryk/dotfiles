vim.opt.errorbells = false

vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.updatetime = 100

vim.opt.scrolloff = 10

vim.opt.hlsearch = false
vim.opt.incsearch = true


vim.g.mapleader = " "

vim.opt.laststatus = 3

function hlwinbar()
  local hl = nil
  if (vim.api.nvim_get_current_win() == vim.g.statusline_winid) then
    hl = "%#StatusLine#"
  else
    hl = "%#StatusLineNC#"
  end

  return hl .. "%f"
end

local function update_win_count(opts)
  if opts.event == 'WinClosed' then
    local win = vim.api.nvim_win_get_config(tonumber(opts.match))
    if (win.relative == '') then
      -- dont count floating windows
      vim.g.win_count = vim.g.win_count - 1
    end
  elseif (opts.event == 'WinNew') then
    -- WinNew is not called for floating windows???
    vim.g.win_count = vim.g.win_count + 1
  end
end

vim.g.win_count = 1
vim.api.nvim_create_autocmd({'VimEnter', 'WinNew', 'WinClosed'}, {
  callback = function(opts)
    update_win_count(opts)

    if (vim.g.win_count == 1) then
      vim.opt.winbar = nil
    else
      vim.opt.winbar = '%!luaeval("hlwinbar()")'
    end
  end
})


vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes:2'
