<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/plugins

## Purpose
`init.lua` returns the single `LazySpec` table consumed by lazy.nvim's
`require("config.lazy")` bootstrap. Nearly every entry sets `lazy = true`
(the repo default) with the narrowest applicable trigger — `cmd`, `ft`,
`keys`, or `event` — and defers its actual setup to a sibling
`lua/plugins/<name>.lua` module via `config = function() require("plugins.<name>") end`
(a few plugins instead pass the module's return value straight through as
`opts`). Several plugin specs in `init.lua` are commented out wholesale
(avante.nvim, obsidian.nvim, older copilot.lua variants); their
config modules remain on disk as dead code — see the orphaned-file notes
below and in each row's description.

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Full `LazySpec` table (~48 plugin specs); dispatches to `require("plugins.<name>")`; several specs commented out |
| `aerial.lua` | stevearc/aerial.nvim: symbol outline; lsp/treesitter/markdown/asciidoc/man backends, `prefer_left` placement |
| `blink.lua` | saghen/blink.cmp (v2, main branch + blink.lib): LuaSnip preset, blink-copilot source, rust fuzzy built from source |
| `bqf.lua` | kevinhwang91/nvim-bqf: better quickfix; rounded auto-preview window, 60/30-line preview heights |
| `chatgpt.json` | Prompt-template data for `chatgpt.lua`; DEAD — no `ChatGPT.nvim` spec exists in `init.lua` |
| `chatgpt.lua` | jackMort/ChatGPT.nvim config; API key via `op read op://...`; DEAD — no active spec references it |
| `claudecode.lua` | coder/claudecode.nvim: Claude Code IDE bridge; `terminal_cmd` launches `omc --yolo` in a snacks float |
| `codecompanion.lua` | olimorris/codecompanion.nvim: chat/inline AI; anthropic adapter, mcphub + codecompanion-history extensions |
| `codecov.lua` | zchee/codecov.nvim (local plugin) setup: coverage sign colors, api.codecov.io endpoint, token via CODECOV_NVIM_API_TOKEN |
| `conform.lua` | Options table for stevearc/conform.nvim; none-ls formatting successor (stylua/rustfmt/yamlfmt/terraform_fmt/taplo + goimports-rereviser), manual format via <LocalLeader>f; TOML goes through taplo (`~/.config/taplo/taplo.toml`, whose `[[rule]]` blocks replaced the tombi cwd-routing hack -- tombi's format rules are global only; tombi stays LSP-only), and a project's own `.taplo.toml` suppresses `--config`; `lsp_organize_imports` Lua formatter leads the Go chain (source.organizeImports, the one thing rereviser cannot do); `json5` goes through oxfmt because vscode-json-language-server has no JSON5 mode and mangles such a buffer through the LSP fallback (it injects a space inside `'https://...'`) -- `oxfmt_config()` always passes `--config` (a project `.oxfmtrc.*` found upward, else `~/.config/oxfmt/.oxfmtrc.jsonc`, since oxfmt's own search fails silently into defaults that rewrite every single-quoted string) and `oxfmt_stdin_path()` appends `.json5` to an extensionless name such as `.renovaterc`, which oxfmt otherwise rejects with exit 1; `format_on_save` reads a pinned `lsp_format = "never"` back out of `formatters_by_ft` because conform only consults that entry for keys the caller leaves nil |
| `copilot-chat.lua` | Options table for CopilotC-Nvim/CopilotChat.nvim; claude-opus-4.6 model, ReviewStaged/ReviewUnstaged git-diff prompts |
| `copilot.lua` | zbirenbaum/copilot.lua; go/lua/sh allowlist, `copilot_model = "gpt-41-copilot"`, Keychain-encryption opt-out; tested by `tests/copilot_config_spec.lua` |
| `crates.lua` | Options table for saecki/crates.nvim; LSP mode with `<Leader>rc*` keymap group bound in `lsp.on_attach` |
| `dap.lua` | mfussenegger/nvim-dap + mason-nvim-dap + nvim-dap-go; ensures delve/js/python adapters via Mason |
| `diagram.lua` | 3rd/diagram.nvim: Mermaid/PlantUML/D2/gnuplot rendering in Markdown buffers via image.nvim |
| `diffview.lua` | sindrets/diffview.nvim setup: horizontal diff2 layout, winbar info, conflict-choose keymaps via diffview.actions |
| `dropbar.lua` | Bekaboo/dropbar.nvim: winbar breadcrumbs (lspsaga symbol_in_winbar successor); pick on <Leader>; |
| `dressing.lua` | stevearc/dressing.nvim: `vim.ui.input`/`select` overrides; DEAD — plugin loads as a bare dependency, `setup()` never runs |
| `fidget.lua` | j-hui/fidget.nvim: LSP progress UI; effectively stock defaults, prior tuned config left commented above it |
| `focus.lua` | nvim-focus/focus.nvim (owner unconfirmed in repo): autoresize focused split; DEAD — no plugin spec anywhere |
| `gemini.lua` | Gemini AI completion/inline-hints plugin (`require("gemini")`, owner unconfirmed); DEAD — no plugin spec anywhere |
| `github-preview.lua` | wallpants/github-preview.nvim: live Markdown preview server bound to `127.0.0.1:6041` |
| `gitsigns.lua` | lewis6991/gitsigns.nvim; overrides default sign highlight groups with custom fg/bg hex colors |
| `image.lua` | 3rd/image.nvim `opts` table (kitty backend); integration toggles nested under `integrations`, sizing keys top-level |
| `lint.lua` | mfussenegger/nvim-lint setup; none-ls diagnostics successor (ruff, golangci-lint pinned past the mise shim), FileType-triggered |
| `mason.lua` | williamboman/mason.nvim; minimal setup — 8 concurrent installers, `github:mason-org/mason-registry` |
| `matchup.lua` | andymass/vim-matchup; disables built-in matchparen (`matchparen.enabled = 0`) in favor of Tree-sitter matching |
| `mcphub.lua` | ravitemer/mcphub.nvim: MCP server hub; DEAD in `init.lua`'s active path — plugin loads bare, `setup()` never called |
| `metafrastis.lua` | zchee/metafrastis.nvim (local plugin): translation popup; DeepL provider, disk+memory cache with USD cost guard |
| `neo-tree.lua` | nvim-neo-tree/neo-tree.nvim; patches cursor-hijack via `neo_tree_compat`; filesystem/buffers/git_status/document_symbols sources |
| `neo_tree_compat.lua` | Internal shim guarding neo-tree's cursor-hijack handler against `Invalid 'win'` errors |
| `obsidian.lua` | obsidian-nvim/obsidian.nvim: "knowledge" vault, snacks.pick picker; DEAD — spec fully commented out in `init.lua` |
| `oil.lua` | Options table for stevearc/oil.nvim; `default_file_explorer = true` with icon/permissions/size/mtime columns |
| `render-markdown.lua` | MeanderingProgrammer/render-markdown.nvim; renders `markdown`/`Avante`/`codecompanion`/`copilot-chat` filetypes |
| `rustaceanvim.lua` | mrcjkb/rustaceanvim; keymaps bound on `LspAttach`, not `server.on_attach`, so the global on_attach can't clobber them; `analysis_rustflags()` strips the shell's release RUSTFLAGS down to target-cpu/target-feature for rust-analyzer's own build-script/proc-macro builds (cold start 68.2s -> 12.2s on ganja-code); `rust_analyzer_cmd()` routes rust-analyzer through github.com/zchee/lspmux — the scratch-rewritten single-active-client handoff daemon, NOT the upstream 0.3 multiplexer whose shared instance broke textDocument/definition — auto-spawns the daemon (log at stdpath("log")/lspmux.log), resolves the server binary with `rustup which` run from the crate root so a project's `rust-toolchain.toml` picks the matching rust-analyzer (`RUSTUP_AUTO_INSTALL=0` keeps an uninstalled pin from blocking nvim on a download), falls back to `rustup run nightly rust-analyzer`, is passed as a *function* so probes stay off the startup path, and `RUSTACEANVIM_NO_LSPMUX=1` bypasses it; `cargo_dev_config_path()` takes `rust/config.dev.toml` under `util.xdg_config_home()` (tmpfs target-dir, incremental off) and puts it on every cargo rust-analyzer spawns through `cargo.configPath` — absolute because cargo expands no `~` and rust-analyzer resolves a relative path against the crate root — omitted when the file does not resolve, since an unreadable `--config` fails `cargo metadata` and loses the client, not just the check; `analysis_target_dir()` keeps analysis out of the build directory that config names, since an environment variable beats a `--config` value and so `CARGO_TARGET_DIR` wins over the file's `build.target-dir` — `/Volumes/tmpfs/target-rust-analyzer` where that mount exists (same fast I/O, its own lock: cargo locks a build directory exclusively and `checkOnSave` keeps clippy running most of the time), the relative `target/rust-analyzer` where it does not, because cargo would otherwise create a real directory under an absent mount point per crate; hover floats do not steal focus (`float_win_config.auto_focus = false`) |
| `satellite.lua` | lewis6991/satellite.nvim scrollbar (nvim-scrollbar successor); diagnostics/gitsigns/search handlers, no cursor/marks |
| `smart-splits.lua` | mrjones2014/smart-splits.nvim: multiplexer-aware split nav/resize; DEAD — no plugin spec anywhere in `init.lua` |
| `snacks.lua` | folke/snacks.nvim; quickfile race patch via `snacks_compat`; `words` enabled (replaces vim-illuminate) with <M-n>/<M-p> jumps |
| `snacks_compat.lua` | Internal shim working around a snacks.quickfile Tree-sitter "Decoration provider" race on fast buffer loads |
| `telescope.lua` | nvim-telescope/telescope.nvim; custom `fd`-based `find_files` excluding `.git`/`_tmp`, `live_grep` scoped to LSP workspace roots |
| `todo-comment.lua` | Options table for folke/todo-comments.nvim; consumed as `opts = require("plugins.todo-comment")`, not via `config` |
| `todo.lua` | Legacy TODO-highlighter (`require("todo")`, distinct from todo-comments.nvim); DEAD — superseded by `todo-comment.lua` |
| `toggleterm.lua` | akinsho/toggleterm.nvim; custom `<LocalLeader>t` `open_mapping`; DEAD — no plugin spec exists in `init.lua` at all |
| `tree-sitter.lua` | nvim-treesitter (main branch): FileType-driven `vim.treesitter.start()`/indentexpr, install_dir `tree-sitter-main`, :TSEnsureInstalled |
| `tree.lua` | nvim-tree/nvim-tree.lua config; DEAD — superseded by the inline `stevearc/oil.nvim` spec in `init.lua` |
| `treesitter_parsers.lua` | Parser list for :TSEnsureInstalled (ported master ensure_installed) |
| `treesitter_selection.lua` | Hand-rolled incremental selection (gnn/grn/grm/grc); replaces the removed master module; tested by `tests/treesitter_selection_spec.lua` |
| `ts_context_commentstring.lua` | JoosepAlviste/nvim-ts-context-commentstring; sets `vim.g.skip_ts_context_commentstring_module` |
| `ts_context_commentstring_compat.lua` | Internal shim guarding `is_treesitter_active` against a nil Tree-sitter parser |
| `which-key.lua` | Options table for folke/which-key.nvim (modern preset, custom icon glyphs); consumed as `opts = require(...)` |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `avante/` | `init.lua` (yetone/avante.nvim opts: agentic mode, claude provider, claude+gemini dual_boost) and `keys.lua` (dynamic lazy `keys` pulled from the spec's `opts.mappings`) — documented here, no separate AGENTS.md. Both files are DEAD: the only `yetone/avante.nvim` lazy specs in `init.lua` referencing `plugins.avante`/`plugins.avante.keys` are commented out (twice) |

## For AI Agents

### Working In This Directory
- To add a plugin: append a spec entry to the `LazySpec` table in `init.lua`
  with the narrowest lazy trigger available (`cmd`, `ft`, `keys`, or
  `event` — avoid `lazy = false` unless the plugin must load at startup),
  then create `lua/plugins/<name>.lua` holding the `require("<module>").setup({...})`
  call and `require("plugins.<name>")` it from the spec's `config` function.
  For local (non-GitHub) plugins use `dir = util.src_path("github.com/<owner>/<repo>")`
  instead of a short name (see the `zchee/*` entries at the top of `init.lua`).
  A repo-local skill, `.claude/skills/add-plugin`, documents this exact flow.
- The `rustaceanvim` spec (`init.lua:1533-1541`) uses `init = function() require("plugins.rustaceanvim") end`,
  not `config`/`opts`: rustaceanvim exposes no `setup()` — it reads
  `vim.g.rustaceanvim` and lazy-loads itself from its own `ftplugin`, so the
  value must be set *before* that ftplugin runs, which lazy.nvim's `config`
  hook (invoked on `VeryLazy`/first-use, after ftplugin dispatch) is too late
  for. `require("plugins.rustaceanvim")` sets `vim.g.rustaceanvim` and a
  Rust-only `LspAttach` keymap group.
- Several config modules are orphaned — present on disk but not reachable
  from any active (uncommented) spec in `init.lua`: `blink.lua`, `chatgpt.lua`
  / `chatgpt.json`, `dressing.lua`, `focus.lua`, `gemini.lua`,
  `mcphub.lua`, `obsidian.lua`, `smart-splits.lua`, `todo.lua`, `toggleterm.lua`,
  `tree.lua`, and `avante/init.lua` / `avante/keys.lua`. Do not assume a file's
  presence means it is wired up — grep `init.lua` for
  `require("plugins.<name>")` outside a `--` comment before relying on one.

### Testing Requirements
- `nvim --headless "+Lazy! sync" +qa` bootstraps or updates all plugins named
  in `init.lua` — the baseline check after any spec change.
- `nvim --headless -u NONE -l tests/<name>_spec.lua` runs a headless
  regression spec. The specs covering this directory's `*_compat.lua` shims
  and dead-but-tested modules are: `tests/comment_compat_spec.lua`,
  `tests/copilot_config_spec.lua`, `tests/illuminate_compat_spec.lua`,
  `tests/neo_tree_compat_spec.lua`, `tests/snacks_compat_spec.lua`,
  `tests/treesitter_compat_spec.lua`, `tests/ts_context_commentstring_compat_spec.lua`.
  Each spec appends the repo root to `runtimepath`/`package.path` and asserts
  against the module directly — no plenary/busted runner is configured, they
  run as plain Lua under `nvim -l`.
- `nvim --clean --headless -l <file>` (via `loadfile()`/`dofile()`-style
  checks) is the quick syntax check for an edited module before running the
  full specs above.

### Common Patterns
- Setup-call modules: `config = function() require("plugins.<name>") end` in
  `init.lua`, and the module itself does `local x = require("<upstream>"); x.setup({...})`.
- Options-table modules: the module returns a plain table (no `setup()`
  call) and `init.lua` consumes it as `opts = require("plugins.<name>")`
  (e.g. `todo-comment.lua`).
- `keys` tables carry `<Leader>...` mappings with a `desc` field per entry;
  `cmd` tables list every user command the spec should lazy-load on.
- `event` triggers cluster around `VeryLazy`, `LspAttach`, `BufReadPost`, and
  `BufNewFile`; `ft` triggers are used for single-filetype plugins.
- `vim.g.*` globals are sometimes set before `require("<plugin>")` when the
  plugin reads them at load time rather than via `setup()` (`matchup.lua`
  sets `vim.g.matchup_no_version_check`; `rustaceanvim.lua`'s caller sets
  `vim.g.rustaceanvim`).
- `*_compat.lua` modules (`comment_compat`, `illuminate_compat`,
  `neo_tree_compat`, `snacks_compat`, `treesitter_compat`,
  `ts_context_commentstring_compat`) are internal shims with no upstream
  repo: each monkey-patches one upstream plugin's internals to guard against
  a specific nightly-Neovim crash, and each is paired 1:1 with a
  `tests/<name>_spec.lua`.

## Dependencies

### Internal
- `lua/util` (`require("util")`) supplies `util.src_path()` for local plugin
  `dir =` entries, `util.homebrew_binary()`/`util.bun_prefix()`/`util.go_path()`
  for resolving LSP/tool binaries referenced from plugin configs (e.g.
  `dap.lua`'s delve path, `copilot.lua`'s node binary), and
  `util.xdg_config_home()` for `rustaceanvim.lua`'s cargo dev config (it is
  `fs_readlink`-based, so it answers with the symlink target and with `""` for
  a real directory or an unset `XDG_CONFIG_HOME`).
- `lua/lsp` interplay: `rustaceanvim.lua` deliberately owns the
  `rust-analyzer` client instead of `lua/lsp/rust_analyzer.lua` (per the
  repo's LSP conventions);
  `garbage-day.nvim`'s `excluded_lsp_clients` in `init.lua` references the
  `rust-analyzer` client name rustaceanvim registers.
- `lua/config` supplies `vim.opt`/keymap/autocmd baseline that many specs'
  `keys` tables and `config` functions assume is already loaded.

### External
- [lazy.nvim](https://github.com/folke/lazy.nvim) — the plugin manager this
  entire directory's `LazySpec` table targets.
- Major plugin ecosystems wired here: nvim-treesitter (parsing/highlighting),
  blink.cmp v2 + blink.lib (completion; rust fuzzy matcher built from source),
  nvim-dap + Mason (debugging), Telescope + snacks.nvim (pickers/UI), Git
  tooling (gitsigns, diffview.nvim, fugit2.nvim), and AI assistants
  (claudecode.nvim, codecompanion.nvim, CopilotChat.nvim, codex.nvim, and
  the currently-dead avante.nvim).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
