<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# syntax

## Purpose
Legacy `:syntax`-based highlighting for filetypes not covered by Tree-sitter
in this config, or that intentionally still use regex syntax highlighting.
A mix of upstream files vendored verbatim (Go project, `fatih/vim-go`,
`vim-vgo`, Swift.org, Tim Pope's `tpope/vim-markdown`, Honza Pokorny's
`vim-dockerfile`), hand-written local files, and one generated file
(`kitty.vim`).

## Key Files
| File | Description | Origin |
|------|-------------|--------|
| `dockerfile.vim` | `dockerfile` filetype; includes `@Shell` via `syntax/sh.vim` | Vendored (Honza Pokorny, BSD) |
| `doxyfile.vim` | `doxyfile` filetype (`Doxyfile`, mapped in root `filetype.lua`) | Hand-written |
| `go.vim` | `go` filetype, 595 lines | Vendored (Go Authors, Go project) |
| `go.vim.bak` | 1219-line older/alternate copy of `go.vim` | **Untracked** — matched by the global `*.bak` gitignore rule; not part of the repo, stale local artifact |
| `gomod.vim` | `go.mod` filetype | Copied from `fatih/vim-go` |
| `gosum.vim` | `go.sum` filetype (version-string highlighting) | Copied from `fatih/vim-go` |
| `gotestlog.vim` | `gotestlog` filetype: `go test` output (`RUN`/`PASS`/`FAIL`/`INFO` markers); has commented-out draft rules left in place | Hand-written |
| `graphql.vim` | `graphql` filetype | Vendored (Jon Parise, MIT) |
| `ispc.vim` | `ispc` filetype: `runtime! syntax/c.vim` baseline plus ISPC keywords | Vendored (Andreas Wendleder) |
| `jinja.vim` | `jinja`/`jinja.html` filetype | Vendored (Hsiaoming Yang) |
| `jsonc.vim` | `jsonc` filetype: `runtime! syntax/json.vim` baseline | Vendored (vim-vgo Authors, BSD) |
| `kitty-session.vim` | `kitty-session` filetype (Kitty `.session` files) | Hand-written |
| `kitty.vim` | `kitty` filetype (`kitty.conf`) | **Generated tail** (everything after the `" START GENERATED CODE` marker at line 47) via `script/gen-kitty-syntax.py`; hand-written header/rules above the marker |
| `lsp_markdown.vim` | Markdown variant used for LSP hover/docstring floats; sources `markdown.vim`, then `syn clear markdownError` | Vendored (neovim/neovim) |
| `markdown.vim` | `markdown` filetype, `runtime! syntax/html.vim` baseline | Vendored (Tim Pope) |
| `modulemap.lua` | Clang module-map syntax for filetype `modulemap` (`module.modulemap`, `*.modulemap`, mapped in root `filetype.lua`) | Vendored (Saleem Abdulrasool) |
| `ninja.vim` | `ninja` filetype (Ninja build files) | Vendored (Nicolas Weber); header notes an older v1.4 also lives in upstream Vim |
| `ragel.vim` | `ragel` filetype (`*.rl`, mapped in root `filetype.lua`) | Vendored (Adrian Thurston) |
| `sil.vim` | `sil` filetype (Swift Intermediate Language) | Vendored (Swift.org, Apache-2.0) |
| `swift.vim` | `swift` filetype | Vendored (Swift.org, Apache-2.0, Joe Groff) |
| `swiftgyb.vim` | `swiftgyb` filetype: `runtime! syntax/swift.vim` + `syntax include @Python syntax/python.vim` (Swift `.gyb` templates embed Python) | Vendored (Swift.org, Apache-2.0) |
| `swig.vim` | `swig` filetype: `runtime! syntax/cpp.vim` baseline | Vendored (Roman Stanchak) |
| `tigrc.vim` | `tigrc` filetype | Copied from `teatimeguest/vim-tigrc` |
| `zsh.vim` | `zsh` filetype | Vendored (Christian Brabandt / chrisbra/vim-zsh, official Vim distribution copy) |

