---
name: add-lsp
description: Add a new LSP server configuration following this repo's patterns. Use when adding support for a new language server.
---

## Adding a new LSP server

Follow these steps to add a new LSP server to this Neovim config.

### 1. Create the server config file

Create `lua/lsp/<server_name>.lua` that returns a `vim.lsp.Config` table:

```lua
local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("<formula>", "<binary>") },  -- or util.prefix(), util.go_path(), etc.
  filetypes = { "<filetype>" },
  settings = {
    -- server-specific settings
  },
}
```

Key conventions:
- Always resolve binary paths via `util.homebrew_binary()`, `util.prefix()`, `util.bun_prefix()`, `util.go_path()`, or `util.pnpm_prefix()` — never use bare command names.
- Return a plain table — do NOT call `lspconfig.setup()`.
- Use `--- @class vim.lsp.Config : vim.lsp.ClientConfig` annotation.
- Add `on_attach` only if the server needs buffer-specific overrides.

### 2. Register in lua/lsp/init.lua

If the server exists in lspconfig, add it to the `servers` table:

```lua
["<server_name>"] = require("lsp.<server_name>"),
```

If the server is NOT in lspconfig, register it first with `register_lsp()` before the `servers` table:

```lua
register_lsp(
  "<server_name>",
  {
    cmd = { "<binary>" },
    filetypes = { "<filetype>" },
    root_markers = { ".git" },
    single_file_support = true,
    capabilities = default_capabilities_config(),
  }
)
```

### 3. Add filetype detection (if needed)

If the filetype isn't already detected by Neovim, add an entry in `filetype.lua` via `vim.filetype.add()`.

### 4. Add after/ftplugin (if needed)

For filetype-specific buffer settings, create `after/ftplugin/<filetype>.lua`.
