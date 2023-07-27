vim.api.nvim_create_autocmd("FocusLost", {
  command = "silent! wa"
})
