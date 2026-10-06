<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-10-07 -->

# tests

## Purpose
Headless Neovim regression specs, one per bug/behavior being pinned down.
Each is a standalone Lua script run directly with `nvim -l` (no test
framework, no assertion library) — every spec extends `runtimepath` and
`package.path` to reach `lua/`, `require()`s the module under test, and uses
plain `error()`/`assert()` calls with descriptive failure messages. A failing
assertion throws, which propagates as a non-zero exit from `nvim`. `perf/`
holds the specs for `script/`'s performance harnesses and the specs that boot
the full config in child sessions.

## Key Files
| File | Description |
|------|-------------|
| `asm_lsp_root_spec.lua` | `lsp/asm_lsp.lua` — the `root_dir` function: asm-lsp exits 1 with "Unable to detect project root directory" when its config has a `[[project]]` table and the client sends no root, so the function must root every named buffer. On a real tree it asserts the order `.asm-lsp.toml` > `.git` > `go.mod` (a nested module inside a repository keeps the repository root; GOROOT and module-cache assembly, which carry `go.mod` but no `.git`, root at the `go.mod`), the file's own directory when no marker exists, and no `on_dir` call for an unnamed buffer; `root_markers` must be gone, since a `root_dir` function makes it dead config. Then the live half, with `HOME` pointed at a throwaway global config holding a `[[project]]` table: a nil root must reproduce the error through `window/showMessage` (the control), and the root the config resolves for a marker-less file must leave the server answering `textDocument/documentSymbol` with the fixture's label. Prints SKIP for the live half when asm-lsp is not installed. Prints `OK: asm_lsp roots every buffer it can name, ...` |
| `auto_hlsearch_on_key_spec.lua` | `lua/config/autocmd.lua` — the auto-hlsearch `vim.on_key` handler: replaces `vim.fn` with a proxy that errors on any access (the handler runs per physical keystroke and must never cross the VimL bridge), then drives the search-key truth table, the argument keys that must leave hlsearch alone (`"*p`, `f*`, ...), the `q` that stops a recording (typed `qajq` then `n` must light the search, so the Recording autocmds really fire), the `typed == ""` mapping-expansion early return, the no-redundant-option-write path, and the Insert-mode gate, entered with the Insert-mode pattern below. Prints `ALL PASS: auto_hlsearch_on_key_spec` |
| `chrome_spec.lua` | `lua/config/chrome.lua` — the hand-rolled statusline and tabline that replaced lualine+bufferline: the 1.5 ms module-load budget (a timing assert kept on purpose, judged on the minimum over fresh processes, see below), insert-after-current tabline ordering, the statusline sections, the modified/readonly markers, the gitsigns-fed branch and diff segments, diagnostic counts with lualine's icons and their Insert-mode deferral (entered with the Insert-mode pattern below), buffer ids and click regions, bufferline's dedup prefixes for same-named files, the `%@` click handler's button discrimination, the blanked `snacks_picker_input` statusline, `%` escaping in filenames, file icons surviving `:colorscheme` (that section prints SKIP without nvim-web-devicons), and `_G.Chrome_click` existing only while chrome owns the tabline. Prints `ALL PASS: chrome_spec` |
| `conform_hujsonfmt_spec.lua` | `lua/plugins/conform.lua` — the hujson formatter wiring: `formatters_by_ft.hujson` is hujsonfmt alone with `lsp_format = "never"` (jsonls formats HuJSON to a different layout, so a missing hujsonfmt must format nothing), the command resolves to `~/go/bin/hujsonfmt` for a document (leading blank lines and a comment-only buffer included) and to `cat` for an empty or whitespace-only buffer, and `format_on_save` returns `never` for hujson. Then the live half through `conform.format` and the real binary: a fixture is tab-indented with aligned values, comments kept and single-line trailing commas dropped, a parse error comes back as hujsonfmt's own message with the buffer untouched, and an empty buffer formats with no error and no edit (the outcome is read from the callback; the return value only says a formatter was attempted). Prints SKIP when hujsonfmt is not installed. Needs `conform.nvim` installed |
| `conform_organize_imports_spec.lua` | `lua/plugins/conform.lua` — the `lsp_organize_imports` formatter with a stubbed `vim.lsp.buf_request_sync` (gopls does not attach in headless Neovim): asserts the Go chain order, WorkspaceEdit extraction, that edits land in the returned lines and never in the buffer, the stale-lines guard, and the empty/nil-response no-ops. Also that `format_on_save` hands back the `lsp_format = "first"` pin of the go and goasm entries (gopls formats before the chain) instead of overwriting it with `fallback`. Prints `OK: conform_organize_imports_spec passed` |
| `conform_oxfmt_json5_spec.lua` | `lua/plugins/conform.lua` — the json5 formatter wiring: `formatters_by_ft.json5` is oxfmt alone with `lsp_format = "never"`, the oxfmt `args` always pass a `--config` (project `.oxfmtrc.*` found upward, else the personal one under `util.xdg_config_home()`, realpath-resolved: the spec points `$XDG_CONFIG_HOME` at a symlink it creates before anything resolves it) and a `--stdin-filepath` oxfmt can infer a dialect from (`.json`/`.json5`/`.jsonc` pass through case-insensitively, an extensionless `.renovaterc` gains `.json5`), and `format_on_save` returns `never` for json5 while json and python keep `fallback`. Needs `conform.nvim` installed |
| `conform_taplo_spec.lua` | `lua/plugins/conform.lua` — the taplo formatter wiring: toml maps to taplo, tombi is no longer a formatter, `--config` lands after the `format` subcommand with the stdin args last and names the personal config under the realpath-resolved `util.xdg_config_home()` (the spec points `$XDG_CONFIG_HOME` at a symlink it creates), and a project's own `.taplo.toml` found by walking upward suppresses `--config`. Prints `OK: conform_taplo_spec passed` |
| `copilot_config_spec.lua` | `lua/plugins/copilot.lua` — stubs `package.preload["copilot"]` to capture the config passed to `copilot.setup()`, against a fake bun global install: the native server (`server.type = "binary"`, `custom_server_filepath` the bun-installed binary, no `copilot_node_command`); a missing binary raises exactly one ERROR naming the absolute path it expected and skips `setup()`, so copilot.lua never downloads its own build; with `$BUN_INSTALL` unset the package's bin link on `$PATH` still finds the same binary; `should_attach` accepts a named file buffer and rejects `[No Name]` and `nofile` buffers; panel and inline-suggestion UI stay disabled and `advanced.inlineSuggestCount`/`advanced.listCount` are positive, in copilot.lua's `settings.advanced` shape (not VS Code's `github.copilot.advanced` shape). Prints `copilot_config_spec: ALL PASS` |
| `custom_parser_queries_spec.lua` | `lua/nvim-treesitter/parsers.lua`'s `install_info.queries` — for each custom grammar whose entry installs the grammar repo's queries (`cel`, `ghostty`, `goasm`, `mustache`, `x86asm`) and whose parser is installed: `highlights` resolves from `stdpath("data")/tree-sitter-main/queries/<lang>` (a parser installed before the entry gained `queries` fails here until it is reinstalled with `force`) and every `.scm` there compiles against that parser. Then a Ghostty config fixture (comment, string, number, boolean, colour, `palette`, `config-file = ?path`, a `keybind` with modifiers and an action argument, `keybind = clear`) parses without ERROR nodes and gets 16 captures (`@comment`, `@variable`, `@operator`, `@string`, `@number`, `@boolean`, `@variable.member`, `@keyword.import`, `@keyword.conditional`, `@string.special.path`, `@constant.builtin`, `@function.call`, `@variable.parameter`, `@keyword`). Prints SKIP per grammar whose parser is not installed, then `ALL PASS (<n> grammars, ...)` |
| `filetype_rules_spec.lua` | `filetype.lua` and `ftdetect/` — 42 cases, each opening a real file in a scratch tree so detection runs as in a session: `vim.filetype.match` with the runtime rules and `filetype.lua`, shebang content detection, and the `ftdetect/` autocmds (sourced into `filetypedetect` by the spec, since `-u NONE` never loads them). Most pin a `pattern` rule that once matched far more than it meant to (`pattern` keys are Lua patterns, anchored, and matched against the tail when they hold no `/`): `dockerfile_test.go` → go, `venv.py` → python, `bashrc_test.go` → go, `.env.local` → env, `c++/README.md` → markdown, `README.txt` → text, `a.tfvars` → terraform-vars. Also ragel, doxyfile and modulemap detection, `.npmrc` → dosini, the tigrc names, the buf files, `go.log` → gotestlog, and the gotmpl content fallback yielding to a `#!/bin/sh` shebang. Prints one line per case, then `ALL PASS (42 cases)` |
| `go_build_cache_filetype_spec.lua` | `filetype.lua` — the Go build-cache pattern: an object under `<XDG_CACHE_HOME>/go/go-build/` is detected as Go source, while `go/gobuild/` and `go/other/` are not. `vim.filetype.add` reads `pattern` keys as Lua patterns, so the glob spelling this entry started with matched nothing at all (`-` is the lazy quantifier, `**` is not a wildcard) and failed silently; the two near-miss assertions are what stop an unescaped rewrite from passing. Reloads `filetype.lua` against a temp `XDG_CACHE_HOME` |
| `go_injections_spec.lua` | `after/queries/go/injections.scm` — the SQL and JSON injections, parsed from an inline Go source against the installed go/sql/json parsers with only the parser dir, `$VIMRUNTIME` and this checkout's `after/` on the rtp. Counts the regions per injected text, which must be exactly one for each expected literal and none for anything else. SQL: upper-case statements, a raw string that starts with a line break, lower-case `insert into ... values` and `select ... from`, the `-- sql` marker, sqlc-shaped raw strings led by `-- name: X :one` lines (with a blank line, or `DELETE` and `FROM` on separate lines), a `/* */`-led statement and one led by a block and a `--` line, and the `SELECT 1` run after the `\n` escape of an interpreted string; no SQL for the `database/sql/driver` import path, sentences holding an SQL word (`unknown database name %q`, `no rows having that id`, `please update the cache`, `please select an option from the menu`) or Go error strings led by a lower-case verb (`create %q: %s`, `can't delete from empty map`), strings holding only `--` comments (`-- just a note`, raw and interpreted, and `--- test:` lines) or lower-case `with` after a `-- name:` comment, and no literal twice. JSON: const, var and `:=` raw strings holding one object (multi-line included); none for plain text, a call argument or an interpreted string. Looks for the parsers under `stdpath("data")/tree-sitter-main`, then `~/.local/share/nvim/tree-sitter-main` (the isolated data dir of a test run has none), prints which, and prints SKIP when go, sql or json is missing, as on CI. Prints `ALL PASS: go_injections_spec` |
| `goasm_filetype_spec.lua` | `lua/filetypes/goasm.lua` — `detect()` across all three heuristics (Plan 9 header include, Go arch-suffixed filename, sibling `.go` file) plus the plain-`asm` fallback, using real temp files/buffers |
| `hujson_ftplugin_spec.lua` | `ftplugin/hujson.lua` — a hujson buffer takes jsonc's settings: `commentstring` `// %s`, `comments` covering `//` and `/* */`, and `after/ftplugin/jsonc.lua` sourced (checked through `getscriptinfo()`, since `after/ftplugin/json.lua` sets the same indent options and is reached anyway) with its `sw=ts=2` applied, then `noexpandtab` to match hujsonfmt's tabs; `gcc` comments and uncomments a line, and `vim.filetype.get_option("hujson", "commentstring")` (what `gc` reads on a Tree-sitter buffer) sees it too. To see it fail without the ftplugin, run it with `--clean` inside a copy of the repo lacking `ftplugin/hujson.lua`: under `-u NONE` the `~/.config/nvim` symlink puts the real one back on the rtp, and from outside the repo nothing of it is on the rtp at all |
| `hujson_queries_spec.lua` | `queries/hujson/` — against the installed tree-sitter-hujson parser and nvim-treesitter's json queries, every inherited query (`highlights`, `injections`, `indents`, `folds`, `locals`) compiles and is found, a fixture with comments and trailing commas parses without ERROR nodes, and the HuJSON-only syntax gets real captures (`@comment` on line, trailing and inline `/* */` comments, `@punctuation.delimiter` on the `,]` and `,}` trailing commas, `@boolean`/`@constant.builtin`/`@property`/`@string`/`@number`). Prints SKIP when the parser is not installed. Run it with `--clean` to see it fail without the repo on the rtp: under `-u NONE` the `~/.config/nvim` symlink still puts the repo's `queries/` there |
| `imectl_focus_guard_spec.lua` | `lua/config/autocmd.lua` — `make_imectl_callback` (the FocusGained imectl guard): with injected `executable`/`jobstart` deps, asserts the probe asks for `util.prefix("bin", "imectl")`, `executable() == 0` never reaches jobstart (the pre-fix truthy-`0` bug spawned a failing process per focus gain), `== 1` jobstarts on every event with an argv list (no shell, no `$PATH` lookup), and the probe-once cache calls `executable()` at most once across repeated events |
| `jsonls_chrome_manifest_spec.lua` | `lsp/jsonls.lua` — the Chrome extension manifest route: `before_init` points the catalog's Chrome Extension entry at `chrome-manifest.json` with `chrome-extension*/**/manifest.json`, and every entry claiming a file named `manifest.json` (Foxx Manifest, WebExtensions, Web App Manifest, UI5, ...) ends with the matching `!` negation, since the server merges every matching association under `allOf` and the last matching pattern decides; a catalog without the Chrome Extension entry gets one added; the catalog module's own table stays untouched. Then the live half: against the real server, `json/languageStatus` (no schema download, so no network) reports `chrome-manifest.json` alone for root, `src/` and nested manifests and for the plural `chrome-extensions-*`, while `package.json` and a web app `manifest.json` keep their catalog schemas. Needs `schemastore.nvim` (prints SKIP without it) and `vscode-json-language-server` installed. Prints `OK: chrome-extension* manifests resolve to chrome-manifest.json alone` |
| `jsonls_hujson_spec.lua` | `lsp/jsonls.lua` — the hujson route: `filetypes` lists hujson, `get_language_id` sends it as `jsonc` and leaves every other filetype's id alone, and the diagnostic handler drops only TrailingComma (519) on hujson buffers while jsonc keeps it. Then the live half: against the real server, with the config's own `get_language_id`, a fixture with `//` and `/* */` comments, three trailing commas and one missing comma draws no comment diagnostic (521) and exactly `519,519,514,519`, and after the handler only the missing comma (514) remains. No network: no schema is set. Needs `vscode-json-language-server` installed |
| `jsonls_json5_diagnostics_spec.lua` | `lsp/jsonls.lua` — the json5 diagnostic filter: `textDocument/diagnostic` reports on a `json5` buffer lose the JSON-grammar diagnostics (`ErrorCode` 0x101-0x106 scanner, 0x201-0x210 parser) and keep the schema ones (no code, or below 0x100, or SchemaUnsupportedFeature/SchemaResolveError at 0x300 and above); `json`/`jsonc`/`jsonschema` buffers are never filtered; `unchanged` reports, response errors, and a wiped buffer pass through untouched. Needs `schemastore.nvim` installed, since jsonls.lua requires it at module scope |
| `jsonls_keep_lines_spec.lua` | `lsp/jsonls.lua` — the keepLines setting: the config advertises no formatter (`provideFormatter = false`), so the spec sends `textDocument/formatting` directly, and the server applies keepLines only from `settings.json.keepLines.enable` (VS Code's `json.format.keepLines` is renamed to that by the VS Code client, so `json.format.keepLines` is silently ignored). Asserts the config sends the read shape and not the ignored one, then against the real server formats a fixture of single-line arrays and objects, a 106-column line and a multi-line array: the line count is unchanged and each line differs only by the space keepLines pads inside a single-line bracket pair (`[ "zig", "fmt" ]`). A control run with the old `format.keepLines` shape must still expand the arrays, which fails the spec if the server ever starts reading that key. Needs `schemastore.nvim` and `vscode-json-language-server` installed |
| `jsonls_ref_definition_spec.lua` | `lua/lsp/on_attach.lua` — the jsonls `$ref` jump in the shared `on_attach`: it binds `<C-]>` buffer-locally for `jsonls` and for no other client (a `yamlls` buffer keeps the global map), a cursor inside a `"$ref"` pointer resolves through `textDocument/documentLink` (never `textDocument/definition`, which this server does not implement) and lands on the target's *value* node via the 1-indexed `#line,column` fragment, and a cursor outside every link falls back to the definition picker without moving. Prints `OK: jsonls resolves $ref through documentLink and falls back elsewhere` |
| `lint_debounce_spec.lua` | `lua/plugins/lint.lua` — the nvim-lint trigger wiring with a counting `try_lint` stub preloaded as `lint`, driven on the first filetype `plugins.lint` configures (sorted order, so disabling one linter cannot strand the spec on a dead filetype): the unconfigured control filetype (`text`) never lints, FileType/BufWritePost lint immediately, an InsertLeave burst collapses to exactly one run per 500 ms quiet window (trailing-edge uv timer per buffer), the timer re-arms, and deleting a buffer cancels its pending run |
| `lsp_capabilities_snapshot_spec.lua` | `lua/lsp/capabilities.lua` — the static blink.cmp capability snapshot `lua/lsp/init.lua` merges so blink.cmp stays unloaded until InsertEnter: equal in both directions to the live `require("blink.cmp").get_lsp_capabilities({}, false)`, reporting the first differing path (the snapshot's header carries the regeneration one-liner). Then, after `require("lsp")`, the merged `vim.lsp.config["*"]` `completionItem` claims nothing blink.cmp reports as unimplemented, and resolving every enabled config plus `tsgo` calls no `util.bun_prefix`/`util.nodenv_prefix`/`vim.fn.exepath` (lookups belong in a function `cmd` or `before_init`). Needs `blink.cmp` and `blink.lib` installed. Prints `OK: capabilities snapshot matches blink.cmp, ...` |
| `lsp_noop_edit_spec.lua` | `lua/lsp/init.lua` — the no-op formatting-edit filter: loads the module with lspkind stubbed and `vim.lsp.enable` a no-op, attaches fake clients through the real `LspAttach` autocmd (`vim.lsp.get_client_by_id` stubbed), and calls the handler the wrapper hands to the client's original `request`. An edit that leaves the buffer byte-identical is dropped and a real one kept, in order: ASCII, the end-of-buffer edit vscode-json-language-server appends, a start past the last line, multi-line and reversed ranges, columns past the end of the line, and utf-8/utf-16/utf-32 offsets on multibyte text (a missing `offset_encoding` reads as utf-16). `rangeFormatting`/`rangesFormatting` are filtered too; other methods, nil handlers, nil or empty results and a deleted buffer pass through; a second attach does not wrap twice. Prints `OK: no-op formatting edits are dropped in every offset encoding, real edits are kept` |
| `luasnippets_parse_spec.lua` | Every file under `lua/luasnippets/` loads without raising — the set of a filetype is only executed on that filetype's first InsertEnter, so a broken file stays invisible until someone opens that filetype and finds all its snippets missing (the case that motivated it: `fmta` reads `<>` as delimiters, so a literal `>` must be doubled). Both file shapes pass: returning a snippet table or registering imperatively with `ls.add_snippets`. Then the 14 gated Go snippets (13 triggers; `ft` exists in both the function and the test set) are hidden and refuse to expand in a buffer that is neither inside a function nor a `_test.go` file, while ungated control snippets stay available: the gate must reach the snippet's own opts, not `fmt()`'s. Appends lazy's `LuaSnip` dir to the rtp and prints SKIP when the plugin is not installed. Prints `luasnippets: <n> files load cleanly (...)` |
| `markdown_oxide_spec.lua` | `lsp/markdown_oxide.lua` — the config shape now that nvim-lspconfig is gone: `cmd` is the bare binary resolved through `util.homebrew_binary` (a subcommand would start the daily-note CLI instead of the server), markdown is the only filetype, `settings` stays absent (the server never pulls `workspace/configuration`) and so does a per-server `on_attach` (it would replace the shared one). The shared `on_attach` in `lua/lsp/on_attach.lua` creates `:LspToday`/`:LspTomorrow`/`:LspYesterday`, and `:LspTomorrow` runs the server's `jump` command. The inlined `root_markers` let a vault's `.moxide.toml` or `.obsidian` root it ahead of the repository `.git`, checked with `vim.fs.root` on a real tree. Then the live half: against the real binary, an inline `[Handoff](target.md)` link inside a git-ignored folder still resolves — the property that ruled marksman out. Needs `markdown-oxide` installed. Prints `OK: markdown_oxide config shape holds and ...` |
| `neo_tree_compat_spec.lua` | `lua/plugins/neo_tree_compat.lua` — `is_invalid_win_error`, `get_node_safely` (suppresses a known stale-window `nui` error, rethrows anything else), `hijack_cursor_handler` (moves the cursor to the filename start, no-ops when `neo_tree_source` is unavailable, tolerates the stale-window failure), and `patch_hijack_cursor_module` idempotency |
| `parsers_overlay_loader_spec.lua` | `lua/nvim-treesitter/parsers.lua` — the parsers overlay under `vim.loader`, enabled first as the root `init.lua` does: the overlay must read the shadowed nvim-treesitter registry as source text, because `loadfile()` dies with "wrong mode" once the loader owns it. Asserts the base entries (`go`, `lua`) survive, the custom `goasm` grammar is merged with its local-checkout `path`, each custom grammar whose repo ships Neovim queries (`goasm`, `cel`, `ghostty`, `mustache`, `x86asm`) names that query dir in `install_info.queries`, and `dockerfile` is the overlay's fork. Needs nvim-treesitter installed |
| `qf_help_autocmd_spec.lua` | `lua/config/autocmd.lua` — the pager-window `FileType` autocmd: after `:copen` the quickfix buffer maps `u`/`d` to `<C-u>`/`<C-d>` (its buffer is still modifiable when FileType fires), a modifiable `ft=help` buffer keeps `u`/`d` unmapped, and read-only `:help` pages on them; then the `WinClosed` auto-quit: a `:quit` refused by a modified hidden buffer is one `E37` message with no Lua traceback, `<C-w>T` on quickfix keeps its new tab, closing a focused float keeps a qf-only tab (a hover preview closed by its own `q` after `<C-w>T`, and an entered float in a `:only` qf tab), and — last — `:q` from the only file window quits the qf-only tab, ending Nvim, where a `VimLeavePre` guard prints `ALL PASS: qf_help_autocmd_spec` (any other exit is exit 1) |
| `rustaceanvim_cargo_config_spec.lua` | `lua/plugins/rustaceanvim.lua` — the dev cargo config wiring: `cargo.configPath` is the absolute `rust/config.dev.toml` under the symlink-resolved `util.xdg_config_home()` (rust-analyzer passes it to every cargo as `--config`, and cargo expands no `~`), stays unset when that file is missing, and is never a path cargo cannot read. Since `util.xdg_config_home()` became realpath-based it also pins the case that used to collapse to `""` and hand cargo a relative path: a real-directory `XDG_CONFIG_HOME` holding the file still yields a `configPath`. Also pins the analysis `CARGO_TARGET_DIR`, which has been deleted once as redundant: it stays set, never equals the `target-dir` that same config hands the shell, and is absolute only when its parent mount exists |
| `snacks_compat_spec.lua` | `lua/plugins/snacks_compat.lua` — `is_treesitter_quickfile_range_error` matcher, `render_quickfile` (Tree-sitter fast path, syntax fallback on start/redraw failure, re-propagates unknown redraw errors after stopping Tree-sitter), and `patch_quickfile_module` (excluded-language and bigfile skip logic) |
| `treesitter_selection_spec.lua` | `lua/plugins/treesitter_selection.lua` — incremental selection on a scratch lua buffer: init/expand/shrink/scope mark transitions, and a selection started afresh (`v` from normal mode) beginning at the node under the cursor rather than at the top of the stack an earlier selection left. Prints `OK: treesitter_selection incremental selection behaves` |
| `ts_context_commentstring_compat_spec.lua` | `lua/plugins/ts_context_commentstring_compat.lua` — `resolve_parser` (nil-safe, suppresses `get_parser` exceptions) and `patch_utils` (`is_treesitter_active` nil-parser guard, idempotency) |
| `ui_mode_spec.lua` | `lua/config/ui_mode.lua` — the statusline/tabline renderer switch: the resolution order (`$NVIM_UI_MODE` > `vim.g.ui_mode` > state file > `chrome`, unknown values falling through) against a scratch `XDG_STATE_HOME` so the real state dir is never written, resolve-once caching, that resolving never drags `config.chrome` in (`lua/plugins/init.lua` asks before `require("config")` has run), that `set()` refuses an unknown mode and a `plugins` switch while the plugins are uninstalled without touching the options or the state file, the persistence round-trip, and chrome's re-enterability — a second `setup()` rebuilds the tabline order instead of appending, `teardown()` restores the options nightly ships and deletes the `config_chrome` augroup. Then three round trips with the real lualine+bufferline through lazy.nvim (installs, checker and change detection off, lockfile in the scratch dir): bufferline's `setup()` runs once, so its BufEnter autocmd stays single, no autocmd accumulates, and `persist = false` writes no state file; that section prints SKIP when a plugin is not installed. Prints `ALL PASS: ui_mode_spec` |
| `util_prefix_spec.lua` | `lua/util/init.lua` — `bun_prefix` and `nodenv_prefix` against a scratch `$BUN_INSTALL`, `$NODENV_ROOT` and `$PATH` (no real bun or nodenv install is read): the derived path when it is executable, with no warning; the `$PATH` fallback with one WARN naming the helper, the derived path and the `$PATH` answer; the derived absolute path when `$PATH` has no such binary either; one warning per helper and binary however often it is asked; and an unreadable `$NODENV_ROOT/version`, which warns "cannot read" and yields the shim path, even when that shim is executable. Prints `ALL PASS: util_prefix_spec` |
| `perf/hl_dump_spec.lua` | Colorscheme-parity falsifier — runs `script/hl-dump.lua` in a child `nvim --headless -l` (`vim.v.progpath`). `-l` never loads the user config, and the script puts the checkout it lives in first on the rtp, so it dumps the colorscheme of the tree under test rather than whatever `~/.config/nvim` points at. Byte-compares the canonical dump with `perf/fixtures/hl_baseline.txt` twice, on first paint and after a `:colorscheme` re-apply (`--reapply`), reporting the first divergent line. The fixture pins nvim's default-derived groups too, so an intentional scheme change or a nightly bump that changes a default (MCursor's link did) means regenerating it with `nvim --headless -u NONE -i NONE -l script/hl-dump.lua tests/perf/fixtures/hl_baseline.txt` and checking that the diff holds only those groups. Prints `hl parity: <bytes> bytes, <n> groups, re-apply stable` |
| `perf/metrics_probe_spec.lua` | uv-metrics stall probe falsifier for `script/perf-report.sh`'s pty probe: `loop_configure("metrics_idle_time")` returns 0, `metrics_idle_time()` (nanoseconds) grows across an idle 200 ms `vim.wait`, `metrics_info()` exposes `loop_count`, and `script/lib/stall_probe.lua` — the prepare/check pair the report's probe dofiles (check = poll returned, prepare = about to block, so check→next-prepare is one loop turn's active stretch) — registers a synthetic 30 ms hrtime busy-loop as a ≥25 ms stall |
| `perf/startup_budget_spec.lua` | Load-graph harness — boots the FULL user config in pty sessions (`jobstart` with `pty = true`, each on a throwaway ShaDa copy from `script/lib/throwaway_shada.lua`) and asserts the lazy load-graph shape: at 3 s no-file idle schemastore is unloaded, blink.cmp and copilot are loaded only by the tagged warmup (`vim.g.warmup_loaded`), and nvim-lspconfig is not a spec at all; gopls attaches to a Go fixture while blink.cmp stays off the InsertEnter path; schemastore materializes on a JSON buffer. The config runs gopls as a forwarder to `/tmp/gopls.sock`, and a socket file is no proof of a daemon, so the spec probes it with a real connect: a file that refuses connections is a leftover and is removed, a daemon is started only when nothing serves, and only a daemon this spec started is stopped, with its socket removed. Timing numbers are reported by `script/perf-report.sh`, never asserted here. Prints one summary line, for the idle scenario only (`idle: startuptime=... plugins_loaded=... load_sum=...`) |
| `perf/trace_export_spec.lua` | `script/perf-trace.lua` — the Perfetto/Chrome trace-event exporter: runs it end-to-end (the exporter spawns its own full-config child, fires UIEnter manually to arm the warmup, and merges the `--startuptime` log with lazy.nvim per-plugin loads, warmup `tick_ms` and, through `--ui-latency`, a real `script/ui-latency.lua --json` run), then pins the output contract — the file round-trips through `vim.json.decode`, top level is `{traceEvents, displayTimeUnit="ms"}`, every event carries name/ph/ts/pid/tid with `dur` on `ph="X"`, ts is sane µs (0 ≤ ts < 10⁹) and non-decreasing per tid, every source contributed ≥1 event, the lazy.nvim anchors sit on the log's wall-clock axis (`args.clock = "wall"`), and every pair of complete slices on a tid is nested or disjoint (also on a synthetic case through `script/lib/trace_nesting.lua`). When `util.prefix("perfetto", "trace_processor_shell")` exists the trace must also import with zero overlapping complete events. Durations are reported, never asserted |
| `perf/ui_latency_spec.lua` | Embed UI latency client smoke — runs `script/ui-latency.lua --clean --socket-free` end to end via `vim.system` (60 s bound): the msgpack-RPC UI attaches to a spawned `nvim --embed -u NONE -i NONE`, `attach_to_first_flush_ms` and `input_to_flush_ms_median` parse from stdout inside the generous (0, 5000) ms smoke bounds, and the script exits 0 (deadline plumbing never hangs). Timing numbers are reported by `script/perf-report.sh`, never asserted here |
| `perf/warmup_spec.lua` | `lua/config/warmup.lua` — the cooperative insert-stack warmup. Most blocks drive it through injected recorder deps (fake lazy.load / is_loaded / scheduler / tagger, so no real plugin loads): unit shape (7-plugin order, blink.cmp terminal), one-plugin-load-per-scheduled-tick discipline, the InsertEnter abort flag before and between ticks, already-loaded skip + terminal short-circuit idempotency, non-fatal prewarm failures, fatal plugin-load failures, the `vim.g.warmup_loaded` tag shape, and UIEnter arming via `exec_autocmds`. The last block boots full-config child sessions, each on a throwaway ShaDa copy from `script/lib/throwaway_shada.lua`: the warmup path and the plain InsertEnter load path must end in the same state (Go quote-swap maps, autopairs BS/CR maps, snippet counts, a loaded blink.cmp), and every warmup tick's minimum over up to three runs must fit the 8 ms budget (a timing assert kept on purpose, see below) |

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
  A spec whose module is a repo-root `lsp/<server>.lua` also adds
  `vim.fn.getcwd() .. "/?.lua"` (after the two `lua/` entries), so
  `require("lsp.jsonls")` resolves to `lsp/jsonls.lua`. Then plain
  `do ... end` blocks calling local `assert_equal`/`assert_truthy`/
  `assert_falsy`/`assert_deep_equal` helpers (each spec redefines these
  locally — there is no shared test-helper module) or bare `assert()`/
  `error()`.
- Specs must be run from the repo root (`vim.fn.getcwd()` must resolve to
  `.nvim/`) — `-u NONE` skips the user's real init.lua so the spec's own
  `runtimepath`/`package.path` setup is what makes `require()` work at all.
  On this machine `~/.config/nvim` is a symlink to this repo, and `-u NONE`
  keeps it on the default runtimepath, where Nvim's `lua/` loader finds a
  module before the spec's `package.path` does. A spec run from a copy of
  the tree (a `git archive` of an old revision) therefore loads the LIVE
  checkout's modules and can pass against code it never ran. To test a
  copy, point `XDG_CONFIG_HOME` at an empty directory, from the copy's root:
  `cd <copy> && XDG_CONFIG_HOME="$(mktemp -d)" nvim --headless -u NONE -i NONE -l tests/<name>_spec.lua`.
  `--clean` also drops `~/.config/nvim`, but it sources the builtin
  runtime plugins (matchparen, netrw, ...) that `-u NONE` never loads, so
  the spec no longer runs as documented.
- The exit status is the verdict. A spec that prints a closing line prints
  it last (`ALL PASS: <spec>`, `OK: ...`, or a summary such as `hl parity:
  ...`); more than half print nothing on success, so read the exit
  status, never the output alone.
- Insert mode: an `-l` script cannot enter Insert mode and carry on
  (`startinsert` and `nvim_input` act only once the script yields, and
  `feedkeys("i", "x!")` returns only when Insert mode ends). A spec that
  needs Insert mode runs its checks in a callback scheduled onto the
  Insert-mode input loop, which feeds the `<Esc>` itself, and registers a
  `VimLeavePre` guard that turns any exit before its last assertion into
  exit 1 (it ends with `finished = true` and `os.exit(0)`). Copy
  `in_insert_mode()` and the guard from `chrome_spec.lua` or
  `auto_hlsearch_on_key_spec.lua`: before this pattern both specs ended at
  their first `feedkeys("i", "x!")` with exit 0 and skipped everything
  after it.
- Timing is reported by `script/perf-report.sh`, never asserted — except two
  budgets kept on purpose: `chrome_spec.lua` (module load under 1.5 ms) and
  `perf/warmup_spec.lua` (8 ms per warmup tick, the minimum over up to three
  runs). `chrome_spec.lua` times its own first `require`; only when that is
  over budget does it time one `require` in each of up to five fresh
  `nvim -u NONE -i NONE -l` children (the spec re-run with `--load-sample`),
  stopping at the first one within budget, and the minimum over all samples
  decides. A second `require` in the same process is not a sample: it costs
  about a third of a first load. The spec prints every sample.
- No mocking framework: specs build small hand-rolled fake tables
  (fake `ft`/`provider`/`utils`/`query` objects) matching just the shape the
  module under test calls into, or stub a plugin through
  `package.preload` — follow that pattern rather than pulling in a mocking
  library.
- Compat specs (`neo_tree_compat`, `snacks_compat`,
  `ts_context_commentstring_compat`) exist because upstream plugins hit a
  specific, reproducible Neovim/Tree-sitter error. The neo-tree and snacks
  matchers pin the exact error string they patch around
  (`find(..., 1, true)` substring checks) — if the upstream error message
  changes, the matcher and its spec need to change together.
- Specs that touch the real filesystem or environment instead of pure fakes:
  temp files and trees (`goasm_filetype`, `filetype_rules`,
  `markdown_oxide`, the `jsonls_*` fixtures, `conform_taplo`,
  `conform_oxfmt_json5`), environment variables (`rustaceanvim_cargo_config`
  sets `XDG_CONFIG_HOME`,
  `go_build_cache_filetype` sets `XDG_CACHE_HOME`, `copilot_config` sets
  `BUN_INSTALL` and `PATH`, `ui_mode` sets `XDG_STATE_HOME` and
  `NVIM_UI_MODE`, `util_prefix` sets `BUN_INSTALL`, `NODENV_ROOT` and
  `PATH`), real binaries (`conform_hujsonfmt`, the `asm_lsp_root`, `jsonls_*` and
  `markdown_oxide` live halves) and child processes (the `perf/` specs).
  Temp paths come from `vim.fn.tempname()`, inside Neovim's per-process
  temp dir, which Neovim removes on exit (after `os.exit()` too); a spec
  that uses `vim.uv.os_tmpdir()` directly (`chrome_spec`, `ui_mode_spec`)
  deletes its dir itself. `rustaceanvim_cargo_config`, `go_build_cache_filetype`,
  `copilot_config` and `util_prefix` restore the
  variables they change, and `goasm_filetype`, `rustaceanvim_cargo_config`,
  `go_build_cache_filetype` and `util_prefix` clean up even on failure via
  `pcall`.
  `rustaceanvim_cargo_config` and `go_build_cache_filetype` resolve their
  temp dirs through `vim.uv.fs_realpath` before comparing with
  `util.xdg_*_home()`, which resolves symlinks: on macOS `tempname()` sits
  under `/var`, itself a link to `/private/var`.
- A perf spec whose children boot the full config (`startup_budget`,
  `warmup`, `trace_export`) runs with `XDG_STATE_HOME` pointed at a scratch
  dir, so no child can write the real ShaDa or state files.

### Testing Requirements
Run any spec with:
`nvim --headless -u NONE -i NONE -l tests/<name>_spec.lua`
and a `perf/` spec with
`XDG_STATE_HOME=<scratch> nvim --headless -u NONE -i NONE -l tests/perf/<name>_spec.lua`.
Exit status 0 means pass; a thrown `error()` prints a traceback and exits
non-zero. No runner script exists; loop over the files, e.g.
`for f in tests/*_spec.lua tests/perf/*_spec.lua; do XDG_STATE_HOME=<scratch> nvim --headless -u NONE -i NONE -l "$f" >/dev/null 2>&1 || echo "FAIL: $f"; done`.
When adding a spec, follow the naming convention `<module_or_topic>_spec.lua`
and add its row to the table above.

### Common Patterns
- One spec file per module under test, named `<module>_spec.lua`.
- Tests are structured as a sequence of independent `do ... end` blocks
  within a single file (no `describe`/`it` nesting), each covering one
  behavior with an inline descriptive failure message as the last argument
  to the assert helper. Equality helpers (`assert_equal`, `assert_eq`,
  `assert_deep_equal`) take the expected value first and the actual one
  second, in every spec.
- Modules under test expose small, pure, dependency-injected functions
  (e.g. `make_imectl_callback(executable, jobstart)`,
  `patch_quickfile_module(quickfile, deps)`) specifically so specs can pass
  fakes instead of touching real Neovim/plugin state — preserve that
  injectable-dependency shape when adding new compat/patch functions so
  they stay testable this way.

## Dependencies

### Internal
Tests directly `require()`:
- `lua/config/autocmd.lua`, `lua/config/chrome.lua`, `lua/config/ui_mode.lua`
- `lua/plugins/conform.lua` (with `conform.nvim` on the runtimepath),
  `lua/plugins/copilot.lua`, `lua/plugins/lint.lua`,
  `lua/plugins/neo_tree_compat.lua`, `lua/plugins/rustaceanvim.lua`,
  `lua/plugins/snacks_compat.lua`, `lua/plugins/treesitter_selection.lua`,
  `lua/plugins/ts_context_commentstring_compat.lua`, and
  `lua/plugins/lualine.lua` + `lua/plugins/bufferline.lua` (`ui_mode_spec`)
- `lua/lsp/init.lua`, `lua/lsp/capabilities.lua`, `lua/lsp/on_attach.lua`
- `lsp/asm_lsp.lua`, `lsp/jsonls.lua`, `lsp/markdown_oxide.lua` (repo-root native lsp/ dir)
- `lua/filetypes/goasm.lua`, `lua/nvim-treesitter/parsers.lua`,
  `lua/util/init.lua`

`filetype_rules_spec.lua` and `go_build_cache_filetype_spec.lua` `dofile`
the repo-root `filetype.lua`, which pulls in `lua/util/init.lua` and
`lua/filetypes/goasm.lua`; `luasnippets_parse_spec.lua` `dofile`s every
`lua/luasnippets/*.lua`. The perf specs `dofile`
`script/lib/throwaway_shada.lua` (`startup_budget`, `warmup`),
`script/lib/trace_nesting.lua` (`trace_export`) and
`script/lib/stall_probe.lua` (`metrics_probe`), and run `script/hl-dump.lua`, `script/perf-trace.lua` and
`script/ui-latency.lua` as child processes. `go_injections_spec.lua` puts
the repo's `after/` on the rtp and reads `after/queries/go/injections.scm`
through `vim.treesitter.query`.

### External
- `nvim` binary on `PATH` to run the specs (`nvim --headless -u NONE -i NONE -l ...`).
- Installed plugins under lazy.nvim's root for the specs that load them:
  `conform.nvim`, `schemastore.nvim`, `blink.cmp` + `blink.lib`, `LuaSnip`,
  `nvim-treesitter` (and the tree-sitter-hujson parser; the go, sql and
  json parsers under `tree-sitter-main/parser/` for `go_injections_spec`),
  `lualine.nvim` + `bufferline.nvim`, `nvim-web-devicons`. Specs that print
  SKIP degrade without theirs; the others fail with an install hint.
- Binaries for the live halves: `vscode-json-language-server`,
  `markdown-oxide`, `hujsonfmt`, `asm-lsp`.
- `perf/startup_budget_spec.lua` additionally requires the full plugin set
  installed (it boots the real config) and a `gopls` binary for the daemon.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
