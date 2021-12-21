local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PackerBootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local gopath = fn.expand('~/go/src/github.com')
local src = fn.expand('~/src/github.com')

vim.api.nvim_exec([[ packadd packer.nvim ]], false)
vim.api.nvim_exec([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]], false)

local packer = require("packer")
local packer_util = require("packer.util")

packer.init {
  package_root = packer_util.join_paths(vim.fn.stdpath('data'), 'site', 'pack'),
  compile_path = packer_util.join_paths(vim.fn.stdpath('config'), 'plugin', 'packer_compiled.lua'),
}

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  -- local
    -- use {
    --   gopath..'/zchee/nvim-lsp',
    -- }
    use {
      gopath..'/zchee/nvim-go',
    }
    use {
      src..'/zchee/vim-goasm',
    }
    use {
      src..'/zchee/vim-flatbuffers',
    }
    use {
      src..'/zchee/vim-gn',
    }
    use {
      src..'/zchee/vim-go-testscript',
    }
    -- use {
    --   src..'/deoplete-plugins/deoplete-cgo',
    -- }
    -- use {
    --   src..'/deoplete-plugins/deoplete-asm',
    -- }
    -- use {
    --   src..'/deoplete-plugins/deoplete-zsh',
    -- }

  -- completion
  use {
    'ms-jpq/coq_nvim',
    requires = {
      'ms-jpq/coq.artifacts',
      'folke/lua-dev.nvim',
      'windwp/nvim-autopairs',
    },
    config = function()
      -- https://github.com/ms-jpq/coq_nvim/blob/coq/config/defaults.yml
      vim.g.coq_settings = {
        xdg = true,
        auto_start = 'shut-up',
        keymap = {
          recommended = false,
          pre_select = false,
          manual_complete = '<C-Space>',
          ['repeat'] = nil,
          bigger_preview = '<C-k>',
          jump_to_mark = '<C-h>',
          eval_snips = nil,
        },
        match = {
          unifying_chars = {
            "-",
            "_",
          },                     -- These characters count as part of words: default: { "-", "_" }
          max_results = 500,     -- Maximum number of results to return: default: 33, 500
          proximate_lines = 16,  -- How many lines to use, for the purpose of proximity bonus. Neighbouring words in proximity are counted: default: 16
          exact_matches = 1,     -- For word searching, how many exact prefix characters is required: default: 2
          look_ahead = 2,        -- For word searching, how many characters to look ahead, in case of typos: default: 2
          fuzzy_cutoff = 0.6,    -- What is the minimum similarity score, for a word to be proposed by the algorithm: default: 0.6
        },
        weights = {
          prefix_matches = 2.0,  -- Relative weight adjustment of exact prefix matches
          edit_distance = 1.5,   -- Relative weight adjustment of Damerau–Levenshtein distance, normalized and adjusted for look-aheads
          recency = 1.0,         -- Relative weight adjustment of recently inserted items
          proximity = 0.5,       -- Relative weight adjustment of prevalence within the proximate_lines
        },
        display = {
          mark_highlight_group = 'Pmenu',
          ghost_text = {
            enabled = true,
            context = {
              "〈  ",
              "  〉",
            },
            highlight_group = 'Comment',
          },
          pum = {
            fast_close = true,
            y_max_len = 100,                -- default: 16, 100
            y_ratio = 0.3,                  -- default: 0.3, 0.8
            x_max_len = 500,                -- default: 66, 500
            x_truncate_len = 500,           -- default: 12, 500
            ellipsis = "...",
            kind_context = { '"', '"' },    -- default: { " [", "]" },
            source_context = { '[', ']' },  -- default: { "「", "」" },
          },
          preview = {
            x_max_len = 200,         -- default: 88
            resolve_timeout = 0.09,  -- default: 0.09
            border = {               -- "rounded"
              { '╭', 'NormalFloat' },
              { '─', 'NormalFloat' },
              { '╮', 'NormalFloat' },
              { '│', 'NormalFloat' },
              { '╯', 'NormalFloat' },
              { '─', 'NormalFloat' },
              { '╰', 'NormalFloat' },
              { '│', 'NormalFloat' },
            },
            positions = {
              north = 3,  -- default: 1
              south = 4,  -- default: 2
              west = 1,   -- default: 3
              east = 2,   -- default: 4
            },
          },
          icons = {
            mode = 'long',
            spacing = 1,
            aliases = {
              Conditional = 'Keyword',
              Float = 'Number',
              Include = 'Property',
              Label = 'Keyword',
              Member = 'Property',
              Repeat = 'Keyword',
              Structure = 'Struct',
              Type = 'TypeParameter',
            },
            mappings = {
              Boolean = "",
              Character = "",
              Class = "",
              Color = "",
              Constant = "",
              Constructor = "",
              Enum = "",
              EnumMember = "",
              Event = "ﳅ",
              Field = "",
              File = "",
              Folder = "ﱮ",
              Function = "ﬦ",
              Interface = "",
              Keyword = "",
              Method = "",
              Module = "",
              Number = "",
              Operator = "Ψ",
              Parameter = "",
              Property = "ﭬ",
              Reference = "",
              Snippet = "",
              String = "",
              Struct = "ﯟ",
              Text = "",
              TypeParameter = "",
              Unit = "",
              Value = "",
              Variable = "ﳛ",
            },
          },
        },
        limits = {
          index_cutoff = 333333,
          idle_timeout = 1.88,
          completion_auto_timeout = 1.00,  -- default: 0.088, 0.88, 81.0
          completion_manual_timeout = 0.66,
          download_retries = 6,
          download_timeout = 66.0,
        },
        clients = {
          tabnine = {
            enabled = false,
          },
          third_party = {
            enabled = true,
            short_name = "3p",
            weight_adjust = 1.00,
          },
          tmux = {
            enabled = false,
          },
          buffers = {
            enabled = true,
            short_name = 'buf',
            match_syms = false,
            same_filetype = false,
            weight_adjust = 0,  -- default: 0
          },
          tree_sitter = {
            enabled = false,
          },
          paths = {
            enabled = true,
            short_name = 'path',
            resolution = {
              'cwd',
              'file',
            },
            -- path_seps = {},
            preview_lines = 6,
            weight_adjust = -0.5,  -- default: 0
          },
          snippets = {
            enabled = false,
            short_name = 'snip',
            weight_adjust = -0.5,  -- default: 0
            user_path = vim.fn.stdpath('config')..'/snippets/coq',
            warn = {
              'missing',
              'outdated',
            },
          },
          tags = {
            enabled = false,
          },
          lsp = {
            enabled = true,
            short_name = 'LSP',
            weight_adjust = 1.00,   -- default: 0.06
            resolve_timeout = 0.6,  -- default: 0.3
          },
        }
      }
    end,
  }
  use {
    src..'/ms-jpq/coq.thirdparty',
    config = function()
      require 'coq_3p' {
        { src = 'nvimlua', short_name = 'nlua', conf_only = true },
        { src = 'dap' },
      }
      -- require('coq-deoplete')
    end
  }
  use {
    'neovim/nvim-lspconfig',
  }
  use {
    'williamboman/nvim-lsp-installer',
    config = function()
      local nvim_data = vim.fn.stdpath('data')

      local servers = require('nvim-lsp-installer.servers')
      local server = require('nvim-lsp-installer.server')
      local shell = require('nvim-lsp-installer.installers.shell')
      local path = require('nvim-lsp-installer.path')
      local npm = require('nvim-lsp-installer.installers.npm')
      local util = require 'lspconfig.util'

      -- go
      local gopls = server.Server:new {
        name = 'gopls',
        root_dir = nvim_data..'/lsp_servers/gopls',
        homepage = 'https://pkg.go.dev/golang.org/x/tools/gopls',
        filetypes = { 'go', 'gomod', 'gotexttmpl' },
        installer = shell.bash [[ true ]],
        default_options = {
          cmd = { '/Users/zchee/go/bin/gopls', '-remote=unix;/tmp/gopls.sock' },
          filetypes = { 'go', 'gomod', 'gotexttmpl' },
          settings = {
            env = {},
            buildTags = {},
            directoryFilters = {
              '-asm',
              '-example',
              '-examples',
              '-examples',
              '-node_modules',
            },
            memoryMode = 'normal',
            completionDocumentation = true,
            usePlaceholders = true,
            deepCompletion = true,
            completeUnimported = true,
            matcher = 'fuzzy',
            symbolMatcher = 'fuzzy',
            symbolStyle = 'full',
            hoverKind = 'fulldocumentation',
            linkTarget = '',
            linksInHover = false,
            importShortcut = 'both',
            analyses = {
              fieldalignment = true,
              implementmissing = true,
              nilness = true,
              shadow = true,
              unusedparams = false,
              unusedwrite = true,
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
            templateSupport = true,
            templateExtensions = { 'tmpl', 'gotmpl', 'tpl' },
            diagnosticsDelay = '100ms',
            experimentalWatchedFileDelay = '100ms',
            experimentalPackageCacheKey = true,
            allowModfileModifications = true,
            allowImplicitNetworkAccess = true,
            experimentalUseInvalidMetadata = false,
          }
        },
      }
      servers.register(gopls)

      -- golangci_lint_ls
      local golangci_lint_ls = server.Server:new {
        name = 'golangci_lint_ls',
        root_dir = servers.get_server_install_path('golangci_lint_ls'),
        languages = { 'go', 'gomod' },
        filetypes = { 'go', 'gomod' },
        homepage = 'https://github.com/nametake/golangci-lint-langserver',
        installer = shell.bash [[ true ]],
        default_options = {
          cmd = { '/Users/zchee/go/bin/golangci-lint-langserver' },
          filetypes = { 'go', 'gomod' },
          init_options = {
            command = { 'golangci-lint', 'run', '--enable-all', '--disable', 'lll', '--out-format', 'json' },
          },
          root_dir = function(fname)
            return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git')(fname)
          end,
        }
      }
      servers.register(golangci_lint_ls)

      -- clangd
      local clangd = server.Server:new {
        name = 'clangd',
        languages = { 'c', 'c++' },
        root_dir = servers.get_server_install_path('clangd'),
        homepage = 'https://clangd.llvm.org',
        installer = shell.bash [[ true ]],
        default_options = {
          cmd = {
            '/opt/llvm/clangd/stable/bin/clangd',
            '--all-scopes-completion',
            '--completion-style=detailed',
            '--header-insertion-decorators',
            '--header-insertion=iwyu',
            '--index',
            -- '--inlay-hints',
            -- '--pch-storage=memory',
            -- '-j20',
            -- '--log=verbose',
          },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        },
      }
      servers.register(clangd)

      -- sourcekit
      local sourcekit = server.Server:new {
        name = 'sourcekit',
        languages = { 'swift' },
        root_dir = servers.get_server_install_path('sourcekit'),
        homepage = 'https://github.com/apple/sourcekit-lsp',
        installer = shell.bash [[ true ]],
        default_options = {
          cmd = { 'xcrun', '--toolchain', 'swift', '-r', 'sourcekit-lsp', '--build-path=.build' },
          filetypes = { 'swift' },
        },
      }
      servers.register(sourcekit)

      -- sumneko_lua
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")
      local sumneko_lua = server.Server:new {
        name = 'sumneko_lua',
        root_dir = servers.get_server_install_path('sumneko_lua'),
        languages = { 'lua' },
        homepage = 'https://github.com/sumneko/lua-language-server',
        installer = shell.bash [[
        git clone --depth 1 --single-branch --branch master https://github.com/sumneko/lua-language-server
        cd ./lua-language-server/3rd/luamake
        git submodule update --init --recursive
        ./compile/install.sh
        cd ../../
        ./3rd/luamake/luamake rebuild
        ]],
        default_options = {
          cmd = {
            path.concat { servers.get_server_install_path('sumneko_lua'), 'lua-language-server', 'bin', 'macOS', 'lua-language-server' },
            '-E',
            path.concat { servers.get_server_install_path('sumneko_lua'), 'lua-language-server', 'main.lua' },
          },
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
            },
          },
        },
      }
      servers.register(sumneko_lua)

      -- rust_analyzer
      local rust_analyzer = server.Server:new {
        name = 'rust_analyzer',
        root_dir = servers.get_server_install_path('rust_analyzer'),
        languages = { 'rust' },
        homepage = 'https://rust-analyzer.github.io',
        installer = shell.bash [[ true ]],
        default_options = {
          cmd = { '/usr/local/rust/rustup/toolchains/nightly-x86_64-apple-darwin/bin/rust-analyzer' },
        },
      }
      servers.register(rust_analyzer)

      -- tsserver
      local tsserver = server.Server:new {
        name = 'tsserver',
        root_dir = servers.get_server_install_path('tsserver'),
        languages = { 'typescript', 'javascript' },
        homepage = 'https://github.com/typescript-language-server/typescript-language-server',
        installer = npm.packages { 'typescript-language-server@latest', 'typescript@next' },
        default_options = {
          cmd = { npm.executable(servers.get_server_install_path('tsserver'), 'typescript-language-server'), '--stdio' },
        },
      }
      servers.register(tsserver)

      -- yamlls
      local yamlls =  server.Server:new {
        name = 'yamlls',
        root_dir = servers.get_server_install_path('yamlls'),
        languages = { 'yaml' },
        homepage = 'https://github.com/redhat-developer/yaml-language-server',
        installer = npm.packages { 'yaml-language-server@next' },
        default_options = {
          cmd = { npm.executable(servers.get_server_install_path('yamlls'), 'yaml-language-server'), '--stdio' },
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
              schemas = {
                -- local
                [ 'file:///Users/zchee/src/github.com/zchee/schema/appengine-app.schema.json' ] = {
                  'app*.yaml'
                },
                [ 'file:///Users/zchee/src/github.com/zchee/schema/circleci.schema.json' ] = {
                  '.circleci/config.yml',
                  '@orb.yml',
                  '**/commands/*.yml',
                  '**/examples/*.yml',
                  '**/executors/*.yml',
                  '**/jobs/*.yml'
                },
                [ 'file:///Users/zchee/src/github.com/zchee/schema/codecov.schema.json' ] = {
                  '**/.codecov.yml'
                },
                [ 'file:///Users/zchee/src/github.com/zchee/schema/kaitai-struct-compiler.schema.json' ] = {
                  '*.ksy'
                },
                [ 'file:///Users/zchee/src/github.com/zchee/schema/mkdocs.schema.json' ] = {
                  'mkdocs.yml'
                },
                [ 'file:///Users/zchee/src/github.com/zchee/schema/open-rpc.schema.json' ] = {
                  'openrpc.yaml'
                },
                -- https
                [ 'https://json.schemastore.org/appveyor.json'] = {
                  '*appveyor.yml'
                },
                [ 'https://github.com/compose-spec/compose-spec/raw/master/schema/compose-spec.json' ] = {
                  '*docker-compose*.yaml',
                  '*docker-compose*.yml'
                },
                [ 'https://github.com/microsoft/azure-pipelines-vscode/raw/main/service-schema.json' ] = {
                  'azure-pipelines.yml'
                },
                [ 'https://json.schemastore.org/dependabot-2.0.json' ] = {
                  '.github/dependabot.yml'
                },
                [ 'https://json.schemastore.org/cloudbuild'] = {
                  '*cloudbuild.yaml',
                  '*cloudbuild.*.yaml'
                },
                [ 'https://json.schemastore.org/compile-commands.json' ] = {
                  'compile_commands.json'
                },
                [ 'https://json.schemastore.org/kustomization.json' ] = {
                  'kustomization.yaml',
                  'kustomizeconfig.yaml'
                },
                [ 'https://json.schemastore.org/github-action.json' ] = {
                  'action.yml'
                },
                [ 'https://json.schemastore.org/github-workflow.json' ] = {
                  '**/.github/workflows/*.yml'
                },
                [ 'https://github.com/OAI/OpenAPI-Specification/raw/master/schemas/v3.0/schema.json' ] = {
                  'openapi.yaml',
                  '**/openapi-spec/*.yaml',
                  '*swagger.yaml',
                  '**/swagger-spec/*.yaml'
                },
                [ 'https://github.com/googleapis/gnostic/raw/master/discovery/discovery.json'] = {
                  '*discovery.yaml'
                },
                [ 'https://github.com/GoogleContainerTools/skaffold/raw/main/docs/content/en/schemas/v2beta24.json'] = {
                  'skaffold*.yaml'
                },
                -- kubernetes
                [ 'kubernetes' ] = {
                  'kubernetes/*',
                  'manifest.yaml',
                  'statefulset.yaml',
                  'daemonset.yaml',
                  'deployment.yaml',
                  'replicaset.yaml',
                  'pod.yaml',
                },
                [ "file:///Users/zchee/go/src/github.com/kouzoh/kube-pubsub-operator/_kubernetes/kube-pubsub-operator-api/apis/v1alpha1/crd/delivery.platform.mercari.com_subscriptionreplicationconfigs.yaml" ] = {
                  'kubernetes/*/subscription_replication_config.yaml',
                  '_kubernetes/*/subscription_replication_config.yaml',
                  'subscription_replication_config.yaml',
                },
              }
            }
          }
        }
      }
      servers.register(yamlls)

      -- sqls
      local sqls = server.Server:new {
        name = 'sqls',
        root_dir = servers.get_server_install_path('sqls'),
        languages = { 'sql' },
        homepage = 'https://github.com/lighttiger2505/sqls',
        installer = shell.bash [[
        go install -v github.com/lighttiger2505/sqls@master
        ]],
        default_options = {
          cmd = { '/Users/zchee/go/bin/sqls' },
        }
      }
      servers.register(sqls)
    end
  }
  use {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require('nvim-autopairs')

      npairs.setup({
        check_ts = true,
        disable_filetype = {
          'TelescopePrompt',
        },
        fast_wrap = {},
        map_bs = false,
        map_cr = false,
        ts_config = {
          lua = { 'string' },
          go = { 'string' },
        },
      })

      _G.MUtils = {}
      local remap = vim.api.nvim_set_keymap
      local npairs_rule = require('nvim-autopairs.rule')
      local ts_conds = require('nvim-autopairs.ts-conds')

      -- go
      npairs.add_rules({
        npairs_rule('"', "'", "'", 'go')
          :with_pair(ts_conds.is_ts_node({ 'string' })),
        npairs_rule("'", '"', '"', 'go')
          :with_pair(ts_conds.is_ts_node({ 'string' })),
      })

      -- lua
      npairs.add_rules({
        npairs_rule('%', '%', 'lua')
          :with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
        npairs_rule('$', '$', 'lua')
          :with_pair(ts_conds.is_not_ts_node({ 'function' }))
      })

      MUtils.BS = function()
        if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
          return npairs.esc('<C-e>') .. npairs.autopairs_bs()
        else
          return npairs.autopairs_bs()
        end
      end

      MUtils.CR = function()
        if vim.fn.pumvisible() ~= 0 then
          if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
            return npairs.esc('<C-y>')
          else
            return npairs.esc('<C-e>') .. npairs.autopairs_cr()
          end
        else
          return npairs.autopairs_cr()
        end
      end

      remap('i', '<BS>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
      remap('i', '<CR>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
      -- ms-jpq/coq_nvim default
      -- remap('i', '<BS>', "pumvisible() ? '<c-e><bs>' : '<bs>'", { expr = true, noremap = true })
      -- remap('i', '<CR>', "pumvisible() ? (complete_info(['selected']).selected == -1 ? '<c-e><cr>' : '<c-y>') : '<cr>'", { expr = true, noremap = true })
      remap('i', '<ESC>', [[pumvisible() ? "<C-e><ESC>" : "<ESC>"]], { expr = true, noremap = true })
      remap('i', '<Tab>', [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true, noremap = true })
      remap('i', '<S-Tab>', [[pumvisible() ? "<C-p>" : "<BS>"]], { expr = true, noremap = true })
      remap('i', '<C-c>', [[pumvisible() ? "<C-e><C-c>" : "<C-c>"]], { expr = true, noremap = true })
      -- ms-jpq/coq_nvim default
      remap('i', '<C-u>', "pumvisible() ? '<C-e><C-u>' : '<C-u>'", { expr = true, noremap = true })
      remap('i', '<C-w>', "pumvisible() ? '<C-e><C-w>' : '<C-w>'", { expr = true, noremap = true })

      -- remap("x", "nu", [[lua require"treesitter-unit".select()<CR>]], { expr = true, noremap = true })
      -- remap("x", "tu", [[lua require"treesitter-unit".select(true)<CR>]], { expr = true, noremap = true })
    end,
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-frecency.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-packer.nvim',
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = 'smart_case',        -- or 'ignore_case' or 'respect_case'. the default case_mode is 'smart_case'
          }
        },
      }
      telescope.load_extension 'frecency'
      telescope.load_extension 'fzf'
      telescope.load_extension 'packer'
    end,
  }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    requires = {
      'tami5/sql.nvim',
    },
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
  }

  -- tree-sitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'windwp/nvim-autopairs',
    },
    config = function()
      local treesitter = require('nvim-treesitter.configs')
      local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()

      -- objc
      parser_config.objc = {
        filetype = 'objc',
        install_info = {
          url = 'https://github.com/merico-dev/tree-sitter-objc',
          branch = 'master',
          files = {'src/parser.c'},
          generate_requires_npm = true,
          requires_generate_from_grammar = true,
        },
      }
      -- sql
      parser_config.sql = {
        filetype = 'sql',
        install_info = {
          url = 'https://github.com/m-novikov/tree-sitter-sql',
          branch = 'main',
          files = {'src/parser.c'},
          requires_generate_from_grammar = true,
        },
      }

      treesitter.setup {
        ensure_installed = {
          'bash',
          -- 'beancount',
          -- 'bibtex',
          'c',
          -- 'c_sharp',
          -- 'clojure',
          'cmake',
          'comment',
          -- 'commonlisp',
          'cpp',
          -- 'css',
          -- 'cuda',
          -- 'd',
          -- 'dart',
          -- 'devicetree',
          'dockerfile',
          -- 'dot',
          -- 'elixir',
          -- 'elm',
          -- 'erlang',
          -- 'fennel',
          -- 'fish',
          -- 'fortran',
          -- 'gdscript',
          -- 'glimmer',
          'glsl',
          'go',
          -- 'godotResource',
          'gomod',
          'graphql',
          -- 'haskell',
          'hcl',
          -- 'heex',
          -- 'hjson',
          'html',
          -- 'http',
          'java',
          'javascript',
          'jsdoc',
          'json',
          'json5',
          'jsonc',
          -- 'julia',
          -- 'kotlin',
          -- 'latex',
          -- 'ledger',
          'llvm',
          'lua',
          'nix',
          'objc',
          -- 'ocaml',
          -- 'ocaml_interface',
          -- 'ocamllex',
          'perl',
          -- 'php',
          -- 'pioasm',
          'python',
          'ql',
          'query',
          -- 'r',
          'regex',
          'rst',
          'ruby',
          'rust',
          -- 'scala',
          -- 'scss',
          -- 'sparql',
          'sql',
          -- 'supercollider',
          -- 'surface',
          -- 'svelte',
          'swift',
          'teal',
          -- 'tlaplus',
          'toml',
          'tsx',
          -- 'turtle',
          'typescript',
          -- 'verilog',
          'vim',
          -- 'vue',
          'yaml',
          -- 'yang',
          -- 'zig',
        },
        highlight = {
          enable = true,
          disable = {
            'bash',
            'dockerfile',
            'go',
            'gomod',
            'vim',
          },
          additional_vim_regex_highlighting = {
            'toml',
          },
        };
        indent = {
          enable = true,
          disable = {
            'go',
            'json',
            'yaml',
          },
        };
        incremental_selection = {
          enable = true,
          disable = { },
          keymaps = {
            init_selection = 'gnn',
            node_decremental = 'grm',
            node_incremental = 'grn',
            scope_incremental = 'grc'
          },
        };
        autopairs = {
          enable = true,
        },
        matchup = {
          enable = true,              -- mandatory, false will disable the whole extension
          disable = { 'c', 'ruby' },  -- optional, list of language that will be disabled
        },
      }
    end,
  }

  -- UI
  use {
    'andymass/vim-matchup',
    requires = {
      'nvmi-treesitter/nvim-treesitter',
    },
    config = function()
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  }

  -- use {
  --   'David-Kunz/treesitter-unit',
  --   requires = {
  --     'nvim-treesitter/nvim-treesitter',
  --   },
  -- }

  -- comment

  -- file tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function ()
      vim.g.nvim_tree_highlight_opened_files = 1
      vim.g.nvim_tree_show_icons = {
        git = 1,
        folders= 1,
        files= 1,
        folder_arrows = 0,
      }
      vim.g.nvim_tree_git_hl = 1
      vim.g.nvim_tree_window_picker_exclude = {
        filetype = {
          'notify',
          'packer',
          'qf'
        },
        buftype = {
          'terminal',
        }
      }

      local nvim_tree = require('nvim-tree')
      nvim_tree.setup {
        disable_netrw       = true,
        hijack_netrw        = true,
        open_on_setup       = false,
        open_on_tab         = false,
        update_to_buf_dir   = {
          enable = true,
          auto_open = true,
        },
        auto_close          = true,
        hijack_cursor       = true,
        update_cwd          = true,
        hide_root_folder    = false,
        update_focused_file = {
          enable = true,
          update_cwd = true,
          ignore_list = {}
        },
        ignore_ft_on_setup = {},
        system_open = {
          cmd  = nil,
          args = {}
        },
        diagnostics = {
          enable = false,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          }
        },
        filters = {
          dotfiles = true,
          custom_filter = {}
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 400,
        },
        view = {
          width = '10%',
        },
      }

      vim.api.nvim_set_keymap('n', '-', ':<C-u>NvimTreeFindFile<CR>', { noremap = true, silent = true, nowait = true } )
    end,
  }

  -- lua
  -- use {
  --   'euclidianAce/BetterLua.vim',
  --   ft = { 'lua' },
  -- }

  -- git
  use {
    'TimUntersberger/neogit',
    requires = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    cmd = "Neogit",
    config = function ()
      local neogit = require('neogit')
      neogit.setup {
        disable_commit_confirmation = true,
        disable_signs = false,
        signs = {
          section = { '>', 'v' },
          item = { '>', 'v' },
          hunk = { '', '' },
        },
        integrations = {
          diffview = true,
        },
        mappings = {
          status = {
            -- ["c"] = "CommitPopup -s",
          }
        }
      }
    end,
  }

  -- quickfix
  use {
    {
      'kevinhwang91/nvim-bqf',
      config = function ()
        local bqf = require('bqf')

        bqf.config = {
          auto_enable = true,
          magic_window = true,
          auto_resize_height = true,
          preview = {
            auto_preview = true,
            border_chars = { '│', '│', '─', '─', '╭', '╮', '╰', '╯', '█' },
            delay_syntax = 5,
            win_height = 50,
            win_vheight = 30,
            wrap = true
          },
          func_map = {
            filter = 'zn',
            filterr = 'zN',
            fzffilter = 'zf',
            nextfile = '<C-n>',
            nexthist = '>',
            open = '<CR>',
            openc = 'o',
            prevfile = '<C-p>',
            prevhist = '<',
            pscrolldown = '<C-f>',
            pscrollorig = 'zo',
            pscrollup = '<C-b>',
            ptoggleauto = 'P',
            ptoggleitem = 'p',
            ptogglemode = 'zp',
            sclear = 'z<Tab>',
            split = '<C-x>',
            stogglebuf = "'<Tab>",
            stoggledown = '<Tab>',
            stoggleup = '<S-Tab>',
            stogglevm = '<Tab>',
            tab = 't',
            tabb = 'T',
            vsplit = '<C-v>'
          },
          filter = {
            fzf = {
              action_for = {
                [ 'ctrl-q' ] = 'signtoggle',
                [ 'ctrl-t' ] = 'tabedit',
                [ 'ctrl-v' ] = 'vsplit',
                [ 'ctrl-x' ] = 'split'
              },
              extra_opts = { '--bind', 'ctrl-o:toggle-all' }
            }
          },
        }
      end,
    },
    {
      'sindrets/diffview.nvim',
      opt = true,
    },
  }

  -- Debug
  use {
    'bfredl/nvim-luadev',
    ft = { "lua" },
  }

  use {
    'tweekmonster/startuptime.vim',
  }
  -- use {
  --   "dstein64/vim-startuptime",
  --   -- cmd = 'StartupTime',
  --   config = function()
  --     vim.g.startuptime_exe_path = '/usr/local/bin/nvim'
  --     vim.g.startuptime_exe_args = { '-u', '~/.config/nvim/init.vim' }
  --     vim.g.startuptime_sort = 1
  --     vim.g.startuptime_tries = 10
  --   end,
  -- }
  -- use {
  --   "henriquehbr/nvim-startup.lua",
  --   config = function()
  --     require('nvim-startup').setup()
  --   end
  -- }

  use {
    'norcalli/nvim-colorizer.lua',
    ft = { 'vim', 'kitty' },
    config = function()
      require('colorizer').setup {
        'vim',
        'kitty',
      }
    end,
  }

  -- Dap
  use {
    'mfussenegger/nvim-dap',
    requires = {
      'jbyuki/one-small-step-for-vimkind',
    },
    -- config = [[require('config.dap')]],
    -- config = function()
    --   -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    --   local dap = require('dap')
    --
    --   dap.adapters.go = function(callback, _)
    --     local stdout = vim.loop.new_pipe(false)
    --     local handle
    --     local pid_or_err
    --     local port = 38697
    --     local opts = {
    --       stdio = {nil, stdout},
    --       args = {"dap", "-l", "127.0.0.1:" .. port},
    --       detached = true
    --     }
    --     handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    --       stdout:close()
    --       handle:close()
    --       if code ~= 0 then
    --         print('dlv exited with code', code)
    --       end
    --     end)
    --     assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    --     stdout:read_start(function(err, chunk)
    --       assert(not err, err)
    --       if chunk then
    --         vim.schedule(function()
    --           require('dap.repl').append(chunk)
    --         end)
    --       end
    --     end)
    --     -- Wait for delve to start
    --     vim.defer_fn(
    --     function()
    --       callback({type = "server", host = "127.0.0.1", port = port})
    --     end,
    --     100)
    --   end
    --   -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    --   dap.configurations.go = {
    --     {
    --       type = "go",
    --       name = "Debug",
    --       request = "launch",
    --       program = "${file}"
    --     },
    --     {
    --       type = "go",
    --       name = "Debug test", -- configuration for debugging test files
    --       request = "launch",
    --       mode = "test",
    --       program = "${file}"
    --     },
    --     -- works with go.mod packages and sub packages
    --     {
    --       type = "go",
    --       name = "Debug test (go.mod)",
    --       request = "launch",
    --       mode = "test",
    --       program = "./${relativeFileDirname}"
    --     }
    --   }
    -- end,
  }
  use {
    'rcarriga/nvim-dap-ui',
    requires = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('dapui').setup()
    end,
  }

  -- UI
  -- use {
  --   'edluffy/hologram.nvim',
  -- }

  -- vim plugins
  use {
    {
      'Shougo/neoinclude.vim',
      ft = {'c', 'cpp', 'objc', 'objcpp', 'swift', 'go'},
    },

    -- UI
    {
      'itchyny/lightline.vim',
      requires = {
        'ryanoasis/vim-devicons',
        -- 'maximbaz/lightline-ale',
        'mgee/lightline-bufferline',
      },
    },
    {
      'voldikss/vim-floaterm',
      cmd = { 'FloatermNew', 'FloatermToggle', 'FloatermPrev', 'FloatermNext', 'FloatermHide' },
    },
    {
      'airblade/vim-gitgutter'
    },
    -- {
    --   'rhysd/git-messenger.vim'
    -- },
    {
      'liuchengxu/vista.vim',
      cmd = { 'Vista' },
    },

    -- linters
    -- {
    --   "dense-analysis/ale"
    -- },
    {
      'rhysd/vim-clang-format',
      cmd = { 'ClangFormat', 'ClangFormatEchoFormattedCode', 'ClangFormatAutoToggle', 'ClangFormatAutoEnable', 'ClangFormatAutoDisable' },
    },

    -- operator
    {
      'kana/vim-operator-user'
    },
    {
      'kana/vim-repeat'
    },
    {
      'kana/vim-operator-replace',
      requires = {
        'kana/vim-operator-user',
      },
    },
    {
      'rhysd/vim-operator-surround',
      requires = {
        'kana/vim-operator-user',
      },
    },
    {
      'mopp/vim-operator-convert-case',
      requires = {
        'kana/vim-operator-user',
      },
    },
    -- formatter
    {
      'sbdchd/neoformat',
      cmd = { 'Neoformat' },
    },
    {
      'AndrewRadev/switch.vim'
    },
    {
      'haya14busa/vim-asterisk'
    },
    -- {
    --   'itchyny/vim-parenmatch'
    -- },
    {
      'junegunn/vim-easy-align',
      cmd = { 'EasyAlign' },
    },
    {
      'rhysd/accelerated-jk'
    },
    -- {
    --   'RRethy/vim-hexokinase',
    --   cmd = { 'HexokinaseToggle', 'HexokinaseRefresh' },
    --   run = { 'make hexokinase' },
    -- },
    {
      'RRethy/vim-illuminate'
    },
    -- {
    --   'thinca/vim-quickrun',
    --   cmd = { 'Capture' },
    -- },
    {
      'tyru/caw.vim'
    },
    {
      'tyru/open-browser.vim',
    },
    {
      'utahta/trans.nvim',
      cmd = { 'Trans' },
      run = { 'make' },
    },
    {
      'wakatime/vim-wakatime'
    },

    -- languages
    {
      'tweekmonster/hl-goimport.vim',
      ft = { 'go' },
    },
    {
      'hofstadter-io/cue.vim',
      ft = { 'cue' },
    },
    {
      'vim-jp/vim-cpp',
      ft = { 'cpp' },
    },
    {
      'bfrg/vim-cpp-modern',
      ft = { 'c', 'cpp' },
    },
    {
      'octol/vim-cpp-enhanced-highlight',
      ft = { 'c', 'cpp' },
    },
    {
      'keith/swift.vim',
      ft = { 'swift' },
    },
    {
      'pboettch/vim-cmake-syntax',
      ft = { 'cmake' },
    },
    {
      'neui/cmakecache-syntax.vim',
      ft = { 'cmakec' },
    },
    {
      'lambdalisue/vim-cython-syntax',
      ft = { 'python' },
    },
    {
      'rust-lang/rust.vim',
      ft = { 'rust' },
    },
    {
      'ron-rs/ron.vim',
      ft = { 'ron' },
    },
    {
      'ollykel/v-vim',
      ft = { 'vlang' },
    },
    {
      'uarun/vim-protobuf',
      ft = { 'protobuf' },
    },
    {
      'tsandall/vim-rego',
      ft = { 'rego' },
    },
    {
      'cappyzawa/starlark.vim',
      ft = { 'starlark' },
    },
    {
      'Shirk/vim-gas',
      ft = { 'gas' },
    },
    {
      'HerringtonDarkholme/yats.vim',
      ft = { 'typescript' },
    },
    {
      'Shougo/vinarise.vim',
      cmd = { 'Vinarise', 'VinarisePluginDump' },
    },
    {
      'moorereason/vim-markdownfmt',
      ft = { 'markdown' },
    },
    {
      'iamcco/markdown-preview.nvim',
      ft = { 'markdown' },
      run = { 'cd app & yarn install' },
    },
    {
      'gisphm/vim-gitignore',
      ft = { 'gitignore' },
    },
    {
      'vim-jp/vimdoc-ja',
    },
    -- {
    --   'vim-jp/syntax-vim-ex',
    --   ft = { 'vim' },
    -- },
    -- {
    --   'chrisbra/vim-sh-indent',
    --   ft = { 'sh' },
    -- },
    -- {
    --   'stephpy/vim-yaml',
    --   ft = { 'yaml' },
    -- },
    {
      'cespare/vim-toml',
      Ft = { 'toml' },
    },
    {
      'elzr/vim-json',
      ft = { 'json' },
    },
    {
      'gutenye/json5.vim',
      ft = { 'json5' },
    },
    {
      'jparise/vim-graphql',
      ft = { 'graphql' },
    },
    {
      'udalov/kotlin-vim',
      ft = { 'kotlin' },
    },
    {
      'ericpruitt/tmux.vim',
      ft = { 'tmux' },
    },
    {
      'hashivim/vim-terraform',
      ft = { 'terraform' },
    },
    {
      'mustache/vim-mustache-handlebars',
      ft = { 'mustache' },
    },
    {
      'glench/vim-jinja2-syntax',
      ft = { 'jinja2' },
    },
    {
      'vim-scripts/vim-niji',
      ft = { 'scheme' },
    },
    {
      'compnerd/modulemap-vim',
      ft = { 'modulemap' },
    },
    {
      'aklt/plantuml-syntax',
      ft = { 'plantuml' },
    },
    {
      'weirongxu/plantuml-previewer.vim',
      ft = { 'plantuml' },
    },
    {
      'tikhomirov/vim-glsl',
      ft = { 'glsl' },
    },
    {
      'fladson/vim-kitty',
      ft = { 'kitty' },
    },
  }

  if PackerBootstrap then
    require('packer').sync()
  end
end)
