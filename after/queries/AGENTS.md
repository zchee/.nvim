<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# after/queries

## Purpose
Tree-sitter query overrides, one subdirectory per language/parser name (10
total: `diff`, `go`, `goasm`, `json`, `lua`, `markdown`,
`markdown_inline`, `printf`, `python`, `yaml`). Nine of the ten use
Neovim/nvim-treesitter's `; extends` (or `;; extends`) modeline convention
to *merge* additional captures into the upstream bundled query of the same
name/kind rather than replacing it. The exception is `goasm/`, whose three
files are symlinks into `~/src/github.com/zchee/tree-sitter-goasm/queries/`
— the full, authoritative query set for a private grammar with no upstream
nvim-treesitter queries to extend.

## Key Files
None directly in this directory (plus an untracked `.DS_Store`) — every
`.scm` file lives one level down, in a per-language subdirectory below.

## Subdirectories
| Directory | Files (extends?) | Purpose |
|-----------|-------------------|---------|
| `diff/` | `injections.scm` (extends) | Captures `@injection.filename` / `@injection.content` (with `#set! injection.include-children`) per diff hunk, for filename-driven language routing |
| `go/` | `highlights.scm` (extends) | `case`/`default`/`defer` keywords, `err`/`error`/`any` identifiers, raw string literals, builtin-type call highlighting, package import namespacing, `//go:` pragma and `//nolint:` comment highlighting, const-string spell-checking |
| `go/` | `injections.scm` (extends) | SQL injection into string literals (match- and keyword-`contains`-based heuristics), JSON injection for `*Json*`-named const/var string literals, and `printf`-grammar injection for raw string literals passed to `Printf`/`Sprintf`/`Fprintf`/etc. — the last one exists specifically because upstream nvim-treesitter only injects `printf` into `interpreted_string_literal`, not raw strings |
| `go/` | `locals.scm` (extends) | `var_spec` as `local.scope`, struct field declarations, interface method elements, struct/interface `type_declaration` as `local.name`/`local.type` |
| `goasm/` | `highlights.scm`, `injections.scm`, `tags.scm` (symlinks — full base queries, not extends) | Comments incl. `//go:*`/`//line` pragma detection, C-style preprocessor directives, labels, and (in `tags.scm`) ctags-style function/data/label/macro definitions plus call/jump-target references across many architectures (amd64/arm64/riscv64/etc.) |
| `json/` | `injections.scm` (extends) | Injects `bash` into the string value of nested pairs under a `"scripts"` key (npm `package.json` convention) |
| `lua/` | `highlights.scm` (extends) | Highlights the identifier `vim` as `@namespace.builtin` |
| `markdown/` | `injections.scm` (extends) | Injects `tsx` into inline nodes matching `^(import\|export)` (MDX-style import/export lines) |
| `markdown_inline/` | `highlights.scm` (extends) | Restores backslash-escape and hard-line-break conceal rules that nvim-treesitter's *own* `markdown_inline/highlights.scm` drops (see gotcha audit — this file's header comment documents exactly the upstream failure mode this section audits for) |
| `printf/` | `highlights.scm` (extends) | `(format) @printf` |
| `python/` | `highlights.scm` (extends) | Highlights module/class/function/method docstrings and bare-string "attribute docstrings" as `@comment` |
| `yaml/` | `injections.scm` (extends) | Injects `twig` (stand-in for the absent Jinja2 grammar, per the file's own comment) into block/flow scalar values containing `{{` or `{%` |

## For AI Agents

### Working In This Directory
- New query files must live at `queries/<language>/<highlights|injections|
  locals|tags>.scm` where `<language>` is the Tree-sitter parser/language
  name (not always the same as the Neovim filetype — see `lua/plugins/
  tree-sitter.lua` for `vim.treesitter.language.register()` calls that map
  filetypes like `zsh`/`tiltfile`/`jsonschema`/`helm` onto a parser name).
- To *extend* an upstream nvim-treesitter query (the normal case), start the
  file with `; extends` or `;; extends` as the literal first line — see the
  gotcha audit below for why this is strict. To *replace* an upstream query
  outright, omit the modeline (rare in this repo — currently only justified
  for `goasm/`, a grammar with no upstream queries at all).
- `goasm/*.scm` are symlinks to a sibling repo
  (`~/src/github.com/zchee/tree-sitter-goasm`), which is also this
  parser's install source in `lua/plugins/tree-sitter.lua`
  (`parser_config.goasm`). Edit the target repo directly, not through these
  symlinks in isolation — a change here without a corresponding upstream
  commit will not survive a fresh clone of that repo.
- Before adding an `injection.language "<x>"` capture, confirm `<x>` is
  actually installed as a parser in `lua/plugins/tree-sitter.lua` (grep
  `parser_config`/the numbered install list) — an injection into an
  uninstalled grammar silently no-ops rather than erroring.

### Testing Requirements
- No automated tests cover this directory's `.scm` content.
- Real verification: open a buffer of the target language, place the cursor
  on the node in question, and use `:InspectTree` (or `:Inspect` for a
  single position) to confirm the expected capture group appears; for
  injections, confirm the injected language's own highlighting/LSP applies
  inside the injected range.
- After editing `lua/plugins/tree-sitter.lua` parser registration (e.g. for
  `goasm` or `printf`), run `nvim --headless "+Lazy! sync" +qa` and check
  `~/.local/share/nvim/tree-sitter/parser/<name>.so` exists before assuming
  a query referencing that language will work.

### Common Patterns
- `; extends` (single semicolon) and `;; extends` (double) are both used in
  this repo interchangeably — Neovim accepts either. Both must still be on
  line 1.
- `#lua-match?`, `#match?`, `#any-of?`, `#contains?`, `#eq?`, `#offset!`, and
  `#set! injection.language "<x>"` are the predicate/directive vocabulary
  used throughout; `go/injections.scm` is the densest example, layering
  multiple heuristics (exact keyword match, `#contains?` keyword lists) for
  the same SQL-injection goal to cover different tree-sitter/grammar
  versions.
- Several files carry inline provenance comments crediting an upstream
  source (`go/injections.scm` and `go/locals.scm` both credit
  `ray-x/go.nvim`'s `after/queries/go/*.scm`) — preserve this convention
  when porting a query from elsewhere.

### Known Gotcha: `; extends` / `;; extends` must be on line 1
An extends modeline that appears after a blank line (or any other content)
is not honored — Neovim then treats the file as a full *replacement* of the
upstream query instead of an extension, silently dropping every capture the
upstream file provided. Audited every `.scm` file's literal first line:

| File | Line 1 | Verdict |
|------|--------|---------|
| `diff/injections.scm` | `; extends` | OK |
| `go/highlights.scm` | `;; extends` | OK |
| `go/injections.scm` | `;; extends` | OK |
| `go/locals.scm` | `;; extends` | OK |
| `goasm/highlights.scm` | `; Tree-sitter highlights for Go (Plan 9) assembly.` | N/A — intentional full replacement, no upstream query exists to extend |
| `goasm/injections.scm` | `; Tree-sitter injections for Go (Plan 9) assembly.` | N/A — same |
| `goasm/tags.scm` | `; Tree-sitter tags for Go (Plan 9) assembly.` | N/A — same |
| `json/injections.scm` | `; extends` | OK |
| `lua/highlights.scm` | `; extends` | OK |
| `markdown/injections.scm` | `; extends` | OK |
| `markdown_inline/highlights.scm` | `;; extends` | OK |
| `printf/highlights.scm` | `;; extends` | OK |
| `python/highlights.scm` | `; extends` | OK |
| `yaml/injections.scm` | `; extends` | OK |

No file in this repo has the modeline present-but-misplaced (i.e. after a
blank line) — the specific silent-replacement bug does not currently occur
here. One finding worth flagging:

- **`markdown_inline/highlights.scm`'s own header comment documents this
  exact gotcha on the upstream side**: it explains that nvim-treesitter's
  *bundled* `markdown_inline/highlights.scm` ships without an
  `;; extends` modeline, so it fully replaces the runtime's base query and
  drops backslash-escape conceal rules — which is why this file exists, to
  restore them. Worth knowing this file is itself a workaround for the
  class of bug this audit checks for, just triggered upstream rather than
  in this repo.

## Dependencies

### Internal
- `goasm/*` requires the `goasm` parser from `lua/plugins/tree-sitter.lua`
  (`parser_config.goasm`) and filetype detection from
  `lua/filetypes/goasm.lua`.
- Injection targets (`sql`, `json`, `bash`, `twig`, `tsx`, `printf`,
  `comment`) each require the corresponding parser to be installed via
  `lua/plugins/tree-sitter.lua`.

### External
- nvim-treesitter — supplies the base `highlights.scm`/`injections.scm`/
  `locals.scm` that the `extends`-modeline files merge into.
- `github.com/zchee/tree-sitter-goasm` (external repo, symlinked in) —
  authoritative source for `goasm/`'s three query files.
- `ray-x/go.nvim` — credited as the origin of `go/injections.scm` and
  `go/locals.scm`'s base content.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
