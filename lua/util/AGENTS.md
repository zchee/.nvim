<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-09-29 -->

# lua/util

## Purpose
Shared helper module (`require("util")`) used throughout the config to resolve
binary/prefix paths for macOS package managers (Homebrew, arm64 `/opt/local`),
XDG directories with symlink resolution, and a couple of general-purpose Lua
utilities (`switch`, `fast_switch`, `is_exists`, the global `dump`).

## Key Files
| File | Description |
|------|--------------|
| `init.lua` | Main `M` module: path/prefix resolvers, `switch` helpers |
| `types.lua` | LuaCATS-only file declaring the `go_dir_custom_args` class annotation |

## For AI Agents

### Working In This Directory
- `require("util")` returns the `init.lua` module table.
- Path helpers follow a strict pattern: `M.prefix()` branches on
  `vim.uv.os_uname().machine` (`arm64` -> `/opt/local`, `x86_64` ->
  `/usr/local`) and is distinct from `M.homebrew_prefix()`, which reads
  `$HOMEBREW_PREFIX` first and falls back to `/opt/homebrew` (arm64) or
  `/usr/local` (x86_64). Do not conflate the two — `prefix()` is a
  MacPorts-style convention specific to this config, not the real Homebrew
  prefix.
- `M.homebrew_binary(formula, binary)` joins
  `homebrew_prefix()/opt/<formula>/bin/<binary>`; `M.bun_prefix(binary)`
  resolves `$BUN_INSTALL/bin/<binary>` (`~/.bun` when unset).
- `M.nodenv_prefix(binary)` resolves
  `$NODENV_ROOT/versions/<global>/bin/<binary>` by reading
  `$NODENV_ROOT/version` (`~/.nodenv` when unset), deliberately skipping the
  shim. A shim picks its node version from the process cwd, so a
  `#!/usr/bin/env node` language server spawned in a project root dies
  whenever that project pins a version the machine has not installed.
- `bun_prefix` and `nodenv_prefix` always return an absolute path: when the
  derived file is not executable (or the nodenv version file is unreadable)
  they fall back to `vim.fn.exepath(binary)` and warn once per binary; when
  `$PATH` has no such binary either, they return the derived absolute path so
  the spawn error names where it was expected.
- `M.fast_switch` compiles a generated Lua chunk via `loadstring`; treat it as
  hot-path-only tooling, not a place to add branching business logic.
- New helpers should be added to `init.lua`'s `M` table with a LuaCATS
  `---@param`/`---@return` doc comment, matching the existing style.

### Testing Requirements
No dedicated spec file exists under `tests/` for this directory's modules.
Verify changes by loading the module headlessly, e.g.:
`nvim --headless -u NONE -i NONE -c 'set rtp+=.' -c 'lua vim.print(require("util").prefix())' -c 'qa'`

### Common Patterns
- Every public function is documented with LuaCATS `---@param`/`---@return`
  annotations immediately above the definition.
- Path joins consistently use `vim.fs.joinpath(...)` over string
  concatenation.
- Environment lookups go through `os.getenv`/`M.getenv`. `M.getenv` returns
  nil for an unset or empty variable -- never the string `"nil"`, which
  `vim.fs.joinpath` would keep as a relative path segment -- so callers
  fall back with `or`.

## Dependencies

### Internal
None — this is a leaf dependency consumed by `lua/config/*`, `lua/lsp/*`,
`lua/plugins/*`, `filetype.lua`, and `lua/filetypes/*`.

### External
`vim.uv`/`vim.fs` (Neovim built-ins) throughout.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
