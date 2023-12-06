vim.lsp.set_log_level("INFO")

local uv = require("luv")

local home = uv.os_homedir()
local homebrew_prefix = os.getenv("HOMEBREW_PREFIX")
local nvim_data = vim.fn.stdpath("data")
local xdg_cache_home = vim.fn.resolve(os.getenv("$XDG_CACHE_HOME"))
_ = xdg_cache_home
local xdg_config_home = vim.fn.resolve(os.getenv("$XDG_CONFIG_HOME"))

-- local srcpath = vim.fs.joinpath(home, "src")
local gopath = vim.fs.joinpath(home, "go")

local cmp_nvim_lsp = require("cmp_nvim_lsp")
local neodev = require("neodev")
neodev.setup({
  library = {
    enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
    runtime = true, -- runtime path
    types = true,   -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = {
      "nvim-cmp",
      "lsp-setup.nvim",
      "nvim-lspconfig",
      "mason.nvim",
      "mason-lspconfig.nvim",
      "cmp-nvim-lsp",
      "cmp-nvim-lsp-document-symbol",
      "cmp-nvim-lsp-signature-help",
      "cmp-buffer",
      "cmp-path",
      "lspkind-nvim",
      "LuaSnip",
      "friendly-snippets",
      "LuaSnip-snippets.nvim",
      "cmp_luasnip",
      "lsp-inlayhints.nvim",
      "fidget.nvim",
      "lspsaga.nvim",
      "lsp_signature.nvim",
      "cmp-git",
      "neodev.nvim",
      "cmp-nvim-lua",
      "schemastore.nvim",
      "lualine.nvim",
      "bufferline.nvim",
      "vim-matchup",
      "nvim-tree.lua",
      "nvim-bqf",
      "gitsigns.nvim",
      "nvim-dap",
      "nvim-dap-ui",
      "nvim-dap-virtual-text",
      "nvim-dap-go",
      "one-small-step-for-vimkind",
      "Comment.nvim",
      "chowcho.nvim",
      "accelerated-jk.nvim",
      "nvim-luaref",

      "nvim-treesitter",
      "plenary.nvim",
      "telescope.nvim",
    },
  },
  setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files

  -- for your Neovim config directory, the config.library settings will be used as is
  -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
  -- for any other directory, config.library.enabled will be set to false
  override = function(root_dir, options)
    _ = root_dir
    _ = options
  end,

  -- With lspconfig, Neodev will automatically setup your lua-language-server
  -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
  -- in your lsp start options
  lspconfig = true,
  -- much faster, but needs a recent built of lua-language-server
  -- needs lua-language-server >= 3.6.0
  pathStrict = true,
})

local lspconfig = require("lspconfig")
-- local lspconfig_async = require("lspconfig.async")
-- local lspconfig_configs = require("lspconfig.configs")
local lspconfig_util = require("lspconfig.util")
local lsp_setup = require("lsp-setup")
local lspkind = require("lspkind")
-- local lsp_format = require("lsp-format")
local navic = require("nvim-navic")
-- local inlayhints = require("lsp-inlayhints")

-- loading module to provide config for a server following steps from guide here
-- https://github.com/neovim/nvim-lspconfig/blob/ede4114e1fd41acb121c70a27e1b026ac68c42d6/doc/lspconfig.txt#L326
local configs = require 'lspconfig.configs'

-- copy paste from
-- https://github.com/neovim/nvim-lspconfig/blob/ede4114e1fd41acb121c70a27e1b026ac68c42d6/lua/lspconfig/server_configurations/gopls.lua
local util = require 'lspconfig.util'
local async = require 'lspconfig.async'
-- -> the following line fixes it - mod_cache initially set to value that you've got from `go env GOMODCACHE` command
local mod_cache = '/root/go/pkg/mod'

-- setting the config for gopls, the contents below is also copy-paste from
-- https://github.com/neovim/nvim-lspconfig/blob/ede4114e1fd41acb121c70a27e1b026ac68c42d6/lua/lspconfig/server_configurations/gopls.lua
configs.gopls = {
  default_config = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = function(fname)
      -- see: https://github.com/neovim/nvim-lspconfig/issues/804
      if not mod_cache then
        local result = async.run_command "go env GOMODCACHE"
        if result and result[1] then
          mod_cache = vim.trim(result[1])
        end
      end
      if fname:sub(1, #mod_cache) == mod_cache then
        local clients = vim.lsp.get_clients({ name = "gopls" })
        if #clients > 0 then --- @class lsp.Client
          local client = clients[#clients]
          return client.config.root_dir
        end
      end
      return util.root_pattern 'go.work' (fname) or util.root_pattern('go.mod', '.git')(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
  https://github.com/golang/tools/tree/master/gopls

  Google's lsp server for golang.
  ]],
  },
}

local mason_core_path = require("mason-core.path")
-- local mason_lspconfig = require("mason-lspconfig")

-- mason_lspconfig.setup_handlers({
--   ["clangd"] = function()
--     lspconfig.clangd.setup({
--       filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
--     })
--   end,
--   ["jsonls"] = function()
--     lspconfig.jsonls.setup({
--       filetypes = {
--         "json",
--         "jsonc",
--         "json5",
--       },
--     })
--   end,
--   ["terraformls"] = function()
--     lspconfig.terraformls.setup({
--       cmd = { "/usr/local/opt/terraform-ls/bin/terraform-ls", "serve" },
--     })
--   end,
--   ["tsserver"] = function()
--     lspconfig.tsserver.setup({
--       cmd = { "/usr/local/var/node/bin/tsserver" },
--     })
--   end,
--   ["sourcekit"] = function()
--     lspconfig.sourcekit.setup({
--       cmd = { 'sourcekit-lsp' },
--       filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
--       root_dir = lspconfig_util.root_pattern('Package.swift', 'buildServer.json', 'compile_commands.json', '.git'),
--     })
--   end
-- })

local asm_lsp_config = function()
  lspconfig.asm_lsp.setup({
    autostart = true,
    root_dir = function()
      return "/Users/zchee/src/github.com/bergercookie/asm-lsp/target/release"
    end,
    languages = {
      "asm",
      "goasm",
      "vmasm",
    },
    filetypes = {
      "asm",
      "goasm",
      "vmasm",
    },
  })
end

local awk_ls_config = function()
  lspconfig.awk_ls.setup({
    cmd = { mason_core_path.bin_prefix("awk-language-server") },
    single_file_support = true,
    handlers = {
      ["workspace/workspaceFolders"] = function()
        return {
          {
            uri = "file://" .. vim.fn.getcwd(),
            name = "current_dir",
          },
        }
      end,
    },
  })
end

local bufls_config = function()
  lspconfig.bufls.setup({
    cmd = { mason_core_path.bin_prefix("bufls"), "serve" },
    filetypes = { "proto" },
    root_dir = function(fname)
      return lspconfig.util.root_pattern("buf.yaml", ".git")(fname)
    end,
  })
end

local bashls_config = function()
  lspconfig.bashls.setup({
    autostart = true,
    cmd = { mason_core_path.bin_prefix("bash-language-server"), "start" },
    filetypes = { "sh", "bash" },
    settings = {
      backgroundAnalysisMaxFiles = 1000,
      enableSourceErrorDiagnostics = true,
      -- globPattern = "**/*@(.sh|.inc|.bash|.command)",
      -- explainshellEndpoint = "",
      -- logLevel = "info",
      includeAllWorkspaceSymbols = true,
      shellcheckPath = "/opt/local/bin/shellcheck",
    },
  })
end

