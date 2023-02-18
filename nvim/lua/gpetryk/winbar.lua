function vim.g.hlwinbar()
  local hl = nil
  if (vim.api.nvim_get_current_win() == vim.g.statusline_winid) then
    hl = "%#StatusLine#"
  else
    hl = "%#StatusLineNC#"
  end

  return hl .. "%f"
end

local function update_win_count(opts)
  if opts.event == 'VimEnter' then
    return
  end

  if opts.event == 'WinClosed' then
    local win = vim.api.nvim_win_get_config(tonumber(opts.match))
    if (win.relative == '') then
      -- dont count floating windows
      vim.g.win_count = vim.g.win_count - 1
    end
  elseif (opts.event == 'WinNew') then
    -- WinNew does not populate window number anywhere but also doesn't
    -- get called for floating windows for whatever reason so ¯\_(ツ)_/¯
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
      vim.opt.winbar = '%!luaeval("vim.g.hlwinbar()")'
    end
  end
})
