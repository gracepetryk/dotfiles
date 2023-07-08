local cmp = require('cmp')
local cmp_comparators = require('cmp.config.compare')

vim.g.vsnip_snippet_dir = os.getenv('HOME') .. '/dotfiles/snippets/'

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end,

  preselect = cmp.PreselectMode.None,
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end,
    ['<Esc>'] = cmp.mapping.abort(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      local in_snippet = vim.fn["vsnip#available"](1) == 1
      if in_snippet then
        if cmp.visible() and cmp.get_active_entry() then
          return cmp.confirm()
        end

        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif cmp.visible() then
        cmp.confirm({select=true})
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),

    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<Up>'] = cmp.mapping(function (fallback) fallback() end),
    ['<Down>'] = cmp.mapping(function (fallback) fallback() end)
  }),
  sources = cmp.config.sources(
  {
    { name = 'nvim_lsp'},
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer'}
  }
  ),
  formatting = {
    fields = { "abbr", "kind", "menu"},
    format = function(entry, vim_item)
      local name_mapping = {
        ['nvim_lsp'] = 'LSP'
      }
      local source_name = name_mapping[entry.source.name] or entry.source.name
      vim_item.menu = ' [' .. source_name .. ']'
      return vim_item
    end
  },
  -- view = {
  --   entries = {
  --     name = 'custom', selection_order = 'near_cursor'
  --   }
  -- },
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
