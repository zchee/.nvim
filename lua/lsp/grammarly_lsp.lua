local lspconfig = require("lspconfig")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  filetypes = { "markdown" },
  -- ---@type fun(): string
  -- root_dir = function()
  --   return lspconfig.util.find_git_ancestor
  -- end,
  init_options = {
    clientId = "client_BaDkMgx4X19X9UxxYRCXZo",
  },
  handlers = {
    ["$/updateDocumentState"] = function()
      return ""
    end,
  },
}
