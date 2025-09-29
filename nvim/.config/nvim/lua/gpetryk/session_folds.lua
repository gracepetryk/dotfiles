local M = {}


M._get_closed_folds = function(bufnr)
  local folds = {}

  vim.api.nvim_buf_call(bufnr, function ()
    for lnum = 1, vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) do
      local is_closed = vim.fn.foldclosed(lnum) == lnum
      if is_closed then
        folds[tostring(lnum)] = is_closed
      end
    end
  end)

  return folds
end

M.save_extra_data = function (_)
  local data = {closed_folds={}, foldlevel={}}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)

    local closed_folds = M._get_closed_folds(buf)
    local level = vim.b[buf].ufo_foldlevel

    if not vim.tbl_isempty(closed_folds) then
      data.closed_folds[name] = closed_folds
    end

    if level then
      data.foldlevel[name] = level
    end

  end

  return vim.fn.json_encode(data)
end

M.restore_extra_data = function (_, json)
  local data = vim.fn.json_decode(json)
  local has_folds = data.closed_folds ~= nil
  local has_level = data.foldlevel ~= nil
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(winid)
    local name = vim.api.nvim_buf_get_name(buf)

    if has_level then
      vim.b[buf].ufo_foldlevel = data.foldlevel[name]
    end

    if has_folds then
      vim.b[buf].closed_folds = data.closed_folds[name]
    end
  end
end

return M
