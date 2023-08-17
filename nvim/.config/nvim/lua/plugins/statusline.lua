local lualine = require('lualine')

local function pending_buffers()
  for _, buf in pairs(vim.fn.getbufinfo()) do
    if buf['changed'] == 1 then
      return '󰐕'
    end
  end

  return ''
end

local function is_wide()
  return vim.api.nvim_win_get_width(0) > 80
end

lualine.setup({
  options = {
    always_divide_middle = false,
  },
  sections = {
    lualine_b = {
      'branch',
      'diff',
      pending_buffers,
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1
      },
    },
    lualine_x = {
      {
        'encoding',
        cond = is_wide
      },
      {
        'fileformat',
        cond = is_wide
      },
      {
        'filetype',
        cond = is_wide
      }
    }
  },
  inactive_sections = {
    lualine_c = {
      {
        'filename',
        path=1
      }
    }
  }
})

