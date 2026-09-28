<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# ftplugin

## Purpose
Per-filetype settings that load BEFORE `$VIMRUNTIME`'s own ftplugin for the
same filetype (this repo precedes the runtime on 'runtimepath'). That order
makes this directory right for filetypes Neovim ships no ftplugin for, and
wrong for overriding one that it does: settings meant to win over a runtime
ftplugin belong in `after/ftplugin/` (see `after/ftplugin/AGENTS.md`).

## Key Files
| File | Description |
|------|-------------|
| `devicetree.lua` | `devicetree` (`*.keymap`, from `filetype.lua`): guard; noexpandtab, `sw=4 sts=4 ts=8`; C-style `comments` and `commentstring = "/* %s */"`, the string `$VIMRUNTIME/ftplugin/dts.vim` uses, which is also what `gcc` resolves through the devicetree parser (registered for `dts` as well) |
| `goasm.lua` | Plan 9 assembly as Go's assembler takes it: `commentstring = "// %s"`, which nothing else set (`gcc` was a silent no-op on these buffers). Its other job is existing at all -- `lua/filetypes/goasm.lua` detects the filetype with a function, and a function in the registry is invisible to `vim.filetype._get_known_filetypes()`, so without a runtime file naming `goasm` both `lsp/asm_lsp.lua` and `lsp/gopls.lua` drew an "Unknown filetype" warning from `:checkhealth vim.lsp` |
| `gomod.lua` | `go.mod`: guard; `sw=ts=sts=4`, noexpandtab, Go-style `comments`/`commentstring`, drops `t` from `formatoptions`. Its guard also suppresses `$VIMRUNTIME/ftplugin/gomod.vim`, whose `formatoptions-=c` and `b:undo_ftplugin` are therefore not applied |
| `gotmpl.lua` | Go templates: guard; `runtime! syntax/go.vim`, same indent/comment settings as `gomod.lua` |
| `gowork.lua` | `go.work`: guard; same indent/comment settings as `gomod.lua` |
| `hujson.lua` | HuJSON (JWCC): `runtime! ftplugin/jsonc[.]{vim,lua}`, so it takes jsonc's settings wholesale -- `$VIMRUNTIME/ftplugin/jsonc.vim` (`commentstring = "// %s"`, `//` and `/* */` `comments`, and json's own ftplugin underneath) and `after/ftplugin/jsonc.lua` (indent), since the rtp carries the after/ dirs. Then `noexpandtab`, since `hujsonfmt` (`lua/plugins/conform.lua`) indents with tabs; jsonc's `sw=ts=2` makes one level one tab. Nvim ships no hujson ftplugin, so without it `gcc` failed with "Option 'commentstring' is empty". No guard of its own: the sourced json ftplugin sets `b:did_ftplugin`. Pinned by `tests/hujson_ftplugin_spec.lua` |
| `java.lua` | Entirely commented out -- dormant `jdtls.start_or_attach()` scaffold, not active |
| `jsonschema.lua` | `expandtab`, `sw=sts=ts=2`, `conceallevel=0` |
| `metal.lua` | Metal Shading Language: `commentstring = "// %s"`. Like `goasm.lua` it also exists so `metal` is a filetype nvim knows -- `filetype.lua` maps the extension, `lua/plugins/tree-sitter.lua` registers the `cpp` parser for it, and `lsp/clangd.lua` deliberately does NOT list it (upstream clangd has no Metal mode and compiles a shader as C) |
| `modulemap.lua` | Entirely commented out -- a note on the old autocmd detection. The filetype itself is live: `filetype.lua` maps `*.modulemap` and `syntax/modulemap.lua` highlights it |
| `proto.lua` | Protobuf: `autoindent`/`cindent`, `colorcolumn=100`, `commentstring = "// %s"`, `copyindent`, `expandtab`, `formatoptions+=croq`, `sw=4 sts=4 ts=8`, `smartindent=false`, `smarttab=true`, buffer-local `foldmethod=expr` (the Tree-sitter `foldexpr` line is commented out). No guard, so `$VIMRUNTIME/ftplugin/proto.vim` still runs after it |
| `qf.lua` | Quickfix/location-list windows (filetype `qf`): `nolist`, `nonumber` |
| `tigrc.lua` | `tig` config: guard; `commentstring="# %s"`, `comments=":#"`, sets `b:undo_ftplugin` to restore both on filetype change |
| `tiltfile.lua` | `Tiltfile`: `commentstring="# %s"`, `expandtab`, `sw=sts=ts=4` |

## For AI Agents

### Working In This Directory
- Check `$VIMRUNTIME/ftplugin/<ft>.{vim,lua}` first. When it exists, put the
  settings in `after/ftplugin/<ft>.lua` with no guard: a file here that sets
  `b:did_ftplugin` switches the runtime ftplugin off entirely (that is how
  `sh` buffers lost their commentstring and `help` buffers their conceal
  until both moved to after/). When it does not exist, this directory is
  the place, and the Lua guard is `if vim.b.did_ftplugin then return end` /
  `vim.b.did_ftplugin = true` (Vimscript: `exists('b:did_ftplugin')` --
  with a colon; `b.did_ftplugin` names no variable and is never true).
- Files without a guard (`goasm.lua`, `hujson.lua`, `jsonschema.lua`,
  `metal.lua`, `proto.lua`, `qf.lua`, `tiltfile.lua`) only set idempotent
  buffer-local values, so a second sourcing is harmless.
- Always `vim.opt_local`/`vim.bo`: a bare `vim.opt.<option>` here changes
  the global value for every later buffer (gomod.lua once removed `t` from
  the global 'formatoptions' this way).
- `java.lua` and `modulemap.lua` are inert (100% commented out); don't
  assume either does anything.
- A filetype needing only option changes belongs here or in
  `after/ftplugin/`; detection logic belongs in root `filetype.lua` or
  `lua/filetypes/`.

### Testing Requirements
No spec covers this directory as a whole (`tests/hujson_ftplugin_spec.lua`
pins `hujson.lua`). Verify with the full config so the rtp order is real:
`nvim --headless -i NONE <file> +'verbose set shiftwidth? commentstring?' +qa!`
-- `verbose` names the script that set each value last.

### Common Patterns
- One file per filetype, named exactly after the `filetype` value.
- Indent (`shiftwidth`/`tabstop`/`softtabstop`/`expandtab`) and
  `comments`/`commentstring` are the usual content.

## Dependencies

### Internal
- Filetype names come from root `filetype.lua` (`devicetree`, `goasm` via
  `lua/filetypes/goasm.lua`, `hujson`, `metal`, `modulemap`, `tigrc`,
  `tiltfile`, `gotmpl`, ...) or from Neovim's own detection.
- `gotmpl.lua` sources `syntax/go.vim`; `hujson.lua` sources the jsonc
  ftplugins.

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
