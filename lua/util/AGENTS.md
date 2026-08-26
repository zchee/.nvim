<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-07-31 | Updated: 2026-08-26 -->

# lua/util

## Purpose
Shared helper module (`require("util")`) used throughout the config to resolve
binary/prefix paths for macOS package managers (Homebrew, arm64 `/opt/local`),
XDG directories with symlink resolution, LSP `on_attach`/lazy-load
scaffolding, and a couple of general-purpose Lua utilities (`switch`,
`fast_switch`, `contains`, `dump`).

## Key Files
| File | Description |
|------|--------------|
| `init.lua` | Main `M` module: path/prefix resolvers, `on_attach`, `lazy_load`, `switch` helpers |
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
  `homebrew_prefix()/opt/<formula>/bin/<binary>`; `M.bun_prefix`,
  `M.pnpm_prefix`, `M.rbenv_prefix` follow the equivalent
  `$ENV_VAR/.../binary` pattern for their respective toolchains.
- `M.fast_switch` compiles a generated Lua chunk via `loadstring`; treat it as
  hot-path-only tooling, not a place to add branching business logic.
- New helpers should be added to `init.lua`'s `M` table with a LuaCATS
  `---@param`/`---@return` doc comment, matching the existing style.

### Testing Requirements
No dedicated spec file exists under `tests/` for this directory's modules.
Verify changes by loading the module headlessly, e.g.:
`nvim --headless -u NONE -c 'set rtp+=.' -c 'lua vim.print(require("util").prefix())' -c 'qa'`

### Common Patterns
- Every public function is documented with LuaCATS `---@param`/`---@return`
  annotations immediately above the definition.
- Path joins consistently use `vim.fs.joinpath(...)` over string
  concatenation.
- Environment lookups go through `os.getenv`/`M.getenv` and are always
  wrapped in `tostring(...)` before being returned, since `os.getenv` can
  return `nil`.

## Dependencies

### Internal
None — this is a leaf dependency consumed by `lua/config/*`, `lua/lsp/*`,
`lua/plugins/*`, `filetype.lua`, and `lua/filetypes/*`.

### External
`vim.uv`/`vim.fs` (Neovim built-ins) throughout.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
