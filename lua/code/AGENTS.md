<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/code

## Purpose
Standalone, minimal configuration tree loaded only when running inside
VSCode-Neovim (`vim.g.vscode` is truthy). The repo root `init.lua` branches
on `vim.g.vscode` before anything else: `if vim.g.vscode then
require("code"); return end`. This tree deliberately does not reuse
`lua/config/` or `lua/plugins/` — it re-implements its own tiny
`lazy.nvim` bootstrap, its own lazy config, and a near-empty plugin spec
list, appropriate for VSCode's embedded Neovim where most editor-level
settings (statusline, LSP UI, etc.) are irrelevant or handled by the VSCode
extension itself.

## Key Files
| File | Description |
|------|--------------|
| `init.lua` | Entry point: LuaJIT tuning (`jit.opt.start(...)`), lazy.nvim bootstrap clone into `stdpath("data")/vscode/lazy/lazy.nvim` (exit 1 when the clone fails; `getchar()` only with a UI), sets leader keys, requires `code.config.lazy`, `code.plugins`, `code.config` |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `config/` | VSCode-path `lazy.nvim` bootstrap config + minimal keymaps — documented here, no separate AGENTS.md |
| `plugins/` | VSCode-path plugin spec (single plugin) — documented here, no separate AGENTS.md |

### `config/`
| File | Description |
|------|--------------|
| `init.lua` | Two keymaps only: swaps `@`/`^` in normal mode (`vim.keymap.set`) |
| `lazy.lua` | `lazy.nvim` `LazyConfig` scoped to a `vscode` subdirectory of the cache/data/state dirs (plugin root `stdpath("data")/vscode/lazy`); `require("lazy").setup(require("code.plugins"), lazy_config)` |

### `plugins/`
| File | Description |
|------|--------------|
| `init.lua` | `LazySpec` with a single entry: `rainbowhxch/accelerated-jk.nvim`, `lazy = false`, configured + bound to `j`/`k` in its own `config` function |

## For AI Agents

### Working In This Directory
- `code/init.lua` runs **before** `lua/config`/`lua/plugins` would ever be
  reached — it is a fully separate bootstrap, not a thin wrapper around the
  main config. Do not assume anything from `lua/config/*` or `lua/plugins/*`
  is available here; if a setting is needed under VSCode-Neovim too, it must
  be duplicated rather than `require`d cross-tree. This tree requires
  nothing outside itself except lazy.nvim and its one plugin — not even
  `lua/util` — so factoring into `lua/util` would be its first shared
  dependency.
- `code/init.lua` sets `vim.g.mapleader = " "` / `vim.g.maplocalleader =
  vim.keycode("<BS>")` independently of the repo-root `init.lua` — keep these two
  definitions in sync by hand if the leader keys ever change, since there is
  no shared source of truth between the two trees.
- The JIT tuning block at the top of `code/init.lua`
  (`jit.opt.start("hotloop=1", "loopunroll=1000000", ...)`) is unique to this
  entry point — the main path (repo-root `init.lua` -> `lua/config`) has no
  such block, and there is no `lua/init.lua`. Treat any change here as
  VSCode-Neovim-specific performance tuning, not a general-purpose default to
  backport. Never add `jit.off()`: it stops the whole JIT engine, and the
  `jit.on(true, true)` after the tuning only sets this chunk's per-function
  mode, so the engine stayed off for the session (`jit.status()` false).
- `code/config/lazy.lua` mirrors `lua/config/lazy.lua` closely but scopes
  `cache_dir`/`data_dir`/`state_dir` under a `vscode` subdirectory of each
  `stdpath()` root, and drops several options present in the main config
  (`concurrency`, `rocks`, `pkg`, `headless`) — when porting a `lazy.nvim`
  option from the main `lua/config/lazy.lua`, check whether it is actually
  meaningful for the embedded/VSCode host before adding it here.
- `code/plugins/init.lua` intentionally carries only the single
  `accelerated-jk.nvim` plugin (with `lazy = false`) — this is the current,
  deliberately minimal VSCode plugin surface; do not bulk-import the main
  `lua/plugins/` spec list into this file.
- Keymaps here use `vim.keymap.set`, as `lua/config/keymap.lua` does.

### Testing Requirements
No spec files exist for this tree. `--cmd 'let g:vscode=1'` enters it
headless, but a plain run clones lazy.nvim and installs any missing plugin
under `stdpath("data")/vscode`. To check the entry without that, run the repo-root
`init.lua` from an `nvim -l` probe with a scratch `XDG_DATA_HOME` (holding an
empty `nvim/vscode/lazy/lazy.nvim` dir) and `package.preload` stubs for
`code.config.lazy`, `code.plugins` and `code.config`, then read
`jit.status()` and the lazy.nvim rtp entry:
`XDG_DATA_HOME=<scratch> nvim --headless -u NONE -i NONE --cmd 'let g:vscode=1' -l <probe.lua>`.
Syntax-check individual files with
`nvim --headless -u NONE -i NONE -c "set rtp+=." -c 'luafile lua/code/config/init.lua' -c 'qa'`.

### Common Patterns
- Mirrors the shape of the root config's bootstrap (`bootstrap lazy.nvim`
  -> `set leaders` -> `require lazy config` -> `require plugins` ->
  `require config`) but at roughly 1/10th the size and with zero external
  LSP/statusline/UI plugin dependencies.

## Dependencies

### Internal
None — this tree does not `require` anything from `lua/config`, `lua/util`,
`lua/lsp`, or `lua/plugins`.

### External
`folke/lazy.nvim` (bootstrapped independently); `rainbowhxch/accelerated-jk.nvim`
(the sole managed plugin).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
