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

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "vtsls", "--stdio" },
  handlers = {
    ["textDocument/publishDiagnostics"] = filter_ignored_diagnostics,
  },
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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
