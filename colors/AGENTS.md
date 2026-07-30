<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# colors

## Purpose
Holds a single colorscheme, `equinusocio_material.vim`, a dark Material-style
theme adapted from `yunlingz/equinusocio-material.vim`. It defines a palette
table (`s:p.material.*`) plus attribute constants, then applies every
highlight group through a local `s:hl(group, fg, bg, attrs, blend)` helper
that wraps `execute "highlight! ..."`.

## Key Files
| File | Description |
|------|-------------|
| `equinusocio_material.vim` | Dark Material colorscheme: palette table, `s:hl()` helper, highlight group definitions (editor groups, syntax groups, `nvim-lspconfig`/Diagnostic groups) |

## For AI Agents

### Working In This Directory
- Standard Vim colorscheme skeleton: guards on `g:colors_name`, `highlight
  clear`, `syntax reset`, sets `g:colors_name = "equinusocio_material"` and
  `background=dark` before defining any groups.
- All colors flow through the `s:p.material.*` dict (e.g. `s:p.material.blue`,
  `s:p.material.cursor_guide`) — add new named colors there rather than
  hard-coding hex values in `s:hl()` calls.
- Every highlight group is set via `call s:hl("GroupName", fg, bg, attrs,
  blend)`, one call per group, grouped by area with `" ----` comment
  dividers (editor UI, diagnostics, syntax, `nvim-lspconfig`/Diagnostic).
  Follow this call shape for new groups instead of raw `highlight` commands.
- `s:hl()`'s list-typed `attrs` branch references `a:attr` (undefined —
  should be `a:attrs`); no existing call site passes a list, so this path is
  dead/broken. Combined attributes are currently passed as a comma-joined
  string instead (e.g. `s:p.bold.",".s:p.underline` for `Error`).

### Testing Requirements
`nvim --headless -u NONE -c 'set rtp+=.' -c 'colorscheme equinusocio_material' -c 'qa'`
should exit cleanly with no errors on stderr; that is the only practical
smoke test for a colorscheme file.

### Common Patterns
- Palette-first, then apply: define colors in `s:p`, then a flat sequence of
  `s:hl()` calls — no per-group conditionals or filetype checks.

## Dependencies

### Internal
None — self-contained; activated via `:colorscheme equinusocio_material` from
elsewhere in the config (e.g. `lua/config/`).

### External
None; pure Vimscript, no plugin dependency.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
