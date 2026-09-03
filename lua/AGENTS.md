<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua

## Purpose
Root Lua source tree for this personal Neovim configuration. Split into two
independent bootstrap paths — the normal Neovim path (`lua/init.lua`
-> `lua/config` + `lua/plugins`, LSP wired through `lua/lsp`) and the
VSCode-Neovim path (`lua/code`, activated when `vim.g.vscode` is set,
entered from the repo root `init.lua` before anything else runs). Everything
under `lua/util`, `lua/filetypes`, `lua/luasnippets`, `lua/lualine`, and


## Key Files
No files directly in `lua/` — every module lives under a subdirectory (see
below). The entry point that requires into this tree is the repo root
`init.lua`.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `code/` | VSCode-Neovim-only bootstrap, config, and plugin spec (see code/AGENTS.md) |
| `config/` | Core `vim.opt`/keymap/autocmd/command/highlight setup + `lazy.nvim` bootstrap config (see config/AGENTS.md) |
| `filetypes/` | Stateful custom filetype detectors consumed by root `filetype.lua` (see filetypes/AGENTS.md) |
| `lsp/` | Per-server `vim.lsp.Config` tables + central LSP orchestration (see lsp/AGENTS.md) |
| `lualine/` | Custom lualine statusline theme, live only in the `plugins` ui mode (see lualine/AGENTS.md) |
| `luasnippets/` | LuaSnip snippet definitions, one file per target filetype (see luasnippets/AGENTS.md) |
| `nvim-treesitter/` | `parsers.lua` overlay shadowing the plugin registry by rtp order (custom/forked grammars survive install.lua's reload_parsers) — documented here, no separate AGENTS.md |
| `plugins/` | `lazy.nvim` `LazySpec` plugin specs (see plugins/AGENTS.md) |
| `util/` | Shared path/prefix/XDG helper module used across the whole config (see util/AGENTS.md) |

## For AI Agents

### Working In This Directory
- Determine which bootstrap path a change belongs to before editing:
  normal Neovim uses `lua/config` + `lua/plugins` + `lua/lsp`; VSCode-Neovim
  uses only `lua/code` and does not `require` anything from those three.
  `lua/util`, `lua/filetypes`, and `lua/luasnippets` are shared/support code
  reachable from either path (though `luasnippets` and `filetypes` are only
  actually wired up by the normal-Neovim plugin/filetype config today).
- Module resolution follows the directory path exactly:
  `require("plugins.telescope")` -> `lua/plugins/telescope.lua`,
  `require("lsp.gopls")` -> `lua/lsp/gopls.lua`,
  `require("filetypes.goasm")` -> `lua/filetypes/goasm.lua`. Match this
  convention (snake_case filenames, dotted require paths) for any new
  module.
- LSP servers are registered centrally: each `lua/lsp/<server>.lua` returns
  a plain `vim.lsp.Config` table, and `lua/lsp/init.lua` is what actually
  calls `vim.lsp.config()` + `vim.lsp.enable()` for each one (plus a
  `register_lsp()` path for servers not known to `lspconfig.configs`). Do
  not call `vim.lsp.enable()` from an individual server file.
- Plugin specs default to `lazy = true` (set in both `lua/config/lazy.lua`
  and `lua/code/config/lazy.lua`'s `defaults`); pick the narrowest trigger
  (`ft`, `cmd`, `keys`, `event`) rather than `lazy = false` unless the
  plugin genuinely must load at startup (e.g.
  `rainbowhxch/accelerated-jk.nvim` in `lua/code/plugins/init.lua`, or the
  local `dir = util.src_path(...)` plugins in `lua/plugins/init.lua`).
- Binary/path resolution always goes through `lua/util`
  (`util.homebrew_binary()`, `util.prefix()`, `util.homebrew_prefix()`,
  `util.bun_prefix()`, `util.go_path()`, `util.src_path()`) — never
  hardcode `/opt/homebrew`, `/usr/local`, or `/opt/local` directly in a new
  module. Remember `util.prefix()` (arm64 -> `/opt/local`) and
  `util.homebrew_prefix()` (arm64 -> `/opt/homebrew` or `$HOMEBREW_PREFIX`)
  are deliberately different helpers for different purposes.

### Testing Requirements
Headless regression specs live under the repo-root `tests/` directory
(`tests/*_spec.lua`), not inside `lua/`. Relevant ones today:
`tests/goasm_filetype_spec.lua` (`lua/filetypes/goasm.lua`),
`tests/rust_analyzer_spec.lua` (`lua/lsp/rust_analyzer.lua`), plus
`comment_compat_spec.lua`, `illuminate_compat_spec.lua`,
`neo_tree_compat_spec.lua`, `snacks_compat_spec.lua`,
`treesitter_compat_spec.lua`, `ts_context_commentstring_compat_spec.lua`,
`copilot_config_spec.lua` covering various `lua/plugins/*_compat.lua`
modules. Run any of them with:
`nvim --headless -u NONE -l tests/<name>_spec.lua`
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
consumed by `plugins/cmp.lua` and `plugins/blink.lua`. `lualine/` is
consumed by `plugins/lualine.lua`.

### External
`folke/lazy.nvim` (plugin manager, bootstrapped by both `config/lazy.lua`
and `code/config/lazy.lua`); Neovim's native `vim.lsp.config()` /
`vim.lsp.enable()` LSP framework (not `lspconfig.setup()`); `stylua`
(formatter); `stevearc/conform.nvim`; `mfussenegger/nvim-lint`;
`nvim-lualine/lualine.nvim`;
`L3MON4D3/LuaSnip`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
