local nvim_data = vim.fn.stdpath("data")

local installer_servers = require("nvim-lsp-installer.servers")
local installer_server = require("nvim-lsp-installer.server")
local installer_shell = require("nvim-lsp-installer.installers.shell")
local installer_path = require("nvim-lsp-installer.path")
local installer_npm = require("nvim-lsp-installer.installers.npm")

-- go
local gopls = installer_server.Server:new {
  name = "gopls",
  root_dir = nvim_data.."/lsp_servers/gopls",
  homepage = "https://pkg.go.dev/golang.org/x/tools/gopls",
  languages = { "go", "gomod", "gowork", "gotexttmpl" },
  installer = installer_shell.bash [[ true ]],
  default_options = {
    cmd = { "/Users/zchee/go/bin/gopls", "-remote=unix;/tmp/gopls.sock" },
    filetypes = { "go", "gomod", "gowork", "gotexttmpl" },
    settings = {
      env = {},
      buildFlags = {},
      directoryFilters = {
        "-asm",
        "-example",
        "-examples",
        "-sample",
        "-samples",
        "-node_modules",
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
      experimentalWorkspaceModule = false,
      templateExtensions = { "tmpl", "gotmpl", "tpl" },
      diagnosticsDelay = 0,
      experimentalWatchedFileDelay = "0",
      experimentalPackageCacheKey = true,
      allowModfileModifications = true,
      allowImplicitNetworkAccess = true,
      experimentalUseInvalidMetadata = false,
    }
  },
}
installer_servers.register(gopls)

-- clangd
local clangd = installer_server.Server:new {
  name = "clangd",
  languages = { "c", "c++" },
  root_dir = installer_servers.get_server_install_path("clangd"),
  homepage = "https://clangd.llvm.org",
  installer = installer_shell.bash [[ true ]],
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

-- sourcekit
local sourcekit = installer_server.Server:new {
  name = "sourcekit",
  languages = { "swift" },
  root_dir = installer_servers.get_server_install_path("sourcekit"),
  homepage = "https://github.com/apple/sourcekit-lsp",
  installer = installer_shell.bash [[ true ]],
  default_options = {
    cmd = { "xcrun", "--toolchain", "swift", "-r", "sourcekit-lsp", "--build-path=.build" },
    filetypes = { "swift" },
  },
}
installer_servers.register(sourcekit)

-- sumneko_lua
local sumneko_lua = installer_server.Server:new {
  name = "sumneko_lua",
  root_dir = installer_servers.get_server_install_path("sumneko_lua"),
  languages = { "lua" },
  homepage = "https://github.com/sumneko/lua-language-server",
  installer = installer_shell.bash [[
        git clone --depth 1 --single-branch --branch master https://github.com/sumneko/lua-language-server
        cd ./lua-language-server/3rd/luamake
        git submodule update --init --recursive
        ./compile/install.sh
        cd ../../
        ./3rd/luamake/luamake rebuild
        ]],
  default_options = {
    cmd = {
      installer_path.concat { installer_servers.get_server_install_path("sumneko_lua"), "lua-language-server", "bin", "lua-language-server" },
      "-E",
      installer_path.concat { installer_servers.get_server_install_path("sumneko_lua"), "lua-language-server", "main.lua" },
    },
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
      },
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
  installer = installer_shell.bash [[ true ]],
  default_options = {
    cmd = { "/usr/local/rust/rustup/toolchains/nightly-x86_64-apple-darwin/bin/rust-analyzer" },
  },
}
installer_servers.register(rust_analyzer)

-- tsserver
local tsserver = installer_server.Server:new {
  name = "tsserver",
  root_dir = installer_servers.get_server_install_path("tsserver"),
  languages = { "typescript", "javascript" },
  homepage = "https://github.com/typescript-language-server/typescript-language-server",
  installer = installer_npm.packages { "typescript-language-server@latest", "typescript@next" },
  default_options = {
    cmd_env = installer_npm.env(installer_servers.get_server_install_path("tsserver")),
  },
}
installer_servers.register(tsserver)

-- yamlls
local yamlls =  installer_server.Server:new {
  name = "yamlls",
  root_dir = installer_servers.get_server_install_path("yamlls"),
  languages = { "yaml" },
  homepage = "https://github.com/redhat-developer/yaml-language-server",
  installer = installer_npm.packages { "yaml-language-server@next" },
  default_options = {
    cmd_env = installer_npm.env(installer_servers.get_server_install_path("yamlls")),
    settings = {
      yaml = {
        yamlVersion = "1.2",
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
          [ "file:///Users/zchee/src/github.com/zchee/schema/appengine-app.schema.json" ] = {
            "app*.yaml"
          },
          [ "file:///Users/zchee/src/github.com/zchee/schema/circleci.schema.json" ] = {
            ".circleci/config.yml",
            -- "@orb.yml",
            -- "**/commands/*.yml",
            -- "**/examples/*.yml",
            -- "**/executors/*.yml",
            -- "**/jobs/*.yml"
          },
          -- [ "https://json.schemastore.org/circleciconfig" ] = {
          --   ".circleci/config.yml",
          -- },
          [ "file:///Users/zchee/src/github.com/zchee/schema/codecov.schema.json" ] = {
            ".codecov.yml"
          },
          [ "file:///Users/zchee/src/github.com/zchee/schema/kaitai-struct-compiler.schema.json" ] = {
            "*.ksy"
          },
          [ "file:///Users/zchee/src/github.com/zchee/schema/mkdocs.schema.json" ] = {
            "mkdocs.yml"
          },
          [ "file:///Users/zchee/src/github.com/zchee/schema/open-rpc.schema.json" ] = {
            "openrpc.yaml"
          },
          -- https
          [ "https://json.schemastore.org/appveyor.json" ] = {
            "*appveyor.yml"
          },
          [ "https://github.com/compose-spec/compose-spec/raw/master/schema/compose-spec.json" ] = {
            "*docker-compose*.yaml",
            "*docker-compose*.yml"
          },
          [ "https://github.com/microsoft/azure-pipelines-vscode/raw/main/service-schema.json" ] = {
            "azure-pipelines.yml"
          },
          [ "https://json.schemastore.org/dependabot-2.0.json" ] = {
            ".github/dependabot.yml"
          },
          [ "https://json.schemastore.org/cloudbuild" ] = {
            "*cloudbuild.yaml",
            "*cloudbuild.*.yaml"
          },
          [ "https://json.schemastore.org/compile-commands.json" ] = {
            "compile_commands.json"
          },
          [ "https://json.schemastore.org/kustomization.json" ] = {
            "kustomization.yaml",
            "kustomizeconfig.yaml"
          },
          [ "https://json.schemastore.org/github-issue-forms.json" ] = {
            ".github/ISSUE_TEMPLATE/*.yml"
          },
          [ "https://json.schemastore.org/github-issue-config.json" ] = {
            ".github/ISSUE_TEMPLATE/config.yml"
          },
          [ "https://json.schemastore.org/workflows.json" ] = {
            "cloudfunctions.workflow.yaml"
          },
          [ "https://json.schemastore.org/github-action.json" ] = {
            "action.yml"
          },
          [ "https://json.schemastore.org/github-workflow.json" ] = {
            "**/.github/workflows/*.yml"
          },
          [ "https://github.com/OAI/OpenAPI-Specification/raw/main/schemas/v3.1/schema.json" ] = {
            "*openapi.yaml",
            "**/openapi-spec/*.yaml",
          },
          [ "https://github.com/OAI/OpenAPI-Specification/raw/main/schemas/v2.0/schema.json" ] = {
            "*swagger.yaml",
            "**/swagger-spec/*.yaml"
          },
          [ "https://github.com/googleapis/gnostic/raw/master/discovery/discovery.json" ] = {
            "*discovery.yaml"
          },
          [ "https://github.com/GoogleContainerTools/skaffold/raw/main/docs/content/en/schemas/v2beta24.json" ] = {
            "skaffold*.yaml"
          },
          -- kubernetes
          [ "kubernetes" ] = {
            "kubernetes/*",
            "manifest.yaml",
            "statefulset.yaml",
            "daemonset.yaml",
            "deployment.yaml",
            "replicaset.yaml",
            "pod.yaml",
          },
          [ "file:///Users/zchee/go/src/github.com/kouzoh/kube-pubsub-operator/_kubernetes/kube-pubsub-operator-api/apis/v1alpha1/crd/delivery.platform.mercari.com_subscriptionreplicationconfigs.yaml" ] = {
            "kubernetes/*/subscription_replication_config.yaml",
            "_kubernetes/*/subscription_replication_config.yaml",
            "subscription_replication_config.yaml",
          },
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
  installer = installer_shell.bash [[ true ]],
  default_options = {
    cmd = { "/Users/zchee/go/bin/sqls" },
  }
}
installer_servers.register(sqls)

local asm_lsp_config = {
  filetypes = { "asm", "vmasm", "goasm" }
}
local bashls_config = {}
local clangd_config = {}

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
  filetypes = { "go", "gomod", "gotexttmpl" },
  on_init = function(client)
    local cwd = vim.fn.getcwd()

    local update_env = function()
      -- local envs = {
      --   [ "GOEXPERIMENT" ] = { "heapminimum512kib,pacerredesign,staticlockranking,unified" },
      -- }
      local envs = {}

      -- gvisor, moby/buildkit, zchee/go-cloud-debug-agent
      if string.find(cwd, "gvisor") or string.find(cwd, "buildkit") or string.find(cwd, "go-cloud-debug-agent") then
        envs = vim.tbl_deep_extend("keep", envs, {
          [ "GOOS" ] = { "linux" },
        })
      end
      -- go-clang/gen
      if string.find(cwd, "go%-clang/gen") then
        envs = vim.tbl_deep_extend("keep", envs, {
          [ "CGO_CFLAGS" ] = { "-Wno-deprecated-declarations" },
          [ "CGO_LDFLAGS" ] = { "-L/opt/llvm/13/lib -Wl,%-rpath,/opt/llvm/13/lib" },
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
            vim.fn.getcwd().."/third_party",
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

local path = require("nvim-lsp-installer.path")
local servers = require("nvim-lsp-installer.servers")
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua")
-- table.insert(runtime_path, "lua/?.lua")
-- table.insert(runtime_path, "lua/?/init.lua")
local sumneko_config = require("lua-dev").setup({
  library = {
    vimruntime = true,
    types = true,
    plugins = true,
  },
  lspconfig = {
    cmd = {
      path.concat { servers.get_server_install_path("sumneko_lua"), "lua-language-server", "bin", "lua-language-server" },
      "-E",
      path.concat { servers.get_server_install_path("sumneko_lua"), "lua-language-server", "main.lua" },
    },
    -- https://github.com/sumneko/lua-language-server/blob/master/script/config/config.lua
    settings = {
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
        workspace = {
          maxPreload = 10000,
          preloadFileSize = 10000,
          library = vim.api.nvim_get_runtime_file("", true),
        },
        completion = {
          enable = true,
        },
        hint = {
          enable = true,
        },
        telemetry = {
          enable = true,
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

local solargraph_config = {}
local rust_analyzer_config = {}
local tsserver_config = {}
local sourcekit_config = {}
local terraformls_config = {}
local yamlls_config = {}

-- on_attach
local on_attach_mappings = function()
  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(0, "n", "<Leader>e", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<Leader>e", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
end
local on_attach_mapping_go = function()
  local opts = { noremap = true, silent = true }

  -- vim.api.nvim_buf_set_keymap(0, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<C-]>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<LocalLeader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(0, "n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  vim.api.nvim_buf_set_keymap(0, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local on_attach = function()
  on_attach_mappings()
end

-- config that activates keymaps and enables snippet support
local function make_config()
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- local capabilities = require("coq").lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities())
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = false

  return {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

local function setup_servers()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.on_server_ready(function(server)
    local config = make_config()

    if server.name == "asm_lsp" then
      -- config.filetypes = asm_lsp_config.filetypes
      config = vim.tbl_deep_extend("keep", config, asm_lsp_config)
    end
    if server.name == "cmake" then
      config.on_init = cmake_config.on_init
    end
    if server.name == "eslint" then
      config.autostart = eslint_config.autostart
    end
    if server.name == "denols" then
      config.autostart = denols_config.autostart
    end
    if server.name == "dockerls" then
      config.root_dir = dockerls_config.root_dir
      config.on_init = dockerls_config.on_init
    end
    if server.name == "gopls" then
      -- config.filetypes = gopls_config.filetypes
      -- config.on_init = gopls_config.on_init
      config = vim.tbl_deep_extend("keep", config, gopls_config)
    end
    if server.name == "sumneko_lua" then
      config = vim.tbl_deep_extend("keep", config, sumneko_config)
    end
    if server.name == "spectral" then
      config.autostart = spectral_config.autostart
    end
    if server.name == "pyright" then
      config.on_init = pyright_config.on_init
    end

    server:setup(config)
    server:on_ready(config.on_attach)
  end)
end

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
--
-- Jump directly to the first available definition every time.
-- vim.lsp.handlers["textDocument/definition"] = function(_, result)
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
    signs = {
      severity_limit = "Error",
    },
    underline = {
      severity_limit = "Warning",
    },
    virtual_text = true,
  })

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
highlight! LspSignatureActiveParameter guifg=None guibg=#343941 blend=5
]])
local lsp_signature_cfg = {
  debug = false, -- set to true to enable debug logging
  log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
  verbose = false, -- show debug line number
  bind = true, -- This is mandatory, otherwise border config won't get registered. If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10,
  floating_window = true,
  floating_window_above_cur_line = true,
  floating_window_off_x = 1, -- adjust float windows x position.
  floating_window_off_y = 1, -- adjust float windows y position.
  fix_pos = true,
  hint_enable = true,
  hint_prefix = " ",
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter",
  max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
  max_width = 200, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "rounded"   -- double, rounded, single, shadow, none
  },
  always_trigger = true, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 100, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}
require("lsp_signature").setup(lsp_signature_cfg)

setup_servers()
