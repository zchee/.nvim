--                                                                                                 --
--                 __                                                                              --
--  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    --
-- /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  --
-- \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  --
--   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ --
--                                                                                                 --
--                                                                                                 --
-- =============================================================================================== --

-- Environment Variables:

local gopath         = vim.fn.expand('$HOME/go')
local gopath_src     = gopath..'/src/'
local srcpath        = vim.fn.expand('$HOME/src')
local srcpath_github = srcpath..'/github.com/'

-- :help lua-filetype
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.cmd([[
if !exists("syntax_on")
  filetype plugin indent on
  syntax enable
  colorscheme equinusocio_material
endif
]])

-- disable built-in plugins
vim.g.loaded_gzip               = 1
vim.g.loaded_zip                = 1
vim.g.loaded_zipPlugin          = 1
vim.g.loaded_tar                = 1       -- $VIMRUNTIME/autoload/tar.vim
vim.g.loaded_tarPlugin          = 1       -- $VIMRUNTIME/plugin/tarPlugin.vim
vim.g.loaded_getscript          = 1
vim.g.loaded_getscriptPlugin    = 1
vim.g.loaded_vimball            = 1       -- $VIMRUNTIME/pack/dist/opt/vimball/autoload/vimball.vim
vim.g.loaded_vimballPlugin      = 1       -- $VIMRUNTIME/pack/dist/opt/vimball/plugin/vimballPlugin.vim
vim.g.loaded_2html_plugin       = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_logiPat            = 1
vim.g.loaded_rrhelper           = 1
-- $VIMRUNTIME
vim.g.did_install_default_menus = 1       -- $VIMRUNTIME/menu.vim
vim.g.skip_loading_mswin        = true    -- $VIMRUNTIME/mswin.vim
-- $VIMRUNTIME/pack/dist/opt
vim.g.loaded_cfilter            = 1       -- $VIMRUNTIME/pack/dist/opt/cfilter/plugin/cfilter.vim
-- $VIMRUNTIME/autoload
vim.g.loaded_netrw              = 1       -- $VIMRUNTIME/autoload/netrw.vim
vim.g.loaded_netrwFileHandlers  = 1       -- $VIMRUNTIME/autoload/netrwFileHandlers.vim
vim.g.loaded_netrwSettings      = 1       -- $VIMRUNTIME/autoload/netrwSettings.vim
vim.g.loaded_pythonx_provider   = 1       -- $VIMRUNTIME/autoload/provider/pythonx.vim
vim.g.loaded_syntax_completion  = 130     -- $VIMRUNTIME/autoload/syntaxcomplete.vim
vim.g.loaded_xmlformat          = 1       -- $VIMRUNTIME/autoload/xmlformat.vim
vim.g.loaded_less               = 1       -- $VIMRUNTIME/macros/less.vim
vim.g.loaded_netrwPlugin        = 1       -- $VIMRUNTIME/plugin/netrwPlugin.vim
vim.g.netrw_nogx                = true    -- $VIMRUNTIME/plugin/netrwPlugin.vim
vim.g.loaded_spellfile_plugin   = 1       -- $VIMRUNTIME/plugin/spellfile.vim
vim.g.loaded_tutor_mode_plugin  = 1       -- $VIMRUNTIME/plugin/tutor.vim

