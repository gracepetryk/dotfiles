local nvim_treesitter = require("nvim-treesitter")

local STABLE = 1
local UNSTABLE = 2
local langs = vim.list_extend(nvim_treesitter.get_available(STABLE), nvim_treesitter.get_available(UNSTABLE))

local exclude_langs = {
  "jinja",
  "jinja_inline",
  "csv",
}

local exclude_indent = { "javascript" }

langs = vim.tbl_filter(function(entry)
  return not vim.tbl_contains(exclude_langs, entry)
end, langs)

-- FileType autocmds match filetypes, which differ from parser names (e.g. typescriptreact -> tsx)
local filetypes = {}
for _, lang in ipairs(langs) do
  vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
end

local start_ts = function(opts)
  opts = opts or {}

  local indent_query_path = "queries/" .. vim.bo.filetype .. "/indents.scm"
  local indent_details = vim.api.nvim_get_runtime_file(indent_query_path, true)
  local has_indent_query = #indent_details > 0

  if opts.indent and has_indent_query then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  vim.schedule(function()
    pcall(vim.treesitter.start, opts.buf)
  end)
end
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local parser_config = require("nvim-treesitter.parsers")
    parser_config.markdown = {
      install_info = {
        url = "https://github.com/gracepetryk/tree-sitter-markdown",
        branch = "no-indented-blocks",
        -- optional entries
        location = "tree-sitter-markdown",
        generate = false,
        generate_from_json = false,
      },
    }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  callback = function(opts)
    local ft = vim.bo.filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    local installed = nvim_treesitter.get_installed()

    local wrapped_start_ts = function()
      start_ts({ buf = opts.buf, indent = not vim.tbl_contains(exclude_indent, ft) })
    end

    if not vim.tbl_contains(installed, lang) then
      nvim_treesitter.install(lang):await(wrapped_start_ts)
    else
      wrapped_start_ts()
    end
  end,
})
