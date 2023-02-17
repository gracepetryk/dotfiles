local M = {}

local pairs = {
  ["'"] = "'",
  ['"'] = '"',
  ['('] = ')',
  ['{'] = '}',
  ['['] = ']',
  ['<'] = '>',
  [')'] = '(',
  ['}'] = '{',
  [']'] = '[',
  ['>'] = '<',
}

-- should probably be using regex for this...
local non_word_chars = {
  [' '] = true,
  ['\n'] = true,
  ['\t'] = true,
  ['.'] = true,
  [','] = true,
}

local function can_insert_closing(char)
  return char == nil or pairs[char] ~= nil or non_word_chars[char] ~= nil
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
  local prev_char, next_char = get_cursor_chars()

  -- insert opening char
  vim.api.nvim_paste(opening_char, false, -1)
  vim.api.nvim_win_set_cursor(0, { line, col + 1 })

  if not can_insert_closing(next_char) then
    -- don't insert closing char when there's a non-paired char next
    return false
  end

  if pairs[opening_char] == opening_char and not can_insert_closing(prev_char) then
    -- don't insert closing quote if the preceding char is not a pair char
    return
  end

  vim.api.nvim_paste(pairs[opening_char], false, -1)
  vim.api.nvim_win_set_cursor(0, { line, col + 1 })
end

function M.insert_quote(char)
  local line, col = get_cursor_pos()
  local _, next_char = get_cursor_chars()

  if next_char == char then
    -- skip over closing if already present
    vim.api.nvim_win_set_cursor(0, { line, col + 1 })
    return
  end

  M.insert_pair(char)
end

local function insert_pair_newline()
  local prev_char, next_char = get_cursor_chars()

  if pairs[prev_char] ~= next_char then
    return '<CR>'
  end

  return '<CR><ESC>O'
end

local function delete_pair()
  local prev_char, next_char = get_cursor_chars()

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
