vim.diagnostic.config({
  signs = false,
  severity_sort = true,
  virtual_text = false,
  float = {
    format = function (diagnostic)
      return string.format('%s [%s]', diagnostic.message, diagnostic.code)
    end
  }
})