local clangd_config = function()
  lspconfig.clangd.setup({
    cmd = {
      -- clangd version 18.0.0 (https://github.com/llvm/llvm-project 4b5366c9512aa273a5272af1d833961e1ed156e7)
      -- Features: mac+grpc+xpc
      -- Platform: x86_64-apple-darwin23.2.0
      "/opt/llvm/clangd/bin/clangd",
      "--all-scopes-completion",
      "--background-index",
      "--background-index-priority=normal",
      "--clang-tidy",
      "--completion-parse=auto",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--header-insertion=iwyu",
      "--header-insertion-decorators",
      "--import-insertions",
      "--limit-references=0",
      "--limit-results=0",
      "--rename-file-limit=1000",
      "--enable-config",
      "--enable-config",
      "-j=32",
      "--parse-forwarding-functions",
      "--pch-storage=memory",
      "--use-dirty-headers",
      "--input-style=standard",
      "--offset-encoding=utf-8",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    -- on_new_config = function(new_config, _)
    --   local cwd = vim.fn.getcwd()
    --   new_config.init_options = {
    --     compilationDatabasePath = cwd,
    --   }
    --
    --   -- if string.find(cwd, "google/EXEgesis") then
    --   --   new_config.cmd = vim.tbl_flatten({ new_config.cmd, "--header-insertion=never", "--compile-commands-dir="..cwd })
    --   -- end
    --   -- print(vim.inspect(new_config.init_options))
    -- end
  })
end

local cmake_config = function()
  lspconfig.cmake.setup({
    cmd = { mason_core_path.bin_prefix("cmake-language-server"), "--stdio" },
    on_init = function(client)
      client.config.settings = {
        cmake = {
          buildDirectory = "build",
        },
      }

      client.notify("workspace/didChangeConfiguration")
      return true
    end,
  })
end
_ = cmake_config

-- local denols_config = function()
--   lspconfig.denols.setup {
--     autostart = false,
--   }
-- end

local dockerls_config = function()
  lspconfig.dockerls.setup({
    -- cmd = { "node",
    --   vim.fs.joinpath(srcpath, "github.com", "rcjsuen", "dockerfile-language-server-nodejs", "bin", "docker-langserver"),
    --   "--stdio" },
    cmd = { mason_core_path.bin_prefix("docker-langserver"), "--stdio" },
    root_dir = lspconfig.util.root_pattern("Dockerfile", "*.dockerfile", "Dockerfile*"),
    on_init = function(client)
      client.config.settings = {
        docker = {
          languageserver = {
            diagnostics = {
              -- string values must be equal to "ignore", "warning", or "error"
              deprecatedMaintainer = "error",
              directiveCasing = "warning",
              emptyContinuationLine = "ignore",
              instructionCasing = "error",
              instructionCmdMultiple = "error",
              instructionEntrypointMultiple = "error",
              instructionHealthcheckMultiple = "error",
              instructionJSONInSingleQuotes = "error",
            },
            formatter = {
              ignoreMultilineInstructions = true,
            },
          },
        },
      }

      client.notify("workspace/didChangeConfiguration")
      return true
    end,
  })
end

-- local golangci_lint_ls_onfig = {
--   root_dir = lspconfig.util.root_pattern('.git', 'go.mod'),
--   init_options = {
--     command = { "golangci-lint", "run", "--out-format=json" }, -- , "--config=.golangci.yaml"
--   },
--   -- init_options = {
--   --   command = { "go", "run", "github.com/golangci/golangci-lint/cmd/golangci-lint", "run" },
--   -- },
--   on_init = function()
--     vim.uv.set_env("CGO_ENABLED", 0)
--   end,
-- }

-- https://github.com/golang/tools/blob/master/gopls/internal/lsp/source/options.go
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
local gopls_config = function()
  lspconfig.gopls.setup({
    cmd = { vim.fs.joinpath(gopath, "bin", "gopls"), "-remote=unix;/tmp/gopls.sock" },
    filetypes = { "go", "gomod", "gowork", "gotexttmpl", "gotmpl" },
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      directoryFilters = {
        "-**/-asm", -- mmcloughlin/avo
        -- "-**/-example",
        -- "-**/-examples",
        -- "-**/-sample",
        -- "-**/-samples",
        "-**/node_modules",
        -- "-rtloader", -- bytedance/sonic
        "-internal/kokoro/discogen",
      },
      memoryMode = "Normal", -- "DegradeClosed"
      completionDocumentation = true,
      usePlaceholders = true,
      deepCompletion = true,
      completeUnimported = true,
      completionBudget = "100ms",
      matcher = "fuzzy",
      symbolMatcher = "fastfuzzy",
      symbolStyle = "dynamic",
      symbolScope = "workspace",       -- "all",
      hoverKind = "fulldocumentation", -- "structured"
      linkTarget = "",
      linksInHover = false,
      importShortcut = "Definition",
      -- analyses = {
      --   asmdecl = true,
      --   assign = true,
      --   atomic = true,
      --   atomicalign = true,
      --   bools = true,
      --   buildtag = true,
      --   cgocall = true,
      --   composite = true,
      --   copylock = true,
      --   deepequalerrors = true,
      --   directive = true,
      --   errorsas = true,
      --   fieldalignment = true,
      --   httpresponse = true,
      --   ifaceassert = true,
      --   loopclosure = true,
      --   lostcancel = true,
      --   nilfunc = true,
      --   nilness = true,
      --   printf = true,
      --   shadow = true,
      --   shift = true,
      --   sortslice = true,
      --   stdmethods = true,
      --   stringintconv = true,
      --   structtag = true,
      --   testinggoroutine = true,
      --   tests = true,
      --   timeformat = true,
      --   unmarshal = true,
      --   unreachable = true,
      --   unsafeptr = true,
      --   unusedresult = true,
      --   unusedwrite = true,
      --   embeddirective = true,
      --   fillreturns = true,
      --   fillstruct = true,
      --   infertypeargs = true,
      --   nonewvars = true,
      --   noresultvalues = true,
      --   simplifycompositelit = true,
      --   simplifyrange = true,
      --   simplifyslice = true,
      --   stubmethods = true,
      --   undeclaredname = true,
      --   unusedparams = true,
      --   unusedvariable = true,
      --   useany = true,
      -- },
      -- hints = {
      --   assignVariableTypes = true,
      --   compositeLiteralFields = true,
      --   compositeLiteralTypes = true,
      --   constantValues = true,
      --   functionTypeParameters = true,
      --   parameterNames = true,
      --   rangeVariableTypes = true,
      -- },
      -- annotations = {
      --   ["nil"] = true,
      --   escape = true,
      --   inline = true,
      --   bounds = true,
      -- },
      vulncheck = "Off",
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
      staticcheck = false,
      verboseOutput = false,
      verboseWorkDoneProgress = false,
      -- tempModfile = true,
      showBugReports = false,
      gofumpt = true,
      semanticTokens = true,
      noSemanticString = false,
      noSemanticNumber = false,
      -- expandWorkspaceToModule = true,
      experimentalPostfixCompletions = true,
      -- experimentalWorkspaceModule = true,
      experimentalTemplateSupport = true,
      templateExtensions = { "tmpl", "gotmpl", "tpl" },
      diagnosticsDelay = "250ms",
      diagnosticsTrigger = "save",
      analysisProgressReporting = true,
      -- experimentalWatchedFileDelay = true,
      -- experimentalPackageCacheKey = true,
      allowModfileModifications = true,
      allowImplicitNetworkAccess = false,
      -- experimentalUseInvalidMetadata = true,
      standaloneTags = {
        "ignore",
      },
      newDiff = "new",
      chattyDiagnostics = false,
      subdirWatchPatterns = "auto",
    },
    on_new_config = function(new_config, _) -- new_root_dir
      local cwd = string(vim.fn.getcwd())

      local update_env = function()
        local envs = table()
        -- gvisor, moby/buildkit, chaos%-mesh/chaos%-mesh, zchee/go-cloud-debug-agent, go.opentelemetry.io/auto
        if
            string.find(cwd, "gvisor")
            or string.find(cwd, "buildkit")
            or string.find(cwd, "chaos%-mesh/chaos%-mesh")
            or string.find(cwd, "go%-cloud%-debug%-agent")
            or string.find(cwd, "GoogleCloudPlatform/grpc%-gcp%-tools")
            or string.find(cwd, "go.opentelemetry.io/auto")
        then
          envs = vim.tbl_deep_extend("keep", envs, {
            ["GOOS"] = { "linux" },
          })
        end
        -- go-clang/gen
        if string.find(cwd, "go%-clang/gen") then
          envs = vim.tbl_deep_extend("keep", envs, {
            ["CGO_CFLAGS"] = { "-Wno-deprecated-declarations" },
            ["CGO_LDFLAGS"] = {
              "-L/usr/local/opt/llvm/lib -Wl,%-rpath,/usr/local/opt/llvm/lib",
            },
          })
        end

        envs = vim.tbl_deep_extend("keep", envs, {
          ["GOWORK"] = { vim.fs.joinpath(cwd, "go.work") },
        })

        return envs
      end

      local update_buildFlags = function()
        local flags = table()
        if
            string.find(cwd, "gvisor")
            or string.find(cwd, "buildkit")
            or string.find(cwd, "chaos%-mesh/chaos%-mesh")
            or string.find(cwd, "go%-cloud%-debug%-agent")
            or string.find(cwd, "GoogleCloudPlatform/grpc%-gcp%-tools")
            or string.find(cwd, "go.opentelemetry.io/auto")
        then
          flags = vim.tbl_deep_extend("keep", flags, { "-tags=linux" })
        end

        return flags
      end

      new_config.settings.env = update_env()
      new_config.settings.buildFlags = update_buildFlags()
    end,
  })
end

-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
-- https://github.com/microsoft/pyright/blob/main/packages/vscode-pyright/package.json
-- https://github.com/microsoft/pyright/blob/main/packages/pyright-internal/src/common/configOptions.ts
local pyright_config = function()
  lspconfig.pyright.setup({
    settings = {
      python = {
        disableLanguageServices = false,
        disableOrganizeImports = false,
        openFilesOnly = false,
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "workspace", -- "openFilesOnly"
          diagnosticSeverityOverrides = {},
          exclude = {},
          extraPaths = {
            -- "/usr/local/google-cloud-sdk/lib",
            -- "/usr/local/google-cloud-sdk/lib/third_party",
            vim.fn.getcwd() .. "/third_party",
          },
          ignore = {},
          include = {},
          logLevel = "Error",
          stubPath = "",
          typeCheckingMode = "basic", -- "strict"
          typeshedPaths = {},
        },
        useLibraryCodeForTypes = true,
        functionSignatureDisplay = "formatted",
      },
    },
  })
