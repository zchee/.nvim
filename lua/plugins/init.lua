local util = require("util")

---@type LazySpec
return {
	-- Local
	{
		dir = vim.fs.joinpath(util.go_path("src/github.com/zchee/trans.nvim")),
		cmd = { "TransNvim" },
	},
	{
		dir = vim.fs.joinpath(util.src_path("github.com/zchee/hl-goimport.nvim")),
		lazy = false,
	},
	{
		dir = vim.fs.joinpath(util.src_path("github.com/zchee/vim-flatbuffers")),
		lazy = false,
	},
	{
		dir = vim.fs.joinpath(util.src_path("github.com/zchee/vim-gn")),
		lazy = false,
	},
	{
		dir = vim.fs.joinpath(util.src_path("github.com/zchee/vim-go-testscript")),
		lazy = false,
	},
	-- {
	--   dir = vim.fs.joinpath(util.src_path("github.com/zchee/tree-sitter-goasm")),
	--   lazy = false,
	--   opts = function()
	--     return {}
	--   end,
	-- },

	-- LSP
	{
		{
			"nvim-lua/plenary.nvim",
			lazy = false,
			config = function()
				require("plugins.plenary")
			end,
		},
		{
			"williamboman/mason.nvim",
			lazy = false,
			config = function()
				require("plugins.mason")
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				"neovim/nvim-lspconfig",
				"williamboman/mason.nvim",
				"zchee/lsp-setup.nvim",
				"nvimdev/lspsaga.nvim",
				"lukas-reineke/lsp-format.nvim",
				"hrsh7th/nvim-gtd",
			},
			lazy = false,
			config = function()
				require("plugins.lsp")
			end,
		},
		{
			"nvimdev/lspsaga.nvim",
			lazy = false,
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("plugins.lspsaga")
			end,
		},
		{
			"aznhe21/actions-preview.nvim",
			lazy = false,
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
			-- event = { "BufReadPre", "BufNewFile" },
			lazy = true,
			dependencies = {
				"jay-babu/mason-null-ls.nvim",
				"williamboman/mason.nvim",
			},
			config = function()
				require("plugins.null-ls")
			end,
		}
	},

	-- Editor
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"petertriho/cmp-git",
			-- "MysticalDevil/inlay-hints.nvim",
			{
				"chrisgrieser/nvim-lsp-endhints",
				event = "LspAttach",
				opts = {
					icons = {
						type = "󰜁 ",
						parameter = "󰏪 ",
						offspec = " ",
						unknown = " ",
					},
					label = {
						padding = 1,
						marginLeft = 0,
						bracketedParameters = true,
					},
					autoEnableHints = true,
				},
			},
			"onsails/lspkind-nvim",
			"SmiteshP/nvim-navic",
			"rafamadriz/friendly-snippets",
			"ray-x/cmp-treesitter",
			"windwp/nvim-autopairs",
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
				"b0o/schemastore.nvim",
				ft = {
					"json",
					"yaml",
				},
			},
			{
				"ray-x/lsp_signature.nvim",
				event = "InsertEnter",
			},
			{
				"numToStr/Comment.nvim",
				dependencies = {
					{
						"JoosepAlviste/nvim-ts-context-commentstring",
						config = function()
							require("plugins.ts_context_commentstring")
						end,
					},
				},
				config = function()
					require("plugins.comment")
				end,
				lazy = false,
			},
		},
		config = function()
			require("plugins.cmp")
		end,
	},

	-- DAP
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"LiadOz/nvim-dap-repl-highlights",
			"leoluz/nvim-dap-go",
			"jay-babu/mason-nvim-dap.nvim",
			"jbyuki/one-small-step-for-vimkind",
			"nvim-neotest/nvim-nio",
		},
		event = "VeryLazy",
		config = function()
			require("plugins.dap")
		end,
	},

	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = function()
			require("plugins.dressing")
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					require("plugins.ts_context_commentstring")
				end,
			},
			"rush-rs/tree-sitter-asm",
			"yamatsum/nvim-nonicons",
		},
		event = { "VeryLazy" },
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		build = ":TSUpdate",
		config = function()
			require("plugins.treesitter")
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"matheusfillipe/grep_app.nvim",
			-- "tamago324/telescope-openbrowser.nvim",
			"nvim-telescope/telescope-ghq.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build =
				"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build && cmake --install build --prefix build",
			},
		},
		cmd = "Telescope",
		config = function()
			require("plugins.telescope")
		end,
	},

	{
		"rainbowhxch/accelerated-jk.nvim",
		config = function()
			vim.keymap.set({ "n" }, "j", "<Plug>(accelerated_jk_gj)", { nowait = true, silent = true })
			vim.keymap.set({ "n" }, "k", "<Plug>(accelerated_jk_gk)", { nowait = true, silent = true })

			require('accelerated-jk').setup({
				mode = "time_driven",
				enable_deceleration = true,
				acceleration_motions = {},
				acceleration_limit = 500,
				acceleration_table = { 1, 2, 7, 12, 17, 21, 24, 26, 28, 30 },
				deceleration_table = { { 200, 3 }, { 300, 7 }, { 450, 11 }, { 600, 15 }, { 750, 21 }, { 900, 9999 } },
			})
		end,
		lazy = false,
	},
	{
		"haya14busa/vim-asterisk",
		---@type LazyKeysSpec
		keys = {
			--- @diagnostic disable-next-line
			{ "*", "<Plug>(asterisk-gz*)", desc = "Run 'asterisk-gz*'", { "n", "v", "x", "s", "o", "i", "t" } }, -- "c"
		},
	},

	{
		"akinsho/toggleterm.nvim",
		cmd = {
			"ToggleTerm",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualLines",
			"ToggleTermSendVisualSelection",
			"ToggleTermSetName",
			"ToggleTermToggleAll",
			"TermExec",
		},
		keys = {
			--- @diagnostic disable-next-line
			{ "<BS>t", "<Cmd>exe v:count1 . 'ToggleTerm'<CR>", desc = "exe v:count1 . 'ToggleTerm'", { "n" } },
		},
		config = function()
			require("plugins.toggleterm")
		end,
		---@type LazyKeysSpec
	},

	-- UI
	{
		{
			"nvim-tree/nvim-tree.lua",
			cmd = {
				"NvimTreeToggle",
				"NvimTreeOpen",
				"NvimTreeFindFile",
				"NvimTreeFindFileToggle",
			},
			dependencies = {
				"nvim-tree/nvim-web-devicons",
				"antosha417/nvim-lsp-file-operations",
			},
			init = function()
				local autocmd = vim.api.nvim_create_autocmd

				autocmd("BufEnter", {
					group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
					pattern = "NvimTree_*",
					callback = function()
						local layout = vim.api.nvim_call_function("winlayout", {})
						if
						    layout[1] == "leaf"
						    and vim.api.nvim_get_option_value(
							    "filetype",
							    { buf = vim.api.nvim_win_get_buf(layout[2]) }
						    ) == "NvimTree"
						    and layout[3] == nil
						then
							vim.cmd("confirm quit")
						end

						local api = require("nvim-tree.api")
						local global_cwd = vim.fn.getcwd(-1, -1)
						api.tree.change_root(global_cwd)
					end,
				})

				-- when no file/directory is opened at startup
				-- skip nvim-tree so that dashboard can load
				local cmdline_args = -1
				if vim.fn.argc(cmdline_args) == 0 then
					return
				else
					autocmd({ "VimEnter" }, {
						-- open nvim-tree for noname buffers and directory
						callback = function(args)
							-- buffer is a [No Name]
							local no_name = args.file == ""
							    and vim.bo[args.buf].buftype == ""
							-- buffer is a directory
							local directory = vim.fn.isdirectory(args.file) == 1

							if not directory and not no_name then
								return
							end

							local api = require("nvim-tree.api")

							if directory then
								-- change to the directory
								vim.cmd.cd(args.file)
								-- open the tree
								api.tree.open()
							else
								-- open the tree, find the file but don't focus it
								api.tree.toggle({ focus = false, find_file = true })
							end
						end,
					})
				end
			end,
			config = function()
				require("plugins.tree")
				require("lsp-file-operations").setup {
					debug = false,
					operations = {
						willRenameFiles = true,
						didRenameFiles = true,
						willCreateFiles = true,
						didCreateFiles = true,
						willDeleteFiles = true,
						didDeleteFiles = true,
					},
					timeout_ms = 1000,
				}
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
				{
					"nvim-tree/nvim-web-devicons",
				},
			},
			config = function()
				require("plugins.bufferline")
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			event = "VeryLazy",
			config = function()
				require("plugins.gitsigns")
			end,
		},
		{
			-- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
			"RRethy/vim-illuminate",
			config = function()
				require("plugins.illuminate")
			end,
			event = "VeryLazy",
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
			"rcarriga/nvim-notify",
			event = "VeryLazy",
		},

		{
			"folke/todo-comments.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
			},
			event = "VeryLazy",
			opts = require("plugins.todo-comment")
		},

		{
			"liuchengxu/vista.vim",
			cmd = { "Vista" },
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
			"tkmpypy/chowcho.nvim",
			event = "VeryLazy",
			config = function()
				require("plugins.chowcho")
			end,
		},
		{
			"AndrewRadev/switch.vim",
			event = "VeryLazy",
		},
		{
			"junegunn/vim-easy-align",
			cmd = { "EasyAlign" },
		},
		{
			"tyru/open-browser.vim",
			event = "VeryLazy",
		},
	},

	-- Language
	{
		-- {
		--   "ray-x/go.nvim",
		--   dependencies = { -- optional packages
		--     "ray-x/guihua.lua",
		--     "neovim/nvim-lspconfig",
		--     "nvim-treesitter/nvim-treesitter",
		--   },
		--   config = function()
		--     require("go").setup({
		--       disable_defaults = true,
		--     })
		--   end,
		--   lazy = true,
		--   -- event = "VeryLazy", -- event = { "CmdlineEnter" }
		--   -- ft = { "go", "gomod" },
		--   -- build = ':lua require("go.install").update_all_sync()'
		-- },
		{
			"jparise/vim-graphql",
			ft = "graphql",
		},
		{
			"folke/lazydev.nvim",
			ft = "lua",
			config = function()
				require("plugins.lazydev")
			end,
			dependencies = {
				{
					"Bilal2453/luvit-meta",
					lazy = true
				},
			},
		},
		{
			"nvim-java/nvim-java",
			dependencies = {
				"nvim-java/lua-async-await",
				"nvim-java/nvim-java-core",
				"nvim-java/nvim-java-test",
				"nvim-java/nvim-java-dap",
				"MunifTanjim/nui.nvim",
				"neovim/nvim-lspconfig",
				"mfussenegger/nvim-dap",
				{
					"williamboman/mason.nvim",
					opts = {
						registries = {
							"github:nvim-java/mason-registry",
							"github:mason-org/mason-registry",
						},
					},
				}
			},
			ft = "java",
		},
		{
			"towolf/vim-helm",
			ft = "helm",
		},
		{
			"rhysd/vim-syntax-codeowners",
			ft = "codeowners",
		},
		{
			"wallpants/github-preview.nvim",
			build = "bun i && git reset --hard",
			cmd = { "GithubPreviewToggle", "GithubPreviewStart", "GithubPreviewStop" },
			config = function()
				require("plugins.github-preview")
			end,
		},
	},

	-- Utilities
	{
		{
			"nvimdev/hlsearch.nvim",
			event = "BufReadPost",
			config = function()
				require("hlsearch").setup()
			end
		},
		{
			"monkoose/matchparen.nvim",
			event = "VeryLazy",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			config = function()
				require('matchparen').setup({
					on_startup = true,
					hl_group = 'MatchParen',
					augroup_name = 'matchparen',
					debounce_time = 10,
				})
			end,
		},
		{
			"nvchad/minty",
			cmd = { "Shades", "Huefy" },
		},
		-- {
		--   "folke/which-key.nvim",
		--   event = "VeryLazy",
		--   init = function()
		--     vim.o.timeout = true
		--     vim.o.timeoutlen = 300
		--   end,
		--   opts = {
		--     -- your configuration comes here
		--     -- or leave it empty to use the default settings
		--     -- refer to the configuration section below
		--   }
		-- },
		-- {
		--   "lucidph3nx/nvim-sops",
		--   ---@type LazyKeysSpec
		--   keys = {
		--     --- @diagnostic disable
		--     { "<LocalLeader>se", vim.cmd.SopsEncrypt, desc = "Encrypt File with SOPS" },
		--     { "<LocalLeader>sd", vim.cmd.SopsDecrypt, desc = "Decrypt File with SOPS" },
		--     --- @diagnostic enable
		--   },
		-- },
		{
			"mrjones2014/op.nvim",
			event = "VeryLazy",
		},
		{
			"NvChad/nvim-colorizer.lua",
			cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers", "ColorizerToggle" },
			opts = {
				filetypes = { "*" },
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
			"jackMort/ChatGPT.nvim",
			cmd = {
				"ChatGPT",
				"ChatGPTActAs",
				"ChatGPTCompleteCode",
				"ChatGPTEditWithInstructions",
				"ChatGPTRun",
			},
			config = function()
				require("plugins.chatgpt")
			end,
			dependencies = {
				"MunifTanjim/nui.nvim",
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
		},
		{
			"voldikss/vim-translator",
			init = function()
				vim.g.translator_source_lang = "auto"
				vim.g.translator_target_lang = "ja"
				vim.g.translator_default_engines = { "google" }
				vim.g.translator_history_enable = true
				vim.g.translator_window_type = "popup"
				vim.g.translator_window_max_width = 0.6
				vim.g.translator_window_max_height = 0.6
				vim.g.translator_window_borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
			end,
			cmd = {
				"Translate",
				"TranslateW",
				"TranslateR",
				"TranslateX",
				"TranslateH",
				"TranslateL",
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
			"folke/neoconf.nvim",
			cmd = "Neoconf",
		},
		{
			"wakatime/vim-wakatime",
			lazy = false,
		},
	},
}

-- {
--   "romgrk/kirby.nvim",
--   dependencies = {
--     { "romgrk/kui.nvim",            build = "corepack enable pnpm && pnpm i" },
--     { "romgrk/fzy-lua-native",      build = "make all" },
--     { "nvim-tree/nvim-web-devicons" },
--     { "nvim-lua/plenary.nvim" },
--   },
--   cmd = "Kirby",
-- },
