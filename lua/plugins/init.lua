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
  {
    dir = util.src_path("github.com/zchee/codecov.nvim"),
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("plugins.codecov")
    end,
  },

  -- AI

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
            "rust-analyzer",
            "tombi",
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
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = require("plugins.conform"),
      },
      {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
          require("plugins.lint")
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
          vim.keymap.set("n", "<Leader>o", function()
            ---@diagnostic disable-next-line
            require("aerial").snacks_picker({ layout = { preset = "sidebar", preview = "main" } })
          end, { desc = "Symbols" })
        end,
      },
    },
  },

  -- Completion
  {
    "saghen/blink.cmp",
    -- Track main; build the fuzzy matcher from source. RUSTFLAGS must be
    -- unset for the build: the global export in .zprofile overrides blink's
    -- own .cargo/config.toml rustflags and strips the macOS-required
    -- "-undefined dynamic_lookup" link args, failing the link with
    -- unresolved mlua/luaL_* symbols -- the root cause of the previous
    -- failed migration attempt.
    -- v2's blink.lib loader resolves <repo>/lib/lib*.dylib.<commit7>, so the
    -- built artifact must be copied there under the current commit hash.
    -- Old-hash dylibs are pruned only after a successful build; if the build
    -- fails, implementation = "rust" hard-errors instead of silently reusing
    -- a stale matcher. After :Lazy update, verify this build ran.
    build = 'env -u RUSTFLAGS cargo build --release && mkdir -p lib && rm -f lib/libblink_cmp_fuzzy.dylib.* && cp target/release/libblink_cmp_fuzzy.dylib "lib/libblink_cmp_fuzzy.dylib.$(git rev-parse HEAD | cut -c1-7)"',
    event = { "InsertEnter" },
    dependencies = {
      -- blink.cmp v2 split its Rust/native runtime into a separate plugin.
      "saghen/blink.lib",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      {
        "fang2hou/blink-copilot",
        dependencies = {
          {
            "zbirenbaum/copilot.lua",
            config = function()
              require("plugins.copilot")
            end,
          },
        },
      },
      {
        "windwp/nvim-autopairs",
        event = { "InsertEnter" },
      },
      "echasnovski/mini.icons",
    },
    config = function()
      require("plugins.blink")
    end,
  },
  {
    -- Besides the library, this repoints lua_ls's root_dir at a workspace that
    -- already covers the file, which is what keeps a jumped-to buffer outside
    -- the project from landing in the server's settings-less <fallback> scope.
    -- The LLS-Addons paths are not repeated here: lazydev seeds each workspace
    -- from the client settings, so lsp/lua_ls.lua's library carries over.
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        "plenary.nvim",
        -- lua/nvim-treesitter/parsers.lua shadows the upstream registry
        "nvim-treesitter",
        {
          path = "${3rd}/luv/library",
          words = { "vim%.uv" },
        },
      },
    },
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
    branch = "main",
    lazy = false, -- the main branch does not support lazy-loading (upstream README)
    build = ":TSUpdate",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "yamatsum/nvim-nonicons",
    },
    config = function()
      require("plugins.tree-sitter")
    end,
  },

  -- UI
  {
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
    {
      "folke/snacks.nvim",
      lazy = false,
      -- load before other startup plugins so snacks can patch vim.notify etc.
      priority = 1000,
      config = function()
        require("plugins.snacks")
      end,
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      cmd = "Neotree",
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
      opts = {
        border = "rounded",
        max_width = 100,
        max_height = 20,
      },
      keys = {
        {
          "<Leader>pd",
          function()
            require("overlook").open_definition()
          end,
          desc = "Peek Definition",
        },
        {
          "<Leader>pc",
          function()
            require("overlook").close_all()
          end,
          desc = "Close All Popups",
        },
        {
          "<Leader>pu",
          function()
            require("overlook").restore_one()
          end,
          desc = "Restore Last Popup",
        },
        {
          "<Leader>pU",
          function()
            require("overlook").restore_all()
          end,
          desc = "Restore All Popups",
        },
        {
          "<Leader>pf",
          function()
            require("overlook").toggle_focus()
          end,
          desc = "Toggle Focus",
        },
        {
          "<Leader>ps",
          function()
            require("overlook").open_in_split()
          end,
          desc = "Open in Split",
        },
        {
          "<Leader>pv",
          function()
            require("overlook").open_in_vsplit()
          end,
          desc = "Open in VSplit",
        },
        {
          "<Leader>po",
          function()
            require("overlook").open_in_original()
          end,
          desc = "Open in Original",
        },
      },
    },
    {
      "stevearc/oil.nvim",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      opts = require("plugins.oil"),
      keys = {
        { "-", "<Cmd>Oil<CR>", desc = "Open parent directory" },
        { "<Leader>e", "<Cmd>Oil<CR>", desc = "File Explorer (Oil)" },
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
      event = "VeryLazy",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("plugins.lualine")
      end,
    },
    {
      -- dropbar.nvim: winbar breadcrumbs (replaces lspsaga's symbol_in_winbar)
      "Bekaboo/dropbar.nvim",
      event = "VeryLazy",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      keys = {
        {
          "<Leader>;",
          function()
            require("dropbar.api").pick()
          end,
          desc = "Winbar pick",
        },
      },
      config = function()
        require("plugins.dropbar")
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
      event = "VeryLazy",
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
        { "<Leader>g", mode = "n", "<cmd>Fugit2<cr>" },
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
        file_tree_maps = {
          menu = {
            commit = "c",
            diff = "d",
            branch = "b",
            push = "P",
            fetch = "f",
            pull = "p",
            forge = "N",
            stash = "z",
            cherry_pick = "A",
          },
        },
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
        { "<Leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (working tree)" },
        { "<Leader>gD", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff vs previous commit" },
        { "<Leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
        { "<Leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
        { "<Leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
        { "<Leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff vs main branch" },
        { "<Leader>gM", "<cmd>DiffviewOpen master...HEAD<cr>", desc = "Diff vs master branch" },
        { "<Leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Staged changes" },
        { "<Leader>gt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle file panel" },
      },
      config = function()
        require("plugins.diffview")
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
      -- satellite.nvim: scrollbar with diagnostics/gitsigns/search marks
      -- (successor of the dormant petertriho/nvim-scrollbar)
      "lewis6991/satellite.nvim",
      event = "VeryLazy",
      config = function()
        require("plugins.satellite")
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
    -- Rust
    {
      "mrcjkb/rustaceanvim",
      -- rustaceanvim exposes no `setup()`: it is configured through `vim.g.rustaceanvim`
      -- and lazy-loads itself from its own ftplugin, so lazy.nvim must not manage it
      -- via `opts`/`config` (that path calls `require("rustaceanvim").setup(opts)`).
      lazy = false,
      init = function()
        require("plugins.rustaceanvim")
      end,
    },
    {
      "saecki/crates.nvim",
      opts = require("plugins.crates"),
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
            opts = require("plugins.image"),
          },
        },
        config = function()
          require("plugins.diagram")
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
        ft = "zig",
      },
    },

    -- tmux
    {
      "ericpruitt/tmux.vim",
      ft = "tmux",
    },
  },

  -- Utilities
  {
    {
      "zchee/accelerated-jk.nvim",
      keys = {
        { "j", "<Plug>(accelerated_jk_gj)", mode = "n", nowait = true, silent = true },
        { "k", "<Plug>(accelerated_jk_gk)", mode = "n", nowait = true, silent = true },
      },
      opts = {
        mode = "time_driven",
        enable_deceleration = true,
        acceleration_motions = {},
        acceleration_limit = 500, ---@default: 150
        acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 }, -- { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 }, { 1, 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 }, { { 200, 3 }, { 300, 7 }, { 450, 11 }, { 600, 15 }, { 750, 21 }, { 900, 9999 } }, ---@default
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
      opts = require("plugins.which-key"),
      keys = {
        {
          "<Leader>?",
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
        { "<Leader>p", false },
        {
          "<Leader>sy",
          function()
            require("telescope").extensions.yank_history.yank_history({})
          end,
          desc = "Yank History",
        },
      },
    },
    {
      "catgoose/nvim-colorizer.lua",
      cmd = {
        "ColorizerAttachToBuffer",
        "ColorizerDetachFromBuffer",
        "ColorizerReloadAllBuffers",
        "ColorizerToggle",
      },
      init = function()
        -- Colorizer auto-attaches by filetype, which cannot name these files:
        -- a colorscheme is plain lua or vim, kitty/color.conf is conf, and the
        -- ganja themes are json -- filetypes shared with files that must stay
        -- unhighlighted. So `filetypes` stays empty below and attachment is
        -- driven from here, by path. Requiring the module is what pulls the
        -- plugin in, so no separate lazy trigger is needed.
        vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
          group = vim.api.nvim_create_augroup("colorizer_paths", { clear = true }),
          pattern = {
            "*/colors/*",
            "*/highlight.lua",
            "*/kitty/color.conf",
            vim.fs.normalize("~/.config/ganja/themes/*.json"),
          },
          callback = function(args)
            require("colorizer").attach_to_buffer(args.buf)
          end,
        })
      end,
      opts = {
        filetypes = {},
        options = {
          parsers = {
            -- colorschemes and theme files carry 8-digit hex and the odd
            -- rgb()/hsl(); names and 3/6-digit hex are on by default
            hex = { rrggbbaa = true },
            rgb = true,
            hsl = true,
          },
        },
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
      "wakatime/vim-wakatime",
      event = "VeryLazy",
      opts = {
        cli_path = util.homebrew_binary("wakatime-cli-head", "wakatime-cli"),
        python_binary = util.homebrew_binary("python@3.14", "python3"),
        status_bar_enabled = false,
      },
    },
  },
}
