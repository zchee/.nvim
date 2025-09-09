local util = require "util"
--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  -- cmd = { vim.fn.stdpath("data") .. '/mason/bin/vscode-json-language-server', '--stdio' },
  cmd = { util.src_path("github.com/hrsh7th/vscode-langservers-extracted/bin/vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "json5", "jsonschema" },
  -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
  settings = {
    json = {
      -- schemas = require("schemastore").json.schemas(),
      schemas = {
        -- {
        --   url = "/Users/zchee/src/github.com/zchee/schema/claude-code.schema.json",
        --   fileMatch = ".*/%.claude.json",
        -- },
        -- {
        --   url = "/Users/zchee/src/github.com/zchee/schema/claude-code.settings.schema.json",
        --   fileMatch = ".*/%.claude/settings.json",
        -- },
        {
          url = "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/tsconfig.json",
          fileMatch = ".*/%.tsconfig.json",
        },
      },
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
  -- on_new_config = function(new_config, _)
  --   -- disable json5 validation
  --   if string.find(vim.api.nvim_buf_get_name(0), "json5") then
  --     new_config.settings.json.validate.enable = true
  --   end
  -- end,
}
