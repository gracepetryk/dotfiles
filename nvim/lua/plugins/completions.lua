local cmp = require('cmp')
local cmp_types = require('cmp.types')
local cmp_comparators = require('cmp.config.compare')


require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/dotfiles/snippets" })

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  completion = {
    completeopt = 'menu,menuone,preview'
  },

  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end,
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<Up>'] = nil,
    ['<Down>'] = nil,
  }),
  -- formatting = {
  --   format = function (entry, vim_item)
  --     vim_item.menu = entry:get_completion_item().sortText
  --     return vim_item
  --   end
  -- },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' }
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp_comparators.offset,
      cmp_comparators.exact,
      cmp_comparators.score,
      cmp_comparators.sort_text, -- lsp sorting
      cmp_comparators.recently_used,
      cmp_comparators.locality,
      cmp_comparators.kind,
      cmp_comparators.length,
      cmp_comparators.order,
    },
  }
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

vim.keymap.set('i', '<C-Space>', cmp.complete)
