<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

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
| `goasm.lua` | Registers `vim.filetype.add({ extension = { s = ... } })`, delegating `.s` files to `require("filetypes.goasm").detect` (see `lua/filetypes/AGENTS.md`) |
| `gotestlog.vim` | `.log` files whose first line matches `^=== .+` → `gotestlog` |
| `gotmpl.vim` | Any new/read buffer containing `{{...}}` → `go.gotmpl` (content sniff, not extension-based) |
| `ispc.vim` | `*.ispc` → `ispc` |
| `jinja.vim` | `.html`/`.htm` scanned (first 50 lines) for Jinja/Django tag syntax → `jinja.html`; `.jinja2`/`.j2`/`.jinja`/`.nunjucks`/`.nunjs`/`.njk` → `jinja` |
| `kitty.lua` | Appends `#`/`#:` comment leaders; `kitty.conf` / `*/kitty/*.conf` → `kitty`; `*/kitty/*.session` → `kitty-session` |
| `npmrc.lua` | `npmrc` / `.npmrc` → `npmrc` |
| `tigrc.lua` | `.tigrc` / `tigrc` → `tigrc` |

## For AI Agents

### Working In This Directory
- Prefer root `filetype.lua`'s `vim.filetype.add()` tables (`extension` /
  `filename` / `pattern` keys) for simple string-to-filetype mappings; only
  add a file here when detection needs buffer content inspection (see
  `gotestlog.vim`, `gotmpl.vim`, `jinja.vim`) or side effects beyond setting
  `filetype` (see `kitty.lua`'s `comments` option).
- New scripts may be Lua (`nvim_create_autocmd({"BufNewFile","BufReadPost"|"BufRead"}, ...)`)
  or legacy Vimscript `autocmd`/`au BufRead,BufNewFile` — both load
  automatically from this directory; match the style of the nearest similar
  file rather than mixing conventions within one file.
- `gotmpl.vim` sets filetype `go.gotmpl` (compound, content-triggered on any
  buffer), while extension-based routing elsewhere (`tmpl`/`tpl` in root
  `filetype.lua`, `ftplugin/gotmpl.lua`, `queries/gotmpl/`) targets plain
  `gotmpl`. These are two different filetypes by Neovim's rules (a
  compound filetype `go.gotmpl` is not the same as `gotmpl`) — verify which
  one a change actually needs before assuming they are interchangeable.

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
- `goasm.lua` → `lua/filetypes/goasm.lua` (`M.detect(path, bufnr)`)
- Filetypes set here are consumed by matching `ftplugin/*.lua` and
  `syntax/*.vim`/`indent/*.vim` files (e.g. `kitty` → `ftplugin/kitty.lua` +
  `syntax/kitty.vim`; `jinja` → `indent/jinja.vim` + `syntax/jinja.vim`;
  `tigrc` → `ftplugin/tigrc.lua` + `syntax/tigrc.vim`).

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
