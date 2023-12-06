local function io_exist(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local homedir = vim.uv.os_homedir()

local go_path = vim.fs.joinpath(homedir, "go/src/github.com")
local src_path = vim.fs.joinpath(homedir, "src/github.com")

-- bootstrap packer
local install_path = vim.fs.joinpath(vim.fn.stdpath("data"), "site/pack/packer/start/packer.nvim")
local bootstrap = false
if not io_exist(install_path) then
  bootstrap = true
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

vim.cmd("packadd packer.nvim")
local packer = require("packer")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("packerConfig", { clear = false }),
  pattern = { "*.lua" },
  callback = function()
    packer.install()
    packer.compile()
  end,
})

packer.init({
  package_root = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack"),
  compile_path = vim.fs.joinpath(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
  luarocks = {
    python_cmd = "python3.11",
  },
})

packer.startup({
  function()
    local use = packer.use

    use({
      "wbthomason/packer.nvim",
    })

    -- local
    use({
      vim.fs.joinpath(src_path, "zchee/vim-goasm"),
    })
    use({
      vim.fs.joinpath(src_path, "zchee/vim-flatbuffers"),
    })
    use({
      vim.fs.joinpath(src_path, "zchee/vim-gn"),
    })
    use({
      vim.fs.joinpath(src_path, "zchee/vim-go-testscript"),
    })

    use({
      vim.fs.joinpath(src_path, "esensar/nvim-dev-container"),
      requires = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("zchee.plugins.devcontainer")
      end,
    })

    use({
      "hrsh7th/nvim-cmp",
      module = { "cmp" },
      requires = {
        {
          "junnplus/lsp-setup.nvim",
          requires = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
          },
        },
        {
          "hrsh7th/cmp-nvim-lsp",
        },
        {
          "hrsh7th/cmp-nvim-lsp-document-symbol",
          event = "InsertEnter",
        },
        {
          "hrsh7th/cmp-nvim-lsp-signature-help",
          event = "InsertEnter",
        },
        {
          "hrsh7th/cmp-buffer",
          event = "InsertEnter",
        },
        {
          "hrsh7th/cmp-path",
          event = "InsertEnter",
        },
        {
          "onsails/lspkind-nvim",
        },
        {
          "L3MON4D3/LuaSnip",
          run = { "make install_jsregexp" },
          requires = {
            "rafamadriz/friendly-snippets",
            "molleweide/LuaSnip-snippets.nvim",
          },
          -- event = "InsertEnter",
        },
        {
          "saadparwaiz1/cmp_luasnip",
          event = "InsertEnter",
        },
        {
          "lvimuser/lsp-inlayhints.nvim",
          config = function()
            require("zchee.plugins.lsp-inlayhints")
          end,
        },
        {
          "j-hui/fidget.nvim",
          tag = "legacy",
          config = function()
            require("zchee.plugins.fidget")
          end,
        },
        {
          "nvimdev/lspsaga.nvim",
          requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
          },
          config = function()
            require("zchee.plugins.lspsaga")
          end,
        },
        {
          "ray-x/lsp_signature.nvim",
        },
        {
          "windwp/nvim-autopairs",
          requires = {
            "nvim-treesitter/nvim-treesitter",
          },
        },
        -- git
        {
          "petertriho/cmp-git",
          requires = {
            "nvim-lua/plenary.nvim",
          },
          ft = "gitcommit",
        },
        -- lua
        {
          "folke/neodev.nvim",
        },
        {
          "hrsh7th/cmp-nvim-lua",
          ft = "lua",
        },
        -- yaml
        {
          "b0o/schemastore.nvim",
        },
      },
      config = function()
        require("zchee.plugins.autopairs")
        require("zchee.plugins.lsp-config")
        require("zchee.plugins.cmp")
      end,
    })
    -- use({
    --   "echasnovski/mini.pairs",
    --   config = function()
    --     require("zchee.plugins.mini_pairs")
    --   end,
    -- })

    -- use({
    --   "lukas-reineke/lsp-format.nvim",
    -- })

    -- Linter
    -- use({
    --   "jose-elias-alvarez/null-ls.nvim",
    --   -- config = function()
    --   --   local null_ls = require("null-ls")
    --   --   null_ls.setup({
    --   --     sources = {
    --   --       null_ls.builtins.code_actions.shellcheck,
    --   --       null_ls.builtins.completion.spell,
    --   --       null_ls.builtins.diagnostics.eslint,
    --   --       null_ls.builtins.formatting.stylua,
    --   --     },
    --   --     log_level = "trace",
    --   --   })
    --   -- end,
    --   requires = { "nvim-lua/plenary.nvim" },
    --   config = function()
    --     require("zchee.plugins.null-ls")
    --   end,
    -- })
    -- use({
    --   "jose-elias-alvarez/null-ls.nvim",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --   },
    --   config = function()
    --     require("zchee.plugins.null-ls")
    --   end,
    -- })

    -- telescope
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        {
          "nvim-lua/plenary.nvim",
        },
        {
          "nvim-lua/popup.nvim",
        },
        {
          "nvim-telescope/telescope-dap.nvim",
        },
        {
          "nvim-telescope/telescope-live-grep-args.nvim",
        },
        {
          "nvim-telescope/telescope-ui-select.nvim",
        },
        {
          "tamago324/telescope-openbrowser.nvim",
        },
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = {
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" },
        },
      },
      config = function()
        require("zchee.plugins.telescope")
      end,
    })

    -- tree-sitter
    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        {
          -- Additional text objects via treesitter
          "nvim-treesitter/nvim-treesitter-textobjects",
          after = "nvim-treesitter",
          requires = { "nvim-treesitter/nvim-treesitter" },
        },
        {
          "nvim-treesitter/nvim-treesitter-context",
          disable = true,
        },
        {
          "nvim-treesitter/nvim-tree-docs",
        },
        -- {
        --   "nvim-treesitter/nvim-treesitter-refactor",
        -- },
        -- {
        --   "nvim-treesitter/playground",
        --   cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
        -- },
      },
      run = ":TSUpdate",
      config = function()
        require("zchee.plugins.treesitter")
      end,
    })

    -- terminal
    use({
      "akinsho/toggleterm.nvim",
      config = function()
        require("zchee.plugins.toggleterm")
      end,
    })

    -- Develop

    -- UI
    use {
      "nvim-lualine/lualine.nvim",
      requires = {
        "nvim-tree/nvim-web-devicons",
        opt = true,
      },
      config = function()
        require("zchee.plugins.lualine")
      end,
    }
    -- use({
    --   "itchyny/lightline.vim",
    --   requires = {
    --     "ryanoasis/vim-devicons",
    --   },
    -- })
    use({
      "akinsho/bufferline.nvim",
      requires = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("zchee.plugins.bufferline")
      end,
    })
    use({
      "liuchengxu/vista.vim",
      cmd = { "Vista" },
    })
    use({
      "AmeerTaweel/todo.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("zchee.plugins.todo")
      end,
    })
    use({
      "petertriho/nvim-scrollbar",
      config = function()
        require("zchee.plugins.scrollbar")
      end,
    })
    use({
      "utilyre/barbecue.nvim",
      requires = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },
      after = "nvim-web-devicons",
      config = function()
        require("zchee.plugins.barbecue")
      end,
    })
    -- use({
    --   "stevearc/dressing.nvim",
    --   requires = {
    --     "MunifTanjim/nui.nvim",
    --   },
    --   config = function()
    --     require("zchee.plugins.dressing")
    --   end,
    -- })
    use({
      "andymass/vim-matchup",
      setup = function()
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
      requires = {
        "nvmi-treesitter/nvim-treesitter",
      },
      config = function()
        require("zchee.plugins.matchup")
      end,
    })
    use({
      "yamatsum/nvim-nonicons",
    })

    -- file tree
    use({
      "nvim-tree/nvim-tree.lua",
      requires = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("zchee.plugins.tree")
      end,
    })

    -- quickfix
    use({
      "kevinhwang91/nvim-bqf",
      ft = "qf",
      config = function()
        require("zchee.plugins.bqf")
      end,
    })

    -- git
    use({
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("zchee.plugins.gitsigns")
      end,
    })
    -- use({
    --   "TimUntersberger/neogit",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --     "sindrets/diffview.nvim",
    --   },
    --   cmd = "Neogit",
    --   config = function()
    --     require("zchee.plugins.neogit")
    --   end,
    -- })

    -- Dap
    use({
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "leoluz/nvim-dap-go",
        "jbyuki/one-small-step-for-vimkind",
      },
      config = function()
        require("zchee.plugins.dap")
      end,
    })

    -- operator
    use({
      "kana/vim-operator-replace",
      requires = {
        "kana/vim-operator-user",
      },
    })
    use({
      "rhysd/vim-operator-surround",
      requires = {
        "kana/vim-operator-user",
      },
    })
    use({
      "mopp/vim-operator-convert-case",
      requires = {
        "kana/vim-operator-user",
      },
    })

    -- comment
    use({
      "numToStr/Comment.nvim",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      config = function()
        require("zchee.plugins.comment")
      end,
    })

    -- utilities
    use({
      "NvChad/nvim-colorizer.lua",
      cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers", "ColorizerToggle" },
      config = function()
        require("colorizer").setup({
          filetypes = { "*" },
          user_default_options = {
            RGB = true,          -- #RGB hex codes
            RRGGBB = true,       -- #RRGGBB hex codes
            names = true,        -- "Name" codes like Blue or blue
            RRGGBBAA = false,    -- #RRGGBBAA hex codes
            AARRGGBB = false,    -- 0xAARRGGBB hex codes
            rgb_fn = false,      -- CSS rgb() and rgba() functions
            hsl_fn = false,      -- CSS hsl() and hsla() functions
            css = false,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            css_fn = false,      -- Enable all CSS *functions*: rgb_fn, hsl_fn
            -- Available modes for `mode`: foreground, background,  virtualtext
            mode = "background", -- Set the display mode.
            -- Available methods are false / true / "normal" / "lsp" / "both"
            -- True is same as normal
            virtualtext = "■",
          },
          buftypes = {},
        })
      end,
    })
    use({
      "folke/which-key.nvim",
      cmd = "WhichKey",
      config = function()
        require("zchee.plugins.whichkey")
      end,
    })
    use({
      "devoc09/gpt-trans.nvim",
      run = { "make" },
      cmd = { "Trans", "TransWord" },
      config = function()
        vim.g.trans_lang_output = "float"
      end,
    })
    use({
      "krady21/compiler-explorer.nvim",
      requires = {
        "stevearc/dressing.nvim",
      },
    })
    use({
      "tkmpypy/chowcho.nvim",
      config = function()
        require("zchee.plugins.chowcho")
      end,
    })
    use({
      "AndrewRadev/switch.vim",
    })
    use({
      "haya14busa/vim-asterisk",
    })
    use({
      "junegunn/vim-easy-align",
      cmd = { "EasyAlign" },
    })
    use({
      "rainbowhxch/accelerated-jk.nvim",
      config = function()
        require("accelerated-jk").setup({
          mode = "time_driven",
          enable_deceleration = true,
          acceleration_motions = {},
          acceleration_limit = 500,                                                                             -- 70, 250, 350
          acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 },                                         -- { 1, 2, 7, 12, 17, 21, 24, 26, 28 }
          deceleration_table = { { 200, 3 }, { 300, 7 }, { 450, 11 }, { 600, 15 }, { 750, 21 }, { 900, 9999 } } -- when 'enable_deceleration = true', 'deceleration_table = { {200, 3}, {300, 7}, {450, 11}, {600, 15}, {750, 21}, {900, 9999} }'
        })
      end,
    })
    use({
      "RRethy/vim-illuminate",
      config = function()
        require("zchee.plugins.illuminate")
      end,
    })
    use({
      "tyru/open-browser.vim",
    })
    use({
      "Shougo/vinarise.vim",
      cmd = { "Vinarise", "VinarisePluginDump" },
    })
    use({
      "wakatime/vim-wakatime",
    })
    use({
      "tweekmonster/helpful.vim",
      cmd = { "HelpfulVersion" },
    })

    -- Debug
    use({
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
    })

    -- Languages
    -- use({
    --   "ray-x/go.nvim",
    --   requires = {  -- optional packages
    --     "ray-x/guihua.lua",
    --     "neovim/nvim-lspconfig",
    --     "nvim-treesitter/nvim-treesitter",
    --   },
    --   config = function()
    --     require("zchee.plugins.go")
    --   end,
    --   ft = {"go"},
    -- })
    -- use({
    --   "tjdevries/green_light.nvim",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --   },
    -- })
    use({
      "raimon49/requirements.txt.vim",
    })
    use({
      "jjo/vim-cue",
      -- "hofstadter-io/cue.vim",
    })
    use({
      "milisims/nvim-luaref",
      ft = { "lua" },
    })
    -- use({
    --   "vim-jp/vim-cpp",
    --   ft = { "c", "cpp" },
    -- })
    -- use({
    --   "keith/swift.vim",
    --   ft = { "swift" },
    -- })
    -- use({
    --   "pboettch/vim-cmake-syntax",
    --   ft = { "cmake" },
    -- })
    -- use({
    --   "neui/cmakecache-syntax.vim",
    --   ft = { "cmake" },
    -- })
    -- use({
    --   "rust-lang/rust.vim",
    --   ft = { "rust" },
    -- })
    -- use({
    --   "uarun/vim-protobuf",
    --   ft = { "proto" },
    -- })
    -- use({
    --   "cappyzawa/starlark.vim",
    -- })
    -- use({
    --   "HerringtonDarkholme/yats.vim",
    --   ft = "yaml",
    -- })
    -- use({
    --   "toppair/peek.nvim",
    --   run = "deno task --quiet build:fast",
    --   setup = function()
    --     require("peek").setup({
    --       auto_load = true,          -- whether to automatically load preview when
    --       -- entering another markdown buffer
    --       close_on_bdelete = true,   -- close preview window on buffer delete
    --       syntax = true,             -- enable syntax highlighting, affects performance
    --       theme = 'dark',            -- 'dark' or 'light'
    --       update_on_change = true,
    --       app = "browser",           -- 'webview', 'browser', string or a table of strings
    --       -- explained below
    --       filetype = { 'markdown' }, -- list of filetypes to recognize as markdown
    --       -- relevant if update_on_change is true
    --       throttle_at = 200000,      -- start throttling when file exceeds this
    --       -- amount of bytes in size
    --       throttle_time = 'auto',    -- minimum amount of time in milliseconds
    --       -- that has to pass before starting new render
    --     })
    --   end,
    -- })
    -- use({
    --   "iamcco/markdown-preview.nvim",
    --   requires = {
    --     "aklt/plantuml-syntax",
    --     "zhaozg/vim-diagram",
    --   },
    --   run = { "cd app & yarn install" },
    --   ft = "markdown",
    --   setup = function()
    --     vim.g.mkdp_filetypes = { "markdown" }
    --   end,
    --   config = function()
    --     vim.cmd([[
    --       function! s:markdown_preview_kitty()
    --       call mkdp#util#open_preview_page()
    --       call timer_start(500, {-> system("kitty @ focus-window")}, {"repeat": 1})
    --       endfunction
    --       command! -nargs=* MarkdownPreviews call s:markdown_preview_kitty()
    --       ]])
    --   end,
    -- })
    -- use({
    --   "udalov/kotlin-vim",
    --   ft = { "kotlin" },
    -- })
    -- use({
    --   "mfussenegger/nvim-jdtls",
    --   ft = { "java" },
    -- })
    -- use({
    --   "moorereason/vim-markdownfmt",
    --   ft = { "markdown" },
    -- })
    use({
      "jparise/vim-graphql",
    })
    -- use({
    --   "mracos/mermaid.vim",
    -- })
    -- use({
    --   "b4winckler/vim-objc",
    --   ft = { "objc" },
    -- })
    -- use({
    --   "gisphm/vim-gitignore",
    -- })
    use({
      "rhysd/vim-syntax-codeowners",
    })
    -- use({
    --   "vim-jp/vimdoc-ja",
    -- })
    -- use({
    --   "vim-jp/syntax-vim-ex",
    --   ft = "vim",
    -- })
    -- use({
    --   "cespare/vim-toml",
    --   ft = "toml",
    -- })
    -- use({
    --   "elzr/vim-json",
    --   ft = "json",
    -- })
    -- use({
    --   "kyoh86/vim-jsonl",
    --   ft = "jsonl",
    -- })
    -- use({
    --   "gennaro-tedesco/nvim-jqx",
    --   ft = "json",
    -- })
    -- use({
    --   "gutenye/json5.vim",
    --   ft = { "json5" },
    -- })
    -- use({
    --   "hashivim/vim-terraform",
    --   ft = { "hcl", "terraform" },
    -- })
    -- use({
    --   "ericpruitt/tmux.vim",
    --   rtp = "vim/",
    -- })
    -- use({
    --   "vim-scripts/vim-niji",
    -- })
    -- use({
    --   "compnerd/modulemap-vim",
    -- })
    -- use({
    --   "aklt/plantuml-syntax",
    --   ft = { "plantuml" },
    -- })
    -- use({
    --   "weirongxu/plantuml-previewer.vim",
    --   ft = { "plantuml" },
    -- })
    -- use({
    --   "chrisbra/vim-zsh",
    --   ft = { "zsh" },
    -- })

    -- unsed
    -- use({
    --   "doums/oterm.nvim",
    --   config = function()
    --     require("zchee.plugins.oterm")
    --   end,
    -- })
    -- use {
    --   "nvim-neotest/neotest",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --     "nvim-treesitter/nvim-treesitter",
    --     "antoinemadec/FixCursorHold.nvim",
    --     'akinsho/neotest-go',
    --   },
    --   config = function()
    --     require("zchee.plugins.neotest")
    --   end,
    -- }
    -- use {
    --   "mfussenegger/nvim-lint",
    --   config = function()
    --     require("zchee.plugins.lint")
    --   end,
    -- }
    -- use {
    --   "ms-jpq/coq_nvim",
    --   requires = {
    --     {
    --       "ms-jpq/coq.thirdparty",
    --       config = function()
    --         require "coq_3p" {
    --           {
    --             src = "nvimlua",
    --             short_name = "nlua",
    --             conf_only = false,
    --           },
    --           {
    --             src = "dap",
    --           },
    --           {
    --             src = "vim_dadbod_completion",
    --             short_name = "dadbod",
    --           },
    --         }
    --       end
    --     },
    --     "ms-jpq/coq.artifacts",
    --     "neovim/nvim-lspconfig",
    --     "junnplus/nvim-lsp-setup",
    --     "williamboman/mason.nvim",
    --     "williamboman/mason-lspconfig.nvim",
    --     "onsails/lspkind-nvim",
    --     "ray-x/lsp_signature.nvim",
    --     -- languages
    --     "folke/lua-dev.nvim",
    --     {
    --       "windwp/nvim-autopairs",
    --       requires = {
    --         "nvim-treesitter/nvim-treesitter",
    --       },
    --     },
    --     {
    --       "b0o/schemastore.nvim",
    --       ft = "yaml",
    --     },
    --   },
    --   config = function()
    --     require("zchee.plugins.autopairs")
    --     require("zchee.plugins.lsp-config")
    --     require('zchee.plugins.coq')
    --   end,
    -- }
    -- use {
    --   "ms-jpq/coq_nvim",
    --   requires = {
    --     "neovim/nvim-lspconfig",
    --     "williamboman/nvim-lsp-installer",
    --     "folke/lua-dev.nvim",
    --     "ray-x/lsp_signature.nvim",
    --     "ms-jpq/coq.artifacts",
    --     "b0o/schemastore.nvim",
    --   },
    --   config = function()
    --     require('zchee.plugins.coq')
    --     require('zchee.plugins.lsp')
    --   end,
    -- }
    -- use {
    --   "ms-jpq/coq.thirdparty",
    --   config = function()
    --     require "coq_3p" {
    --     {
    --         src = "nvimlua",
    --         short_name = "nlua",
    --         conf_only = false,
    --       },
    --       {
    --         src = "dap",
    --       },
    --       {
    --         src = "vim_dadbod_completion",
    --         short_name = "dadbod",
    --       },
    --     }
    --   end
    -- }
    -- use {
    --   "Shougo/ddc.vim",
    --   requires = {
    --     "vim-denops/denops.vim",
    --     "Shougo/ddc-nvim-lsp",
    --     "Shougo/ddc-converter_remove_overlap",
    --     "Shougo/ddc-matcher_head",
    --     "Shougo/ddc-sorter_rank",
    --     "neovim/nvim-lspconfig",
    --     "williamboman/nvim-lsp-installer",
    --     "Shougo/pum.vim",
    --     "ray-x/lsp_signature.nvim",
    --     "Shougo/echodoc.vim",
    --     "matsui54/ddc-nvim-lsp-doc",
    --     "b0o/schemastore.nvim",
    --   },
    --   config = function()
    --     require('zchee.plugins.ddc')
    --     require('zchee.plugins.lsp')
    --   end
    -- }
    -- use {
    --   "Shougo/deol.nvim",
    -- }
    -- use {
    --   "voldikss/vim-floaterm",
    --   cmd = {
    --     "FloatermNew",
    --     "FloatermToggle",
    --     "FloatermPrev",
    --     "FloatermNext",
    --     "FloatermHide",
    --   },
    -- }
    -- use {
    --   "nathom/filetype.nvim",
    --   config = function()
    --     require('zchee.plugins.filetype')
    --   end
    -- }
    -- use {
    --   "sidebar-nvim/sidebar.nvim",
    --   config = function ()
    --     local sidebar = require("sidebar-nvim")
    --     sidebar.setup({
    --       section_separator = {"", "=====", ""},
    --       open = true,
    --       disable_closing_prompt = true,
    --     })
    --   end,
    -- }
    -- use {
    --   "norcalli/nvim-colorizer.lua",
    --   ft = { "vim", "kitty" },
    --   config = function()
    --     require("colorizer").setup {
    --       "vim",
    --       "kitty",
    --     }
    --   end,
    -- }
    -- use {
    --   "RRethy/vim-hexokinase",
    --   cmd = { "HexokinaseToggle", "HexokinaseRefresh" },
    --   run = { "make hexokinase" },
    -- }
    -- use {
    --   "lepture/vim-jinja",
    -- }
    -- use {
    --   "direnv/direnv.vim",
    -- }

    -- unsed
    -- terraform
    -- use {
    --   "hashivim/vim-terraform",
    --   ft = "terraform",
    -- }
    -- sql
    -- use {
    --   "tpope/vim-dadbod",
    -- }
    -- use {
    --   "kristijanhusak/vim-dadbod-completion",
    -- }
    -- use {
    --   "kristijanhusak/vim-dadbod-ui",
    -- }
    -- use {
    --   "bfrg/vim-cpp-modern",
    --   ft = { "c", "cpp" },
    -- }
    -- use {
    --   "octol/vim-cpp-enhanced-highlight",
    --   ft = { "c", "cpp" },
    -- }
    -- use {
    --   "Shirk/vim-gas",
    --   ft = { "gas" },
    -- }

    if bootstrap then
      require("packer").sync()
    end
  end,
})
