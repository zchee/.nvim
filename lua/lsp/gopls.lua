local util = require("util")

---
---For gvisor, moby/buildkit, chaos%-mesh/chaos%-mesh, zchee/go-cloud-debug-agent, go.opentelemetry.io/auto
---
local is_goos_linux = function(cwd)
  return
      string.find(cwd, "gvisor")
      or string.find(cwd, "chaos%-mesh/chaos%-mesh")
      or string.find(cwd, "go%-cloud%-debug%-agent")
      or string.find(cwd, "GoogleCloudPlatform/grpc%-gcp%-tools")
      or string.find(cwd, "go.opentelemetry.io/auto")
      or string.find(cwd, "buildkit")
end

local function organize_imports()
  local params = {
    command = "source.organizeImports",
    arguments = { vim.uri_from_bufnr(0) },
  }
  vim.lsp.buf.exec_cmd(params)
end

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
  local cmd = { "go", "env", custom_args.envvar_id }
  vim.system(cmd, { text = true }, function(output)
    local res = vim.trim(output.stdout or "")
    if output.code == 0 and res ~= "" then
      if custom_args.custom_subdir and custom_args.custom_subdir ~= "" then
        res = res .. custom_args.custom_subdir
      end
      on_complete(res)
    else
      vim.schedule(function()
        vim.notify(
          ("[gopls] identify " .. custom_args.envvar_id .. " dir cmd failed with code %d: %s\n%s"):format(
            output.code,
            vim.inspect(cmd),
            output.stderr
          )
        )
      end)
      on_complete(nil)
    end
  end)
end

---@return string?
local function get_std_lib_dir()
  if std_lib and std_lib ~= "" then
    return std_lib
  end

  identify_go_dir({ envvar_id = "GOROOT", custom_subdir = "/src" }, function(dir)
    if dir then
      std_lib = dir
    end
  end)
  return std_lib
end

---@return string?
local function get_mod_cache_dir()
  if mod_cache and mod_cache ~= "" then
    return mod_cache
  end

  identify_go_dir({ envvar_id = "GOMODCACHE" }, function(dir)
    if dir then
      mod_cache = dir
    end
  end)
  return mod_cache
end

