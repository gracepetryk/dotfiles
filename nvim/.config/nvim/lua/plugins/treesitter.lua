require 'nvim-treesitter.configs'.setup({
  ignore_install = {},
  ensure_installed = "all",
  sync_install = false,

  highlight = {
    enable = true,
    disable = { "embedded_template" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
})
