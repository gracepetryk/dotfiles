local filters = require('nvim-tree.explorer.filters')
local enum = require('nvim-tree.enum')
local should_filter = filters.should_filter

local should_filter_as_reason = filters.should_filter_as_reason

filters.should_filter = function (self, path, fs_stat, status)
  if self.state.no_buffer and not self:buf(path, status.bufinfo) then
    return false
  end

  if self.state.git_clean and not self:git(path, status.project) then
    return false
  end

  return should_filter(self, path, fs_stat, status)
end

filters.should_filter_as_reason = function (self, path, fs_stat, status)
  if not should_filter(self, path, fs_stat, status) then
    return enum.FILTER_REASON.none
  end

  return should_filter_as_reason(self, path, fs_stat, status)
end

require('nvim-tree').setup({
  update_focused_file = {
    enable = true
  },
  renderer = {
    full_name=true,
    highlight_git = 'name',
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
    no_buffer = true,
    git_clean = true,
  }
})
