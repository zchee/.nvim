local util = require("util")

local lspconfig = require("lspconfig")
local lspconfig_async = require("lspconfig.async")

-- gvisor, moby/buildkit, chaos%-mesh/chaos%-mesh, zchee/go-cloud-debug-agent, go.opentelemetry.io/auto
local is_goos_linux = function(cwd)
  return
      string.find(cwd, "gvisor")
      or string.find(cwd, "chaos%-mesh/chaos%-mesh")
      or string.find(cwd, "go%-cloud%-debug%-agent")
      or string.find(cwd, "GoogleCloudPlatform/grpc%-gcp%-tools")
      or string.find(cwd, "go.opentelemetry.io/auto")
      or string.find(cwd, "buildkit")
end

-- --- @param workspace_folders string|lsp.WorkspaceFolder[]?
-- --- @return lsp.WorkspaceFolder[]?
-- local function get_workspace_folders(workspace_folders)
--   if type(workspace_folders) == 'table' then
--     return workspace_folders
--   elseif type(workspace_folders) == 'string' then
--     return {
--       {
--         uri = vim.uri_from_fname(workspace_folders),
--         name = workspace_folders,
--       },
--     }
--   end
-- end

local function organize_imports()
  local params = {
    command = "source.organizeImports",
    arguments = { vim.uri_from_bufnr(0) },
  }
  vim.lsp.buf.execute_command(params)
end


local mod_cache = nil

