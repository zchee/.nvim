<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# script

## Purpose
One-off generator scripts that are not part of Neovim's runtime load path —
they are run manually to regenerate a checked-in file elsewhere in the repo.
Currently holds `gen-kitty-syntax.py`, which regenerates the keyword/action
lists baked into `syntax/kitty.vim`.

## Key Files
| File | Description |
|------|-------------|
| `gen-kitty-syntax.py` | Regenerates the generated tail of `syntax/kitty.vim` from the installed Kitty terminal's own option/action metadata. Adapted from `fladson/vim-kitty`'s `gen-syntax.py`. |

## For AI Agents

### Working In This Directory
- `gen-kitty-syntax.py` must be run through Kitty's own Python, not a
  generic interpreter — the script header says `cd` into the repo and run
  `kitty +launch gen-syntax.py` (Kitty's `+launch` embeds its own
  `kitty`-package Python so `from kitty.actions import get_all_actions` and
  `from kitty.config import option_names_for_completion` resolve).
- Verified behavior: it reads `syntax/kitty.vim`, finds the literal line
  `" START GENERATED CODE\n"` (present at line 41 of the current file),
  keeps everything **before and including** that line, and replaces
  everything after it with two freshly generated `syn keyword` blocks —
  `kittyKeyword` (from `option_names_for_completion()` plus
  `definition.option_map`) and `kittyAction` (from `get_all_actions()`,
  chunked 8-per-line, plus a small hardcoded tail list:
  `increase_font_size`, `decrease_font_size`, `restore_font_size`, `pipe`,
  `click`, `noop`, `no_op` for actions missing from Kitty's own action
  registry).
- Never hand-edit the generated tail of `syntax/kitty.vim` (everything after
  the `" START GENERATED CODE` marker) — re-run this script instead so the
  keyword/action lists stay in sync with the installed Kitty version.
- The debugging one-liners in the header comment
  (`kitty +runpy 'from kitty.actions import get_all_actions; ...'`) are a
  faster way to preview the action/option list than running the full
  regeneration when just checking what Kitty currently exposes.

### Testing Requirements
After running the script, diff `syntax/kitty.vim` (`git diff syntax/kitty.vim`)
to confirm only the generated tail changed, then smoke-test with
`nvim --headless -u NONE -c 'set rtp+=.' -c 'edit /tmp/x.conf' -c 'set ft=kitty' -c 'qa'`
against a scratch `kitty.conf`-named file to confirm no syntax errors.

### Common Patterns
Read-existing-file, locate-marker, splice-in-regenerated-tail,
write-back-in-place — the whole file is regenerated data plus a small
hardcoded patch list for known gaps in Kitty's own metadata.

## Dependencies

### Internal
Writes directly to `syntax/kitty.vim` (see `syntax/AGENTS.md`).

### External
Requires the Kitty terminal's Python environment (`kitty +launch` /
`kitty +runpy`) — not a standalone `python3` script; `kitty.actions` and
`kitty.config` are Kitty-internal modules, not published on PyPI.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
