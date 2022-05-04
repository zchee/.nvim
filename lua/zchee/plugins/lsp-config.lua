local nvim_data = vim.fn.stdpath("data")
local xdg_config_home = vim.fn.resolve(vim.fn.expand('$XDG_CONFIG_HOME'))

local packer_util = require("packer.util")

local installer_servers = require("nvim-lsp-installer.servers")
local installer_server = require("nvim-lsp-installer.server")
local installer_process = require("nvim-lsp-installer.process")
local installer_path = require("nvim-lsp-installer.path")
local installer_cargo = require("nvim-lsp-installer.core.managers.cargo")
local installer_npm = require("nvim-lsp-installer.core.managers.npm")

local function path_join(...)
  return table.concat(vim.tbl_flatten({ ... }), "/")
end

-- go
local gopls = installer_server.Server:new {
  name = "gopls",
  root_dir = nvim_data .. "/lsp_servers/gopls",
  homepage = "https://pkg.go.dev/golang.org/x/tools/gopls",
  languages = { "go", "gomod", "gowork", "gotexttmpl" },
  async = true,
  installer = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end,
  default_options = {
    cmd = { "/Users/zchee/go/bin/gopls", "-remote=unix;/tmp/gopls.sock" },  -- cmd = { "/Users/zchee/go/bin/gopls", "serve" },
    filetypes = { "go", "gomod", "gowork", "gotexttmpl" },
  },
}
installer_servers.register(gopls)

