local nvim_treesitter = require('nvim-treesitter')

local STABLE = 1;
local UNSTABLE = 2;
local langs = vim.tbl_extend(
  'keep',
  nvim_treesitter.get_available(STABLE),
  nvim_treesitter.get_available(UNSTABLE)
)

local exclude_langs = {'jinja', 'jinja_inline', 'TelescopePrompt', 'dap-view', 'dap-repl', 'csv'}
local exclude_indent = {'javascript'}

langs = vim.tbl_filter(function (entry)
  return not vim.tbl_contains(exclude_langs, entry)
end, langs)

local start_ts = function (opts)
  vim.treesitter.start()

  opts = opts or {}
  local indent = opts.indent

  if indent and not vim.tbl_isempty(vim.api.nvim_get_runtime_file('queries/' .. vim.bo.filetype .. '/indents.scm', true)) then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function()
    local ft = vim.bo.filetype
    local installed = nvim_treesitter.get_installed()

    if not vim.tbl_contains(installed, ft) then
      nvim_treesitter.install(ft):await(start_ts);
    else
      start_ts({indent=not vim.tbl_contains(exclude_indent, ft)})
    end
  end,
})
