<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-07-31 -->

# lua/filetypes

## Purpose
Custom filetype-detection functions that are too stateful or logic-heavy for
a plain string/pattern entry in `vim.filetype.add()`. Currently holds a
single detector, `goasm.lua`, which disambiguates Go's Plan 9-style
assembly (`filetype=goasm`) from generic NASM-style `.s` files
(`filetype=asm`). Wired in from the repo root via
`filetype.lua`'s `extension.s = require("filetypes.goasm").detect`.

## Key Files
| File | Description |
|------|--------------|
| `goasm.lua` | `M.detect(path, bufnr)` — classifies `.s` files as `goasm` vs `asm` |

## For AI Agents

### Working In This Directory
- `goasm.lua` exports `M.detect(path, bufnr)`, called directly from
  `vim.filetype.add({ extension = { s = ... } })` in the root
  `filetype.lua` — the function signature must stay `(path, bufnr) -> string`
  to match Neovim's `vim.filetype.add` function-value contract.
- Detection heuristic (in priority order, first match wins): (1) buffer's
  first 64 lines include a `#include "textflag.h"` / `funcdata.h` /
  `go_asm.h` / `go_tls.h` header, (2) filename is `<arch>.s` or
  `*_<arch>.s` for one of the Go arch suffixes in the `arches` table
  (`amd64`, `arm64`, `arm`, `386`, `riscv64`, `loong64`, `mips*`, `ppc64*`,
  `s390x`, `wasm`), (3) a sibling `*.go` file exists in the same directory
  (via `vim.fn.glob`). Falls back to `"asm"`.
- If a new Go architecture is added upstream, extend the `arches` list here
  rather than adding a one-off pattern in root `filetype.lua`.
- Any new filetype detector that needs buffer inspection or multi-condition
  logic (not just a string/pattern mapping) belongs in this directory,
  following the `M.detect(path, bufnr)` module shape.

### Testing Requirements
`tests/goasm_filetype_spec.lua` covers this module directly — run with:
`nvim --headless -u NONE -l tests/goasm_filetype_spec.lua`
It exercises all three detection branches (header include, arch-suffixed
filename, sibling `.go` file) plus the `asm` fallback, using real temp files
and buffers (no mocks).

### Common Patterns
- Detection functions are small, single-purpose, and return a plain
  filetype string (or delegate/return `nil`/`"asm"` for the non-match case).
- Buffer scanning is bounded (`nvim_buf_get_lines(bufnr, 0, 64, false)`) to
  avoid scanning entire large files just to sniff a header comment.

## Dependencies

### Internal
None directly; consumed by root `filetype.lua`.

### External
None beyond built-in `vim.api`/`vim.fn`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
