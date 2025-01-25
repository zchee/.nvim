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

local util                      = require("util")

-- Environment Variables:

vim.env.MANWIDTH                = 999

-- Remote Plugins:
vim.g.loaded_python_provider    = 1 -- $VIMRUNTIME/autoload/provider/python.vim
vim.g.loaded_node_provider      = 1 -- $VIMRUNTIME/autoload/provider/node.vim
vim.g.loaded_ruby_provider      = 1 -- $VIMRUNTIME/autoload/provider/ruby.vim
vim.g.loaded_perl_provider      = 1 -- $VIMRUNTIME/autoload/provider/perl.vim
vim.g.no_man_maps               = 1
vim.g.ft_man_folding_enable     = 0
vim.g.man_hardwrap              = false
vim.g.vimsyn_embed              = 'lP'

-- disable built-in plugins
vim.g.loaded_gzip               = 1
vim.g.loaded_zip                = 1
vim.g.loaded_zipPlugin          = 1
vim.g.loaded_tar                = 1 -- $VIMRUNTIME/autoload/tar.vim
vim.g.loaded_tarPlugin          = 1 -- $VIMRUNTIME/plugin/tarPlugin.vim
vim.g.loaded_getscript          = 1
vim.g.loaded_getscriptPlugin    = 1
vim.g.loaded_vimball            = 1 -- $VIMRUNTIME/pack/dist/opt/vimball/autoload/vimball.vim
vim.g.loaded_vimballPlugin      = 1 -- $VIMRUNTIME/pack/dist/opt/vimball/plugin/vimballPlugin.vim
vim.g.loaded_2html_plugin       = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_logiPat            = 1
vim.g.loaded_rrhelper           = 1
vim.g.did_install_default_menus = 1    -- $VIMRUNTIME/menu.vim
vim.g.skip_loading_mswin        = true -- $VIMRUNTIME/mswin.vim
vim.g.loaded_cfilter            = 1    -- $VIMRUNTIME/pack/dist/opt/cfilter/plugin/cfilter.vim
vim.g.loaded_netrw              = 1    -- $VIMRUNTIME/autoload/netrw.vim
vim.g.loaded_netrwFileHandlers  = 1    -- $VIMRUNTIME/autoload/netrwFileHandlers.vim
vim.g.loaded_netrwSettings      = 1    -- $VIMRUNTIME/autoload/netrwSettings.vim
vim.g.loaded_pythonx_provider   = 1    -- $VIMRUNTIME/autoload/provider/pythonx.vim
vim.g.loaded_syntax_completion  = 130  -- $VIMRUNTIME/autoload/syntaxcomplete.vim
vim.g.loaded_xmlformat          = 1    -- $VIMRUNTIME/autoload/xmlformat.vim
vim.g.loaded_less               = 1    -- $VIMRUNTIME/macros/less.vim
vim.g.loaded_netrwPlugin        = 1    -- $VIMRUNTIME/plugin/netrwPlugin.vim
vim.g.netrw_nogx                = true -- $VIMRUNTIME/plugin/netrwPlugin.vim
vim.g.loaded_spellfile_plugin   = 1    -- $VIMRUNTIME/plugin/spellfile.vim
vim.g.loaded_tutor_mode_plugin  = 1    -- $VIMRUNTIME/plugin/tutor.vim

-- Global Settings:

