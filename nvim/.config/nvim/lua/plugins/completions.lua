local cmp = require('cmp')
local cmp_comparators = require('cmp.config.compare')


require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/dotfiles/nvim/snippets" })

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  ---@diagnostic disable-next-line: missing-fields
  completion = {
    completeopt = 'menu,menuone,preview,noselect'
  },

  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end,
  mapping = cmp.mapping.preset.insert({
    ['<C-s>'] = function(fallback)
      local save_spell = vim.opt.spell:get()
      vim.opt_local.spell = true

      cmp.complete({
        config = {
          mapping = {
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          },
          sources = {
            {
              name = 'spell',
              option = {
                keep_all_entries = true,
                enable_in_context = function()
                  return true
                end,
              },
            },
          }
        }
      })

      local function complete_callback(...)
        vim.opt_local.spell = save_spell
        cmp.event:off('complete_done', complete_callback)
      end

      cmp.event:on('complete_done', complete_callback)
    end,
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
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

---@diagnostic disable-next-line: missing-fields
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

vim.keymap.set('i', '<C-Space>', cmp.complete)