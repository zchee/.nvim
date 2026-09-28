<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# lua/lsp

## Purpose
Central LSP wiring for the config. It uses Neovim's native
`vim.lsp.config()` / `vim.lsp.enable()` API exclusively — `nvim-lspconfig`
is uninstalled. Per-server configs do not live in this directory: each
server is a plain `vim.lsp.Config` table in the repo-root `lsp/` runtime
directory (`lsp/<server>.lua`). This directory owns everything
cross-cutting: diagnostics UI, the shared capabilities, the shared
`on_attach`, the `vim.lsp.enable()` list, and the global LSP keymaps. The
stack itself loads lazily: the `onsails/lspkind-nvim` spec in
`lua/plugins/init.lua` (`BufReadPre`/`BufNewFile`) runs `require("lsp")`,
since lspkind is the one plugin `init.lua` requires at load time.

The server configs are **not** lazy. `vim.lsp.enable()` loads every named
`lsp/<name>.lua` to validate it (runtime `lsp.lua`, `_ = lsp.config[nm]`),
and the first `FileType` event of any filetype loads them all again to cache
the resolved configs. Module-scope code in a server file therefore runs in
every session, whether or not that server ever starts.

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Semantic-tokens `reset_timer` crash guard, diagnostics config, `default_capabilities_config()` (Neovim's capabilities + the blink snapshot + overrides), the `tsgo` registration (configured, not enabled), the no-op formatting-edit filter for every client, `vim.lsp.config("*")`, the `vim.lsp.enable()` list with the deliberately absent servers (marksman, markdown_oxide, rust_analyzer), and the global LSP keymaps |
| `on_attach.lua` | The `on_attach` every server shares, as a table keyed by server name: dockerls capability stripping, clangd and basedpyright user commands, terraformls and vtsls code lenses / inlay hints, markdown_oxide daily notes, the jsonls `$ref` `<C-]>` |
| `cmd.lua` | `require("lsp.cmd").lazy(argv)`: a function `cmd` that builds its argv when the server starts and spawns it with the options vim.lsp passes for a table `cmd` (`cwd = cmd_cwd or root_dir`, `env = cmd_env`, `detached`, as runtime `lua/vim/lsp/client.lua` `Client.create`). Used by jsonls, yamlls, vtsls, helm_ls, sourcekit and tsgo. Required as `lsp.cmd`, never via `require("lsp")`, whose `vim.lsp.enable()` loads the `lsp/` files |
| `capabilities.lua` | Static snapshot of `require("blink.cmp").get_lsp_capabilities({}, false)`, merged into every server so blink stays unloaded until InsertEnter. Drift-guarded by `tests/lsp_capabilities_snapshot_spec.lua`; regeneration recipe in its header |

## For AI Agents

### Working In This Directory
- To add a server, follow `.claude/skills/add-lsp/SKILL.md`: create
  `lsp/<server_name>.lua` returning a `--- @class vim.lsp.Config :
  vim.lsp.ClientConfig` table, then add the name to the `vim.lsp.enable()`
  list in `init.lua`. The `lsp/` file is the whole registration; nothing
  else lists servers. `tsgo` is the one config registered inline instead,
  with `vim.lsp.config("tsgo", ...)` in `init.lua`, because it is kept off
  (vtsls owns TypeScript buffers).
- Resolve every binary to an absolute path through `lua/util` — never a bare
  command name, which the environment (or a project's version file) would
  choose. See Common Patterns for which helper fits which server.
- Options go where the server reads them, verified in its source:
  - `settings` for servers that pull `workspace/configuration`, nested under
    the exact section they request (`gopls`, `helm-ls`, `json`, `yaml`,
    `Lua`, `docker.languageserver`, ...). A flat table answers that
    request with `null`, and the server silently keeps its defaults.
  - `init_options` for servers that read only `initializationOptions`:
    neocmakelsp, terraform-ls, ruby-lsp.
  - Neither for markdown-oxide, which takes its options from TOML files.
- `vim.lsp.config("*", { capabilities = ..., on_attach = ..., root_markers =
  { ".git" } })` sets defaults for every server; server files override only
  what differs. Lists are replaced, not merged.
- Per-server attach work (buffer commands, keymaps, codelens/inlay-hint
  enables) goes in `on_attach.lua` as an `attach.<server_name>` entry.
  Never define `on_attach` in `lsp/<name>.lua`: configs resolve through
  `vim.tbl_deep_extend("force", config["*"], ...)`, which replaces a
  function instead of merging it, so it would drop the shared one. Never
  create an autocmd at module scope in `lsp/<name>.lua` either: the file
  loads in every session (see Purpose).
- Anything a server needs only when it starts (disk lookups, `$PATH` walks,
  catalogs) goes in `before_init` or a function `cmd`, not at module scope.
  `before_init` sees the resolved `root_dir`, and vim.lsp deepcopies the
  config per start, so its mutations stay scoped to that client
  (`lsp/gopls.lua`, `lsp/jsonls.lua`, `lsp/basedpyright.lua`).
- nvim-lspconfig-only keys (`autostart`, `single_file_support`,
  `offsetEncoding`, `on_new_config`) do nothing under native `vim.lsp`.
  Encoding goes in `capabilities.general.positionEncodings`.
- LSP keymaps (`K`, `<C-]>`, `<LocalLeader>gr`, `<Leader>e`, etc.) are
  defined once, globally, at the bottom of `init.lua`. The one exception is
  jsonls's buffer-local `<C-]>` in `on_attach.lua`, which exists because the
  server answers no `textDocument/definition`: a `$ref` can be followed only
  through `textDocument/documentLink`.
- `<LocalLeader>f` (manual format) does not pass a literal `lsp_format`:
  conform only consults a `formatters_by_ft` entry's own `lsp_format` for
  keys the caller leaves nil, so a literal would discard whatever a filetype
  pins. It hands any pinned value back instead (`"fallback"` when there is
  none), mirroring `format_on_save` in `lua/plugins/conform.lua`. `json5`
  and `hujson` pin `"never"`, so an unavailable CLI formatter (`oxfmt` for
  json5, `hujsonfmt` for hujson) formats nothing: `jsonls` has no JSON5 mode
  and rewrites a json5 buffer as strict JSON, and it would reflow a hujson
  file into its own layout. `go` and `goasm` pin `"first"`, so the LSP
  formats before their CLI chain (for go, gopls with `gofumpt = true` ahead of
  `goimports-rereviser`).
- Per-server diagnostic filters live in that server's `lsp/<name>.lua` as a
  client-local `handlers` entry, never by assigning `vim.lsp.handlers`, which
  every server would inherit: `vtsls.lua` drops TypeScript 80001 from
  pushed `textDocument/publishDiagnostics`, `jsonls.lua` drops JSON syntax
  errors on JSON5 buffers and TrailingComma (519) on HuJSON buffers from
  pulled `textDocument/diagnostic`. HuJSON is also sent to the server as
  languageId `jsonc` (`get_language_id`), the only id it relaxes comments
  for; JSON5 deliberately is not, since its syntax goes beyond JSONC.
  Client-side commands a server sends back work the same way, through the
  config's `commands` table (`lsp/terraformls.lua`'s `client.showReferences`).
- A JSON schema that must own a file outright goes in `EXCLUSIVE_SCHEMAS` in
  `lsp/jsonls.lua`, not in a bare `fileMatch`: the server merges every
  matching association under `allOf`, so each competing catalog entry needs a
  trailing `!` negation, which `before_init` appends. Chrome extension
  manifests (`chrome-extension*/**/manifest.json`) are routed this way.

### Testing Requirements
- `echo 'assert(loadfile("lsp/<server>.lua"))' | nvim --clean --headless -i
  NONE -l -` is the quick syntax check for an edited server file. `loadfile`
  compiles without running it; `-l lsp/<server>.lua` would run it, and its
  `require("util")` cannot resolve under `--clean`.
- `nvim --headless -u NONE -l tests/<name>_spec.lua` runs a headless
  regression spec. Specs that target this stack:
  - `lsp_capabilities_snapshot_spec.lua`: the snapshot equals blink's live
    output, and `init.lua`'s overrides switch on no completion feature blink
    reports as unimplemented.
  - `jsonls_json5_diagnostics_spec.lua`, `jsonls_hujson_spec.lua`,
    `jsonls_keep_lines_spec.lua`, `jsonls_chrome_manifest_spec.lua`
    (`lsp/jsonls.lua`) and `jsonls_ref_definition_spec.lua` (the `$ref`
    jump in `on_attach.lua`).
  - `markdown_oxide_spec.lua`: config shape, vault-marker precedence over
    `.git`, the daily-note commands from `on_attach.lua`, and a live
    definition inside a git-ignored folder.
  - `tests/perf/startup_budget_spec.lua`: gopls attaches from a pty session
    while blink stays unloaded; needs the gopls daemon.
- Under `-u NONE` the `~/.config/nvim` symlink keeps this repo on the rtp,
  so `require("lsp")` loads the repo's files even from a copy of the tree;
  run such a copy with `XDG_CONFIG_HOME` pointed at an empty directory
  (the exact command is in `tests/AGENTS.md`).
- gopls runs in forwarder mode (`-remote=unix;/tmp/gopls.sock`) and exits
  without a daemon — start `gopls -listen="unix;/tmp/gopls.sock" serve`
  before attach checks.
- Other server files are verified by opening a buffer of the matching
  filetype and checking `:checkhealth vim.lsp` (which also flags unknown
  filetypes and non-executable commands).

### Common Patterns
- Every `lsp/<server>.lua` returns a single table typed
  `--- @class vim.lsp.Config : vim.lsp.ClientConfig` — no `setup()` call,
  no side effects at module load.
- Binary resolution:
  - `util.homebrew_binary(formula, binary)` is the norm.
  - `util.go_path("bin", ...)` for Go-installed servers (gopls).
  - `util.prefix(...)` for the `/opt/local` (arm64) or `/usr/local`
    toolchain: gopls's `go`, bashls's `shellcheck`.
  - Node servers name their interpreter and script separately, so the
    nodenv shim cannot pick node from the project's version file:
    `{ util.nodenv_prefix("node"), util.bun_prefix("<bin>"), "--stdio" }`,
    built inside `require("lsp.cmd").lazy(function() ... end)` so both
    lookups run when the server starts — jsonls, yamlls, vtsls, tsgo (in
    `init.lua`) — and, for helm-ls's yamlls child, in `before_init`
    (`settings["helm-ls"].yamlls.path`). `tests/lsp_capabilities_snapshot_spec.lua`
    fails when any config looks a binary up at load time.
  - `vim.fn.exepath()` inside a function `cmd` where `$PATH` is meant to
    choose (helm_ls, sourcekit's toolchain), both through `lsp.cmd.lazy`, so
    the walk happens only when the server starts.
  - `$ZVM_PATH` for zls, with one ERROR and no `cmd` when it is unset;
    clangd keeps its absolute `/opt/local/llvm/clangd` path.
  - `util.src_path()` for auxiliary include/library paths (protols).
- `root_markers` are tried in list order, not nearest-first; a nested list is
  one equal-priority group (nearest wins within it). Markers are literal
  file or directory names — `vim.fs.root` does not glob. A root-defining
  marker must come before `.git` (markdown_oxide's vault markers, neocmake's
  `CMakePresets.json`); a per-directory file such as `.clang-format` or a
  subproject's `CMakeLists.txt` must come after it. `root_dir` functions are
  for logic markers cannot express (`lsp/gopls.lua`).

## Dependencies

### Internal
- `lua/util/init.lua` — `homebrew_binary()`, `prefix()`, `homebrew_prefix()`,
  `bun_prefix()`, `nodenv_prefix()`, `go_path()`, `src_path()`,
  `xdg_config_home()`, `is_exists()`.
- `lua/plugins/` — the lspkind spec that loads this stack; `rustaceanvim`
  owns the active `rust-analyzer` client, so there is deliberately no
  `lsp/rust_analyzer.lua`.

### External
- The language server binaries themselves (gopls, clangd, basedpyright,
  lua-language-server, yaml-language-server, vscode-json-language-server,
  vtsls, tombi, zls, sourcekit-lsp, etc.), installed via Homebrew, bun, go,
  zvm and Xcode, and resolved through the helpers above.
- UI/capability plugins configured via `lua/plugins/`: `hover.nvim`,
  `lspkind.nvim`, `lsp-endhints.nvim`, `tiny-inline-diagnostic.nvim`,
  `actions-preview.nvim` (all `LspAttach`-triggered), `blink.cmp`
  (capabilities snapshot only), `SchemaStore.nvim` (required in
  `lsp/jsonls.lua`'s `before_init`, when a JSON buffer starts the server).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
