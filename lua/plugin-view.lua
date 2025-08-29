local bindings = require "plugin-view.bindings"
local config = require "plugin-view.config"
local utils = require "plugin-view.utils"
local M = {}

M.open = function()
  local float = utils.create_floating_win()
  local plugins = vim.pack.get()
  bindings.setup(float.buf, float.win)
  utils.populate_buf(float.buf, plugins)
end

---@param opts plugin-view.options
M.setup = function(opts)
  config.extend_options(opts)
end

return M
