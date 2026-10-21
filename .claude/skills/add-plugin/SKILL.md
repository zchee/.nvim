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
  cmd = { "CommandName" },   -- and/or ft, keys, event
  dependencies = { ... },    -- if needed
  config = function()
    require("plugins.<name>")
  end,
},
```

Key conventions:
- Specs are lazy by default (`defaults.lazy` in `lua/config/lazy.lua`). Always give the narrowest trigger: `cmd`, `ft`, `keys`, or `event`.
- For local plugins, use `dir = util.src_path("github.com/<owner>/<repo>")` instead of a GitHub short name.
- Wire the config module in one of two ways, and keep the `require` inside a function so the module loads only when the plugin does:
  - `config = function() require("plugins.<name>") end` when the module calls `setup()` itself (most plugins).
  - `opts = function() return require("plugins.<name>") end` when the module *returns* the options table and lazy.nvim calls `setup(opts)` (e.g. conform.nvim, `lua/plugins/conform.lua`). A table-form `opts = require(...)` would load the module while the spec list is built at startup.
- A plugin that draws the statusline or tabline only runs in the `plugins` ui mode: give it `event = chrome_plugins and "VeryLazy" or nil` (the `chrome_plugins` local at the top of `lua/plugins/init.lua`, from `lua/config/ui_mode.lua`), as lualine and bufferline do, so the default `chrome` mode never loads it.

### 2. Create the plugin config file

Create `lua/plugins/<name>.lua` with the plugin's `setup()` call and configuration (or, for the `opts = function()` form, `return` the options table instead):

```lua
local plugin = require("<plugin-module>")

plugin.setup({
  -- configuration options
})
```

- Do NOT put large config tables inline in `lua/plugins/init.lua` — always use a separate file.
- Look at existing configs (e.g., `lua/plugins/snacks.lua`, `lua/plugins/copilot.lua`) for style reference.
- Add a row for the new file to the Key Files table in `lua/plugins/AGENTS.md` (`owner/repo`, what it configures, anything unusual about how it loads).

### 3. Add keymaps

- Plugin-specific keymaps can go in the `keys` field of the lazy spec (preferred for lazy-loading triggers).
- Or set them in the plugin config file if they depend on the plugin being loaded.
- Leader is Space, LocalLeader is Backspace.
