<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/none-ls

## Purpose
Custom `none-ls.nvim` (formerly `null-ls`) source builders that are not
shipped by `none-ls.nvim` or `none-ls-extras.nvim` upstream. Consumed via
`require("none-ls.formatting.<name>")` from
`lua/plugins/null-ls.lua`'s `sources` table, alongside upstream builtins
(`null_ls.builtins.formatting.stylua`, etc.) and `none-ls-extras` sources
(`require("none-ls.formatting.rustfmt")`, `require("none-ls.diagnostics.ruff")`).
Only one source is currently defined and it is commented out in
`lua/plugins/null-ls.lua` (formatting is instead handled by `gopls`'
own `goimports`-equivalent / conform.nvim's disabled spec — see that file for
the current wiring).

## Key Files
No files directly in `lua/none-ls/` — see Subdirectories.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `formatting/` | Custom none-ls formatter source builders — documented here, no separate AGENTS.md |

### `formatting/`
| File | Description |
|------|--------------|
| `goimports_rereviser.lua` | `h.make_builtin(...)` FORMATTING source wrapping the `goimports-rereviser` Go binary |

## For AI Agents

### Working In This Directory
- Follow the `null-ls.helpers.make_builtin({...})` contract used by
  `goimports_rereviser.lua`: `name`, `meta = { url, description }`,
  `method` (from `require("null-ls.methods").internal.<CATEGORY>`),
  `filetypes`, `generator_opts` (`command`, `args`, `to_temp_file`/`to_stdin`,
  `prepend_extra_args`), and `factory` (`h.formatter_factory` for
  formatting sources, `h.generator_factory` for diagnostics/code actions).
- `goimports_rereviser.lua` uses `to_temp_file = true` specifically because
  the `goimports-rereviser` binary does not support reading from stdin — the
  comment in the file documents the stdin-capable alternative
  (`to_stdin = true` + `args = { "-output", "stdout", "$FILENAME" }`) for
  reference if the upstream binary ever adds stdin support.
- New custom sources should live under `formatting/`, `diagnostics/`, or
  `code_actions/` subdirectories mirroring `none-ls-extras.nvim`'s own
  module layout (`none-ls.formatting.*`, `none-ls.diagnostics.*`), so
  `require("none-ls.<category>.<name>")` resolves correctly.
- Wiring a new source into the active config still requires adding it to the
  `sources = { ... }` table in `lua/plugins/null-ls.lua`; creating the
  builder here alone does not activate it.

### Testing Requirements
No spec exists. Verify a builder loads and its `factory` produces a valid
generator by requiring it headlessly once `none-ls.nvim` is installed:
`nvim --headless -c 'lua require("none-ls.formatting.goimports_rereviser")' -c 'qa'`
End-to-end formatting behavior is best checked interactively by opening a
`.go` buffer and invoking `:lua vim.lsp.buf.format()` (or the configured
format-on-save) after enabling the source in `lua/plugins/null-ls.lua`.

### Common Patterns
- `local h = require("null-ls.helpers")` / `local methods =
  require("null-ls.methods")` at the top, then a single `return
  h.make_builtin({ ... })`.

## Dependencies

### Internal
None.

### External
`nvimtools/none-ls.nvim` (`null-ls.helpers`, `null-ls.methods`); the
`goimports_rereviser` builder additionally requires the external
`goimports-rereviser` binary (https://pkg.go.dev/github.com/zchee/goimports-rereviser)
on `$PATH`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
