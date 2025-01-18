-- https://github.com/DetachHead/basedpyright/blob/main/packages/pyright-internal/src/common/configOptions.ts

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  -- cmd = { vim.fs.joinpath(require("mason-core.path").package_prefix("basedpyright"), "venv", "bin", "basedpyright-langserver"), "--stdio" },
  cmd = { "/usr/local/share/pipx/basedpyright-langserver", "--stdio" },
  settings = {
    basedpyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
      openFilesOnly = false,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly", -- "workspace", -- "openFilesOnly"
        diagnosticSeverityOverrides = {},
        exclude = {},
        -- extraPaths = function()
        --   local paths = {}
        --   if not vim.uv.fs_stat(vim.fs.joinpath(vim.fn.getcwd(), "third_party")) then
        --     paths = { vim.fs.joinpath(vim.fn.getcwd(), "third_party") }
        --   end
        --   return paths
        -- end,
        -- extraPaths = {
        --   -- "/usr/local/google-cloud-sdk/lib",
        --   -- "/usr/local/google-cloud-sdk/lib/third_party",
        --   vim.fn.getcwd() .. "/third_party",
        -- },
        ignore = {},
        include = {},
        logLevel = "Error",
        -- stubPath = "",
        typeCheckingMode = "none", -- "basic", -- "strict"
        -- typeshedPaths = {},
      },
      useLibraryCodeForTypes = true,
      functionSignatureDisplay = "formatted",
    },
  },
}
