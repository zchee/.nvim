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
| `conform_organize_imports_spec.lua` | `lua/plugins/conform.lua` — the `lsp_organize_imports` formatter with a stubbed `vim.lsp.buf_request_sync` (gopls does not attach in headless Neovim): asserts the Go chain order, WorkspaceEdit extraction, that edits land in the returned lines and never in the buffer, the stale-lines guard, and the empty/nil-response no-ops |
| `conform_oxfmt_json5_spec.lua` | `lua/plugins/conform.lua` — the json5 formatter wiring: `formatters_by_ft.json5` is oxfmt alone with `lsp_format = "never"`, the oxfmt `args` always pass a `--config` (project `.oxfmtrc.*` found upward, else the personal one under `XDG_CONFIG_HOME`) and a `--stdin-filepath` oxfmt can infer a dialect from (`.json`/`.json5`/`.jsonc` pass through case-insensitively, an extensionless `.renovaterc` gains `.json5`), and `format_on_save` returns `never` for json5 while everything else keeps `fallback`. Needs `conform.nvim` installed |
| `conform_taplo_spec.lua` | `lua/plugins/conform.lua` — the taplo formatter wiring: toml maps to taplo, tombi is no longer a formatter, `--config` lands after the `format` subcommand with the stdin args last, and a project's own `.taplo.toml` found by walking upward suppresses `--config` |
| `copilot_config_spec.lua` | `lua/plugins/copilot.lua` — stubs `package.preload["copilot"]` to capture the config passed to `copilot.setup()`; asserts panel/inline-suggestion UI stay disabled (cmp owns completion UI) and `advanced.inlineSuggestCount`/`advanced.listCount` are positive, in copilot.lua's `settings.advanced` shape (not VS Code's `github.copilot.advanced` shape) |
| `go_build_cache_filetype_spec.lua` | `filetype.lua` — the Go build-cache pattern: an object under `<XDG_CACHE_HOME>/go/go-build/` is detected as Go source, while `go/gobuild/` and `go/other/` are not. `vim.filetype.add` reads `pattern` keys as Lua patterns, so the glob spelling this entry started with matched nothing at all (`-` is the lazy quantifier, `**` is not a wildcard) and failed silently; the two near-miss assertions are what stop an unescaped rewrite from passing. Reloads `filetype.lua` against a temp `XDG_CACHE_HOME` |
| `goasm_filetype_spec.lua` | `lua/filetypes/goasm.lua` — `detect()` across all three heuristics (Plan 9 header include, Go arch-suffixed filename, sibling `.go` file) plus the plain-`asm` fallback, using real temp files/buffers |
| `jsonls_json5_diagnostics_spec.lua` | `lua/lsp/jsonls.lua` — the json5 diagnostic filter: `textDocument/diagnostic` reports on a `json5` buffer lose the JSON-grammar diagnostics (`ErrorCode` 0x101-0x106 scanner, 0x201-0x210 parser) and keep the schema ones (no code, or below 0x100, or SchemaUnsupportedFeature/SchemaResolveError at 0x300 and above); `json`/`jsonc`/`jsonschema` buffers are never filtered; `unchanged` reports, response errors, and a wiped buffer pass through untouched. Needs `schemastore.nvim` installed, since jsonls.lua requires it at module scope |
| `jsonls_ref_definition_spec.lua` | `lua/lsp/jsonls.lua` — the `$ref` jump: `LspAttach` binds `<C-]>` buffer-locally for `jsonls` and for no other client, a cursor inside a `"$ref"` pointer resolves through `textDocument/documentLink` (never `textDocument/definition`, which this server does not implement) and lands on the target's *value* node via the 1-indexed `#line,column` fragment, and a cursor outside every link falls back to the definition picker without moving. Needs `schemastore.nvim` installed, since jsonls.lua requires it at module scope |
| `markdown_oxide_spec.lua` | `lua/lsp/markdown_oxide.lua` — the config shape that leans on nvim-lspconfig's defaults: `cmd` is the bare homebrew binary (a subcommand would start the daily-note CLI instead of the server), markdown is the only filetype, and `settings`, `on_attach` and `root_markers` all stay absent, since `vim.lsp.config` merges with `tbl_deep_extend("force")` and would replace the upstream on_attach and markers, while a `settings` table would never be read at all. Then the live half: against the real binary, an inline `[x](target.md)` link inside a git-ignored folder still resolves — the property that ruled marksman out. Needs `markdown-oxide` and `nvim-lspconfig` installed |
| `neo_tree_compat_spec.lua` | `lua/plugins/neo_tree_compat.lua` — `is_invalid_win_error`, `get_node_safely` (suppresses a known stale-window `nui` error, rethrows anything else), `hijack_cursor_handler` (moves the cursor to the filename start, no-ops when `neo_tree_source` is unavailable, tolerates the stale-window failure), and `patch_hijack_cursor_module` idempotency |
| `rust_analyzer_spec.lua` | `lua/lsp/rust_analyzer.lua` — writes a fake executable `rustup` onto a temp `PATH` to verify `cmd` resolves to `{"rustup","run",<toolchain>,"rust-analyzer"}` when `rustup default` succeeds, and falls back to plain `{"rust-analyzer"}` when it fails or prints no toolchain |
| `rustaceanvim_cargo_config_spec.lua` | `lua/plugins/rustaceanvim.lua` — the dev cargo config wiring: `cargo.configPath` is the absolute `rust/config.dev.toml` under the symlink-resolved `util.xdg_config_home()` (rust-analyzer passes it to every cargo as `--config`, and cargo expands no `~`), stays unset when that file is missing, and is never a path cargo cannot read. Since `util.xdg_config_home()` became realpath-based it also pins the case that used to collapse to `""` and hand cargo a relative path: a real-directory `XDG_CONFIG_HOME` holding the file still yields a `configPath`. Also pins the analysis `CARGO_TARGET_DIR`, which has been deleted once as redundant: it stays set, never equals the `target-dir` that same config hands the shell, and is absolute only when its parent mount exists |
| `snacks_compat_spec.lua` | `lua/plugins/snacks_compat.lua` — `is_treesitter_quickfile_range_error` matcher, `render_quickfile` (Tree-sitter fast path, syntax fallback on start/redraw failure, re-propagates unknown redraw errors after stopping Tree-sitter), and `patch_quickfile_module` (excluded-language and bigfile skip logic) |
| `treesitter_selection_spec.lua` | Incremental selection module: init/expand/shrink/scope mark transitions on a scratch lua buffer |
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
- `rust_analyzer_spec.lua`, `goasm_filetype_spec.lua`,
  `rustaceanvim_cargo_config_spec.lua`, and
  `go_build_cache_filetype_spec.lua` are the specs that touch the real
  filesystem/environment (temp dirs, a fake executable `rustup`, a symlinked
  temp `XDG_CONFIG_HOME`, a temp `XDG_CACHE_HOME`) instead of pure fakes — they
  clean up (`vim.fn.delete(dir, "rf")`, restore
  `vim.env.PATH`/`vim.env.XDG_CONFIG_HOME`/`vim.env.XDG_CACHE_HOME`) even on
  failure via `pcall`. Both specs that build a path from a temp directory
  resolve it through `vim.uv.fs_realpath` first: `util.xdg_*_home()` resolves
  symlinks, and on macOS `tempname()` sits under `/var`, itself a link to
  `/private/var`.

### Testing Requirements
Run any spec with:
`nvim --headless -u NONE -l tests/<name>_spec.lua`
Exit code 0 and no output means pass; a thrown `error()` prints a traceback
and exits non-zero. Run the full suite by looping over all fifteen files (no
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
- `lua/plugins/rustaceanvim.lua`
- `lua/filetypes/goasm.lua`
- `lua/lsp/jsonls.lua`, `lua/lsp/rust_analyzer.lua`
- `lua/plugins/conform.lua` (with `conform.nvim` on the runtimepath)

`go_build_cache_filetype_spec.lua` instead `dofile`s the repo-root
`filetype.lua`, which pulls in `lua/util/init.lua` and `lua/filetypes/goasm.lua`
as a side effect.

### External
- `nvim` binary on `PATH` to run the specs (`nvim --headless -u NONE -l ...`).
- `rust_analyzer_spec.lua` additionally requires a POSIX shell (`#!/bin/sh`
  fake `rustup` script, `chmod`) — will not run as-is on a non-POSIX host.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
