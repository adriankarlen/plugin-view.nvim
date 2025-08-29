# 📦 plugin-view

A plugin to see what plugins you have installed via Neovim's built in package
manager.

## Installation

# vim.pack

```lua
vim.plug.add("https://github.com/adriankarlen/plugin-view.nvim")
require("plugin-view").setup()
```

# Usage

To open the plugin view simply call `require("plugin-view").open()`.

### Examples
```lua
-- as a keybind
vim.keymap.set("n", "<leader>p", function() require("plugin-view").open() end )

-- as a key on snacks.dashboard
keys = {
  ...
  { icon = " ", key = "p", desc = "packages", action = ":lua require('plugin-view').open()" },
  ...
},
```

# Keybindings inside window
- `q`/`close` - Close the window
- `u` - Update plugin on current line
- `U` - Update all plugins
