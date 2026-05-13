vim.cmd.colorscheme("rose-pine")

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd.colorscheme("rose-pine")
  end,
})

