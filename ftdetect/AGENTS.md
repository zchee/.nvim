<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# ftdetect

## Purpose
Filetype detection scripts Neovim sources when filetype detection starts
(runtimepath `ftdetect/*` convention). Only detection that has to read a
buffer's content lives here; every name, extension or path rule is a
`vim.filetype.add()` entry in root `filetype.lua`, where
`vim.filetype.match()` sees it too (an autocmd here is invisible to it).
Both scripts are legacy Vimscript `autocmd`s.

## Key Files
| File | Description |
|------|-------------|
| `gotestlog.vim` | `*.log` whose first line matches `^=== .+` (`go test -v` output) -> `gotestlog` |
| `jinja.vim` | `.html`/`.htm` scanned (first 50 lines) for Jinja/Django tag syntax -> `jinja.html`; `.jinja2`/`.j2`/`.jinja`/`.nunjucks`/`.nunjs`/`.njk` -> `jinja` |

Former residents now handled by root `filetype.lua` (or the runtime):
`goasm.lua` (`.s` delegation to `require("filetypes.goasm").detect`),
`gotmpl.vim` (the old compound `go.gotmpl` content sniff is now a bounded
20-line `gotmpl` fallback pattern), `kitty.lua` (kitty rules in
`filetype.lua`; `comments`/`commentstring` in `after/ftplugin/kitty.lua`),
`tigrc.lua` and `ispc.vim` (plain name/extension entries), `buf.lua` (it
named `buf.gen`/`buf.mod`/`buf.work`, which Buf never writes; the runtime
maps `buf.lock` to yaml), and `npmrc.lua` (it forced a syntax-less `npmrc`
filetype over the runtime's `dosini`).

## For AI Agents

### Working In This Directory
- Add a file here only when detection must read buffer content beyond what
  a `vim.filetype.add()` pattern function expresses (see `gotestlog.vim`,
  `jinja.vim`). Name, extension and path rules go in root `filetype.lua`,
  and `tests/filetype_rules_spec.lua` gets a case for each.
- An autocmd here runs after `vim.filetype.match()` has set a filetype and
  overwrites it unconditionally; prefer `setfiletype` (as `gotestlog.vim`
  does), which only sets a filetype when none is set yet.
- Go templates use the single filetype `gotmpl` (`filetype.lua` routing and
  its bounded content fallback, `ftplugin/gotmpl.lua`). The old compound
  `go.gotmpl` and the `gotexttmpl`/`gohtmltmpl` filetypes are gone -- do
  not reintroduce them.

### Testing Requirements
`nvim --headless -u NONE -i NONE -l tests/filetype_rules_spec.lua` opens a
real file per case with this directory's scripts sourced (includes the
`gotestlog` case).

### Common Patterns
- A single `au BufRead,BufNewFile <pattern> ...` line, delegating to an
  `s:`-scoped function for multi-line content checks.

## Dependencies

### Internal
- `jinja` -> `indent/jinja.vim` + `syntax/jinja.vim`; `gotestlog` ->
  `syntax/gotestlog.vim`.

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
