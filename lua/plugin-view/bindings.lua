local utils = require("plugin-view.utils")

---@private
local M = {}
M.setup = function(buf, win)
  utils.add_keymap(buf, "n", "q", function()
    vim.api.nvim_win_close(win, true)
  end)
  utils.add_keymap(buf, "n", "<ESC>", function()
    vim.api.nvim_win_close(win, true)
  end)
  utils.add_keymap(buf, "n", "r", function()
    vim.api.nvim_win_close(win, true)
    require("plugin-view").open()
  end)
end


return M
