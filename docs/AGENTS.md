<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# docs

## Purpose
Reference notes for the config. Currently holds one file: a captured `:highlight`
dump listing Neovim's built-in default highlight groups (`SpecialKey`,
`NonText`, the `Nvim*` runtime/expression-parsing groups, `Diagnostic*`,
etc.) and what each one links to or its `gui=`/`guifg=`/`guibg=` value. It is
a lookup reference, not executable code.

## Key Files
| File | Description |
|------|-------------|
| `defaut-groups.md` | Snapshot of `:highlight` output for Neovim's default groups — filename has a typo (`defaut`, missing the `l` in `default`) |

## For AI Agents

### Working In This Directory
- This is reference material, not source: consult it when picking a
  highlight group to link a new syntax/colorscheme group to (e.g. in
  `colors/equinusocio_material.vim` or `syntax/*.vim`), rather than guessing
  group names or re-running `:highlight` interactively.
- If Neovim's default groups change upstream, regenerate this file with
  `:redir > docs/defaut-groups.md | silent highlight | redir END` (or
  equivalent) rather than hand-editing individual lines.
- The filename typo (`defaut-groups.md`) is long-standing; do not silently
  "fix" it without checking for other references to the exact filename
  first (none found under this repo as of this pass).

### Testing Requirements
None — static Markdown reference content, nothing to execute.

### Common Patterns
One flat list, one highlight group per line, in the exact `:highlight`
output format (`GroupName    xxx <attrs>` or `GroupName    xxx links to
Other`).

## Dependencies

### Internal
None.

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