-- clangd
local clangd = installer_server.Server:new {
  name = "clangd",
  languages = { "c", "cpp" },
  root_dir = installer_servers.get_server_install_path("clangd"),
  homepage = "https://clangd.llvm.org",
  async = true,
  installer = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end,
  default_options = {
    cmd = {
      "/opt/llvm/clangd/devel/bin/clangd",
      "--all-scopes-completion",
      "--completion-parse=always",
      "--completion-style=detailed",
      "--header-insertion-decorators",
      "--header-insertion=iwyu",
      "--index",
      "--enable-config",
      "--folding-ranges",
      "--use-dirty-headers",
      "--include-ineligible-results",
      "--offset-encoding=utf-16",
      "--input-style=standard",
      "--resource-dir=/opt/llvm/devel/lib/clang/15.0.0",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
  },
}
installer_servers.register(clangd)

-- taplo
local taplo = installer_server.Server:new {
  name = "taplo",
  languages = { "toml" },
  root_dir = installer_servers.get_server_install_path("taplo"),
  async = true,
  installer = function(ctx)
    ctx.spawn.bash {
      "-c", [[ cargo install --root . --locked --jobs=40 --force --verbose --git https://github.com/tamasfe/taplo taplo-cli ]]
    }
  end,
  default_options = {
    cmd_env = installer_cargo.env(installer_servers.get_server_install_path("taplo")),
  },
}
installer_servers.register(taplo)

-- sourcekit
local sourcekit = installer_server.Server:new {
  name = "sourcekit",
  languages = { "swift" },
  root_dir = installer_servers.get_server_install_path("sourcekit"),
  homepage = "https://github.com/apple/sourcekit-lsp",
  async = true,
  installer = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end,
  default_options = {
    cmd = { "xcrun", "--toolchain", "swift", "-r", "sourcekit-lsp", "-c", "release" },
    filetypes = { "swift" },
    offset_encoding = "utf-8",
  },
}
installer_servers.register(sourcekit)

local sumneko_lua = installer_server.Server:new {
  name = "sumneko_lua",
  root_dir = installer_servers.get_server_install_path("sumneko_lua"),
  languages = { "lua" },
  async = true,
  homepage = "https://github.com/sumneko/lua-language-server",
  installer = function(ctx)
    ctx.spawn.bash {
      "-c", [[
        git clone --depth 1 --single-branch --branch master https://github.com/sumneko/lua-language-server
        cd ./lua-language-server/3rd/luamake
        git submodule update --init --recursive
        ./compile/install.sh
        cd ../../
        ./3rd/luamake/luamake rebuild
      ]]
    }
  end,
  default_options = {
    cmd = {
      installer_path.concat { installer_servers.get_server_install_path("sumneko_lua"), "lua-language-server", "bin", "lua-language-server" },
      "-E",
      installer_path.concat { installer_servers.get_server_install_path("sumneko_lua"), "lua-language-server", "main.lua" },
    },
  },
}
installer_servers.register(sumneko_lua)

-- rust_analyzer
local rust_analyzer = installer_server.Server:new {
  name = "rust_analyzer",
  root_dir = installer_servers.get_server_install_path("rust_analyzer"),
  languages = { "rust" },
  homepage = "https://rust-analyzer.github.io",
  async = true,
  installer = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end,
  default_options = {
    cmd = { "/usr/local/rust/rustup/toolchains/nightly-x86_64-apple-darwin/bin/rust-analyzer" },
  },
}
installer_servers.register(rust_analyzer)

local terraformls = installer_server.Server:new {
  name = "terraformls",
  root_dir = installer_servers.get_server_install_path("terraformls"),
  homepage = "https://github.com/hashicorp/terraform-ls",
  languages = { "terraform" },
  async = true,
  installer = function(ctx)
    ctx.spawn.go {
      "install", "-v", "-x", "-trimpath", "-tags=osusergo,netgo,static", "-buildmode=pie", ("-ldflags=-s -w -linkmode external -buildid= %s"):format('"-extldflags=-static-pie"'), "github.com/hashicorp/terraform-ls@main",
      env = {
        GOBIN = ctx.cwd:get(),
        CGO_ENABLED = 0,
      },
    }
  end,
  default_options = {
    cmd_env = {
      PATH = installer_process.extend_path { installer_path.concat { installer_servers.get_server_install_path("terraformls"), "terraform-ls" } },
    },
  },
}
installer_servers.register(terraformls)

-- tsserver
local tsserver = installer_server.Server:new {
  name = "tsserver",
  root_dir = installer_servers.get_server_install_path("tsserver"),
  languages = { "typescript", "javascript" },
  homepage = "https://github.com/typescript-language-server/typescript-language-server",
  async = true,
  installer = installer_npm.packages { "typescript-language-server@latest", "typescript@next" },
  default_options = {
    cmd_env = installer_npm.env(installer_servers.get_server_install_path("tsserver")),
  },
}
installer_servers.register(tsserver)

-- yamlls
local yamlls = installer_server.Server:new {
  name = "yamlls",
  root_dir = installer_servers.get_server_install_path("yamlls"),
  languages = { "yaml" },
  homepage = "https://github.com/redhat-developer/yaml-language-server",
  async = true,
  installer = installer_npm.packages { "yaml-language-server@next" },
  default_options = {
    cmd_env = installer_npm.env(installer_servers.get_server_install_path("yamlls")),
    settings = {
      yaml = {
        yamlVersion = 1.2,
        format = {
          enable = true,
          singleQuote = false,
          bracketSpacing = true,
          printWidth = 150,
        },
        validate = true,
        hover = true,
        completion = true,
        -- customTags = {
        --   "!!python/name scalar",
        --   "!Seq-example sequence",
        --   "!Mapping-example mapping"
        -- },
        schemas = {
          -- local
          -- [ "file:///Users/zchee/src/github.com/zchee/schema/appengine-app.schema.json" ] = {
          --   "app*.yaml"
          -- },
          -- [ "file:///Users/zchee/src/github.com/zchee/schema/circleci.schema.json" ] = {
          --   ".circleci/config.yml",
          --   -- "@orb.yml",
          --   -- "**/commands/*.yml",
          --   -- "**/examples/*.yml",
          --   -- "**/executors/*.yml",
          --   -- "**/jobs/*.yml"
          -- },
          ["file:///Users/zchee/src/github.com/zchee/schema/clangd.schema.json"] = {
            ".clangd",
            path_join(xdg_config_home, "clangd/config.yaml"),
          },
          ["file:///Users/zchee/src/github.com/zchee/schema/codecov.schema.json"] = {
            ".codecov.yml"
          },
          ["file:///Users/zchee/src/github.com/zchee/schema/kaitai-struct-compiler.schema.json"] = {
            "*.ksy"
          },
          ["file:///Users/zchee/src/github.com/zchee/schema/mkdocs.schema.json"] = {
            "mkdocs.yml"
          },
          ["file:///Users/zchee/src/github.com/zchee/schema/open-rpc.schema.json"] = {
            "openrpc.yaml"
          },
          -- https
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/clang-format.json"] = {
            ".clang-format",
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/circleciconfig.json"] = {
            ".circleci/config.yml",
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/appveyor.json"] = {
            "*appveyor.yml"
          },
          ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
            "*docker-compose*.yaml",
            "*docker-compose*.yml"
          },
          ["https://github.com/microsoft/azure-pipelines-vscode/raw/main/service-schema.json"] = {
            "azure-pipelines.yml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/dependabot-2.0.json"] = {
            ".github/dependabot.yml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/cloudbuild.json"] = {
            "*cloudbuild.yaml",
            "*cloudbuild.*.yaml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/compile-commands.json"] = {
            "compile_commands.json"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/kustomization.json"] = {
            "kustomization.yaml",
            "kustomizeconfig.yaml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-issue-forms.json"] = {
            ".github/ISSUE_TEMPLATE/*.yml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-issue-config.json"] = {
            ".github/ISSUE_TEMPLATE/config.yml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/workflows.json"] = {
            "cloudfunctions.workflow.yaml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-action.json"] = {
            "action.yml"
          },
          ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/github-workflow.json"] = {
            "**/.github/workflows/*.yml"
          },
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = {
            "*openapi.yaml",
            "**/openapi-spec/*.yaml",
          },
          ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v2.0/schema.json"] = {
            "*swagger.yaml",
            "**/swagger-spec/*.yaml"
          },
          ["https://raw.githubusercontent.com/googleapis/gnostic/master/discovery/discovery.json"] = {
            "*discovery.yaml"
          },
          ["https://raw.githubusercontent.com/GoogleContainerTools/skaffold/main/docs/content/en/schemas/v2beta28.json"] = {
            "skaffold*.yaml"
          },
          -- kubernetes
          ["kubernetes"] = {
            "kubernetes/*",
            "manifest.yaml",
            "statefulset.yaml",
            "daemonset.yaml",
            "deployment.yaml",
            "replicaset.yaml",
            "pod.yaml",
          },
          -- [ "file:///Users/zchee/go/src/github.com/kouzoh/kube-pubsub-operator/_kubernetes/kube-pubsub-operator-api/apis/v1alpha1/crd/delivery.platform.mercari.com_subscriptionreplicationconfigs.yaml" ] = {
          --   "kubernetes/*/subscription_replication_config.yaml",
          --   "_kubernetes/*/subscription_replication_config.yaml",
          --   "subscription_replication_config.yaml",
          -- },
        }
      }
    }
  }
}
installer_servers.register(yamlls)

