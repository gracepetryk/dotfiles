if not vim.o.modifiable then
  -- lsp floating windows
  vim.fn.matchadd('Conceal', '\\')
  vim.fn.matchadd('Conceal', '&nbsp;', 99, -1, {conceal = ' '})
  vim.api.nvim_set_hl(0, '@string.escape', {})
  vim.o.linebreak = true
  vim.o.breakat=' '
end

