--                                                                                                                 --
--                    __                                                                                           --
--                   /\ \                                                      __                                  --
--   ____      ___   \ \ \___       __      __                ___     __  __  /\_\     ___ ___     _ __    ___     --
--  /\_ ,`\   /'___\  \ \  _ `\   /'__`\  /'__`\            /' _ `\  /\ \/\ \ \/\ \  /' __` __`\  /\`'__\ /'___\   --
--  \/_/  /_ /\ \__/   \ \ \ \ \ /\  __/ /\  __/            /\ \/\ \ \ \ \_/ | \ \ \ /\ \/\ \/\ \ \ \ \/ /\ \__/   --
--    /\____\\ \____\   \ \_\ \_\\ \____\\ \____\           \ \_\ \_\ \ \___/   \ \_\\ \_\ \_\ \_\ \ \_\ \ \____\  --
--    \/____/ \/____/    \/_/\/_/ \/____/ \/____/            \/_/\/_/  \/__/     \/_/ \/_/\/_/\/_/  \/_/  \/____/  --
--                                                                                                                 --
--                                                                                                                 --
-- --------------------------------------------------------------------------------------------------------------- --

-- Environment Variables:

vim.env.MANWIDTH = 999

-- Remote Plugins: disable provider probing entirely (no rplugins in use).
-- Note: 0 disables a provider; any other value leaves the probe enabled.
vim.g.loaded_python3_provider = 0 -- $VIMRUNTIME/autoload/provider/python3.vim
vim.g.loaded_node_provider = 0 -- $VIMRUNTIME/autoload/provider/node.vim
vim.g.loaded_ruby_provider = 0 -- $VIMRUNTIME/autoload/provider/ruby.vim
vim.g.loaded_perl_provider = 0 -- $VIMRUNTIME/autoload/provider/perl.vim
vim.g.no_man_maps = 1
-- vim.g.ft_man_folding_enable     = 0
-- vim.g.man_hardwrap              = false
-- vim.g.vimsyn_embed              = 'lP'
--
-- -- disable built-in plugins
-- vim.g.loaded_gzip               = 1
-- vim.g.loaded_zip                = 1
-- vim.g.loaded_zipPlugin          = 1
-- vim.g.loaded_tar                = 1 -- $VIMRUNTIME/autoload/tar.vim
-- vim.g.loaded_tarPlugin          = 1 -- $VIMRUNTIME/plugin/tarPlugin.vim
-- vim.g.loaded_getscript          = 1
-- vim.g.loaded_getscriptPlugin    = 1
-- vim.g.loaded_vimball            = 1 -- $VIMRUNTIME/pack/dist/opt/vimball/autoload/vimball.vim
-- vim.g.loaded_vimballPlugin      = 1 -- $VIMRUNTIME/pack/dist/opt/vimball/plugin/vimballPlugin.vim
-- vim.g.loaded_2html_plugin       = 1
-- vim.g.loaded_matchit            = 1
-- vim.g.loaded_matchparen         = 1
-- vim.g.loaded_logiPat            = 1
-- vim.g.loaded_rrhelper           = 1
-- vim.g.did_install_default_menus = 1    -- $VIMRUNTIME/menu.vim
-- vim.g.skip_loading_mswin        = true -- $VIMRUNTIME/mswin.vim
-- vim.g.loaded_cfilter            = 1    -- $VIMRUNTIME/pack/dist/opt/cfilter/plugin/cfilter.vim
-- vim.g.loaded_netrw              = 1    -- $VIMRUNTIME/autoload/netrw.vim
-- vim.g.loaded_netrwFileHandlers  = 1    -- $VIMRUNTIME/autoload/netrwFileHandlers.vim
-- vim.g.loaded_netrwSettings      = 1    -- $VIMRUNTIME/autoload/netrwSettings.vim
-- vim.g.loaded_pythonx_provider   = 1    -- $VIMRUNTIME/autoload/provider/pythonx.vim
-- vim.g.loaded_syntax_completion  = 130  -- $VIMRUNTIME/autoload/syntaxcomplete.vim
-- vim.g.loaded_xmlformat          = 1    -- $VIMRUNTIME/autoload/xmlformat.vim
-- vim.g.loaded_less               = 1    -- $VIMRUNTIME/macros/less.vim
-- vim.g.loaded_netrwPlugin        = 1    -- $VIMRUNTIME/plugin/netrwPlugin.vim
-- vim.g.netrw_nogx                = true -- $VIMRUNTIME/plugin/netrwPlugin.vim
-- vim.g.loaded_spellfile_plugin   = 1    -- $VIMRUNTIME/plugin/spellfile.vim
-- vim.g.loaded_tutor_mode_plugin  = 1    -- $VIMRUNTIME/plugin/tutor.vim

