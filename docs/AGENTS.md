<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# docs

## Purpose
Reference notes for the config. Holds no reference files at present: the one
it had, `defaut-groups.md` (a `:highlight` capture of Neovim's default
groups), was deleted on 2026-09-29; the running build is the reference for
default groups, not a snapshot of an older one.

## Key Files
| File | Description |
|------|-------------|
| `AGENTS.md` | This file |

## For AI Agents

### Working In This Directory
- For Neovim's default highlight groups, ask the running build: `:highlight`
  or `vim.api.nvim_get_hl(0, {})` in `nvim --clean` (no colorscheme, no
  config). `script/hl-dump.lua` is not that: it applies this config's
  colorscheme first.
- A note added here is reference material, not source: add a row for it to
  Key Files, and say how to regenerate it if it is a capture of tool output.

### Testing Requirements
None — static Markdown, nothing to execute.

## Dependencies

### Internal
None.

### External
None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