-- Global Settings:

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("data").."/backup"
vim.opt.belloff = "all"
vim.opt.cindent = true
vim.opt.cinkeys:remove("0#")                -- comments don't fiddle with indenting
vim.opt.cinoptions=''                -- See :h cinoptions-values
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2
vim.opt.cmdwinheight = 50
vim.opt.complete = "." -- .,w,b,u,t  -- default: .,w,b,u,t, .
-- vim.opt.completeopt = { "noinsert", "noselect", "menuone" } -- noinsert,noselect,longest,menu,menuone,preview
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.concealcursor = "niv"
vim.opt.conceallevel = 0
vim.opt.copyindent = true
vim.opt.cpoptions:remove("_")
vim.opt.cscopetag = true
vim.opt.diffopt:append("hiddenoff")
vim.opt.directory = vim.fn.stdpath("data").."/swap"
vim.opt.display:remove("msgsep")
vim.opt.emoji = true
vim.opt.encoding = "utf-8"
vim.opt.expandtab = true
vim.opt.fileformats = { "unix", "mac", "dos" }
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 99  --open all folds by default
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = vim.treesitter.foldexpr
vim.opt.foldnestmax=1     -- maximum fold depth
vim.opt.formatoptions:append("c")  -- Autowrap comments using textwidth - :help fo-table
vim.opt.formatoptions:append("j")  -- Delete comment character when joining commented lines
vim.opt.formatoptions:append("l")  -- do not wrap lines that have been longer when starting insert mode already
vim.opt.formatoptions:append("n")  -- Recognize numbered lists
vim.opt.formatoptions:append("q")  -- Allow formatting of comments with "gq"
vim.opt.formatoptions:append("r")  -- Insert comment leader after hitting <Enter>
vim.opt.formatoptions:append("t")  -- Auto-wrap text using textwidth
vim.opt.formatoptions:remove("o")  -- Automatically insert the current comment leader after hitting 'o' or'O' in Normal mode
vim.opt.foldnestmax = 1     -- maximum fold depth
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.helplang = { "en", "ja" }
vim.opt.hidden = true
vim.opt.history = 10000
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.inccommand = "nosplit"
vim.opt.isfname:remove("=")
vim.opt.keywordprg = ":Help"
vim.opt.langmenu = "none"
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.lazyredraw = true
vim.opt.listchars = { tab = "»-", trail = "-", nbsp = "%", extends = "›", precedes = "‹" }
vim.opt.makeprg = "make"
vim.opt.matchtime = 0  -- disable nvim matchparen
vim.opt.maxmempattern = 1000  -- default: 1000, max: 2000000
vim.opt.modelines = 1
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.path:append("$PWD/**", "**")
vim.opt.previewheight = 5
vim.opt.pumblend = 25
vim.opt.pumheight = 30
vim.opt.pyxversion = 3
vim.opt.redrawtime = 20000
vim.opt.regexpengine = 2
vim.opt.ruler = true
vim.opt.scrollback = 100000
vim.opt.scrolljump = 5
vim.opt.scrolloff = 8  -- default: 0
vim.opt.secure = true
vim.opt.shada = { "'20", "<50", "s10" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append("c", "I")  -- atOIc " default: filnxtToOF
vim.opt.showfulltag = true
vim.opt.showtabline = 2
vim.opt.sidescroll = 1  -- 0
vim.opt.sidescrolloff = 15  -- 0
vim.opt.signcolumn = "yes:2"
vim.opt.sessionoptions = { "blank", "buffers", "curdir", "folds", "globals", "help", "resize", "tabpages", "terminal", "winpos", "winsize" }
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.suffixes:append(".pyc")
vim.opt.switchbuf = "uselast"  -- useopen
vim.opt.synmaxcol = 3000  -- default: 3000, 0: unlimited, 400, 1500, 5000
vim.opt.tabstop = 2
vim.opt.tagcase = "smart"
vim.opt.tags = "./tags;"  -- http://d.hatena.ne.jp/thinca/20090723/1248286959
vim.opt.textwidth = 0
vim.opt.timeout = true         -- mappnig timeout
vim.opt.timeoutlen=200  -- default: 1000
vim.opt.ttimeout = true        -- keycode timeout
vim.opt.ttimeoutlen=20  -- default: 50
vim.opt.undodir = vim.fn.stdpath("data").."/undo"
vim.opt.undofile = true
vim.opt.undolevels = 100000
vim.opt.updatetime = 100  -- default: 4000
vim.opt.pumblend = 15
vim.opt.pumheight = 30
vim.opt.virtualedit = "block"
-- vim.opt.winbar = vim.fn.expand('%:~:.:h')..'/%t'
vim.opt.wildignore:append("*.jpg", "*.jpeg", "*.bmp", "*.gif", "*.png")
vim.opt.wildignore:append("*.o", "*.obj", "*.exe", "*.dll", "*.so", "*.out", "*.class")
vim.opt.wildignore:append("*.swp", "*.swo", "*.swn")
vim.opt.wildignore:append("*/.git", "*/.hg", "*/.svn")
vim.opt.wildignore:append("tags", "*.tags")
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.wildoptions = "pum"
vim.opt.winblend = 20
vim.opt.wrap = true
vim.opt.writebackup = true

vim.opt.autochdir = false
vim.opt.cursorcolumn = false
vim.opt.cursorline = false
vim.opt.errorbells = false
vim.opt.foldenable = false
vim.opt.ignorecase = false
vim.opt.imdisable = false
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

vim.opt.termguicolors = true
