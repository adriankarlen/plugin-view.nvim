---@private
---@class plugin-view.config
local M = {}

---@class plugin-view.options
M.options = {
  border = "single", -- See `:h nvim_open_win` for more details
  width = 0.3, -- Width of the window (0 < width <= 1)
  height = 0.3, -- Height of the window (0 < height <= 1)
  title = "Plugins"
}

---@param opts plugin-view.options
function M.extend_options(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
