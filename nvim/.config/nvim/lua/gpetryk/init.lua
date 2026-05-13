require("gpetryk.set")
require("gpetryk.abbrev")

require("lazy").setup({
  spec = {
    { import = "gpetryk.lazy" },
    { import = "specs" },
  },
  dev = {
    path = "~/dotfiles/nvim/plugins",
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
})

require("gpetryk.keymaps")
require("gpetryk.autosave")
require("gpetryk.commands")
require("gpetryk.claude")

local yank_group = vim.api.nvim_create_augroup("HighlightYank", {})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})
