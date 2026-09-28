<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# lua/config

## Purpose
Core, plugin-independent editor configuration: `vim.opt` settings, global
keymaps, autocommands, user commands, the statusline/tabline renderer, the
insert-stack warmup, and the `lazy.nvim` bootstrap config itself.
Highlight-group overrides live inside `colors/equinusocio_material.lua`
since the R3.1 colorscheme port. The repo root `init.lua` bootstraps
`lazy.nvim`, then runs `require("config.lazy")` and `require("config")`;
`init.lua` in this directory is the aggregator that `require`s the other
modules in a fixed order.

## Key Files
| File | Description |
|------|--------------|
| `init.lua` | Aggregator: toggles clipboard around setup, requires nvim, ui_mode (+ `setup()`), keymap, autocmd and command synchronously, then arms `config.warmup` |
| `ui_mode.lua` | Picks the statusline/tabline renderer: `chrome` (default) or `plugins` (lualine+bufferline). Resolves `$NVIM_UI_MODE` -> `vim.g.ui_mode` -> `stdpath("state")/ui-mode` -> `chrome`; `set()` switches live and persists, `:UiMode` drives it. A switch back to the plugins only shows them again once they have run `setup()` (bufferline's is not re-entrant), asking lazy which have. Consulted by `plugins/init.lua` while lazy evaluates specs, so it requires nothing from `config.*` at load time. Spec `tests/ui_mode_spec.lua` |
| `chrome.lua` | Hand-rolled statusline + tabline standing in for lualine.nvim/bufferline.nvim (round-3 W3.2); equinusocio_material palette, gitsigns/diagnostic-fed, `%@` click handler published as `_G.Chrome_click` while it owns the tabline; `setup()` is re-enterable and `teardown()` hands the options back for `ui_mode`. Spec `tests/chrome_spec.lua` |
| `warmup.lua` | Cooperative insert-stack warmup: from UIEnter + a delay it loads the completion/snippet/pairs stack one unit per event-loop tick, and aborts when a real InsertEnter wins the race. Never runs headless (no UIEnter). Spec `tests/perf/warmup_spec.lua` |
| `lazy.lua` | `lazy.nvim` bootstrap `LazyConfig` (paths, git, ui, performance, disabled rtp plugins) + `require("lazy").setup(require("plugins"), lazy_config)` |
| `nvim.lua` | Large `vim.opt`/`vim.g` block: editor options (each assigned once), `vim.hl.priorities`, the colorscheme, legacy syntax globals for runtime/`syntax/` files; commented-out built-in plugin/provider toggles kept for reference |
| `keymap.lua` | Global keymaps across n/i/v/x/c/t modes (leaders are set in the repo root `init.lua`), per-terminal maps on TermOpen, and a `live_grep_from_project_git_root` helper |
| `autocmd.lua` | `FileType`/`BufNewFile`/`BufEnter`/`BufWinEnter`/`WinClosed`/`LspTokenUpdate`/`FocusGained`/`TermOpen` autocmds, incl. macOS header path wiring (Xcode dir from `xcode-select -p`, asked asynchronously); the auto-:nohlsearch `vim.on_key` hook (hlsearch.nvim successor; the key after `"`, f/t/F/T, r, q, m, `'`, `` ` `` or `@` is an argument, never a search). Holds no `BufWritePre` formatting: conform.nvim owns write-time formatting alone. Specs `tests/auto_hlsearch_on_key_spec.lua`, `tests/imectl_focus_guard_spec.lua`, `tests/qf_help_autocmd_spec.lua` |
| `command.lua` | User commands: `Help`, `TrimSpace`, `LuaVimInspect`, `LuaSnipEdit`, `ManV`, `TerminalV`, `LspServerInfo`, `TSInspectTree`, `DiagramToggle`, `UiMode` |

## For AI Agents

### Working In This Directory
- Load order matters: `config/init.lua` requires `config.nvim` first (so
  `vim.opt` state, e.g. clipboard, is established), then `ui_mode`,
  `keymap`, `autocmd` and `command`, all synchronously. `command` is not
  deferred: 'keywordprg' is `:Help`, which it defines, and headless runs
  never fire VeryLazy. Do not reorder without checking for implicit
  dependencies (e.g. `keymap.lua` creates the `AutocmdUser` group with
  `clear = true` before `autocmd.lua` joins it with `clear = false`).
- The repo-root `init.lua` sets `vim.g.mapleader = " "` and
  `vim.g.maplocalleader = vim.keycode("<BS>")` — the canonical place for
  leader definitions in the non-VSCode path (compare `lua/code/init.lua`,
  which sets the same values independently for the VSCode-Neovim path
  before its own lazy bootstrap). `vim.keycode` is load-bearing:
  `<LocalLeader>` expands by copying the value verbatim, so a literal
  `"<BS>"` string binds mappings to those four characters, not Backspace.
- `nvim.lua` contains a large block of commented-out `vim.g.loaded_*`
  built-in-plugin disablers and remote-provider toggles — these are
  intentionally left as reference/toggle points, not dead code to delete
  outright; if re-enabling one, verify it doesn't conflict with
  `lazy.lua`'s `performance.rtp.disabled_plugins` list, which already
  disables several of the same built-ins (netrw, matchit, matchparen,
  gzip/tar/zip family, etc.) through the rtp mechanism instead.
- `autocmd.lua` has macOS-specific path-augmentation logic
  (`path_add_macos_headers`) gated behind `vim.fn.has("mac")`, and reuses
  `util.homebrew_prefix()`/`util.prefix()` for header search paths — follow
  that pattern (never hardcode `/opt/homebrew` or `/usr/local` directly)
  when adding new platform-specific path wiring.
- Highlight overrides belong in the overrides section of
  `colors/equinusocio_material.lua` (its `ovr()` wrapper force-replaces the
  group like the former `config.highlight` module did); `vim.hl.priorities`
  tuning lives in `nvim.lua` next to the `:colorscheme` call. Any colors
  change must keep `tests/perf/hl_dump_spec.lua` green (regenerate the
  fixture with `nvim --headless -l script/hl-dump.lua
  tests/perf/fixtures/hl_baseline.txt` when the change is intentional).

### Testing Requirements
Specs: `tests/chrome_spec.lua`, `tests/ui_mode_spec.lua`,
`tests/auto_hlsearch_on_key_spec.lua`, `tests/imectl_focus_guard_spec.lua`,
`tests/qf_help_autocmd_spec.lua` (each `nvim --headless -u NONE -i NONE -l tests/<name>_spec.lua`) and
`tests/perf/warmup_spec.lua` (full-config children; see tests/AGENTS.md).
A spec that enters Insert mode must do it from a callback scheduled onto
the Insert-mode input loop (see `in_insert_mode` in chrome_spec): feedkeys
"x!" ends an `-l` script there with exit 0.
Whole-config load check: `nvim --headless -i NONE +qa` (fails loudly on any
`require("config...")` error). Single file:
`nvim --headless -u NONE -i NONE -c "set rtp+=." -c 'lua require("config.command")' -c 'qa'`.

### Common Patterns
- Autocommands are grouped under `AutocmdUser`, created in `keymap.lua`
  (`clear = true`, it loads first) and joined by `autocmd.lua`
  (`clear = false`) -- both files touch the same augroup name.
- User commands in `command.lua` follow
  `vim.api.nvim_create_user_command("Name", function(opts) ... end, { nargs
  = ..., desc = ..., complete = ... })`, with `desc` provided for
  discoverability where present.
- Large blocks of superseded VimScript/Lua are kept commented out inline as
  historical reference rather than deleted (notably in `keymap.lua`,
  `nvim.lua`, `command.lua`) — match this repo's existing convention of
  preserving prior art in comments rather than assuming it should be purged.

## Dependencies

### Internal
`lua/util` (`util.homebrew_prefix()`, `util.prefix()` in `autocmd.lua`);
`lua/plugins` (via `lazy.lua`'s `require("lazy").setup(require("plugins"),
...)`; `ui_mode.lua` and `warmup.lua` load plugins through lazy).

### External
`folke/lazy.nvim` (bootstrap target of `lazy.lua`); `rg`/ripgrep (referenced
by `grepprg` in `nvim.lua`); macOS Xcode / Command Line Tools SDK headers and
`xcode-select` (path wiring in `autocmd.lua`); `imectl` (FocusGained, when
installed under `util.prefix("bin")`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
