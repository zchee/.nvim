<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/lsp

## Purpose
Central LSP wiring for the config. `init.lua` uses Neovim's native
`vim.lsp.config()` / `vim.lsp.enable()` API exclusively — there is no
`lspconfig.setup()` call anywhere in this directory. `nvim-lspconfig` is
only pulled in for its `lspconfig.configs` registry (via `register_lsp()`,
for servers not shipped in lspconfig, e.g. `tsgo`) and for stray
`lspconfig.util`/`require("lspconfig")` references left in a few
now-unused server files. Every other file in this directory is a plain Lua
module that returns a `vim.lsp.Config` table (`cmd`, `filetypes`,
`root_markers`/`root_dir`, `settings`, `init_options`, `on_attach`, ...);
`init.lua` `require()`s the ones it wants active into a `servers` table and
calls `vim.lsp.config(name, cfg)` + `vim.lsp.enable(name, true)` in a loop.
Not every `<server>.lua` file here is wired in — several are kept as
disabled/experimental references (see the "NOT registered" notes in the
table below).

## Key Files
| File | Description |
|------|-------------|
| `init.lua` | Orchestrates LSP: semantic-tokens crash guard, UI setup, capabilities/on_attach, servers table, keymaps |
| `asm_lsp.lua` | asm-lsp via util.homebrew_binary("asm-lsp"); ft asm/vmasm/goasm; root .asm-lsp.toml/.git. Registered. |
| `basedpyright.lua` | basedpyright-langserver (basedpyright-head) via util.homebrew_binary; typeCheckingMode=off. Registered. |
| `bashls.lua` | bash-language-server via util.homebrew_binary; hardcoded /opt/local shellcheck path + shfmt. Registered. |
| `buf_ls.lua` | buf lsp serve via util.homebrew_binary("buf"); proto ft. NOT registered (commented in init.lua). |
| `clangd.lua` | cmd hardcoded /opt/local/llvm/clangd/bin/clangd (no util helper); heavy flags, utf-16, -j=16. Registered. |
| `cmake-language-server.lua` | cmake-language-server via util.homebrew_binary. NOT registered; neocmake.lua is the active cmake server. |
| `denols.lua` | deno lsp via util.homebrew_binary("deno"). NOT registered; ts/js handled by vtsls instead. |
| `docker_language_server.lua` | MS docker-language-server via util.homebrew_binary; newer file, but NOT registered; dockerls.lua is active. |
| `dockerls.lua` | dockerfile-language-server-nodejs via util.homebrew_binary(dockerfile-language-server). Registered. |
| `emmylua_ls.lua` | emmylua_ls via util.homebrew_binary; sets EMMYLUALS_CONFIG env. NOT registered, so that line never runs. |
| `emmylua_ls.json` | Raw EmmyLua analyzer JSON config, read via $EMMYLUALS_CONFIG; not a vim.lsp.Config table. |
| `golangci_lint_ls.lua` | golangci-lint-langserver via util.go_path + mason-core.path; autostart=false. NOT registered. |
| `gopls.lua` | gopls via util.go_path; unix-socket -remote serve; custom root_dir; GOEXPERIMENT for go/src. Registered. |
| `grammarly_lsp.lua` | No cmd field; markdown ft; hardcoded personal clientId. NOT registered. |
| `graphql.lua` | graphql-lsp via mason-core.path (not util helper). NOT registered. |
| `helm_ls.lua` | cmd = vim.fn.exepath("helm_ls") (bare, deviates from util convention); autostart=false. Registered. |
| `jsonls.lua` | vscode-json-language-server via util.bun_prefix; schemastore.nvim + trustedDomains allowlist. Registered. |
| `lua_ls.lua` | lua-language-server via util.homebrew_binary; workspace.library via util.src_path(LLS-Addons). Registered. |
| `metals.lua` | metals via util.homebrew_binary; hardcodes Java 8 temurin javaHome, sbt/gradle/maven. NOT registered. |
| `neocmake.lua` | neocmakelsp via util.homebrew_binary; cmake ft; typo `rotoot_markers` vs `root_markers`. Registered. |
| `pls.lua` | proto lsp "pls" at ~/go/bin/pls, hand-built path. NOT registered; protols.lua is active instead. |
| `protols.lua` | protols-head via util.homebrew_binary; --include-paths via util.src_path(googleapis/...). Registered. |
| `pyright.lua` | pyright-langserver via util.homebrew_binary. NOT registered; basedpyright.lua is active instead. |
| `ruby_lsp.lua` | ruby-lsp via util.homebrew_binary, vim.lsp.rpc.start + custom cwd dispatcher; rbenv manager. Registered. |
| `ruff_lsp.lua` | No cmd field; disables hover in favor of Pyright; autostart=false in init_options. NOT registered. |
| `rust_analyzer.lua` | Execs `rustup run <toolchain> rust-analyzer`; NOT registered (rustaceanvim owns it); has a test spec. |
| `sourcekit.lua` | Bare `sourcekit-lsp` on PATH (no util helper); swift ft; repeats --experimental-feature. Registered. |
| `taplo.lua` | taplo lsp stdio via util.homebrew_binary; schema catalogs; on_attach widens pyproject.toml indent. Registered. |
| `terraformls.lua` | terraform-ls via util.homebrew_binary(terraform-ls-head); -req-concurrency=16. Registered. |
| `tilt_ls.lua` | tilt lsp start via util.homebrew_binary(tilt-head). NOT registered. |
| `tombi.lua` | tombi lsp via util.homebrew_binary; toml ft, overlaps with taplo.lua (both active). Registered. |
| `ts_ls.lua` | typescript-language-server via util.homebrew_binary. NOT registered. |
| `tsgo.lua` | cmd hardcodes personal go/src/microsoft/typescript-go path. Dead; init.lua registers tsgo inline instead. |
| `vtsls.lua` | Bare `vtsls --stdio` on PATH (no util helper); move-to-file action, reference code lenses. Registered. |
| `xor.lua` | cmd runs cargo run against a hardcoded personal xor-lsp checkout; hardcoded root_dir. NOT registered; WIP. |
| `yamlls.lua` | yaml-language-server via util.bun_prefix; large per-repo schema map (gjc etc); helm dirs stopped. Registered. |
| `zizmor.lua` | zizmor --lsp via util.homebrew_binary; root_dir scoped to GH/Forgejo/Gitea workflow dirs. NOT registered. |
| `zls.lua` | zls at $ZVM_PATH/bin/zls (not a util helper); zig/zon ft. Registered. |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `protocol/` | LSP 3.17 constants module (`init.lua`, `M.constants`: DiagnosticSeverity, MessageType, CompletionItemKind, MarkupKind, CodeActionKind, CodeActionTriggerKind, InlineCompletionTriggerKind, FileChangeType, ...), required as `require("lsp.protocol")` in `init.lua` and used to build `capabilities.textDocument.completion.completionItem.documentationFormat` (documented here — no separate AGENTS.md) |

