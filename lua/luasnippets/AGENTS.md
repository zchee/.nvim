<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# lua/luasnippets

## Purpose
LuaSnip snippet definitions, one file per filetype plus `all.lua` for
filetype-agnostic snippets. `lua/plugins/luasnip.lua` loads them with
`luasnip.loaders.from_lua` (`lazy_paths = { stdpath("config")/lua/luasnippets }`),
one filetype at a time through `load_snippets_ft(ft)`: the driver sets `go`
and `all` register eagerly (in their own `config.warmup` ticks when a warmup
runs), and every other filetype registers on its first `InsertEnter`
(`luasnip_ft_snippets` augroup). A new `<filetype>.lua` file therefore needs
no registration anywhere.

## Key Files
| File | Description |
|------|-------------|
| `all.lua` | Global snippets (`todo`, `note`, `devnull`); returns its table; further ideas kept commented out |
| `dockerfile.lua` | `syntax`/`check` snippets for Dockerfile frontmatter directives |
| `go.lua` | Largest file: func/error/iter/fmt/test/benchmark/doc snippets; in-function and test-only snippets are gated by `condition`/`show_condition`; registers itself with `ls.add_snippets("go", ...)` |
| `markdown.lua` | GitHub alert-block snippets (`high-note`, `high-tip`, `high-important`, `high-warning`, `high-caution`) |
| `python.lua` | `uv_shebang`: the uv inline-script header (PEP 723) |
| `sh.lua` | `shebang`: bash shebang with strict mode (`devnull` comes from `all.lua`) |
| `yaml.lua` | Single `yaml-language-server` schema-comment snippet |

## For AI Agents

### Working In This Directory
- Two file shapes are in use and both work with the `from_lua` loader: a
  file that returns `{ ls.s(...), ... }` (every file but `go.lua`), and
  `go.lua`, which builds `func_snippets`, `test_snippets` and `doc_snippets`
  and calls `ls.add_snippets("go", ..., { refresh_notify = true, type =
  "snippets" })` for each. Follow the shape the target file already uses.
- Conditions go to `ls.s()` as its third argument (the snippet opts), never
  to `fmt()`/`fmta()`, whose third argument is fmt's own options table and
  silently drops them. `go.lua` passes `in_fn`, `in_test_fn` and
  `in_test_file` this way; they are built on `vim.treesitter.get_node()`
  walking up to `function_declaration`/`method_declaration`, and on the
  `_test.go` filename. Reuse those tables instead of re-deriving the checks.
- `go.lua` defines `trig = "ft"` twice — `fmt.Printf("%T = %#v")` under
  `in_fn` and `t.Logf("%T = %#v")` under `in_test_fn`. That is intentional,
  not a duplicate.
- A trigger that belongs to every filetype goes in `all.lua` only; repeating
  it in a filetype file offers it twice.
- Prefer `fmt`/`fmta` from `luasnip.extras.fmt` for multi-line snippets.
  `fmta` reads `<>` as its delimiters, so a literal `>` must be doubled
  (`>>`), and `{`/`}` are literal; in `fmt` it is the other way round.

### Testing Requirements
`nvim --headless -u NONE -i NONE -l tests/luasnippets_parse_spec.lua` loads
every file under this directory, fails on any load error, and asserts that
each gated Go snippet is hidden and refuses to expand outside its context
while ungated ones stay available. For interactive checks, open a buffer of
the target filetype and trigger the snippet through blink.cmp.

### Common Patterns
- Snippets use `ls.s({ trig = ..., name = ..., dscr = ... }, ...)` with
  `trig`/`dscr` on essentially every snippet; `name` mostly on multi-node
  snippets.
- Insert nodes follow numeric jump order (`ls.i(1)`, `ls.i(2)`, ...,
  `ls.i(0)` as the final cursor stop).

## Dependencies

### Internal
Loaded by `lua/plugins/luasnip.lua`; `lua/config/warmup.lua` and
`lua/plugins/blink.lua` call its loader.

### External
`L3MON4D3/LuaSnip` (`luasnip`, `luasnip.extras.fmt`); Neovim's
`vim.treesitter` for `go.lua`'s function-scope checks.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
