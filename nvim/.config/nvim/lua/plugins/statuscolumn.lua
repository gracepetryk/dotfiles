local builtin = require('statuscol.builtin')
local number_enabled = function ()
  return vim.wo.number
end
require('statuscol').setup({
  segments = {
    {
      sign = {
        namespace = {".*"},
        name = { ".*" },
        maxwidth = 1,
        auto = false,
      },
      condition = { number_enabled }
    },
    { text = { builtin.lnumfunc, ' ' } },
    {
      sign = {
        namespace = {'gitsigns'},
        colwidth=2,
        auto=false,
      },
      condition = { number_enabled }
    },
  }
})
