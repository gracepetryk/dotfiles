-- https://github.com/folke/tokyonight.nvim/issues/52#issuecomment-857759344
-- vim.api.nvim_exec([[
-- augroup MyColors
-- 	autocmd!
-- 	autocmd ColorScheme * highlight LineNr guifg=#5081c0   | highlight CursorLineNR guifg=#FFba00
-- augroup END
-- ]], false)
--
--

-- local Shade = require("nightfox.lib.shade")
-- require('nightfox').setup({
--   palettes = {
--     all = {
--       bg1 = "#1e1e1e",
--       bg0 = "#191919",
--       bg3 = "#282828",
--       sel0 = "#282828",
--     },
--     terafox = {
--       blue = Shade.new("#569fba", "#65b1cd", "#4a869c", "#9cc3d9"),
--     }
--   },
--   groups = {
--     all = {
--       VertSplit = { link = "Comment" },
--       ["@keyword.operator"] = {fg = "#65b1cd"}
--     }
--   },
--   specs = {
--     all = {
--       syntax = {
--         func = "pink.bright",
--         type = "orange.bright",
--         variable = "blue.light",
--         field = "blue.light",
--         const = "orange.bright",
--         string = "green.base",
--       }
--     }
--   }
-- })

vim.cmd [[colorscheme vscode]]
