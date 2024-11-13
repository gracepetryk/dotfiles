require 'nvim-treesitter.configs'.setup({
  ignore_install = {},
  ensure_installed ={},
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    disable = { 'csv' },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "sql", "lua", "yaml" }
  },
})
