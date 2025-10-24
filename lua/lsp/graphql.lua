local lspconfig = require("lspconfig")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { require("mason-core.path").bin_prefix("graphql-lsp"), "server", "--method", "stream" },
  filetypes = { "graphql", "typescriptreact", "javascriptreact" },
  -- root_dir = lspconfig.util.root_pattern(".git", ".graphqlrc*", ".graphql.config.*", "graphql.config.*"),
  root_markers = { ".graphqlrc*", ".graphql.config.*", "graphql.config.*", ".git" },
  settings = {
    graphql = {
      filePath = ".graphqlrc.yaml",
    },
  },
}