## For AI Agents

### Working In This Directory
- **`kitty.vim` is generated — do not hand-edit past the `" START GENERATED
  CODE` marker.** Edit `script/gen-kitty-syntax.py` and re-run it through
  `kitty +launch` (see `script/AGENTS.md`) to change the `kittyKeyword` /
  `kittyAction` lists; only the header/rules above the marker are safe to
  edit directly.
- Markdown fenced ```` ```objective-c ```` blocks reach Neovim's own
  `syntax/objc.vim` through the `"objective-c=objc"` alias in
  `g:markdown_fenced_languages` (`lua/config/nvim.lua`); no file here is
  needed for that (an absolute symlink `objective-c.vim` used to be).
- `modulemap.lua`, `ragel.vim` and `doxyfile.vim` load for filetypes that
  root `filetype.lua` maps (`*.modulemap`, `*.rl`, `Doxyfile`);
  `ftplugin/modulemap.lua` is fully commented out.
- `go.vim.bak` is a stale, gitignored local backup (`*.bak` in the global
  ignore file) — not part of the tracked config. Do not treat it as a
  fallback or reference; if `go.vim` needs the older behavior back, diff
  against `go.vim.bak` deliberately, then delete it once no longer needed.
- Several vendored files (`dockerfile.vim`, `go.vim`, `gomod.vim`,
  `gosum.vim`, `graphql.vim`, `ispc.vim`, `jinja.vim`,
  `jsonc.vim`, `markdown.vim`, `modulemap.lua`, `ninja.vim`, `ragel.vim`,
  `sil.vim`, `swift.vim`, `swiftgyb.vim`, `swig.vim`, `tigrc.vim`, `zsh.vim`)
  carry upstream copyright/license headers — preserve attribution comments
  when editing; prefer patching narrowly rather than reformatting wholesale,
  to keep future upstream diffs reviewable.
- The one `.lua` syntax file here (`modulemap.lua`) is a thin
  `vim.cmd([[...]])` wrapper around Vimscript `syntax` commands, not an
  idiomatic Lua syntax definition -- match that style for a new `.lua`
  syntax file (Neovim has no native Lua API for legacy regex syntax).

### Testing Requirements
No automated specs. Per-file smoke test:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'edit <sample-file>' -c 'set ft=<filetype>' -c 'qa'`
should exit 0 with no `E`-prefixed errors on stderr. For `kitty.vim`
specifically, also re-run `script/gen-kitty-syntax.py` and `git diff
syntax/kitty.vim` to confirm only the generated tail changed.

### Common Patterns
- Legacy Vimscript `if exists("b:current_syntax") | finish | endif` guard at
  the top of nearly every file (the `.lua` files use `if
  vim.b.current_syntax then return end` instead).
- Several files build on a more general baseline via `runtime! syntax/<other>.vim`
  before adding their own rules (`ispc.vim` → `c.vim`; `jsonc.vim`/
  `dockerfile.vim`'s commented include → `json.vim`; `markdown.vim`/
  `jinja.vim` → `html.vim`; `swig.vim` → `cpp.vim`; `swiftgyb.vim` →
  `swift.vim`).

## Dependencies

### Internal
- `kitty.vim` ← `script/gen-kitty-syntax.py` (see `script/AGENTS.md`).
- Filetypes are assigned by root `filetype.lua` and `ftdetect/*` — see
  those directories for how each filetype here gets selected.
- `lsp_markdown.vim` is consumed by Neovim's LSP hover/signature-help
  floating windows, not by user-edited buffers directly.

### External
- Requires the corresponding Neovim-bundled syntax files at runtime
  (`c.vim`, `cpp.vim`, `html.vim`, `json.vim`, `python.vim`, `sh.vim`,
  `yaml.vim`) for the files that `runtime!`/`syntax include` them.
- `kitty.vim`'s generated tail tracks the installed kitty's option and
  action tables (regenerated for kitty 0.49.0).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