---@param fname string
---@return string?
local function get_root_dir(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = vim.lsp.get_clients({ name = "gopls" })
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  if std_lib and fname:sub(1, #std_lib) == std_lib then
    local clients = vim.lsp.get_clients({ name = "gopls" })
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return vim.fs.root(fname, "go.mod") or vim.fs.root(fname, "go.work") or vim.fs.root(fname, ".git")
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.go_path("bin", "gopls"), "serve" },
  -- cmd = { util.go_path("bin", "gopls"), "-remote=unix;/tmp/gopls.sock", "serve" },
  filetypes = { "go", "gotmpl", "gomod", "gowork" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    get_mod_cache_dir()
    get_std_lib_dir()
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    local rootdir = get_root_dir(fname)
    on_dir(rootdir)
  end,

  capabilities = {
    experimental = {
      interactiveInputTypes = {
        string = true,
        fileURI = true,
        bool = true,
        number = true,
        enum = true,
        list = true,
      },
    },
  },

  -- capabilities = {
  --   textDocument = {
  --     completion = {
  --       completionItem = {
  --         commitCharactersSupport = true,
  --         deprecatedSupport = true,
  --         documentationFormat = { "markdown", "plaintext" },
  --         preselectSupport = true,
  --         insertReplaceSupport = true,
  --         labelDetailsSupport = true,
  --         snippetSupport = true,
  --         resolveSupport = {
  --           properties = {
  --             "edit",
  --             "documentation",
  --             "details",
  --             "additionalTextEdits",
  --           },
  --         },
  --       },
  --       completionList = {
  --         itemDefaults = {
  --           "editRange",
  --           "insertTextFormat",
  --           "insertTextMode",
  --           "data",
  --         },
  --       },
  --       contextSupport = true,
  --       dynamicRegistration = true,
  --     },
  --   },
  -- },

  flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 500,
    exit_timeout = false,
  },

  commands = {
    ---@type fun(command: lsp.Command, ctx: table)
    GoOrganizeImports = function(_, _)
      organize_imports()
    end,
  },

  handlers = {
    -- for tiny_inline_diagnostic
    ["textDocument/publishDiagnostics"] = function()
    end,
    -- ["textDocument/rangeFormatting"] = function(...)
    --   vim.lsp.handlers["textDocument/rangeFormatting"](...)
    --   if vim.fn.getbufinfo("%")[1].changed == 1 then
    --     vim.cmd("noautocmd write")
    --   end
    -- end,
    -- ["textDocument/formatting"] = function(...)
    --   vim.lsp.handlers["textDocument/formatting"](...)
    --   if vim.fn.getbufinfo("%")[1].changed == 1 then
    --     vim.cmd("noautocmd write")
    --   end
    -- end,
  },

  init_options = {
    -- env = {},
    -- buildFlags = {},
    directoryFilters = {
      "-**/asm", -- mmcloughlin/avo
      -- "-**/example",
      -- "-**/examples",
      "-**/sample",
      "-**/samples",
      "-**/kokoro",             -- Google kokoro
      "-**/node_modules",       -- Node.js
      "-external_jsonlib_test", -- bytedance/sonic
      "-fuzz",                  -- bytedance/sonic
      "-generic_test",          -- bytedance/sonic
    },
    workspaceFiles = {},        -- NOTE(zchee): This setting need only be customized in environments with a custom GOPACKAGESDRIVER
    completionDocumentation = true,
    usePlaceholders = true,
    deepCompletion = true,
    completeUnimported = true,
    completionBudget = "10ms",       -- default: "100ms"
    importsSource = "gopls",         -- "off", "gopls", "goimports"
    matcher = "CaseSensitive",       -- "Fuzzy", "CaseInsensitive", "CaseSensitive"
    symbolMatcher = "CaseSensitive", -- "Fuzzy", "FastFuzzy", "CaseInsensitive", "CaseSensitive"
    symbolStyle = "Dynamic",         -- "Package", "Full", "Dynamic"
    symbolScope = "workspace",       -- "workspace", "all",
    hoverKind = "FullDocumentation", -- "SingleLine", "NoDocumentation", "SynopsisDocumentation", "FullDocumentation", "Structured"
    linkTarget = "pkg.go.dev",       -- default: "pkg.go.dev",
    linksInHover = "gopls",          -- true, false, "gopls"
    importShortcut = "Definition",   -- "Both", "Link", "Definition"
    -- golang.org/x/tools/gopls/internal/settings.DefaultAnalyzers
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
      deprecated = false,
      directive = true,
      embeddirective = true,
      errorsas = true,
      fieldalignment = true,
      fillreturns = true,
      framepointer = true,
      hostport = true,
      httpresponse = true,
      ifaceassert = true,
      infertypeargs = true,
      loopclosure = true,
      lostcancel = true,
      modernize = true,
      nilfunc = true,
      nilness = true,
      nonewvars = true,
      noresultvalues = true,
      printf = true,
      shadow = false,
      shift = true,
      sigchanyzer = true,
      simplifycompositelit = true,
      simplifyrange = true,
      simplifyslice = true,
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
      unusedfunc = true,
      unusedparams = true,
      unusedresult = true,
      unusedvariable = true,
      unusedwrite = true,
      waitgroup = true,
      yield = true,
      -- NOTE(zchee): those analyzer is not safe to enable by default
      appendclipped = true,
      slicesdelete = true,
      -- staticcheck: https://staticcheck.dev/docs/checks
      QF1008 = false, -- Omit embedded fields from selector expression
      --- non-default
      SA9003 = false, -- Empty body in an if or else branch
      ST1000 = false, -- Incorrect or missing package comment
      ST1003 = true,  -- Poorly chosen identifier
      ST1016 = true,  -- Use consistent method receiver names
      ST1020 = true,  -- The documentation of an exported function should start with the function’s name
      ST1021 = true,  -- The documentation of an exported type should start with type’s name
      ST1022 = true,  -- The documentation of an exported variable or constant should start with variable’s name
      ST1023 = true,  -- Redundant type in variable declaration
    },
    -- golang.org/x/tools/gopls/internal/settings.InlayHint
    hints = {
      parameterNames = true,
      assignVariableTypes = true,
      constantValues = true,
      rangeVariableTypes = true,
      compositeLiteralTypes = true,
      compositeLiteralFields = true,
      functionTypeParameters = true,
      ignoredError = true,
    },
    annotations = {
      -- golang.org/x/tools/gopls/internal/settings.Annotation
      ["nil"] = true,
      escape = true,
      inline = true,
      bounds = true,
    },
    vulncheck = "Imports", -- "Prompt", "Imports", "Off"
    -- golang.org/x/tools/gopls/internal/golang/compileropt.CodeLensSource
    codelenses = {
      generate = true,
      regenerate_cgo = true,
      vulncheck = true,
      test = true,
      tidy = true,
      upgrade_dependency = true,
      vendor = true,
    },
    staticcheck = true,
    ["local"] = "", -- NOTE(zchee): set dinamically
    maxFileCacheBytes = 1e9,
    verboseOutput = false,
    verboseWorkDoneProgress = false,
    showBugReports = false,
    gofumpt = true,
    completeFunctionCalls = true,
    semanticTokens = true,
    -- golang.org/x/tools/gopls/internal/protocol/semtok.Type
    semanticTokenTypes = {
      comment = true,
      ["function"] = true,
      keyword = true,
      label = true,
      macro = true,
      method = true,
      namespace = true,
      number = true,
      operator = true,
      parameter = true,
      property = true,
      string = true,
      type = true,
      typeParameter = true,
      variable = true,
    },
    -- golang.org/x/tools/gopls/internal/protocol/semtok.Modifier
    semanticTokenModifiers = {
      defaultLibrary = true,
      definition = true,
      readonly = true,
      static = true,
      -- non-standard modifiers
      array = true,
      bool = true,
      chan = true,
      format = true,
      interface = true,
      map = true,
      number = true,
      pointer = true,
      signature = true,
      slice = true,
      string = true,
      struct = true,
      shadowing = true,
    },
    newGoFileHeader = true,
    expandWorkspaceToModule = true,
    experimentalPostfixCompletions = true,
    templateExtensions = { "tmpl", "tpl", "gotmpl" },
    diagnosticsDelay = "1s",     -- default: "1s", "100ms"
    diagnosticsTrigger = "Edit", -- "Edit", "Save",
    analysisProgressReporting = true,
    standaloneTags = {
      "ignore", -- default
      "tools",
      "integration",
      "wireinject",
    },
    subdirWatchPatterns = "on",         -- "on", "off", "auto"
    reportAnalysisProgressAfter = "5s", -- default: "5s", "1000ms"
    telemetryPrompt = true,
    linkifyShowMessage = false,
    includeReplaceInWorkspace = false,
    zeroConfig = true,
    pullDiagnostics = true,
    -- gopls Invalid settings: setting option "Annotations": unexpected setting; setting option "codelenses": The 'run_govulncheck' codelens is superseded by the 'vulncheck' codelens. Only 'vulncheck' should be set.; setting option "mcpTools": invalid type []interface {} (want JSON object)
    -- mcpTools = {},
    renameMovesSubpackages = true,
    fileWatcher = "fsnotify", -- "off", "fsnotify", "poll"
    testTemplatePath = vim.fs.joinpath(util.xdg_config_home(), "/go/gopls/template/base.go"),
  },

  on_new_config = function(new_config, new_root_dir)
    if is_goos_linux(new_root_dir) then
      new_config.settings.env = {
        GOOS = { "linux" },
      }
    end

    if string.find(new_root_dir, "go/src") then
      new_config.settings.env = {
        GOEXPERIMENTAL = { "loopvar,newinliner,jsonv2,greenteagc,randomizedheapbase64,sizespecializedmalloc,goroutineleakprofile,runtimefreegc,simd,runtimesecret" },
      }
      new_config.settings.buildFlags = {
        "goexperiment.loopvar", "goexperiment.newinliner", "goexperiment.jsonv2",
        "goexperiment.greenteagc", "goexperiment.randomizedheapbase64", "goexperiment.sizespecializedmalloc",
        "goexperiment.goroutineleakprofile", "goexperiment.runtimefreegc", "goexperiment.simd",
        "goexperiment.runtimesecret",
      }
    end
  end,
}
