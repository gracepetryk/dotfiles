local M = {}
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

local function normal(cmd)
  -- print(cmd)
  vim.cmd('keepjumps silent! normal! ' .. cmd)
end

local function children_open(check_type)
  normal('zc')
  local top_of_closed_fold = vim.fn.foldclosed('.')
  local fold_end = vim.fn.foldclosedend('.')
  local parent_level = vim.fn.foldlevel('.')
  normal('zo')

  local no_early_return
  if check_type == 'all' then
    no_early_return = true
  elseif check_type == 'any' then
    no_early_return = false
  else
    check_type = 'any'
    no_early_return = false
  end

  for line = top_of_closed_fold, fold_end do
    local is_open = vim.fn.foldclosed(line) == -1
    if check_type == 'all' and not is_open then
      return false
    end

    local level = vim.fn.foldlevel(line)

    if check_type == 'any' and is_open and level > parent_level  then
      return true
    end

  end

  return no_early_return
end

M.children_open = children_open

local function get_parent_level_with_closed_childeren()
  normal('zcvovzo')
  local parent_level = vim.fn.foldlevel('.')
  while parent_level >= 0 do
    local any_closed = not children_open('all')
    if not children_open('all') then
      return parent_level
    end
    normal('[z')
    parent_level = parent_level - 1
  end
  return 0
end
M.get_parent_level_with_closed_childeren = get_parent_level_with_closed_childeren

vim.keymap.set('n', 'zM', function () set_foldlevel(math.max(vim.v.count, 1)) end)
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
  local level = vim.b.ufo_foldlevel or (max)
  local line_level = vim.fn.foldlevel('.')

  set_foldlevel(level)
  if line_level > level then
    vim.cmd[[silent! normal! zOzz]]
  end
end)
vim.keymap.set('n', 'zX', function ()
  local max = vim.b.ufo_max or get_max_foldlevel()
  local level = vim.b.ufo_foldlevel or max

  set_foldlevel(level)
end)
vim.keymap.set('n', 'zO', ':silent! normal! zozczO<CR>')
vim.keymap.set('n', 'zo', function ()
  local top_of_closed_fold = vim.fn.foldclosed('.')
  local is_closed = top_of_closed_fold ~= -1

  if is_closed then
    vim.cmd('silent! normal! zo')
    return
  end

  normal('mf')
  local next_parent = math.max(vim.b.ufo_foldlevel or 0, get_parent_level_with_closed_childeren())
  local distance = vim.fn.foldlevel('.') - next_parent
  local map = 'zc'

  for i = 1, distance do
    map = map .. 'zc'
  end

  normal(map .. 'zO`fzz')
end)
vim.keymap.set('n', 'zC', function ()
  -- close siblings and open node one level
  normal('mf')

  local top_of_closed_fold = vim.fn.foldclosed('.')
  local is_closed = top_of_closed_fold ~= -1
  local is_open = not is_closed

  if is_open then
    normal("zc")
  end

  local top_of_fold = vim.fn.foldclosed('.')
  local end_of_fold = vim.fn.foldclosedend('.')

  normal('[zzc')
  local parent_level = vim.fn.foldlevel('.')
  local top_of_parent = vim.fn.foldclosed('.')
  local end_of_parent = vim.fn.foldclosedend('.')
  normal('zo')

  vim.print({top_of_parent, top_of_fold, end_of_fold, end_of_parent, parent_level})

  normal('`fzo')

  normal(top_of_parent .. 'Gzj')
  vim.print({vim.fn.getpos('.')[2],vim.fn.foldlevel('.'), top_of_fold})
  while vim.fn.getpos('.')[2] < top_of_fold do
    vim.print({vim.fn.getpos('.')[2],vim.fn.foldclosed('.')})
    if vim.fn.foldclosed('.') == -1 then
      vim.print('closed')
      normal('zc')
    end

    normal('zj')
    vim.print({vim.fn.getpos('.')[2],vim.fn.foldlevel('.')})
  end
  normal('`f]zj')

  while vim.fn.getpos('.')[2] < end_of_parent do
    normal('j')
    if vim.fn.foldclosed('.') == -1 and vim.fn.foldlevel('.') > parent_level then
      normal('zc')
    end
  end
  normal('`fzvzz')
end)
vim.keymap.set('n', '<leader>zc', function()
  local top_of_closed_fold = vim.fn.foldclosed('.')
  local is_closed = top_of_closed_fold ~= -1

  normal('mf')
  if not is_closed then
    normal('zc')
  end

  normal('zcvov')
  local parent_level = vim.fn.foldlevel('.')
  normal('VzC`fzvzz')

  if vim.fn.foldlevel('.') > parent_level and vim.fn.foldclosed('.') == -1 then
    normal('zc')
  end
end)
vim.keymap.set('n', 'zi', ':set fen!<CR>zz')

local ft_map = {
  java = 'lsp',
  default = 'treesitter'
}

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return ft_map[filetype] or ft_map['default']
  end,
  fold_virt_text_handler=handler,
  open_fold_hl_timeout=0
})



M.get_callback = function (bufid)
  return function ()
    vim.treesitter.get_parser()
      if not vim.b[bufid].closed_folds then
        return
      end

    vim.api.nvim_buf_call(bufid, function ()
      vim.cmd.mark("c")
      for line, _ in pairs(vim.b.closed_folds) do
        local cmd = 'silent! keepjumps ' .. line .. ';foldclose'
        vim.cmd(cmd)
      end
      vim.wait(1000, function ()
        if vim.api.nvim_buf_get_mark(bufid, 'c')[1] == 0 then
          return false
        end

        vim.cmd[[normal! `czz]]

        return true
      end, 50)
    end)

  end
end

return M
