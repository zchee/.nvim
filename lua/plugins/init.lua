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
    dir = util.src_path("github.com/zchee/nvim-goasm"),
    ft = "goasm",
  },
  -- {
  --   dir = vim.fs.joinpath(util.src_path("github.com/zchee/tree-sitter-goasm")),
  --   lazy = false,
  --   opts = function()
  --     return {}
  --   end,
  -- },
  -- {
  --   dir = vim.fs.joinpath(util.go_path("src/github.com/zchee/trans.nvim")),
  --   cmd = { "TransNvim" },
  -- },
  {
    dir = util.src_path("github.com/zchee/metafrastis.nvim"),
    event = "VeryLazy",
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
    branch = "main",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("plugins.claudecode")
    end,
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
        build = "bun install -g mcp-hub@latest",
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
        {
          "lewis6991/hover.nvim",
          event = "LspAttach",
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
            filter = function(_buf, win)
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
      {
        'mrcjkb/rustaceanvim',
        lazy = false,
        confio = function()
          require("plugins.rustaceanvim")
        end,
      },
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
                  floating_windows = false,   -- if true, images will be rendered in floating markdown windows
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
            window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
            editor_only_render_when_focused = false,                                            -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = false,                                            -- auto show/hide images in the correct Tmux window (needs visual-activity off)
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
      lazy = false,
    },
  },

  -- Utilities
  {
    {
      "zchee/accelerated-jk.nvim", -- "rainbowhxch/accelerated-jk.nvim",
      branch = "main",
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
      dir = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy/vimdoc-ja"),
      lazy = false,
    },
    {
      "wakatime/vim-wakatime",
      lazy = false,
    },
  },
}
