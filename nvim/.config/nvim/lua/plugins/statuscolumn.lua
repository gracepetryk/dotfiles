local builtin = require('statuscol.builtin')
require('statuscol').setup({
  segments = {
    { text = { builtin.lnumfunc, " " } },
    { hl='SignColumn', sign = { namespace = {".*"}, name = { ".*" }, maxwidth = 1, auto = false }},
  }
})

