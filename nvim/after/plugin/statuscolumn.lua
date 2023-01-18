function get_lineno()
  local relno = vim.api.nvim_get_vvar('relnum')
  local lineno = vim.api.nvim_get_vvar('lnum')

  if relno == 0 then
    return lineno
  else
    return relno
  end
end

local function reltimefloat(time)
  return vim.fn.reltimefloat(time) * 1000
end

local invalidate_time = 100 -- ms
local sign_cache = {}

local git_status = {}
function draw_signs(max_signs)
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_get_vvar('lnum')

  if sign_cache[bufnr] == nil then
    sign_cache[bufnr] = {}
  end

  if sign_cache[bufnr][lnum] == nil then
    sign_cache[bufnr][lnum] = {}
  end

  if sign_cache[bufnr][lnum]['val'] ~= nil and reltimefloat(vim.fn.reltime(sign_cache[bufnr][lnum]['start'])) < invalidate_time then
    return sign_cache[bufnr][lnum]['val']
  end

  if git_status[bufnr] == nil then
    git_status[bufnr] = {}
  end

  git_status[bufnr][lnum] = nil

  local signs = vim.api.nvim_call_function('sign_getplaced', {bufnr, {group = "*", lnum=lnum}})[1]['signs']

  if (signs[1] == nil) then
    return ''
  end

  local keys = {}

  for k, _ in pairs(signs) do
    table.insert(keys, k)
  end

  table.sort(keys, function (a, b)
    return signs[a]['priority'] > signs[b]['priority'] -- higher priority first
  end)

  local mark_column = ''

  local count = 0
  for k, _ in pairs(keys) do
    local sign = signs[k]
    local sign_attrs = vim.api.nvim_call_function('sign_getdefined', {sign['name']})[1]
    local draw_sign = true

    if sign['group'] == 'gitsigns_vimfn_signs_' then
      git_status[bufnr][lnum] = sign_attrs['texthl']
      draw_sign = false
    end

    if draw_sign and count < max_signs then
      count = count + 1
      mark_column = mark_column..'%#'..sign_attrs['texthl']..'#'..sign_attrs['text']
    end
  end

  mark_column = mark_column..'%*'
  sign_cache[bufnr][lnum]['val'] = mark_column
  sign_cache[bufnr][lnum]['start'] = vim.fn.reltime()
  return mark_column
end

function hl_git_bar()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_get_vvar('lnum')

  local hl_group = git_status[bufnr][lnum]

  local bar = '┃'

  if hl_group == nil then
    return bar
  end

  bar = '%#'..hl_group..'#'..bar
  return bar
end

vim.opt.signcolumn = "no"
vim.opt.statuscolumn = "%{%luaeval('draw_signs(3)')%}%=%{luaeval('get_lineno()')}%C%{%luaeval('hl_git_bar()')%} "
