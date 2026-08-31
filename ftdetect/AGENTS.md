<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-01 -->

# ftdetect

## Purpose
Filetype detection scripts Neovim autoloads on startup (runtimepath
`ftdetect/*` convention). Used for cases the simpler declarative
`vim.filetype.add()` table in root `filetype.lua` cannot express cleanly —
buffer content sniffing, multi-pattern filename matching, or setting
buffer-local options alongside the filetype. Mixes modern Lua
(`nvim_create_autocmd`) and legacy Vimscript `autocmd`/`au` one-liners.

## Key Files
| File | Description |
|------|-------------|
| `buf.lua` | `buf.gen`/`buf.lock`/`buf.mod`/`buf.work` (Buf CLI config files) → `yaml` |
| `gotestlog.vim` | `.log` files whose first line matches `^=== .+` → `gotestlog` |
| `ispc.vim` | `*.ispc` → `ispc` |
| `jinja.vim` | `.html`/`.htm` scanned (first 50 lines) for Jinja/Django tag syntax → `jinja.html`; `.jinja2`/`.j2`/`.jinja`/`.nunjucks`/`.nunjs`/`.njk` → `jinja` |
| `npmrc.lua` | `npmrc` / `.npmrc` → `npmrc` |
| `tigrc.lua` | `.tigrc` / `tigrc` → `tigrc` |

Former residents now handled by root `filetype.lua`: `goasm.lua` (`.s`
delegation to `require("filetypes.goasm").detect`), `gotmpl.vim` (the old
compound `go.gotmpl` content sniff is now a bounded 20-line `gotmpl`
fallback pattern), and `kitty.lua` (kitty rules in `filetype.lua`;
`comments`/`commentstring` moved to `after/ftplugin/kitty.lua` because
`$VIMRUNTIME` resets them).

## For AI Agents

### Working In This Directory
- Prefer root `filetype.lua`'s `vim.filetype.add()` tables (`extension` /
  `filename` / `pattern` keys) for simple string-to-filetype mappings; only
  add a file here when detection needs buffer content inspection beyond
  what a `vim.filetype.add()` pattern function expresses cleanly (see
  `gotestlog.vim`, `jinja.vim`).
- New scripts may be Lua (`nvim_create_autocmd({"BufNewFile","BufReadPost"|"BufRead"}, ...)`)
  or legacy Vimscript `autocmd`/`au BufRead,BufNewFile` — both load
  automatically from this directory; match the style of the nearest similar
  file rather than mixing conventions within one file.
- Go templates use the single filetype `gotmpl` everywhere: the
  extension/pattern routing and the bounded content-sniff fallback in root
  `filetype.lua`, `ftplugin/gotmpl.lua`, and `queries/gotmpl/` all target
  it. The old compound `go.gotmpl` (set by the deleted `gotmpl.vim`) no
  longer exists — do not reintroduce it.

### Testing Requirements
No automated specs cover this directory. Verify manually per file:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'edit <sample-file>' -c 'echo &filetype' -c 'qa'`
against a real sample of the target file (or a scratch buffer with matching
content, for the content-sniffing scripts).

### Common Patterns
- Lua scripts guard with `nvim_create_autocmd({"BufNewFile","BufReadPost"|"BufRead"}, { pattern = {...}, callback = function() vim.bo.filetype = "..." end })`.
- Legacy Vimscript scripts use a single `au BufRead,BufNewFile <pattern> ...`
  line, occasionally delegating to a `s:`-scoped function for multi-line
  content checks (`gotestlog.vim`, `jinja.vim`).

## Dependencies

### Internal
- Filetypes set here are consumed by matching `ftplugin/*.lua` and
  `syntax/*.vim`/`indent/*.vim` files (e.g. `kitty` → `ftplugin/kitty.lua` +
  `syntax/kitty.vim`; `jinja` → `indent/jinja.vim` + `syntax/jinja.vim`;
  `tigrc` → `ftplugin/tigrc.lua` + `syntax/tigrc.vim`).

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
