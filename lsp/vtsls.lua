local lsp_cmd = require("lsp.cmd")
local util = require("util")

-- Codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
local ignored_diagnostic_codes = {
  -- "File is a CommonJS module; it may be converted to an ES module."
  -- Without a jsconfig/tsconfig the inferred project runs module=Preserve with
  -- moduleResolution=Bundler, so TypeScript never reads package.json "type" and
  -- flags every require()-based .js file, including "type": "commonjs" packages.
  [80001] = true,
}

-- vtsls only pushes diagnostics. A per-client handler is reached through
-- Client:_resolve_handler, so the filter never leaks into other servers.
---@param err lsp.ResponseError?
---@param result lsp.PublishDiagnosticsParams
---@param ctx lsp.HandlerContext
local function filter_ignored_diagnostics(err, result, ctx)
  if type(result) == "table" and result.diagnostics then
    result.diagnostics = vim.tbl_filter(function(diagnostic)
      return not ignored_diagnostic_codes[tonumber(diagnostic.code)]
    end, result.diagnostics)
  end
  return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

-- Every inlay hint kind the schema offers except parameter names, which are
-- switched off; the two suppressWhen* filters stay off so nothing else is
-- hidden. Shared by both languages; enumMemberValues is TypeScript-only, and
-- vtsls ignores an unknown key rather than erroring.
local inlay_hints = {
  parameterNames = {
    -- enabled = "all",
    enabled = false,
    suppressWhenArgumentMatchesName = false,
  },
  parameterTypes = {
    enabled = true,
  },
  variableTypes = {
    enabled = true,
    suppressWhenTypeMatchesName = false,
  },
  propertyDeclarationTypes = {
    enabled = true,
  },
  functionLikeReturnTypes = {
    enabled = true,
  },
  enumMemberValues = {
    enabled = true,
  },
}

-- Inlay hints and code lenses are switched on per buffer in
-- lua/lsp/on_attach.lua; both are pull-based, so the settings below need it.

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  -- node named explicitly and lsp.cmd.lazy, both as in lsp/jsonls.lua.
  cmd = lsp_cmd.lazy(function()
    return { util.nodenv_prefix("node"), util.bun_prefix("vtsls"), "--stdio" }
  end),
  handlers = {
    ["textDocument/publishDiagnostics"] = filter_ignored_diagnostics,
  },
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  settings = {
    -- Literal "js/ts" section: vtsls reads this one under that exact name,
    -- unlike everything else, which is split per language. 500 is the default
    -- and truncates mid-signature on generic-heavy code.
    ["js/ts"] = {
      hover = {
        maximumLength = 2000,
      },
    },
    typescript = {
      inlayHints = inlay_hints,
      -- Jump to the implementation instead of a bundled .d.ts. vtsls applies
      -- this inside its definition provider, so plain `gd` benefits; it needs
      -- the dependency to ship sources or a declaration map to have an effect.
      preferGoToSourceDefinition = true,
      suggest = {
        -- Completing a call inserts its parameters as snippet placeholders.
        -- Needs client snippetSupport, which the blink.cmp capability merge in
        -- lua/lsp/init.lua provides.
        completeFunctionCalls = true,
      },
      preferences = {
        -- "auto" stops offering package.json dependencies once a project has
        -- many of them; "on" keeps them in the auto-import list.
        includePackageJsonAutoImports = "on",
      },
      -- Takes effect only once something notifies workspace/didRenameFiles:
      -- neo-tree does not, so its file_renamed/file_moved handlers in
      -- lua/plugins/neo-tree.lua have to call snacks' on_rename_file.
      updateImportsOnFileMove = {
        enabled = "always",
      },
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
      inlayHints = inlay_hints,
      preferGoToSourceDefinition = true,
      suggest = {
        completeFunctionCalls = true,
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
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