-- Global Settings:

vim.o.autoindent = true
vim.o.autoread = true
vim.o.backup = true
vim.o.backupdir = vim.fn.stdpath("state") .. "/backup/" -- NOTE(zchee): can't use `vim.fs.joinpath`
vim.o.backupcopy = "yes"
vim.o.belloff = "all"
vim.o.cindent = true
vim.opt.cinkeys:remove("0#") -- comments don't fiddle with indenting
vim.o.cinoptions = "" -- See :h cinoptions-values
-- vim.opt.clipboard = "unnamedplus"
vim.o.cmdheight = 2
vim.o.cmdwinheight = 50
vim.o.complete = "." -- default: .,w,b,u,t, .
-- vim.opt.completeopt = { "noinsert", "noselect", "menuone" } -- noinsert,noselect,longest,menu,menuone,preview
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.o.concealcursor = "niv"
vim.o.conceallevel = 1
vim.o.copyindent = true
vim.opt.cpoptions:remove("_")
vim.opt.diffopt:append("hiddenoff")
vim.o.directory = vim.fn.stdpath("state") .. "/swap/" -- NOTE(zchee): can't use `vim.fs.joinpath`
vim.opt.display:remove("msgsep")
vim.o.emoji = true
vim.o.encoding = "utf-8"
vim.o.expandtab = true
vim.opt.fileformats = { "unix" }
vim.opt.fillchars:append("diff:/")
vim.o.foldcolumn = "0"
vim.o.foldlevel = 0
vim.o.foldlevelstart = 99 -- open all folds by default
vim.o.foldmethod = "expr"
vim.o.foldnestmax = 1 -- maximum fold depth
vim.opt.formatoptions:append("c") -- Autowrap comments using textwidth - :help fo-table
vim.opt.formatoptions:append("j") -- Delete comment character when joining commented lines
vim.opt.formatoptions:append("l") -- do not wrap lines that have been longer when starting insert mode already
vim.opt.formatoptions:append("n") -- Recognize numbered lists
vim.opt.formatoptions:append("q") -- Allow formatting of comments with "gq"
vim.opt.formatoptions:append("r") -- Insert comment leader after hitting <Enter>
vim.opt.formatoptions:append("t") -- Auto-wrap text using textwidth
vim.opt.formatoptions:remove("o") -- Automatically insert the current comment leader after hitting 'o' or'O' in Normal mode
vim.o.foldnestmax = 1 -- maximum fold depth
vim.o.grepformat = "%f:%l:%c:%m"
if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg --vimgrep --hidden --glob '!.git'"
end
vim.opt.helplang = { "en" }
vim.o.hidden = true
vim.o.history = 10000 -- default: 10000 (maximum)
vim.o.iminsert = 0
vim.o.imsearch = 0
vim.o.inccommand = "nosplit"
vim.opt.isfname:remove("=")
vim.o.jumpoptions = "view"
vim.o.keywordprg = ":Help"
vim.o.langmenu = "none"
vim.o.laststatus = 3
vim.o.lazyredraw = false
vim.o.linebreak = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  nbsp = "%",
  extends = "›",
  precedes = "‹",
}
vim.o.makeprg = "make"
vim.o.matchtime = 0 -- disable nvim matchparen
vim.o.maxmempattern = 1000 -- default: 1000, max: 2000000
vim.o.modelines = 1
vim.o.mouse = "a"
vim.o.number = true
vim.opt.path:append("$PWD/**")
vim.opt.path:append("**")
vim.o.previewheight = 5
vim.o.pumblend = 25
vim.o.pumheight = 30
vim.o.pyxversion = 3
vim.o.redrawtime = 20000
vim.o.regexpengine = 2
vim.o.ruler = true
vim.o.scrollback = 100000
vim.o.scrolljump = 6
vim.o.scrolloff = 8 -- default: 0
vim.o.secure = true
-- "h": don't re-apply hlsearch to the restored last-search pattern at
-- startup -- the auto-:nohlsearch on_key hook (autocmd.lua) only clears on
-- the first typed key, so without it every freshly opened file showed the
-- previous session's matches (e.g. one Search cell at each EOL for \s*$).
vim.opt.shada = { "'20", "<50", "s10", "h" }
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.opt.shortmess:append("c") -- atOIc " default: filnxtToOF
vim.opt.shortmess:append("I") -- atOIc " default: filnxtToOF
vim.o.showfulltag = true
vim.o.showtabline = 2
vim.o.sidescroll = 1 -- 0
vim.o.sidescrolloff = 15 -- 0
vim.o.signcolumn = "yes:5"
vim.opt.sessionoptions = {
  "blank",
  "buffers",
  "curdir",
  "folds",
  "globals",
  "help",
  "resize",
  "tabpages",
  "terminal",
  "winpos",
  "winsize",
}
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.suffixes:append(".pyc")
vim.o.switchbuf = "uselast" -- useopen
vim.o.synmaxcol = 0 -- default: 3000, 0: unlimited, 400, 1500, 5000
vim.o.tabstop = 2
vim.o.tagcase = "smart"
vim.o.tags = "./tags;" -- http://d.hatena.ne.jp/thinca/20090723/1248286959
vim.o.textwidth = 0
vim.o.timeout = true -- mappnig timeout
vim.o.timeoutlen = 230 -- default: 1000
vim.o.ttimeout = true -- keycode timeout
vim.o.ttimeoutlen = 30 -- default: 50
vim.o.undodir = vim.fn.stdpath("state") .. "/undo/" -- NOTE(zchee): can't use `vim.fs.joinpath`
vim.o.undofile = true
vim.o.undolevels = 10000 -- default: 1000
vim.o.updatetime = 100 -- default: 4000
vim.o.pumblend = 15
vim.o.pumheight = 30
vim.o.virtualedit = "block"
-- vim.opt.winbar = vim.fn.expand('%:~:.:h')..'/%t'
vim.opt.wildignore:append("*.jpg")
vim.opt.wildignore:append("*.jpeg")
vim.opt.wildignore:append("*.bmp")
vim.opt.wildignore:append("*.gif")
vim.opt.wildignore:append("*.png")
vim.opt.wildignore:append("*.o")
vim.opt.wildignore:append("*.obj")
vim.opt.wildignore:append("*.exe")
vim.opt.wildignore:append("*.dll")
vim.opt.wildignore:append("*.so")
vim.opt.wildignore:append("*.out")
vim.opt.wildignore:append("*.class")
vim.opt.wildignore:append("*.swp")
vim.opt.wildignore:append("*.swo")
vim.opt.wildignore:append("*.swn")
vim.opt.wildignore:append("*/.git")
vim.opt.wildignore:append("*/.hg")
vim.opt.wildignore:append("*/.svn")
vim.opt.wildignore:append("tags")
vim.opt.wildignore:append("*.tags")
vim.o.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.o.wildoptions = "pum"
vim.o.winblend = 0
-- default border for all floating windows opened without an explicit
-- border; plugins that set their own border (or a different style, e.g.
-- gitsigns/dap "single") still win
vim.o.winborder = "rounded"
vim.o.winminwidth = 5
vim.o.wrap = true
vim.o.writebackup = true

