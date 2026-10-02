local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("dockerfile-language-server", "docker-langserver"), "--stdio" },
  filetypes = { "dockerfile" },
  -- root_dir = require("lspconfig").util.root_pattern("Dockerfile", "*.dockerfile", "Dockerfile*"),
  -- root_dir = function(bufnr, on_dir)
  --   local fname = vim.api.nvim_buf_get_name(bufnr)
  --   local dir
  --   for _, f in ipairs({ "Dockerfile", "*.dockerfile", "Dockerfile*" }) do
  --     dir = vim.fs.root(fname, f)
  --     if dir ~= nil then
  --       on_dir(dir)
  --       return
  --     end
  --   end
  -- end,
  -- root_markers are literal file names, never globs: vim.fs.root would
  -- compare "*.dockerfile" or "Dockerfile*" literally.
  root_markers = { "Dockerfile", ".git" },
  -- The server pulls "docker.languageserver.formatter" and
  -- "docker.languageserver.diagnostics" through workspace/configuration and
  -- never reads initializationOptions (lib/server.js), so settings is the one
  -- place these take effect.
  settings = {
    docker = {
      languageserver = {
        diagnostics = {
          -- string values must be equal to "ignore", "warning", or "error"
          deprecatedMaintainer = "error",
          directiveCasing = "warning",
          emptyContinuationLine = "ignore",
          instructionCasing = "error",
          instructionCmdMultiple = "error",
          instructionEntrypointMultiple = "error",
          instructionHealthcheckMultiple = "error",
          instructionJSONInSingleQuotes = "error",
        },
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    },
  },
}
