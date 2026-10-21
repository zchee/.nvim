<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# .nvim

## Purpose
Personal Neovim configuration, written almost entirely in Lua. `init.lua` at
the repo root is the entrypoint: it enables `vim.loader`, then, when
`vim.g.vscode` is set, loads the minimal `lua/code/` profile for
VSCode-Neovim and stops; otherwise it sets `mapleader` (Space) /
`maplocalleader` (Backspace), starts an RPC server fallback for broken
`$XDG_RUNTIME_DIR` environments, bootstraps
[lazy.nvim](https://github.com/folke/lazy.nvim), then runs
`require("config.lazy")` and `require("config")`. LSP servers are wired
through native `vim.lsp.config()` / `vim.lsp.enable()` — one
`lsp/<server>.lua` per server on the runtimepath, not `lspconfig.setup()`.

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Entrypoint: `vim.loader`, VSCode branch, leader keys, RPC server fallback, lazy.nvim bootstrap |
| `filetype.lua` | Custom `vim.filetype.add()` overrides for extensions, filenames, and patterns |
| `CLAUDE.md` | Symlink to `AGENTS.md`, and the only `CLAUDE.md` in the repo: the per-directory symlinks were removed in c48ae83, so each subdirectory carries its `AGENTS.md` alone |
| `README.md` | One-line repo description |
| `.luarc.json` | lua-language-server workspace settings: LuaJIT runtime, `lua/` require paths, and the `$VIMRUNTIME`, luv, blink.cmp, lazy.nvim and snacks.nvim type libraries |
| `.stylua.toml` | StyLua formatter profile (2-space indent) |
| `.gitignore` / `.gitleaksignore` | VCS and secret-scan exclusions |
| `.github/workflows/ci.yaml` | GitHub Actions for pushes and pull requests to `main`: `stylua --check .`, and every `tests/*_spec.lua` on Neovim nightly with the plugins named in its `SPEC_PLUGINS` cloned into `stdpath("data")/lazy` |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `lua/` | All Lua modules: core config, plugin specs, LSP wiring, helpers (see `lua/AGENTS.md`) |
| `lsp/` | One `vim.lsp.Config` table per language server (`lsp/<server>.lua`), which `vim.lsp.config()` finds on the runtimepath; `lua/lsp/init.lua` enables them. No AGENTS.md of its own (see `lua/lsp/AGENTS.md`) |
| `after/` | Late-loaded per-filetype settings and Tree-sitter query extensions (see `after/AGENTS.md`) |
| `ftdetect/` | Filetype detection that has to read buffer content (see `ftdetect/AGENTS.md`) |
| `ftplugin/` | Per-filetype settings for filetypes Neovim ships no ftplugin for; they load before `$VIMRUNTIME`'s own (see `ftplugin/AGENTS.md`) |
| `queries/` | Tree-sitter queries for languages without bundled queries (see `queries/AGENTS.md`) |
| `syntax/` | Legacy Vim syntax files, incl. generated `kitty.vim` (see `syntax/AGENTS.md`) |
| `indent/` | Indent scripts (see `indent/AGENTS.md`) |
| `colors/` | The `equinusocio_material` colorscheme (see `colors/AGENTS.md`) |
| `path/` | Framework header paths (see `path/AGENTS.md`) |
| `script/` | The kitty syntax generator and the perf harnesses (see `script/AGENTS.md`) |
| `tests/` | Headless regression specs (see `tests/AGENTS.md`) |
| `docs/` | Notes and references; holds only its `AGENTS.md` at present (see `docs/AGENTS.md`) |
| `.claude/skills/` | Repo-local Claude Code skills: `add-lsp`, `add-plugin`, `nvim-search-plugin` |

## For AI Agents

### Working In This Directory
- Match module names to paths (`require("plugins.telescope")`,
  `require("lsp.on_attach")`); filenames are snake_case.
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
- `nvim --headless -u NONE -i NONE -l tests/<name>_spec.lua` runs a
  regression spec (see `tests/AGENTS.md` for the list).
- `nvim --clean --headless -l <file>` with `loadfile()` asserts is the quick
  syntax check for edited Lua modules.
- `kitty +launch script/gen-kitty-syntax.py`, run from the repo root,
  regenerates the generated tail of `syntax/kitty.vim`.

### Common Patterns
- Plugin config lives in `lua/plugins/<name>.lua`, loaded from the spec in
  `lua/plugins/init.lua`.
- Each enabled LSP server is `lsp/<server>.lua` at the repo root, returning a
  `vim.lsp.Config` table that `vim.lsp.config()` resolves from the
  runtimepath. `lua/lsp/init.lua` sets the shared defaults with
  `vim.lsp.config("*", ...)` (capabilities, plus the `on_attach` in
  `lua/lsp/on_attach.lua`) and lists every enabled server in one
  `vim.lsp.enable()` call.
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
