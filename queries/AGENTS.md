<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-10-04 -->

# queries

## Purpose
Tree-sitter query files for grammars that ship no Neovim queries of their
own. Currently only HuJSON (`hujson`). Overrides and additions to queries
nvim-treesitter already installs belong in `after/queries/` instead (see
`after/queries/AGENTS.md`): a file here does not extend an installed query,
and nvim-treesitter's install dir comes first on the rtp, so it wins.

## Key Files
| File | Description |
|------|-------------|
| `.DS_Store` | macOS Finder metadata; not tracked by git (matched by the global `.DS_Store` gitignore rule) — stray local artifact, safe to delete |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `hujson/` | `highlights`, `injections`, `indents`, `folds` and `locals`, each a single `; inherits: json` line. tree-sitter-hujson is a custom registry entry, so nvim-treesitter ships no queries for it, and the grammar repo's own `queries/` targets Zed (booleans as `@constant.builtin`, `@indent`/`@end` indents nvim-treesitter ignores). The grammar keeps tree-sitter-json's node types, so nvim-treesitter's json queries apply as they are. Without these files the parser still attaches, `vim.treesitter.start` clears `syntax`, and the buffer has no highlighting at all. Pinned by `tests/hujson_queries_spec.lua` |

## For AI Agents

### Working In This Directory
- Only add a query file here when the grammar ships no Neovim queries at
  all. When the grammar repo has queries written for Neovim (nvim-treesitter
  capture names), set `install_info.queries` on its entry in
  `lua/nvim-treesitter/parsers.lua` instead: install then copies (url) or
  symlinks (path) them next to the parser, so they track the parser
  revision. `cel`, `ghostty`, `goasm`, `mustache` and `x86asm` work that
  way (pinned by `tests/custom_parser_queries_spec.lua`); hujson stays here
  because its repo's queries target Zed. To change a query nvim-treesitter installs, write
  `after/queries/<lang>/<kind>.scm` with `;; extends` on line 1.
- Check where a query resolves before assuming a file here is live:
  `:lua =vim.treesitter.query.get_files("<lang>", "highlights")`. A
  `queries/gotmpl/` pair lived here until 2026-09-29 without ever being
  loaded, because the installed gotmpl queries shadowed it.
- Directory name in the query path must match the Tree-sitter language name
  exactly for Neovim to discover it on `runtimepath`.

### Testing Requirements
`nvim --headless -u NONE -i NONE -l tests/hujson_queries_spec.lua` (prints
SKIP when the tree-sitter-hujson parser is not installed).

## Dependencies

### Internal
- The `hujson` filetype comes from root `filetype.lua` (`hujson` extension);
  `ftplugin/hujson.lua` and `lsp/jsonls.lua` consume it too.

### External
The tree-sitter-hujson parser (custom registry entry in
`lua/nvim-treesitter/parsers.lua`) and nvim-treesitter's json queries.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