--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { util.go_path("bin", "gopls") }, -- , "-remote=unix;/tmp/gopls.sock"
  filetypes = { "go", "gomod", "gowork", "gotmpl" },

  ---@class lsp.ClientCapabilities
  capabilities = function()
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    capabilities.workspace.workspaceEdit = {
      documentChanges = true,
      resourceOperations = { "create", "rename", "delete" },
    }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.workspace.configuration = true
    capabilities.workspace.didChangeConfiguration.dynamicRegistration = true
    capabilities.textDocument.semanticTokens.dynamicRegistration = true
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
    capabilities.workspace.didChangeWatchedFiles.relativePatternSupport = true
    capabilities.textDocument.documentSymbol.hierarchicalDocumentSymbolSupport = true
    capabilities.textDocument.semanticTokens.tokenTypes = {
      "namespace",
      "type",
      "class",
      "enum",
      "interface",
      "struct",
      "typeParameter",
      "parameter",
      "variable",
      "property",
      "enumMember",
      "event",
      "function",
      "method",
      "macro",
      "keyword",
      "modifier",
      "comment",
      "string",
      "number",
      "regexp",
      "operator",
      "decorator"
    }
    capabilities.textDocument.semanticTokens.tokenModifiers = {
      "declaration",
      "definition",
      "readonly",
      "static",
      "deprecated",
      "abstract",
      "async",
      "modification",
      "documentation",
      "defaultLibrary"
    }
    capabilities.textDocument.publishDiagnostics.relatedInformation = true

    return capabilities
  end,

  root_dir = function(filename, _)
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    if not mod_cache then
      local result = lspconfig_async.run_command { 'go', 'env', 'GOMODCACHE' }
      if result and result[1] then
        mod_cache = vim.trim(result[1])
      else
        mod_cache = vim.fn.system 'go env GOMODCACHE'
      end
    end
    if mod_cache and filename:sub(1, #mod_cache) == mod_cache then
      local clients = lspconfig.util.get_lsp_clients { name = 'gopls' }
      if #clients > 0 then
        return clients[#clients].config.root_dir
      end
    end
    return lspconfig.util.root_pattern('go.work', 'go.mod', '.git')(filename)
  end,

  settings = {
    env = {},
    buildFlags = {},
    directoryFilters = {
      "-**/asm", -- mmcloughlin/avo
      "-**/example",
      "-**/examples",
      "-**/sample",
      "-**/samples",
      "-**/kokoro",             -- Google kokoro
      "-**/node_modules",
      "-external_jsonlib_test", -- bytedance/sonic
      "-fuzz",                  -- bytedance/sonic
      "-generic_test",          -- bytedance/sonic
    },
    completionDocumentation = true,
    importsSource = "gopls",
    usePlaceholders = true,
    deepCompletion = true,
    completeUnimported = true,
    addTestSourceCodeAction = true,
    completionBudget = "0s",       -- "100ms",
    matcher = "fuzzy",             -- "Fuzzy", "CaseInsensitive", "CaseSensitive"
    symbolMatcher = "fastFuzzy",   -- "Fuzzy", "FastFuzzy", "CaseInsensitive", "CaseSensitive"
    symbolStyle = "package",       -- "Package", "Full", "Dynamic"
    symbolScope = "workspace",     -- "workspace", "all",
    hoverKind = "structured",      -- "FullDocumentation",
    linkTarget = "",               -- "pkg.go.dev",
    linksInHover = true,           -- true, false, "gopls"
    importShortcut = "definition", -- "Link", "Both",
    analyses = {
      appends = true,
      asmdecl = true,
      assign = true,
      atomic = true,
      atomicalign = true,
      bools = true,
      buildtag = true,
      cgocall = true,
      composite = true,
      copylock = true,
      deepequalerrors = true,
      defers = true,
      directive = true,
      errorsas = true,
      fieldalignment = false,
      framepointer = true,
      httpresponse = true,
      ifaceassert = true,
      loopclosure = true,
      lostcancel = true,
      nilfunc = true,
      nilness = true,
      printf = true,
      shadow = true,
      shift = true,
      sigchanyzer = true,
      slog = true,
      sortslice = true,
      stdmethods = true,
      stdversion = true,
      stringintconv = true,
      structtag = true,
      testinggoroutine = true,
      tests = true,
      timeformat = true,
      unmarshal = true,
      unreachable = true,
      unsafeptr = true,
      unusedresult = true,
      unusedwrite = true,
      gdeprecated = true,
      gembeddirective = true,
      gfillreturns = true,
      ginfertypeargs = true,
      gnonewvars = true,
      gnorangeoverfunc = true,
      gnoresultvalues = true,
      gsimplifycompositelit = true,
      gsimplifyrange = true,
      gsimplifyslice = true,
      gstubmethods = true,
      gundeclaredname = true,
      gunusedparams = true,
      gunusedvariable = true,
      guseany = true,
    },
    hints = {
      parameterNames = true,
      assignVariableTypes = true,
      constantValues = true,
      rangeVariableTypes = true,
      compositeLiteralTypes = true,
      compositeLiteralFields = true,
      functionTypeParameters = true,
    },
    annotations = {
      ["nil"] = true,
      escape = true,
      inline = true,
      bounds = true,
    },
    vulncheck = "off", -- "imports",
    codelenses = {
      gc_details = true,
      generate = true,
      regenerate_cgo = true,
      run_govulncheck = true,
      test = true,
      tidy = true,
      upgrade_dependency = true,
      vendor = true,
    },
    staticcheck = true,
    ["local"] = "",
    verboseOutput = false,
    verboseWorkDoneProgress = false,
    showBugReports = false,
    gofumpt = true,
    completeFunctionCalls = true,
    semanticTokens = true,
    semanticTokenTypes = true,
    expandWorkspaceToModule = true,
    experimentalPostfixCompletions = true,
    templateExtensions = { "tmpl", "tpl", "gotmpl" },
    diagnosticsDelay = "1s",
    diagnosticsTrigger = "Edit", -- "Save",
    analysisProgressReporting = true,
    standaloneTags = {
      "ignore",
      "tools",
      "integration",
      "wireinject",
      "nikandfor_loc_unsafe",
      "kubeapiserver",
    },
    subdirWatchPatterns = "on", -- "on", "off", "auto"
    reportAnalysisProgressAfter = "1s",
    telemetryPrompt = false,
    linkifyShowMessage = true,
    includeReplaceInWorkspace = true,
    zeroConfig = true,
    pullDiagnostics = true,
  },
  -- handlers = {
  --   ["textDocument/rangeFormatting"] = function(...)
  --     vim.lsp.handlers["textDocument/rangeFormatting"](...)
  --     if vim.fn.getbufinfo("%")[1].changed == 1 then
  --       vim.cmd("noautocmd write")
  --     end
  --   end,
  --   ["textDocument/formatting"] = function(...)
  --     vim.lsp.handlers["textDocument/formatting"](...)
  --     if vim.fn.getbufinfo("%")[1].changed == 1 then
  --       vim.cmd("noautocmd write")
  --     end
  --   end,
  -- },
  on_new_config = function(new_config, new_root_dir)
    if is_goos_linux(new_root_dir) then
      new_config.settings.env = {
        GOOS = { "linux" },
      }
    end

    if is_goos_linux(new_root_dir) then
      table.insert(new_config.settings.buildFlags, { "-tags=linux" })
    end
  end,

  -- commands = {
  --   GoOrganizeImports = {
  --     organize_imports,
  --     description = 'Organize Imports',
  --   },
  -- },
}
