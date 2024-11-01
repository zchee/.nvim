--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  filetypes = { "json", "json5", "jsonschema" },
  -- https://github.com/microsoft/vscode/blob/main/extensions/json-language-features/package.json
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
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
  on_new_config = function(new_config, _)
    -- disable json5 validation
    if string.find(vim.api.nvim_buf_get_name(0), "json5") then
      new_config.settings.json.validate.enable = false
    end
  end,
}