end

local ruff_lsp_config = function()
  lspconfig.ruff_lsp.setup({
    on_attach = function(client, _)
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      }
    }
  })
end

local graphql_config = function()
  lspconfig.graphql.setup({
  })
end

local jsonls_config = function()
  lspconfig.jsonls.setup({
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = {
          enable = true,
        },
        schemas = require("schemastore").json.schemas(),
        resultLimit = 100000,
      },
    },
  })
end

-- local _runtime_path = {
--   "./?.lua",
--   "/Users/zchee/src/github.com/neovim/neovim/.deps/usr/share/luajit-2.1.0-beta3/?.lua",
--   "/usr/local/share/lua/5.1/?.lua",
--   "/usr/local/share/lua/5.1/?/init.lua",
--   "/Users/zchee/src/github.com/neovim/neovim/.deps/usr/share/lua/5.1/?.lua",
--   "/Users/zchee/src/github.com/neovim/neovim/.deps/usr/share/lua/5.1/?/init.lua",
--   "/Users/zchee/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua",
--   "/Users/zchee/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua",
--   "/Users/zchee/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua",
--   "/Users/zchee/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua",
-- }
-- _ = _runtime_path
-- local lua_ls_runtime_path = vim.split(package.path, ";")
-- local lua_ls_runtime_path = {
--   "?.lua",
--   "?/init.lua",
--   vim.fn.expand("~/.luarocks/share/lua/5.3/?.lua"),
--   vim.fn.expand("~/.luarocks/share/lua/5.3/?/init.lua"),
--   "/usr/share/5.3/?.lua",
--   "/usr/share/lua/5.3/?/init.lua"
-- }
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
-- local _ = vim.fs.find('lua', { path = vim.fs.joinpath(vim.fn.stdpath("data"), "site/pack/packer"), type = "directory", limit = math.huge })
-- local packer_plugins = function()
--   for _, v in pairs(vim.fn.values(packer_plugins)) do print(v.path) end
-- end
-- packer_plugins()

local lua_ls_workspace_library = function()
  return {
    vim.fs.find('lua', {
      -- path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      path = vim.fs.joinpath(string.format("%s", nvim_data), "site/pack/packer"),
      -- upward = true,
      -- stop = vim.uv.os_homedir(),
      type = "directory",
      limit = math.huge,
    }),
    vim.fs.find({ "lua" }, { types = "directory" }),
    vim.fs.joinpath(string.format("%s", nvim_data), "site/pack/packer/start/?/lua"),
    vim.fs.joinpath(string.format("%s", nvim_data), "site/pack/packer/opt/?/lua"),
  }
end
--
-- local userThirdParty = function()
--   local third_party_path = lua_ls_runtime_path
--   table.insert(third_party_path, "lua/?.lua")
--   table.insert(third_party_path, "lua/?/init.lua")
--   table.insert(third_party_path, vim.fn.stdpath("data") .. "/site/pack/packer/start/?/lua/?.lua")
--   table.insert(third_party_path, vim.fn.stdpath("data") .. "/site/pack/packer/start/?/lua/init.lua")
--   table.insert(third_party_path, vim.fn.stdpath("data") .. "/site/pack/packer/opt/?/lua/?.lua")
--   table.insert(third_party_path, vim.fn.stdpath("data") .. "/site/pack/packer/opt/?/lua/init.lua")
--
--   return third_party_path
-- end

local lua_ls_runtime_path = vim.split(package.path, ";")
table.insert(lua_ls_runtime_path, "lua/?.lua")
table.insert(lua_ls_runtime_path, "lua/?/init.lua")

-- https://github.com/LuaLS/lua-language-server/blob/master/script/config/template.lua
local lua_ls_config = function()
  lspconfig.lua_ls.setup({
    cmd = {
      mason_core_path.bin_prefix("lua-language-server"),
    },
    settings = {
      Lua = {
        completion = {
          autoRequire = false,
          callSnippet = "Both",
          displayContext = 1,
          enable = true,
          keywordSnippet = "Both",
        },
        diagnostics = {
          enable = true,
          globals = {
            "vim",            -- neovim builtin
            "package",        -- neovim builtin
            "packer_plugins", -- packer.nvim
            "describe",
            "it",
            "before_each",
            "after_each",
            "teardown",
            "pending",
            "clear", -- Busted
          },
          disable = {
            -- "missing-parameter",
            -- "undefined-field",
          },
          -- workspaceDelay = 3000,
          -- workspaceRate = 100,
          -- libraryFiles = "Enable",
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          },
        },
        hint = {
          enable = true,
        },
        runtime = {
          builtin = "defalut",
          path = lua_ls_runtime_path,
          pathStrict = true,
          unicodeName = true,
          version = "LuaJIT",
        },
        semantic = {
          enabled = true,
          variable = true,
          annotation = true,
          keyword = true,
        },
        telemetry = {
          enable = false,
        },
        window = {
          statusBar = true,
          progressBar = true,
        },
        workspace = {
          ignoreDir = {},
          useGitIgnore = true,
          maxPreload = 500000,     -- default: 5000
          preloadFileSize = 50000, -- default: 500
          -- library = userThirdParty(),
          library = lua_ls_workspace_library(),
          -- library = {
          --   vim.api.nvim_get_runtime_file("", true),
          --   -- lua_ls_runtime_path,
          -- },
          checkThirdParty = false,
          -- userThirdParty = userThirdParty(),
        },
      },
    },
    -- on_init = function(client)
    --   client.config.settings.Lua.workspace.library["/usr/share/nvim/runtime"] = nil
    --   -- client.server_capabilities.document_formatting = false
    --   -- client.server_capabilities.document_range_formatting = false
    --
    --   client.notify("workspace/didChangeConfiguration")
    --   return true
    -- end,
  })
end

local neocmake_config = function()
  lspconfig.neocmake.setup({
    cmd = { mason_core_path.bin_prefix("neocmakelsp"), "--stdio" },
    filetypes = { "cmake" },
    root_dir = function(fname)
      return lspconfig_util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    init_options = {
      format = {
        enable = true
      },
    },
  })
end

