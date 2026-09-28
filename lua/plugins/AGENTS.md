<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# lua/plugins

## Purpose
`init.lua` returns the single `LazySpec` table consumed by lazy.nvim's
`require("config.lazy")` bootstrap. Nearly every entry sets `lazy = true`
(the repo default) with the narrowest applicable trigger — `cmd`, `ft`,
`keys`, or `event` — and defers its actual setup to a sibling
`lua/plugins/<name>.lua` module, either as a setup module
(`config = function() require("plugins.<name>") end`) or as an options
table handed over in function form
(`opts = function() return require("plugins.<name>") end`). Specs that are
switched off stay in `init.lua` commented out (commented code is kept by
convention); their config modules were deleted in the optimize-branch
cleanup, so every module below is live.

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Full `LazySpec` table; dispatches to `require("plugins.<name>")`; switched-off specs stay commented out |
| `actions_preview.lua` | aznhe21/actions-preview.nvim: code-action preview with delta/diff-so-fancy/diff-highlight diffs, snacks picker backend (nui fallback); loads on `LspAttach` |
| `aerial.lua` | stevearc/aerial.nvim: symbol outline; lsp/treesitter/markdown/asciidoc/man backends, `prefer_left` placement; `lazy_load = false` so `on_attach` maps `{`/`}` (AerialPrev/Next) from the first opened file |
| `autopairs.lua` | windwp/nvim-autopairs setup, run from the spec config (its own warmup tick): `check_ts` with the Go string node names tree-sitter-go actually has, a Go-only `[` rule, and the buffer-local Go quote swap (`"` pairs `''` inside a Go string and vice versa) registered after `setup()` so it wins over the plugin's own maps |
| `blink.lua` | saghen/blink.cmp (v2, main branch + blink.lib): LuaSnip preset, blink-copilot source, rust fuzzy built from source |
| `bqf.lua` | kevinhwang91/nvim-bqf: better quickfix; rounded auto-preview window, 60/30-line preview heights |
| `bufferline.lua` | akinsho/bufferline.nvim; `numbers = "buffer_id"`, `nvim_lsp` diagnostics indicator. Only loaded in the `plugins` ui mode (`lua/config/ui_mode.lua`); `lua/config/chrome.lua` draws the tabline by default |
| `codecov.lua` | zchee/codecov.nvim (local plugin) setup: coverage sign colors, api.codecov.io endpoint, token via CODECOV_NVIM_API_TOKEN, `log_level = vim.log.levels.INFO` |
| `conform.lua` | Options table for stevearc/conform.nvim; none-ls formatting successor (stylua/rustfmt/yamlfmt/terraform_fmt/taplo + goimports-rereviser), manual format via <LocalLeader>f; TOML goes through taplo (`~/.config/taplo/taplo.toml`, whose `[[rule]]` blocks replaced the tombi cwd-routing hack -- tombi's format rules are global only; tombi stays LSP-only), and a project's own `.taplo.toml` suppresses `--config`; `lsp_organize_imports` Lua formatter leads the Go chain (source.organizeImports, the one thing rereviser cannot do); `json5` goes through oxfmt because vscode-json-language-server has no JSON5 mode and mangles such a buffer through the LSP fallback (it injects a space inside `'https://...'`) -- `oxfmt_config()` always passes `--config` (a project `.oxfmtrc.*` found upward, else `~/.config/oxfmt/.oxfmtrc.jsonc`, since oxfmt's own search fails silently into defaults that rewrite every single-quoted string) and `oxfmt_stdin_path()` appends `.json5` to an extensionless name such as `.renovaterc`, which oxfmt otherwise rejects with exit 1; `hujson` goes through `hujsonfmt` (`~/go/bin`, from `go install github.com/tailscale/hujson/cmd/hujsonfmt@latest`; stdin to stdout, tab indent, aligned values) with `lsp_format = "never"`, because jsonls formats HuJSON to a different layout and a machine without hujsonfmt would otherwise rewrite the whole file on save; its `command` is a function that hands a whitespace-only buffer to `cat` instead, since hujsonfmt exits 1 on input with no value and the first `:w` of a new file raised "Formatter failed" (a `condition` would make conform report "Formatters unavailable", which reads as a missing binary); `format_on_save` reads a pinned `lsp_format` back out of `formatters_by_ft` (`"never"` for json5/hujson, `"first"` for go/goasm) because conform only consults that entry for keys the caller leaves nil |
| `copilot.lua` | zbirenbaum/copilot.lua: runs the native `copilot-language-server` binary from bun's global install (`@github/copilot-language-server-<os>-<arch>`, resolved from `os_uname()`; one ERROR and no `setup()` when it is missing), so setup spawns no `node --version`; `filetypes["*"] = true` with a `should_attach` that rejects unnamed, unlisted and special-buftype buffers; `copilot_model = "gpt-41-copilot"`; Keychain token-encryption opt-out; tested by `tests/copilot_config_spec.lua` |
| `crates.lua` | Options table for saecki/crates.nvim; LSP mode with `<Leader>rc*` keymap group bound in `lsp.on_attach` |
| `dap.lua` | mfussenegger/nvim-dap + mason-nvim-dap + nvim-dap-go/-docker/-virtual-text + dap-ui; ensures delve/js/python adapters via Mason; lldb and bash (`bash-debug-adapter`, mason-nvim-dap's launch fields) adapters resolved on PATH; `<LocalLeader>dp`/`dc` are spec `keys` |
| `diagram.lua` | 3rd/diagram.nvim: Mermaid/PlantUML/D2/gnuplot rendering in Markdown buffers via image.nvim; loaded only by `:DiagramToggle` (`lua/config/command.lua`) |
| `diffview.lua` | sindrets/diffview.nvim setup: horizontal diff2 layout, winbar info, conflict-choose keymaps via diffview.actions |
| `dropbar.lua` | Bekaboo/dropbar.nvim: winbar breadcrumbs (lspsaga symbol_in_winbar successor); pick on <Leader>; |
| `fidget.lua` | j-hui/fidget.nvim: LSP progress UI with one notification group per client, `poll_rate = 0`, borderless window at `winblend = 100`; leaves `vim.notify` to snacks (`override_vim_notify = false`); loads on `LspAttach` |
| `github-preview.lua` | wallpants/github-preview.nvim: live Markdown preview server bound to `127.0.0.1:6041`; loads on its `GithubPreview*` commands |
| `gitsigns.lua` | lewis6991/gitsigns.nvim; sign texts only (its highlight groups live in `colors/equinusocio_material.lua`), blame/preview options, buffer-local hunk keymaps |
| `hover.lua` | lewis6991/hover.nvim: diagnostic/lsp/dap/man/dictionary providers, rounded border, lsp-only mouse hover; loads on `LspAttach` |
| `image.lua` | 3rd/image.nvim `opts` table (kitty backend); integration toggles nested under `integrations`, sizing keys top-level |
| `lint.lua` | mfussenegger/nvim-lint setup; none-ls diagnostics successor: ruff for python; golangci-lint's `cmd` stays pinned to `~/go/bin` (past the mise shim) but its `go` entry is commented out until its runs pass (13cd8e9); `FileType`/`BufWritePost` lint immediately, `InsertLeave` is debounced 500 ms per buffer; tested by `tests/lint_debounce_spec.lua` |
| `lsp_endhints.lua` | chrisgrieser/nvim-lsp-endhints: end-of-line inlay hints for `*.lua`/`*.py`; `setup()` runs once on the first matching `LspAttach`, from an augroup so lazy.nvim replays the attach that loaded it |
| `lualine.lua` | nvim-lualine/lualine.nvim; `equinusocio_material` theme, disables statusline/winbar for the snacks picker input filetype. Only loaded in the `plugins` ui mode (`lua/config/ui_mode.lua`); `lua/config/chrome.lua` draws the statusline by default |
| `luasnip.lua` | L3MON4D3/LuaSnip setup and snippet loader: `from_lua` over `stdpath("config")/lua/luasnippets` one filetype at a time (`load_snippets_ft`); the driver sets (`go`, `all`) load eagerly (by `config.warmup` ticks when a warmup runs), every other filetype on its first `InsertEnter` (`luasnip_ft_snippets` augroup); returns the loader module that `plugins/blink.lua` and `config.warmup` call |
| `mason.lua` | williamboman/mason.nvim; minimal setup — 8 concurrent installers, `github:mason-org/mason-registry` |
| `matchup.lua` | andymass/vim-matchup: `matchparen.enabled = 0` turns off match-up's own match highlighting (the built-in matchparen is already off: match-up clears it and lazy.nvim disables the rtp plugin); `%` motions and Tree-sitter matching stay on. `vim.g.matchup_no_version_check` is set here, after `plugin/matchup.vim` ran, which only matters for the Vim < 7.4 guard it skips |
| `metaphrast.lua` | zchee/metaphrast.nvim (local plugin): translation popup; default provider `google_llm`, with deepl/google/openai/gemini/openrouter entries; disk+memory cache with a USD cost guard; env names `METAPHRAST_*` first, the pre-rename `METAFRASTIS_*` as fallback, `GOOGLE_CLOUD_PROJECT` first for the google provider's project |
| `neo-tree.lua` | nvim-neo-tree/neo-tree.nvim; patches cursor-hijack via `neo_tree_compat`; filesystem/buffers/git_status/document_symbols sources; shared `window.mappings` (e.g. `s` = open_split) under each source's own mappings |
| `neo_tree_compat.lua` | Internal shim guarding neo-tree's cursor-hijack handler against `Invalid 'win'` errors |
| `render-markdown.lua` | MeanderingProgrammer/render-markdown.nvim; renders `markdown` buffers, blink completions enabled |
| `rustaceanvim.lua` | mrcjkb/rustaceanvim; keymaps bound on `LspAttach`, not `server.on_attach`, so the global on_attach can't clobber them; `analysis_rustflags()` strips the shell's release RUSTFLAGS down to target-cpu/target-feature for rust-analyzer's own build-script/proc-macro builds (cold start 68.2s -> 12.2s on ganja-code); `rust_analyzer_cmd()` routes rust-analyzer through github.com/zchee/lspmux — the scratch-rewritten single-active-client handoff daemon, NOT the upstream 0.3 multiplexer whose shared instance broke textDocument/definition — auto-spawns the daemon (log at stdpath("log")/lspmux.log), resolves the server binary with `rustup which` run from the crate root so a project's `rust-toolchain.toml` picks the matching rust-analyzer (`RUSTUP_AUTO_INSTALL=0` keeps an uninstalled pin from blocking nvim on a download), falls back to `rustup run nightly rust-analyzer`, is passed as a *function* so probes stay off the startup path, and `RUSTACEANVIM_NO_LSPMUX=1` bypasses it; `cargo_dev_config_path()` takes `rust/config.dev.toml` under `util.xdg_config_home()` (tmpfs target-dir, incremental off) and puts it on every cargo rust-analyzer spawns through `cargo.configPath` — absolute because cargo expands no `~` and rust-analyzer resolves a relative path against the crate root — omitted when the file does not resolve, since an unreadable `--config` fails `cargo metadata` and loses the client, not just the check; `analysis_target_dir()` keeps analysis out of the build directory that config names, since an environment variable beats a `--config` value and so `CARGO_TARGET_DIR` wins over the file's `build.target-dir` — `/Volumes/tmpfs/target-rust-analyzer` where that mount exists (same fast I/O, its own lock: cargo locks a build directory exclusively and `checkOnSave` keeps clippy running most of the time), the relative `target/rust-analyzer` where it does not, because cargo would otherwise create a real directory under an absent mount point per crate; hover floats do not steal focus (`float_win_config.auto_focus = false`) |
| `satellite.lua` | lewis6991/satellite.nvim scrollbar (nvim-scrollbar successor); diagnostic and gitsigns handlers only (cursor, search, marks, quickfix off; search cost 30-60 ms per scroll event) |
| `snacks.lua` | folke/snacks.nvim; quickfile race patch via `snacks_compat`; notifier filter drops gopls timeout/context-canceled and pull-diagnostics notices; `words` enabled (replaces vim-illuminate) with <M-n>/<M-p> jumps; owns `vim.ui.select`/`vim.ui.input` |
| `snacks_compat.lua` | Internal shim working around a snacks.quickfile Tree-sitter "Decoration provider" race on fast buffer loads |
| `telescope.lua` | nvim-telescope/telescope.nvim; `fd`-based `find_files` excluding `.git`/`_tmp`, ghq via `util.go_path`; `find_files`/`live_grep` are wrapped to run in the current buffer's first LSP workspace folder, looked up per call (a caller's own `cwd` wins); no ui-select extension, so `vim.ui.select` stays snacks' |
| `tiny_inline_diagnostic.lua` | rachartier/tiny-inline-diagnostic.nvim: "modern" preset with transparent background, source shown when several, multiline messages; loads on `LspAttach` |
| `todo-comment.lua` | folke/todo-comments.nvim setup module: options, a `snacks.picker` preload guard armed around `setup()` so todo-comments does not load the picker, and a `BufWinEnter`/`WinResized` repaint that calls the idempotent `highlight.attach()` before `_update()` so a file opened into an already-known window is painted |
| `tree-sitter.lua` | nvim-treesitter (main branch): FileType-driven `vim.treesitter.start()`/indentexpr, install_dir `tree-sitter-main`, :TSEnsureInstalled; parser routing (`hcl` for docker-bake, `cpp` for metal; zsh uses its own parser) |
| `treesitter_parsers.lua` | Parser list for :TSEnsureInstalled (ported master ensure_installed) |
| `treesitter_selection.lua` | Hand-rolled incremental selection (gnn/grn/grm/grc); replaces the removed master module; a visual mode the user starts (`ModeChanged n:[vV^V]`) resets the node stack; tested by `tests/treesitter_selection_spec.lua` |
| `ts_context_commentstring.lua` | JoosepAlviste/nvim-ts-context-commentstring; sets `vim.g.skip_ts_context_commentstring_module` |
| `ts_context_commentstring_compat.lua` | Internal shim guarding `is_treesitter_active` against a nil Tree-sitter parser |
| `which-key.lua` | Options table for folke/which-key.nvim (modern preset, custom icon glyphs); consumed in function form, `opts = function() return require("plugins.which-key") end` |

## Subdirectories
| Directory | Purpose |
|-----------|---------|

## For AI Agents

### Working In This Directory
- To add a plugin: append a spec entry to the `LazySpec` table in `init.lua`
  with the narrowest lazy trigger available (`cmd`, `ft`, `keys`, or
  `event` — avoid `lazy = false` unless the plugin must load at startup),
  then create `lua/plugins/<name>.lua` holding the `require("<module>").setup({...})`
  call and `require("plugins.<name>")` it from the spec's `config` function
  (or return an options table and pass it as
  `opts = function() return require("plugins.<name>") end`). Add its row to
  the Key Files table above.
  For local (non-GitHub) plugins use `dir = util.src_path("github.com/<owner>/<repo>")`
  instead of a short name (see the `zchee/*` entries at the top of `init.lua`).
  A repo-local skill, `.claude/skills/add-plugin`, documents this exact flow.
- The `rustaceanvim` spec in `init.lua` uses `init = function() require("plugins.rustaceanvim") end`,
  not `config`/`opts`: rustaceanvim exposes no `setup()` — it reads
  `vim.g.rustaceanvim` and lazy-loads itself from its own `ftplugin`, so the
  value must be set *before* that ftplugin runs, which lazy.nvim's `config`
  hook (invoked on `VeryLazy`/first-use, after ftplugin dispatch) is too late
  for. `require("plugins.rustaceanvim")` sets `vim.g.rustaceanvim` and a
  Rust-only `LspAttach` keymap group.
- Every config module here should be reachable from a spec in `init.lua`
  (or a compat shim consumed by `tests/`); orphaned modules were deleted in
  the optimize-branch cleanup rounds. Before relying on a file, grep
  `init.lua` for `require("plugins.<name>")` outside a `--` comment.

### Testing Requirements
- `nvim --headless "+Lazy! sync" +qa` bootstraps or updates all plugins named
  in `init.lua` — the baseline check after any spec change.
- `nvim --headless -u NONE -i NONE -l tests/<name>_spec.lua` runs a headless
  regression spec. The specs covering this directory are:
  `tests/copilot_config_spec.lua` (`copilot.lua`),
  `tests/conform_hujsonfmt_spec.lua`, `tests/conform_organize_imports_spec.lua`,
  `tests/conform_oxfmt_json5_spec.lua`, `tests/conform_taplo_spec.lua`
  (`conform.lua`), `tests/lint_debounce_spec.lua` (`lint.lua`),
  `tests/luasnippets_parse_spec.lua` (`../luasnippets/`),
  `tests/neo_tree_compat_spec.lua`, `tests/snacks_compat_spec.lua`,
  `tests/ts_context_commentstring_compat_spec.lua` (the `*_compat.lua` shims),
  `tests/rustaceanvim_cargo_config_spec.lua` (`rustaceanvim.lua`),
  `tests/treesitter_selection_spec.lua` (`treesitter_selection.lua`),
  `tests/parsers_overlay_loader_spec.lua` (`../nvim-treesitter/parsers.lua`),
  and `tests/perf/warmup_spec.lua`, whose full-config children check that the
  warmup and the lazy `InsertEnter` path configure autopairs/LuaSnip/blink
  identically. Each spec appends the repo root to `runtimepath`/`package.path`
  and asserts against the module directly — no plenary/busted runner, plain
  Lua under `nvim -l`. The `~/.config/nvim` symlink keeps the repo on the rtp
  even under `-u NONE`; run a spec with `--clean` to test a copy of a module
  outside the repo.
- `nvim --clean --headless -l <file>` (via `loadfile()`/`dofile()`-style
  checks) is the quick syntax check for an edited module before running the
  full specs above.

### Common Patterns
- Setup-call modules: `config = function() require("plugins.<name>") end` in
  `init.lua`, and the module itself does `local x = require("<upstream>"); x.setup({...})`.
- Options-table modules return a plain table (no `setup()` call) that
  `init.lua` passes in function form,
  `opts = function() return require("plugins.<name>") end` (`conform.lua`,
  `crates.lua`, `image.lua`, `which-key.lua`), so the require runs when the
  plugin loads rather than while lazy.nvim evaluates the spec at startup.
- `keys` tables carry `<Leader>...` mappings with a `desc` field per entry;
  `cmd` tables list every user command the spec should lazy-load on.
- `event` triggers cluster around `VeryLazy`, `LspAttach`, `BufReadPost`,
  `InsertEnter` and `FileType`; `ft` triggers are used for single-filetype
  plugins. A module that creates an autocmd for the event that is loading it
  must put it in an augroup: lazy.nvim replays that event only for autocmds
  in augroups the load created (`lsp_endhints.lua`).
- `vim.g.*` globals are sometimes set before `require("<plugin>")` when the
  plugin reads them at load time rather than via `setup()`
  (`rustaceanvim.lua` sets `vim.g.rustaceanvim` from the spec's `init`).
- `*_compat.lua` modules (`neo_tree_compat`, `snacks_compat`,
  `ts_context_commentstring_compat`) are internal shims with no upstream
  repo: each monkey-patches one upstream plugin's internals to guard against
  a specific nightly-Neovim crash, and each is paired 1:1 with a
  `tests/<name>_spec.lua`.

## Dependencies

### Internal
- `lua/util` (`require("util")`) supplies `util.src_path()` for local plugin
  `dir =` entries, `util.go_path()` for Go-installed tools (`dap.lua`'s delve,
  `lint.lua`'s golangci-lint, `telescope.lua`'s ghq), and
  `util.xdg_config_home()` for `rustaceanvim.lua`'s cargo dev config and
  `conform.lua`'s config paths (it is `fs_realpath`-based with a
  `$HOME/.config` fallback, so the answer is always absolute).
  `copilot.lua` reads `$BUN_INSTALL` itself to find the native server.
- `lua/lsp` interplay: `rustaceanvim.lua` deliberately owns the
  `rust-analyzer` client instead of `lua/lsp/rust_analyzer.lua` (per the
  repo's LSP conventions);
  `garbage-day.nvim`'s `excluded_lsp_clients` in `init.lua` references the
  `rust-analyzer` client name rustaceanvim registers.
- `lua/config` supplies `vim.opt`/keymap/autocmd baseline that many specs'
  `keys` tables and `config` functions assume is already loaded;
  `config/warmup.lua` loads the insert stack (mini.icons, blink.lib,
  copilot.lua, blink-copilot, nvim-autopairs, LuaSnip, blink.cmp) one tick at
  a time after `UIEnter`, and calls `luasnip.lua`'s loader.

### External
- [lazy.nvim](https://github.com/folke/lazy.nvim) — the plugin manager this
  entire directory's `LazySpec` table targets.
- Major plugin ecosystems wired here: nvim-treesitter (parsing/highlighting),
  blink.cmp v2 + blink.lib (completion; rust fuzzy matcher built from source),
  nvim-dap + Mason (debugging), Telescope + snacks.nvim (pickers/UI), Git
  tooling (gitsigns, diffview.nvim, fugit2.nvim + nvim-tinygit), and
  copilot.lua with blink-copilot as the only AI plugin.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
