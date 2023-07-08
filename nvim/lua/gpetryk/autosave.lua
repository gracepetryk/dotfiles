vim.api.nvim_create_autocmd({'InsertLeave', 'TextChanged'}, {
  command = 'silent! w'
})