-- sqls
local sqls = installer_server.Server:new {
  name = "sqls",
  root_dir = installer_servers.get_server_install_path("sqls"),
  languages = { "sql" },
  homepage = "https://github.com/lighttiger2505/sqls",
  async = true,
  installer = function(ctx)
    ctx.spawn.bash { "-c", "true" }
  end,
  default_options = {
    cmd = { "/Users/zchee/go/bin/sqls" },
  }
}
installer_servers.register(sqls)

local asm_lsp_config = {
  languages = {
    "asm",
    "goasm",
    "vmasm",
  },
  filetypes = {
    "asm",
    "goasm",
    "vmasm",
  }
}

local grammarly_config = {
  filetypes = {
    "markdown",
  },
}

-- local bashls_config = {}
-- local clangd_config = {}

local cmake_config = {
  on_init = function(client)
    client.config.settings = {
      cmake = {
        buildDirectory = "build",
      }
    }

    client.notify("workspace/didChangeConfiguration")
    return true
  end
}

local denols_config = {
  autostart = false,
}

local dockerls_config = {
  root_dir = require("lspconfig.util").root_pattern("Dockerfile", "*.dockerfile", "Dockerfile.*"),
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
          }
        }
      }
    }

    client.notify("workspace/didChangeConfiguration")
    return true
  end
}

