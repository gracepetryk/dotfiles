---@class LocalConfig
---@field dap_configurations table?
local M = {}
local ok, module = pcall(require, "local.local")

if ok then
  M = module
end

return M
