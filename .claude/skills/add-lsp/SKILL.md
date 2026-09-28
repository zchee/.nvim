---
name: add-lsp
description: Add a new LSP server configuration following this repo's patterns. Use when adding support for a new language server.
---

## Adding a new LSP server

Servers use Neovim's native `vim.lsp.config()` / `vim.lsp.enable()`;
nvim-lspconfig is not installed. A server is one file, `lsp/<server_name>.lua`
at the repo root, plus its name in the `vim.lsp.enable()` list. Background and
the reasons behind each rule: `lua/lsp/AGENTS.md`.

### 1. Find out how the server takes its options

Read the server's source or docs before writing any options:

- Does it request `workspace/configuration`? Note the exact `section` it asks
  for (`gopls`, `helm-ls`, `docker.languageserver.formatter`, ...). Options go
  in `settings`, nested under that section.
- Does it read only `initializationOptions`? Options go in `init_options`.
- A server that reads neither gets no options table.

A table in the wrong place is silently ignored and the server runs on its
defaults.

### 2. Create `lsp/<server_name>.lua`

```lua
local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("<formula>", "<binary>"), "<args>" },
  filetypes = { "<filetype>" },
  root_markers = { "<project-marker>", ".git" },
  settings = {
    ["<section>"] = {
      -- server options
    },
  },
}
```

- `cmd[1]` must be an absolute path, never a bare command name:
  - `util.homebrew_binary(formula, binary)` for Homebrew formulae.
  - `util.go_path("bin", "<binary>")` for `go install`ed servers.
  - `util.prefix("bin", "<binary>")` for the `/opt/local` (arm64) toolchain.
  - A node server (a `#!/usr/bin/env node` bin) takes the interpreter as its
    own argument, so a project's `.node-version` cannot choose node:
    `cmd = { util.nodenv_prefix("node"), util.bun_prefix("<bin>"), "--stdio" }`.
  - A binary `$PATH` should choose: resolve it with `vim.fn.exepath()` inside a
    function `cmd` (see `lsp/helm_ls.lua`), passing
    `{ cwd = config.cmd_cwd or config.root_dir, env = config.cmd_env, detached = config.detached }`
    to `vim.lsp.rpc.start` as a table `cmd` would get.
- `filetypes` must be names Neovim or `filetype.lua` actually produces;
  `:checkhealth vim.lsp` warns about any other.
- `root_markers` are tried in list order, not nearest-first, and are literal
  names (no globs). `{ { "a", "b" }, ".git" }` makes `a` and `b` one
  equal-priority group ahead of `.git`.
- The file is loaded in every session, as soon as `lua/lsp/init.lua` runs
  `vim.lsp.enable()`, whether or not the server ever starts. Keep module scope
  free of side effects: no autocmds, no keymaps, no disk or `$PATH` lookups.
  Put start-time work in `before_init = function(params, config) ... end`,
  which sees the resolved `config.root_dir`.
- Do not add `on_attach` (it would replace the shared one), nor the
  nvim-lspconfig keys `autostart`, `single_file_support`, `offsetEncoding`,
  `on_new_config`, which native `vim.lsp` never reads.

### 3. Enable it in `lua/lsp/init.lua`

Add the name, in alphabetical order, to the `vim.lsp.enable({ ... })` list.
That list and the `lsp/` file are the whole registration.

### 4. Attach-time work (only if needed)

Buffer-local commands, keymaps, or `vim.lsp.inlay_hint.enable` /
`vim.lsp.codelens.enable` calls go in `lua/lsp/on_attach.lua` as an entry:

```lua
attach["<server_name>"] = function(client, bufnr)
  vim.lsp.codelens.enable(true, { bufnr = bufnr })
end
```

Global LSP keymaps stay at the bottom of `lua/lsp/init.lua`.

### 5. Filetype detection (only if needed)

If Neovim does not detect the filetype, add a rule to `filetype.lua` via
`vim.filetype.add()`. Buffer settings for it go in `after/ftplugin/<filetype>.lua`.

### 6. Verify

Format and syntax-check the new file:

```sh
stylua lsp/<server_name>.lua lua/lsp/init.lua
echo 'assert(loadfile("lsp/<server_name>.lua"))' | nvim --clean --headless -i NONE -l -
```

Open a sample file with the full config and check that the server attaches
(`-i NONE` keeps the real ShaDa untouched):

```sh
nvim --headless -i NONE -c 'edit <sample-file>' \
  -c 'lua local ok = vim.wait(20000, function() local c = vim.lsp.get_clients({ bufnr = 0, name = "<server_name>" })[1]; return c ~= nil and c.initialized end, 50); io.stdout:write((ok and "ATTACHED" or "NOT ATTACHED") .. "\n")' \
  -c 'qa!'
```

Then open a buffer interactively and run `:checkhealth vim.lsp`: the new
config must show no "Unknown filetype" or "not executable" warning.
