vim.opt_local.formatoptions = 'cqjlr2'

vim.opt_local.makeprg="flake8"
vim.opt_local.errorformat="%f:%l:%c: %t%n %m"

vim.lsp.config('pyright', {
  settings = {
    pyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportArgumentType = "warning",
          reportOptionalMemberAccess =  "information",
          reportOptionalSubscript = "information",
          reportAttributeAccessIssue = "information",
          reportUnnecessaryTypeIgnoreComment = "warning"
        }
      },
      pythonPath = vim.system({"which", "python"}):wait().stdout:gsub('%s+', ''),
    }
  }
})

vim.lsp.enable('pyright')
