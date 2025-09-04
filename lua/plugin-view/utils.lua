local config = require "plugin-view.config"
---@private
---@class plugin-view.utils
local M = {}

M.create_floating_win = function()
  local buf = vim.api.nvim_create_buf(false, true)

  local function calculate_dimension(dim_option, total_cells)
    -- Add validation
    if type(dim_option) ~= "table" or not dim_option.type or not dim_option.value then
      -- Fallback to treating it as a relative value for backward compatibility
      return math.floor(total_cells * (type(dim_option) == "number" and dim_option or 0.3))
    end

    if dim_option.type == "relative" then
      return math.floor(total_cells * dim_option.value)
    else -- "cell"
      return dim_option.value
    end
  end

  local width = calculate_dimension(config.options.win.width, vim.o.columns)
  local height = calculate_dimension(config.options.win.height, vim.o.lines)
  local row = math.floor((vim.o.lines - height) / 2 - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = config.options.win.border,
    title = config.options.win.title,
    title_pos = "left",
  }
  local win = vim.api.nvim_open_win(buf, true, opts)
  return { buf = buf, win = win }
end

M.populate_buf = function(buf, plugins)
  -- Create highlight groups for plugin lines
  vim.api.nvim_set_hl(0, "PluginViewLine", { link = "NormalFloat" })
  vim.api.nvim_set_hl(0, "PluginViewHeader", { link = "WinBar" })
  vim.api.nvim_set_hl(0, "PluginViewTotal", {
    fg = vim.api.nvim_get_hl(0, { name = "NormalFloat" }).fg,
    bg = vim.api.nvim_get_hl(0, { name = "WinBar" }).bg,
    bold = true,
  })
  vim.api.nvim_set_hl(0, "PluginViewName", { link = "Directory" })
  vim.api.nvim_set_hl(0, "PluginViewVersion", { link = "DiagnosticHint" })
  vim.api.nvim_set_hl(0, "PluginViewActive", { link = "Boolean" })

  local lines = {}
  local name_width = 60
  local version_width = 10

  -- Add total plugins count
  table.insert(lines, string.format("Total: %d", #plugins))

  -- Add header with fixed width columns
  local header_name = "Name" .. string.rep(" ", name_width - 4)
  local header_version = "Version" .. string.rep(" ", version_width - 7)
  table.insert(lines, header_name .. "  " .. header_version .. "  Active")

  for _, plugin in ipairs(plugins) do
    local name = (plugin.spec.name or ""):sub(1, name_width)
    local version = (plugin.spec.version or ""):sub(1, version_width)
    local active = plugin.active and "Yes" or "No"

    -- Pad columns to fixed width
    name = name .. string.rep(" ", name_width - #name)
    version = version .. string.rep(" ", version_width - #version)

    local line = name .. "  " .. version .. "  " .. active
    table.insert(lines, line)
  end

  -- Set the lines in the buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Create a namespace for our highlights
  local ns_id = vim.api.nvim_create_namespace "plugin_view"

  -- Highlight the total line
  vim.api.nvim_buf_set_extmark(buf, ns_id, 0, 0, {
    line_hl_group = "PluginViewTotal",
    end_row = 0,
  })

  -- Add header highlights
  vim.api.nvim_buf_set_extmark(buf, ns_id, 1, 0, {
    line_hl_group = "PluginViewHeader",
    end_row = 1,
  })

  -- Add highlights for each content line (starting from line 2)
  for i = 2, #lines - 1 do
    -- Highlight the entire line with base color
    vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
      line_hl_group = "PluginViewLine",
      end_row = i,
    })

    -- Highlight just the plugin name
    vim.api.nvim_buf_set_extmark(buf, ns_id, i, 0, {
      hl_group = "PluginViewName",
      end_col = name_width,
    })

    -- Highlight just the version
    vim.api.nvim_buf_set_extmark(buf, ns_id, i, name_width, {
      hl_group = "PluginViewVersion",
      end_col = name_width + version_width,
    })

    -- Highlight the "Active" column for active plugins
    vim.api.nvim_buf_set_extmark(buf, ns_id, i, name_width + version_width, {
      hl_group = "PluginViewActive",
      end_col = name_width + version_width + 6,
    })
  end

  -- Set buffer options
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("readonly", true, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
end

M.add_keymap = function(buf, mode, key, callback)
  vim.keymap.set(mode, key, callback, { buffer = buf })
end

return M