-- rust-analyzer.assist.emitMustUse (default: false)
-- Whether to insert #[must_use] when generating as_ methods for enum variants.
--
-- rust-analyzer.assist.expressionFillDefault (default: "todo")
-- Placeholder expression to use for missing expressions in assists.
--
-- rust-analyzer.cachePriming.enable (default: true)
-- Warm up caches on project load.
--
-- rust-analyzer.cachePriming.numThreads (default: 0)
-- How many worker threads to handle priming caches. The default 0 means to pick automatically.
--
-- rust-analyzer.cargo.autoreload (default: true)
-- Automatically refresh project info via cargo metadata on Cargo.toml or .cargo/config.toml changes.
--
-- rust-analyzer.cargo.buildScripts.enable (default: true)
-- Run build scripts (build.rs) for more precise code analysis.
--
-- rust-analyzer.cargo.buildScripts.invocationLocation (default: "workspace")
-- Specifies the working directory for running build scripts. - "workspace": run build scripts for a workspace in the workspace’s root directory. This is incompatible with rust-analyzer.cargo.buildScripts.invocationStrategy set to once. - "root": run build scripts in the project’s root directory. This config only has an effect when rust-analyzer.cargo.buildScripts.overrideCommand is set.
--
-- rust-analyzer.cargo.buildScripts.invocationStrategy (default: "per_workspace")
-- Specifies the invocation strategy to use when running the build scripts command. If per_workspace is set, the command will be executed for each workspace. If once is set, the command will be executed once. This config only has an effect when rust-analyzer.cargo.buildScripts.overrideCommand is set.
--
-- rust-analyzer.cargo.buildScripts.overrideCommand (default: null)
-- Override the command rust-analyzer uses to run build scripts and build procedural macros. The command is required to output json and should therefore include --message-format=json or a similar option.
--
-- If there are multiple linked projects/workspaces, this command is invoked for each of them, with the working directory being the workspace root (i.e., the folder containing the Cargo.toml). This can be overwritten by changing rust-analyzer.cargo.buildScripts.invocationStrategy and rust-analyzer.cargo.buildScripts.invocationLocation.
--
-- By default, a cargo invocation will be constructed for the configured targets and features, with the following base command line:
--
-- cargo check --quiet --workspace --message-format=json --all-targets
-- .
--
-- rust-analyzer.cargo.buildScripts.useRustcWrapper (default: true)
-- Use RUSTC_WRAPPER=rust-analyzer when running build scripts to avoid checking unnecessary things.
--
-- rust-analyzer.cargo.cfgs (default: {})
-- List of cfg options to enable with the given values.
--
-- rust-analyzer.cargo.extraArgs (default: [])
-- Extra arguments that are passed to every cargo invocation.
--
-- rust-analyzer.cargo.extraEnv (default: {})
-- Extra environment variables that will be set when running cargo, rustc or other commands within the workspace. Useful for setting RUSTFLAGS.
--
-- rust-analyzer.cargo.features (default: [])
-- List of features to activate.
--
-- Set this to "all" to pass --all-features to cargo.
--
-- rust-analyzer.cargo.noDefaultFeatures (default: false)
-- Whether to pass --no-default-features to cargo.
--
-- rust-analyzer.cargo.sysroot (default: "discover")
-- Relative path to the sysroot, or "discover" to try to automatically find it via "rustc --print sysroot".
--
-- Unsetting this disables sysroot loading.
--
-- This option does not take effect until rust-analyzer is restarted.
--
-- rust-analyzer.cargo.sysrootSrc (default: null)
-- Relative path to the sysroot library sources. If left unset, this will default to {cargo.sysroot}/lib/rustlib/src/rust/library.
--
-- This option does not take effect until rust-analyzer is restarted.
--
-- rust-analyzer.cargo.target (default: null)
-- Compilation target override (target triple).
--
-- rust-analyzer.cargo.unsetTest (default: ["core"])
-- Unsets the implicit #[cfg(test)] for the specified crates.
--
-- rust-analyzer.checkOnSave (default: true)
-- Run the check command for diagnostics on save.
--
-- rust-analyzer.check.allTargets (default: true)
-- Check all targets and tests (--all-targets).
--
-- rust-analyzer.check.command (default: "check")
-- Cargo command to use for cargo check.
--
-- rust-analyzer.check.extraArgs (default: [])
-- Extra arguments for cargo check.
--
-- rust-analyzer.check.extraEnv (default: {})
-- Extra environment variables that will be set when running cargo check. Extends rust-analyzer.cargo.extraEnv.
--
-- rust-analyzer.check.features (default: null)
-- List of features to activate. Defaults to rust-analyzer.cargo.features.
--
-- Set to "all" to pass --all-features to Cargo.
--
-- rust-analyzer.check.ignore (default: [])
-- List of cargo check (or other command specified in check.command) diagnostics to ignore.
--
-- For example for cargo check: dead_code, unused_imports, unused_variables,…​
--
-- rust-analyzer.check.invocationLocation (default: "workspace")
-- Specifies the working directory for running checks. - "workspace": run checks for workspaces in the corresponding workspaces' root directories. This falls back to "root" if rust-analyzer.cargo.check.invocationStrategy is set to once. - "root": run checks in the project’s root directory. This config only has an effect when rust-analyzer.cargo.check.overrideCommand is set.
--
-- rust-analyzer.check.invocationStrategy (default: "per_workspace")
-- Specifies the invocation strategy to use when running the check command. If per_workspace is set, the command will be executed for each workspace. If once is set, the command will be executed once. This config only has an effect when rust-analyzer.cargo.check.overrideCommand is set.
--
-- rust-analyzer.check.noDefaultFeatures (default: null)
-- Whether to pass --no-default-features to Cargo. Defaults to rust-analyzer.cargo.noDefaultFeatures.
--
-- rust-analyzer.check.overrideCommand (default: null)
-- Override the command rust-analyzer uses instead of cargo check for diagnostics on save. The command is required to output json and should therefore include --message-format=json or a similar option (if your client supports the colorDiagnosticOutput experimental capability, you can use --message-format=json-diagnostic-rendered-ansi).
--
-- If you’re changing this because you’re using some tool wrapping Cargo, you might also want to change rust-analyzer.cargo.buildScripts.overrideCommand.
--
-- If there are multiple linked projects/workspaces, this command is invoked for each of them, with the working directory being the workspace root (i.e., the folder containing the Cargo.toml). This can be overwritten by changing rust-analyzer.cargo.check.invocationStrategy and rust-analyzer.cargo.check.invocationLocation.
--
-- An example command would be:
--
-- cargo check --workspace --message-format=json --all-targets
-- .
--
-- rust-analyzer.check.targets (default: null)
-- Check for specific targets. Defaults to rust-analyzer.cargo.target if empty.
--
-- Can be a single target, e.g. "x86_64-unknown-linux-gnu" or a list of targets, e.g. ["aarch64-apple-darwin", "x86_64-apple-darwin"].
--
-- Aliased as "checkOnSave.targets".
--
-- rust-analyzer.completion.autoimport.enable (default: true)
-- Toggles the additional completions that automatically add imports when completed. Note that your client must specify the additionalTextEdits LSP client capability to truly have this feature enabled.
--
-- rust-analyzer.completion.autoself.enable (default: true)
-- Toggles the additional completions that automatically show method calls and field accesses with self prefixed to them when inside a method.
--
-- rust-analyzer.completion.callable.snippets (default: "fill_arguments")
-- Whether to add parenthesis and argument snippets when completing function.
--
-- rust-analyzer.completion.fullFunctionSignatures.enable (default: false)
-- Whether to show full function/method signatures in completion docs.
--
-- rust-analyzer.completion.limit (default: null)
-- Maximum number of completions to return. If None, the limit is infinite.
--
-- rust-analyzer.completion.postfix.enable (default: true)
-- Whether to show postfix snippets like dbg, if, not, etc.
--
-- rust-analyzer.completion.privateEditable.enable (default: false)
-- Enables completions of private items and fields that are defined in the current workspace even if they are not visible at the current position.
--
-- rust-analyzer.completion.snippets.custom
-- Default:
--
-- {
--             "Arc::new": {
--                 "postfix": "arc",
--                 "body": "Arc::new(${receiver})",
--                 "requires": "std::sync::Arc",
--                 "description": "Put the expression into an `Arc`",
--                 "scope": "expr"
--             },
--             "Rc::new": {
--                 "postfix": "rc",
--                 "body": "Rc::new(${receiver})",
--                 "requires": "std::rc::Rc",
--                 "description": "Put the expression into an `Rc`",
--                 "scope": "expr"
--             },
--             "Box::pin": {
--                 "postfix": "pinbox",
--                 "body": "Box::pin(${receiver})",
--                 "requires": "std::boxed::Box",
--                 "description": "Put the expression into a pinned `Box`",
--                 "scope": "expr"
--             },
--             "Ok": {
--                 "postfix": "ok",
--                 "body": "Ok(${receiver})",
--                 "description": "Wrap the expression in a `Result::Ok`",
--                 "scope": "expr"
--             },
--             "Err": {
--                 "postfix": "err",
--                 "body": "Err(${receiver})",
--                 "description": "Wrap the expression in a `Result::Err`",
--                 "scope": "expr"
--             },
--             "Some": {
--                 "postfix": "some",
--                 "body": "Some(${receiver})",
--                 "description": "Wrap the expression in an `Option::Some`",
--                 "scope": "expr"
--             }
--         }
-- Custom completion snippets.
--
-- rust-analyzer.diagnostics.disabled (default: [])
-- List of rust-analyzer diagnostics to disable.
--
-- rust-analyzer.diagnostics.enable (default: true)
-- Whether to show native rust-analyzer diagnostics.
--
-- rust-analyzer.diagnostics.experimental.enable (default: false)
-- Whether to show experimental rust-analyzer diagnostics that might have more false positives than usual.
--
-- rust-analyzer.diagnostics.remapPrefix (default: {})
-- Map of prefixes to be substituted when parsing diagnostic file paths. This should be the reverse mapping of what is passed to rustc as --remap-path-prefix.
--
-- rust-analyzer.diagnostics.warningsAsHint (default: [])
-- List of warnings that should be displayed with hint severity.
--
-- The warnings will be indicated by faded text or three dots in code and will not show up in the Problems Panel.
--
-- rust-analyzer.diagnostics.warningsAsInfo (default: [])
-- List of warnings that should be displayed with info severity.
--
-- The warnings will be indicated by a blue squiggly underline in code and a blue icon in the Problems Panel.
--
-- rust-analyzer.files.excludeDirs (default: [])
-- These directories will be ignored by rust-analyzer. They are relative to the workspace root, and globs are not supported. You may also need to add the folders to Code’s files.watcherExclude.
--
-- rust-analyzer.files.watcher (default: "client")
-- Controls file watching implementation.
--
-- rust-analyzer.highlightRelated.breakPoints.enable (default: true)
-- Enables highlighting of related references while the cursor is on break, loop, while, or for keywords.
--
-- rust-analyzer.highlightRelated.closureCaptures.enable (default: true)
-- Enables highlighting of all captures of a closure while the cursor is on the | or move keyword of a closure.
--
-- rust-analyzer.highlightRelated.exitPoints.enable (default: true)
-- Enables highlighting of all exit points while the cursor is on any return, ?, fn, or return type arrow (→).
--
-- rust-analyzer.highlightRelated.references.enable (default: true)
-- Enables highlighting of related references while the cursor is on any identifier.
--
-- rust-analyzer.highlightRelated.yieldPoints.enable (default: true)
-- Enables highlighting of all break points for a loop or block context while the cursor is on any async or await keywords.
--
-- rust-analyzer.hover.actions.debug.enable (default: true)
-- Whether to show Debug action. Only applies when rust-analyzer.hover.actions.enable is set.
--
-- rust-analyzer.hover.actions.enable (default: true)
-- Whether to show HoverActions in Rust files.
--
-- rust-analyzer.hover.actions.gotoTypeDef.enable (default: true)
-- Whether to show Go to Type Definition action. Only applies when rust-analyzer.hover.actions.enable is set.
--
-- rust-analyzer.hover.actions.implementations.enable (default: true)
-- Whether to show Implementations action. Only applies when rust-analyzer.hover.actions.enable is set.
--
-- rust-analyzer.hover.actions.references.enable (default: false)
-- Whether to show References action. Only applies when rust-analyzer.hover.actions.enable is set.
--
-- rust-analyzer.hover.actions.run.enable (default: true)
-- Whether to show Run action. Only applies when rust-analyzer.hover.actions.enable is set.
--
-- rust-analyzer.hover.documentation.enable (default: true)
-- Whether to show documentation on hover.
--
-- rust-analyzer.hover.documentation.keywords.enable (default: true)
-- Whether to show keyword hover popups. Only applies when rust-analyzer.hover.documentation.enable is set.
--
-- rust-analyzer.hover.links.enable (default: true)
-- Use markdown syntax for links on hover.
--
-- rust-analyzer.hover.memoryLayout.alignment (default: "hexadecimal")
-- How to render the align information in a memory layout hover.
--
-- rust-analyzer.hover.memoryLayout.enable (default: true)
-- Whether to show memory layout data on hover.
--
-- rust-analyzer.hover.memoryLayout.niches (default: false)
-- How to render the niche information in a memory layout hover.
--
-- rust-analyzer.hover.memoryLayout.offset (default: "hexadecimal")
-- How to render the offset information in a memory layout hover.
--
-- rust-analyzer.hover.memoryLayout.size (default: "both")
-- How to render the size information in a memory layout hover.
--
-- rust-analyzer.imports.granularity.enforce (default: false)
-- Whether to enforce the import granularity setting for all files. If set to false rust-analyzer will try to keep import styles consistent per file.
--
-- rust-analyzer.imports.granularity.group (default: "crate")
-- How imports should be grouped into use statements.
--
-- rust-analyzer.imports.group.enable (default: true)
-- Group inserted imports by the following order. Groups are separated by newlines.
--
-- rust-analyzer.imports.merge.glob (default: true)
-- Whether to allow import insertion to merge new imports into single path glob imports like use std::fmt::*;.
--
-- rust-analyzer.imports.preferNoStd (default: false)
-- Prefer to unconditionally use imports of the core and alloc crate, over the std crate.
--
-- rust-analyzer.imports.preferPrelude (default: false)
-- Whether to prefer import paths containing a prelude module.
--
-- rust-analyzer.imports.prefix (default: "plain")
-- The path structure for newly inserted paths to use.
--
-- rust-analyzer.inlayHints.bindingModeHints.enable (default: false)
-- Whether to show inlay type hints for binding modes.
--
-- rust-analyzer.inlayHints.chainingHints.enable (default: true)
-- Whether to show inlay type hints for method chains.
--
-- rust-analyzer.inlayHints.closingBraceHints.enable (default: true)
-- Whether to show inlay hints after a closing } to indicate what item it belongs to.
--
-- rust-analyzer.inlayHints.closingBraceHints.minLines (default: 25)
-- Minimum number of lines required before the } until the hint is shown (set to 0 or 1 to always show them).
--
-- rust-analyzer.inlayHints.closureCaptureHints.enable (default: false)
-- Whether to show inlay hints for closure captures.
--
-- rust-analyzer.inlayHints.closureReturnTypeHints.enable (default: "never")
-- Whether to show inlay type hints for return types of closures.
--
-- rust-analyzer.inlayHints.closureStyle (default: "impl_fn")
-- Closure notation in type and chaining inlay hints.
--
-- rust-analyzer.inlayHints.discriminantHints.enable (default: "never")
-- Whether to show enum variant discriminant hints.
--
-- rust-analyzer.inlayHints.expressionAdjustmentHints.enable (default: "never")
-- Whether to show inlay hints for type adjustments.
--
-- rust-analyzer.inlayHints.expressionAdjustmentHints.hideOutsideUnsafe (default: false)
-- Whether to hide inlay hints for type adjustments outside of unsafe blocks.
--
-- rust-analyzer.inlayHints.expressionAdjustmentHints.mode (default: "prefix")
-- Whether to show inlay hints as postfix ops (. instead of , etc).
--
-- rust-analyzer.inlayHints.lifetimeElisionHints.enable (default: "never")
-- Whether to show inlay type hints for elided lifetimes in function signatures.
--
-- rust-analyzer.inlayHints.lifetimeElisionHints.useParameterNames (default: false)
-- Whether to prefer using parameter names as the name for elided lifetime hints if possible.
--
-- rust-analyzer.inlayHints.maxLength (default: 25)
-- Maximum length for inlay hints. Set to null to have an unlimited length.
--
-- rust-analyzer.inlayHints.parameterHints.enable (default: true)
-- Whether to show function parameter name inlay hints at the call site.
--
-- rust-analyzer.inlayHints.reborrowHints.enable (default: "never")
-- Whether to show inlay hints for compiler inserted reborrows. This setting is deprecated in favor of rust-analyzer.inlayHints.expressionAdjustmentHints.enable.
--
-- rust-analyzer.inlayHints.renderColons (default: true)
-- Whether to render leading colons for type hints, and trailing colons for parameter hints.
--
-- rust-analyzer.inlayHints.typeHints.enable (default: true)
-- Whether to show inlay type hints for variables.
--
-- rust-analyzer.inlayHints.typeHints.hideClosureInitialization (default: false)
-- Whether to hide inlay type hints for let statements that initialize to a closure. Only applies to closures with blocks, same as rust-analyzer.inlayHints.closureReturnTypeHints.enable.
--
-- rust-analyzer.inlayHints.typeHints.hideNamedConstructor (default: false)
-- Whether to hide inlay type hints for constructors.
--
-- rust-analyzer.interpret.tests (default: false)
-- Enables the experimental support for interpreting tests.
--
-- rust-analyzer.joinLines.joinAssignments (default: true)
-- Join lines merges consecutive declaration and initialization of an assignment.
--
-- rust-analyzer.joinLines.joinElseIf (default: true)
-- Join lines inserts else between consecutive ifs.
--
-- rust-analyzer.joinLines.removeTrailingComma (default: true)
-- Join lines removes trailing commas.
--
-- rust-analyzer.joinLines.unwrapTrivialBlock (default: true)
-- Join lines unwraps trivial blocks.
--
-- rust-analyzer.lens.debug.enable (default: true)
-- Whether to show Debug lens. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.lens.enable (default: true)
-- Whether to show CodeLens in Rust files.
--
-- rust-analyzer.lens.forceCustomCommands (default: true)
-- Internal config: use custom client-side commands even when the client doesn’t set the corresponding capability.
--
-- rust-analyzer.lens.implementations.enable (default: true)
-- Whether to show Implementations lens. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.lens.location (default: "above_name")
-- Where to render annotations.
--
-- rust-analyzer.lens.references.adt.enable (default: false)
-- Whether to show References lens for Struct, Enum, and Union. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.lens.references.enumVariant.enable (default: false)
-- Whether to show References lens for Enum Variants. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.lens.references.method.enable (default: false)
-- Whether to show Method References lens. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.lens.references.trait.enable (default: false)
-- Whether to show References lens for Trait. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.lens.run.enable (default: true)
-- Whether to show Run lens. Only applies when rust-analyzer.lens.enable is set.
--
-- rust-analyzer.linkedProjects (default: [])
-- Disable project auto-discovery in favor of explicitly specified set of projects.
--
-- Elements must be paths pointing to Cargo.toml, rust-project.json, or JSON objects in rust-project.json format.
--
-- rust-analyzer.lru.capacity (default: null)
-- Number of syntax trees rust-analyzer keeps in memory. Defaults to 128.
--
-- rust-analyzer.lru.query.capacities (default: {})
-- Sets the LRU capacity of the specified queries.
--
-- rust-analyzer.notifications.cargoTomlNotFound (default: true)
-- Whether to show can’t find Cargo.toml error message.
--
-- rust-analyzer.numThreads (default: null)
-- How many worker threads in the main loop. The default null means to pick automatically.
--
-- rust-analyzer.procMacro.attributes.enable (default: true)
-- Expand attribute macros. Requires rust-analyzer.procMacro.enable to be set.
--
-- rust-analyzer.procMacro.enable (default: true)
-- Enable support for procedural macros, implies rust-analyzer.cargo.buildScripts.enable.
--
-- rust-analyzer.procMacro.ignored (default: {})
-- These proc-macros will be ignored when trying to expand them.
--
-- This config takes a map of crate names with the exported proc-macro names to ignore as values.
--
-- rust-analyzer.procMacro.server (default: null)
-- Internal config, path to proc-macro server executable.
--
-- rust-analyzer.references.excludeImports (default: false)
-- Exclude imports from find-all-references.
--
-- rust-analyzer.runnables.command (default: null)
-- Command to be executed instead of 'cargo' for runnables.
--
-- rust-analyzer.runnables.extraArgs (default: [])
-- Additional arguments to be passed to cargo for runnables such as tests or binaries. For example, it may be --release.
--
-- rust-analyzer.rust.analyzerTargetDir (default: null)
-- Optional path to a rust-analyzer specific target directory. This prevents rust-analyzer’s cargo check from locking the Cargo.lock at the expense of duplicating build artifacts.
--
-- Set to true to use a subdirectory of the existing target directory or set to a path relative to the workspace to use that path.
--
-- rust-analyzer.rustc.source (default: null)
-- Path to the Cargo.toml of the rust compiler workspace, for usage in rustc_private projects, or "discover" to try to automatically find it if the rustc-dev component is installed.
--
-- Any project which uses rust-analyzer with the rustcPrivate crates must set [package.metadata.rust-analyzer] rustc_private=true to use it.
--
-- This option does not take effect until rust-analyzer is restarted.
--
-- rust-analyzer.rustfmt.extraArgs (default: [])
-- Additional arguments to rustfmt.
--
-- rust-analyzer.rustfmt.overrideCommand (default: null)
-- Advanced option, fully override the command rust-analyzer uses for formatting. This should be the equivalent of rustfmt here, and not that of cargo fmt. The file contents will be passed on the standard input and the formatted result will be read from the standard output.
--
-- rust-analyzer.rustfmt.rangeFormatting.enable (default: false)
-- Enables the use of rustfmt’s unstable range formatting command for the textDocument/rangeFormatting request. The rustfmt option is unstable and only available on a nightly build.
--
-- rust-analyzer.semanticHighlighting.doc.comment.inject.enable (default: true)
-- Inject additional highlighting into doc comments.
--
-- When enabled, rust-analyzer will highlight rust source in doc comments as well as intra doc links.
--
-- rust-analyzer.semanticHighlighting.nonStandardTokens (default: true)
-- Whether the server is allowed to emit non-standard tokens and modifiers.
--
-- rust-analyzer.semanticHighlighting.operator.enable (default: true)
-- Use semantic tokens for operators.
--
-- When disabled, rust-analyzer will emit semantic tokens only for operator tokens when they are tagged with modifiers.
--
-- rust-analyzer.semanticHighlighting.operator.specialization.enable (default: false)
-- Use specialized semantic tokens for operators.
--
-- When enabled, rust-analyzer will emit special token types for operator tokens instead of the generic operator token type.
--
-- rust-analyzer.semanticHighlighting.punctuation.enable (default: false)
-- Use semantic tokens for punctuation.
--
-- When disabled, rust-analyzer will emit semantic tokens only for punctuation tokens when they are tagged with modifiers or have a special role.
--
-- rust-analyzer.semanticHighlighting.punctuation.separate.macro.bang (default: false)
-- When enabled, rust-analyzer will emit a punctuation semantic token for the ! of macro calls.
--
-- rust-analyzer.semanticHighlighting.punctuation.specialization.enable (default: false)
-- Use specialized semantic tokens for punctuation.
--
-- When enabled, rust-analyzer will emit special token types for punctuation tokens instead of the generic punctuation token type.
--
-- rust-analyzer.semanticHighlighting.strings.enable (default: true)
-- Use semantic tokens for strings.
--
-- In some editors (e.g. vscode) semantic tokens override other highlighting grammars. By disabling semantic tokens for strings, other grammars can be used to highlight their contents.
--
-- rust-analyzer.signatureInfo.detail (default: "full")
-- Show full signature of the callable. Only shows parameters if disabled.
--
-- rust-analyzer.signatureInfo.documentation.enable (default: true)
-- Show documentation.
--
-- rust-analyzer.typing.autoClosingAngleBrackets.enable (default: false)
-- Whether to insert closing angle brackets when typing an opening angle bracket of a generic argument list.
--
-- rust-analyzer.workspace.symbol.search.kind (default: "only_types")
-- Workspace symbol search kind.
--
-- rust-analyzer.workspace.symbol.search.limit (default: 128)
-- Limits the number of items returned from a workspace symbol search (Defaults to 128). Some clients like vs-code issue new searches on result filtering and don’t require all results to be returned in the initial search. Other clients requires all results upfront and might require a higher limit.
--
-- rust-analyzer.workspace.symbol.search.scope (default: "workspace")
-- Workspace symbol search scope.

