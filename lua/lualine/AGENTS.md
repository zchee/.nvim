<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/lualine

## Purpose
Holds a single custom `lualine.nvim` theme (`equinusocio_material`), loaded
via lualine's own theme-discovery mechanism (theme name `"equinusocio_material"`
is set in `lua/plugins/lualine.lua`'s `options.theme`, which resolves to
this module through lualine's `themes/<name>.lua` runtime path convention —
not required directly by name anywhere else in the repo). All actual
statusline section/component configuration lives in
`lua/plugins/lualine.lua`, not here.

lualine only draws in the `plugins` ui mode: `lua/config/chrome.lua` is the
default statusline and carries its own copy of this palette. See
`lua/config/ui_mode.lua` for the switch.

## Key Files
No files directly in `lua/lualine/` — see Subdirectories.

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `themes/` | Custom lualine color theme(s) — documented here, no separate AGENTS.md |

### `themes/`
| File | Description |
|------|--------------|
| `equinusocio_material.lua` | `equinusocio_material` color table (normal/insert/inactive/replace/visual modes, sections a/b/c) matching the `equinusocio_material` colorscheme palette |

## For AI Agents

### Working In This Directory
- A lualine theme module returns a table keyed by vim mode
  (`normal`, `insert`, `inactive`, `replace`, `visual`), each with `a`/`b`/`c`
  sub-tables of `{ fg, bg, gui }` — follow this exact shape for any new
  theme; lualine loads it by `require("lualine.themes.<name>")` internally
  when `options.theme = "<name>"` is set.
- The `colors` table at the top of `equinusocio_material.lua` uses
  `colorN` keys (`color0`..`color11`, though only 0,1,2,3,4,5,8,11 are
  populated) that loosely mirror ANSI terminal color slots from the
  `equinusocio_material` colorscheme; keep new themes self-contained in the
  same file (no shared palette module exists here).
- If adding a second theme, name the new file after the theme string that
  will be passed to `lualine.setup({ options = { theme = "<name>" } })`.

### Testing Requirements
No spec exists. Verify by starting Neovim and confirming the statusline
renders without error:
`nvim --headless -c 'lua require("lualine")' -c 'qa'`
(requires `lualine.nvim` to already be installed via lazy.nvim).

### Common Patterns
- Flat `local colors = { ... }` table referenced by short keys, kept at the
  top of the file above the theme table that consumes it.

## Dependencies

### Internal
None.

### External
`nvim-lualine/lualine.nvim` — the theme is only meaningful when loaded
through `lualine.setup()` in `lua/plugins/lualine.lua`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
