<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# .nvim

## Purpose
Personal Neovim configuration, written almost entirely in Lua. `init.lua` at
the repo root is the entrypoint: when `vim.g.vscode` is set it loads the
minimal `lua/code/` profile for VSCode-Neovim and stops; otherwise it sets
`mapleader` (Space) / `maplocalleader` (Backspace), starts an RPC server
fallback for broken `$XDG_RUNTIME_DIR` environments, bootstraps
[lazy.nvim](https://github.com/folke/lazy.nvim), then runs
`require("config.lazy")` and `require("config")`. LSP servers are wired
through native `vim.lsp.config()` / `vim.lsp.enable()` — not
`lspconfig.setup()`.

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Entrypoint: VSCode branch, leader keys, RPC server fallback, lazy.nvim bootstrap |
| `filetype.lua` | Custom `vim.filetype.add()` overrides for extensions, filenames, and patterns |
| `CLAUDE.md` | Claude Code guidance (structure overview and key conventions) |
| `README.md` | One-line repo description |
| `.stylua.toml` | StyLua formatter profile (2-space indent) |
| `.gitignore` / `.gitleaksignore` | VCS and secret-scan exclusions |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `lua/` | All Lua modules: core config, plugin specs, LSP servers, helpers (see `lua/AGENTS.md`) |
| `after/` | Late-loaded per-filetype settings, Tree-sitter query overrides, syntax tweaks (see `after/AGENTS.md`) |
| `ftdetect/` | Filetype detection scripts (see `ftdetect/AGENTS.md`) |
| `ftplugin/` | Per-filetype settings loaded before plugins' own (see `ftplugin/AGENTS.md`) |
| `queries/` | Tree-sitter queries for languages without bundled queries (see `queries/AGENTS.md`) |
| `syntax/` | Legacy Vim syntax files, incl. generated `kitty.vim` (see `syntax/AGENTS.md`) |
| `indent/` | Indent scripts (see `indent/AGENTS.md`) |
| `colors/` | Colorschemes (see `colors/AGENTS.md`) |
| `path/` | Framework header paths (see `path/AGENTS.md`) |
| `script/` | Generator scripts (see `script/AGENTS.md`) |
| `tests/` | Headless regression specs (see `tests/AGENTS.md`) |
| `docs/` | Notes and references (see `docs/AGENTS.md`) |
| `.claude/skills/` | Repo-local Claude Code skills: `add-lsp`, `add-plugin` |

## For AI Agents

### Working In This Directory
- Match module names to paths (`require("plugins.telescope")`,
  `require("lsp.gopls")`); filenames are snake_case.
- Resolve binaries via `lua/util/init.lua` helpers (`util.homebrew_binary()`,
  `util.prefix()`, `util.bun_prefix()`, `util.go_path()`) — never hard-code
  command names. `util.prefix()` returns `/opt/local` on arm64 macOS;
  `util.homebrew_prefix()` returns the actual Homebrew prefix.
- Plugin specs default to `lazy = true` with the narrowest trigger
  (`ft`, `cmd`, `keys`, `event`).
- LSP keymaps are set globally in `lua/lsp/init.lua`, not per-server.
- Use LuaJIT-compatible Lua with 2-space indentation (`.stylua.toml`).

### Testing Requirements
- `nvim` starts the full configuration locally.
- `nvim --headless "+Lazy! sync" +qa` bootstraps or updates plugins.
- `nvim --headless -u NONE -l tests/<name>_spec.lua` runs a regression spec
  (see `tests/AGENTS.md` for the list).
- `nvim --clean --headless -l <file>` with `loadfile()` asserts is the quick
  syntax check for edited Lua modules.
- `python3 script/gen-kitty-syntax.py` regenerates `syntax/kitty.vim`.

### Common Patterns
- Plugin config lives in `lua/plugins/<name>.lua`, loaded from the spec in
  `lua/plugins/init.lua`.
- Each LSP server file in `lua/lsp/` returns a `vim.lsp.Config` table consumed
  by `lua/lsp/init.lua`; custom servers use `register_lsp()`.
- Headless specs extend `runtimepath`, update `package.path`, require the
  target module, and use plain Lua assertions with clear failure messages.

## Dependencies

### Internal
All runtime directories are consumed directly by Neovim's runtimepath; `lua/`
modules cross-reference via `require`.

### External
- Neovim nightly (0.13-dev) — native `vim.lsp.config` API is required
- lazy.nvim — plugin manager, bootstrapped by `init.lua`
- StyLua — formatting
- macOS toolchains under `/opt/local` (MacPorts-style prefix) and Homebrew

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->

## Commit & Pull Request Guidelines
Recent commits use short, scope-first subjects such as `lsp: fix lua_ls cmd
path` and `lua/plugins: disable cmp.setup.cmdline`. Keep subjects imperative
and within 72 characters. Pull requests should explain the affected
plugin/server/filetype, list the exact `nvim --headless` checks you ran, and
include screenshots or terminal captures for visible UI changes. Link related
issues when applicable.
