local util = require("util")

local lspconfig = require("lspconfig")

-- https://docs.deno.com/runtime/reference/lsp_integration/#settings
-- deno.enable
-- deno.enablePaths
-- deno.cache
-- deno.certificateStores
-- deno.config
-- deno.importMap
-- deno.internalDebug
-- deno.codeLens.implementations
-- deno.codeLens.references
-- deno.codeLens.referencesAllFunctions
-- deno.codeLens.test
-- deno.suggest.completeFunctionCalls
-- deno.suggest.names
-- deno.suggest.paths
-- deno.suggest.autoImports
-- deno.suggest.imports.autoDiscover
-- deno.suggest.imports.hosts
-- deno.lint
-- deno.tlsCertificate
-- deno.unsafelyIgnoreCertificateErrors
-- deno.unstable

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("deno", "deno"), "lsp" },
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "tsconfig.json", "package.json", ".git"),
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  init_options = {
    deno = {
      enable = true,
      cache_on_save = true,
      codeLens = {
        implementations = true,
        references = true,
        referencesAllFunctions = true,
        test = true,
      },
      suggest = {
        completeFunctionCalls = true,
        names = true,
        paths = true,
        autoImports = true,
        imports = {
          autoDiscover = true,
          hosts = {
            ['https://deno.land'] = true,
          },
        },
      },
      lint = true,
      unsafelyIgnoreCertificateErrors = true,
      unstable = true,
    },
  },
  settings = {
    deno = {
      enable = true,
      cache_on_save = true,
      codeLens = {
        implementations = true,
        references = true,
        referencesAllFunctions = true,
        test = true,
      },
      suggest = {
        completeFunctionCalls = true,
        names = true,
        paths = true,
        autoImports = true,
      },
      unsafelyIgnoreCertificateErrors = true,
      unstable = true,
    },
  },
  -- ---@class lsp.ClientCapabilities
  -- capabilities = function()
  --   local capabilities = vim.lsp.protocol.make_client_capabilities()
  --   capabilities.textDocument.semanticTokens.tokenTypes = {}
  --
  --   return capabilities
  -- end,
}
