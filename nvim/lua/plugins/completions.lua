local cmp = require('cmp')
local cmp_types = require('cmp.types')
local cmp_comparators = require('cmp.config.compare')
local cmp_kinds = {
  Text = ' ',
  Method = ' ',
  Function = ' ',
  Constructor = ' ',
  Field = ' ',
  Variable = ' ',
  Class = ' ',
  Interface = ' ',
  Module = ' ',
  Property = ' ',
  Unit = ' ',
  Value = ' ',
  Enum = ' ',
  Keyword = ' ',
  Snippet = ' ',
  Color = ' ',
  File = ' ',
  Reference = ' ',
  Folder = ' ',
  EnumMember = ' ',
  Constant = ' ',
  Struct = ' ',
  Event = ' ',
  Operator = ' ',
  TypeParameter = ' ',
}

vim.g.vsnip_snippet_dir = os.getenv('HOME') .. '/dotfiles/snippets/'

---@diagnostic disable-next-line: redundant-parameter
cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
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
    ['<Esc>'] = function (fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end,
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Down>'] = function(fallback)
      if cmp.visible() then
        if cmp.core.view.custom_entries_view:is_direction_top_down() then
          cmp.select_next_item()
        else
          cmp.select_prev_item()
        end
      else
        fallback()
      end
    end,
    ['<Up>'] = function(fallback)
      if cmp.visible() then
        if cmp.core.view.custom_entries_view:is_direction_top_down() then
          cmp.select_prev_item()
        else
          cmp.select_next_item()
        end
      else
        fallback()
      end
    end,
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp'},
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = 'dap' },
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function ()
          return vim.api.nvim_list_bufs()
        end
      }
    }
  }),
  formatting = {
    fields = { "abbr", "kind", "menu"},
    format = function(entry, vim_item)
      local name_mapping = {
        ['nvim_lsp'] = 'LSP'
      }
      local source_name = name_mapping[entry.source.name] or entry.source.name
      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
      vim_item.menu = ' [' .. source_name .. ']'
      return vim_item
    end
  },
  view = {
    entries = {
      name = 'custom', selection_order = 'near_cursor'
    }
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp_comparators.exact,
      cmp_comparators.offset,
      function (entry1, entry2)
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
      cmp_comparators.score,
      cmp_comparators.order,
      -- cmp_comparators.scopes,
      cmp_comparators.recently_used,
      cmp_comparators.locality,
      cmp_comparators.kind,
      -- cmp_comparators.sort_text,
      -- cmp_comparators.length,
    },
  }
}
