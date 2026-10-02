local util = require("util")

---
---For gvisor, moby/buildkit, chaos%-mesh/chaos%-mesh, zchee/go-cloud-debug-agent, go.opentelemetry.io/auto
---
local is_goos_linux = function(cwd)
  return string.find(cwd, "gvisor")
    or string.find(cwd, "chaos%-mesh/chaos%-mesh")
    or string.find(cwd, "go%-cloud%-debug%-agent")
    or string.find(cwd, "GoogleCloudPlatform/grpc%-gcp%-tools")
    or string.find(cwd, "go.opentelemetry.io/auto")
    or string.find(cwd, "buildkit")
end

---Whether `root` is a Go source tree's own module: GOROOT/src declares
---`module std` and GOROOT/src/cmd `module cmd`, whichever checkout or SDK
---they live in (/opt/local/go/src, ~/sdk/go1.27.1/src). Read from go.mod, not
---guessed from the path: a "go/src" substring also matches every module
---under GOPATH/src (~/go/src/github.com/...), which are ordinary modules.
---@param root string
---@return boolean
local function is_go_source_tree(root)
  local fd = io.open(vim.fs.joinpath(root, "go.mod"), "r")
  if not fd then
    return false
  end
  local module
  for line in fd:lines() do
    module = line:match("^module%s+(%S+)")
    if module then
      break
    end
  end
  fd:close()
  return module == "std" or module == "cmd"
end

local mod_cache = nil
local std_lib = nil