local eslint_config = {
  autostart = false,
}

local spectral_config = {
  autostart = false,
}

local jsonls_config = {
  on_init = function(client)
    client.config.settings = {
      json = {
        format = {
          enable = true,
        },
        maxItemsComputed = 100000,
        schemas = vim.list_extend(
          {
            {
              url = "https://github.com/OAI/OpenAPI-Specification/raw/main/schemas/v2.0/schema.json",
              fileMatch = {
                "swagger.json",
                "**/swagger-spec/*.json"
              },
            },
            {
              url = "https://github.com/OAI/OpenAPI-Specification/raw/main/schemas/v3.1/schema.json",
              fileMatch = {
                "swagger.json",
                "**/swagger-spec/*.json"
              },
            },
            {
              url = "file:///Users/zchee/src/github.com/zchee/schema/jsonschema-draft-07.schema.json",
              fileMatch = {
                "circleci.schema.json",
              },
            },
          },
          require('schemastore').json.schemas {
            select = {
              "package.json",
              "tsconfig.json",
              "renovate.json",
              "compile-commands.json",
            },
          }
        ),
      }
    }

    client.notify("workspace/didChangeConfiguration")
    return true
  end
}

local gopls_config = {
  settings = {
    env = {
    },
    buildFlags = {
    },
    directoryFilters = {
      "-asm",  -- mmcloughlin/avo
      "-example",
      "-examples",
      "-sample",
      "-samples",
      "-node_modules",
      "-rtloader",  -- bytedance/sonic
    },
    memoryMode = "normal",
    completionDocumentation = true,
    usePlaceholders = true,
    deepCompletion = true,
    completeUnimported = true,
    completionBudget = "100ms",
    matcher = "fuzzy",
    symbolMatcher = "fastfuzzy",
    symbolStyle = "dynamic",
    hoverKind = "fulldocumentation",
    linkTarget = "",
    linksInHover = false,
    importShortcut = "both",
    analyses = {
      fieldalignment = true,
      nilness = true,
      shadow = true,
      unsafeptr = false,
      unusedparams = true,
      unusedwrite = true,
      useany = true,
    },
    annotations = {
      bounds = true,
      escape = true,
      inline = true,
      ["nil"] = true,
    },
    codelenses = {
      add_dependency = true,
      add_import = true,
      apply_fix = true,
      check_upgrades = true,
      gc_details = true,
      generate = true,
      generate_gopls_mod = true,
      go_get_package = true,
      list_known_packages = true,
      regenerate_cgo = true,
      remove_dependency = true,
      run_tests = true,
      start_debugging = true,
      test = true,
      tidy = true,
      toggle_gc_details = true,
      update_go_sum = true,
      upgrade_dependency = true,
      vendor = true,
      workspace_metadata = true,
      extract_function = true,
      extract_variable = true,
      fill_struct = true,
      undeclared_name = true,
    },
    staticcheck = true,
    verboseOutput = false,
    verboseWorkDoneProgress = false,
    tempModfile = true,
    gofumpt = true,
    semanticTokens = true,
    expandWorkspaceToModule = true,
    experimentalPostfixCompletions = true,
    experimentalWorkspaceModule = true,
    templateExtensions = { "tmpl", "gotmpl", "tpl" },
    diagnosticsDelay = "0",
    experimentalWatchedFileDelay = "0",
    experimentalPackageCacheKey = true,
    allowModfileModifications = true,
    allowImplicitNetworkAccess = true,
    experimentalUseInvalidMetadata = true,
  },
  filetypes = { "go", "gomod", "gotexttmpl" },
  on_attach = function(client)
    local cwd = vim.fn.getcwd()

    local update_env = function()
      local envs = {}

      -- gvisor, moby/buildkit, zchee/go-cloud-debug-agent
      if string.find(cwd, "gvisor") or string.find(cwd, "buildkit") or string.find(cwd, "go-cloud-debug-agent") then
        envs = vim.tbl_deep_extend("keep", envs, {
          ["GOOS"] = { "linux" },
        })
      end
      -- go-clang/gen
      if string.find(cwd, "go%-clang/gen") then
        envs = vim.tbl_deep_extend("keep", envs, {
          ["CGO_CFLAGS"] = { "-Wno-deprecated-declarations" },
          ["CGO_LDFLAGS"] = { "-L/opt/llvm/13/lib -Wl,%-rpath,/opt/llvm/13/lib" },
        })
      end

      return envs
    end

    local update_buildFlags = function()
      local flags = {}
      if string.find(cwd, "gvisor") or string.find(cwd, "buildkit") or string.find(cwd, "go-cloud-debug-agent") then
        flags = vim.tbl_deep_extend("keep", flags, { "%-tags=linux" })
      end
      return flags
    end

    client.config.settings.env = update_env()
    client.config.settings.buildFlags = update_buildFlags()

    client.notify("workspace/didChangeConfiguration")
    return true
  end
}

