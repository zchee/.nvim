<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# after/ftplugin

## Purpose
Per-filetype buffer-local settings, one file per filetype (`<filetype>.lua`),
loaded by Neovim's `after-directory` mechanism after any ftplugin a plugin
ships for the same filetype — so these settings win. Content is almost
entirely `vim.opt_local`/`vim.bo` indentation (`expandtab`, `shiftwidth`,
`softtabstop`, `tabstop`) and comment (`comments`, `commentstring`)
overrides; two files (`json.lua`, `jsonc.lua`) also touch `conceallevel`,
and one (`gitcommit.lua`) sets `colorcolumn`. Coverage is inconsistent in
depth: some files are a single settings block, one (`c.lua`) is a stub with
everything commented out, and only three files carry an explanatory header
comment.

## Key Files
| File | Description |
|------|-------------|
| `bzl.lua` | Bazel/Starlark: `expandtab`, 4-space `shiftwidth`/`softtabstop`/`tabstop` |
| `c.lua` | Stub — `comments`/`commentstring` lines present but commented out |
| `cmake.lua` | CMake: `expandtab`, 2-space `shiftwidth`/`softtabstop`/`tabstop` |
| `dockerfile.lua` | Dockerfile: `expandtab`, `shiftwidth=0`, `softtabstop=2`, `tabstop=4` |
| `dts.lua` | Devicetree: `autoindent=true`, `expandtab=false` (tabs) |
| `gitcommit.lua` | Git commit msg: `colorcolumn=72`, `expandtab`, 4-space indent |
| `gitconfig.lua` | Git config: `comments`/`commentstring` for `#`, `noexpandtab`, 4-space indent |
| `go.lua` | Go: `noexpandtab` (tabs), 4-space `shiftwidth`/`softtabstop`/`tabstop` |
| `json.lua` | JSON: `expandtab`, 2-space indent, `conceallevel=0` |
| `json5.lua` | JSON5: `expandtab`, `shiftwidth=0`, `tabstop=4` (no `softtabstop`) |
| `jsonc.lua` | JSONC: `expandtab`, 2-space indent, `conceallevel=0` |
| `terraform.lua` | Terraform: `did_ftplugin` guard; C-style `comments`, `// %s` `commentstring` |
| `typescript.lua` | TypeScript: C-style `comments`, `// %s` `commentstring` (no indent opts) |
| `zsh.lua` | Zsh: shell-comment leader string, `# %s` `commentstring`, 2-space indent, drops `t` from `formatoptions` |

## For AI Agents

### Working In This Directory
- The filename must exactly match the target Neovim `filetype` (e.g.
  `bzl.lua` for `filetype=bzl`). Neovim's `after-directory` convention
  sources it automatically — no additional registration is needed here, but
  the filetype itself must already be produced by root `filetype.lua`,
  `ftdetect/`, or a Neovim built-in (e.g. `gitconfig` comes from the
  `.*/.?git/config` pattern in `filetype.lua`; `dockerfile` from its
  `extension`/`pattern` entries there).
  This is distinct from `lua/filetypes/` (see its `AGENTS.md`), which holds
  *detection* logic (`M.detect(path, bufnr) -> filetype`), not settings.
- `terraform.lua` guards itself with `if vim.b.did_ftplugin then return end`
  before setting `vim.b.did_ftplugin = true` — the idiomatic Vim ftplugin
  re-source guard (`:h ftplugin-guard`). No other file in this directory
  uses the guard; follow `terraform.lua`'s pattern only if the new file has
  a real reason to run more than once per buffer, otherwise match the
  simpler unguarded style used everywhere else.
- `typescript.lua` and `terraform.lua` set an identical
  `comments`/`commentstring` pair (C-style block comment plus `// %s` line
  comment) — reuse that exact string if adding another C-family filetype
  here rather than re-deriving it.

### Testing Requirements
- No automated tests. Verify manually: open a file of the target filetype
  and run `:verbose set expandtab? shiftwidth? softtabstop? tabstop?` (or
  the relevant option) — `:verbose` reports which script last set the
  value, confirming this file actually fired.
- Confirm the filetype itself resolves first with `:set filetype?` before
  debugging why an ftplugin setting didn't apply.

### Common Patterns
- The indentation quad (`expandtab`/`shiftwidth`/`softtabstop`/`tabstop`) is
  the dominant content; not every file sets all four (`json5.lua` omits
  `softtabstop`, `dockerfile.lua` sets `shiftwidth=0` to defer to `tabstop`).
- `comments`/`commentstring` are set together whenever either is overridden,
  never one without the other.
- Only `gitconfig.lua`, `terraform.lua`, and `zsh.lua` carry a
  `-- <file>.lua: Neovim filetype plugin for X.` header comment; the rest
  have none — inconsistent, but not worth normalizing without being asked.

## Dependencies

### Internal
Requires the target filetype to already be registered via root
`filetype.lua`, `ftdetect/`, or Neovim's built-in filetype detection.

### External
Neovim's built-in `after-directory` and `ftplugin` loading mechanism
(`:h after-directory`, `:h ftplugin`). No third-party plugin dependency.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
