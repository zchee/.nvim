local util = require("util")

--- https://github.com/apple/pkl-lsp
--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- A bash wrapper around `java -jar pkl-lsp.jar`. stdio is its only
  -- transport, so unlike the node servers here there is no --stdio to pass;
  -- its whole flag surface is --version and --verbose.
  cmd = { util.homebrew_binary("pkl-lsp", "pkl-lsp") },
  filetypes = { "pkl" },
  -- PklProject marks a Pkl project the way go.mod marks a module, and
  -- PklProject.deps.json lands beside it once dependencies resolve. Rooting
  -- at the project is what lets the server read those dependencies at all.
  root_markers = { "PklProject", ".git" },
  settings = {
    pkl = {
      cli = {
        -- The server shells out to the CLI to resolve projects and packages,
        -- and without a path it reports "Pkl CLI is not configured and not
        -- found in PATH". It would find this one on $PATH; naming it keeps
        -- the server off whatever pkl a project's environment happens to
        -- put there, the same reason every other binary here is absolute.
        path = util.homebrew_binary("pkl", "pkl"),
      },
    },
  },
  -- initializationOptions.extendedClientCapabilities.actionableRuntimeNotifications
  -- is deliberately left unset: it makes the server send pkl/actionableNotification,
  -- a custom method with no handler on this side, so every one would land in
  -- the LSP log as unsupported instead of offering the action it carries.
}
