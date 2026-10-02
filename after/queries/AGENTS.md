<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-10-03 -->

# after/queries

## Purpose
Tree-sitter query overrides, one subdirectory per language/parser name (11
total: `diff`, `go`, `goasm`, `json`, `lua`, `markdown`,
`markdown_inline`, `printf`, `python`, `rust`, `yaml`). Ten of the eleven use
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
| `go/` | `injections.scm` (extends) | SQL injection into string literals through one `#match?` anchored at the start of the content: an upper-case statement keyword (`SELECT`, `INSERT`, `CREATE`, `WITH`, `BEGIN`, ...) followed by more text, a lower-case `select`/`insert`/`update`/`delete` that later reaches `from`/`into`/`set`/`values`, or a `-- sql` marker, after optional leading whitespace including a line break and any number of leading SQL comments (whole `--` lines and `/* */` blocks, so sqlc's `-- name: GetUser :one` queries inject; a string holding only comments stays plain unless one of them is the `-- sql` marker). Each run of an interpreted string between escape sequences is its own content node and is matched on its own. Import paths, prose and Go error strings led by a verb other than `select`/`insert`/`update`/`delete` stay plain (`"update failed: read from %s"` is injected); the `from`/`into`/`set`/`values` and `sql` word boundaries depend on 'iskeyword' (see Common Patterns); known false positives are HTTP mux patterns such as `"DELETE example.com/..."` and upper-case-led messages such as `"SELECT on table %q ..."`, plus raw strings whose first line after any leading `--` lines (a txtar `-- go.mod --` header, a `---` diff line, a prose note) opens with such a keyword, since every leading `--` line is skipped whatever it says. The captured `*_string_literal_content` nodes already exclude the quotes, so the pattern carries no `#offset!`), JSON injection into const/var/`:=` raw string literals holding one `{...}` object (they capture the `raw_string_literal_content` child, since an injection leaves a captured node's children out of the region), and `printf`-grammar injection for raw string literals passed to `Printf`/`Sprintf`/`Fprintf`/etc. — the last one exists specifically because upstream nvim-treesitter only injects `printf` into `interpreted_string_literal`, not raw strings |
| `go/` | `locals.scm` (extends) | `var_spec` as `local.scope`, struct field declarations, interface method elements, struct/interface `type_declaration` as `local.name`/`local.type` |
| `goasm/` | `highlights.scm`, `injections.scm`, `tags.scm` (symlinks — full base queries, not extends) | Comments incl. `//go:*`/`//line` pragma detection, C-style preprocessor directives, labels, and (in `tags.scm`) ctags-style function/data/label/macro definitions plus call/jump-target references across many architectures (amd64/arm64/riscv64/etc.) |
| `json/` | `injections.scm` (extends) | Injects `bash` into the string value of nested pairs under a `"scripts"` key (npm `package.json` convention) |
| `lua/` | `highlights.scm` (extends) | Highlights the identifier `vim` as `@namespace.builtin` |
| `markdown/` | `injections.scm` (extends) | Injects `tsx` into inline nodes matching `^(import\|export)` (MDX-style import/export lines) |
| `markdown_inline/` | `highlights.scm` (extends) | Restores backslash-escape and hard-line-break conceal rules that nvim-treesitter's *own* `markdown_inline/highlights.scm` drops (see gotcha audit — this file's header comment documents exactly the upstream failure mode this section audits for) |
| `printf/` | `highlights.scm` (extends) | `(format) @printf` |
| `python/` | `highlights.scm` (extends) | Highlights module/class/function/method docstrings and bare-string "attribute docstrings" as `@comment` |
| `rust/` | `highlights.scm` (extends) | Inside an `invocations!` macro body (a flat `token_tree`, so every name would land on `@variable`), highlights the DSL's `field: kind "flag";` statements: field as `@property`, kind as `@keyword`, at priority 110 to beat the base query's equal-priority `@variable` |
| `yaml/` | `injections.scm` (extends) | Injects `twig` (stand-in for the absent Jinja2 grammar, per the file's own comment) into block/flow scalar values containing `{{` or `{%`. No `twig` parser is installed today, so this injection is a no-op |

## For AI Agents

### Working In This Directory
- New query files must live at `queries/<language>/<highlights|injections|
  locals|tags>.scm` where `<language>` is the Tree-sitter parser/language
  name (not always the same as the Neovim filetype — see `lua/plugins/
  tree-sitter.lua` for `vim.treesitter.language.register()` calls that map
  filetypes like `tiltfile`/`jsonschema`/`helm`/`metal` onto a parser name).
- To *extend* an upstream nvim-treesitter query (the normal case), start the
  file with `; extends` or `;; extends` as the literal first line — see the
  gotcha audit below for why this is strict. To *replace* an upstream query
  outright, omit the modeline (rare in this repo — currently only justified
  for `goasm/`, a grammar with no upstream queries at all).
- `goasm/*.scm` are symlinks to a sibling repo
  (`~/src/github.com/zchee/tree-sitter-goasm`), whose upstream
  (`github.com/zchee/tree-sitter-goasm`) is the parser's install source in
  the `lua/nvim-treesitter/parsers.lua` overlay. Edit the target repo
  directly, not through these symlinks in isolation -- a change here without
  a corresponding upstream commit will not survive a fresh clone of that repo.
- Before adding an `injection.language "<x>"` capture, confirm a parser for
  `<x>` is installed (`~/.local/share/nvim/tree-sitter-main/parser/<x>.so`,
  nvim-treesitter's `install_dir` from `lua/plugins/tree-sitter.lua`) -- an
  injection into an uninstalled grammar silently no-ops rather than erroring.

### Testing Requirements
- No automated tests cover this directory's `.scm` content.
- Real verification: open a buffer of the target language, place the cursor
  on the node in question, and use `:InspectTree` (or `:Inspect` for a
  single position) to confirm the expected capture group appears; for
  injections, confirm the injected language's own highlighting/LSP applies
  inside the injected range.
- `vim.treesitter.query.get_files(<lang>, <kind>)` lists the files a query
  resolves from; a file here missing from that list is not loaded.
- After changing a parser entry in `lua/nvim-treesitter/parsers.lua`,
  install it with nvim-treesitter's `:TSInstall <name>` and check
  `~/.local/share/nvim/tree-sitter-main/parser/<name>.so` exists before
  assuming a query referencing that language will work.

### Common Patterns
- `; extends` (single semicolon) and `;; extends` (double) are both used in
  this repo interchangeably — Neovim accepts either. Both must still be on
  line 1.
- `#lua-match?`, `#match?`, `#any-of?`, `#contains?`, `#eq?`, `#offset!`, and
  `#set! injection.language "<x>"` are the predicate/directive vocabulary
  used throughout. `#contains?` with several strings needs every one of them
  in the node's text (`#any-contains?` needs one). `#match?` compiles a vim
  regex, very magic unless the pattern starts with its own `\v`/`\m`/`\M`/`\V`,
  and matches the node text as one string, in which `\s`, `\_s` and `\n` never
  match a newline character and `[^\n]` does not exclude one; `[[:space:]]`, `.`
  and `[\d10]` match it and `[^\d10]` excludes it. Its `<`/`>` word
  boundaries use the 'iskeyword' of whichever buffer is current when the
  match runs, not of the parsed buffer (`regexp.c` sets `reg_buf = curbuf`),
  so a word boundary can differ between two parses of the same text.
  `#offset! @x 0 1 0 -1` strips a node's first and last character: right on
  a whole `raw_string_literal` (backticks included), wrong on a
  `*_string_literal_content` node, which has no quotes to strip.
  `go/injections.scm` is the densest example: one SQL `#match?`, three JSON
  patterns and two printf patterns, with its older SQL patterns kept as
  commented-out reference.
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
| `rust/highlights.scm` | `;; extends` | OK |
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
- `goasm/*` requires the `goasm` parser entry in
  `lua/nvim-treesitter/parsers.lua` and filetype detection from
  `lua/filetypes/goasm.lua`.
- Injection targets (`sql`, `json`, `bash`, `twig`, `tsx`, `printf`,
  `comment`) each require the corresponding parser to be installed (`twig`
  is not, today).

### External
- nvim-treesitter — supplies the base `highlights.scm`/`injections.scm`/
  `locals.scm` that the `extends`-modeline files merge into.
- `github.com/zchee/tree-sitter-goasm` (external repo, symlinked in) —
  authoritative source for `goasm/`'s three query files.
- `ray-x/go.nvim` — credited as the origin of `go/injections.scm` and
  `go/locals.scm`'s base content.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
