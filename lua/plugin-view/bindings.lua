local utils = require "plugin-view.utils"

---@private
local M = {}

local get_plugin_name = function(line)
  return line:match "^([^%s]+)"
end

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
    local plugin_name = get_plugin_name(vim.api.nvim_get_current_line())
    if not plugin_name then
      vim.notify("Plugin not found in current line", vim.log.levels.ERROR)
      return
    end

    vim.pack.update { plugin_name }
  end)
  utils.add_keymap(buf, "n", "d", function()
    local plugin_name = get_plugin_name(vim.api.nvim_get_current_line())
    if not plugin_name then
      vim.notify("Plugin not found in current line", vim.log.levels.ERROR)
      return
    end
    vim.pack.delete { plugin_name }
  end)
end

return M
