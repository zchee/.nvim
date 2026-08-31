<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-01 -->

# lua/lsp

## Purpose
Central LSP wiring for the config. `init.lua` uses Neovim's native
`vim.lsp.config()` / `vim.lsp.enable()` API exclusively — `nvim-lspconfig`
is uninstalled. Per-server configs no longer live in this directory:
each server is a plain `vim.lsp.Config` table in the repo-root `lsp/`
runtime directory (`lsp/<server>.lua`), which Neovim resolves lazily on
the first matching FileType event. `init.lua` here owns everything
cross-cutting: diagnostics UI, the shared capabilities/on_attach,
`vim.lsp.enable()` for the active server names, and the global LSP
keymaps. It is itself lazy — loaded via the `lspkind-nvim` spec's
`BufReadPre`/`BufNewFile` trigger in `lua/plugins/init.lua`, the one
plugin it genuinely `require()`s at load time.

Known pitfall (memory-backed): native `lsp/` configs resolve ALL enabled
configs on the first FileType event of any filetype, and silently drop a
`settings` table that is not nested under the server's own section — use
`before_init` for per-server lazy work, never `on_new_config`.

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Orchestrates LSP: semantic-tokens crash guard, diagnostics config, capabilities/on_attach, `vim.lsp.enable()` list (incl. inline `tsgo` registration), global LSP keymaps |
| `capabilities.lua` | Static snapshot of `require("blink.cmp").get_lsp_capabilities({}, false)`; merged into every server so blink stays unloaded until InsertEnter. Drift-guarded by `tests/lsp_capabilities_snapshot_spec.lua`; regeneration recipe in its header |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `protocol/` | LSP 3.17 constants module (`init.lua`, `M.constants`: DiagnosticSeverity, MessageType, CompletionItemKind, MarkupKind, CodeActionKind, CodeActionTriggerKind, InlineCompletionTriggerKind, FileChangeType, ...), required as `require("lsp.protocol")` in `init.lua` and used to build `capabilities.textDocument.completion.completionItem.documentationFormat` (documented here — no separate AGENTS.md) |

## For AI Agents

### Working In This Directory
- To add a server: create repo-root `lsp/<server_name>.lua` returning a
  `--- @class vim.lsp.Config : vim.lsp.ClientConfig` table (`cmd`,
  `filetypes`, `root_markers`, `settings`, ...), resolving the binary via
  `util.homebrew_binary()`, `util.prefix()`, `util.bun_prefix()`,
  `util.go_path()`, or `util.pnpm_prefix()` — never a bare command name —
  then add its name to the `vim.lsp.enable()` list in `init.lua`. Servers
  unknown to Neovim need nothing special: the `lsp/` file IS the
  registration (see `tsgo`, registered inline in `init.lua`).
- Keep `settings` nested under the server's own section (see the pitfall
  above); anything that must run per-server at start time belongs in
  `before_init`.
- `vim.lsp.config("*", { capabilities = ..., on_attach = ..., root_markers
  = { ".git" } })` sets defaults for every server; per-server files only
  need to override what differs.
- LSP keymaps (`K`, `<C-]>`, `<LocalLeader>gr`, `<Leader>e`, etc.) are defined once,
  globally, at the bottom of `init.lua` — do not add per-server keymaps in
  a `lsp/<server>.lua` file. `lsp/jsonls.lua` is the single exception, and only
  because the difference is in the protocol rather than in taste: the server
  answers no `textDocument/definition`, so on a JSON buffer `<C-]>` can be
  served only by `textDocument/documentLink`. It is bound on `LspAttach`
  rather than in an `on_attach`, since configs resolve through
  `vim.tbl_deep_extend("force", config["*"], ...)`, which replaces a function
  instead of merging it and would drop the shared `on_attach` — the same
  reason `lua/plugins/rustaceanvim.lua` binds its Rust keymaps that way.
- `<LocalLeader>f` (manual format) does not pass a literal `lsp_format`:
  conform only consults a `formatters_by_ft` entry's own `lsp_format` for
  keys the caller leaves nil, so a literal would discard a pinned `"never"`.
  It reads that pin back instead, mirroring `format_on_save` in
  `lua/plugins/conform.lua`. `json5` pins it because `jsonls` has no JSON5
  mode and rewrites such a buffer as strict JSON.
