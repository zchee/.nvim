<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# colors

## Purpose
Holds a single colorscheme, `equinusocio_material.lua`, a dark Material-style
theme adapted from `yunlingz/equinusocio-material.vim`. It is a Lua port of
the former `equinusocio_material.vim` with the former
`lua/config/highlight.lua` overrides folded in after the base paint, so a
runtime `:colorscheme equinusocio_material` repaints everything in one pass.
`lua/config/nvim.lua` applies it at startup.

## Key Files
| File | Description |
|------|-------------|
| `equinusocio_material.lua` | Dark Material colorscheme: palette locals, `hl()` base paint (editor, syntax, nvim-lspconfig/Diagnostic groups), then `ovr()` overrides (blink.cmp menu, gitsigns, Go/Rust/Lua/TypeScript/Python/YAML/GraphQL/Diff/C/C++ Tree-sitter and LSP groups, third-party plugin groups) |

## For AI Agents

### Working In This Directory
- The file starts like any colorscheme: `highlight clear`, `syntax reset`
  when syntax is on, `background=dark`, `vim.g.colors_name`.
- Colors come from the palette locals at the top (`foreground`,
  `background`, `comment`, `red`, `blue`, `cursor_guide`, ...); add a named
  local there rather than repeating a hex value.
- Two helpers, two semantics:
  - `hl(name, val)` is the base paint. It mirrors the VimL `s:hl()` shape:
    every group gets an explicit `blend` (0 unless given) and cleared cterm
    attributes.
  - `ovr(name, val)` is an override applied after the base paint. It sets
    `force = true` and leaves blend and cterm as `nvim_set_hl` produces
    them, as the former `config.highlight` repaint did.
  Put a new editor/syntax group in the base section with `hl()`; put a
  plugin- or language-specific group in the overrides section with `ovr()`,
  under its heading (`-- plugins`, `-- Go`, `--- third-party`, ...).
- Plugin highlight groups belong here, not in the plugin's config module:
  a group set from `lua/plugins/<name>.lua` is lost on the next
  `:colorscheme` (gitsigns' groups moved here for that reason). Plugins that
  define their groups with `default = true` never override these.

### Testing Requirements
- `tests/perf/hl_dump_spec.lua` compares every highlight group after
  startup with `tests/perf/fixtures/hl_baseline.txt`. After an intentional
  change regenerate the fixture with
  `nvim --headless -l script/hl-dump.lua tests/perf/fixtures/hl_baseline.txt`
  and check that the diff contains only the groups you meant to change.
- Smoke test:
  `nvim --headless -u NONE -i NONE -c 'set rtp+=.' -c 'colorscheme equinusocio_material' -c 'qa'`
  must exit cleanly with nothing on stderr.

### Common Patterns
- Palette first, then a flat sequence of `hl()` calls, then a flat sequence
  of `ovr()` calls grouped by `--` headings — no per-group conditionals or
  filetype checks.

## Dependencies

### Internal
Applied by `lua/config/nvim.lua`; `lua/lualine/themes/equinusocio_material.lua`
and `lua/config/chrome.lua` use the same palette values for the statusline.

### External
None; plain `vim.api.nvim_set_hl`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