-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
-- https://github.com/microsoft/pyright/blob/main/packages/vscode-pyright/package.json
local pyright_config = {
  on_init = function(client)
    client.config.settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          extraPaths = {
            "/usr/local/google-cloud-sdk/lib",
            "/usr/local/google-cloud-sdk/lib/third_party",
            vim.fn.getcwd() .. "/third_party",
          },
          typeCheckingMode = "basic",
          useLibraryCodeForTypes = false,
        },
        pythonPath = vim.g.python3_host_prog,
      }
    }

    client.notify("workspace/didChangeConfiguration")
    return true
  end
}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local sumneko_config = require("lua-dev").setup({
  library = {
    vimruntime = true,
    types = true,
    plugins = true,
  },
  lspconfig = {
    cmd = {
      installer_path.concat { installer_servers.get_server_install_path("sumneko_lua"), "lua-language-server", "bin", "lua-language-server" },
      "-E",
      installer_path.concat { installer_servers.get_server_install_path("sumneko_lua"), "lua-language-server", "main.lua" },
    },
    on_attach = function(client, _)
      -- Avoiding LSP formatting conflicts.
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
    end,
    -- https://github.com/sumneko/lua-language-server/blob/master/script/config/config.lua
    settings = {
      -- https://github.com/sumneko/lua-language-server/blob/master/script/config/config.lua
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
          unicodeName = true,
        },
        diagnostics = {
          enable = true,
          disable = {
            "trailing-space",
          },
          globals = {
            "vim",  -- Neovim
            "describe", "it", "before_each", "after_each", "teardown", "pending", "clear",  -- Busted
          }
        },
        -- workspace = {
        --   maxPreload = 10000,
        --   preloadFileSize = 10000,
        --   -- library = vim.api.nvim_get_runtime_file("", true),
        -- },
        workspace = {
          maxPreload = 10000,
          preloadFileSize = 10000,
          library = {
            path_join(os.getenv("VIMRUNTIME"), "lua"),
            path_join(vim.fn.stdpath("data"), "/site/pack/packer"),
          },
        },
        completion = {
          enable = true,
        },
        hint = {
          enable = true,
        },
        telemetry = {
          enable = false,
        },
      },
      editor = {
        semanticHighlighting = {
          enabled = true,
        },
      },
    }
  },
})

local solargraph_config = {
  on_init = function(client)
    client.config.settings = {
      solargraph = {
        autoformat      = false,
        bundlerPath     = "vendor/bundle",
        checkGemVersion = false,
        commandPath     = path_join(installer_servers.get_server_install_path("solargraph"), "bin", "solargraph"),
        completion      = true,
        definitions     = true,
        diagnostics     = true,
        -- externalServer = {},
        folding         = true,
        formatting      = false,
        hover           = true,
        logLevel        = "warn",
        references      = true,
        rename          = true,
        symbols         = true,
        transport       = "stdio",
        useBundler      = true,
      }
    }

    client.notify("workspace/didChangeConfiguration")
    return true
  end
}

local clangd_config = {}
local rust_analyzer_config = {}
local tsserver_config = {}
local sourcekit_config = {}
local terraformls_config = {}
local yamlls_config = {}

