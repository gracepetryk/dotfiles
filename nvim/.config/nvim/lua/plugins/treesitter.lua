require 'nvim-treesitter'.setup({
  ignore_install = {},
  ensure_installed = "all",
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "sql" }
  },
})
