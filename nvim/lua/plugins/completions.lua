local luasnip = require('luasnip')
local cmp = require('cmp')
local cmp_comparators = require('cmp.config.compare')


require("luasnip.loaders.from_vscode").lazy_load({paths = "~/dotfiles/snippets"})

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
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Esc>'] = cmp.mapping.abort(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({select = true})

        -- vim schedule to paste snippet before selecting choice
        vim.schedule(function()
          if luasnip.choice_active() then
            require('luasnip.extras.select_choice')()
          end
        end)

      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<Up>'] = nil,
    ['<Down>'] = nil,
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' }
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp_comparators.exact,
      cmp_comparators.offset,
      function (entry1, entry2)
        -- boost parameters
        entry1 = string.find(entry1.completion_item.label, "=") ~= nil
        entry2 = string.find(entry2.completion_item.label, "=") ~= nil

        if not (entry1 or entry2) then
          return nil
        end

        if entry1 and entry2 then
          return nil
        end

        return entry1

      end,
      function (entry1, entry2)
        -- deboost items prefixed with _

        entry1 = string.sub(entry1.completion_item.label, 0, 1) ~= '_'
        entry2 = string.sub(entry2.completion_item.label, 0, 1) ~= '_'

        if not (entry1 or entry2) then
          return nil
        end

        if entry1 and entry2 then
          return nil
        end

        return entry1

      end,
      cmp_comparators.score,
      cmp_comparators.order,
      cmp_comparators.scopes,
      cmp_comparators.recently_used,
      cmp_comparators.locality,
      cmp_comparators.kind,
      cmp_comparators.sort_text,
      cmp_comparators.length,
    },
  }
})

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})
