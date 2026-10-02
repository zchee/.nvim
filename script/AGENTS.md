<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-10-02 -->

# script

## Purpose
Scripts run by hand, outside Neovim's runtime load path: the Kitty syntax
generator, which rewrites the generated tail of `syntax/kitty.vim`, and the
performance harnesses (timing report, trace export, embed UI latency,
highlight dump) with the helpers they share under `lib/`. The specs under
`tests/perf/` drive most of the harnesses.

## Key Files
| File | Description |
|------|-------------|
| `gen-kitty-syntax.py` | Regenerates the generated tail of `syntax/kitty.vim` from Kitty's own option/action metadata. Adapted from `fladson/vim-kitty`'s `gen-syntax.py` |
| `hl-dump.lua` | `nvim --headless -l script/hl-dump.lua [outfile] [--reapply]`: applies `equinusocio_material` from this checkout (the script's repo root goes first on the rtp) and writes every highlight group in canonical sorted form. `tests/perf/hl_dump_spec.lua` compares it with `tests/perf/fixtures/hl_baseline.txt`, which the same command regenerates |
| `perf-report.sh` | The timing report: clean-vs-full `--startuptime` medians (headless and pty), `lazy.stats()` startup, a UIEnter stall probe, the first-insert probe, the burst/warmup split, embed UI latency and a Perfetto trace. Reported, never pass/fail. Runs from any cwd and picks the BSD or util-linux `script(1)` calling form |
| `perf-trace.lua` | `nvim -l script/perf-trace.lua [--out <f>] [--startuptime <log>] [--ui-latency <json>]`: one full-config startup as Chrome trace-event JSON for ui.perfetto.dev (default `$TMPDIR/nvim-perf-trace.json`). lazy.nvim/warmup slices sit on the log's wall-clock axis through hrtime anchors taken in the child; pinned by `tests/perf/trace_export_spec.lua` |
| `ui-latency.lua` | `nvim -l script/ui-latency.lua [--clean\|--full] ...`: a msgpack-RPC UI client on `nvim --embed` that measures attach-to-first-flush and input-to-flush (median over `--keys`, mean of the middle two for an even count). Flags are documented in its header; smoke-tested by `tests/perf/ui_latency_spec.lua` |
| `lib/throwaway_shada.lua` | Returns one function giving the `-i` value for a full-config child: a temp copy of the real `main.shada`, or `"NONE"`. Loaded with `dofile` (scripts: relative to their own path; specs: from the repo root) |
| `lib/stall_probe.lua` | Returns `stall_probe(stall)`: starts a prepare/check handle pair that raises `stall.max_ms` to the longest single loop turn (check = poll returned, prepare = about to block), and returns the function that closes both handles. `perf-report.sh`'s pty probe dofiles it from the repo root the script passes as `$PERF_REPORT_ROOT`, whatever the session's cwd; `tests/perf/metrics_probe_spec.lua` runs it against a synthetic 30 ms stall |
| `lib/trace_nesting.lua` | Returns `enforce_nesting(events)`: shifts partially overlapping trace `X` slices until every pair on a tid is nested or disjoint. Used by `perf-trace.lua`; `trace_export_spec` checks it on a synthetic case |

## For AI Agents

### Working In This Directory
- `gen-kitty-syntax.py` imports `kitty.actions`, `kitty.config` and
  `kitty.options.definition`, and opens `syntax/kitty.vim` by relative
  path, so run it from the repo root. `kitty +launch
  script/gen-kitty-syntax.py` uses the installed Kitty's own modules and
  always matches the terminal. `python3 script/gen-kitty-syntax.py` works only
  where a `kitty` package is importable: Homebrew's `python3` has one in its
  site-packages (0.49.0, same as kitty.app, on 2026-09-29); when the two
  versions differ, the generated lists follow the Python package, not the
  terminal.
- Verified behavior: it reads `syntax/kitty.vim`, finds the literal line
  `" START GENERATED CODE\n"` (line 47 of the current file, below the
  hand-written header),
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

- **Never let a measurement session write the user's real ShaDa.** Every
  full-config nvim run that behaves like an EDITOR session (`--headless ...
  +qa`, a pty session, an `--embed` child) writes ShaDa on exit; `-l` script
  runs and `-u NONE` spec runs do not. Those writes go through
  `main.shada.tmp.a`..`.z`, so a round's dozens of concurrent sessions race
  for that namespace and every session killed mid-write (this harness's own
  pty timeout does exactly that) strands one — once all 26 letters are taken,
  every later write fails with `E138`, the user's own nvim included. The
  scripts here therefore hand each full-config child a throwaway ShaDa copy
  via `-i` from `lib/throwaway_shada.lua` (`perf-report.sh` makes its own
  copy in its temp dir): a COPY of the real file, not `-i NONE`, so the ShaDa
  read cost (measured and tuned in round 2) stays representative while the
  write lands in a temp path. An ad-hoc full-config run outside these
  scripts passes `-i NONE`. Recovery if it ever happens again: remove
  `${XDG_STATE_HOME:-~/.local/state}/nvim/shada/main.shada.tmp.*` — they are
  stranded temporaries, and `main.shada` itself is untouched.
- Full-config children run with `NVIM_UI_MODE=chrome` unless the caller set
  one (`perf-report.sh` exports it; `perf-trace.lua` and `ui-latency.lua`
  set it for their child): `:UiMode` persists its choice, and a measurement
  must not follow the developer's last toggle.
- Timing is reported here, never asserted in specs — except the two budgets
  kept on purpose in `tests/chrome_spec.lua` and
  `tests/perf/warmup_spec.lua`; `tests/AGENTS.md` states both rules.
- `lib/` holds modules for `dofile`, not scripts to run, and is not on the
  runtime path.

### Testing Requirements
- `gen-kitty-syntax.py`: after running it, diff `syntax/kitty.vim`
  (`git diff syntax/kitty.vim`) to confirm only the generated tail changed,
  then smoke-test with
  `nvim --headless -u NONE -i NONE -c 'set rtp+=.' -c 'edit /tmp/x.conf' -c 'set ft=kitty' -c 'qa'`
  against a scratch `kitty.conf`-named file to confirm no syntax errors.
- `perf-report.sh`: `bash -n` and `shellcheck`, then a full run on a quiet
  machine (it takes under a minute here).
- The Lua harnesses through their specs, with a scratch state dir so no run
  touches the real one:
  `XDG_STATE_HOME=<scratch> nvim --headless -u NONE -i NONE -l tests/perf/<name>_spec.lua`
  (`hl_dump`, `metrics_probe`, `trace_export`, `ui_latency`,
  `startup_budget`). `stylua --check` every changed Lua file.

### Common Patterns
- `gen-kitty-syntax.py`: read-existing-file, locate-marker,
  splice-in-regenerated-tail, write-back-in-place — the whole file is
  regenerated data plus a small hardcoded patch list for known gaps in
  Kitty's own metadata.
- Perf harnesses are two-phase: an `nvim -l` driver (which never loads the
  user config) spawns a full-config child, the child writes JSON to a temp
  path the driver named, and the driver aggregates it. `perf-trace.lua`
  re-runs itself as the child's probe, selected by a `vim.g` sentinel.

## Dependencies

### Internal
- `gen-kitty-syntax.py` writes `syntax/kitty.vim` (see `syntax/AGENTS.md`).
- `hl-dump.lua` applies `colors/equinusocio_material.lua`.
- The perf harnesses read `lua/config/warmup.lua`'s state and lazy.nvim's
  plugin table from the full-config child; `tests/perf/*_spec.lua` drive
  them.

### External
- Kitty's Python environment (`kitty +launch` / `kitty +runpy`, or a
  matching `kitty` package on `python3`'s path) for `gen-kitty-syntax.py`;
  `kitty.actions` and `kitty.config` are Kitty-internal modules, not
  published on PyPI.
- `perf-report.sh`: bash, `script(1)` (BSD or util-linux) and awk.
- Perfetto's `trace_processor_shell` under `util.prefix("perfetto")`
  (optional; `trace_export_spec` checks import health with it when present).

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
