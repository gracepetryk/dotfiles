local M = {}

M.motion_select = function (command, flags, motion)
  vim.print(motion)
  local start_mark = vim.api.nvim_buf_get_mark(0, "[")
  local end_mark = vim.api.nvim_buf_get_mark(0, "]")

  local visual_key = ''

  if motion == 'char' then
    visual_key = 'v'
  elseif motion == 'line' then
    visual_key = 'V'
  elseif motion == 'block' then
    visual_key = '<C-v>'
  end

  visual_key = vim.api.nvim_replace_termcodes(visual_key, false, false, false)

  vim.api.nvim_win_set_cursor(0, start_mark)
  vim.api.nvim_feedkeys(visual_key, 'nx', true)
  vim.api.nvim_win_set_cursor(0, end_mark)

  vim.api.nvim_feedkeys(command, flags, false)
end

M.restore_on_leave_insert_autocmd = function ()
  vim.api.nvim_create_autocmd('InsertLeavePre', {
    once = true,
    callback =  function()
      vim.fn.setreg('', vim.fn.getreg('0'))
    end
  })
end

M.delete_restore_unnamed = function (motion)
  M.motion_select('d', 'nx', motion)
  vim.fn.setreg('', vim.fn.getreg('0'))
end

M.change_restore_unnamed =  function (motion)
  M.motion_select('c', 'n', motion)
  M.restore_on_leave_insert_autocmd()
end

if _G.gpetryk == nil then
  _G.gpetryk = {}
end



return M
