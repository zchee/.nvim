local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("taplo", "taplo"), "lsp", "stdio" },
  filetypes = { "toml" },

  -- https://github.com/tamasfe/taplo/blob/master/editors/vscode/package.json
  settings = {
    evenBetterToml = {
      taplo = {
        bundled = false,
        path = util.homebrew_binary("taplo", "taplo"),
      },
      semanticTokens = true,
      schema = {
        enabled = true,
        links = true,
        catalogs = {
          "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json",
          "https://taplo.tamasfe.dev/schema_index.json",
        },
        cache = {
          memoryExpiration = 60, -- default: 60
          diskExpiration = 600,  -- default: 600
        },
      },
      completion = {
        maxKeys = 10 -- default: 5
      },
      syntax = {
        semanticTokens = true,
      },
      formatter = {
        alignEntries = false,
        alignComments = false,
        arrayTrailingComma = true,
        arrayAutoExpand = false,
        arrayAutoCollapse = false,
        compactArrays = true,
        compactInlineTables = false,
        inlineTableExpand = false,
        compactEntries = false,
        columnWidth = 120,
        indentTables = false,
        indentEntries = false,
        indentString = "  ",
        trailingNewline = true,
        reorderKeys = false,
        reorderArrays = false,
        reorderInlineTables = false,
        allowedBlankLines = 2,
      },
    },
  },
}
