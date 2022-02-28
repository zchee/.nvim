local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PackerBootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

local config_path = "$HOME/src/github.com/zchee/.nvim/"
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
local packer_util = require("packer.util")

packer.init {
  package_root = packer_util.join_paths(vim.fn.stdpath("data"), "site", "pack"),
  compile_path = packer_util.join_paths(vim.fn.stdpath("config"), "plugin", "packer_compiled.lua"),
}

return packer.startup(function(use)
  use {
    "wbthomason/packer.nvim",
  }

  use {
    "lewis6991/impatient.nvim",
  }

  -- needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  use {
    "antoinemadec/FixCursorHold.nvim",
  }

  -- local
  require('zchee.plugin-local')

  -- completion
  use {
    "ms-jpq/coq_nvim",
    -- src.."ms-jpq/coq_nvim",
    requires = {
      "ms-jpq/coq.artifacts",
      "folke/lua-dev.nvim",
    },
    config = function()
      require('zchee.plugins.coq')
    end,
  }
  use {
    "ms-jpq/coq.thirdparty",
    config = function()
      require "coq_3p" {
        {
          src = "nvimlua",
          short_name = "nlua",
          conf_only = false,
        },
        -- {
        --   src = "dap",
        -- },
        -- {
        --   src = "vim_dadbod_completion",
        --   short_name = "dadbod",
        -- },
      }
    end
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
  }

  use {
    "williamboman/nvim-lsp-installer",
    config = function() 
      require('zchee.plugins.nvim-lsp')
    end
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require('zchee.plugins.nvim-autopairs')
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
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  }

  -- tree-sitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "windwp/nvim-autopairs",
    },
    config = function()
      require("zchee.plugins.nvim-treesitter")
    end,
  }

  -- UI
  use {
    "andymass/vim-matchup",
    requires = {
      "nvmi-treesitter/nvim-treesitter",
    },
    config = function()
      vim.g.matchup_mappings_enabled = 0
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_singleton = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  }

  -- file tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    -- config = function() require'nvim-tree'.setup {} end
    config = function ()
      require("zchee.plugins.nvim-tree")
    end,
  }

  -- git
  use {
    "TimUntersberger/neogit",
    requires = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = "Neogit",
    config = function ()
      local neogit = require("neogit")
      neogit.setup {
        disable_commit_confirmation = true,
        disable_signs = false,
        signs = {
          section = { ">", "v" },
          item = { ">", "v" },
          hunk = { "", "" },
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
    "kevinhwang91/nvim-bqf",
    requires = {
      "junegunn/fzf",
    },
    ft = "qf",
    config = function ()
      require("zchee.plugins.nvim-bqf")
    end,
  }

  use {
    "junegunn/fzf",
    run = function()
      vim.fn['fzf#install']()
    end,
  }

  -- Debug
  use {
    "bfredl/nvim-luadev",
    ft = { "lua" },
  }

  -- Dap
  use {
    "mfussenegger/nvim-dap",
    requires = {
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      require("zchee.plugins.nvim-dap")
      require("dapui").setup()
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
    cmd = { "FloatermNew", "FloatermToggle", "FloatermPrev", "FloatermNext", "FloatermHide" },
  }
  use {
    "airblade/vim-gitgutter"
  }
  use {
    "liuchengxu/vista.vim",
    cmd = { "Vista" },
  }
  
  -- linters
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

  -- Utilities
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
    "RRethy/vim-illuminate"
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

  -- unsed
  -- use {
  --   "nathom/filetype.nvim",
  --   config = function() 
  --     require('zchee.plugins.filetype')
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
  --   },
  --   config = function() 
  --     require('zchee.plugins.nvim-lsp')
  --     require('zchee.plugins.ddc')
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
    "tweekmonster/hl-goimport.vim",
    ft = { "go" },
  }
  use {
    -- "hofstadter-io/cue.vim",
    "jjo/vim-cue",
    ft = { "cue" },
  }
  use {
    "vim-jp/vim-cpp",
    ft = { "cpp" },
  }
  use {
    "keith/swift.vim",
    ft = { "swift" },
  }
  use {
    "pboettch/vim-cmake-syntax",
    ft = { "cmake" },
  }
  use {
    "neui/cmakecache-syntax.vim",
    ft = { "cmakec" },
  }
  use {
    "lambdalisue/vim-cython-syntax",
    ft = { "python" },
  }
  use {
    "rust-lang/rust.vim",
    ft = { "rust" },
  }
  use {
    "uarun/vim-protobuf",
    ft = { "protobuf" },
  }
  use {
    "cappyzawa/starlark.vim",
    ft = { "starlark" },
  }
  use {
    "HerringtonDarkholme/yats.vim",
    ft = { "typescript" },
  }
  use {
    "moorereason/vim-markdownfmt",
    ft = { "markdown" },
  }
  use {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    run = { "cd app & yarn install" },
  }
  use {
    "gisphm/vim-gitignore",
    ft = { "gitignore" },
  }
  use {
    "vim-jp/vimdoc-ja",
  }
  use {
    "vim-jp/syntax-vim-ex",
    ft = { "vim" },
  }
  use {
    "cespare/vim-toml",
    Ft = { "toml" },
  }
  use {
    "elzr/vim-json",
    ft = { "json" },
  }
  use {
    "gutenye/json5.vim",
    ft = { "json5" },
  }
  use {
    "jparise/vim-graphql",
    ft = { "graphql" },
  }
  use {
    "ericpruitt/tmux.vim",
    ft = { "tmux" },
  }
  use {
    "hashivim/vim-terraform",
    ft = { "terraform" },
  }
  use {
    "vim-scripts/vim-niji",
    ft = { "scheme" },
  }
  use {
    "compnerd/modulemap-vim",
    ft = { "modulemap" },
  }
  use {
    "aklt/plantuml-syntax",
    ft = { "plantuml" },
  }
  use {
    "weirongxu/plantuml-previewer.vim",
    ft = { "plantuml" },
  }
  use {
    "fladson/vim-kitty",
    ft = { "kitty" },
  }
  use {
    "chrisbra/vim-zsh",
    ft = { "zsh" },
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
end)