---@param custom_args go_dir_custom_args
---@param on_complete fun(dir: string | nil)
local function identify_go_dir(custom_args, on_complete)
  local cmd = { util.prefix("go", "bin", "go"), "env", custom_args.envvar_id }
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
  -- cmd = { util.go_path("bin", "gopls"), "serve" },
  cmd = { util.go_path("bin", "gopls"), "-remote=unix;/tmp/gopls.sock", "serve" },
  filetypes = { "go", "gotmpl", "gomod", "gowork", "goasm" },
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

  -- handlers = {
  --   -- for tiny_inline_diagnostic
  --   -- ["textDocument/publishDiagnostics"] = function() end,
  --   -- ["textDocument/rangeFormatting"] = function(...)
  --   --   vim.lsp.handlers["textDocument/rangeFormatting"](...)
  --   --   if vim.fn.getbufinfo("%")[1].changed == 1 then
  --   --     vim.cmd("noautocmd write")
  --   --   end
  --   -- end,
  --   -- ["textDocument/formatting"] = function(...)
  --   --   vim.lsp.handlers["textDocument/formatting"](...)
  --   --   if vim.fn.getbufinfo("%")[1].changed == 1 then
  --   --     vim.cmd("noautocmd write")
  --   --   end
  --   -- end,
  -- },

  -- Process-wide options. gopls applies them from the initialize request's
  -- initializationOptions; read from settings they take effect only when a
  -- folder's options later change. On the shared /tmp/gopls.sock daemon each
  -- session's initialize sets them again, always to these values.
  init_options = {
    maxFileCacheBytes = 1e9,
    -- runtime/debug.SetMemoryLimit of gopls itself; settings.gopls.env
    -- reaches only the go commands gopls runs.
    memoryLimit = 2 * 1024 * 1024 * 1024,
  },

  settings = {
    gopls = {
      -- buildFlags = {},
      directoryFilters = {
        "-**/asm", -- mmcloughlin/avo
        -- "-**/example",
        -- "-**/examples",
        -- "-**/sample",
        -- "-**/samples",
        "-**/kokoro", -- Google kokoro
        "-**/node_modules", -- Node.js
        "-external_jsonlib_test", -- bytedance/sonic
        "-fuzz", -- bytedance/sonic
        "-generic_test", -- bytedance/sonic
      },
      workspaceFiles = {}, -- NOTE(zchee): This setting need only be customized in environments with a custom GOPACKAGESDRIVER
      completionDocumentation = true,
      usePlaceholders = true,
      deepCompletion = true,
      completeUnimported = true,
      completionBudget = "100ms", -- default: "100ms", "10ms"
      matcher = "CaseSensitive", -- "Fuzzy", "CaseInsensitive", "CaseSensitive"
      symbolMatcher = "CaseSensitive", -- "Fuzzy", "FastFuzzy", "CaseInsensitive", "CaseSensitive"
      symbolStyle = "Dynamic", -- "Package", "Full", "Dynamic"
      symbolScope = "workspace", -- "workspace", "all",
      hoverKind = "FullDocumentation", -- "SingleLine", "NoDocumentation", "SynopsisDocumentation", "FullDocumentation", "Structured"
      linkTarget = "pkg.go.dev", -- default: "pkg.go.dev",
      linksInHover = "gopls", -- true, false, "gopls"
      importShortcut = "Definition", -- "Both", "Link", "Definition"
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
        composites = true,
        copylocks = true,
        deepequalerrors = true,
        defers = true,
        deprecated = false,
        directive = true,
        embed = true,
        errorsas = true,
        errorsastypeshadow = true,
        fieldalignment = false,
        fillreturns = true,
        framepointer = true,
        hostport = true,
        httpresponse = true,
        ifaceassert = true,
        infertypeargs = true,
        inline = true,
        loopclosure = true,
        lostcancel = true,
        maprange = true,
        -- modernize is not one analyzer: gopls runs each check as its own
        -- (the modernize#hdr-Analyzer_<name> anchors in `gopls api-json`). All
        -- default on except appendclipped and slicesdelete, enabled below.
        any = true,
        atomictypes = true,
        bloop = true,
        embedlit = true,
        errorsastype = true,
        fmtappendf = true,
        forvar = true,
        importcomment = true,
        mapsloop = true,
        minmax = true,
        newexpr = true,
        omitzero = true,
        plusbuild = true,
        rangeint = true,
        reflecttypeassert = true,
        reflecttypefor = true,
        slicesbackward = true,
        slicesclip = true,
        slicescontains = true,
        slicessort = true,
        stditerators = true,
        stringsbuilder = true,
        stringscut = true,
        stringscutprefix = true,
        stringsseq = true,
        testingcontext = true,
        unsafefuncs = true,
        waitgroupgo = true,
        nilfunc = true,
        nilness = true,
        nonewvars = true,
        noresultvalues = true,
        printf = true,
        ptrtoerror = true,
        recursiveiter = true,
        scannererr = true,
        shadow = false,
        shift = true,
        sigchanyzer = true,
        simplifycompositelit = true,
        simplifyrange = true,
        simplifyslice = true,
        slog = true,
        sortslice = true,
        sqlrowserr = true,
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
        writestring = true,
        yield = true,
        -- NOTE(zchee): those analyzer is not safe to enable by default
        appendclipped = true,
        slicesdelete = true,
        -- staticcheck: https://staticcheck.dev/docs/checks
        -- `staticcheck = true` turns on every staticcheck analyzer not named
        -- here, so with it only the `false` entries change anything.
        QF1008 = false, -- Omit embedded fields from selector expression
        SA9003 = false, -- Empty body in an if or else branch
        ST1000 = false, -- Incorrect or missing package comment
        ST1003 = true, -- Poorly chosen identifier
        ST1016 = true, -- Use consistent method receiver names
        ST1020 = true, -- The documentation of an exported function should start with the function’s name
        ST1021 = true, -- The documentation of an exported type should start with type’s name
        ST1022 = true, -- The documentation of an exported variable or constant should start with variable’s name
        ST1023 = true, -- Redundant type in variable declaration
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
      ["local"] = "",
      verboseOutput = false,
      verboseWorkDoneProgress = false,
      showBugReports = false,
      gofumpt = true,
      completeFunctionCalls = true,
      semanticTokens = true,
      -- golang.org/x/tools/gopls/internal/protocol/semtok.Type
      -- gopls emits a type or modifier only when the client capabilities list
      -- it, so these maps can only switch one off. Neovim's capabilities lack
      -- label and the non-standard modifiers, so those entries do nothing.
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
      diagnosticsDelay = "1s", -- default: "1s", "100ms"
      diagnosticsTrigger = "Edit", -- "Edit", "Save",
      analysisProgressReporting = true,
      standaloneTags = {
        "ignore", -- default
        "bench",
        "tools",
        "integration",
        "wireinject",
      },
      subdirWatchPatterns = "auto", -- "on", "off", "auto"
      reportAnalysisProgressAfter = "5s", -- default: "5s", "1000ms"
      telemetryPrompt = true,
      linkifyShowMessage = false,
      includeReplaceInWorkspace = false,
      zeroConfig = true,
      pullDiagnostics = true,
      mcpTools = vim.empty_dict(),
      renameMovesSubpackages = true,
      fileWatcher = "fsnotify", -- "off", "fsnotify", "poll"
      moveType = true,
      moveDeclaration = true,
      -- Only the gopls-test-tmpl branch of ~/go/src/golang.org/x/tools reads
      -- this; upstream gopls answers it with "Invalid settings: unexpected setting".
      testTemplatePath = vim.fs.joinpath(util.xdg_config_home(), "/go/gopls/template/base.go"),
    },
  },

  -- The per-root overrides: before_init fires just before the initialize
  -- request, when config.root_dir is already resolved.
  --
  -- gopls types `env` as map[string]string, so each value is a plain string.
  -- An empty Lua table encodes as a JSON array, which gopls rejects for `env`,
  -- so the table exists only once a value goes into it.
  ---@param config vim.lsp.ClientConfig
  before_init = function(_, config)
    local root = config.root_dir
    if not root then
      return
    end

    -- settings is lsp.LSPObject, so field access below would trip
    -- undefined-field on the LSPAny union without a concrete local type
    ---@type table<string, any>
    local gopls = config.settings.gopls

    if is_goos_linux(root) then
      gopls.env = gopls.env or {}
      gopls.env.GOOS = "linux"
    end

    -- The experiments gate standard-library packages (simd/archsimd,
    -- runtime/secret), so only the Go source tree itself needs them.
    if is_go_source_tree(root) then
      gopls.env = gopls.env or {}
      gopls.env.GOEXPERIMENT = "simd,runtimesecret"
      -- buildFlags reaches `go list` verbatim, so the tags have to arrive as
      -- one -tags= flag. Listing them bare made go list read each name as a
      -- package pattern, and the load failed silently: every completion in
      -- go/src came back empty.
      gopls.buildFlags = {
        "-tags=goexperiment.simd,goexperiment.runtimesecret",
      }
    end
  end,
}
