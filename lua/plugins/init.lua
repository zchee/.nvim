local util = require("util")

---@type LazySpec
return {
  -- Local
  {
    dir = vim.fs.joinpath(util.src_path("github.com/zchee/vim-flatbuffers")),
    ft = "fbs",
  },
  {
    dir = vim.fs.joinpath(util.src_path("github.com/zchee/vim-gn")),
    ft = "gn",
  },
  {
    dir = vim.fs.joinpath(util.src_path("github.com/zchee/vim-go-testscript")),
    ft = "testscript",
  },
  {
    dir = vim.fs.joinpath(util.src_path("github.com/zchee/nvim-goasm")),
    ft = "goasm",
  },
  -- {
  --   dir = vim.fs.joinpath(util.src_path("github.com/zchee/tree-sitter-goasm")),
  --   lazy = false,
  --   opts = function()
  --     return {}
  --   end,
  -- },
  {
    dir = vim.fs.joinpath(util.src_path("github.com/zchee/tree-sitter-zsh")),
    ft = "zsh",
  },
  -- {
  --   dir = vim.fs.joinpath(util.go_path("src/github.com/zchee/trans.nvim")),
  --   cmd = { "TransNvim" },
  -- },

  -- AI
  {
    "coder/claudecode.nvim",
    branch = "main",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info",                                                 -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = "/opt/local/bin/claude --dangerously-skip-permissions", -- Custom terminal command (default: "claude")
      -- Send/Focus Behavior
      -- When true, successful sends will focus the Claude terminal if already connected
      focus_after_send = false,
      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- Terminal Configuration
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
        provider = "snacks", -- "auto", "snacks", "native", "external", "none"
        auto_close = true,
        ---@module 'snacks'
        ---@class snacks.terminal.Opts: snacks.terminal.Config
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
        -- Provider-specific options
        provider_opts = {
          -- Command for external terminal provider. Can be:
          -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
          -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
          -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
          external_terminal_cmd = nil,
        },
      },
      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = false, -- If true, moves focus back to terminal after diff opens
      },
    },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",     desc = "Add file",           ft = { "NvimTree", "neo-tree", "oil", "minifiles" } },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny diff" },
    },
  },
  -- {
  --   "greggh/claude-code.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   cmd = {
  --     "ClaudeCode",
  --     "ClaudeCodeContinue",
  --     "ClaudeCodeResume",
  --     "ClaudeCodeVerbose",
  --   },
  --   config = function()
  --     require("claude-code").setup({
  --       window = {
  --         split_ratio = 0.4,            -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
  --         height_ratio = 0.3,           -- DEPRECATED: Use split_ratio instead
  --         position = "vertical",        -- Position of the window: "botright", "topleft", "vertical", "float", etc.
  --         enter_insert = true,          -- Whether to enter insert mode when opening Claude Code
  --         start_in_normal_mode = false, -- Whether to start in normal mode instead of insert mode
  --         hide_numbers = true,          -- Hide line numbers in the terminal window
  --         hide_signcolumn = true,       -- Hide the sign column in the terminal window
  --         float = {
  --           width = "80%",              -- Width: number of columns or percentage string
  --           height = "80%",             -- Height: number of rows or percentage string
  --           row = "center",             -- Row position: number, "center", or percentage string
  --           col = "center",             -- Column position: number, "center", or percentage string
  --           relative = "editor",        -- Relative to: "editor" or "cursor"
  --           border = "rounded",         -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
  --         },
  --       },
  --       refresh = {
  --         enable = true,             -- Enable file change detection
  --         updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
  --         timer_interval = 1000,     -- How often to check for file changes (milliseconds)
  --         show_notifications = true, -- Show notification when files are reloaded
  --       },
  --       git = {
  --         use_git_root = true,   -- Set CWD to git root when opening Claude Code (if in git project)
  --         multi_instance = true, -- Use multiple Claude instances (one per git root)
  --       },
  --       shell = {
  --         separator = '&&',                -- Command separator used in shell commands
  --         pushd_cmd = 'pushd',             -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
  --         popd_cmd = 'popd',               -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  --       },
  --       command = "/opt/local/bin/claude", -- Command used to launch Claude Code
  --       command_variants = {
  --         continue = "--continue",         -- Resume the most recent conversation
  --         resume = "--resume",             -- Display an interactive conversation picker
  --         verbose = "--verbose",           -- Enable verbose logging with full turn-by-turn output
  --       },
  --       keymaps = {
  --         toggle = {
  --           normal = '<C-,>',          -- Normal mode keymap for toggling Claude Code
  --           terminal = '<C-,>',        -- Terminal mode keymap for toggling Claude Code
  --           variants = {
  --             continue = '<leader>cC', -- Normal mode keymap for Claude Code with continue flag
  --             verbose = '<leader>cV',  -- Normal mode keymap for Claude Code with verbose flag
  --           },
  --         },
  --         window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
  --         scrolling = true,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  --       }
  --     })
  --   end,
  -- },
  {
    "olimorris/codecompanion.nvim",
    branch = "main",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        branch = "master",
      },
      "nvim-treesitter/nvim-treesitter",
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      {
        "ravitemer/codecompanion-history.nvim",
        branch = "main",
      },
      {
        "Davidyz/VectorCode",
        branch = "main",
        build = "pipx upgrade vectorcode",
        dependencies = {
          {
            "nvim-lua/plenary.nvim",
            branch = "master",
          },
        },
      },
    },
    config = function()
      require("plugins.codecompanion")
    end,
  },
  {
    "yetone/avante.nvim",
    branch = "master",
    event = "VeryLazy",
    build =
    "RUSTFLAGS='-C linker=clang -C target-cpu=native -C opt-level=3 -C force-frame-pointers=on -C debug-assertions=off -C incremental=on -C overflow-checks=off -C panic=abort -C codegen-units=1 -C embed-bitcode=yes -Z dylib-lto -Z location-detail=none -C strip=symbols -C link-arg=-undefined -C link-arg=dynamic_lookup' cargo build -v --release --features=luajit -p avante-repo-map -p avante-templates -p avante-tokenizers",
    keys = require("plugins.avante.keys"),
    opts = require("plugins.avante"),
    dependencies = {
      {
        "ravitemer/mcphub.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        cmd = "MCPHub",
        build = "pnpm install -g mcp-hub@latest",
        config = function()
          require("plugins.mcphub")
        end
      },
      "folke/snacks.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      {
        "ibhagwan/fzf-lua",
        dependencies = { "echasnovski/mini.icons" },
      },
      -- icons
      "echasnovski/mini.icons",
    },
    {
      "obsidian-nvim/obsidian.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/.obsidian/vaults/knowledge/*.md", -- "BufReadPre path/to/my-vault/*.md","BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      },
      config = function()
        require("plugins.obsidian")
      end,
    },
  },

  -- LSP
  {
    {
      "williamboman/mason.nvim",
      cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
      config = function()
        require("plugins.mason")
      end,
    },
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
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
          branch = "master",
          event = "LspAttach",
        },
        {
          "rachartier/tiny-inline-diagnostic.nvim",
          event = "LspAttach",
        },
      },
      config = function()
        require("lsp")
      end,
    },
    {
      "lewis6991/hover.nvim",
      event = "LspAttach",
      config = function()
        require("plugins.hover")
      end,
    },
    {
      "amrbashir/nvim-docs-view",
      cmd = "DocsViewToggle",
      opts = {
        position = "top", -- "right",
        width = 60,
        height = 10,
      }
    },
    {
      "j-hui/fidget.nvim",
      branch = "main",
      event = "VeryLazy",
      config = function()
        require("plugins.fidget")
      end,
    },
    {
      "nvimtools/none-ls.nvim",
      disable = true,
      -- event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "jay-babu/mason-null-ls.nvim",
        "williamboman/mason.nvim",
      },
      config = function()
        require("plugins.null-ls")
      end,
    },
    {
      "stevearc/aerial.nvim",
      branch = "master",
      event = "VeryLazy",
      -- cmd = {
      --   "AerialToggle",
      -- },
      dependencies = {
        "folke/snacks.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
      },
      config = function()
        require("plugins.aerial")
        vim.keymap.set("n", "<Space>o", function()
            require("aerial").snacks_picker({ layout = { preset = "sidebar", preview = "main" } })
          end,
          { desc = "Symbols" }
        )
      end,
    },
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        branch = "main",
      },
      {
        "hrsh7th/cmp-buffer",
        branch = "main",
      },
      {
        "hrsh7th/cmp-path",
        branch = "main",
      },
      {
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        branch = "main",
      },
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        branch = "main",
      },
      {
        "petertriho/cmp-git",
        branch = "main",
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
      "onsails/lspkind-nvim",
      "SmiteshP/nvim-navic",
      {
        "ray-x/cmp-treesitter",
        branch = "master",
      },
      "echasnovski/mini.pairs",
      {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
      },
      {
        "L3MON4D3/LuaSnip",
        branch = "master",
        dependencies = {
          {
            "saadparwaiz1/cmp_luasnip",
            branch = "master",
          },
        },
        build = "make install_jsregexp",
      },
      -- {
      --   "samiulsami/cmp-go-deep",
      --   dependencies = {
      --     "kkharji/sqlite.lua",
      --   },
      -- },
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            "lazy.nvim",
            {
              path = "${3rd}/luv/library",
              words = { "vim%.uv" },
            },
          },
          integrations = {
            lspconfig = true,
            cmp = true,
            coq = false,
          },
        },
      },
      "b0o/schemastore.nvim",
      {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
      },
      "echasnovski/mini.icons",
      {
        "zbirenbaum/copilot-cmp",
        branch = "master",
        config = function()
          require("copilot_cmp").setup()
        end
      },
      {
        "zbirenbaum/copilot.lua",
        branch = "master",
        lazy = false,
        event = "InsertEnter",
        -- cmd = "Copilot",
        build = "pnpm i -g @github/copilot-language-server@latest",
        opts = {
          panel = { enabled = false },
          suggestion = { enabled = false },
          filetypes = {
            -- ["*"] = false,
            help = false,
            markdown = true,
            sh = false,
          },
          copilot_node_command = util.homebrew_binary("node", "node"),
          server = {
            type = "nodejs",
            custom_server_filepath = vim.fs.joinpath(util.getenv("PNPM_HOME"),
              "global/5/node_modules/@github/copilot-language-server/dist/language-server.js"),
          },
          copilot_model = "gpt-41-copilot",
          -- configuration: [{
          --   title: "GitHub Copilot",
          --   properties: {
          --     "github.copilot.selectedCompletionModel": {
          --       type: "string",
          --       default: "",
          --       markdownDescription: "The currently selected completion model ID. To select from a list of available models, use the __\"Change Completions Model\"__ command or open the model picker (from the Copilot menu in the VS Code title bar, select __\"Configure Code Completions\"__ then __\"Change Completions Model\"__. The value must be a valid model ID. An empty value indicates that the default model will be used."
          --     },
          --     "github.copilot.advanced": {
          --       type: "object",
          --       title: "Advanced Settings",
          --       properties: {
          --         authProvider: {
          --           type: "string",
          --           enum: ["github", "github-enterprise"],
          --           enumDescriptions: ["GitHub.com", "GitHub Enterprise"],
          --           default: "github",
          --           description: "The GitHub identity to use for Copilot"
          --         },
          --         authPermissions: {
          --           type: "string",
          --           enum: ["default", "minimal"],
          --           markdownEnumDescriptions: ["Default (recommended) - The default permissions enable the best that Copilot has to offer including, but not limited to, faster repo indexing and the power of the `@github` agent.", "Minimal - The minimal permissions required for Copilot functionality."],
          --           default: "default",
          --           markdownDescription: "Controls what kind of permissions are asked for when signing in to Copilot. The options are\n* `default` - (strongly recommended) The default permissions enable the best that Copilot has to offer including, but not limited to, faster repo indexing and the power of the `@github` agent.\n* `minimal` - The minimal permissions are the least that Copilot needs to function. Some features may behave slower or not at all."
          --         },
          --         useLanguageServer: {
          --           type: "boolean",
          --           default: false,
          --           description: "Experimental: Use language server"
          --         },
          --         "debug.overrideEngine": {
          --           type: "string",
          --           default: "",
          --           description: "Override engine name"
          --         },
          --         "debug.overrideProxyUrl": {
          --           type: "string",
          --           default: "",
          --           description: "Override GitHub authentication proxy full URL"
          --         },
          --         "debug.testOverrideProxyUrl": {
          --           type: "string",
          --           default: "",
          --           description: "Override GitHub authentication proxy URL when running tests"
          --         },
          --         "debug.overrideCapiUrl": {
          --           type: "string",
          --           default: "",
          --           description: "Override GitHub Copilot API full URL"
          --         },
          --         "debug.testOverrideCapiUrl": {
          --           type: "string",
          --           default: "",
          --           description: "Override GitHub Copilot API URL when running tests"
          --         },
          --         "debug.filterLogCategories": {
          --           type: "array",
          --           default: [],
          --           deprecationMessage: "Set overrideLogLevels.* to ERROR to filter out unwanted categories.",
          --           description: "Show only log categories listed in this setting. If an array is empty, show all loggers"
          --         }
          --       }
          --     },
          --     "github.copilot.enable": {
          --       type: "object",
          --       scope: "window",
          --       default: {
          --         "*": true,
          --         plaintext: false,
          --         markdown: false,
          --         scminput: false
          --       },
          --       additionalProperties: {
          --         type: "boolean"
          --       },
          --       markdownDescription: "Enable or disable auto triggering of Copilot completions for specified [languages](https://code.visualstudio.com/docs/languages/identifiers). You can still trigger suggestions manually using `Alt + \\`"
          --     }
          --   }
          -- }],
          -- server_opts_overrides = {
          --   -- autostart = true,
          --   -- trace = "off",
          --   init_options = {
          --     github = {
          --       copilot = {
          --         selectedCompletionModel = "gpt-4o-copilot",
          --         advanced = {
          --           -- displayStyle = "node",
          --           -- useLanguageServer = true,
          --           -- secretKey = ["advanced", "secret_key"],
          --           length = 0,
          --           -- stops = ["advanced", "stops"],
          --           -- temperature = ["advanced", "temperature"],
          --           -- topP = ["advanced", "top_p"],
          --           indentationMode = false,
          --           inlineSuggestCount = 0, -- #completions for getCompletions
          --           listCount = 3,          -- #completions for panel
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
          --     -- enableAutoCompletions = false,
          --     -- inlineSuggest = {
          --     --   enable = false,
          --     -- },
          --     -- editor = {
          --     --   showEditorCompletions = false,
          --     --   enableAutoCompletions = false,
          --     --   delayCompletions = false,
          --     --   -- filterCompletions = ["editor", "filterCompletions"],
          --     -- },
          --   },
          -- },
        },
      },
    },
    config = function()
      require("plugins.cmp")
    end,
  },
  -- {
  --   {
  --     "saghen/blink.cmp",
  --     -- lazy = false,
  --     event = "InsertEnter",
  --     build =
  --     "RUSTFLAGS='-C linker=clang -C target-cpu=native -C opt-level=3 -C force-frame-pointers=on -C debug-assertions=off -C incremental=on -C overflow-checks=off -C panic=abort -C codegen-units=1 -C embed-bitcode=yes -Z dylib-lto -Z location-detail=none -C strip=symbols -C link-arg=-undefined -C link-arg=dynamic_lookup' cargo build -v --release",
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
  --       "yetone/avante.nvim",
  --       "Kaiser-Yang/blink-cmp-avante",
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
  --   {
  --     "zbirenbaum/copilot.lua",
  --     cmd = "Copilot",
  --     build = "pnpm i -g @github/copilot-language-server@latest",
  --     opts = {
  --       panel = { enabled = false },
  --       suggestion = { enabled = false },
  --       filetypes = {
  --         -- ["*"] = false,
  --         help = false,
  --         markdown = true,
  --         sh = false,
  --       },
  --       copilot_node_command = util.homebrew_binary("node", "node"),
  --       server = {
  --         type = "nodejs",
  --         custom_server_filepath = vim.fs.joinpath(
  --           util.getenv("PNPM_HOME"),
  --           "global/5/node_modules/@github/copilot-language-server/dist/language-server.js"),
  --       },
  --       copilot_model = "gpt-4o-copilot",
  --       server_opts_overrides = {
  --         autostart = false,
  --         trace = "off",
  --         init_options = {
  --           github = {
  --             copilot = {
  --               selectedCompletionModel = "gpt-4o-copilot",
  --             },
  --           },
  --           enableAutoCompletions = false,
  --           inlineSuggest = {
  --             enable = false,
  --           },
  --           editor = {
  --             showEditorCompletions = false,
  --             enableAutoCompletions = false,
  --             delayCompletions = false,
  --             -- filterCompletions = ["editor", "filterCompletions"],
  --           },
  --           advanced = {
  --             displayStyle = "node",
  --             -- secretKey = ["advanced", "secret_key"],
  --             length = 0,
  --             -- stops = ["advanced", "stops"],
  --             -- temperature = ["advanced", "temperature"],
  --             -- topP = ["advanced", "top_p"],
  --             indentationMode = false,
  --             inlineSuggestCount = 0, -- #completions for getCompletions
  --             listCount = 0,          -- #completions for panel
  --             -- debugOverrideProxyUrl = ["advanced", "debug.overrideProxyUrl"],
  --             -- debugTestOverrideProxyUrl = ["advanced", "debug.testOverrideProxyUrl"],
  --             -- debugEnableGitHubTelemetry = ["advanced", "debug.githubCTSIntegrationEnabled"],
  --             -- debugOverrideEngine = ["advanced", "debug.overrideEngine"],
  --             -- debugShowScores = ["advanced", "debug.showScores"],
  --             -- debugOverrideLogLevels = ["advanced", "debug.overrideLogLevels"],
  --             -- debugFilterLogCategories = ["advanced", "debug.filterLogCategories"],
  --             -- debugUseSuffix = ["advanced", "debug.useSuffix"],
  --             -- debugAcceptSelfSignedCertificate = ["advanced", "debug.acceptSelfSignedCertificate"]
  --           },
  --         },
  --       },
  --     },
  --   },
  --   {
  --     "saghen/blink.compat",
  --   },
  -- },
  {
    "numToStr/Comment.nvim",
    branch = "master",
    event = "VeryLazy",
    dependencies = {
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
    },
    config = function()
      require("plugins.dap")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "yamatsum/nvim-nonicons",
    },
    init = function(plugin)
      require("lazy.core.loader").add_to_rtp(plugin)
    end,
    config = function()
      require("nvim-treesitter.query_predicates")
      require("plugins.tree-sitter")
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    config = function()
      require("plugins.ts_context_commentstring")
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
      -- {
      --   "nvim-telescope/telescope-fzf-native.nvim",
      --   build =
      --   "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build && cmake --install build --prefix build",
      -- },
    },
    config = function()
      require("plugins.telescope")
    end,
  },

  -- UI
  {
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "main",
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
      "folke/snacks.nvim",
      branch = "main",
      lazy = false,
      config = function()
        require("plugins.snacks")
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      branch = "master",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("plugins.lualine")
      end,
    },
    {
      "akinsho/bufferline.nvim",
      branch = "main",
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
      branch = "main",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
        {
          "chrisgrieser/nvim-tinygit",
          dependencies = {
            {
              "stevearc/dressing.nvim",
              branch = "master",
            },
          }
        },
      },
      cmd = {
        "Fugit2",
        "Fugit2Blame",
        "Fugit2Diff",
        "Fugit2Graph",
      },
      keys = {
        { '<Space>g', mode = 'n', '<cmd>Fugit2<cr>' }
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
      branch = "main",
      cmd = {
        "DiffviewFileHistory",
        "DiffviewOpen",
        "DiffviewToggleFiles",
        "DiffviewFocusFiles",
        "DiffviewRefresh",
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      "lewis6991/gitsigns.nvim",
      branch = "main",
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
      branch = "master",
      event = "BufRead",
      config = function()
        require("plugins.illuminate")
      end,
    },
    {
      "petertriho/nvim-scrollbar",
      branch = "main",
      event = "VeryLazy",
      config = function()
        require("plugins.scrollbar")
      end,
    },
    {
      "kevinhwang91/nvim-bqf",
      branch = "main",
      ft = "qf",
      config = function()
        require("plugins.bqf")
      end,
    },
    {
      "folke/todo-comments.nvim",
      branch = "main",
      event = "BufRead",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      opts = require("plugins.todo-comment")
    },
  },

  -- Operator
  {
    {
      "kana/vim-operator-replace",
      branch = "master",
      event = "VeryLazy",
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "rhysd/vim-operator-surround",
      branch = "master",
      event = "VeryLazy",
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "mopp/vim-operator-convert-case",
      branch = "master",
      event = "VeryLazy",
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "AndrewRadev/switch.vim",
      branch = "main",
      event = "VeryLazy",
    },
    {
      "junegunn/vim-easy-align",
      branch = "master",
      cmd = {
        "EasyAlign",
      },
    },
    {
      "tyru/open-browser.vim",
      branch = "master",
      event = "VeryLazy",
    },
    {
      "tkmpypy/chowcho.nvim",
      branch = "main",
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
      {
        "cappyzawa/go-playground.nvim",
        branch = "master",
        ft = "go",
        cmd = {
          "GoPlayground",
          "GotipPlayground",
        },
      },
      -- {
      --   "ray-x/go.nvim",
      --   event = { "CmdlineEnter" },
      --   ft = { "go", 'gomod' },
      --   build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
      --   -- event = "VeryLazy",
      --   config = function(lp, opts)
      --     require("go").setup(opts)
      --     local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       pattern = "*.go",
      --       callback = function()
      --         require('go.format').goimports()
      --       end,
      --       group = format_sync_grp,
      --     })
      --   end,
      --   dependencies = {
      --     "ray-x/guihua.lua",
      --     "neovim/nvim-lspconfig",
      --     "nvim-treesitter/nvim-treesitter",
      --   },
      -- },
    },

    -- Rust
    {
      -- {
      --   'mrcjkb/rustaceanvim',
      --   lazy = false,
      --   config = function()
      --     vim.g.rustaceanvim = {
      --       tools = {
      --       },
      --       ---@class rustaceanvim.lsp.ClientConfig: vim.lsp.ClientConfig
      --       server = {
      --         ---@type lsp.ClientCapabilities
      --         capabilities = require('rustaceanvim.config.server')
      --             .create_client_capabilities(),
      --         -- ---@type boolean | fun(bufnr: integer):boolean Whether to automatically attach the LSP client.
      --         -- ---Defaults to `true` if the `rust-analyzer` executable is found.
      --         -- auto_attach = function(bufnr)
      --         --   if #vim.bo[bufnr].buftype > 0 then
      --         --     return false
      --         --   end
      --         --   local path = vim.api.nvim_buf_get_name(bufnr)
      --         --   if not require('rustaceanvim.os').is_valid_file_path(path) then
      --         --     return false
      --         --   end
      --         --   local cmd = require('rustaceanvim.types.internal').evaluate(RustaceanConfig.server.cmd)
      --         --   if type(cmd) == 'function' then
      --         --     -- This could be a function that connects via a TCP socket, so we don't want to evaluate it.
      --         --     return true
      --         --   end
      --         --   ---@cast cmd string[]
      --         --   local rs_bin = cmd[1]
      --         --   return vim.fn.executable(rs_bin) == 1
      --         -- end,
      --         ---@type string[] | fun():(string[]|fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient)
      --         cmd = function()
      --           -- return { exepath_or_binary('rust-analyzer'), '--log-file', RustaceanConfig.server.logfile }
      --           return { "rustup", "run", "nightly", "rust-analyzer" }
      --         end,
      --
      --         -- --- Defaults to `nil`, which means rustaceanvim will use the built-in async root directory detection
      --         -- ---@type nil | string | fun(filename: string, default: fun(filename: string):string|nil):string|nil
      --         -- root_dir = nil,
      --
      --         -- ra_multiplex = {
      --         --   ---@type boolean
      --         --   enable = vim.tbl_get(rustaceanvim_opts, 'server', 'cmd') == nil,
      --         --   ---@type string
      --         --   host = '127.0.0.1',
      --         --   ---@type integer
      --         --   port = 27631,
      --         -- },
      --
      --         ---@type boolean
      --         standalone = true,
      --         -- ---@type string The path to the rust-analyzer log file.
      --         -- logfile = vim.fn.tempname() .. '-rust-analyzer.log',
      --         -- ---@type table | (fun(project_root:string|nil, default_settings: table|nil):table) -- The rust-analyzer settings or a function that creates them.
      --         -- settings = function(_, default_settings)
      --         --   return server_config.load_rust_analyzer_settings(_, { default_settings = default_settings })
      --         -- end,
      --         --- @type table
      --         default_settings = {
      --           --- options to send to rust-analyzer
      --           --- See: https://rust-analyzer.github.io/book/configuration
      --           --- @type table
      --           ['rust-analyzer'] = {},
      --         },
      --         ---@type boolean Whether to search (upward from the buffer) for rust-analyzer settings in .vscode/settings json.
      --         -- load_vscode_settings = true,
      --         ---@type rustaceanvim.server.status_notify_level
      --         -- status_notify_level = 'error',
      --       },
      --       dap = {
      --       },
      --     }
      --   end,
      -- },
      {
        "saecki/crates.nvim",
        branch = "main",
        config = function()
          require("crates").setup({
            lsp = {
              enabled = true,
              -- on_attach = function(client, bufnr)
              --   -- the same on_attach function as for your other language servers
              --   -- can be ommited if you're using the `LspAttach` autocmd
              -- end,
              actions = true,
              completion = true,
              hover = true,
            },
            completion = {
              cmp = {
                use_custom_kind = true,
                -- optionally change the text and highlight groups
                kind_text = {
                  version = "Version",
                  feature = "Feature",
                },
                kind_highlight = {
                  version = "CmpItemKindVersion",
                  feature = "CmpItemKindFeature",
                },
              },
            },
          })
        end,
      },
    },

    -- Zig
    {
      {
        "ziglang/zig.vim",
        branch = "master",
        lazy = false,
      },
    },

    -- GraphQL
    {
      {
        "jparise/vim-graphql",
        branch = "master",
        ft = "graphql",
      },
    },

    -- Helm
    {
      {
        "towolf/vim-helm",
        branch = "master",
        ft = "helm",
      },
    },

    -- Git
    {
      "rhysd/vim-syntax-codeowners",
      branch = "master",
      ft = "codeowners",
    },

    -- Markdown
    {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        branch = "main",
        ft = {
          "markdown",
          "Avante",
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
        branch = "master",
        cmd = { "DiagramToggle" },
        dependencies = {
          {
            "nvim-treesitter/nvim-treesitter",
          },
          {
            "3rd/image.nvim",
            opts = {
              backend = "kitty",
              processor = "magick_cli", -- or "magick_rock"
              integrations = {
                markdown = {
                  enabled = true,
                  clear_in_insert_mode = false,
                  download_remote_images = true,
                  only_render_image_at_cursor = false,
                  only_render_image_at_cursor_mode = "popup",
                  floating_windows = false, -- if true, images will be rendered in floating markdown windows
                  filetypes = { "markdown" }, -- markdown extensions (ie. quarto) can go here
                },
              },
              neorg = {
                enabled = true,
                filetypes = { "norg" },
              },
              typst = {
                enabled = true,
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
            window_overlap_clear_enabled = false,                                         -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
            editor_only_render_when_focused = false,                                      -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = false,                                      -- auto show/hide images in the correct Tmux window (needs visual-activity off)
            hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
          },
        },
        config = function() -- you can just pass {}, defaults below
          require("diagram").setup({
            events = {
              render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
              clear_buffer = { "BufLeave" },
            },
            integrations = {
              require("diagram.integrations.markdown"),
              require("diagram.integrations.neorg"),
            },
            renderer_options = {
              mermaid = {
                background = "#010101",
                theme = "dark",
                scale = 1,
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
        branch = "main",
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

    -- tmux
    {
      {
        "ericpruitt/tmux.vim",
        ft = "tmux",
      },
    },

    -- Zsh
    {
      "chrisbra/vim-zsh",
      event = "VeryLazy",
    },
  },

  -- Utilities
  {
    {
      "rainbowhxch/accelerated-jk.nvim",
      branch = "main",
      event = "VeryLazy",
      config = function()
        require("accelerated-jk").setup({
          mode = "time_driven",
          enable_deceleration = true,
          acceleration_motions = {},
          acceleration_limit = 500,
          acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 },
          deceleration_table = { { 200, 3 }, { 300, 7 }, { 450, 11 }, { 600, 15 }, { 750, 21 }, { 900, 9999 } },
        })
        vim.keymap.set({ "n" }, "j", "<Plug>(accelerated_jk_gj)",
          { nowait = true, silent = true })
        vim.keymap.set({ "n" }, "k", "<Plug>(accelerated_jk_gk)",
          { nowait = true, silent = true })
      end,
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
            mode = "nxso"
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
            min = 50
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
            { "^%+",              "" },
            { "<[cC]md>",         "" },
            { "<[cC][rR]>",       "" },
            { "<[sS]ilent>",      "" },
            { "^lua%s+",          "" },
            { "^call%s+",         "" },
            { "^:%s*",            "" },
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
        { "*", "<Plug>(asterisk-gz*)", desc = "Run 'asterisk-gz*'", { "n", "v", "x", "s", "o", "i", "t" } }, -- "c"
      },
    },
    {
      "johmsalas/text-case.nvim",
      lazy = false,
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
      "echasnovski/mini.icons",
      event = "VeryLazy",
    },
    {
      "nvimdev/hlsearch.nvim",
      event = "BufWinEnter",
      config = function()
        require("hlsearch").setup()
      end
    },
    {
      "andymass/vim-matchup",
      event = "VeryLazy",
      init = function()
        vim.g.matchup_no_version_check = true
        ---@type matchup.Config
        require("match-up").setup({
          enabled = 1,
          -- matchparen = {
          --   -- deferred 0|1
          --   -- deferred_fade_time integer
          --   -- deferred_hide_delay integer
          --   -- deferred_show_delay integer
          --   -- enabled 0|1
          --   -- end_sign string
          --   -- hi_background 0|1
          --   -- hi_surround_always 0|1
          --   -- insert_timeout integer
          --   -- nomode string
          --   -- offscreen matchup.OffscreenConfig
          --   -- pumvisible 0|1
          --   -- singleton 0|1
          --   -- stopline integer
          --   -- timeout integer
          -- },
          treesitter = {
            enabled = true,
            disabled = {},
            include_match_words = true,
            disable_virtual_text = true,
            enable_quotes = true,
            stopline = 500,
          }
        })
      end,
    },
    -- {
    --   "monkoose/matchparen.nvim",
    --   event = "VeryLazy",
    --   dependencies = {
    --     "nvim-treesitter/nvim-treesitter",
    --   },
    --   config = function()
    --     ---@class MatchParenOptions
    --     ---@diagnostic disable-next-line
    --     require("matchparen").setup({
    --       enabled = true,
    --       hl_group = "MatchParen",
    --       debounce_time = 60,
    --       -- in_insert = true,
    --       -- matchpairs = {
    --       --   "(:)",
    --       --   "{:}",
    --       --   "[:]",
    --       --   "<:>",
    --       -- },
    --     })
    --   end,
    -- },
    {
      "NvChad/nvim-colorizer.lua",
      cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers", "ColorizerToggle" },
      opts = {
        filetypes = { "lua" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = false,
          AARRGGBB = false,
          rgb_fn = false,
          hsl_fn = false,
          css = false,
          css_fn = false,
          mode = "background",
          virtualtext = "■",
        },
        buftypes = {},
      },
    },
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      init = function()
        vim.g.startuptime_tries = 10
      end,
    },
    {
      "potamides/pantran.nvim",
      cmd = {
        "Pantran",
      },
      opts = {
        default_engine = "deepl",
        engines = {
          deepl = {
            default_source = "EN",
            default_target = "JA",
            free_api = false,
          },
        },
      },
    },
    {
      "folke/neoconf.nvim",
      cmd = "Neoconf",
    },
    {
      "wakatime/vim-wakatime",
      lazy = false,
    },
  },
}
