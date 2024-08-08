for name, url in pairs {
   vim_sleuth = "https://github.com/tpope/vim-sleuth"
} do
  local install_path = vim.fn.fnamemodify('nvim_issue/' .. name, ':p')
  if vim.fn.isdirectory(install_path) == 0 then
    vim.fn.system { 'git', 'clone', '--depth=1', url, install_path }
  end
  vim.opt.runtimepath:append(install_path)
end

vim.opt.scrolloff = 10
