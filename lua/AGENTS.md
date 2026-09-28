<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# lua

## Purpose
Root Lua source tree for this personal Neovim configuration. Split into two
independent bootstrap paths, both entered from the repo root `init.lua`
(there is no `lua/init.lua`): the normal Neovim path (`lua/config` +
`lua/plugins`, LSP wired through `lua/lsp`) and the VSCode-Neovim path
(`lua/code`, taken when `vim.g.vscode` is set, before anything else runs).
Everything under `lua/util`, `lua/filetypes`, `lua/luasnippets`,
`lua/lualine`, and `lua/nvim-treesitter` is support code: `require`d by
other modules or by root `filetype.lua`, or found by a plugin through the
runtimepath.

## Key Files
No Lua files directly in `lua/` — every module lives under a subdirectory (see
below). The entry point that requires into this tree is the repo root
`init.lua`.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `code/` | VSCode-Neovim-only bootstrap, config, and plugin spec (see code/AGENTS.md) |
| `config/` | Core options, keymaps, autocmds and user commands, the `lazy.nvim` setup config (`lazy.lua`), the hand-rolled statusline/tabline (`chrome.lua`) with its renderer switch (`ui_mode.lua`), and the post-UIEnter warmup (`warmup.lua`) (see config/AGENTS.md) |
| `filetypes/` | Stateful custom filetype detectors consumed by root `filetype.lua` (see filetypes/AGENTS.md) |
| `lsp/` | Central LSP wiring: diagnostics, the shared capabilities and `on_attach`, the `vim.lsp.enable()` list and the global LSP keymaps; the per-server configs live in the repo-root `lsp/` (see lsp/AGENTS.md) |
| `lualine/` | Custom lualine statusline theme, live only in the `plugins` ui mode (see lualine/AGENTS.md) |
| `luasnippets/` | LuaSnip snippet definitions, one file per target filetype (see luasnippets/AGENTS.md) |
| `nvim-treesitter/` | `parsers.lua` overlay shadowing the plugin registry by rtp order (custom/forked grammars survive install.lua's reload_parsers) — documented here, no separate AGENTS.md |
| `plugins/` | `lazy.nvim` `LazySpec` plugin specs (see plugins/AGENTS.md) |
| `util/` | Shared path/prefix/XDG helper module, required by the normal path and by root `filetype.lua` (see util/AGENTS.md) |

## For AI Agents

### Working In This Directory
- Determine which bootstrap path a change belongs to before editing:
  normal Neovim uses `lua/config` + `lua/plugins` + `lua/lsp`; VSCode-Neovim
  uses only `lua/code` and does not `require` anything from those three.
  Root `filetype.lua` runs on both paths, so `lua/util` and
  `lua/filetypes` load under VSCode too; `lua/luasnippets` is loaded only
  by the normal path's LuaSnip spec.
- Module resolution follows the directory path exactly:
  `require("plugins.telescope")` -> `lua/plugins/telescope.lua`,
  `require("lsp.on_attach")` -> `lua/lsp/on_attach.lua`,
  `require("filetypes.goasm")` -> `lua/filetypes/goasm.lua`. Match this
  convention (snake_case filenames, dotted require paths) for any new
  module.
- LSP servers are registered through the runtimepath: each server is a
  repo-root `lsp/<server>.lua` returning a plain `vim.lsp.Config` table,
  which `vim.lsp.config()` resolves by name. `lua/lsp/init.lua` sets the
  shared defaults with `vim.lsp.config("*", ...)` (capabilities, and the
  `on_attach` from `lua/lsp/on_attach.lua`) and makes the single
  `vim.lsp.enable()` call. Do not call `vim.lsp.enable()` from an
  individual server file.
- Plugin specs default to `lazy = true` (set in both `lua/config/lazy.lua`
  and `lua/code/config/lazy.lua`'s `defaults`); pick the narrowest trigger
  (`ft`, `cmd`, `keys`, `event`) rather than `lazy = false` unless the
  plugin genuinely must load at startup (e.g.
  `rainbowhxch/accelerated-jk.nvim` in `lua/code/plugins/init.lua`). The
  local `dir = util.src_path(...)` plugins in `lua/plugins/init.lua` are
  lazy too: each loads on `ft`, on `cmd`, or as a dependency.
- Binary/path resolution always goes through `lua/util`
  (`util.homebrew_binary()`, `util.prefix()`, `util.homebrew_prefix()`,
  `util.bun_prefix()`, `util.go_path()`, `util.src_path()`) — never
  hardcode `/opt/homebrew`, `/usr/local`, or `/opt/local` directly in a new
  module. Remember `util.prefix()` (arm64 -> `/opt/local`) and
  `util.homebrew_prefix()` (arm64 -> `/opt/homebrew` or `$HOMEBREW_PREFIX`)
  are deliberately different helpers for different purposes.

### Testing Requirements
Headless regression specs live under the repo-root `tests/` directory
(`tests/*_spec.lua`), not inside `lua/`; `tests/AGENTS.md` lists them all.
The ones aimed at a module here include `goasm_filetype_spec.lua`
(`lua/filetypes/goasm.lua`), `parsers_overlay_loader_spec.lua`
(`lua/nvim-treesitter/parsers.lua`), `lsp_capabilities_snapshot_spec.lua`
(`lua/lsp/capabilities.lua`), `luasnippets_parse_spec.lua`
(`lua/luasnippets/`), `chrome_spec.lua` and `ui_mode_spec.lua`
(`lua/config/chrome.lua`, `lua/config/ui_mode.lua`), and
`neo_tree_compat_spec.lua`, `snacks_compat_spec.lua` and
`ts_context_commentstring_compat_spec.lua` (the `lua/plugins/*_compat.lua`
modules). Run any of them with:
`nvim --headless -u NONE -i NONE -l tests/<name>_spec.lua`
`nvim --headless "+Lazy! sync" +qa` bootstraps/updates plugins for a full
integration smoke test.

### Common Patterns
- 2-space indentation, `.stylua.toml` at the repo root
  (`syntax = "LuaJIT"`, `column_width = 120`, `quote_style =
  "AutoPreferDouble"`, `call_parentheses = "Always"`,
  `[sort_requires] enabled = true`) is the canonical formatter profile —
  run `stylua` rather than hand-matching style.
- LuaCATS `---@param`/`---@return`/`---@class` annotations are used
  throughout `lua/util` and several `lua/lsp/*.lua` files; match this when
  adding new public functions.
- Modules that wrap third-party APIs (`lua/lualine/themes/*`,
  `lua/nvim-treesitter/parsers.lua`) mirror the upstream plugin's own
  directory/module naming convention so
  `require("<plugin-namespace>.<category>.<name>")` resolves without extra
  glue code.

## Dependencies

### Internal
`util/` is the shared leaf dependency for nearly every other subdirectory.
`config/` depends on `plugins/` (via `lazy.lua`'s `lazy.setup(require("plugins"),
...)`). `filetypes/` is consumed by root `filetype.lua`. `luasnippets/` is
loaded by `plugins/luasnip.lua` (`luasnip.loaders.from_lua` with
`lazy_paths`). `lualine/` is consumed by `plugins/lualine.lua`.

### External
`folke/lazy.nvim` (plugin manager: cloned by the repo root `init.lua` into
`stdpath("data")/lazy` and by `code/init.lua` into
`stdpath("data")/vscode/lazy`, configured by `config/lazy.lua` and
`code/config/lazy.lua`); Neovim's native `vim.lsp.config()` /
`vim.lsp.enable()` LSP framework (not `lspconfig.setup()`); `stylua`
(formatter); `stevearc/conform.nvim`; `mfussenegger/nvim-lint`;
`nvim-lualine/lualine.nvim`;
`L3MON4D3/LuaSnip`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