## For AI Agents

### Working In This Directory
- To add a server: create `lua/lsp/<server_name>.lua` returning a
  `--- @class vim.lsp.Config : vim.lsp.ClientConfig` table (`cmd`,
  `filetypes`, `root_markers`, `settings`, ...), resolving the binary via
  `util.homebrew_binary()`, `util.prefix()`, `util.bun_prefix()`,
  `util.go_path()`, or `util.pnpm_prefix()` — never a bare command name.
- Register it in `init.lua`'s `servers` table:
  `["<server_name>"] = require("lsp.<server_name>")`. If the server is not
  known to `nvim-lspconfig`, call `register_lsp("<name>", { ... })` before
  the table instead (see the `tsgo` example already in `init.lua`).
- `vim.lsp.config("*", { capabilities = ..., on_attach = ..., root_markers
  = { ".git" } })` sets defaults for every server; per-server files only
  need to override what differs.
- LSP keymaps (`K`, `<C-]>`, `<BS>gr`, `<Space>e`, etc.) are defined once,
  globally, at the bottom of `init.lua` — do not add per-server keymaps in
  a `<server>.lua` file.
- Cross-cutting `on_attach` quirks (bashls/lua_ls early return, dockerls
  capability stripping, tsserver diagnostic filtering, yamlls stopping
  itself inside Helm template directories) live in `init.lua`'s shared
  `on_attach`, not in the individual server files.
- A repo-local skill, `.claude/skills/add-lsp`, documents this exact
  workflow — invoke it when adding a new server.