vim.opt.autoindent              = true
vim.opt.autoread                = true
vim.opt.backup                  = true
vim.opt.backupdir               = vim.fn.stdpath("state") .. "/backup/" -- NOTE(zchee): can't use `vim.fs.joinpath`
vim.opt.backupcopy              = "yes"
vim.opt.belloff                 = "all"
vim.opt.cindent                 = true
vim.opt.cinkeys:remove("0#") -- comments don't fiddle with indenting
vim.opt.cinoptions = ""      -- See :h cinoptions-values
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2
vim.opt.cmdwinheight = 50
vim.opt.complete = "." -- default: .,w,b,u,t, .
-- vim.opt.completeopt = { "noinsert", "noselect", "menuone" } -- noinsert,noselect,longest,menu,menuone,preview
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.concealcursor = "niv"
vim.opt.conceallevel = 0
vim.opt.copyindent = true
vim.opt.cpoptions:remove("_")
vim.opt.diffopt:append("hiddenoff")
vim.opt.directory = vim.fn.stdpath("state") .. "/swap/" -- NOTE(zchee): can't use `vim.fs.joinpath`
vim.opt.display:remove("msgsep")
vim.opt.emoji = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.fillchars:append("diff:/")
vim.opt.fileformats = { "unix", "mac", "dos" }
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 99       -- open all folds by default
vim.opt.foldmethod = "expr"
vim.opt.foldnestmax = 1           -- maximum fold depth
vim.opt.formatoptions:append("c") -- Autowrap comments using textwidth - :help fo-table
vim.opt.formatoptions:append("j") -- Delete comment character when joining commented lines
vim.opt.formatoptions:append("l") -- do not wrap lines that have been longer when starting insert mode already
vim.opt.formatoptions:append("n") -- Recognize numbered lists
vim.opt.formatoptions:append("q") -- Allow formatting of comments with "gq"
vim.opt.formatoptions:append("r") -- Insert comment leader after hitting <Enter>
vim.opt.formatoptions:append("t") -- Auto-wrap text using textwidth
vim.opt.formatoptions:remove("o") -- Automatically insert the current comment leader after hitting 'o' or'O' in Normal mode
vim.opt.foldnestmax = 1           -- maximum fold depth
vim.opt.grepformat = "%f:%l:%c:%m"
if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = "rg --vimgrep --hidden --glob ‘!.git’"
end
vim.opt.helplang = { "en" }
vim.opt.hidden = true
vim.opt.history = 10000 -- default: 10000 (maximum)
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.inccommand = "nosplit"
vim.opt.isfname:remove("=")
vim.opt.jumpoptions = "view"
vim.opt.keywordprg = ":Help"
vim.opt.langmenu = "none"
vim.opt.laststatus = 3
vim.opt.lazyredraw = false
vim.opt.linebreak = true
vim.opt.listchars = {
  tab = "»-",
  trail = "-",
  nbsp = "%",
  extends = "›",
  precedes = "‹",
}
vim.opt.makeprg = "make"
vim.opt.matchtime = 0           -- disable nvim matchparen
vim.opt.maxmempattern = 2000000 -- default: 1000, max: 2000000
vim.opt.modelines = 1
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.path:append("$PWD/**")
vim.opt.path:append("**")
vim.opt.previewheight = 5
vim.opt.pumblend = 25
vim.opt.pumheight = 30
vim.opt.pyxversion = 3
vim.opt.redrawtime = 20000
vim.opt.regexpengine = 2
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.scrolljump = 5
vim.opt.scrolloff = 8 -- default: 0
vim.opt.secure = true
vim.opt.shada = { "'20", "<50", "s10" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("c") -- atOIc " default: filnxtToOF
vim.opt.shortmess:append("I") -- atOIc " default: filnxtToOF
vim.opt.showfulltag = true
vim.opt.showtabline = 2
vim.opt.sidescroll = 1     -- 0
vim.opt.sidescrolloff = 15 -- 0
vim.opt.signcolumn = "yes:4"
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
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.suffixes:append(".pyc")
vim.opt.switchbuf = "uselast" -- useopen
vim.opt.synmaxcol = 0         -- default: 3000, 0: unlimited, 400, 1500, 5000
vim.opt.tabstop = 2
vim.opt.tagcase = "smart"
vim.opt.tags = "./tags;"                              -- http://d.hatena.ne.jp/thinca/20090723/1248286959
vim.opt.textwidth = 0
vim.opt.timeout = true                                -- mappnig timeout
vim.opt.timeoutlen = 250                              -- default: 1000
vim.opt.ttimeout = true                               -- keycode timeout
vim.opt.ttimeoutlen = 30                              -- default: 50
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo/" -- NOTE(zchee): can't use `vim.fs.joinpath`
vim.opt.undofile = true
vim.opt.undolevels = 10000                            -- default: 1000
vim.opt.updatetime = 100                              -- default: 4000
vim.opt.pumblend = 15
vim.opt.pumheight = 30
vim.opt.virtualedit = "block"
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
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.wildoptions = "pum"
vim.opt.winblend = 0
vim.opt.wrap = true
vim.opt.writebackup = true

vim.opt.autochdir = false
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.errorbells = false
vim.opt.foldenable = false
vim.opt.ignorecase = false
vim.opt.joinspaces = false
vim.opt.list = false
vim.opt.shiftround = false
vim.opt.showcmd = false
vim.opt.showmatch = false
vim.opt.showmode = false
vim.opt.spell = false
vim.opt.swapfile = false
vim.opt.visualbell = false
vim.opt.wrapscan = false

vim.cmd.colorscheme("equinusocio_material")

local go_include = function()
  vim.opt.path:append("/usr/local/go/pkg/include")
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "go", callback = go_include })

local path_add_python_headers = function()
  if vim.fn.isdirectory("/usr/local/Frameworks/Python.framework/Headers") then
    vim.opt.path:append("/usr/local/Frameworks/Python.framework/Headers")
  end
end
vim.api.nvim_create_autocmd("Filetype", { pattern = "c, cpp, objc, objcpp", callback = path_add_python_headers })

-- Color:

-- Go:
vim.g["go#generate#test#template_dir"] = os.getenv("XDG_CONFIG_HOME") .. "/go/template/gotests"
vim.g.go_highlight_array_whitespace_error = 0    -- default : 1
vim.g.go_highlight_chan_whitespace_error = 0     -- default : 1
vim.g.go_highlight_extra_types = 1               -- default : 1
vim.g.go_highlight_space_tab_error = 0           -- default : 1
vim.g.go_highlight_trailing_whitespace_error = 0 -- default : 1
vim.g.go_highlight_operators = 1                 -- default : 0
vim.g.go_highlight_functions = 1                 -- default : 0
vim.g.go_highlight_function_parameters = 0       -- default : 0
vim.g.go_highlight_function_calls = 1            -- default : 0
vim.g.go_highlight_fields = 1                    -- default : 0
vim.g.go_highlight_types = 0                     -- default : 0
vim.g.go_highlight_build_constraints = 1         -- default : 0
vim.g.go_highlight_string_spellcheck = 0         -- default : 1
vim.g.go_highlight_format_strings = 1            -- default : 1
vim.g.go_highlight_generate_tags = 1             -- default : 0
vim.g.go_highlight_variable_assignments = 0      -- default : 0
vim.g.go_highlight_variable_declarations = 0     -- default : 0
vim.g.go_highlight_diagnostic_errors = 1         -- default : 0
vim.g.go_highlight_diagnostic_warnings = 1       -- default : 1
vim.g.go_highlight_debug = 1                     -- default : 1
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

-- vim-wakatime
vim.g.wakatime_CLIPath = util.homebrew_binary("wakatime-cli-head", "wakatime-cli")
vim.g.wakatime_PythonBinary = util.homebrew_binary("python3.13", "python3")
