local util = require "util"

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.src_path("github.com/hrsh7th/vscode-langservers-extracted/bin/vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "json5", "jsonschema" },
  -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      -- schemas = {
      --   -- {
      --   --   url = "/Users/zchee/src/github.com/zchee/schema/claude-code.schema.json",
      --   --   fileMatch = ".*/%.claude.json",
      --   -- },
      --   -- {
      --   --   url = "/Users/zchee/src/github.com/zchee/schema/claude-code.settings.schema.json",
      --   --   fileMatch = ".*/%.claude/settings.json",
      --   -- },
      --   {
      --     url = "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/tsconfig.json",
      --     fileMatch = ".*/%.tsconfig.json",
      --   },
      -- },
      validate = {
        enable = true,
      },
      format = {
        enable = true,
        keepLines = true,
      },
      resultLimit = 100000,
      schemaDownload = {
        enable = true,
      },
    },
  },
}
