local function pending_buffers()
  for _, buf in pairs(vim.fn.getbufinfo()) do
    if buf['changed'] == 1 then
      return '%#lualine_b_diff_modified_normal#+'
    end
  end

  return ''
end

require('lualine').setup({

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
    }
  }
})
