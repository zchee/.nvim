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
    -- coverage.autostart is false, so the user commands are the only entry
    -- points; loading at VeryLazy only paid the setup cost up front.
    cmd = {
      "CodecovRefresh",
      "CodecovToggle",
      "CodecovResetApiKey",
      "CodecovValidate",
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
        -- The LSP entry point. nvim-lspconfig is gone -- every server config
        -- is a self-sufficient native vim.lsp.config table -- so the stack
        -- boots from lspkind, the one plugin lua/lsp/init.lua genuinely
        -- require()s at load time.
        "onsails/lspkind-nvim",
        event = {
          "BufReadPre",
          "BufNewFile",
        },
        config = function()
          require("lsp")
        end,
      },
      {
        -- lazy with no trigger: loaded by lazy.nvim's module loader when
        -- lsp/jsonls.lua require()s it for the schema catalog, so the
        -- catalog only materializes once a JSON buffer starts jsonls.
        "b0o/schemastore.nvim",
        lazy = true,
      },
      {
        dir = util.src_path("github.com/LuaLS/LLS-Addons"), -- "LuaLS/LLS-Addons",
        ft = "lua",
      },
      -- Standalone specs, not nvim-lspconfig dependencies: lazy.nvim loads
      -- dependencies together with their parent, which turned these four
      -- LspAttach triggers into BufReadPre loads.
      {
        "chrisgrieser/nvim-lsp-endhints",
        event = "LspAttach",
        config = function()
          require("plugins.lsp_endhints")
        end,
      },
      {
        "aznhe21/actions-preview.nvim",
        event = "LspAttach",
        config = function()
          require("plugins.actions_preview")
        end,
      },
      {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        config = function()
          require("plugins.tiny_inline_diagnostic")
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
        -- LSP progress UI: nothing to render before a client attaches.
        event = "LspAttach",
        config = function()
          require("plugins.fidget")
        end,
      },
      {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = function()
          return require("plugins.conform")
        end,
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
      "fang2hou/blink-copilot",
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
    -- Not a blink-copilot dependency: lazy.nvim loads dependencies together
    -- with their parent, which would configure copilot.lua during blink's
    -- InsertEnter load. As a standalone lazy spec it loads through lazy.nvim's
    -- module loader the moment blink-copilot first require()s it.
    "zbirenbaum/copilot.lua",
    lazy = true,
    config = function()
      require("plugins.copilot")
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
      cmd = "Oil",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      -- netrw is disabled in lazy.nvim's rtp, so `nvim <dir>` has no
      -- fallback explorer: when any startup argument is a directory, load
      -- oil eagerly so its own hijack takes the buffer. The check is
      -- argv+fs_stat only -- no requires on the clean-start path.
      init = function()
        for i = 0, vim.fn.argc() - 1 do
          local stat = vim.uv.fs_stat(vim.fn.argv(i) --[[@as string]])
          if stat and stat.type == "directory" then
            require("lazy").load({ plugins = { "oil.nvim" } })
            return
          end
        end
      end,
      opts = function()
        return require("plugins.oil")
      end,
      keys = {
        { "-", "<Cmd>Oil<CR>", desc = "Open parent directory" },
        { "<Leader>e", "<Cmd>Oil<CR>", desc = "File Explorer (Oil)" },
      },
    },
    {
      "folke/edgy.nvim",
      -- Its only configured consumers are the snacks_terminal panels below
      -- (edgy's own defaults manage nothing), so the terminal filetype is
      -- the earliest moment edgy can have any effect. Snacks terminals
      -- default to position=float in lua/plugins/snacks.lua, which these
      -- edge panels never match anyway; pty parity vs the VeryLazy trigger
      -- was verified for an explicit position=bottom terminal.
      ft = "snacks_terminal",
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
      -- winbar breadcrumbs need a file window; nothing to draw at idle.
      event = "BufReadPost",
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
      -- attaches per buffer anyway; BufReadPre keeps signs on the first file.
      event = { "BufReadPre", "BufNewFile" },
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
      -- scrollbar marks only make sense once a real buffer is displayed.
      event = "BufReadPost",
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
      opts = function()
        return require("plugins.todo-comment")
      end,
    },
  },

  -- Operator
  {
    -- The three kana/vim-operator-user operators load from stubs on their
    -- <Plug> targets (the accelerated-jk pattern): the typed maps in
    -- lua/config/keymap.lua keep their noremap lhs, and an rhs starting with
    -- <Plug> is always remapped, so the stub fires on first press, loads the
    -- plugin (vim-operator-user rides along as a dependency), and re-feeds.
    -- Stubbing <Plug> lhs adds no typed-key prefixes, so operator-pending
    -- timeout behavior is untouched.
    {
      "kana/vim-operator-replace",
      -- No live mapping references <Plug>(operator-replace) (the one in
      -- lua/config/keymap.lua is commented out); the stub keeps the target
      -- reachable for runtime-added maps at zero burst cost.
      keys = {
        { "<Plug>(operator-replace)", mode = { "n", "v" } },
      },
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "rhysd/vim-operator-surround",
      -- td/ti/tr visual maps in lua/config/keymap.lua feed these.
      keys = {
        { "<Plug>(operator-surround-delete)", mode = "v" },
        { "<Plug>(operator-surround-append)", mode = "v" },
        { "<Plug>(operator-surround-replace)", mode = "v" },
      },
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "mopp/vim-operator-convert-case",
      -- tu visual map in lua/config/keymap.lua feeds this.
      keys = {
        { "<Plug>(operator-convert-case-upper-camel)", mode = "v" },
      },
      dependencies = {
        "kana/vim-operator-user",
      },
    },
    {
      "AndrewRadev/switch.vim",
      -- the only live entry is the manual `gs` -> `:Switch` map in
      -- lua/config/keymap.lua; the command stub covers it. The globals moved
      -- here from the (unrelated) convert-case spec: `init` runs at startup,
      -- so g:switch_mapping is cleared before the plugin ever loads.
      cmd = { "Switch", "SwitchReverse" },
      init = function()
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
    },
    {
      "junegunn/vim-easy-align",
      cmd = {
        "EasyAlign",
      },
    },
    {
      "tyru/open-browser.vim",
      -- gx (n/v) in lua/config/keymap.lua feeds this <Plug>; stubbing the
      -- <Plug> itself (accelerated-jk pattern) survives that noremap map,
      -- because an rhs starting with <Plug> is always remapped.
      keys = {
        { "<Plug>(openbrowser-smart-search)", mode = { "n", "v" } },
      },
    },
    {
      "tkmpypy/chowcho.nvim",
      -- No live entry point: every win_keymap_set() call in
      -- lua/plugins/chowcho.lua is commented out, so the VeryLazy load only
      -- paid setup cost for an unreachable picker. Module-loader lazy keeps
      -- require("chowcho")/require("plugins.chowcho") working if a map
      -- returns; restore-or-remove is tracked with the round-2 lead.
      lazy = true,
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
      -- upstream-recommended trigger; without one this spec (defaults.lazy =
      -- true) never loaded at all.
      event = { "BufRead Cargo.toml" },
      opts = function()
        return require("plugins.crates")
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
            opts = function()
              return require("plugins.image")
            end,
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
      -- every entry point is `:Trouble ...` (lua/lsp/init.lua keymaps run
      -- `<Cmd>Trouble ...<CR>`); the command stub loads it on first use.
      cmd = "Trouble",
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
      opts = function()
        return require("plugins.which-key")
      end,
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
      -- autoclose=true is the whole point: hbac must count buffers as they
      -- appear, so its true trigger is the first listed buffer (BufAdd never
      -- fires for the initial startup buffer), not a key or command.
      event = "BufAdd",
      cmd = "Hbac",
      opts = {
        autoclose = true,
        threshold = 10,
        close_buffers_with_windows = false,
      },
    },
    {
      "gbprod/yanky.nvim",
      -- no y/p remaps exist in this config; the ring only has value if it
      -- records every yank, so the first TextYankPost is the real trigger
      -- (lazy re-emits the event after loading, so that yank is captured).
      event = "TextYankPost",
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
      -- heartbeats only matter once editing starts; the burst's heaviest
      -- plugin (8-10 ms) has no business in a no-file idle session.
      event = { "BufReadPost", "BufNewFile", "InsertEnter" },
      opts = {
        cli_path = util.homebrew_binary("wakatime-cli-head", "wakatime-cli"),
        python_binary = util.homebrew_binary("python@3.14", "python3"),
        status_bar_enabled = false,
      },
    },
  },
}
