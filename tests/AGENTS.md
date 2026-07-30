<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# tests

## Purpose
Headless Neovim regression specs, one per bug/behavior being pinned down.
Each is a standalone Lua script run directly with `nvim -l` (no test
framework, no assertion library) — every spec extends `runtimepath` and
`package.path` to reach `lua/`, `require()`s the module under test, and uses
plain `error()`/`assert()` calls with descriptive failure messages. A failing
assertion throws, which propagates as a non-zero exit from `nvim`.

## Key Files
| File | Description |
|------|-------------|
| `comment_compat_spec.lua` | `lua/plugins/comment_compat.lua` — `patch_ft()` guards `Comment.nvim`'s filetype table against a nil Tree-sitter parser (kitty buffers), falls back to filetype `commentstring`, preserves language-aware resolution when a parser exists, and is idempotent |
| `copilot_config_spec.lua` | `lua/plugins/copilot.lua` — stubs `package.preload["copilot"]` to capture the config passed to `copilot.setup()`; asserts panel/inline-suggestion UI stay disabled (cmp owns completion UI) and `advanced.inlineSuggestCount`/`advanced.listCount` are positive, in copilot.lua's `settings.advanced` shape (not VS Code's `github.copilot.advanced` shape) |
| `goasm_filetype_spec.lua` | `lua/filetypes/goasm.lua` — `detect()` across all three heuristics (Plan 9 header include, Go arch-suffixed filename, sibling `.go` file) plus the plain-`asm` fallback, using real temp files/buffers |
| `illuminate_compat_spec.lua` | `lua/plugins/illuminate_compat.lua` — error-message matchers for known `nvim-treesitter` locals/invalid-line failures, cursor/reference clamping (`normalize_cursor`, `sanitize_references`), and the patched Tree-sitter/regex/reference-module providers that suppress only the known failures while still propagating unrelated errors |
| `neo_tree_compat_spec.lua` | `lua/plugins/neo_tree_compat.lua` — `is_invalid_win_error`, `get_node_safely` (suppresses a known stale-window `nui` error, rethrows anything else), `hijack_cursor_handler` (moves the cursor to the filename start, no-ops when `neo_tree_source` is unavailable, tolerates the stale-window failure), and `patch_hijack_cursor_module` idempotency |
| `rust_analyzer_spec.lua` | `lua/lsp/rust_analyzer.lua` — writes a fake executable `rustup` onto a temp `PATH` to verify `cmd` resolves to `{"rustup","run",<toolchain>,"rust-analyzer"}` when `rustup default` succeeds, and falls back to plain `{"rust-analyzer"}` when it fails or prints no toolchain |
| `snacks_compat_spec.lua` | `lua/plugins/snacks_compat.lua` — `is_treesitter_quickfile_range_error` matcher, `render_quickfile` (Tree-sitter fast path, syntax fallback on start/redraw failure, re-propagates unknown redraw errors after stopping Tree-sitter), and `patch_quickfile_module` (excluded-language and bigfile skip logic) |
| `treesitter_compat_spec.lua` | `lua/plugins/treesitter_compat.lua` — `capture_node` (direct vs. list-wrapped captures), `get_parser_from_markdown_info_string` (filetype-first, alias fallback), and `patch_query_predicates` (registers `nth?`/`kind-eq?`/`is?` predicates and `set-lang-from-mimetype!`/`set-lang-from-info-string!`/`downcase!` directives against a fake Tree-sitter query object) |
| `ts_context_commentstring_compat_spec.lua` | `lua/plugins/ts_context_commentstring_compat.lua` — `resolve_parser` (nil-safe, suppresses `get_parser` exceptions) and `patch_utils` (`is_treesitter_active` nil-parser guard, idempotency) |

## For AI Agents

### Working In This Directory
- Spec boilerplate (copy this exactly for a new spec):
  ```lua
  vim.opt.runtimepath:append(vim.fn.getcwd())
  package.path = table.concat({
    vim.fn.getcwd() .. "/lua/?.lua",
    vim.fn.getcwd() .. "/lua/?/init.lua",
    package.path,
  }, ";")

  local target = require("plugins.<module>")
  ```
  then plain `do ... end` blocks calling local `assert_equal`/`assert_truthy`/
  `assert_falsy`/`assert_deep_equal` helpers (each spec redefines these
  locally — there is no shared test-helper module) or bare `assert()`/
  `error()`.
- Specs must be run from the repo root (`vim.fn.getcwd()` must resolve to
  `.nvim/`) — `-u NONE` skips the user's real init.lua so the spec's own
  `runtimepath`/`package.path` setup is what makes `require()` work at all.
- No mocking framework: specs build small hand-rolled fake tables
  (fake `ft`/`provider`/`utils`/`query` objects) matching just the shape the
  module under test calls into — follow that pattern rather than pulling in
  a mocking library.
- Compat specs (`comment_compat`, `illuminate_compat`, `neo_tree_compat`,
  `snacks_compat`, `treesitter_compat`, `ts_context_commentstring_compat`)
  exist because upstream plugins hit a specific, reproducible Neovim/Tree-sitter
  error; each spec pins the exact error string it patches around
  (`#find(..., 1, true)` substring checks) — if the upstream error message
  changes, the matcher and its spec need to change together.
- `rust_analyzer_spec.lua` and `goasm_filetype_spec.lua` are the two specs
  that touch the real filesystem/`PATH` (temp dirs, a fake executable
  `rustup`) instead of pure fakes — they clean up (`vim.fn.delete(dir,
  "rf")`, restore `vim.env.PATH`) even on failure via `pcall`.

### Testing Requirements
Run any spec with:
`nvim --headless -u NONE -l tests/<name>_spec.lua`
Exit code 0 and no output means pass; a thrown `error()` prints a traceback
and exits non-zero. Run the full suite by looping over all nine files (no
runner script exists — invoke each individually, e.g.
`for f in tests/*_spec.lua; do nvim --headless -u NONE -l "$f" || echo "FAIL: $f"; done`).
When adding a spec for a new compat shim or filetype detector, follow the
naming convention `<module_or_topic>_spec.lua` and add it to this table.

### Common Patterns
- One spec file per module under test, named `<module>_spec.lua`.
- Tests are structured as a sequence of independent `do ... end` blocks
  within a single file (no `describe`/`it` nesting), each covering one
  behavior with an inline descriptive failure message as the last argument
  to the assert helper.
- Modules under test expose small, pure, dependency-injected functions
  (e.g. `patch_ft(ft, deps)`, `patch_treesitter_provider(provider, deps)`)
  specifically so specs can pass fake `deps` instead of touching real
  Neovim/plugin state — preserve that injectable-dependency shape when
  adding new compat/patch functions so they stay testable this way.

## Dependencies

### Internal
Tests directly `require()`:
- `lua/plugins/comment_compat.lua`, `lua/plugins/copilot.lua`,
  `lua/plugins/illuminate_compat.lua`, `lua/plugins/neo_tree_compat.lua`,
  `lua/plugins/snacks_compat.lua`, `lua/plugins/treesitter_compat.lua`,
  `lua/plugins/ts_context_commentstring_compat.lua`
- `lua/filetypes/goasm.lua`
- `lua/lsp/rust_analyzer.lua`

### External
- `nvim` binary on `PATH` to run the specs (`nvim --headless -u NONE -l ...`).
- `rust_analyzer_spec.lua` additionally requires a POSIX shell (`#!/bin/sh`
  fake `rustup` script, `chmod`) — will not run as-is on a non-POSIX host.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
