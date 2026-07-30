<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# ftplugin

## Purpose
Top-level per-filetype settings, loaded by Neovim's runtimepath convention
whenever a buffer's `filetype` matches a file's basename here. Mostly small
Lua scripts that set `vim.opt_local`/`vim.bo` indent, comment, and fold
options for a filetype; a couple carry buffer-local keymaps or delegate to
another filetype's plugin/syntax file. Distinct from `after/ftplugin/`
(documented separately), which loads later and layers on top of a plugin's
own ftplugin.

## Key Files
| File | Description |
|------|-------------|
| `devicetree.lua` | `.keymap`/devicetree files: noexpandtab, `sw=4 sts=4 ts=8` |
| `gohtmltmpl.lua` | Go HTML templates: `did_ftplugin` guard, then `runtime ftplugin/html.lua` |
| `gomod.lua` | `go.mod`: `sw=ts=sts=4`, noexpandtab, Go-style `comments`/`commentstring`, drops `t` from `formatoptions` |
| `gotmpl.lua` | Go templates: `runtime! syntax/go.vim`, same indent/comment settings as `gomod.lua` |
| `gowork.lua` | `go.work`: same indent/comment settings as `gomod.lua`, set via `vim.opt_local` instead of `vim.bo`/`vim.opt` |
| `headlines.vim` | Vimscript, `did_ftplugin` guard; maps buffer-local `q` to `:q<CR>` |
| `help.vim` | Vimscript; adjusts mouse-click and cursor-movement column position around concealed characters in `:help` buffers |
| `java.lua` | Entirely commented out — dormant `jdtls.start_or_attach()` scaffold, not active |
| `jsonschema.lua` | `expandtab`, `sw=sts=ts=2`, `conceallevel=0` |
| `kitty.lua` | `commentstring = "# %s"` |
| `modulemap.lua` | Entirely commented out — dormant scaffold referencing a `FileType` autocmd that was never implemented |
| `proto.lua` | Protobuf: `autoindent`/`cindent`, `colorcolumn=100`, `commentstring=//\ %%s`, `copyindent`, `expandtab`, `formatoptions+=croq`, `sw=4 sts=4 ts=8`, `smartindent=false`, `smarttab=true`, `foldmethod=expr` (Tree-sitter `foldexpr` line is commented out) |
| `quickfix.lua` | Quickfix window: `list=false`, `number=false` |
| `sh.lua` | Shell scripts: `expandtab`, `sw=ts=sts=2` |
| `tigrc.lua` | `tig` config: `commentstring="# %s"`, `comments=":#"`, sets `b:undo_ftplugin` to restore both on filetype change |
| `tiltfile.lua` | `Tiltfile`: `commentstring="# %s"`, `expandtab`, `sw=sts=ts=4` |

## For AI Agents

### Working In This Directory
- Guard against double-sourcing with `if vim.b.did_ftplugin then return end`
  / `vim.b.did_ftplugin = true` (Lua) or `if exists('b.did_ftplugin') |
  finish | endif` (Vimscript) — most files here follow this, but not all
  (`devicetree.lua`, `jsonschema.lua`, `kitty.lua`, `proto.lua`,
  `quickfix.lua`, `tiltfile.lua` skip the guard since they only set
  idempotent `opt_local` values with no side effects worth guarding).
- `java.lua` and `modulemap.lua` are inert stubs (100% commented out). Either
  implement them for real (`jdtls` for Java, a `FileType` autocmd + syntax
  wiring for `modulemap`) or leave them as intentional placeholders — don't
  assume either currently does anything.
- Prefer `vim.opt_local.*` for new files (most recent additions use this);
  `vim.bo.*`/`vim.opt.*` in `gomod.lua`/`gotmpl.lua` predate
  that convention.
- A filetype needing only option changes belongs here; anything requiring
  buffer-scoped detection logic belongs in `lua/filetypes/` + `ftdetect/`
  instead.

### Testing Requirements
No automated specs. Verify manually:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'edit <file-of-filetype>' -c 'setfiletype <ft>' -c 'verbose set shiftwidth? expandtab? commentstring?' -c 'qa'`
and confirm the expected options were applied (and, for `verbose set`, which
file set them last).

### Common Patterns
- One file per filetype, named exactly after the `filetype` value it targets
  (matches an entry in root `filetype.lua` or a script in `ftdetect/`).
- Indent settings (`shiftwidth`/`tabstop`/`softtabstop`/`expandtab`) and
  `commentstring`/`comments` are the two most common concerns; a handful add
  `formatoptions` tweaks or `foldmethod`.

## Dependencies

### Internal
- Filetype names here are produced by root `filetype.lua` or scripts in
  `ftdetect/` (e.g. `kitty` from `ftdetect/kitty.lua`, `jinja` from
  `ftdetect/jinja.vim`, `tigrc` from `ftdetect/tigrc.lua`).
- `gohtmltmpl.lua` and `gotmpl.lua` `runtime` other ftplugin/syntax files
  directly (`ftplugin/html.lua`, `syntax/go.vim`).

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
