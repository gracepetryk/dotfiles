local name = "UfoJavaStart_" .. vim.api.nvim_get_current_buf()
local lsp_augroup = vim.api.nvim_create_augroup(name, {})
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.declaration, {})
vim.api.nvim_create_autocmd("LspRequest", {
  group = lsp_augroup,
  buffer = vim.api.nvim_get_current_buf(),
  callback = function(event)
    if event.data.request.type ~= "complete" then
      return
    end

    if event.data.request.method ~= "textDocument/foldingRange" then
      return
    end

    vim.defer_fn(require("plugins.folds").get_callback(event.buf), 300)
    -- if not vim.b[event.buf].closed_folds then
    --   vim.defer_fn(function()
    --     require('ufo').closeFoldsWith(1)
    --     vim.cmd[[silent! normal! zOzz]]
    --   end, 300)
    -- end
    vim.api.nvim_del_augroup_by_id(lsp_augroup)
  end,
})
