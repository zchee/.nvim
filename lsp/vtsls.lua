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

-- Every inlay hint kind the schema offers, with the two suppressWhen* filters
-- off so nothing is hidden. Shared by both languages; enumMemberValues is
-- TypeScript-only, and vtsls ignores an unknown key rather than erroring.
local inlay_hints = {
  parameterNames = {
    enabled = "all",
    suppressWhenArgumentMatchesName = false,
  },
  parameterTypes = { enabled = true },
  variableTypes = {
    enabled = true,
    suppressWhenTypeMatchesName = false,
  },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

-- Bound on LspAttach rather than in an `on_attach` here, for the reason
-- lsp/jsonls.lua spells out: configs resolve through
-- vim.tbl_deep_extend("force", config["*"], ...), which replaces rather than
-- merges a function, so an `on_attach` in this file would silently drop the
-- shared one lua/lsp/init.lua installs for every server.
--
-- Both features are pull-based: without these calls Neovim never sends
-- textDocument/inlayHint or textDocument/codeLens, so the settings below would
-- reach the server and never show up on screen.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("vtsls_hints_and_lenses", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil or client.name ~= "vtsls" then
      return
    end
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    vim.lsp.codelens.enable(true, { bufnr = args.buf })
  end,
})

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