vim.o.autochdir = false
vim.o.cursorcolumn = false
vim.o.cursorline = false
vim.o.errorbells = false
vim.o.foldenable = false
vim.o.ignorecase = false
vim.o.joinspaces = false
vim.o.list = false
vim.o.shiftround = false
vim.o.showcmd = false
vim.o.showmatch = false
vim.o.showmode = false
vim.o.spell = false
vim.o.swapfile = false
vim.o.visualbell = false
vim.o.wrapscan = false

-- :help vim.highlight.priorities
vim.hl.priorities.syntax = 50
vim.hl.priorities.treesitter = 130
vim.hl.priorities.semantic_tokens = 125
vim.hl.priorities.diagnostics = 150
vim.hl.priorities.user = 200

vim.cmd.colorscheme("equinusocio_material")

-- Color:

-- Go:
vim.g["go#generate#test#template_dir"] = os.getenv("XDG_CONFIG_HOME") .. "/go/template/gotests"
vim.g.go_highlight_array_whitespace_error = 0 -- default : 1
vim.g.go_highlight_chan_whitespace_error = 0 -- default : 1
vim.g.go_highlight_extra_types = 1 -- default : 1
vim.g.go_highlight_space_tab_error = 0 -- default : 1
vim.g.go_highlight_trailing_whitespace_error = 0 -- default : 1
vim.g.go_highlight_operators = 1 -- default : 0
vim.g.go_highlight_functions = 1 -- default : 0
vim.g.go_highlight_function_parameters = 0 -- default : 0
vim.g.go_highlight_function_calls = 1 -- default : 0
vim.g.go_highlight_fields = 1 -- default : 0
vim.g.go_highlight_types = 0 -- default : 0
vim.g.go_highlight_build_constraints = 1 -- default : 0
vim.g.go_highlight_string_spellcheck = 0 -- default : 1
vim.g.go_highlight_format_strings = 1 -- default : 1
vim.g.go_highlight_generate_tags = 1 -- default : 0
vim.g.go_highlight_variable_assignments = 0 -- default : 0
vim.g.go_highlight_variable_declarations = 0 -- default : 0
vim.g.go_highlight_diagnostic_errors = 1 -- default : 0
vim.g.go_highlight_diagnostic_warnings = 1 -- default : 1
vim.g.go_highlight_debug = 1 -- default : 1
vim.g.go_fold_enable = { "block", "import", "varconst", "comment", "package_comment" }
vim.g.go_highlight_error = 1
vim.g.go_highlight_return = 1
vim.api.nvim_set_hl(0, "goImportString", { link = "Comment", force = true })
vim.api.nvim_set_hl(0, "goPredefinedIdentifiers", { link = "Keyword", force = true })
vim.api.nvim_set_hl(0, "goReceiverType", { link = "Keyword", force = true })

