require('noice').setup({
  commands = {
    last = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    }
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = false
      }
    }
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    lsp_doc_border = true, -- add a border to hover docs and signature help
    command_palette = false,
    cmdline_output_to_split = false
  },
  cmdline = {
    enabled = false,
    view = 'cmdline',
  },
  popupmenu = {
    enabled = false,
  },
  messages = {
    enabled = false
  },
  views = {
    mini = {
      position = {
        row = -2,
        col = "100%"
      }
    }
  },
  routes = {
    {
      filter = {
        any = {
          {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          {
            event = "msg_show",
            kind = "",
            find = "fewer lines",
          },
          {
            event = "msg_show",
            kind = "",
            find = "more lines",
          },
        }
      },
      view = "mini"
    }
  }
})