- Many `<server>.lua` files exist but are not wired into the `servers`
  table (see "NOT registered" notes above); before reusing one, check
  whether it is current or superseded by the active alternative.

### Testing Requirements
- `nvim --clean --headless -l <file>` (per repo root `AGENTS.md`) is the
  quick syntax check for an edited `lua/lsp/<server>.lua` module.
- `nvim --headless -u NONE -l tests/<name>_spec.lua` runs a headless
  regression spec. `tests/rust_analyzer_spec.lua` is the one that targets
  this directory: it fakes a `rustup` binary on `PATH`, `require()`s
  `lsp.rust_analyzer` fresh each time (via `package.loaded[...] = nil`),
  and asserts the resulting `config.cmd` for the "toolchain found",
  "rustup default fails", and "rustup default prints nothing" cases. Run
  it with `nvim --headless -u NONE -l tests/rust_analyzer_spec.lua`.
- No other server file has a dedicated spec; changes to them are verified
  by opening a buffer of the matching filetype and checking `:LspInfo` /
  `:checkhealth vim.lsp`.

### Common Patterns
- Every file returns a single table typed `--- @class vim.lsp.Config :
  vim.lsp.ClientConfig` — no `setup()` call, no side effects beyond
  occasional module-load-time helpers (e.g. `basedpyright.lua`'s
  `detect_extra_paths()`).
- Binary resolution order in practice: `util.homebrew_binary(formula,
  binary)` is the norm; `util.go_path()` for Go-toolchain binaries,
  `util.bun_prefix()` for JS/TS-ecosystem servers,
  `util.src_path()` for auxiliary include/library paths. A handful of
  files deviate with a bare command name (`sourcekit.lua`, `vtsls.lua`,
  `helm_ls.lua` via `vim.fn.exepath`) or a fully hardcoded absolute path
  (`clangd.lua`, `tsgo.lua`, `xor.lua`) — flagged per-row above.
- `settings` nests the server's native JSON configuration schema verbatim
  (e.g. `gopls.lua`'s `settings.*` mirrors `golang.org/x/tools/gopls`
  settings; `yamlls.lua`'s mirrors `redhat-developer/yaml-language-server`).
- `on_attach` is used sparingly per-file for buffer-local capability
  overrides (`ruff_lsp.lua` disabling hover, `taplo.lua` widening indent
  for `pyproject.toml`), while global behavior lives in `init.lua`.
- `root_markers` is preferred over the legacy `root_dir` function; a few
  files (`gopls.lua`, `zizmor.lua`, `xor.lua`) still use a `root_dir`
  function/string for logic `root_markers` cannot express.

## Dependencies

### Internal
- `lua/util/init.lua` — `homebrew_binary()`, `prefix()`, `homebrew_prefix()`,
  `bun_prefix()`, `pnpm_prefix()`, `go_path()`, `src_path()`,
  `xdg_config_home()`, `is_exists()`; used throughout for binary/path
  resolution.
- `lua/lsp/protocol/init.lua` — LSP spec constants consumed by `init.lua`'s
  `default_capabilities_config()` (e.g. `protocol.constants.MarkupKind`).
- `lua/plugins/` — `rustaceanvim` (configured under `lua/plugins/`) owns
  the active `rust-analyzer` client instead of `lsp/rust_analyzer.lua`;
  see the comment next to the commented-out `rust_analyzer` line in
  `init.lua`'s `servers` block.

### External
- The language server binaries themselves (gopls, rust-analyzer, clangd,
  basedpyright, lua-language-server, yaml-language-server, taplo, tombi,
  zls, sourcekit-lsp, etc.), installed via Homebrew/mise/bun/go and
  resolved through the `util` helpers above.
- `nvim-lspconfig` — only for `lspconfig.configs` (used by `register_lsp()`
  to register non-lspconfig servers such as `tsgo`), never for
  `lspconfig.setup()`.
- UI/capability plugins configured centrally in `init.lua`: `hover.nvim`,
  `lspsaga.nvim`, `lspkind.nvim`, `lsp-endhints.nvim`,
  `tiny-inline-diagnostic.nvim`, `actions-preview.nvim`, `blink.cmp` (capabilities),
  `SchemaStore.nvim` (`jsonls.lua`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