-- C:
vim.g.c_ansi_constants = 1
vim.g.c_ansi_typedefs = 1
vim.g.c_comment_strings = 1
vim.g.c_gnu = 0
vim.g.c_no_curly_error = 1
vim.g.c_no_tab_space_error = 1
vim.g.c_no_trail_space_error = 1
vim.g.c_syntax_for_h = 0
vim.g.c_no_curly_error = 1

-- CPP:
vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_experimental_template_highlight = 1
vim.g.cpp_concepts_highlight = 1

-- Json:
vim.g.vim_json_syntax_conceal = 0

-- Asm:
vim.g.nasm_loose_syntax = 1
vim.g.nasm_ctx_outside_macro = 1

-- Perl:
vim.g.perl_include_pod = 1
vim.g.perl_no_scope_in_variables = 0
vim.g.perl_no_extended_vars = 0
vim.g.perl_string_as_statement = 1
vim.g.perl_no_sync_on_sub = 0
vim.g.perl_no_sync_on_global_var = 0
vim.g.perl_sync_dist = 100

-- Markdown:
-- $VIMRUNTIME/ftplugin/markdown.vim sets `expandtab tabstop=4 softtabstop=4
-- shiftwidth=4` buffer-locally, so the global shiftwidth=2 above is the one
-- setting that never reaches a markdown buffer. That 4 is the recommended
-- style inherited from Gruber's 2004 Markdown, not a CommonMark requirement:
-- CommonMark nests a list at the parent item's content offset (2 columns for
-- `- `), and 4 columns past it opens an indented code block instead.
vim.g.markdown_recommended_style = 0

vim.g.markdown_fenced_languages = {
  "c",
  "console=sh",
  "cpp",
  "dockerfile",
  "go",
  "graphql",
  "help",
  "mermaid",
  "mysql",
  "objective-c",
  "proto",
  "python",
  "sh",
  "sql",
  "typescript",
}

vim.g["vista#renderer#enable_icon"] = true
vim.g["vista#renderer#enable_kind"] = true
vim.g.vista_blink = { 0, 0 }
vim.g.vista_cursor_delay = 400 -- default
vim.g.vista_default_executive = "nvim_lsp"
vim.g.vista_disable_statusline = 0
vim.g.vista_echo_cursor_strategy = "floating_win" -- echo, scroll, floating_win, both
vim.g.vista_executive_for = {
  markdown = "toc",
}
vim.g.vista_sidebar_width = "150"
vim.g.vista_update_on_text_changed = true
vim.g.vista_executive_nvim_lsp_fetching = true
