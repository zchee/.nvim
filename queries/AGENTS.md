<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# queries

## Purpose
Tree-sitter query files for languages/grammars that need highlighting or
injection queries this config supplies itself, rather than relying on
queries bundled with `nvim-treesitter` or a grammar's own `queries/`
directory. Currently covers exactly one language: Go templates (`gotmpl`).

## Key Files
| File | Description |
|------|-------------|
| `.DS_Store` | macOS Finder metadata; not tracked by git (matched by the global `.DS_Store` gitignore rule) — stray local artifact, safe to delete |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `gotmpl/` | Tree-sitter queries for the `gotmpl` language/parser: `highlights.scm` (identifiers, function/method calls, operators, the builtin-function allowlist `and\|call\|html\|index\|slice\|js\|len\|not\|or\|print\|printf\|println\|urlquery\|eq\|ne\|lt\|ge\|gt`, delimiters, `{{`/`}}`/`{{-`/`-}}` brackets, `if`/`else`/`else if`/`with` conditionals, `range`/`end`/`template`/`define`/`block` keywords, string/number/bool/nil literals, comments, `(ERROR)`) and `injections.scm` (injects `html` and `javascript` into `(text)` nodes as combined injections; a commented-out `(text) @yaml` injection is left disabled). No separate AGENTS.md — documented here. |

## For AI Agents

### Working In This Directory
- Only add a query file here when the target grammar's own repo does not
  ship the query, or when the shipped query needs a local override; check
  the installed parser's `queries/` first (via `:TSInstallInfo` or the
  parser's upstream repo) before duplicating one.
- `gotmpl/highlights.scm` intentionally treats builtin template functions as
  a fixed, explicit allowlist (`#match?` regex) rather than a generic
  identifier highlight — extend that regex if a new Go template builtin
  needs highlighting, don't add a separate capture.
- `gotmpl/injections.scm`'s `(text) @injection.content` captures are
  unconditional (no `#match?`/`#eq?` guard distinguishing HTML vs JS
  context) — both injections are registered as `combined`, so Tree-sitter
  merges all `(text)` fragments per language before parsing. If per-context
  injection (e.g. only inside `<script>`) is ever needed, this file will
  need real predicates, not just two unconditional injection blocks.
- Directory name in the query path must match the Tree-sitter language name
  exactly (`gotmpl`, not `go.gotmpl` or `go_tmpl`) for Neovim to discover it
  on `runtimepath`.

### Testing Requirements
No automated specs. Verify manually against a `.tmpl`/`.tpl`/`gotmpl` buffer:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'edit <file.tmpl>' -c 'set ft=gotmpl' -c 'lua vim.treesitter.start(0, "gotmpl")' -c 'qa'`
should not error; interactively, `:Inspect` / `:InspectTree` on a `gotmpl`
buffer confirms captures resolve as expected.

### Common Patterns
Standard Tree-sitter query file split: `highlights.scm` for `@capture`
groups, `injections.scm` for `#set! injection.language` / `injection.content`
directives — no `locals.scm` or `folds.scm` present for this grammar.

## Dependencies

### Internal
- `gotmpl` filetype is produced by root `filetype.lua` (`tmpl`/`tpl`
  extensions) and `ftdetect/gotmpl.vim`; consumed together with
  `ftplugin/gotmpl.lua` and `syntax/gotexttmpl.vim`.
- `lua/plugins/tree-sitter.lua` calls
  `vim.treesitter.language.register("gotmpl", "helm")`, aliasing the `helm`
  parser to also serve `gotmpl` buffers — these queries apply to that
  aliased parser.

### External
Requires a `gotmpl`-compatible Tree-sitter parser to be installed (aliased
from the `helm` parser per `lua/plugins/tree-sitter.lua`).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