local rust_analyzer_config = function()
  lspconfig.rust_analyzer.setup({
    cmd = { vim.fs.joinpath(os.getenv("RUST_HOME"), "cargo", "bin", "rust-analyzer") },
    settings = {
      sorbet = {
        enabled = true,
        highlightUntyped = true,
      },
    },
  })
end

local sourcekit_config = function()
  lspconfig.sourcekit.setup({
    cmd = { "sourcekit-lsp" }, -- , "-c", "release", "--completion-max-results=1000"
    filetypes = { "swift" },   -- , "c", "cpp", "objective-c", "objective-cpp"
    root_dir = lspconfig_util.root_pattern("Package.swift", "buildServer.json", "compile_commands.json", ".git"),
    settings = {},
  })
end
_ = sourcekit_config

local terraformls_config = function()
  lspconfig.terraformls.setup({
    cmd = { "/usr/local/opt/terraform-ls-head/bin/terraform-ls", "serve" },
    root_dir = lspconfig_util.root_pattern(
      ".terraform.lock.hcl",
      "providers.tf",
      "version.tf",
      ".terraform",
      ".git"
    ),
    settings = {
      terraformls = {
        indexing = {
          ignoreDirectoryNames = {},
          ignorePaths = {},
        },
        experimentalFeatures = {
          validateOnSave = true,
          prefillRequiredFields = true,
        },
        validation = {
          enableEnhancedValidation = true,
        },
      },
    },
  })
