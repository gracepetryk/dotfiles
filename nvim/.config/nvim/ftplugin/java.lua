local get_callback = function (bufid)
  return function ()
    local level = 1
    if level then
      vim.api.nvim_buf_call(bufid, function ()
        vim.b[bufid].ufo_foldlevel = level
        require('ufo').closeFoldsWith(level)
        vim.cmd[[silent! foldopen!]]
        vim.cmd[[normal! zz]]
      end)
    end
  end
end


local name = 'UfoJavaStart_' .. vim.api.nvim_get_current_buf()
local lsp_augroup = vim.api.nvim_create_augroup(name, {})
vim.api.nvim_create_autocmd('LspRequest', {
  group=lsp_augroup,
  buffer=vim.api.nvim_get_current_buf(),
  callback=function (event)
    if event.data.request.type ~= 'complete' then
      return
    end

    if event.data.request.method ~= 'textDocument/foldingRange' then
      return
    end

    vim.defer_fn(get_callback(event.buf), 300)
    vim.api.nvim_del_augroup_by_id(lsp_augroup)
  end
})
