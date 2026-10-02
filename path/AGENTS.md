<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-10-02 -->

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
| `symlink.bash` | Regenerates `Frameworks/*` symlinks by scanning an Xcode install for `*/Headers` directories and linking `Frameworks/<Name> -> <path>/<Name>.framework/.../Headers`; `--dry-run` lists the links it would create and changes nothing |

## Subdirectories
| Directory | Purpose |
|-----------|---------|
| `Frameworks/` | ~290 symlinks (one per framework, e.g. `AppKit`, `CoreFoundation`, `AVFoundation`, `DriverKit`, `HealthKit`) pointing into `/Applications/Xcode-beta.app/Contents/Developer/.../<Name>.framework/Headers` (DriverKit ones with a trailing `/`, from an older `fd`). Tracked in git as symlinks; regenerated in place by `symlink.bash`, not hand-maintained. No separate AGENTS.md — documented here. |

## For AI Agents

### Working In This Directory
- `symlink.bash [--dry-run] [xcode_path]`: the Xcode path is optional; if
  omitted it probes `/Applications/Xcode-beta.app`, then
  `/Applications/Xcode.app`, then falls back to `xcode-select --print-path`.
- A real run REPLACES the tracked links: every symlink under `Frameworks/`
  is unlinked before the new set is linked. Run `--dry-run` first and never
  run it for real as a check — it rewrites tracked files. It collects the
  whole new set before unlinking anything and aborts (tree untouched) when
  the set is empty, e.g. for a wrong Xcode path.
- It requires `fd` (`fd -0 -j <cpus> -t d -t l 'Headers$' ...`, the CPU
  count from `sysctl -n hw.ncpu` or `getconf _NPROCESSORS_ONLN`) on
  `$PATH`. The search excludes AppleTVOS/AppleTVSimulator/WatchOS/
  WatchSimulator/iPhoneOS/iPhoneSimulator/XROS/XRSimulator platforms,
  `iOSSupport`, `Python[3].framework`, and `Colloqui` to avoid duplicate or
  irrelevant framework names.
- `<Name>` is the path component before the last `.framework`; a `Headers`
  dir outside any framework is skipped, and the first `Headers` dir `fd`
  reports for a name wins (`fd`'s order is not stable, so a name with two
  candidates, e.g. `Kernel`, can flip between runs).
- `Frameworks/` is resolved next to the script, so it can be run from any
  cwd.
- The bottom ~40 lines are a commented-out earlier implementation
  (`_find_framework_header`, per-SDK/per-platform explicit calls) kept as
  reference/history — dead code, not wired up.

### Testing Requirements
No automated specs. To verify after editing the script: `bash -n` and
`shellcheck path/symlink.bash`, then `bash path/symlink.bash --dry-run`
(changes nothing) and compare its `<Name> -> <target>` lines with
`readlink path/Frameworks/<Name>`. A dangling tracked link is found with
`git ls-files -z path/Frameworks | while IFS= read -r -d '' f; do test -e "$f" || echo "$f"; done`.
Only when the user asks for a regeneration, run it for real and review
`git status --short path/Frameworks/`.

### Common Patterns
Collect-then-replace: `fd` locates `*Headers` directories under the Xcode
bundle into a temp list, the component before the last `.framework` becomes
the link name (parameter expansion), and only a non-empty set replaces the
old links, via `ln -fs` (an entry that is not a symlink is left alone).

## Dependencies

### Internal
None.

### External
- `fd`
- A local Xcode.app / Xcode-beta.app install, or `xcode-select` configured
- `sysctl` (macOS) or `getconf` for the `fd -j` CPU count

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