end

local tsserver_config = function()
  lspconfig.tsserver.setup({
    cmd = {
      vim.fs.joinpath(homebrew_prefix, "opt", "typescript-language-server-head", "bin", "typescript-language-server"),
      "--stdio"
    },
    -- "--tsserver-path",
    -- vim.fs.joinpath(homebrew_prefix, "opt", "typescript", "bin", "tsserver"),
    -- mason_core_path.bin_prefix("typescript-language-server"),
    -- "--stdio",
    -- "--tsserver-path",
    -- "mason/packages/typescript-language-server/node_modules/typescript/bin/tsserver"
    root_dir = lspconfig.util.root_pattern(
      "node_modules",
      ".git",
      "package.json",
      "tsconfig.json"
    ),
    settings = {
      tsserver = {
        typescript = {
          tsserver = {
            experimental = {
              enableProjectDiagnostics = true,
            },
          },
          enablePromptUseWorkspaceTsdk = true,
          workspaceSymbols = {
            scope = "currentProjects",
          },
        },
      }
    },
  })
end

local vimls_config = function()
  lspconfig.vimls.setup({})
end

local vtsls_config = function()
  -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
end

local yamlls_config = function()
  lspconfig.yamlls.setup({
    cmd = { mason_core_path.bin_prefix("yaml-language-server"), "--stdio" },
    -- cmd = { "/Users/zchee/src/github.com/redhat-developer/yaml-language-server/bin/yaml-language-server", "--stdio" },
    settings = {
      yaml = {
        -- yamlVersion = 1.2,
        format = {
          enable = true,
          singleQuote = false,
          bracketSpacing = true,
          printWidth = 150,
        },
        validate = true,
        hover = true,
        completion = true,
        schemaStore = {
          enbale = true,
          url = "https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json",
        },
        disableAdditionalProperties = false,
        -- disableDefaultProperties = true,
        -- suggest = {
        --   parentSkeletonSelectedFirst = true,
        -- },
        -- style = {
        --   flowMapping = "forbid",
        --   flowSequence = "forbid",
        -- },
        schemas = {
          -- local
          ["file:///Users/zchee/src/github.com/zchee/schema/buf.schema.json"] = {
            "buf.yaml",
          },
          -- ["file:///Users/zchee/src/github.com/zchee/schema/circleci.official.schema.json"] = {
          --   ".circleci/config.yml",
          --   -- "@orb.yml",
          --   -- "**/commands/*.yml",
          --   -- "**/examples/*.yml",
          --   -- "**/executors/*.yml",
          --   -- "**/jobs/*.yml"
          -- },
          ["file:///Users/zchee/src/github.com/zchee/schema/Revision.serving.knative.dev.json"] = {
            "*.knative.yaml",
          },
          ["file:///Users/zchee/src/github.com/zchee/schema/clangd.schema.json"] = {
            ".clangd",
            vim.fs.joinpath(xdg_config_home, "clangd/config.yaml"),
          },
          ["file:///Users/zchee/src/github.com/zchee/schema/kaitai-struct-compiler.schema.json"] = {
            "*.ksy",
          },
          -- mkdocs
          ["file:///Users/zchee/src/github.com/zchee/schema/mkdocs.schema.json"] = {
            "mkdocs.yml",
          },
          -- open-rpc
          ["file:///Users/zchee/src/github.com/zchee/schema/open-rpc.schema.json"] = {
            "openrpc.yaml",
          },
          -- Cloud Workflows
          ["file:///Users/zchee/src/github.com/zchee/schema/workflows.schema.json"] = {
            "workflows.yaml",
            "*.workflows.yaml",
            "workflows.yml",
            "*.workflows.yml",
            "workflows-demos/**/*.yaml",
          },

          -- SchemaStore
          -- appveyor
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/appveyor.json"] = {
            "*appveyor.yml",
          },
          -- circleci
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/circleciconfig.json"] = {
            ".circleci/config.yml",
            ".circleci/config.yaml",
          },
          -- clang-format
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/clang-format.json"] = {
            ".clang-format",
          },
          -- cloudbuild
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/cloudbuild.json"] = {
            "*cloudbuild.yaml",
            "*cloudbuild.*.yaml",
          },
          -- compile-commands.json
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/compile-commands.json"] = {
            "compile_commands.json",
          },
          -- dependabot
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/dependabot-2.0.json"] = {
            ".github/dependabot.yml",
          },
          -- github-action
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-action.json"] = {
            "**/action.yml",
            "**/action.yaml",
          },
          -- github-issue-forms
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-issue-forms.json"] = {
            ".github/ISSUE_TEMPLATE/*.yml",
            ".github/ISSUE_TEMPLATE/*.yaml",
          },
          -- github-issue-config
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-issue-config.json"] = {
            ".github/ISSUE_TEMPLATE/config.yml",
            ".github/ISSUE_TEMPLATE/config.yaml",
          },
          -- github-workflow
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-workflow.json"] = {
            ".github/workflows/*.yml",
            ".github/workflows/*.yaml",
          },
          -- golangci-lint
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/golangci-lint.json"] = {
            ".golangci.yml",
            ".golangci.yaml",
          },
          -- kustomize
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/kustomization.json"] = {
            "kustomization.yaml",
            "kustomizeconfig.yaml",
          },
          -- yamllint
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/yamllint.json"] = {
            ".yamllint.yaml",
          },
          -- helm
          ["https://raw.githubusercontent.com/open-telemetry/opentelemetry-helm-charts/main/charts/opentelemetry-operator/values.schema.json"] = {
            "opentelemetry-operator/values.yaml",
          },
          -- codecov
          ["https://raw.githubusercontent.com/codecov/vscode/main/schemas/codecov.json"] = {
            "*codecov.yml",
            "*codecov.yaml",
          },
          -- azure-pipelines
          ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/main/service-schema.json"] = {
            "azure-pipelines.yml",
          },
          -- compose
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
            "*docker-compose*.yaml",
            "*docker-compose*.yml",
          },
          -- Swagger
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v2.0/schema.json"] = {
            "*swagger.yaml",
            "**/swagger-spec/*.yaml",
          },
          -- OpenAPI
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = {
            "*openapi*.yaml",
            "**/openapi-spec/*.yaml",
          },
          -- discovery (disco)
          ["https://raw.githubusercontent.com/googleapis/gnostic/master/discovery/discovery.json"] = {
            "*discovery.yaml",
          },
          -- skaffold
          ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/main/docs-v2/content/en/schemas/v3alpha1.json"] = {
            "skaffold*.yaml",
          },
          -- renovate
          ["https://docs.renovatebot.com/renovate-schema.json"] = {
            "renovate.json",
            "renovate.json5",
            ".renovaterc",
            ".renovaterc.json",
          },
          -- other
          ["https://raw.githubusercontent.com/microsoft/vscode-languageserver-node/main/protocol/metaModel.schema.json"] = {
            "metaModel.yaml",
            "lsp*.yaml",
          },

          -- kubernetes
          ["kubernetes"] = {
            "comfigmap.yaml",
            "daemonset.yaml",
            "deployment.yaml",
            "pod.yaml",
            "replicaset.yaml",
            "secrets*.yaml",
            "service.yaml",
            "service_account.yaml",
            "statefulset.yaml",
          },
        },
      },
    },
  })
