local utils = require "plugin-view.utils"

---@private
local M = {}
M.setup = function(buf, win)
  utils.add_keymap(buf, "n", "q", function()
    vim.api.nvim_win_close(win, true)
  end)
  utils.add_keymap(buf, "n", "<ESC>", function()
    vim.api.nvim_win_close(win, true)
  end)
  utils.add_keymap(buf, "n", "U", function()
    vim.pack.update()
  end)
  utils.add_keymap(buf, "n", "u", function()
    -- Get current line and extract plugin name until first space
    local current_line = vim.api.nvim_get_current_line()
    local plugin_name = current_line:match "^([^%s]+)"

    if not plugin_name then
      vim.notify("Plugin not found in current line", vim.log.levels.ERROR)
      return
    end

    vim.pack.update { plugin_name }
  end)
end

return M
