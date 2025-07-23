-- local filters = require('nvim-tree.explorer.filters')
-- local enum = require('nvim-tree.enum')
--
-- local should_filter = filters.should_filter
-- local should_filter_as_reason = filters.should_filter_as_reason
--
-- filters.should_filter = function (self, path, fs_stat, status)
--   if self.state.no_buffer and not self:buf(path, status.bufinfo) then
--     return false
--   end
--
--   if self.state.git_clean and not self:git(path, status.project) then
--     return false
--   end
--
--   return should_filter(self, path, fs_stat, status)
-- end
--
-- filters.should_filter_as_reason = function (self, path, fs_stat, status)
--   if not should_filter(self, path, fs_stat, status) then
--     return enum.FILTER_REASON.none
--   end
--
--   return should_filter_as_reason(self, path, fs_stat, status)
-- end

local nt = require('nvim-tree.api')
vim.keymap.set('n', '<leader>nt', nt.tree.open)

require('nvim-tree').setup({
  on_attach = function (bufnr)
      require('nvim-tree.keymap').default_on_attach(bufnr)


      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      vim.keymap.set('n', 'U', function ()
        nt.tree.toggle_custom_filter()
        vim.cmd('normal! w')
        nt.tree.reload()
        nt.tree.open({find_file=true})
      end, opts('Toggle Custom Filter'))

      vim.keymap.set('n', 'bc', function ()
        nt.node.buffer.delete()
        nt.tree.reload()
      end, opts("Close Buffer"))

      nt.tree.toggle_custom_filter()  -- start with filter off
  end,
  reload_on_bufenter = true,

  view = {
    width = {
      min = 40,
      max = 60,
      padding = 1
    }
  },
  actions = {
    change_dir = {
      enable = false
    }
  },
  update_focused_file = {
    enable = true
  },
  hijack_directories = {
    enable = false,
    auto_open = false
  },
  renderer = {
    full_name=true,
    highlight_git = 'name',
    group_empty=true,
    hidden_display='none',
    indent_markers = {
      enable = true
    },
    icons = {
      show = {
        folder_arrow = false,
        git = false,
      }
    }
  },
  filters = {
    git_ignored = true,
    custom = function (path)
      local filter_api = require('nvim-tree.api').filters

      return filter_api.git_clean(path) and filter_api.no_buffer(path)
    end
  }
})