- Cross-cutting `on_attach` quirks (bashls/lua_ls early return, dockerls
  capability stripping, tsserver diagnostic filtering, yamlls stopping
  itself inside Helm template directories) live in `init.lua`'s shared
  `on_attach`, not in the individual server files.
- A repo-local skill, `.claude/skills/add-lsp`, documents this exact
  workflow — invoke it when adding a new server.

### Testing Requirements
- `nvim --clean --headless -l <file>` (per repo root `AGENTS.md`) is the
  quick syntax check for an edited `lsp/<server>.lua` module.
- `nvim --headless -u NONE -l tests/<name>_spec.lua` runs a headless
  regression spec. Specs that target this stack:
  `lsp_capabilities_snapshot_spec.lua` (snapshot == blink's live output),
  `jsonls_json5_diagnostics_spec.lua` / `jsonls_ref_definition_spec.lua`
  (`lsp/jsonls.lua`), `markdown_oxide_spec.lua`, and
  `tests/perf/startup_budget_spec.lua` (gopls attaches from a pty session
  while blink stays unloaded; needs the gopls daemon).
- gopls runs in forwarder mode (`-remote=unix;/tmp/gopls.sock`) and exits
  without a daemon — start `gopls -listen="unix;/tmp/gopls.sock" serve`
  before attach checks.
- Other server files are verified by opening a buffer of the matching
  filetype and checking `:LspInfo` / `:checkhealth vim.lsp`.

### Common Patterns
- Every `lsp/<server>.lua` returns a single table typed
  `--- @class vim.lsp.Config : vim.lsp.ClientConfig` — no `setup()` call,
  no side effects at module load; anything per-start lives in
  `before_init`/`on_attach`.
- Binary resolution order in practice: `util.homebrew_binary(formula,
  binary)` is the norm; `util.go_path()` for Go-toolchain binaries,
  `util.bun_prefix()` for JS/TS-ecosystem servers,
  `util.src_path()` for auxiliary include/library paths. A handful of
  files deviate with a bare command name (`sourcekit.lua`, `vtsls.lua`,
  `helm_ls.lua` via `vim.fn.exepath`) or a hardcoded absolute path
  (`clangd.lua`).
- `settings` nests the server's native JSON configuration schema verbatim
  (e.g. `lsp/gopls.lua`'s `settings.*` mirrors `golang.org/x/tools/gopls`
  settings; `lsp/yamlls.lua`'s mirrors `redhat-developer/yaml-language-server`).
- `root_markers` is preferred over the legacy `root_dir` function; a few
  files (`lsp/gopls.lua`) still use a `root_dir` function for logic
  `root_markers` cannot express.

## Dependencies

### Internal
- `lua/util/init.lua` — `homebrew_binary()`, `prefix()`, `homebrew_prefix()`,
  `bun_prefix()`, `pnpm_prefix()`, `go_path()`, `src_path()`,
  `xdg_config_home()`, `is_exists()`; used throughout for binary/path
  resolution.
- `lua/lsp/protocol/init.lua` — LSP spec constants consumed by `init.lua`'s
  `default_capabilities_config()` (e.g. `protocol.constants.MarkupKind`).
- `lua/lsp/capabilities.lua` — blink.cmp capabilities snapshot (see Key
  Files).
- `lua/plugins/` — `rustaceanvim` (configured under `lua/plugins/`) owns
  the active `rust-analyzer` client; there is deliberately no
  `lsp/rust_analyzer.lua`.

### External
- The language server binaries themselves (gopls, rust-analyzer, clangd,
  basedpyright, lua-language-server, yaml-language-server, tombi,
  zls, sourcekit-lsp, etc.), installed via Homebrew/mise/bun/go and
  resolved through the `util` helpers above.
- UI/capability plugins configured via `lua/plugins/`: `hover.nvim`,
  `lspkind.nvim`, `lsp-endhints.nvim`, `tiny-inline-diagnostic.nvim`,
  `actions-preview.nvim` (all `LspAttach`-triggered), `blink.cmp`
  (capabilities snapshot only), `SchemaStore.nvim` (`lsp/jsonls.lua`,
  loaded on first JSON buffer).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