end

local zls_config = function()
  -- https://github.com/zigtools/zls?tab=readme-ov-file#configuration-options
end

navic.setup({
  icons = {
    File = ' ',
    Module = ' ',
    Namespace = ' ',
    Package = ' ',
    Class = ' ',
    Method = ' ',
    Property = ' ',
    Field = ' ',
    Constructor = ' ',
    Enum = ' ',
    Interface = ' ',
    Function = ' ',
    Variable = ' ',
    Constant = ' ',
    String = ' ',
    Number = ' ',
    Boolean = ' ',
    Array = ' ',
    Object = ' ',
    Key = ' ',
    Null = ' ',
    EnumMember = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' '
  },
  lsp = {
    auto_attach = false,
    preference = nil,
  },
  highlight = false,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
  safe_output = true,
  lazy_update_context = true,
  click = false
})

local on_attach = function(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  if client.server_capabilities.documentFormattingProvider then
    local lsp_format_augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
      group = lsp_format_augroup,
      callback = function()
        vim.lsp.buf.format({
          async = false,
          trimTrailingWhitespace = true,
          insertFinalNewline = true,
        })
      end,
    })
  end
end

local capabilities_config = function()
  local capabilities = cmp_nvim_lsp.default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.contextSupport = true
  capabilities.textDocument.definition = {
    linkSupport = false,
  }

  return capabilities
