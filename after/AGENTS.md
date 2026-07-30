<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# after

## Purpose
Neovim's `after/` runtime directory: everything under here loads *after* the
rest of `runtimepath` (including plugins), so files here get the final say
over per-filetype buffer options and Tree-sitter query behavior. This repo
uses it for three things: `ftplugin/` (per-filetype `vim.opt_local` settings
— mostly indentation and comment/commentstring — for 14 filetypes, loaded
after any ftplugin a plugin ships for the same filetype), `queries/`
(Tree-sitter query overrides that either `extends` nvim-treesitter's bundled
`highlights.scm`/`injections.scm`/`locals.scm` for 10 languages, or supply
the full base query set for the private `goasm` grammar), and `syntax/`
(currently empty — legacy regex `:syntax` overrides were removed as the
config migrated to Tree-sitter; see `after/syntax/AGENTS.md`).

## Key Files
None directly in this directory (plus an untracked `.DS_Store`) — all content
lives in the three subdirectories below.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `ftplugin/` | Per-filetype `vim.opt_local` settings (indent, comments) for 14 filetypes |
| `queries/` | Tree-sitter query overrides/extensions for 10 languages plus the base `goasm` query set |
| `syntax/` | Empty — legacy Vim syntax overrides removed in favor of Tree-sitter |

## For AI Agents

### Working In This Directory
- Route a new override by kind: buffer-local Vim options (indent width,
  `commentstring`, `colorcolumn`, ...) go in `ftplugin/<filetype>.lua`;
  highlighting/injection/locals/tags behavior for a Tree-sitter-parsed
  filetype goes in `queries/<language>/<kind>.scm`.
  Don't add third-party plugin configuration here — that belongs in
  `lua/plugins/<name>.lua`.
- Files here only take effect once the filetype (for `ftplugin/`) or
  Tree-sitter parser/language (for `queries/`) is already registered
  elsewhere — check root `filetype.lua` and `lua/plugins/tree-sitter.lua`
  before assuming a new file here will load.
- `after/` is a Neovim runtime convention (`:h after-directory`); no
  additional Lua wiring is needed to make a correctly-named file under
  `ftplugin/` or `queries/<lang>/` load.

### Testing Requirements
- No automated tests cover `after/ftplugin/*.lua` or `after/queries/*.scm`
  content directly (the one related spec, `tests/goasm_filetype_spec.lua`,
  tests the *filetype detector* in `lua/filetypes/goasm.lua`, not the
  `after/queries/goasm/*.scm` query files).
- Real verification: open a buffer of the target filetype and check
  `:verbose set <option>?` (ftplugin) or `:InspectTree` / `:EditQuery`
  (queries) to confirm the override took effect.
- `nvim --headless "+Lazy! sync" +qa` re-installs/updates Tree-sitter
  parsers, including the two custom `parser_config` entries (`goasm`,
  `printf`) that `after/queries/goasm/` and `after/queries/printf/` depend on.

### Common Patterns
- `ftplugin/*.lua` files are almost entirely `vim.opt_local.<option> = ...`
  one-liners; only a few (`gitconfig.lua`, `terraform.lua`, `zsh.lua`) carry
  a `-- <file>.lua: Neovim filetype plugin for X.` header comment.
- `queries/<lang>/*.scm` files open with an `; extends` or `;; extends`
  modeline on line 1 to merge into (not replace) nvim-treesitter's bundled
  queries — see `after/queries/AGENTS.md` for the full per-file audit of
  this convention, including one file that has no such modeline.

## Dependencies

### Internal
- `queries/goasm/*` depends on the `goasm` parser registered in
  `lua/plugins/tree-sitter.lua` (`parser_config.goasm`, source
  `github.com/zchee/tree-sitter-goasm`) and on filetype detection in
  `lua/filetypes/goasm.lua`.
- `queries/*/injections.scm` files that set `injection.language "printf"`
  or `"sql"`/`"bash"`/`"twig"`/`"tsx"` depend on those parsers also being
  installed via `lua/plugins/tree-sitter.lua`.
- `ftplugin/*.lua` filenames must match a filetype produced by root
  `filetype.lua` or a built-in Neovim filetype.

### External
- nvim-treesitter — ships the upstream `highlights.scm`/`injections.scm`/
  `locals.scm` that `queries/` files extend.
- Neovim's built-in `after-directory` and `ftplugin` loading mechanism
  (`:h after-directory`, `:h ftplugin`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
