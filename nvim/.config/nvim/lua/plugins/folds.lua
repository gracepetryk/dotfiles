local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (' 󰁂 %d lines'):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, {chunkText, hlGroup})
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, {suffix, 'Folded'})
  return newVirtText
end

local ft_map = {
  python = 'treesitter',
  markdown = '',
  java = {'lsp'},
  default = 'treesitter'
}

require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return ft_map[filetype] or ft_map['default']
  end,
  fold_virt_text_handler=handler,
  open_fold_hl_timeout=0
})

-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--   callback = function (event)
--     vim.print(vim.fn.getcmdline())
--   end
-- })
