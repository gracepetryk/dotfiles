if not vim.o.modifiable then
  -- lsp floating windows
  vim.fn.matchadd('Conceal', '\\')
  vim.api.nvim_set_hl(0, '@string.escape', {})
  vim.o.linebreak = true
  vim.o.breakat=' '
end

