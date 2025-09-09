local lspconfig = require("lspconfig")

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  autostart = true,
  cmd = { vim.fn.exepath("taplo"), "lsp", "stdio" },
  filetypes = { "toml" },
  root_dir = lspconfig.util.root_pattern("*.toml", ".git"),

  -- https://github.com/tamasfe/taplo/blob/master/editors/vscode/package.json
  settings = {
    evenBetterToml = {
      taplo = {
        bundled = true,
      },
      semanticTokens = true,
      schema = {
        enabled = true,
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
        alignComments = true,
        arrayTrailingComma = true,
        arrayAutoExpand = true,
        arrayAutoCollapse = false,
        compactArrays = false,
        compactInlineTables = false,
        inlineTableExpand = true,
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
