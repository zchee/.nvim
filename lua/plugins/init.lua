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
  -- {
  --   dir = util.src_path("github.com/zchee/nvim-goasm"),
  --   ft = "goasm",
  -- },
  -- {
  --   dir = vim.fs.joinpath(util.src_path("github.com/zchee/tree-sitter-goasm")),
  --   lazy = false,
  --   opts = function()
  --     return {}
  --   end,
  -- },
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

  -- AI
  {
    "coder/claudecode.nvim",
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
    },
    config = function()
      require("plugins.claudecode")
    end,
    keys = {
      {
        "<leader>a", nil, desc = "AI/Claude Code"
      },
      {
        "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude"
      },
      {
        "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude"
      },
      {
        "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude"
      },
      {
        "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude"
      },
      {
        "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model"
      },
      {
        "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer"
      },
      {
        "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude"
      },
      {
        "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = { "NvimTree", "neo-tree", "oil", "minifiles" }
      },
      -- Diff management
      {
        "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff"
      },
      {
        "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff"
      },
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
      "zeioth/garbage-day.nvim",
      event = "VeryLazy",
      opts = {
        aggressive_mode = false,
        excluded_lsp_clients = {
          "rust_analyzer",
        }, -- "null-ls",, "jdtls", "marksman", "lua_ls",
      },
      dependencies = {
        "neovim/nvim-lspconfig",
      },
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
            dir = util.src_path("github.com/LuaLS/LLS-Addons"), -- "LuaLS/LLS-Addons",
            ft = "lua",
          },
        },
        config = function()
          require("lsp")
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
        event = "VeryLazy",
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
      "onsails/lspkind-nvim",
      "SmiteshP/nvim-navic",
      {
        "ray-x/cmp-treesitter",
      },
      "echasnovski/mini.pairs",
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
        dependencies = {
          "zbirenbaum/copilot.lua",
        },
        config = function()
          require("copilot_cmp").setup()
        end
      },
      {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        build = "bun i -g @github/copilot-language-server@latest",
        config = function()
          require("plugins.copilot")
        end,
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
  --     build = "bun i -g @github/copilot-language-server@latest",
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
    },
    config = function()
      require("plugins.dap")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
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
      "folke/snacks.nvim",
      lazy = false,
      config = function()
        require("plugins.snacks")
      end,
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
        { "<Space>g", mode = "n", "<cmd>Fugit2<cr>" }
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
      dependencies = { "nvim-tree/nvim-web-devicons" },
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
      opts = require("plugins.todo-comment")
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
      -- {
      --   'mrcjkb/rustaceanvim',
      --   lazy = false,
      --   confio = function()
      --     require("plugins.rustaceanvim")
      --   end,
      -- },
      -- {
      --   "saecki/crates.nvim",
      --   config = function()
      --     require("crates").setup({
      --       lsp = {
      --         enabled = false,
      --         -- on_attach = function(client, bufnr)
      --         --   -- the same on_attach function as for your other language servers
      --         --   -- can be ommited if you're using the `LspAttach` autocmd
      --         -- end,
      --         actions = true,
      --         completion = true,
      --         hover = true,
      --       },
      --       completion = {
      --         cmp = {
      --           use_custom_kind = true,
      --           -- optionally change the text and highlight groups
      --           kind_text = {
      --             version = "Version",
      --             feature = "Feature",
      --           },
      --           kind_highlight = {
      --             version = "CmpItemKindVersion",
      --             feature = "CmpItemKindFeature",
      --           },
      --         },
      --       },
      --     })
      --   end,
      -- },
    },

    -- Markdown
    {
      {
        "MeanderingProgrammer/render-markdown.nvim",
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
                  floating_windows = true,    -- if true, images will be rendered in floating markdown windows
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
            window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
            editor_only_render_when_focused = false,                                            -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = false,                                            -- auto show/hide images in the correct Tmux window (needs visual-activity off)
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
                width = 800,  -- nil | 800 | 400 | ...
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

    -- GraphQL
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
      "zchee/accelerated-jk.nvim", -- "rainbowhxch/accelerated-jk.nvim",
      lazy = false,
      keys = {
        {
          "j",
          "<Plug>(accelerated_jk_gj)",
          mode = "n",
          nowait = true,
          silent = true,
        },
        {
          "k",
          "<Plug>(accelerated_jk_gk)",
          mode = "n",
          nowait = true,
          silent = true,
        },
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
      "NvChad/nvim-colorizer.lua",
      lazy = true,
      cmd = {
        "ColorizerAttachToBuffer",
        "ColorizerDetachFromBuffer",
        "ColorizerReloadAllBuffers",
        "ColorizerToggle", },
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
      dir = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy/vimdoc-ja"),
      lazy = false,
    },
    {
      "wakatime/vim-wakatime",
      lazy = false,
    },
  },
}
