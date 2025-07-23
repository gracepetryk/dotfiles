local nvim_treesitter = require('nvim-treesitter')

local STABLE = 2;
local UNSTABLE = 3;
local langs = vim.tbl_extend(
  'keep',
  nvim_treesitter.get_available(STABLE),
  nvim_treesitter.get_available(UNSTABLE)
)

local exclude_langs = {'jinja', 'jinja_inline'}

langs = vim.tbl_filter(function (entry)
  return not vim.tbl_contains(exclude_langs, entry)
end, langs)

local installed = nvim_treesitter.get_installed()

local start_ts = function ()
  vim.treesitter.start()

  if not vim.tbl_isempty(vim.api.nvim_get_runtime_file('queries/' .. vim.bo.filetype .. '/indents.scm', true)) then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function()
    local ft = vim.bo.filetype

    if not vim.tbl_contains(installed, ft) then
      nvim_treesitter.install(ft):await(start_ts);
    else
      start_ts()
    end
  end,
})
