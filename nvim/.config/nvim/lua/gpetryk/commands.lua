vim.api.nvim_create_user_command("Remove", function(opts)
  path = opts.args[1]

  if not path then
    path = vim.fn.expand("%")
  end

  vim.fn.delete(path)
  vim.cmd.bwipeout()
  vim.print('"' .. path .. '" deleted')
end, {})
