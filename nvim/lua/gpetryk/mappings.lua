function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', 'x', '"_x')
map('i', 'jj', '<Esc>')
map('i', ';;', '<Right>')
map('i', 'hh', '<Left>')
map('n', 'd', '"_d')
map('n', 'D', 'd')

