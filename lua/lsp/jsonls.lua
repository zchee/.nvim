local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("node", "node"), util.bun_prefix("vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "json5", "jsonschema" },
  -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
  settings = {
    json = {
      schemas = vim.tbl_deep_extend("keep", {
        -- {
        --   url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/codex.hooks.schema.json",
        --   fileMatch = ".*/%.?codex/hooks.json",
        -- },
        {
          url = "file:///Users/zchee/src/github.com/zchee/schema/claude-code.schema.json",
          -- url = "https://raw.githubusercontent.com/zchee/schema/refs/heads/main/claude-code.schema.json",
          fileMatch = ".*/%.claude.json$$",
        },
        {
          url = "/Users/zchee/src/github.com/zchee/schema/claude-code.settings.schema.json",
          fileMatch = ".*/%.?claude/settings.json$$",
        },
        {
          url = "https://raw.githubusercontent.com/google-gemini/gemini-cli/main/schemas/settings.schema.json",
          fileMatch = ".*/%.?gemini/settings.json",
        },
      }, require("schemastore").json.schemas()),
      validate = {
        enable = false,
      },
      format = {
        enable = true,
        keepLines = true,
      },
      colorDecorators = {
        enable = true,
      },
      maxItemsComputed = 100000,
      schemaDownload = {
        enable = true,
      },
    },
  },
}
