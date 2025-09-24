local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d lines'):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, {chunkText, hlGroup})
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, {suffix, 'Folded'})
  return newVirtText
end

---@param exclude_closed? boolean
local function get_max_foldlevel(exclude_closed)
  if exclude_closed == nil then
    exclude_closed = true
  end

  local max_level = 0
  for lnum = 1, vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf()) do
    if exclude_closed and vim.fn.foldclosed(lnum) ~= -1 then
      goto continue
    end

    local level = vim.fn.foldlevel(lnum)
    if level > max_level then
      max_level = level
    end

    ::continue::
  end
  vim.b.ufo_max = max_level
  return max_level
end

local function set_foldlevel(level)
  vim.b.ufo_foldlevel = level
  require('ufo').closeFoldsWith(level)
end

vim.keymap.set('n', 'zM', function () set_foldlevel(0) end)
vim.keymap.set('n', 'zR', function () set_foldlevel(get_max_foldlevel(false)) end)
vim.keymap.set('n', 'zr', function ()
  local max = vim.b.ufo_max or get_max_foldlevel(true)
  local level = vim.b.ufo_foldlevel or max

  level = level + 1
  if level > max then
    max = get_max_foldlevel(false)
  end

  level = math.min(level, max)
  set_foldlevel(level)
end)
vim.keymap.set('n', 'zm', function ()
  local max = vim.b.ufo_max or get_max_foldlevel()
  local level = vim.b.ufo_foldlevel or max

  level = level - 1
  level = math.max(level, 0)
  set_foldlevel(level)
end)
vim.keymap.set('n', 'zx', function ()
  local max = vim.b.ufo_max or get_max_foldlevel()
  local level = vim.b.ufo_foldlevel or max
  local line_level = vim.fn.foldlevel('.')

  set_foldlevel(level)
  if line_level > level then
    vim.cmd[[silent! normal zO]]
  end
end)
vim.keymap.set('n', 'zX', function ()
  local max = vim.b.ufo_max or get_max_foldlevel()
  local level = vim.b.ufo_foldlevel or max

  set_foldlevel(level)
end)

local ft_map = {
  python = 'treesitter',
  markdown = '',
  java = {'lsp'},
  default = 'treesitter'
}

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return ft_map[filetype] or ft_map['default']
  end,
  fold_virt_text_handler=handler,
  open_fold_hl_timeout=0
})


require('auto-session').setup(vim.tbl_extend('force', require('auto-session.config').options, {
  save_extra_data = function (_)
    local data = {foldlevels={}}
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(winid)
      local name = vim.api.nvim_buf_get_name(buf)
      data.foldlevels[name] = vim.b[buf].ufo_foldlevel or 99
    end

    return vim.fn.json_encode(data)
  end,
}))
