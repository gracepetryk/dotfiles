vim.g.mapleader = ' '
vim.g.maplocalleader = '~'

vim.g.loaded_ruby_provider = 0

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
