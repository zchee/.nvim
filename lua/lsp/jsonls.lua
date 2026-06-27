local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.bun_prefix("vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "json5", "jsonschema" },
  -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
  settings = {
    json = {
      -- schemas = {
      --   {
      --     url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
      --     fileMatch = ".*/%.?codex/hooks.json",
      --   },
      --   {
      --     url = "file:///Users/zchee/src/github.com/zchee/schema/claude-code.schema.json",
      --     -- url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/claude-code.schema.json",
      --     fileMatch = ".*/%.claude.json$$",
      --   },
      --   {
      --     url = "/Users/zchee/src/github.com/zchee/schema/claude-code.settings.schema.json",
      --     fileMatch = ".*/%.?claude/settings.json$$",
      --   },
      --   {
      --     url = "https://raw.githubusercontent.com/google-gemini/gemini-cli/main/schemas/settings.schema.json",
      --     fileMatch = ".*/%.?gemini/settings.json",
      --   },
      -- },
      schemas = require("schemastore").json.schemas({
        -- `ignore` and `select`: https://github.com/b0o/SchemaStore.nvim/blob/main/lua/schemastore/catalog.lua
        -- ignore = {
        --   "Codex Hooks",
        -- },
        -- select = {
        --   ".eslintrc",
        --   "package.json",
        -- },
        -- replace = {
        --   ["Codex Hooks"] = {
        --     name = "Codex Hooks",
        --     description = "OpenAI Codex hooks configuration file",
        --     url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
        --     fileMatch = ".codex/hooks.json",
        --   },
        -- },
        -- extra = {
        --   {
        --     name = "codex.hooks.schema.json",
        --     description = "Codex hooks JSON Schema",
        --     url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
        --     -- fileMatch = { ".*/%.codex/hooks.json" },
        --     fileMatch = ".?codex/hooks.json$",
        --   },
        -- },
      }),

      validate = {
        enable = true,
      },
      format = {
        enable = true,
        keepLines = true,
      },
      colorDecorators = {
        enable = true,
      },
      maxItemsComputed = 50000,
      schemaDownload = {
        enable = true,
        trustedDomains = {
          ["https://schemastore.azurewebsites.net/"] = true,
          ["https://raw.githubusercontent.com/microsoft/vscode/"] = true,
          ["https://raw.githubusercontent.com/devcontainers/spec/"] = true,
          ["https://www.schemastore.org/"] = true,
          ["https://json.schemastore.org/"] = true,
          ["https://json-schema.org/"] = true,
          ["https://developer.microsoft.com/json-schemas/"] = true,
          -- additional
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/"] = true,
          ["https://raw.githubusercontent.com/zchee/schema/"] = true,
        },
      },
    },
  },
}
