local function io_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local function join_paths(...)
  return table.concat({ ... }, "/")
end

local homedir = vim.loop.os_homedir()

-- bootstrap packer
local install_path = join_paths(vim.fn.stdpath("data"), "site/pack/packer/start/")
local bootstrap = false
if not io_exists(install_path) then
  bootstrap = true

  vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
  vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/nvim-lua/plenary.nvim", install_path})
end

vim.cmd([[
  packadd packer.nvim
  packadd plenary.nvim

  augroup packerUserConfig
    autocmd!
    autocmd BufWritePost plugin.lua source <afile> | PackerInstall
    autocmd BufWritePost plugin.lua source <afile> | PackerCompile
  augroup end
]])

local packer = require("packer")

local gopath = join_paths(homedir, "go/src/github.com/")
local src = join_paths(homedir, "src/github.com/")


packer.init {
  max_jobs = 20,
  package_root = join_paths(vim.fn.stdpath("data"), "site", "pack"),
  compile_path = join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
  luarocks = {
    python_cmd = "python3.10",
  },
}

-- use {
--   -- The following keys are all optional
--   disable = boolean,                                     -- Mark a plugin as inactive
--   as = string,                                           -- Specifies an alias under which to install the plugin
--   installer = function,                                  -- Specifies custom installer. See |packer-custom-installers|
--   updater = function,                                    -- Specifies custom updater. See |packer-custom-installers|
--   after = string or list,                                -- Specifies plugins to load before this plugin.
--   rtp = string,                                          -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,                                         -- Manually marks a plugin as optional.
--   branch = string,                                       -- Specifies a git branch to use
--   tag = string,                                          -- Specifies a git tag to use. Supports '*' for "latest tag"
--   commit = string,                                       -- Specifies a git commit to use
--   lock = boolean,                                        -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table                       -- Post-update/install hook. See |packer-plugin-hooks|
--   requires = string or list                              -- Specifies plugin dependencies. See |packer-plugin-dependencies|
--   config = string or function,                           -- Specifies code to run after this plugin is loaded.
--   rocks = string or list,                                -- Specifies Luarocks dependencies for the plugin
--
--   -- The following keys all imply lazy-loading
--   cmd = string or list,                                  -- Specifies commands which load this plugin.  Can be an autocmd pattern.
--   ft = string or list,                                   -- Specifies filetypes which load this plugin.
--   keys = string or list,                                 -- Specifies maps which load this plugin. See |packer-plugin-keybindings|
--   event = string or list,                                -- Specifies autocommand events which load this plugin.
--   fn = string or list                                    -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions, -- Specifies a conditional test to load this plugin
--   setup = string or function,                            -- Specifies code to run before this plugin is loaded.
--   module = string or list                                -- Specifies Lua module names for require. When requiring a string which starts with one of these module names, the plugin will be loaded.
--   module_pattern = string/list                           -- Specifies Lua pattern of Lua module names for require. When requiring a string which matches one of these patterns, the plugin will be loaded.
-- }
return packer.startup(
  function()
    local use = packer.use

    use {
      "wbthomason/packer.nvim",
    }

    use {
      "lewis6991/impatient.nvim",
    }

    -- needed while issue https://github.com/neovim/neovim/issues/12587 is still open
    use {
      "antoinemadec/FixCursorHold.nvim",
      run = function()
        vim.g.curshold_updatime = 100
      end,
    }

    -- local
    use {
      join_paths(gopath, "zchee/nvim-go"),
      ft = "go",
    }
    use {
      join_paths(src, "zchee/vim-goasm"),
    }
    use {
      join_paths(src, "zchee/vim-flatbuffers"),
    }
    use {
      join_paths(src, "zchee/vim-gn"),
    }
    use {
      join_paths(src, "zchee/vim-go-testscript"),
    }
    -- use {
    --   gopath.."/zchee/nvim-lsp",
    --   ft = "go",
    -- }
    -- use {
    --   src.."/deoplete-plugins/deoplete-cgo",
    -- }
    -- use {
    --   src.."/deoplete-plugins/deoplete-asm",
    -- }
    -- use {
    --   src.."/deoplete-plugins/deoplete-zsh",
    -- }

    -- LSP
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        "neovim/nvim-lspconfig",
        "junnplus/nvim-lsp-setup",
        "williamboman/nvim-lsp-installer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "molleweide/LuaSnip-snippets.nvim",
        "ray-x/lsp_signature.nvim",
        -- "hrsh7th/cmp-cmdline",  -- TODO(zchee): dig usage
        {
          "windwp/nvim-autopairs",
          requires = {
            "nvim-treesitter/nvim-treesitter",
          },
        },
        {
          "petertriho/cmp-git",
          requires = {
            "nvim-lua/plenary.nvim",
          },
          ft = "gitcommit",
        },
        {
          "folke/lua-dev.nvim",
        },
        {
          "hrsh7th/cmp-nvim-lua",
          ft = "lua",
        },
        {
          "b0o/schemastore.nvim",
          ft = "yaml",
        },
      },
      config = function()
        require("zchee.plugins.autopairs")
        require("zchee.plugins.lsp-config")
        require("zchee.plugins.cmp")
      end,
    }
    use {
      join_paths(src, "tami5/lspsaga.nvim"),  -- "tami5/lspsaga.nvim",
      config = function()
        require("zchee.plugins.lspsaga")
      end,
    }
    use {
      "j-hui/fidget.nvim",
      config = function()
        require("zchee.plugins.fidget")
      end,
    }

    use {
      "stevearc/dressing.nvim",
      -- disable = true,
      requires = {
        "MunifTanjim/nui.nvim"
      },
      config = function()
        require("zchee.plugins.dressing")
      end
    }

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
    --       -- {
    --       --   src = "dap",
    --       -- },
    --       -- {
    --       --   src = "vim_dadbod_completion",
    --       --   short_name = "dadbod",
    --       -- },
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

    -- LSP
    -- use {
    --   "neovim/nvim-lspconfig",
    -- }
    -- use {
    --   "williamboman/nvim-lsp-installer",
    -- }

    -- use {
    --   "stevearc/dressing.nvim",
    --   -- disable = true,
    --   requires = {
    --     "MunifTanjim/nui.nvim"
    --   },
    --   config = function()
    --     require("zchee.plugins.dressing")
    --   end
    -- }

    -- telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-packer.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = "make",
        },
      },
      config = function()
        require("zchee.plugins.telescope")
      end,
    }

    -- tree-sitter
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("zchee.plugins.treesitter")
      end,
    }

    -- UI
    use {
      "andymass/vim-matchup",
      requires = {
        "nvmi-treesitter/nvim-treesitter",
      },
      config = function()
        require("zchee.plugins.matchup")
      end,
    }

    -- file tree
    use {
      "kyazdani42/nvim-tree.lua",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      config = function ()
        require("zchee.plugins.tree")
      end,
    }

    -- git
    use {
      "TimUntersberger/neogit",
      disable = true,
      requires = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      -- cmd = "Neogit",
      config = function()
        require("zchee.plugins.neogit")
      end
    }
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require("zchee.plugins.gitsigns")
      end
    }

    -- quickfix
    use {
      "kevinhwang91/nvim-bqf",
      requires = {
        "junegunn/fzf",
      },
      ft = "qf",
      config = function ()
        require("zchee.plugins.bqf")
      end,
    }

    -- Dap
    use {
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "jbyuki/one-small-step-for-vimkind",
        "leoluz/nvim-dap-go",
      },
      config = function()
        require("zchee.plugins.dap")
      end,
    }

    -- UI
    use{
      "itchyny/lightline.vim",
      requires = {
        "ryanoasis/vim-devicons",
        "maximbaz/lightline-ale",
        -- "mgee/lightline-bufferline",
      },
    }
    use {
      "akinsho/bufferline.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("zchee.plugins.bufferline")
      end,
    }
    use {
      "voldikss/vim-floaterm",
      disable = true,
      cmd = {
        "FloatermNew",
        "FloatermToggle",
        "FloatermPrev",
        "FloatermNext",
        "FloatermHide",
      },
    }
    use {
      "liuchengxu/vista.vim",
      -- disable = true,
      cmd = { "Vista" },
    }

    -- linters
    use {
      "mfussenegger/nvim-lint",
      disable = true,
      config = function()
        require("zchee.plugins.lint")
      end,
    }

    -- operator
    use {
      "kana/vim-operator-user"
    }
    use {
      "kana/vim-repeat"
    }
    use {
      "kana/vim-operator-replace",
      requires = {
        "kana/vim-operator-user",
      },
    }
    use {
      "rhysd/vim-operator-surround",
      requires = {
        "kana/vim-operator-user",
      },
    }
    use {
      "mopp/vim-operator-convert-case",
      requires = {
        "kana/vim-operator-user",
      },
    }

    -- utilities
    use {
      "AndrewRadev/switch.vim"
    }
    use {
      "haya14busa/vim-asterisk"
    }
    use {
      "junegunn/vim-easy-align",
      cmd = { "EasyAlign" },
    }
    use {
      "rhysd/accelerated-jk"
    }
    use {
      "RRethy/vim-illuminate",
      config = function()
        vim.g.Illuminate_delay = 300
        vim.cmd([[
          hi LspReferenceText  guifg=None guibg=None gui=underline
          hi LspReferenceWrite guifg=None guibg=None gui=underline
          hi LspReferenceRead  guifg=None guibg=None gui=underline
        ]])
      end,
    }
    use {
      "tyru/caw.vim"
    }
    use {
      "tyru/open-browser.vim",
    }
    use {
      "Shougo/vinarise.vim",
      cmd = { "Vinarise", "VinarisePluginDump" },
    }
    use {
      "utahta/trans.nvim",
      cmd = { "Trans" },
      run = { "make" },
    }
    use {
      "wakatime/vim-wakatime"
    }

    -- Debug
    use {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
    }

    -- unsed
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

    -- languages
    use {
      "tjdevries/green_light.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
      },
    }
    use {
      "tweekmonster/hl-goimport.vim",
    }
    use {
      -- "hofstadter-io/cue.vim",
      "jjo/vim-cue",
    }
    use {
      "bfredl/nvim-luadev",
      ft = "lua",
    }
    use {
      "nanotee/luv-vimdocs",
      ft = "lua",
    }
    use {
      "milisims/nvim-luaref",
      ft = "lua",
    }
    use {
      "vim-jp/vim-cpp",
      ft = { "c", "cpp" },
    }
    use {
      "keith/swift.vim",
      ft = "swift",
    }
    use {
      "pboettch/vim-cmake-syntax",
      ft = "cmake",
    }
    use {
      "neui/cmakecache-syntax.vim",
      ft = "cmake",
    }
    use {
      "lambdalisue/vim-cython-syntax",
      ft = { "python", "cython" },
    }
    use {
      "rust-lang/rust.vim",
      ft = "rust",
    }
    use {
      "uarun/vim-protobuf",
      ft = "proto",
    }
    use {
      "cappyzawa/starlark.vim",
      ft = "starlark",
    }
    use {
      "HerringtonDarkholme/yats.vim",
      ft = "yaml",
    }

    -- markdown
    use {
      "iamcco/markdown-preview.nvim",
      run = { "cd app & yarn install" },
      config = function()
      --   -- vim.g.mkdp_auto_start = 0
      --   -- vim.g.mkdp_auto_close = 0
      --   vim.g.mkdp_markdown_css = config_path.."/assets/markdown-preview.nvim/github.css"
      --   vim.g.mkdp_highlight_css = config_path.."/assets/markdown-preview.nvim/highlight.css"
      --   -- vim.g.mkdp_preview_options = {
      --   --   mkit                = {},
      --   --   katex               = {},
      --   --   uml                 = {},
      --   --   maid                = {},
      --   --   disable_sync_scroll = 0,
      --   --   sync_scroll_type    = "middle",
      --   --   hide_yaml_meta      = 1,
      --   --   sequence_diagrams   = {},
      --   --   flowchart_diagrams  = {},
      --   --   content_editable    = true,
      --   --   disable_filename    = 1,
      --   -- }
        vim.cmd([[
          function! s:markdown_preview_kitty()
            call mkdp#util#open_preview_page()
            call timer_start(500, {-> system("kitty @ focus-window")}, {"repeat": 1})
          endfunction
          command! -nargs=* MarkdownPreviews call s:markdown_preview_kitty()
        ]])
      end
    }
    use {
      "moorereason/vim-markdownfmt",
      ft = "markdown",
    }

    -- git
    use {
      "gisphm/vim-gitignore",
    }
    use {
      "rhysd/vim-syntax-codeowners",
    }

    -- vim
    use {
      "vim-jp/vimdoc-ja",
    }
    use {
      "vim-jp/syntax-vim-ex",
      ft = "vim",
    }
    use {
      "cespare/vim-toml",
      ft = "toml",
    }
    use {
      "elzr/vim-json",
      ft = "json",
    }
    use {
      "gutenye/json5.vim",
    }
    use {
      "jparise/vim-graphql",
    }
    use {
      "ericpruitt/tmux.vim",
    }
    use {
      "hashivim/vim-terraform",
      ft = "terraform",
    }
    use {
      "vim-scripts/vim-niji",
    }
    -- modulemap
    use {
      "compnerd/modulemap-vim",
    }
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
    -- plantuml
    use {
      "aklt/plantuml-syntax",
    }
    use {
      "weirongxu/plantuml-previewer.vim",
    }
    -- kitty
    use {
      "fladson/vim-kitty",
    }
    -- zsh
    use {
      "chrisbra/vim-zsh",
    }

    -- unsed
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
  end
)
