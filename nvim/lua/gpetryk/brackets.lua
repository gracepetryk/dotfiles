local M = {}

local pairs = {
  ['('] = ')',
  ['{'] = '}',
  ['['] = ']',
  ['<'] = '>',
}

local opening_chars = {
  ['('] = true,
  ['{'] = true,
  ['['] = true,
  ['<'] = true,
}


local closing_chars = {
  [')'] = true,
  ['}'] = true,
  [']'] = true,
  ['>'] = true,
}


-- should probably be using regex for this...
local separators = {
  [' '] = true,
  ['\n'] = true,
  ['\t'] = true,
  ['.'] = true,
  [','] = true,
  ['='] = true,
}

local quotes = {
  ['"'] = true,
  ["'"] = true,
}

local function is_word_like(check_char)
  return not (check_char == nil
      or pairs[check_char] ~= nil
      or closing_chars[check_char] ~= nil
      or separators[check_char] ~= nil
      )
end

local function get_cursor_pos()
  -- returns 1-indexed lines, 0-indexed columns
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1]
  local col = cursor_pos[2]

  return line, col
end

local function get_cursor_chars()
  local line, col = get_cursor_pos()


  local prev_char = nil
  if (col ~= 0) then
    prev_char = vim.api.nvim_buf_get_text(0, line - 1, col - 1, line - 1, col, {})[1]
  end

  local next_char = vim.api.nvim_buf_get_text(0, line - 1, col, line - 1, col + 1, {})[1]
  if next_char == '' then
    next_char = nil
  end

  return prev_char, next_char
end

function M.insert_closing(closing_char)
  local line, col = get_cursor_pos()
  local _, next_char = get_cursor_chars()

  if next_char == closing_char then
    -- skip over already existing closing char
    vim.api.nvim_win_set_cursor(0, { line, col + 1 })
    return
  end

  -- insert the closing char
  vim.api.nvim_paste(closing_char, false, -1)
end

function M.insert_pair(opening_char)
  local line, col = get_cursor_pos()
  local _, next_char = get_cursor_chars()

  -- insert opening char
  vim.api.nvim_paste(opening_char, false, -1)
  vim.api.nvim_win_set_cursor(0, { line, col + 1 })

  if opening_chars[next_char] ~= nil or is_word_like(next_char) then
    -- don't match in the middle of words or before an opening character
    return
  end

  vim.api.nvim_paste(pairs[opening_char], false, -1)
  vim.api.nvim_win_set_cursor(0, { line, col + 1 })
end

function M.insert_quote(quote_char)
  local line, col = get_cursor_pos()
  local prev_char, next_char = get_cursor_chars()


  if next_char == quote_char then
    -- next character is a quote, step over and return
    vim.api.nvim_win_set_cursor(0, { line, col + 1 })
    return
  end

  vim.api.nvim_paste(quote_char, false, -1)

  if not is_word_like(prev_char) and not opening_chars[next_char] then
    vim.api.nvim_paste(quote_char, false, -1)

    if prev_char == quote_char and next_char == nil then
      -- python docstrings
      vim.api.nvim_paste(quote_char .. quote_char, false, -1)
    end
  end

  vim.api.nvim_win_set_cursor(0, { line, col + 1 })
end

local function insert_pair_newline()
  local prev_char, next_char = get_cursor_chars()

  if prev_char ~= nil and next_char ~= nil and pairs[prev_char] == next_char then
    return '<CR><ESC>O'
  end

  return '<CR>'
end

local function delete_pair()
  local prev_char, next_char = get_cursor_chars()

  if prev_char == next_char and quotes[prev_char] == true then
    return '<Right><BS><BS>'
  end

  if next_char ~= nil and prev_char ~= nil and pairs[prev_char] == next_char then
    return '<Right><BS><BS>'
  end

  return '<BS>'
end

-- map doesn't like it when you use expr with included functions for some reason
-- so we set those mappings here instead of keymaps.lua
local map = require('gpetryk.map').map
map('i', '<BS>', delete_pair, { expr = true })
map('i', '<CR>', insert_pair_newline, { expr = true })

return M
