<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# after

## Purpose
Neovim's `after/` runtime directory: everything under here loads *after* the
rest of `runtimepath` (`$VIMRUNTIME` and plugins included), so files here get
the final say over per-filetype buffer options and Tree-sitter query
behavior. Three subdirectories: `ftplugin/` (per-filetype settings for 18
filetypes, applied after the runtime's own ftplugin), `queries/` (Tree-sitter
queries that `extends` nvim-treesitter's for 10 languages, plus the full
query set of the private `goasm` grammar), and `syntax/` (holds only its
AGENTS.md; see `after/syntax/AGENTS.md`).

## Key Files
None directly in this directory (plus an untracked `.DS_Store`) -- all content
lives in the subdirectories below.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `ftplugin/` | Per-filetype settings (indent, comments, a few maps) for 18 filetypes (see `ftplugin/AGENTS.md`) |
| `queries/` | Tree-sitter query extensions for 10 languages plus the base `goasm` query set (see `queries/AGENTS.md`) |
| `syntax/` | No syntax files -- legacy Vim syntax overrides were removed in favor of Tree-sitter (see `syntax/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Route a new override by kind: buffer-local Vim options (indent width,
  `commentstring`, `colorcolumn`, ...) go in `ftplugin/<filetype>.lua`;
  highlighting/injection/locals/tags behavior for a Tree-sitter-parsed
  filetype goes in `queries/<language>/<kind>.scm`. Third-party plugin
  configuration belongs in `lua/plugins/<name>.lua`.
- Never guard an `after/ftplugin` file on `b:did_ftplugin`: the runtime
  ftplugin has always set it by the time after/ runs, so the guard skips
  the whole file (terraform's `//` comments were dead this way).
- Files here only take effect once the filetype (for `ftplugin/`) or the
  Tree-sitter parser/language (for `queries/`) is registered elsewhere --
  check root `filetype.lua`, `lua/plugins/tree-sitter.lua` and
  `lua/nvim-treesitter/parsers.lua` first.
- `after/` is a Neovim runtime convention (`:h after-directory`); no Lua
  wiring is needed to make a correctly named file load.

### Testing Requirements
- Specs touching this directory: `tests/filetype_rules_spec.lua` (filetype
  detection that selects these ftplugins) and the probes recorded in each
  commit. Nothing automated covers the `.scm` content.
- Real verification: `:verbose set <option>?` in a buffer of the filetype
  (ftplugin), `:InspectTree` / `:Inspect` and
  `vim.treesitter.query.get_files(<lang>, <kind>)` (queries).

### Common Patterns
- `ftplugin/*.lua` files are mostly `vim.opt_local.<option> = ...` lines.
- `queries/<lang>/*.scm` files open with `; extends` or `;; extends` on line
  1 to merge into (not replace) the installed query -- see
  `queries/AGENTS.md` for the per-file audit.

## Dependencies

### Internal
- `queries/goasm/*` depends on the `goasm` parser entry in
  `lua/nvim-treesitter/parsers.lua` and on filetype detection in
  `lua/filetypes/goasm.lua`.
- `ftplugin/*.lua` filenames must match a filetype produced by root
  `filetype.lua` or Neovim's own detection.

### External
- nvim-treesitter -- installs the base queries that `queries/` extends.
- Neovim's `after-directory` and `ftplugin` loading (`:h after-directory`,
  `:h ftplugin`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
