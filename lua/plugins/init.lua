local util = require("util")

---@type LazySpec
return {
  -- Local
  {
    dir = util.src_path("github.com/zchee/vim-flatbuffers"),
    ft = "fbs",
  },
  {
    dir = util.src_path("github.com/zchee/vim-gn"),
    ft = "gn",
  },
  {
    dir = util.src_path("github.com/zchee/vim-go-testscript"),
    ft = "testscript",
  },
  {
    dir = util.src_path("github.com/zchee/tree-sitter-goasm"),
    lazy = false,
  },
  {
    dir = util.src_path("github.com/zchee/metafrastis.nvim"),
    lazy = true,
    cmd = {
      "MetafrastisTranslate",
      "MetafrastisCacheClear",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require("plugins.metafrastis")
    end,
  },

  -- Lazy
  {
    "vhyrro/luarocks.nvim",
    lazy = false,
    priority = 1000,
    config = true,
  },

  -- AI
  -- Codex (OpenAI Codex CLI): side-panel terminal wrapper.
  -- The plugin can't pass `--dangerously-bypass-approvals-and-sandbox`
  -- via opts; configure approval mode in `~/.codex/config.toml`
  -- (e.g. `approval_policy = "on-failure"`) for fish abbr `cx` parity.
  {
    "johnseth97/codex.nvim",
    cmd = { "Codex", "CodexToggle" },
    opts = {
      keymaps = {
        toggle = nil,
        quit = "<C-q>",
      },
      panel = true,
      width = 0.4,
      height = 0.85,
      autoinstall = false,
    },
    keys = {
      { "<leader>ax", "<cmd>CodexToggle<cr>", desc = "Toggle Codex (sidebar)" },
    },
  },
  {
    "coder/claudecode.nvim",
    -- dir = util.src_path("github.com/zchee/claudecode.nvim"),
    dependencies = {
      "folke/snacks.nvim",
    },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeNew",
      "ClaudeCodeCloseSession",
      "ClaudeCodeSwitch",
      "ClaudeCodeCloseSession",
    },
    config = function()
      require("plugins.claudecode")
    end,
    keys = {
      { "<Leader>a", nil, desc = "AI/Claude Code" },
      { "<Leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<Leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<Leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<Leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<Leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<Leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<Leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<Leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      -- Diff management
      { "<Leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      {
        "ravitemer/codecompanion-history.nvim",
      },
    },
    config = function()
      require("plugins.codecompanion")
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-opus-4.6",
      debug = false,
      instruction_files = {
        ".github/copilot-instructions.md",
        "AGENTS.md",
        "CLAUDE.md",
      },
      window = {
        layout = "vertical",
        width = 0.35,
      },
      mappings = {
        close = {
          normal = "q",
          insert = "<C-c>",
        },
      },
      prompts = {
        ReviewStaged = {
          prompt = "Review the staged diff. Lead with bugs, security issues, regressions, and missing tests. Cite file paths and keep the response terse.",
          system_prompt = "COPILOT_REVIEW",
          resources = { "gitdiff:staged" },
        },
        ReviewUnstaged = {
          prompt = "Review the unstaged diff. Lead with bugs, security issues, regressions, and missing tests. Cite file paths and keep the response terse.",
          system_prompt = "COPILOT_REVIEW",
          resources = { "gitdiff:unstaged" },
        },
        Workspace = {
          prompt = "Use the available workspace tools to answer. Inspect files before making claims, prefer ripgrep-style search, and do not guess about file contents.",
          tools = "copilot",
          sticky = {
            "#buffer:visible",
            "@copilot",
          },
        },
      },
    },
    keys = {
      { "<leader>ax", false },
      { "<leader>ao", "<cmd>CopilotChatOpen<cr>", desc = "Open Chat" },
      { "<leader>aq", "<cmd>CopilotChatClose<cr>", desc = "Close Chat" },
      { "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "Reset Chat" },
      { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "Select Model" },
      { "<leader>aP", "<cmd>CopilotChatPrompts<cr>", desc = "Prompt Library" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix Code", mode = { "n", "v" } },
      { "<leader>aO", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CopilotChatDocs<cr>", desc = "Generate Docs", mode = { "n", "v" } },
      { "<leader>aR", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
      { "<leader>ag", "<cmd>CopilotChatReviewStaged<cr>", desc = "Review Staged Diff" },
      { "<leader>aG", "<cmd>CopilotChatReviewUnstaged<cr>", desc = "Review Unstaged Diff" },
      { "<leader>aW", "<cmd>CopilotChatWorkspace<cr>", desc = "Workspace Chat" },
    },
  },
  -- {
  --   -- https://github.com/nwiizo/dotfiles/blob/main/nvim/lua/plugins/ai.lua
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   version = false,
  --   -- build = "make",
  --   build = "RUSTFLAGS='-C target-cpu=apple-m3 -C opt-level=3 -C force-frame-pointers=on -C debug-assertions=off -C incremental=on -C overflow-checks=off -C link-arg=-undefined -C link-arg=dynamic_lookup' cargo build -v --release --features=luajit -p avante-repo-map -p avante-templates -p avante-tokenizers",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     "zbirenbaum/copilot.lua",
  --     -- {
  --     --   "HakonHarnes/img-clip.nvim",
  --     --   event = "VeryLazy",
  --     --   opts = {},
  --     -- },
  --   },
  --   opts = {
  --     instructions_file = "CLAUDE.md",
  --     provider = "copilot",
  --     mode = "agentic",
  --     input = { provider = "snacks" },
  --     selector = { provider = "snacks" },
  --     providers = {
  --       copilot = {
  --         endpoint = "https://api.githubcopilot.com",
  --         model = "claude-opus-4.6",
  --         timeout = 30000,
  --       },
  --     },
  --     mappings = {
  --       ask = "<leader>aa",
  --       edit = "<leader>aE",
  --       refresh = "<leader>aS",
  --     },
  --     behaviour = {
  --       auto_suggestions = false,
  --       auto_set_keymaps = true,
  --       auto_apply_diff_after_generation = false,
  --       auto_approve_tool_permissions = false,
  --     },
  --     windows = { position = "right", width = 35 },
  --   },
  -- },
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   build =
  --   "RUSTFLAGS='-C linker=clang -C target-cpu=native -C opt-level=3 -C force-frame-pointers=on -C debug-assertions=off -C incremental=on -C overflow-checks=off -C panic=abort -C codegen-units=1 -C embed-bitcode=yes -Z dylib-lto -Z location-detail=none -C strip=symbols -C link-arg=-undefined -C link-arg=dynamic_lookup' cargo build -v --release --features=luajit -p avante-repo-map -p avante-templates -p avante-tokenizers",
  --   keys = require("plugins.avante.keys"),
  --   opts = require("plugins.avante"),
  --   dependencies = {
  --     {
  --       "ravitemer/mcphub.nvim",
  --       dependencies = {
  --         "nvim-lua/plenary.nvim",
  --       },
  --       cmd = "MCPHub",
  --       build = "bun install -g mcp-hub@latest",
  --       config = function()
  --         require("plugins.mcphub")
  --       end
  --     },
  --     "folke/snacks.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     {
  --       "ibhagwan/fzf-lua",
  --       dependencies = { "echasnovski/mini.icons" },
  --     },
  --     -- icons
  --     "echasnovski/mini.icons",
  --   },
  --   {
  --     "obsidian-nvim/obsidian.nvim",
  --     disable = true,
  --     dependencies = {
  --       "nvim-lua/plenary.nvim",
  --     },
  --     event = {
  --       "BufReadPre " .. vim.fn.expand("~") .. "/.obsidian/vaults/knowledge/*.md", -- "BufReadPre path/to/my-vault/*.md","BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --     },
  --     config = function()
  --       require("plugins.obsidian")
  --     end,
  --   },
  -- },

  -- LSP
  {
    {
      "williamboman/mason.nvim",
      cmd = {
        "Mason",
        "MasonInstall",
        "MasonUpdate",
        "MasonUninstall",
        "MasonUninstallAll",
        "MasonLog",
      },
      config = function()
        require("plugins.mason")
      end,
    },
    {
      {
        "neovim/nvim-lspconfig",
        event = {
          "BufReadPre",
          "BufNewFile",
        },
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          {
            "nvimdev/lspsaga.nvim",
            event = "VeryLazy",
            dependencies = {
              "nvim-treesitter/nvim-treesitter",
              "nvim-tree/nvim-web-devicons",
            },
          },
          "onsails/lspkind-nvim",
          "williamboman/mason-lspconfig.nvim",
          {
            "chrisgrieser/nvim-lsp-endhints",
            event = "LspAttach",
          },
          {
            "aznhe21/actions-preview.nvim",
            event = "LspAttach",
          },
          {
            "rachartier/tiny-inline-diagnostic.nvim",
            event = "LspAttach",
          },
          {
            "lewis6991/hover.nvim",
            event = "LspAttach",
          },
          {
            "b0o/schemastore.nvim",
          },
          {
            dir = util.src_path("github.com/LuaLS/LLS-Addons"), -- "LuaLS/LLS-Addons",
            ft = "lua",
          },
        },
        config = function()
          require("lsp")
        end,
      },
      {
        "zeioth/garbage-day.nvim",
        event = "LspAttach",
        opts = {
          aggressive_mode = false,
          excluded_lsp_clients = {
            "gopls",
            "rust_analyzer",
            "taplo",
          },
          grace_period = 60 * 15,
          wakeup_delay = 500,
        },
        dependencies = {
          "neovim/nvim-lspconfig",
        },
      },
      {
        "amrbashir/nvim-docs-view",
        cmd = "DocsViewToggle",
        opts = {
          position = "top", -- "right",
          width = 60,
          height = 10,
        },
      },
      {
        "j-hui/fidget.nvim",
        event = "VeryLazy",
        config = function()
          require("plugins.fidget")
        end,
      },
      {
        -- conform.nvim: Override formatters (let LazyVim manage format-on-save via <leader>uf)
        "stevearc/conform.nvim",
        enabled = false,
        event = "VeryLazy",
        ---@module 'conform'
        ---@class conform.setupOpts
        opts = {
          formatters = {
            goimports_rereviser = {
              meta = {
                url = "https://github.com/zchee/goimports-rereviser",
                description = "Right imports sorting & code formatting tool (reviser of goimports-reviser)",
              },
              command = "goimports-rereviser",
              args = { "-use-cache=true", "-cache-fast-skip=true", "-rm-unused", "-set-alias", "-format", "$FILENAME" }, -- , "-project-name=github.com/zchee/pandaemonium"
              stdin = false,
            },
            stylua = {
              command = "/opt/homebrew/bin/stylua",
              env = {
                YAMLFIX_SEQUENCE_STYLE = "block_style",
              },
            },
          },
          formatters_by_ft = {
            ---@diagnostic disable: assign-type-mismatch: push
            go = { "goimports_rereviser", lsp_format = "first" },
            goasm = { "asmfmt", lsp_format = "first" },
            lua = { "stylua", lsp_format = "never" },
            python = { "ruff_format", "ruff_fix" }, -- , "ruff_organize_imports"
            rust = { "rustfmt" },
            zig = { "zigfmt" },
            toml = false,
            typescript = false,
            javascript = false,
            typescriptreact = false,
            javascriptreact = false,
            terraform = { "terraform_fmt" },
            bash = { "shfmt" },
            sh = { "shfmt" },
            yaml = false,
            json = false,
            markdown = false,
            ---@diagnostic enable: assign-type-mismatch: pop
          },
          format_on_save = {
            -- I recommend these options. See :help conform.format for details.
            lsp_format = "fallback",
            timeout_ms = 500,
          },
        },
      },
      {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        dependencies = {
          "nvimtools/none-ls-extras.nvim",
          "nvim-lua/plenary.nvim",
        },
        config = function()
          require("plugins.null-ls")
        end,
      },
      {
        "stevearc/aerial.nvim",
        event = "VeryLazy",
        dependencies = {
          "folke/snacks.nvim",
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        },
        config = function()
          require("plugins.aerial")
          vim.keymap.set("n", "<Space>o", function()
            require("aerial").snacks_picker({ layout = { preset = "sidebar", preview = "main" } })
          end, { desc = "Symbols" })
        end,
      },
    },
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
      },
      {
        "hrsh7th/cmp-buffer",
      },
      {
        "hrsh7th/cmp-path",
      },
      {
        "hrsh7th/cmp-cmdline",
      },
      {
        "dmitmel/cmp-cmdline-history",
      },
      {
        "hrsh7th/cmp-nvim-lsp-document-symbol",
      },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
      },
      {
        "petertriho/cmp-git",
      },
      {
        "tamago324/cmp-zsh",
        opts = {
          zshrc = true,
          filetypes = { "zsh" },
        },
      },
      -- {
      -- 	"chrisgrieser/nvim-lsp-endhints",
      -- 	event = "LspAttach",
      -- 	opts = {
      -- 		icons = {
      -- 			type = "󰜁 ",
      -- 			parameter = "󰏪 ",
      -- 			offspec = " ",
      -- 			unknown = " ",
      -- 		},
      -- 		label = {
      -- 			padding = 1,
      -- 			marginLeft = 0,
      -- 			bracketedParameters = true,
      -- 		},
      -- 		autoEnableHints = true,
      -- 	},
      -- },
      {
        "onsails/lspkind-nvim",
      },
      {
        "SmiteshP/nvim-navic",
      },
      {
        "ray-x/cmp-treesitter",
      },
      {
        "echasnovski/mini.pairs",
      },
      {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
      },
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          {
            "saadparwaiz1/cmp_luasnip",
          },
        },
        build = "make install_jsregexp",
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            "lazy.nvim",
            "none-ls.nvim",
            {
              path = "${3rd}/luv/library",
              words = { "vim%.uv" },
            },
            "plenary.nvim",
            vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/busted/library"),
            vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/luassert/library"),
            vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/luvit/library"),
          },
        },
      },
      {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
      },
      {
        "echasnovski/mini.icons",
      },
      {
        "zbirenbaum/copilot-cmp",
        dependencies = {
          {
            "zbirenbaum/copilot.lua",
            opts = {
              filetypes = {
                ["*"] = false,
                go = true,
              },
              panel = { enabled = false },
              suggestion = {
                enabled = false,
                auto_trigger = false,
                keymap = {
                  accept = "<C-j>",
                  accept_word = "<M-k>",
                  accept_line = "<M-j>",
                  next = "<M-]>",
                  prev = "<M-[>",
                  dismiss = "<C-]>",
                },
              },
              --
              -- copilot_node_command = util.homebrew_binary("node", "node"),
              -- server = {
              --   type = "nodejs",
              --   -- custom_server_filepath = "/opt/local/lib/node_modules/@github/copilot-language-server/dist/language-server.js",
              --   custom_server_filepath = vim.fs.joinpath(
              --     util.getenv("BUN_INSTALL"),
              --     "install/global/node_modules/@github/copilot-language-server/dist/language-server.js"
              --   ),
              -- },
            },
            copilot_model = "gpt-41-copilot",
          },
        },
        config = function()
          -- require("plugins.copilot")
          require("copilot_cmp").setup({
            event = { "InsertEnter", "LspAttach" },
            fix_pairs = false,
          })
        end,
      },
      -- {
      --   "zbirenbaum/copilot.lua",
      --   event = "InsertEnter",
      --   build = "bun i -g @github/copilot-language-server@latest",
      --   config = function()
      --     require("plugins.copilot")
      --   end,
      -- },
    },
    config = function()
      require("plugins.cmp")
    end,
  },
  -- {
  --   {
  --     "saghen/blink.cmp",
  --     lazy = false,
  --     event = "InsertEnter",
  --     build = "RUSTFLAGS='-C target-cpu=apple-m3 -C opt-level=3 -C force-frame-pointers=on -C debug-assertions=off -C incremental=on -C overflow-checks=off -C link-arg=-undefined -C link-arg=dynamic_lookup' cargo build -v --release",
  --     dependencies = {
  --       -- sources
  --       {
  --         "L3MON4D3/LuaSnip",
  --         build = "make install_jsregexp",
  --       },
  --       "fang2hou/blink-copilot",
  --       {
  --         "zbirenbaum/copilot.lua",
  --       },
  --       "echasnovski/mini.icons",
  --       "nvim-tree/nvim-web-devicons",
  --       "windwp/nvim-autopairs",
  --       "ray-x/lsp_signature.nvim",
  --       {
  --         "b0o/schemastore.nvim",
  --         ft = { "json", "yaml" },
  --       },
  --     },
  --     config = function()
  --       require("plugins.blink")
  --     end,
  --     opts_extend = { "sources.default" }
  --   },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = "bun i -g @github/copilot-language-server@latest",
  --   opts = {
  --     panel = { enabled = false },
  --     suggestion = { enabled = false },
  --     filetypes = {
  --       -- ["*"] = false,
  --       help = false,
  --       markdown = true,
  --       sh = false,
  --     },
  --     copilot_node_command = util.homebrew_binary("node", "node"),
  --     server = {
  --       type = "nodejs",
  --       custom_server_filepath = vim.fs.joinpath(
  --         util.getenv("BUN_INSTALL"),
  --         "install/global/node_modules/@github/copilot-language-server/dist/language-server.js"),
  --     },
  --     copilot_model = "gpt-4o-copilot",
  --     server_opts_overrides = {
  --       autostart = false,
  --       trace = "off",
  --       init_options = {
  --         github = {
  --           copilot = {
  --             selectedCompletionModel = "gpt-4o-copilot",
  --           },
  --         },
  --         enableAutoCompletions = false,
  --         inlineSuggest = {
  --           enable = false,
  --         },
  --         editor = {
  --           showEditorCompletions = false,
  --           enableAutoCompletions = false,
  --           delayCompletions = false,
  --           -- filterCompletions = ["editor", "filterCompletions"],
  --         },
  --         advanced = {
  --           displayStyle = "node",
  --           -- secretKey = ["advanced", "secret_key"],
  --           length = 0,
  --           -- stops = ["advanced", "stops"],
  --           -- temperature = ["advanced", "temperature"],
  --           -- topP = ["advanced", "top_p"],
  --           indentationMode = false,
  --           inlineSuggestCount = 0,   -- #completions for getCompletions
  --           listCount = 0,            -- #completions for panel
  --           -- debugOverrideProxyUrl = ["advanced", "debug.overrideProxyUrl"],
  --           -- debugTestOverrideProxyUrl = ["advanced", "debug.testOverrideProxyUrl"],
  --           -- debugEnableGitHubTelemetry = ["advanced", "debug.githubCTSIntegrationEnabled"],
  --           -- debugOverrideEngine = ["advanced", "debug.overrideEngine"],
  --           -- debugShowScores = ["advanced", "debug.showScores"],
  --           -- debugOverrideLogLevels = ["advanced", "debug.overrideLogLevels"],
  --           -- debugFilterLogCategories = ["advanced", "debug.filterLogCategories"],
  --           -- debugUseSuffix = ["advanced", "debug.useSuffix"],
  --           -- debugAcceptSelfSignedCertificate = ["advanced", "debug.acceptSelfSignedCertificate"]
  --         },
  --       },
  --     },
  --   },
  -- },
  --   {
  --     "saghen/blink.compat",
  --   },
  --   {
  --     "folke/lazydev.nvim",
  --     opts = {
  --       library = {
  --         "lazy.nvim",
  --         {
  --           path = "${3rd}/luv/library",
  --           words = { "vim%.uv" },
  --         },
  --       },
  --       integrations = {
  --         lspconfig = true,
  --         cmp = true,
  --         coq = false,
  --       },
  --     },
  --   },
  -- },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("plugins.comment")
    end,
  },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapClearBreakpoints",
      "DapContinue",
      "DapDisconnect",
      "DapEval",
      "DapInstall",
      "DapNew",
      "DapPause",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapUninstall",
      "DapVirtualTextDisable",
      "DapVirtualTextEnable",
      "DapVirtualTextForceRefresh",
      "DapVirtualTextToggle",
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "LiadOz/nvim-dap-repl-highlights",
      "leoluz/nvim-dap-go",
      "jay-babu/mason-nvim-dap.nvim",
      "jbyuki/one-small-step-for-vimkind",
      "nvim-neotest/nvim-nio",
      "docker/nvim-dap-docker",
    },
    config = function()
      require("plugins.dap")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "TSInstallInfo",
    },
    build = ":TSUpdate",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "yamatsum/nvim-nonicons",
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      require("plugins.treesitter_compat").patch_query_predicates()
    end,
    config = function()
      require("plugins.tree-sitter")
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "matheusfillipe/grep_app.nvim",
      "nvim-telescope/telescope-ghq.nvim",
    },
    config = function()
      require("plugins.telescope")
    end,
  },

  -- UI
  {
    {
      "folke/snacks.nvim",
      lazy = false,
      config = function()
        require("plugins.snacks")
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "folke/snacks.nvim",
      },
      config = function()
        require("plugins.neo-tree")
      end,
    },
    {
      -- overlook.nvim: Code peek in floating popups
      "WilliamHsieh/overlook.nvim",
      event = "LspAttach",
      keys = {
        {
          "<leader>pd",
          function()
            require("overlook").open_definition()
          end,
          desc = "Peek Definition",
        },
        {
          "<leader>pc",
          function()
            require("overlook").close_all()
          end,
          desc = "Close All Popups",
        },
        {
          "<leader>pu",
          function()
            require("overlook").restore_one()
          end,
          desc = "Restore Last Popup",
        },
        {
          "<leader>pU",
          function()
            require("overlook").restore_all()
          end,
          desc = "Restore All Popups",
        },
        {
          "<leader>pf",
          function()
            require("overlook").toggle_focus()
          end,
          desc = "Toggle Focus",
        },
        {
          "<leader>ps",
          function()
            require("overlook").open_in_split()
          end,
          desc = "Open in Split",
        },
        {
          "<leader>pv",
          function()
            require("overlook").open_in_vsplit()
          end,
          desc = "Open in VSplit",
        },
        {
          "<leader>po",
          function()
            require("overlook").open_in_original()
          end,
          desc = "Open in Original",
        },
      },
      opts = {
        border = "rounded",
        max_width = 100,
        max_height = 20,
      },
    },
    {
      -- oil.nvim: File explorer (custom plugin, not a LazyVim extra)
      "stevearc/oil.nvim",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      opts = {
        default_file_explorer = true,
        columns = {
          "icon",
          "permissions",
          "size",
          "mtime",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
        },
        float = {
          padding = 2,
          max_width = 120,
          max_height = 40,
          border = "rounded",
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-s>"] = "actions.select_split",
          ["-"] = "actions.parent",
          ["g."] = "actions.toggle_hidden",
        },
      },
      keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
        { "<leader>e", "<cmd>Oil<cr>", desc = "File Explorer (Oil)" },
      },
    },
    {
      "folke/edgy.nvim",
      event = "VeryLazy",
      ---@module 'edgy'
      ---@param opts Edgy.Config
      opts = function(_, opts)
        for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
          opts[pos] = opts[pos] or {}
          table.insert(opts[pos], {
            ft = "snacks_terminal",
            size = { height = 0.4 },
            title = "%{b:snacks_terminal.id}: %{b:term_title}",
            filter = function(_, win)
              return vim.w[win].snacks_win
                and vim.w[win].snacks_win.position == pos
                and vim.w[win].snacks_win.relative == "editor"
                and not vim.w[win].trouble_preview
            end,
          })
        end
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("plugins.lualine")
      end,
    },
    -- {
    --   -- incline.nvim: Floating statusline (replaces lualine)
    --   "b0o/incline.nvim",
    --   event = "VeryLazy",
    --   dependencies = { "nvim-tree/nvim-web-devicons" },
    --   config = function()
    --     local devicons = require("nvim-web-devicons")
    --
    --     require("incline").setup({
    --       window = {
    --         padding = 0,
    --         margin = { horizontal = 0, vertical = 0 },
    --         placement = { horizontal = "right", vertical = "bottom" },
    --       },
    --       hide = { cursorline = false, focused_win = false, only_win = false },
    --       render = function(props)
    --         local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    --         if filename == "" then
    --           filename = "[No Name]"
    --         end
    --
    --         local ft_icon, ft_color = devicons.get_icon_color(filename)
    --         local modified = vim.bo[props.buf].modified
    --
    --         -- Show parent dir for generic filenames
    --         local generic_names = { "init.lua", "index.ts", "index.js", "mod.rs", "main.go", "main.rs", "lib.rs" }
    --         local display_name = filename
    --         for _, name in ipairs(generic_names) do
    --           if filename == name then
    --             local full_path = vim.api.nvim_buf_get_name(props.buf)
    --             local parent = vim.fn.fnamemodify(full_path, ":h:t")
    --             display_name = parent .. "/" .. filename
    --             break
    --           end
    --         end
    --
    --         -- Diagnostics
    --         local diagnostics = {}
    --         local diag_counts = {
    --           error = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.ERROR }),
    --           warn = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity.WARN }),
    --         }
    --
    --         local has_diagnostics = diag_counts.error > 0 or diag_counts.warn > 0
    --         local text_hl = has_diagnostics and (diag_counts.error > 0 and "DiagnosticError" or "DiagnosticWarn")
    --             or (props.focused and "Normal" or "Comment")
    --
    --         if diag_counts.error > 0 then
    --           table.insert(diagnostics, { "  ", guifg = "#f38ba8" })
    --           table.insert(diagnostics, { tostring(diag_counts.error), guifg = "#f38ba8" })
    --         end
    --         if diag_counts.warn > 0 then
    --           table.insert(diagnostics, { "  ", guifg = "#f9e2af" })
    --           table.insert(diagnostics, { tostring(diag_counts.warn), guifg = "#f9e2af" })
    --         end
    --
    --         local res = { guibg = props.focused and "#1e1e2e" or "#11111b", { " " } }
    --
    --         if ft_icon then
    --           table.insert(res, { ft_icon, guifg = ft_color })
    --           table.insert(res, { " " })
    --         end
    --
    --         table.insert(res, { display_name, gui = modified and "bold,italic" or "bold", group = text_hl })
    --
    --         if modified then
    --           table.insert(res, { " ", guifg = "#fab387" })
    --         end
    --
    --         for _, diag in ipairs(diagnostics) do
    --           table.insert(res, diag)
    --         end
    --
    --         table.insert(res, { " " })
    --         return res
    --       end,
    --     })
    --   end,
    -- },
    -- {
    --   -- modes.nvim: Cursorline color indicates mode
    --   "mvllow/modes.nvim",
    --   event = "VeryLazy",
    --   config = function()
    --     require("modes").setup({
    --       colors = {
    --         bg = "",
    --         copy = "#f5c359",
    --         delete = "#c75c6a",
    --         insert = "#78ccc5",
    --         visual = "#9745be",
    --       },
    --       line_opacity = 0.25,
    --       set_cursor = true,
    --       set_cursorline = true,
    --       set_number = true,
    --       ignore = { "NvimTree", "TelescopePrompt", "oil", "lazy", "Avante", "AvanteInput", "snacks_dashboard" },
    --     })
    --   end,
    -- },
    {
      "akinsho/bufferline.nvim",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("plugins.bufferline")
      end,
    },
    {
      "SuperBo/fugit2.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        {
          "chrisgrieser/nvim-tinygit",
          dependencies = {
            {
              "stevearc/dressing.nvim",
            },
          },
        },
      },
      cmd = {
        "Fugit2",
        "Fugit2Blame",
        "Fugit2Diff",
        "Fugit2Graph",
      },
      keys = {
        { "<Space>g", mode = "n", "<cmd>Fugit2<cr>" },
      },
      ---@module 'fugit2'
      ---@type Fugit2Config
      opts = {
        width = 100,
        min_width = 50,
        content_width = 60,
        max_width = "80%",
        height = "60%",
        external_diffview = true,
        blame_priority = 1,
        blame_info_height = 10,
        blame_info_width = 60,
        show_patch = false,
        libgit2_path = vim.fs.joinpath(util.homebrew_prefix(), "opt/libgit2/lib/libgit2.dylib"),
        gpgme_path = vim.fs.joinpath(util.homebrew_prefix(), "opt/gpgme/lib/libgpgme.dylib"),
        command_timeout = 15000,
      },
    },
    {
      "sindrets/diffview.nvim",
      cmd = {
        "DiffviewFileHistory",
        "DiffviewOpen",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
      },
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (working tree)" },
        { "<leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff vs previous commit" },
        { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
        { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
        { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
        { "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff vs main branch" },
        { "<leader>gM", "<cmd>DiffviewOpen master...HEAD<cr>", desc = "Diff vs master branch" },
        { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Staged changes" },
        { "<leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle file panel" },
      },
      config = function()
        local actions = require("diffview.actions")
        require("diffview").setup({
          enhanced_diff_hl = true,
          use_icons = true,
          view = {
            default = {
              layout = "diff2_horizontal",
              winbar_info = true,
            },
            merge_tool = {
              layout = "diff3_horizontal",
              disable_diagnostics = true,
            },
            file_history = {
              layout = "diff2_horizontal",
              winbar_info = true,
            },
          },
          file_panel = {
            listing_style = "tree",
            tree_options = { flatten_dirs = true },
            win_config = { position = "left", width = 35 },
          },
          keymaps = {
            view = {
              { "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
              { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
              { "n", "gf", actions.goto_file_edit, { desc = "Open file" } },
              { "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
              { "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
              { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose ours" } },
              { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
              { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose base" } },
              { "n", "dx", actions.conflict_choose("none"), { desc = "Delete conflict" } },
            },
            file_panel = {
              { "n", "j", actions.next_entry, { desc = "Next entry" } },
              { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
              { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
              { "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
              { "n", "s", actions.toggle_stage_entry, { desc = "Stage/unstage" } },
              { "n", "S", actions.stage_all, { desc = "Stage all" } },
              { "n", "U", actions.unstage_all, { desc = "Unstage all" } },
              { "n", "X", actions.restore_entry, { desc = "Restore entry" } },
              { "n", "L", actions.open_commit_log, { desc = "Open commit log" } },
              { "n", "g?", actions.help("file_panel"), { desc = "Help" } },
            },
          },
        })
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      event = "VeryLazy",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("plugins.gitsigns")
      end,
    },
    {
      "RRethy/vim-illuminate",
      event = "BufRead",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("plugins.illuminate")
      end,
    },
    {
      "petertriho/nvim-scrollbar",
      event = "VeryLazy",
      config = function()
        require("plugins.scrollbar")
      end,
    },
    {
      "kevinhwang91/nvim-bqf",
      ft = "qf",
      config = function()
        require("plugins.bqf")
      end,
    },
    {
      "folke/todo-comments.nvim",
      event = "BufRead",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      opts = require("plugins.todo-comment"),
    },
    {
      dir = util.src_path("github.com/zchee/codecov.nvim"),
      event = "VeryLazy",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        require("codecov").setup({
          coverage = {
            enabled = true,
            autostart = false,
            colors = {
              covered = "#21B577", -- rgb(33,181,119)
              partial = "#F4B01B", -- rgb(244,176,27)
              missed = "#F52020", -- rgb(245,32,32)
            },
            signs = {
              covered = "▎",
              partial = "▎",
              missed = "▎",
            },
            priority = 10,
          },
          api = {
            git_provider = "github",
            url = "https://api.codecov.io",
            timeout_ms = 10000,
          },
          token = os.getenv("CODECOV_NVIM_API_TOKEN"),
          ---@type vim.log.levels
          log_level = 2,
        })
      end,
    },
  },

  -- Operator
  {
    {
      "kana/vim-operator-replace",
      event = "VeryLazy",
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "rhysd/vim-operator-surround",
      event = "VeryLazy",
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "mopp/vim-operator-convert-case",
      event = "VeryLazy",
      config = function()
        vim.g.switch_mapping = ""
        vim.g.switch_custom_definitions = {
          { 1, 0 },
          { "v:true", "v:false" },
          { "yes", "no" },
          { "on", "off" },
          { "ON", "OFF" },
          { "static", "dynamic" },
        }
      end,
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "AndrewRadev/switch.vim",
      event = "VeryLazy",
    },
    {
      "junegunn/vim-easy-align",
      cmd = {
        "EasyAlign",
      },
    },
    {
      "tyru/open-browser.vim",
      event = "VeryLazy",
    },
    {
      "tkmpypy/chowcho.nvim",
      event = "VeryLazy",
      config = function()
        require("plugins.chowcho")
      end,
    },
  },

  -- Language
  {
    {
      -- Go
      -- {
      --   "ray-x/go.nvim",
      --   disable = true,
      --   dependencies = {
      --     "ray-x/guihua.lua",
      --     "neovim/nvim-lspconfig",
      --     "nvim-treesitter/nvim-treesitter",
      --   },
      --   ft = { "go", "gomod" },
      --   opts = function()
      --     require("go").setup({
      --       disable_defaults = true, -- true|false when true set false to all boolean settings and replace all tables
      --       remap_commands = {},     -- Vim commands to remap or disable, e.g. `{ GoFmt = "GoFormat", GoDoc = false }`
      --       -- settings with {}; string will be set to ''. user need to setup ALL the settings
      --       -- It is import to set ALL values in your own config if set value to true otherwise the plugin may not work
      --       go = "go", -- go command, can be go[default] or e.g. go1.18beta1
      --       goimports = "gopls", -- goimports command, can be gopls[default] or either goimports or golines if need to split long lines
      --       gofmt = "gopls", -- gofmt through gopls: alternative is gofumpt, goimports, golines, gofmt, etc
      --       fillstruct = "gopls", -- set to fillstruct if gopls fails to fill struct
      --       max_line_len = 0, -- max line length in golines format, Target maximum line length for golines
      --       tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
      --       tag_options = "json=omitzero", -- sets options sent to gomodifytags, i.e., json=omitempty
      --       gotests_template = "", -- sets gotests -template parameter (check gotests for details)
      --       gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
      --       gotest_case_exact_match = true, -- true: run test with ^Testname$, false: run test with TestName
      --       comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. 󰟓       
      --       icons = { breakpoint = "🧘", currentpos = "🏃" }, -- setup to `false` to disable icons setup
      --       verbose = false, -- output loginf in messages
      --       lsp_semantic_highlights = false, -- use highlights from gopls, disable by default as gopls/nvim not compatible
      --       lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
      --       -- false: do nothing
      --       -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
      --       -- lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
      --       lsp_gofumpt = true,  -- true: set default gofmt in gopls format to gofumpt. false: do not set default gofmt in gopls format to gofumpt
      --       lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua. when lsp_cfg is true if lsp_on_attach is a function: use this function as on_attach function for gopls
      --       lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
      --       lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
      --       -- function(bufnr)
      --       --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
      --       -- end
      --       -- to setup a table of codelens
      --       golangci_lint = {
      --         default = "standard", -- set to one of { "standard", "fast", "all", "none" }
      --         -- disable = {'errcheck', 'staticcheck'}, -- linters to disable empty by default
      --         -- enable = {'govet', 'ineffassign','revive', 'gosimple'}, -- linters to enable; empty by default
      --         config = nil,                                                                -- set to a config file path
      --         no_config = false,                                                           -- true: golangci-lint --no-config
      --         -- disable = {},     -- linters to disable empty by default, e.g. {'errcheck', 'staticcheck'}
      --         enable = {},                                                                 -- linters to enable; empty by default, set to e.g. {'govet', 'ineffassign','revive', 'gosimple'}
      --         -- enable_only = {}, -- linters to enable only; empty by default, set to e.g. {'govet', 'ineffassign','revive', 'gosimple'}
      --         severity = vim.diagnostic.severity.INFO,                                     -- severity level of the diagnostics
      --       },
      --       null_ls = {                                                                    -- check null-ls integration in readme
      --         golangci_lint = {
      --           method = { "NULL_LS_DIAGNOSTICS_ON_SAVE", "NULL_LS_DIAGNOSTICS_ON_OPEN" }, -- when it should run
      --           severity = vim.diagnostic.severity.INFO,                                   -- severity level of the diagnostics
      --         },
      --         gotest = {
      --           method = { "NULL_LS_DIAGNOSTICS_ON_SAVE" }, -- when it should run
      --           severity = vim.diagnostic.severity.WARN,    -- severity level of the diagnostics
      --         },
      --       },
      --       diagnostic = false, -- set to table to customize vim.diagnostic.config setup
      --       -- example setup:
      --       -- diagnostic = {  -- set diagnostic to false to disable vim.diagnostic.config setup,
      --       -- true: default nvim setup
      --       -- hdlr = false, -- hook lsp diag handler and send diag to quickfix
      --       -- underline = true,
      --       -- virtual_text = { spacing = 2, prefix = '' }, -- virtual text setup
      --       -- signs = {'', '', '', ''},  -- set to true to use default signs, an array of 4 to specify custom signs
      --       -- update_in_insert = false,
      --       -- },
      --       -- set to false/nil: disable config gopls diagnostic
      --
      --       -- if you need to setup your ui for input and select, you can do it here
      --       -- go_input = require('guihua.input').input -- set to vim.ui.input to disable guihua input
      --       -- go_select = require('guihua.select').select -- vim.ui.select to disable guihua select
      --       lsp_document_formatting = true,
      --       -- set to true: use gopls to format
      --       -- false if you want to use other formatter tool(e.g. efm, nulls)
      --       lsp_inlay_hints = {
      --         enable = false,         -- this is the only field apply to neovim > 0.10
      --       },
      --       gopls_cmd = nil,          -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
      --       gopls_remote_auto = true, -- add -remote=auto to gopls
      --       gocoverage_sign = "█",
      --       sign_priority = 0,        -- change to a higher number to override other signs
      --       dap_debug = true,         -- set to false to disable dap
      --       dap_debug_keymap = true,  -- true: use keymap for debugger defined in go/dap.lua
      --       -- false: do not use keymap in go/dap.lua.  you must define your own.
      --       -- Windows: Use Visual Studio keymap
      --       dap_debug_gui = {}, -- bool|table put your dap-ui setup here set to false to disable
      --       dap_debug_vt = {    -- bool|table put your dap-virtual-text setup here set to false to disable
      --         enabled = true,
      --         enabled_commands = true,
      --         all_frames = true,
      --       },
      --       dap_port = 38697,          -- can be set to a number, if set to -1 go.nvim will pick up a random port
      --       dap_timeout = 15,          --  see dap option initialize_timeout_sec = 15,
      --       dap_retries = 20,          -- see dap option max_retries
      --       dap_enrich_config = nil,   -- see dap option enrich_config
      --       build_tags = "",           -- set default build tags
      --       textobjects = true,        -- enable default text objects through treesittter-text-objects
      --       test_runner = "gotestsum", -- one of {"go", "dlv", "ginkgo", "gotestsum"}
      --       verbose_tests = true,      -- set to add verbose flag to tests deprecated, see '-v' option
      --       run_in_floaterm = false,   -- set to true to run in a float window. :GoTermClose closes the floatterm. float term recommend if you use gotestsum ginkgo with terminal color
      --       floaterm = {               -- position
      --         posititon = "auto",      -- one of {"top", "bottom", "left", "right", "center", "auto"}
      --         width = 0.45,            -- width of float window if not auto
      --         height = 0.98,           -- height of float window if not auto
      --         title_colors = "nord",   -- default to nord, one of {"nord", "tokyo", "dracula", "rainbow", "solarized ", "monokai"}. can also set to a list of colors to define colors to choose from e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
      --         -- title_colors = {"#D8DEE9", "#5E81AC", "#88C0D0", "#EBCB8B", "#A3BE8C", "#B48EAD"}
      --       },
      --       trouble = false,                                                             -- true: use trouble to open quickfix
      --       test_efm = false,                                                            -- errorfomat for quickfix, default mix mode, set to true will be efm only
      --       luasnip = false,                                                             -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
      --       --  Do not enable this if you already added the path, that will duplicate the entries
      --       on_jobstart = function(cmd) _ = cmd end,                                     -- callback for stdout
      --       on_stdout = function(err, data) _, _ = err, data end,                        -- callback when job started
      --       on_stderr = function(err, data) _, _ = err, data end,                        -- callback for stderr
      --       on_exit = function(code, signal, output) _, _, _ = code, signal, output end, -- callback for jobexit, output : string
      --       iferr_vertical_shift = 4,                                                    -- defines where the cursor will end up vertically from the begining of if err statement
      --       iferr_less_highlight = false,                                                -- set to true to make 'if err != nil' statements less highlighted (grayed out)
      --     })
      --     -- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      --     -- vim.api.nvim_create_autocmd("BufWritePre", {
      --     --   pattern = "*.go",
      --     --   group = format_sync_grp,
      --     --   callback = function()
      --     --     require("go.format").goimports()
      --     --   end,
      --     -- })
      --   end,
      -- },
      -- {
      --   "cappyzawa/go-playground.nvim",
      --   ft = "go",
      --   cmd = {
      --     "GoPlayground",
      --     "GotipPlayground",
      --   },
      -- },
    },

    -- Rust
    {
      "mrcjkb/rustaceanvim",
      opts = function(_, opts)
        local prev_on_attach = opts.server and opts.server.on_attach
        opts.tools = vim.tbl_deep_extend("force", opts.tools or {}, {
          float_win_config = { border = "rounded", auto_focus = true },
          code_actions = { ui_select_fallback = true },
          rustc = { edition = "2024" },
        })
        opts.server = opts.server or {}
        opts.server.on_attach = function(client, bufnr)
          if prev_on_attach then
            prev_on_attach(client, bufnr)
          end
          local kopts = { silent = true, buffer = bufnr }
          local map = vim.keymap.set

          map("n", "<leader>ra", function()
            vim.cmd.RustLsp("codeAction")
          end, vim.tbl_extend("force", kopts, { desc = "Rust code action" }))
          map("n", "<leader>rd", function()
            vim.cmd.RustLsp("debuggables")
          end, vim.tbl_extend("force", kopts, { desc = "Rust debuggables" }))
          map("n", "<leader>rr", function()
            vim.cmd.RustLsp("runnables")
          end, vim.tbl_extend("force", kopts, { desc = "Rust runnables" }))
          map("n", "<leader>rR", function()
            vim.cmd.RustLsp({ "runnables", bang = true })
          end, vim.tbl_extend("force", kopts, { desc = "Rerun last runnable" }))
          map("n", "<leader>rt", function()
            vim.cmd.RustLsp("testables")
          end, vim.tbl_extend("force", kopts, { desc = "Rust testables" }))
          map("n", "<leader>rT", function()
            vim.cmd.RustLsp({ "testables", bang = true })
          end, vim.tbl_extend("force", kopts, { desc = "Rerun last test" }))
          map("n", "<leader>rm", function()
            vim.cmd.RustLsp("expandMacro")
          end, vim.tbl_extend("force", kopts, { desc = "Expand macro" }))
          map("n", "<leader>rc", function()
            vim.cmd.RustLsp("openCargo")
          end, vim.tbl_extend("force", kopts, { desc = "Open Cargo.toml" }))
          map("n", "<leader>rp", function()
            vim.cmd.RustLsp("parentModule")
          end, vim.tbl_extend("force", kopts, { desc = "Parent module" }))
          map("n", "<leader>rj", function()
            vim.cmd.RustLsp("joinLines")
          end, vim.tbl_extend("force", kopts, { desc = "Join lines" }))
          map("n", "<leader>rs", function()
            vim.cmd.RustLsp("ssr")
          end, vim.tbl_extend("force", kopts, { desc = "Structural search replace" }))
          map("n", "<leader>re", function()
            vim.cmd.RustLsp("explainError")
          end, vim.tbl_extend("force", kopts, { desc = "Explain error" }))
          map("n", "<leader>rD", function()
            vim.cmd.RustLsp("renderDiagnostic")
          end, vim.tbl_extend("force", kopts, { desc = "Render diagnostic" }))
          map("n", "<leader>rv", function()
            vim.cmd.RustLsp({ "view", "hir" })
          end, vim.tbl_extend("force", kopts, { desc = "View HIR" }))
          map("n", "<leader>rV", function()
            vim.cmd.RustLsp({ "view", "mir" })
          end, vim.tbl_extend("force", kopts, { desc = "View MIR" }))
          map("n", "K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, vim.tbl_extend("force", kopts, { desc = "Rust hover actions" }))
        end
        opts.server.default_settings = vim.tbl_deep_extend("force", opts.server.default_settings or {}, {
          ["rust-analyzer"] = {
            cargo = {
              allTargets = false,
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
                invocationStrategy = "once",
              },
              extraEnv = {
                CARGO_TARGET_DIR = "target/rust-analyzer",
                SKIP_WASM_BUILD = "1",
              },
            },
            procMacro = {
              enable = true,
              attributes = { enable = true },
            },
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            diagnostics = {
              enable = true,
              experimental = { enable = true },
              styleLints = { enable = true },
            },
            inlayHints = {
              enable = true,
              chainingHints = { enable = true },
              typeHints = { enable = true, hideClosureInitialization = true },
              parameterHints = { enable = true },
              closureReturnTypeHints = { enable = "with_block" },
              lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
              maxLength = 25,
              bindingModeHints = { enable = true },
              closureCaptureHints = { enable = true },
              discriminantHints = { enable = "fieldless" },
              expressionAdjustmentHints = { enable = "reborrow" },
              rangeExclusiveHints = { enable = true },
            },
            completion = {
              autoimport = { enable = true },
              postfix = { enable = true },
              callable = { snippets = "fill_arguments" },
              fullFunctionSignatures = { enable = true },
              privateEditable = { enable = true },
              hideDeprecated = true,
            },
            imports = {
              granularity = { group = "module" },
              prefix = "self",
              preferNoStd = false,
            },
            lens = {
              enable = true,
              references = {
                enable = true,
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
              },
              implementations = { enable = true },
              run = { enable = true },
              debug = { enable = true },
            },
            semanticHighlighting = {
              operator = {
                specialization = { enable = true },
              },
              punctuation = {
                enable = true,
                specialization = { enable = true },
              },
              strings = { enable = true },
            },
            hover = {
              actions = {
                enable = true,
                references = { enable = true },
                run = { enable = true },
                debug = { enable = true },
                gotoTypeDef = { enable = true },
                implementations = { enable = true },
              },
              documentation = {
                enable = true,
                keywords = { enable = true },
              },
              links = { enable = true },
            },
            typing = {
              autoClosingAngleBrackets = { enable = true },
            },
            workspace = {
              symbol = {
                search = { kind = "all_symbols" },
              },
            },
            files = {
              excludeDirs = { ".git", "node_modules", ".direnv", "target/debug/build" },
            },
          },
        })
        opts.dap = { autoload_configurations = true }
        return opts
      end,
    },
    -- {
    --   "nwiizo/cargo.nvim",
    --   -- build = "cargo build --release",
    --   ft = { "rust", "toml" },
    --   cmd = { "CargoBuild", "CargoRun", "CargoTest", "CargoCheck", "CargoClippy" },
    --   opts = { float_window = true, window_width = 0.8, window_height = 0.8 },
    --   config = true,
    -- },
    {
      "saecki/crates.nvim",
      opts = {
        completion = {
          crates = { enabled = true, max_results = 8, min_chars = 3 },
        },
        lsp = {
          enabled = true,
          on_attach = function(_, bufnr)
            local crates = require("crates")
            local opts = { silent = true, buffer = bufnr }
            local map = vim.keymap.set
            map("n", "<leader>rct", crates.toggle, vim.tbl_extend("force", opts, { desc = "Toggle crates" }))
            map("n", "<leader>rcr", crates.reload, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
            map(
              "n",
              "<leader>rcv",
              crates.show_versions_popup,
              vim.tbl_extend("force", opts, { desc = "Show versions" })
            )
            map(
              "n",
              "<leader>rcf",
              crates.show_features_popup,
              vim.tbl_extend("force", opts, { desc = "Show features" })
            )
            map(
              "n",
              "<leader>rcd",
              crates.show_dependencies_popup,
              vim.tbl_extend("force", opts, { desc = "Show dependencies" })
            )
            map("n", "<leader>rcu", crates.update_crate, vim.tbl_extend("force", opts, { desc = "Update crate" }))
            map("v", "<leader>rcu", crates.update_crates, vim.tbl_extend("force", opts, { desc = "Update crates" }))
            map("n", "<leader>rcU", crates.upgrade_crate, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
            map("v", "<leader>rcU", crates.upgrade_crates, vim.tbl_extend("force", opts, { desc = "Upgrade crates" }))
            map(
              "n",
              "<leader>rcA",
              crates.upgrade_all_crates,
              vim.tbl_extend("force", opts, { desc = "Upgrade all crates" })
            )
            map("n", "<leader>rcH", crates.open_homepage, vim.tbl_extend("force", opts, { desc = "Open homepage" }))
            map("n", "<leader>rcR", crates.open_repository, vim.tbl_extend("force", opts, { desc = "Open repository" }))
            map("n", "<leader>rcD", crates.open_documentation, vim.tbl_extend("force", opts, { desc = "Open docs.rs" }))
            map("n", "<leader>rcC", crates.open_crates_io, vim.tbl_extend("force", opts, { desc = "Open crates.io" }))
          end,
          actions = true,
          completion = true,
          hover = true,
        },
        popup = { border = "rounded", show_version_date = true, max_height = 30, min_width = 20 },
      },
    },
    {
      "mfussenegger/nvim-dap",
      opts = function(_, opts)
        local dap = require("dap")
        dap.adapters.lldb = {
          type = "executable",
          command = "/opt/homebrew/opt/llvm/bin/lldb-dap",
          name = "lldb",
        }
        dap.configurations.rust = {
          {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
            runInTerminal = false,
          },
        }
        return opts
      end,
    },

    -- marp.nvim: Markdown presentations
    {
      "nwiizo/marp.nvim",
      ft = "markdown",
      config = function()
        require("marp").setup({
          marp_command = "/opt/homebrew/opt/node/bin/node /opt/homebrew/bin/marp",
        })
      end,
    },
    -- {
    --   {
    --     'mrcjkb/rustaceanvim',
    --     lazy = false,
    --     confio = function()
    --       require("plugins.rustaceanvim")
    --     end,
    --   },
    --   {
    --     "saecki/crates.nvim",
    --     config = function()
    --       require("crates").setup({
    --         lsp = {
    --           enabled = false,
    --           -- on_attach = function(client, bufnr)
    --           --   -- the same on_attach function as for your other language servers
    --           --   -- can be ommited if you're using the `LspAttach` autocmd
    --           -- end,
    --           actions = true,
    --           completion = true,
    --           hover = true,
    --         },
    --         completion = {
    --           cmp = {
    --             use_custom_kind = true,
    --             -- optionally change the text and highlight groups
    --             kind_text = {
    --               version = "Version",
    --               feature = "Feature",
    --             },
    --             kind_highlight = {
    --               version = "CmpItemKindVersion",
    --               feature = "CmpItemKindFeature",
    --             },
    --           },
    --         },
    --       })
    --     end,
    --   },
    -- },

    -- Markdown
    {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = {
          "markdown",
          "Avante",
          "codecompanion",
          "copilot-chat",
        },
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "echasnovski/mini.icons",
        },
        config = function()
          require("plugins.render-markdown")
        end,
      },
      {
        "3rd/diagram.nvim",
        lazy = true,
        cmd = { "DiagramToggle" },
        dependencies = {
          {
            "nvim-treesitter/nvim-treesitter",
          },
          {
            "3rd/image.nvim",
            opts = {
              backend = "kitty",
              processor = "magick_cli",
              integrations = {
                markdown = {
                  enabled = true,
                  clear_in_insert_mode = false,
                  download_remote_images = true,
                  only_render_image_at_cursor = true,
                  only_render_image_at_cursor_mode = "popup",
                  floating_windows = true, -- if true, images will be rendered in floating markdown windows
                  filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
                },
              },
              neorg = {
                enabled = false,
                filetypes = { "norg" },
              },
              typst = {
                enabled = false,
                filetypes = { "typst" },
              },
              html = {
                enabled = false,
              },
              css = {
                enabled = false,
              },
            },
            max_width = 800,
            max_height = 600,
            max_width_window_percentage = nil,
            max_height_window_percentage = 50,
            window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = {
              "cmp_menu",
              "cmp_docs",
              "snacks_picker_input",
              "snacks_notif",
              "scrollview",
              "scrollview_sign",
            },
            editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
            hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
          },
        },
        config = function()
          require("diagram").setup({
            events = {
              render_buffer = { "BufWinEnter", "InsertLeave", "TextChanged" },
              clear_buffer = { "BufLeave" },
            },
            integrations = {
              require("diagram.integrations.markdown"),
              -- require("diagram.integrations.neorg"),
            },
            renderer_options = {
              mermaid = {
                background = "#010101",
                theme = "dark",
                scale = 2,
                width = 800, -- nil | 800 | 400 | ...
                height = 600, -- nil | 600 | 300 | ...
              },
              plantuml = {
                charset = "utf-8",
              },
              d2 = {
                theme_id = 1,
                dark_theme_id = nil,
                scale = nil,
                layout = nil,
                sketch = nil,
              },
              gnuplot = {
                font = nil, -- nil | "Arial,12" | ...
                theme = "dark",
                size = "800,600",
              },
            },
          })
        end,
      },
      {
        "wallpants/github-preview.nvim",
        lazy = true,
        build = "bun i && git reset --hard",
        ft = { "markdown" },
        cmd = {
          "GithubPreviewToggle",
          "GithubPreviewStart",
          "GithubPreviewStop",
        },
        config = function()
          require("plugins.github-preview")
        end,
      },
    },

    -- Git
    {
      {
        "rhysd/vim-syntax-codeowners",
        ft = "codeowners",
      },
    },

    -- JSON
    {
      "VPavliashvili/json-nvim",
      ft = "json",
    },

    -- Zig
    {
      {
        "ziglang/zig.vim",
        lazy = false,
      },
    },

    -- Helm
    {
      {
        "towolf/vim-helm",
        ft = "helm",
      },
    },

    -- graphql
    {
      {
        "jparise/vim-graphql",
        ft = "graphql",
      },
    },

    -- tmux
    {
      "ericpruitt/tmux.vim",
      ft = "tmux",
    },

    -- Zsh
    {
      "chrisbra/vim-zsh",
      ft = "zsh",
    },
  },

  -- Utilities
  {
    {
      "zchee/accelerated-jk.nvim",
      lazy = false,
      keys = {
        { "j", "<Plug>(accelerated_jk_gj)", mode = "n", nowait = true, silent = true },
        { "k", "<Plug>(accelerated_jk_gk)", mode = "n", nowait = true, silent = true },
      },
      opts = {
        mode = "time_driven",
        enable_deceleration = true,
        acceleration_motions = {},
        acceleration_limit = 500, ---@default: 150
        acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 }, -- { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 }, { 1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 },
        deceleration_table = { { 200, 3 }, { 300, 7 }, { 450, 11 }, { 600, 15 }, { 750, 21 }, { 900, 9999 } }, ---@default
      },
    },
    {
      "folke/trouble.nvim",
      event = "VeryLazy",
      opts = {
        auto_close = true,
        auto_preview = true,
        focus = true,
      },
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      dependencies = {
        "echasnovski/mini.icons",
      },
      ---@module 'wk'
      ---@class wk.Opts
      opts = {
        preset = "modern",
        delay = function(ctx)
          return ctx.plugin and 0 or 1000
        end,
        ---@param mapping wk.Mapping
        filter = function(mapping)
          -- return mapping.desc and mapping.desc ~= ""
          _ = mapping
          return true
        end,
        ---@type wk.Spec
        spec = {},
        notify = true,
        ---@type wk.Spec
        triggers = {
          {
            "<auto>",
            mode = "nxso",
          },
        },
        ---@param ctx { mode: string, operator: string }
        defer = function(ctx)
          return ctx.mode == "V" or ctx.mode == "<C-V>"
        end,
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        ---@type wk.Win.opts
        win = {
          relative = "editor",
          style = "minimal",
          focusable = false,
          noautocmd = true,
          -- width = 1,
          -- height = { min = 4, max = 25 },
          -- wo = {
          --   -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
          -- },
          -- bo = {},
          -- col = 0,
          -- row = math.huge,
          -- border = "none",
          padding = { 1, 2 },
          no_overlap = true,
          title = true,
          title_pos = "center",
          -- zindex = 1000,
        },
        layout = {
          width = {
            min = 50,
          },
          spacing = 3,
        },
        keys = {
          scroll_down = "<c-d>",
          scroll_up = "<c-u>",
        },
        ---@type (string|wk.Sorter)[]
        sort = {
          "local",
          "order",
          "group",
          "alphanum",
          "mod",
          "manual",
          "case",
        },
        ---@type number|fun(node: wk.Node):boolean?
        expand = 0,
        -- expand = function(node)
        --   return not node.desc -- expand all nodes without a description
        -- end,
        ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
        replace = {
          key = {
            function(key)
              return require("which-key.view").format(key)
            end,
          },
          desc = {
            { "<Plug>%(?(.*)%)?", "%1" },
            { "^%+", "" },
            { "<[cC]md>", "" },
            { "<[cC][rR]>", "" },
            { "<[sS]ilent>", "" },
            { "^lua%s+", "" },
            { "^call%s+", "" },
            { "^:%s*", "" },
          },
        },
        icons = {
          breadcrumb = "»",
          separator = "➜",
          group = "+",
          ellipsis = "…",
          mappings = true,
          ---@type wk.IconRule[]|false
          rules = {},
          colors = true,
          keys = {
            Up = " ",
            Down = " ",
            Left = " ",
            Right = " ",
            C = "󰘴 ",
            M = "󰘵 ",
            D = "󰘳 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󱕐 ",
            ScrollWheelUp = "󱕑 ",
            NL = "󰌑 ",
            BS = "󰁮",
            Space = "󱁐 ",
            Tab = "󰌒 ",
            F1 = "󱊫",
            F2 = "󱊬",
            F3 = "󱊭",
            F4 = "󱊮",
            F5 = "󱊯",
            F6 = "󱊰",
            F7 = "󱊱",
            F8 = "󱊲",
            F9 = "󱊳",
            F10 = "󱊴",
            F11 = "󱊵",
            F12 = "󱊶",
          },
        },
        show_help = true,
        show_keys = true,
        disable = {
          ft = {},
          bt = {},
        },
        debug = false,
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    {
      "haya14busa/vim-asterisk",
      ---@type LazyKeysSpec
      keys = {
        ---@diagnostic disable-next-line
        { "*", "<Plug>(asterisk-gz*)", desc = "Run 'asterisk-gz*'", { "n", "v", "x", "s", "o", "i", "t" } },
      },
    },
    {
      "johmsalas/text-case.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("textcase").setup({})
        require("telescope").load_extension("textcase")
      end,
      keys = {
        "ga", -- Default invocation prefix
        { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
      },
      cmd = {
        -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
        "Subs",
        "TextCaseOpenTelescope",
        "TextCaseOpenTelescopeQuickChange",
        "TextCaseOpenTelescopeLSPChange",
        "TextCaseStartReplacingCommand",
      },
    },
    {
      "nvimdev/hlsearch.nvim",
      event = "BufWinEnter",
      config = function()
        require("hlsearch").setup()
      end,
    },
    {
      "andymass/vim-matchup",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("plugins.matchup")
      end,
    },
    {
      -- hbac.nvim: Auto close unused buffers
      "axkirillov/hbac.nvim",
      event = "VeryLazy",
      opts = {
        autoclose = true,
        threshold = 10,
        close_buffers_with_windows = false,
      },
    },
    {
      "gbprod/yanky.nvim",
      event = "VeryLazy",
      keys = {
        { "<leader>p", false },
        {
          "<leader>sy",
          function()
            require("telescope").extensions.yank_history.yank_history({})
          end,
          desc = "Yank History",
        },
      },
    },
    -- {
    --   "NvChad/nvim-colorizer.lua",
    --   lazy = true,
    --   event = "User Colorizer",
    --   cmd = {
    --     "ColorizerAttachToBuffer",
    --     "ColorizerDetachFromBuffer",
    --     "ColorizerReloadAllBuffers",
    --     "ColorizerToggle",
    --   },
    --   opts = {
    --     filetypes = { "lua" },
    --     user_default_options = {
    --       RGB = true,
    --       RRGGBB = true,
    --       names = true,
    --       RRGGBBAA = false,
    --       AARRGGBB = false,
    --       rgb_fn = false,
    --       hsl_fn = false,
    --       css = false,
    --       css_fn = false,
    --       mode = "background",
    --       virtualtext = "■",
    --     },
    --     buftypes = {},
    --   },
    -- },
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function()
        vim.g.startuptime_tries = 10
      end,
    },
    {
      "wakatime/vim-wakatime",
      lazy = false,
      opts = {
        -- cli_path = util.homebrew_binary("wakatime-cli", "wakatime-cli"),
        -- python_binary = util.homebrew_binary("python@3.14", "python3"),
        -- status_bar_enabled = true,
      },
    },
  },
}
