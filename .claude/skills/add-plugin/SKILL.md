---
name: add-plugin
description: Add a new lazy.nvim plugin following this repo's patterns. Use when adding a new Neovim plugin.
---

## Adding a new plugin

Follow these steps to add a new plugin to this Neovim config.

### 1. Add the plugin spec to lua/plugins/init.lua

Add an entry to the `LazySpec` table returned by `lua/plugins/init.lua`:

```lua
{
  "<owner>/<repo>",
  lazy = true,               -- default; use appropriate triggers
  cmd = { "CommandName" },   -- and/or ft, keys, event
  dependencies = { ... },    -- if needed
  config = function()
    require("plugins.<name>")
  end,
},
```

Key conventions:
- Plugins default to `lazy = true`. Always specify lazy-loading triggers: `cmd`, `ft`, `keys`, or `event`.
- For local plugins, use `dir = util.src_path("github.com/<owner>/<repo>")` instead of a GitHub short name.
- The `config` function should `require("plugins.<name>")` to load the setup from a separate file.

### 2. Create the plugin config file

Create `lua/plugins/<name>.lua` with the plugin's `setup()` call and configuration:

```lua
local plugin = require("<plugin-module>")

plugin.setup({
  -- configuration options
})
```

- Do NOT put large config tables inline in `lua/plugins/init.lua` — always use a separate file.
- Look at existing configs (e.g., `lua/plugins/snacks.lua`, `lua/plugins/copilot.lua`) for style reference.

### 3. Add keymaps

- Plugin-specific keymaps can go in the `keys` field of the lazy spec (preferred for lazy-loading triggers).
- Or set them in the plugin config file if they depend on the plugin being loaded.
- Leader is Space, LocalLeader is Backspace.
