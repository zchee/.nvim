# Repository Guidelines

## Project Structure & Module Organization
`init.vim` is the entrypoint. It loads `lua/init.lua` for normal Neovim and
`lua/code/init.lua` when `g:vscode` is set. Core editor settings live in
`lua/config/`; plugin specs and setup live in `lua/plugins/`; LSP servers live
in `lua/lsp/` and are wired through native `vim.lsp.config()` and
`vim.lsp.enable()`. Filetype overrides live in `filetype.lua` and
`after/ftplugin/`; Tree-sitter and syntax tweaks live under `queries/`,
`after/queries/`, and `syntax/`. Keep focused regression specs in
`tests/*_spec.lua`.

## Build, Test, and Development Commands
- `nvim` starts the full configuration locally.
- `nvim --headless "+Lazy! sync" +qa` bootstraps or updates plugins through
  `lazy.nvim`.
- `nvim --headless -u NONE -l tests/illuminate_compat_spec.lua` runs the
  illuminate compatibility regression spec.
- `nvim --headless -u NONE -l tests/snacks_compat_spec.lua` runs the Snacks
  compatibility regression spec.
- `python3 script/gen-kitty-syntax.py` regenerates `syntax/kitty.vim` from
  Kitty metadata.

## Coding Style & Naming Conventions
Use LuaJIT-compatible Lua with 2-space indentation; `lua/lsp/luarc.json` is the
closest thing to a shared formatter profile. Match module names to paths, for
example `require("plugins.telescope")` or `require("lsp.gopls")`, and keep
filenames snake_case. Prefer helpers from `lua/util/init.lua` for paths and
binary resolution instead of hard-coded command names. In plugin specs, default
to lazy loading and choose the narrowest trigger (`ft`, `cmd`, `keys`,
`event`).

## Testing Guidelines
Add headless specs under `tests/*_spec.lua`. Follow the existing pattern:
extend `runtimepath`, update `package.path`, require the target module, and use
plain Lua assertions with clear failure messages. Cover behavior-changing
compatibility layers and helper modules before wiring UI-facing plugin code.

## Commit & Pull Request Guidelines
Recent commits use short, scope-first subjects such as `lsp: fix lua_ls cmd
path` and `lua/plugins: disable cmp.setup.cmdline`. Keep subjects imperative
and within 72 characters. Pull requests should explain the affected
plugin/server/filetype, list the exact `nvim --headless` checks you ran, and
include screenshots or terminal captures for visible UI changes. Link related
issues when applicable.
