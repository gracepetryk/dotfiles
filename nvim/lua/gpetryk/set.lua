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

vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter', 'WinClosed'}, {
  callback = function (opts)
    local win_count = 0

    if (opts.event == 'WinClosed') then
      -- WinClosed is (sometimes???) called before window is removed from layout
      win_count = -1
    end

    for _, win_id in pairs(vim.api.nvim_list_wins()) do
      local win = vim.api.nvim_win_get_config(win_id)

      if (win.relative == '') then
        -- dont count floating windows
        win_count = win_count + 1
      end
    end

    if (win_count <= 1) then
      vim.opt.winbar = nil
    else
      vim.opt.winbar = '%!luaeval("hlwinbar()")'
    end
  end
})


vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes:2'
