local util = require("util")

--- https://pkg.go.dev/cuelang.org/go/cmd/cue
--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- Forwarder mode, the same shape lsp/gopls.lua runs in: every editor
  -- session is a thin client of one shared daemon, so the module graph is
  -- analysed once instead of per nvim. The daemon has to be up first --
  --
  --   cue lsp serve --listen='unix;/tmp/cue.sock'
  --
  -- because a plain --remote only dials. With nothing listening it exits 1
  -- on "connect: no such file or directory", and on "connect: connection
  -- refused" when a dead daemon left the socket file behind -- in both cases
  -- nvim reports no client at all and cue buffers keep only Tree-sitter.
  -- `--remote=auto` would start a daemon itself, but at a socket path it
  -- derives from the environment (/tmp/user/<uid>/cue-<n>-daemon.<user>)
  -- with a 1 minute idle timeout, not at a path anything else can address.
  cmd = { util.homebrew_binary("cue", "cue"), "lsp", "serve", "--remote=unix;/tmp/cue.sock" },
  filetypes = { "cue" },
  -- cue.mod is a directory, which root_markers matches as readily as a file;
  -- it holds module.cue and the resolved dependencies the server needs.
  root_markers = { "cue.mod", ".git" },
}
