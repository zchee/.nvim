--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsonconfig.json", "package.json", ".git" },
  settings = {
    typescript = {
      updateImportsOnFileMove = "always",
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
      implementationsCodeLens = {
        enabled = true,
        showOnInterfaceMethods = true,
        showOnAllClassMethods = true,
      },
    },
    javascript = {
      updateImportsOnFileMove = "always",
      referencesCodeLens = {
        enabled = true,
        showOnAllFunctions = true,
      },
    },
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
    },
  },
}
