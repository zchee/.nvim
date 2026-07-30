<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/luasnippets

## Purpose
LuaSnip snippet definitions loaded via `luasnip.loaders.from_lua`, pointed at
`stdpath("config")/lua/luasnippets` from both `lua/plugins/cmp.lua` and
`lua/plugins/blink.lua`. Each file (other than `all.lua`) is named after the
filetype it targets and calls `ls.add_snippets(<filetype>, ...)` for that
filetype's completion source (`go`, `dockerfile`, `markdown`, `sh`, `yaml`).
`all.lua` holds filetype-agnostic global snippets and returns them as a
plain table for the "all"/global load path instead of calling
`ls.add_snippets` itself.

## Key Files
| File | Description |
|------|--------------|
| `all.lua` | Global snippets (`todo`, `note`, `devnull`); returns table, several ideas commented out |
| `dockerfile.lua` | `syntax`/`check` snippets for Dockerfile frontmatter directives |
| `go.lua` | Largest file: func/error/test/benchmark/doc snippets, gated by treesitter context checks |
| `markdown.lua` | GitHub alert-block snippets (`> [!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]`, `[!CAUTION]`) |
| `sh.lua` | `shebang` (strict-mode bash) and `devnull` snippets |
| `yaml.lua` | Single `yaml-language-server` schema-comment snippet |

## For AI Agents

### Working In This Directory
- Snippet files fall into two shapes: files that `return { ls.s(...), ... }`
  as a plain table for lazy loading (`all.lua`, `dockerfile.lua`,
  `markdown.lua`, `sh.lua`, `yaml.lua`), and `go.lua`, which builds separate
  tables (`func_snippets`, `test_snippets`, `doc_snippets`) and explicitly
  calls `ls.add_snippets("go", ..., { refresh_notify = true, type =
  "snippets" })` for each — follow whichever pattern the target filetype's
  file already uses.
- `go.lua` gates many snippets with `show_condition`/`condition` tables
  (`in_fn`, `not_in_fn`, `in_test_fn`, `in_test_file`) built on
  `nvim-treesitter.ts_utils.get_node_at_cursor()` walking up to
  `function_declaration`/`method_declaration`, and on `_test.go` filename
  matching. Reuse these tables instead of re-deriving the same checks.
  Note this makes `go.lua` implicitly depend on `nvim-treesitter.ts_utils`
  even though it is not declared as a plugin dependency in this directory.
- Prefer `fmt`/`fmta` from `luasnip.extras.fmt` for multi-line snippets
  (see `go.lua`, `dockerfile.lua`, `markdown.lua`) over manually
  concatenating `ls.t`/`ls.i` nodes.
- `go.lua` defines a `trig = "ft"` snippet twice — once in `func_snippets`
  (`fmt.Printf("%T = %#v")`) and once in `test_snippets`
  (`t.Logf("%T = %#v")`) — this is intentional since the two are added under
  different `show_condition`s (`in_fn` vs `in_test_fn`), not a duplicate bug.
- New filetype-specific snippets go in a new `<filetype>.lua` file named
  after the target filetype; global snippets go in `all.lua`.

### Testing Requirements
No spec file exists for this directory. Verify snippet files load without
error headlessly, e.g.:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'lua require("luasnip"); require("luasnippets.go")' -c 'qa'`
For interactive verification, open a buffer of the target filetype and
trigger the snippet through the configured completion engine.

### Common Patterns
- Snippet tables use `ls.s({ trig = ..., name = ..., dscr = ... }, ...)`
  with `trig`/`dscr` set on essentially every snippet; `name` is used more
  sparingly (mostly on multi-node snippets).
- Insert nodes follow numeric jump order (`ls.i(1)`, `ls.i(2)`, ..., `ls.i(0)`
  as the final cursor stop).

## Dependencies

### Internal
None.

### External
`L3MON4D3/LuaSnip` (snippet engine, `ls`, `ls.extras.fmt`), consumed via
`lua/plugins/cmp.lua` / `lua/plugins/blink.lua`; `go.lua` additionally
depends on `nvim-treesitter/nvim-treesitter`'s `ts_utils` module for
function-scope detection.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
