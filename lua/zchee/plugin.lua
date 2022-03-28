local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PackerBootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

local config_path = fn.stdpath("config")
local gopath = fn.expand("~/go/src/github.com/")
local src = fn.expand("~/src/github.com/")

vim.cmd([[ packadd packer.nvim ]])
vim.cmd([[
augroup packerUserConfig
  autocmd!
  autocmd BufWritePost $HOME/src/github.com/zchee/.nvim/lua/**/*.lua source <afile> | PackerCompile
augroup end
]])

local packer = require("packer")
local join_paths = require("packer.util").join_paths

packer.init {
  max_jobs = 20,
  package_root = join_paths(vim.fn.stdpath("data"), "site", "pack"),
  compile_path = join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
  luarocks = {
    python_cmd = "python3",
  },
}

return packer.startup(
  function(use)
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
      gopath.."/zchee/nvim-go",
      ft = "go",
    }
    use {
      src.."zchee/vim-goasm",
    }
    use {
      src.."zchee/vim-flatbuffers",
    }
    use {
      src.."zchee/vim-gn",
    }
    use {
      src.."zchee/vim-go-testscript",
    }
    -- use {
    --   gopath.."/zchee/nvim-lsp",
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

    -- completion
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
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-document-symbol",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "petertriho/cmp-git",
        -- "hrsh7th/cmp-cmdline",  -- TODO(zchee): dig usage
        {
          "tamago324/cmp-zsh",
          ft = "zsh",
        },
        "folke/lua-dev.nvim",
        {
          "hrsh7th/cmp-nvim-lua",
          ft = "lua",
        },
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "molleweide/LuaSnip-snippets.nvim",
        "neovim/nvim-lspconfig",
        "williamboman/nvim-lsp-installer",
        "ray-x/lsp_signature.nvim",
        {
          "b0o/schemastore.nvim",
          ft = "yaml",
        },
      },
      config = function()
        require('zchee.plugins.lsp')
        require('zchee.plugins.cmp')
      end,
    }
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

    use {
      "ray-x/lsp_signature.nvim"
    }
    -- use {
    --   "folke/lua-dev.nvim",
    -- }

    -- LSP
    -- use {
    --   "neovim/nvim-lspconfig",
    -- }
    -- use {
    --   "williamboman/nvim-lsp-installer",
    --   config = function() 
    --     require('zchee.plugins.nvim-lsp')
    --   end
    -- }

    use {
      "windwp/nvim-autopairs",
      requires = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require('zchee.plugins.autopairs')
      end,
    }

    use {
      "stevearc/dressing.nvim",
      requires = {
        "MunifTanjim/nui.nvim"
      },
      config = function()
        require('zchee.plugins.dressing')
      end
    }

    -- telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-packer.nvim",
      },
      config = function()
        require("zchee.plugins.telescope")
      end,
    }
    -- use {
    --   "nvim-telescope/telescope-fzf-native.nvim",
    --   run = "make",
    -- }

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
    use {
      "kyazdani42/nvim-web-devicons",
    }

    -- git
    use {
      "TimUntersberger/neogit",
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
      config = function ()
        require("zchee.plugins.bqf")
      end,
    }

    -- use {
    --   "junegunn/fzf",
    --   run = function()
    --     vim.fn['fzf#install']()
    --   end,
    -- }

    -- Dap
    use {
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "jbyuki/one-small-step-for-vimkind",
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
        "mgee/lightline-bufferline",
      },
    }
    use {
      "voldikss/vim-floaterm",
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
      -- cmd = { "Vista" },
    }

    -- linters
    use {
      "mfussenegger/nvim-lint",
      config = function()
        require("zchee.plugins.lint")
      end,
    }
    use {
      "dense-analysis/ale"
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
      -- cmd = { "EasyAlign" },
    }
    use {
      "rhysd/accelerated-jk"
    }
    use {
      "RRethy/vim-illuminate",
      config = function()
        vim.g.Illuminate_delay = 100,
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
      -- cmd = "StartupTime",
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
    }
    use {
      "nanotee/luv-vimdocs",
    }
    use {
      "milisims/nvim-luaref",
    }
    use {
      "vim-jp/vim-cpp",
    }
    use {
      "keith/swift.vim",
    }
    use {
      "pboettch/vim-cmake-syntax",
    }
    use {
      "neui/cmakecache-syntax.vim",
    }
    use {
      "lambdalisue/vim-cython-syntax",
    }
    use {
      "rust-lang/rust.vim",
    }
    use {
      "uarun/vim-protobuf",
    }
    use {
      "cappyzawa/starlark.vim",
    }
    use {
      "HerringtonDarkholme/yats.vim",
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
          call timer_start(500, {-> system('kitty @ focus-window')}, {'repeat': 1})
        endfunction
        command! -nargs=* MarkdownPreviews call s:markdown_preview_kitty()
        ]])
      end
    }
    use {
      "moorereason/vim-markdownfmt",
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
    }
    use {
      "cespare/vim-toml",
    }
    use {
      "elzr/vim-json",
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
    }
    use {
      "vim-scripts/vim-niji",
    }
    -- modulemap
    use {
      "compnerd/modulemap-vim",
    }
    -- sql
    use {
      "tpope/vim-dadbod",
    }
    use {
      "kristijanhusak/vim-dadbod-completion",
    }
    use {
      "kristijanhusak/vim-dadbod-ui",
    }
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

    if PackerBootstrap then
      require("packer").sync()
    end
  end
)
