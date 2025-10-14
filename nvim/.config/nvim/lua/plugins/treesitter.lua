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
  opts = opts or {}

  local indent_query_path = 'queries/' .. vim.bo.filetype .. '/indents.scm'
  local indent_details = vim.api.nvim_get_runtime_file(indent_query_path, true)
  local has_indent_query = #indent_details > 0

  if opts.indent and not has_indent_query then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  vim.schedule(function () vim.treesitter.start(opts.buf) end)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function(opts)
    local ft = vim.bo.filetype
    local installed = nvim_treesitter.get_installed()

    local wrapped_start_ts = function ()
      start_ts({buf=opts.buf, indent=not vim.tbl_contains(exclude_indent, ft)})
    end

    if not vim.tbl_contains(installed, ft) then
      nvim_treesitter.install(ft):await(wrapped_start_ts);
    else
      wrapped_start_ts()
    end
  end,
})