-- on_attach
local function register_mappings()
  local function set_keymap(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end

  local opts = { noremap = true, silent = true }

  set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- set_keymap("n", "<leader>e", "<cmd>Lspsaga rename<CR>", opts)
  set_keymap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
  set_keymap("n", "<LocalLeader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  set_keymap("n", "<LocalLeader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  -- set_keymap("n", "<LocalLeader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  set_keymap("n", "<LocalLeader>ca", "<cmd>Lspsaga code_action<cr>", opts)
  set_keymap("x", "<LocalLeader>ca", ":<c-u>Lspsaga range_code_action<cr>", opts)
  set_keymap("n", "<LocalLeader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  set_keymap("n", "ge", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
  set_keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
  set_keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
end

-- local register_mapping_go = function()
--   local function set_keymap(mode, lhs, rhs, opts)
--     vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
--   end
-- 
--   local opts = { noremap = true, silent = true }
-- 
--   if vim.fn.eval('&filetype') == 'go' then
--     set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--     set_keymap('n', '<C-]>', '<Plug>(nvim-lsp-textdocument-definition)', { silent = true })
--     set_keymap('n', 'K', '<Plug>(nvim-lsp-textdocument-hover)', { silent = true })
--     set_keymap('n', '<LocalLeader>gi', '<Plug>(nvim-lsp-textdocument-implementation)', { silent = true })
--     set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--     set_keymap('n', '<LocalLeader>gc', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--     set_keymap('n', '<LocalLeader>gr', '<Plug>(nvim-lsp-textdocument-references)', { silent = true })
--     set_keymap('n', '<LocalLeader>gs', '<Plug>(nvim-lsp-textdocument-symbol)', { silent = true })
--     set_keymap('n', '<LocalLeader>gt', '<Plug>(nvim-lsp-textdocument-typedefinition)', { silent = true })
--   else
--     set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--     set_keymap("n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--     set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
--     set_keymap("n", "<LocalLeader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--     set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
--     set_keymap("n", "<LocalLeader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
--     set_keymap("n", "<LocalLeader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
--     set_keymap("n", "<LocalLeader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
--     set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
--     set_keymap("n", "<Leader>e", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--   end
-- end

local on_attach = function(client, _)
  require("illuminate").on_attach(client)
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem.snippetSupport = false
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true

  return {
    capabilities = capabilities,
  }
end

local function setup_servers()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.on_server_ready(function(server)
    local config = make_config()

    register_mappings()

    if server.name == "asm_lsp" then
      config = packer_util.deep_extend('keep', config, asm_lsp_config)
    end
    if server.name == "cmake" then
      config = packer_util.deep_extend('keep', config, cmake_config)
    end
    if server.name == "denols" then
      config = packer_util.deep_extend('keep', config, denols_config)
    end
    if server.name == "dockerls" then
      config = packer_util.deep_extend('keep', config, dockerls_config)
    end
    if server.name == "grammarly" then
      config = packer_util.deep_extend('keep', config, grammarly_config)
    end
    if server.name == "pyright" then
      config = packer_util.deep_extend('keep', config, pyright_config)
    end
    if server.name == "solargraph" then
      config = packer_util.deep_extend('keep', config, solargraph_config)
    end
    if server.name == "yamlls" then
      config = packer_util.deep_extend('keep', config, yamlls_config)
    end

    config.on_attach = function(client, bufnr)
      on_attach(client, bufnr)
    end

    -- server:setup(config)
    -- server:on_ready(config.on_attach)
  end)
end
-- setup_servers()

local bufmap = function(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
end

bufmap("x", "gx", ":<c-u>Lspsaga range_code_action<cr>", { silent = true, noremap = true })
local nvim_lsp_setup = require("nvim-lsp-setup")
nvim_lsp_setup.setup({
  default_mappings = false,
  mappings = {
    ["<leader>e"] = "Lspsaga rename",
    ["<C-]>"] = "lua vim.lsp.buf.definition()",
    -- K = "lua vim.lsp.buf.hover()",
    K = "Lspsaga hover_doc",
    ["<LocalLeader>gi"] = "lua vim.lsp.buf.implementation()",
    ["<C-k>"] = "lua vim.lsp.buf.signature_help()",
    ["<LocalLeader>gt"] = "lua vim.lsp.buf.type_definition()",
    -- ["<LocalLeader>ca"] = "lua vim.lsp.buf.code_action()",
    ["<LocalLeader>gx"] = "Lspsaga code_action<cr>",
    -- ["<LocalLeader>ca"] = "Lspsaga range_code_action",
    ["<LocalLeader>gr"] = "lua vim.lsp.buf.references()",
    ["<Leader>f"] = "<cmd>lua vim.lsp.buf.formatting()",
    ge = "Lspsaga show_line_diagnostics",
    ["[d"] = "Lspsaga diagnostic_jump_next",
    ["]d"] = "Lspsaga diagnostic_jump_prev",
  },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  on_attach = function(client, bufnr)
    _ = client
    _ = bufnr
  end,
  servers = {
    asm_lsp = asm_lsp_config,
    clangd = clangd_config,
    gopls = gopls_config,
    sourcekit = {},
    sumneko_lua = sumneko_config,
  },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
  border = {
    { "╭", "NormalFloat" },
    { "─", "NormalFloat" },
    { "╮", "NormalFloat" },
    { "│", "NormalFloat" },
    { "╯", "NormalFloat" },
    { "─", "NormalFloat" },
    { "╰", "NormalFloat" },
    { "│", "NormalFloat" },
  },
}
)

-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/handlers.lua

-- Jump directly to the first available definition every time.
vim.lsp.handlers["textDocument/definition"] = function(_, result)
  if not result or vim.tbl_isempty(result) then
    print "[LSP] Could not find definition"
    return
  end

  if vim.tbl_islist(result) then
    vim.lsp.util.jump_to_location(result[1], "utf-8")
  else
    vim.lsp.util.jump_to_location(result, "utf-8")
  end
end

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
--   signs = {
--     severity_limit = "Error",
--   },
--   underline = {
--     severity_limit = "Warning",
--   },
--   virtual_text = true,
-- })

-- local show_message = function()
--   local protocol = require "vim.lsp.protocol"
--
--   _LspMessageBuffer = _LspMessageBuffer or vim.api.nvim_create_buf(false, true)
--
--   local bufnr = _LspMessageBuffer
--   local border = {
--     { "🭽", "FloatBorder" },
--     { "▔", "FloatBorder" },
--     { "🭾", "FloatBorder" },
--     { "▕", "FloatBorder" },
--     { "🭿", "FloatBorder" },
--     { "▁", "FloatBorder" },
--     { "🭼", "FloatBorder" },
--     { "▏", "FloatBorder" },
--   }
--
--   local create_little_window = function(messages)
--     local msg_lines = #messages
--
--     local msg_width = 0
--     for _, v in ipairs(messages) do
--       msg_width = math.max(msg_width, #v + 1)
--     end
--
--     local ui = vim.api.nvim_list_uis()[1]
--     local ui_width = ui.width
--
--     local win_height = math.min(50, msg_lines)
--     local win_width = math.min(150, msg_width) + 5
--
--     return vim.api.nvim_open_win(bufnr, false, {
--       relative = "editor",
--       style = "minimal",
--       height = win_height,
--       width = win_width,
--       -- row = ui_height - win_height - 10,
--       row = 1,
--       col = ui_width - win_width - 2,
--       border = border,
--     })
--   end
--
--   -- TODO: map this to a keybind :)
--   function LspShowMessageBuffer()
--     vim.cmd [[new]]
--     vim.cmd([[buffer ]] .. _LspMessageBuffer)
--   end
--
--   return function(_, result, ctx)
--     local client_id = ctx.client_id
--
--     local message_type = result.type
--     local client_message = result.message
--     local client = vim.lsp.get_client_by_id(client_id)
--     local client_name = client and client.name or string.format("id=%d", client_id)
--
--     local messages = {}
--
--     if not client then
--       error(string.format("LSP[%s] client has shut down after sending the message", client_name))
--     end
--     if message_type == protocol.MessageType.Error then
--       error(string.format("LSP[%s] %s", client_name, client_message))
--     else
--       local message_type_name = protocol.MessageType[message_type]
--       table.insert(messages, string.format("LSP %s %s", client_name, message_type_name))
--       for index, text in ipairs(vim.split(client_message, "\n")) do
--         table.insert(messages, "  " .. text .. "  ")
--       end
--     end
--
--     vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, messages)
--
--     local win_id = create_little_window(messages)
--     vim.cmd(string.format(
--       [[
--       autocmd CursorMoved * ++once :call nvim_win_close(%s, v:true)
--     ]],
--       win_id
--     ))
--
--     return result
--   end
-- end
-- vim.lsp.handlers["window/showMessage"] = show_message

-- local M = {}
--
-- M.implementation = function()
--   local params = vim.lsp.util.make_position_params()
--
--   vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
--     local bufnr = ctx.bufnr
--     local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
--
--     -- In go code, I do not like to see any mocks for impls
--     if ft == "go" then
--       local new_result = vim.tbl_filter(function(v)
--         return not string.find(v.uri, "mock_")
--       end, result)
--
--       if #new_result > 0 then
--         result = new_result
--       end
--     end
--
--     vim.lsp.handlers["textDocument/implementation"](err, result, ctx, config)
--     vim.cmd [[normal! zz]]
--   end)
-- end

vim.lsp.codelens.display = require("gl.codelens").display

-- local lspconfig = require("lspconfig")
-- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config,
-- {
--     -- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/handlers.lua
--     handlers = {
--       ["textDocument/hover"] =
--       ["window/logMessage"] = function(err, method, params, client_id)
--         if params and params.type <= vim.lsp.protocol.MessageType.Log then
--           vim.lsp.handlers["window/logMessage"](err, method, params, client_id)
--         end
--       end;
--       ["window/showMessage"] = function(err, method, params, client_id)
--         if params and params.type <= vim.lsp.protocol.MessageType.Warning.Error then
--           vim.lsp.handlers["window/showMessage"](err, method, params, client_id)
--         end
--       end;
--     }
--   }
-- )

-- return M

vim.cmd([[
  highlight! LspSignatureActiveParameter guifg=None guibg=#343941 blend=5"
]])
-- local lsp_signature_cfg = {
--   bind = true,
--   doc_lines = 30,
--   max_height = 12,
--   max_width = 200,
--   floating_window = true,
--   floating_window_above_cur_line = true,
--   floating_window_off_x = 1,
--   floating_window_off_y = 1,
--   close_timeout = 4000,
--   fix_pos = function(_, _)  -- (signatures, client)
--     return true  -- can be expression like : return signatures[1].activeParameter >= 0 and signatures[1].parameters > 1
--   end,
--   hint_enable = true,
--   hint_prefix = "",
--   hint_scheme = "String",
--   hi_parameter = "LspSignatureActiveParameter",
--   handler_opts = {
--     border = {
--       { "╭", "NormalFloat" },
--       { "─", "NormalFloat" },
--       { "╮", "NormalFloat" },
--       { "│", "NormalFloat" },
--       { "╯", "NormalFloat" },
--       { "─", "NormalFloat" },
--       { "╰", "NormalFloat" },
--       { "│", "NormalFloat" },
--     },
--   },
--   padding = "",
--   always_trigger = false,
--   auto_close_after = nil,
--   check_completion_visible = true,
--   debug = false,
--   log_path = path_join(vim.fn.stdpath("cache"), "lsp_signature.log"),
--   verbose = false,
--   extra_trigger_chars = {},
--   -- decorator = {"`", "`"} -- set to nil if using guihua.lua
--   zindex = 200,
--   transparency = nil,
--   shadow_blend = 36,
--   shadow_guibg = "Black",
--   timer_interval = 100,  -- default: 200
--   toggle_key = nil,
--   check_3rd_handler = nil,
-- }
-- require("lsp_signature").setup(lsp_signature_cfg)
