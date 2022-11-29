-- empty setup using defaults
require("nvim-tree").setup()

local map = require("gpetryk.map").map

map("n", "<C-b>", ":NvimTreeFindFileToggle<CR>")

