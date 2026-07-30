<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# path

## Purpose
Generates and stores symlinks to Apple SDK/Xcode framework `Headers`
directories, keyed by framework name, so clangd/LSP tooling (and anything
else that wants a flat include path) can resolve `#import <Framework/...>`
without pointing directly into the deep, versioned Xcode SDK tree. The
generator script populates `Frameworks/`; the symlinks themselves are
committed to git (as symlinks, not copied headers).

## Key Files
| File | Description |
|------|-------------|
| `symlink.bash` | Regenerates `Frameworks/*` symlinks by scanning an Xcode install for `*/Headers` directories and linking `Frameworks/<FrameworkName> -> <path>/<Framework>.framework/Headers` (or platform `Headers` dirs directly) |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `Frameworks/` | ~280 symlinks (one per framework, e.g. `AppKit`, `CoreFoundation`, `AVFoundation`, `DriverKit`, `HealthKit`) pointing into `/Applications/Xcode.app/Contents/Developer/.../<Name>.framework/Headers` (or DriverKit `System/Library/Frameworks/<Name>.framework/Headers/`). Tracked in git as symlinks; regenerated in place by `symlink.bash`, not hand-maintained. No separate AGENTS.md — documented here. |

## For AI Agents

### Working In This Directory
- `symlink.bash` takes an optional `$1` Xcode path argument; if omitted it
  probes `/Applications/Xcode-beta.app`, then `/Applications/Xcode.app`,
  then falls back to `xcode-select --print-path`.
- It requires `fd` (`fd -j $(nproc) -t d -t l 'Headers$' ...`) on `$PATH` —
  not plain `find`. The `find_framework_header` search explicitly excludes
  AppleTVOS/AppleTVSimulator/WatchOS/WatchSimulator/iPhoneOS/
  iPhoneSimulator/XROS/XRSimulator platforms, `iOSSupport`, `Python[3]
  .framework`, and `Colloqui` to avoid duplicate or irrelevant framework
  names.
- Every run calls `clean_symlink()` first (unlinks every existing symlink
  under `./Frameworks`) before re-scanning and re-linking — it is meant to
  be re-run whenever Xcode updates, not run incrementally.
- The bottom ~40 lines are a commented-out earlier implementation
  (`_find_framework_header`, per-SDK/per-platform explicit `find_framework_header`
  calls) kept as reference/history — dead code, not wired up. Don't assume
  it runs; the active path is `clean_symlink` + the single
  `find_framework_header "$xcode_path"` call near the top.
- Must be run with `cwd` inside `path/` (it writes to the relative
  `./Frameworks` directory).

### Testing Requirements
No automated specs. To verify after editing the script:
`cd path && bash symlink.bash` (or `bash symlink.bash /Applications/Xcode.app`),
then `git status --short Frameworks/` to confirm only expected
additions/removals of symlinks, and spot-check a few links resolve
(`readlink Frameworks/AppKit`, `test -e Frameworks/AppKit`).

### Common Patterns
Discover-then-symlink: `fd` locates `*Headers` directories under the Xcode
bundle, the trailing path component before `.framework` is extracted via a
`rev | cut | awk | rev` pipeline, and `ln -fs` creates the symlink,
skipping frameworks that already have an entry in `Frameworks/`.

## Dependencies

### Internal
None.

### External
- `fd` (required by `find_framework_header`)
- A local Xcode.app / Xcode-beta.app install, or `xcode-select` configured
- `nproc` (for `fd -j $(nproc)` parallelism)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
