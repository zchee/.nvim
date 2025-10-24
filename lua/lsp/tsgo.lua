local util = require("util")

local lspconfig = require("lspconfig")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- cmd = { require("mason-core.path").bin_prefix("typescript-language-server"), "--stdio" },
  cmd = { util.go_path("bin", "tsgo"), "--lsp", "-stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  -- root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
  -- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
  init_options = {
    hostInfo = "neovim",
    preferences = {
      quotePreference = "double",
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      lazyConfiguredProjectsFromExternalProject = true,
      organizeImportsCaseFirst = "upper",
      includeInlayParameterNameHints = "all", -- "literals"
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
    typescript = {
      enablePromptUseWorkspaceTsdk = true,
      workspaceSymbols = {
        scope = "currentProjects",
      },
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  settings = {
    typescript = {
      enablePromptUseWorkspaceTsdk = true,
      workspaceSymbols = {
        scope = "currentProjects",
      },
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  on_init = function(client)
    client.config.settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        completions = {
          completeFunctionCalls = true,
        },
      },
    }
    -- client.notify("workspace/didChangeConfiguration")
    -- return true
  end,
}