end

-- @param tbl table
-- @return table
-- local get_keys = function(tbl)
--   local keys = {}
--   for k, _ in pairs(tbl) do
--     table.insert(keys, k)
--   end
--   return keys
-- end

-- @param tbl table
-- @return table
-- local get_servers = function(tbl)
--   local servers = {}
--   for server, config in pairs(tbl) do
--     servers[server] = config
--   end
--   return servers
-- end

local servers = {
  ["asm_lsp"] = asm_lsp_config,
  ["awk_ls"] = awk_ls_config,
  ["bashls"] = bashls_config,
  ["bufls"] = bufls_config,
  ["clangd"] = clangd_config,
  -- ["cmake"] = cmake_config,
  ["dagger"] = {},
  ["docker_compose_language_service"] = {},
  ["dockerls"] = dockerls_config,
  -- ["golangci_lint_ls"] = golangci_lint_ls_config,
  ["gopls"] = gopls_config,
  ["graphql"] = graphql_config,
  ["helm_ls"] = {},
  ["jsonls"] = jsonls_config,
  ["lua_ls"] = lua_ls_config,
  ["neocmake"] = neocmake_config,
  ["pyright"] = pyright_config,
  ["ruff_lsp"] = ruff_lsp_config,
  ["rust_analyzer"] = rust_analyzer_config,
  -- ["sourcekit"] = sourcekit_config,
  ["terraformls"] = terraformls_config,
  ["tsserver"] = tsserver_config,
  ["vimls"] = vimls_config,
  ["vtsls"] = vtsls_config,
  ["yamlls"] = yamlls_config,
  ["zls"] = zls_config,
}

lsp_setup.setup({
  default_mappings = false,
  mappings = {
    ["<C-]>"] = "lua vim.lsp.buf.definition()",                     -- ["<C-]>"] = "lua vim.lsp.buf.definition()",
    ["<C-k>"] = "<Cmd>Lspsaga signature_help<CR>",                  -- ["<C-k>"] = "lua vim.lsp.buf.signature_help()",
    ["<leader>e"] = "<Cmd>Lspsaga rename<CR>",                      -- ["<leader>e"] = "lua vim.lsp.buf.rename()",
    ["<LocalLeader>ca"] = "<Cmd>Lspsaga code_action<CR>",           -- ["<LocalLeader>ca"] = "lua vim.lsp.buf.code_action()",
    ["<LocalLeader>f"] = "lua vim.lsp.buf.format()",
    ["<LocalLeader>ge"] = "<Cmd>Lspsaga show_line_diagnostics<CR>", -- "Lspsaga rhow_cursor_diagnostics",
    ["<LocalLeader>gh"] = "<Cmd>Lspsaga lsp_finder<CR>",
    ["<LocalLeader>gi"] = "lua vim.lsp.buf.implementation()",
    ["<LocalLeader>gp"] = "<Cmd>Lspsaga peek_definition<CR>",
    ["<LocalLeader>gr"] = "lua vim.lsp.buf.references()",
    ["<LocalLeader>gt"] = "<Cmd>Lspsaga goto_type_definition<CR>", -- "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
    K = "<Cmd>Lspsaga hover_doc<CR>",                              -- "lua vim.lsp.buf.hover()",
  },
  on_attach = on_attach,
  capabilities = capabilities_config(),
  servers = servers,
  inlay_hints = {
    enabled = false,
    highlight = 'Comment',
  },
})

-- handlers

-- local vim_lsp_util_open_floating_preview = function(contents, syntax, opts, ...)
--   local _, winid = vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--   if winid == nil then
--     return
--   end
--
--   -- disable inherit `showbreak`, `breakindent` and `breakindentopt`
--   -- https://github.com/neovim/neovim/issues/20146
--   vim.api.nvim_win_set_option(winid, "breakindentopt", "")
--   vim.api.nvim_win_set_option(winid, "showbreak", "NONE")
--
--   -- disable Error highlight
--   vim.api.nvim_set_hl(0, "Error", { fg = "NONE" })
-- end
-- vim.lsp.util.open_floating_preview = vim_lsp_util_open_floating_preview

-- vim.api.nvim_create_autocmd( "WinLeave", {
--   pattern = "*",
--   callback = function (event)
--     if vim.api.nvim_win_get_config(winid).zindex then
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd("WinNew", {
--   pattern = { "*.c", "*.h" },
--   callback = function(ev)
--     if vim.api.nvim_win_get_config(0).zindex then
--       print(string.format("event fired: s", vim.inspect(ev)))
--     end
--   end,
-- })

-- local hover_handler = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = {
--     { "╭", "NormalFloat" },
--     { "─", "NormalFloat" },
--     { "╮", "NormalFloat" },
--     { "│", "NormalFloat" },
--     { "╯", "NormalFloat" },
--     { "─", "NormalFloat" },
--     { "╰", "NormalFloat" },
--     { "│", "NormalFloat" },
--   },
-- })
-- vim.lsp.handlers["textDocument/hover"] = hover_handler

-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/handlers.lua
-- Jump directly to the first available definition every time.
-- local definition_handler = function(_, result)
--   if not result or vim.tbl_isempty(result) then
--     print "[LSP] Could not find definition"
--     return
--   end
--
--   if vim.tbl_islist(result) then
--     vim.lsp.util.jump_to_location(result[1], "utf-8")
--   else
--     vim.lsp.util.jump_to_location(result, "utf-8")
--   end
-- end
-- vim.lsp.handlers["textDocument/definition"] = definition_handler

-- local publishDiagnostics_handler = vim.lsp.with(
--   require("vim.lsp.diagnostic").on_publish_diagnostics, {
--     underline = true,
--     virtual_text = {
--       spacing = 4,
--     },
--     signs = function(_, bufnr)
--       return vim.b[bufnr].show_signs == true
--     end,
--     update_in_insert = true,
--   }
-- )
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = publishDiagnostics_handler

-- init lspkind
lspkind.init()

vim.cmd([[
highlight! LspSignatureActiveParameter guifg=None    guibg=#343941 blend=5
highlight  LspInlayHint                guifg=#d8d8d8 guibg=#3a3a3a
]])
