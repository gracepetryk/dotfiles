vim.g.mapleader = ' '
vim.g.maplocalleader = '~'

vim.g.loaded_ruby_provider = 0
vim.g.python3_host_prog = vim.fn.stdpath("config") .. "/.venv/bin/python"

if vim.fn.executable(vim.g.python3_host_prog) == 0 then
  local function warn(msg)
    vim.notify(msg, vim.log.levels.WARN)
  end

  local success, result_or_error = pcall(function ()
    warn("python is not available... trying to install with uv")

    vim.system({"cd", vim.fn.stdpath("config")})
    vim.system({"uv", "sync"})
    vim.system({"cd", "-"})
    warn("python ready")
  end)

  if not success then 
    local msg = "unable to set up python: "
    
    if vim.fn.executable("uv") then
      msg = msg .. "uv not available"
    else
      msg = msg .. "\n" .. result_or_error
    end

    warn(msg)
  end
end

require("gpetryk.set")

-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("gpetryk")

pcall(require, "local")
