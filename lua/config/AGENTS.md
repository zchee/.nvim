<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/config

## Purpose
Core, plugin-independent editor configuration: `vim.opt` settings, global
keymaps, autocommands, user commands, and the `lazy.nvim` bootstrap config
itself. Highlight-group overrides live inside
`colors/equinusocio_material.lua` since the R3.1 colorscheme port. Loaded by `lua/init.lua` (bootstraps
`lazy.nvim`, then `require("config.lazy")` and `require("config")`).
`init.lua` in this directory is the aggregator that `require`s the other
modules in a fixed order.

## Key Files
| File | Description |
|------|--------------|
| `init.lua` | Aggregator: toggles clipboard around setup, requires nvim/keymap/autocmd synchronously, command on VeryLazy |
| `lazy.lua` | `lazy.nvim` bootstrap `LazyConfig` (paths, git, ui, performance, disabled rtp plugins) + `require("lazy").setup(require("plugins"), lazy_config)` |
| `nvim.lua` | Large `vim.opt`/`vim.g` block: editor options, disabled built-in providers/plugins (mostly commented out) |
| `keymap.lua` (372 lines) | `mapleader`/`maplocalleader` + global keymaps across n/i/v/x/c/t modes, plus a `live_grep_from_project_git_root` helper |
| `autocmd.lua` (607 lines) | `FileType`/`BufNewFile`/`BufEnter`/`BufWinEnter`/`LspTokenUpdate`/`User` autocmds, incl. macOS SDK/header path wiring; auto-:nohlsearch vim.on_key hook (hlsearch.nvim successor). Holds no `BufWritePre` formatting: the `LspFormat`/`LspCodeActionFormat` groups were removed so conform.nvim owns write-time formatting alone |
| `command.lua` (249 lines) | User commands: `Help`, `TrimSpace`, `LuaVimInspect`, `LuaSnipEdit`, `ManV`, `TerminalV`, `LspServerInfo`, `TSInspectTree`, `DiagramToggle` |

## For AI Agents

### Working In This Directory
- Load order matters: `config/init.lua` requires `config.nvim` first (so
  `vim.opt` state, e.g. clipboard, is established), then `keymap`,
  `autocmd` synchronously and `command` on VeryLazy. Do not
  reorder without checking for implicit dependencies (e.g. `autocmd.lua`
  and `keymap.lua` both reference `vim.g.mapleader`/`maplocalleader`, which
  the repo-root `init.lua` sets before lazy.nvim bootstraps).
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
No spec files target this directory directly. Sanity-check syntax and load
order with:
`nvim --headless -c 'qa'` (fails loudly on any `require("config...")` error
during startup since `lua/init.lua` requires this module eagerly).
For isolated checks of a single file: `nvim --headless -u NONE -c "set rtp+=." -c 'lua require("config.command")' -c 'qa'`.

### Common Patterns
- Autocommands are grouped under `autocmd_user =
  vim.api.nvim_create_augroup("AutocmdUser", { clear = ... })`, defined
  independently (with differing `clear` values) in both `keymap.lua` and
  `autocmd.lua` — be aware both files touch the same augroup name.
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
...)`).

### External
`folke/lazy.nvim` (bootstrap target of `lazy.lua`); `rg`/ripgrep (referenced
by `grepprg` in `nvim.lua`); macOS Xcode Command Line Tools / SDK headers
(path wiring in `autocmd.lua`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
