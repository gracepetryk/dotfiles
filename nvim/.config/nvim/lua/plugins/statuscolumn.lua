local builtin = require("statuscol.builtin")
local number_enabled = function()
  return vim.wo.number
end

local M = {}

local function show_foldcol(args)
  return vim.api.nvim_get_option_value("foldenable", {})
end

require("statuscol").setup({
  segments = {
    {
      text = { builtin.foldfunc, " " },
      click = "v:lua.ScFa",
      condition = { true, show_foldcol },
      hl = "FoldColumn",
    },
    {
      sign = {
        namespace = { ".*" },
        name = { ".*" },
        maxwidth = 1,
        auto = true,
      },
      condition = { number_enabled },
    },
    { text = { builtin.lnumfunc } },
    {
      sign = {
        namespace = { "gitsigns" },
        colwidth = 1,
        auto = false,
        fillchar = "│",
        fillcharhl = "LineNr",
      },
      condition = { number_enabled },
    },
  },
})
