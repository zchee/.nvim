<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# after/ftplugin

## Purpose
Per-filetype buffer-local settings, one file per filetype, sourced by the
`after-directory` mechanism AFTER `$VIMRUNTIME/ftplugin/<ft>` and any plugin
ftplugin -- so these settings win, and the runtime's own settings
(`commentstring`, `keywordprg`, conceal, ...) are already in place underneath.
Content is mostly `vim.opt_local`/`vim.bo` indentation and comment settings;
`help.vim` carries buffer-local cursor helpers for concealed text.

## Key Files
| File | Description |
|------|-------------|
| `bzl.lua` | Bazel/Starlark: `expandtab`, 4-space `shiftwidth`/`softtabstop`/`tabstop` |
| `c.lua` | Stub -- `comments`/`commentstring` lines present but commented out |
| `cmake.lua` | CMake: `expandtab`, 2-space `shiftwidth`/`softtabstop`/`tabstop` |
| `dockerfile.lua` | Dockerfile: `expandtab`, `shiftwidth=0`, `softtabstop=2`, `tabstop=4` |
| `dts.lua` | Devicetree: `autoindent=true`, `expandtab=false` (tabs) |
| `gitcommit.lua` | Git commit msg: `colorcolumn=72`, `expandtab`, 4-space indent |
| `gitconfig.lua` | Git config: `comments`/`commentstring` for `#`, `noexpandtab`, 4-space indent |
| `go.lua` | Go: `noexpandtab` (tabs), 4-space `shiftwidth`/`softtabstop`/`tabstop` |
| `helm.lua` | Go-template `commentstring` (`{{/* %s */}}`) for Helm chart templates |
| `help.vim` | Help buffers: keeps the cursor column right when clicking or moving across concealed characters (buffer-local `<LeftMouse>` map, `BufEnter`/`CursorMoved` autocmds). Here rather than in `ftplugin/` so `$VIMRUNTIME/ftplugin/help.vim` runs first (conceallevel 2, `keywordprg=:help!`) |
| `json.lua` | JSON: `expandtab`, 2-space indent, `conceallevel=0` |
| `json5.lua` | JSON5: `expandtab`, `shiftwidth=0`, `tabstop=4` (no `softtabstop`) |
| `jsonc.lua` | JSONC: `expandtab`, 2-space indent, `conceallevel=0` |
| `kitty.lua` | kitty.conf: `commentstring = "# %s"`, appends `b:#` and `b:#\:` to `comments` (`$VIMRUNTIME/ftplugin/kitty.vim` resets both, so they must come after it) |
| `sh.lua` | Shell scripts: `expandtab`, `sw=ts=sts=2`. Here so `$VIMRUNTIME/ftplugin/sh.vim` sets `comments`/`commentstring` first |
| `terraform.lua` | Terraform: C-style `comments`, `// %s` `commentstring` |
| `typescript.lua` | TypeScript: C-style `comments`, `// %s` `commentstring` (no indent opts) |
| `zsh.lua` | Zsh: shell-comment leader string, `# %s` `commentstring`, 2-space indent, drops `t` from `formatoptions` |

## For AI Agents

### Working In This Directory
- The filename must match the target `filetype` exactly (`bzl.lua` for
  `filetype=bzl`); the filetype itself must come from root `filetype.lua`
  or Neovim's own detection.
- Never guard on `b:did_ftplugin` here: the runtime ftplugin sets it before
  after/ runs, so the guard skips the whole file (terraform.lua's `//`
  comments were dead that way). A settings-only file is idempotent and
  needs no guard at all.
- `typescript.lua` and `terraform.lua` set an identical
  `comments`/`commentstring` pair (C-style block comment plus `// %s` line
  comment) -- reuse that exact string for another C-family filetype.
- This is also the place for settings on a filetype whose runtime ftplugin
  exists: a `ftplugin/` file that sets `b:did_ftplugin` would switch the
  runtime one off (see `ftplugin/AGENTS.md`).

### Testing Requirements
- Verify with the full config: open a file of the target filetype and run
  `:verbose set expandtab? shiftwidth? commentstring?` -- `:verbose` reports
  which script last set each value, confirming this file fired.
- Confirm the filetype resolves first with `:set filetype?`
  (`tests/filetype_rules_spec.lua` pins many of them).

### Common Patterns
- The indentation quad (`expandtab`/`shiftwidth`/`softtabstop`/`tabstop`) is
  the dominant content; not every file sets all four (`json5.lua` omits
  `softtabstop`, `dockerfile.lua` sets `shiftwidth=0` to defer to `tabstop`).
- `comments`/`commentstring` are set together whenever either is overridden
  (`kitty.lua` appends to the runtime's `comments` instead of replacing it).

## Dependencies

### Internal
Requires the target filetype to already be registered via root
`filetype.lua` or Neovim's built-in filetype detection.

### External
Neovim's `after-directory` and `ftplugin` loading mechanism
(`:h after-directory`, `:h ftplugin`). No third-party plugin dependency.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
