"                                                                                                 "
"                 __                                                                              "
"  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                 "
"                                                                                                 "
" -------------------------------------------------------------------------------------------------
" Environment Variables: "{{{

let $XDG_RUNTIME_DIR = expand('/run/user/501')
let $XDG_CACHE_HOME = expand($HOME.'/.cache')
let $XDG_CONFIG_DIRS = expand('/etc/xdg')
let $XDG_CONFIG_HOME = expand($HOME.'/.config')
let $XDG_DATA_DIRS = expand('/usr/local/share:/usr/share')
let $XDG_DATA_HOME = expand($HOME.'/.local/share')
let $XDG_LOG_HOME = expand($HOME.'/.local/var/log')

" }}}
" -------------------------------------------------------------------------------------------------

" Global Settings: "{{{

set autoindent
set backup
set backupdir=$XDG_DATA_HOME/nvim/backup
set belloff=all
set cinoptions+=:0,g0,N-1,m1
set clipboard=unnamed,unnamedplus
set cmdheight=2
set colorcolumn=79
set complete=. " defauld: .,w,b,u,t
set completeopt=menu,longest " noinsert,noselect
set concealcursor=niv
set conceallevel=2
set directory=$XDG_DATA_HOME/nvim/swap
set expandtab
set fillchars="diff:⣿,fold: ,vert:│"
set foldcolumn=1
set foldmethod=indent
set foldnestmax=3 " maximum fold depth
set formatoptions+=r " Insert comment leader after hitting <Enter>
set formatoptions+=o " Insert comment leader after hitting o or O in normal mode
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions+=c " Autowrap comments using textwidth
set formatoptions+=l " do not wrap lines that have been longer when starting insert mode already
set formatoptions+=q " Allow formatting of comments with "gq".
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions+=n " Recognize numbered lists
set formatoptions+=j " Delete comment character when joining commented lines
set helplang=ja,en
set hidden
set history=10000
set ignorecase
set inccommand=nosplit
set laststatus=2
set lazyredraw
set linebreak
set list
set listchars=eol:↲,nbsp:%,tab:»-,trail:_
set makeprg="make -j8"
set matchtime=0
set modeline
set modelines=1
set noswapfile
set number
set path=$PWD/**
set previewheight=15
set pumheight=20
set regexpengine=2
set ruler
set scrolljump=1
set scrolloff=10
set secure
set shiftround
set shiftwidth=2
set shortmess+=c " default: shortmess=filnxtToOc " c: don't give ins-completion-menu messages
set showfulltag
set showmatch
set showmode
set showtabline=2
set sidescrolloff=3
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set switchbuf=useopen
set synmaxcol=0 " 0: unlimited
set tabstop=2
set tags=./tags; " http://d.hatena.ne.jp/thinca/20090723/1248286959
set termguicolors
set textwidth=0
set timeout " Mappnig timeout
set timeoutlen=400
set ttimeout " Keycode timeout
set ttimeoutlen=5
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set undolevels=10000
set updatetime=200
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png           " image
set wildignore+=*.manifest                               " gb
set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.out,*.class " compiler
set wildignore+=*.swp,*.swo,*.swn                        " vim
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc " YCM
set wildignore+=*/.git,*/.hg,*/.svn                      " vcs
set wildignore+=tags,*.tags                              " tags
set wildmode=longest,list:full " http://stackoverflow.com/a/526940/5228839
set wrap

set noautochdir
set noerrorbells
set nofoldenable
set nojoinspaces
set nolazyredraw
set noshiftround
set nostartofline
set noswapfile
set notitle
set novisualbell
set nowrapscan
set nowritebackup

if has('mac')
  set wildignore+=*.DS_Store " macOS only
  source $XDG_CONFIG_HOME/nvim/macOS_header.vim
endif

"}}}
" -------------------------------------------------------------------------------------------------

" GlobalAutoCmd: "{{{

" syntax highlight: ~/.nvim/after/syntax/vim.vim
augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

" }}}
" -------------------------------------------------------------------------------------------------

" Dein: "{{{

let s:dein_cache = expand('$XDG_CACHE_HOME/nvim/dein')
let s:dein_dir = s:dein_cache . '/repos/github.com/Shougo/dein.vim'
let s:vimproc_dir = s:dein_cache . '/repos/github.com/Shougo/vimproc.vim'

if &runtimepath !~ '/dein.vim'
  if !isdirectory(s:dein_dir)
    call mkdir(fnamemodify(s:dein_dir, ':h'), 'p')
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    execute '!git clone https://github.com/Shougo/vimproc.vim' s:vimproc_dir
    execute '!cd ' . s:vimproc_dir '&& make'
  endif

  " Add dein and vimproc to &runtimepath
  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p') , '/$', '', '')
  execute 'set runtimepath^=' . substitute(fnamemodify(s:vimproc_dir, ':p') , '/$', '', '')
endif

" Set dein.vim variables
let g:dein#types#git#clone_depth = 1

" Load dein cache if exists cache file
if dein#load_state(expand('<sfile>'))
  call dein#begin(s:dein_cache)

  " Develop Plugins:
  call dein#local($GOPATH.'/src/github.com/zchee', {'frozen': 1}, ['nvim-go'])
  " call dein#local($GOPATH.'/src/github.com/zchee', {'frozen': 1}, ['deogoto.nvim', 'deogoto-clang'])

  " Deoplete:
  call dein#add('Shougo/deoplete.nvim')
  " call dein#local($HOME.'/src/github.com/Shougo', {'frozen': 1 }, ['deoplete.nvim']) " call dein#add('Shougo/deoplete.nvim')
  " sources
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['c', 'cpp', 'objc', 'objcpp', 'cmake']}, ['deoplete-clang'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['dockerfile']}, ['deoplete-docker'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['go']}, ['deoplete-go'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['python', 'cython', 'pyrex']}, ['deoplete-jedi'])
  " call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['zsh']}, ['deoplete-zsh'])
  call dein#add('Shougo/neco-vim', {'on_i': 1, 'on_ft': ['vim']})
  " support:
  call dein#add('Shougo/echodoc.vim', {'on_i': 1})
  call dein#add('Shougo/neopairs.vim', {'on_i': 1})
  call dein#add('Shougo/neoinclude.vim', {'on_i': 1})
  call dein#add('Shougo/neosnippet.vim', {'on_i': 1})
  call dein#add('Shougo/neosnippet-snippets')

  " Dein:
  call dein#add('Shougo/dein.vim', {'rtp': ''})
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['dein.doc'])

  " Fuzzy:
  call dein#add('Shougo/denite.nvim') " call dein#local($HOME.'/src/github.com/Shougo', {'frozen': 1 }, ['denite.nvim'])
  call dein#add('Shougo/neomru.vim')
  call dein#add('nixprime/cpsm')
  call dein#add('mhinz/vim-grepper', {'on_cmd': ['Grepper'] })

  " Git:
  call dein#add('airblade/vim-gitgutter')
  call dein#add('lambdalisue/vim-gita')

  " Information:
  call dein#add('justinmk/vim-dirvish')
  call dein#add('majutsushi/tagbar', {'on_cmd': ['TagbarToggle']})

  " Interface:
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('scrooloose/nerdtree', {'lazy': 1})

  " Utility:
  call dein#add('Shougo/vimproc.vim')
  call dein#add('zchee/caw.vim', {'rev': 'swig'}) " wating for merge pull request...
  call dein#add('itchyny/vim-parenmatch')
  call dein#add('haya14busa/vim-asterisk', {'on_map': '<Plug>'})
  call dein#add('mattn/sonictemplate-vim', {'on_cmd': 'Template'})
  call dein#add('tyru/open-browser.vim')
  call dein#add('tyru/open-browser-github.vim', {'on_cmd': ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq']})
  call dein#local($HOME.'/src/github.com/haya14busa', {'frozen': 1, 'on_cmd': 'OpenGoogleTranslate'}, ['vim-open-googletranslate'])
  call dein#add('tweekmonster/haunted.vim')

  " Debugging:
  " call dein#add('critiqjo/lldb.nvim')


  " Testing Plugin:
  call dein#add('neomake/neomake')


  " Language Plugins:
  " Go:
  " call dein#add('fatih/vim-go', {'lazy': 1})
  call dein#add('garyburd/vigor', {'build': 'gb vendor restore && gb build'})
  call dein#add('tweekmonster/hl-goimport.vim')
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['vim-goslide'])

  " Python:
  " call dein#add('bfredl/nvim-ipy')
  call dein#add('davidhalter/jedi-vim', {'lazy': 1, 'on_ft' : ['python', 'cython', 'pyrex']})
  call dein#add('nvie/vim-flake8')
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#add('tweekmonster/impsort.vim', {'on_ft' : ['python','cython', 'pyrex']})

  " C Family:
  call dein#add('vim-jp/vim-cpp')
  call dein#add('lyuts/vim-rtags', {'on_ft': ['c', 'cpp', 'objc']})

  " Vim:
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('vim-jp/syntax-vim-ex', {'on_ft': ['vim']})

  " Asm:
  call dein#add('Shirk/vim-gas')

  " Binary:
  call dein#add('Shougo/vinarise.vim')

  " LLVM:
  call dein#add('rhysd/vim-llvm')

  " Toml:
  call dein#add('cespare/vim-toml')

  " Shell:
  call dein#add('chrisbra/vim-sh-indent')

  " Markdown:
  call dein#add('godlygeek/tabular', {'on_cmd': 'Tabularize' })
  call dein#add('moorereason/vim-markdownfmt', {'on_ft': ['markdown']})
  call dein#add('rhysd/vim-gfm-syntax', {'on_ft': ['markdown']})

  " Javascript:
  call dein#add('othree/yajs.vim')

  " Json:
  call dein#add('elzr/vim-json')

  " Tmux:
  call dein#add('tmux-plugins/vim-tmux')


  " Lifelog:
  call dein#add('wakatime/vim-wakatime')

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype indent plugin on

" }}}
" -------------------------------------------------------------------------------------------------

" Neovim: "{{{

let g:python_host_prog = '/opt/intel/intelpython2/bin/python2'
let g:python3_host_prog = '/opt/intel/intelpython3/bin/python3'

" Skip neovim module check
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

" Terminel settings
let g:terminal_scrollback_buffer_size = 100000

"}}}
" -------------------------------------------------------------------------------------------------

" Ignore Plugins: "{{{

let g:did_install_default_menus = 1 " $VIMRUNTIME/menu.vim
let g:did_menu_trans            = 1 " $VIMRUNTIME/menu.vim
let g:load_doxygen_syntax       = 1 " $VIMRUNTIME/syntax/doxygen.vim
let g:loaded_2html_plugin       = 1 " $VIMRUNTIME/plugin/tohtml.vim
let g:loaded_gzip               = 1 " $VIMRUNTIME/plugin/gzip.vim
let g:loaded_less               = 1 " $VIMRUNTIME/macros/less.vim
let g:loaded_matchit            = 1 " $VIMRUNTIME/plugin/matchit.vim
let g:loaded_matchparen         = 1 " $VIMRUNTIME/plugin/matchparen.vim
let g:loaded_netrw              = 1 " $VIMRUNTIME/autoload/netrw.vim
let g:loaded_netrwFileHandlers  = 1 " $VIMRUNTIME/autoload/netrwFileHandlers.vim
let g:loaded_netrwPlugin        = 1 " $VIMRUNTIME/plugin/netrwPlugin.vim
let g:loaded_netrwSettings      = 1 " $VIMRUNTIME/autoload/netrwSettings.vim
let g:loaded_rrhelper           = 1 " $VIMRUNTIME/plugin/rrhelper.vim
let g:loaded_spellfile_plugin   = 1 " $VIMRUNTIME/plugin/spellfile.vim
let g:loaded_sql_completion     = 1 " $VIMRUNTIME/autoload/sqlcomplete.vim
let g:loaded_syntax_completion  = 1 " $VIMRUNTIME/autoload/syntaxcomplete.vim
let g:loaded_tar                = 1 " $VIMRUNTIME/autoload/tar.vim
let g:loaded_tarPlugin          = 1 " $VIMRUNTIME/plugin/tarPlugin.vim
let g:loaded_tutor_mode_plugin  = 1 " $VIMRUNTIME/plugin/tutor.vim
let g:loaded_vimball            = 1 " $VIMRUNTIME/autoload/vimball.vim
let g:loaded_vimballPlugin      = 1 " $VIMRUNTIME/plugin/vimballPlugin
let g:loaded_zip                = 1 " $VIMRUNTIME/autoload/zip.vim
let g:loaded_zipPlugin          = 1 " $VIMRUNTIME/plugin/zipPlugin.vim
let g:myscriptsfile             = 1 " $VIMRUNTIME/scripts.vim
let g:netrw_nogx                = 1
let g:suppress_doxygen          = 1 " $VIMRUNTIME/syntax/doxygen.vim

"}}}
" -------------------------------------------------------------------------------------------------

" Color: "{{{

" Set colorscheme and config
let g:enable_bold_font = 1
colorscheme hybrid_reverse

if !exists('g:syntax_on')
  syntax enable
endif
filetype plugin indent on

" Global:
hi TermCursor    gui=reverse   guifg=#ffffff    guibg=none
hi TermCursorNC  gui=reverse   guifg=#ffffff    guibg=none
hi ParenMatch    gui=underline guifg=none       guibg=#343941

" Go:
" vim-go-stdlib:
let g:go_highlight_error = 1
let g:go_highlight_return = 1
hi goStdlibErr        gui=Bold    guifg=#ff005f    guibg=None
hi goString           gui=None    guifg=#92999f    guibg=None
hi goComment          gui=None    guifg=#787f86    guibg=None
hi goField            gui=Bold    guifg=#a1cbc5    guibg=None
hi link               goStdlib          Statement
hi link               goStdlibReturn    PreProc
hi link               goImportedPkg     Statement
hi link               goFormatSpecifier PreProc

" Python:
hi pythonSpaceError   gui=None    guifg=#787f86    guibg=#787f86
hi link pythonDelimiter    Special
hi link pythonNone    pythonFunction
hi link pythonSelf    pythonOperator
syn keyword pythonDecorator True False

" C:
let g:c_ansi_typedefs = 1
hi cCustomFunc  gui=Bold    guifg=#f0c674    guibg=None
hi cErr         gui=Bold    guifg=#ff005f    guibg=None

" Vim:
" quickfix:
Gautocmdft qf
      \ hi Search     gui=None    guifg=None  guibg=#373b41

" Sh:
let g:is_bash = 1

"}}}
" -------------------------------------------------------------------------------------------------

" Gautocmd: {{{

" Go:
" plan9 assembly
Gautocmdft ia64 let b:caw_oneline_comment = '//' | let b:caw_wrap_oneline_comment = ['/*', '*/']

" Python Cython:
Gautocmd BufWritePre *.py Neomake

" C Family:

" Vim:
" nested autoload
Gautocmd BufWritePost $MYVIMRC,*.vim nested silent! source $MYVIMRC | setlocal colorcolumn=99
Gautocmd BufEnter option-window call LessMap()

" Sh:
Gautocmdft sh let g:sh_noisk=1

" Markdown:
Gautocmdft markdown let g:sh_noisk=1

" Neosnippet:
Gautocmdft neosnippet call dein#source('neosnippet.vim')
" Clear neosnippet markers when InsertLeave
Gautocmd InsertLeave * NeoSnippetClearMarkers

" Gitcommit:
Gautocmd BufEnter COMMIT_EDITMSG startinsert

" Dirvish:
Gautocmdft dirvish let g:treachery#enable_autochdir = 0


" automatically close window
" http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
function! AutoClose()
  let s:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if winnr('$') == 1 &&
        \ s:ft == "qf" || s:ft == 'dirvish'
    quit!
  endif
endfunction
Gautocmd WinEnter * call AutoClose()

" macOS Frameworks and system header protection
Gautocmd BufNewFile,BufReadPost
      \ /System/Library/*,/Applications/Xcode*,/usr/include*,/usr/lib*
      \ setlocal readonly nomodified


" less like keymappnig
Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun,gita\-status,gita\-blame\-navi,neoman
      \ call LessMap()

Gautocmd TermOpen * set sidescrolloff=0 scrolloff=0

" }}}
" -------------------------------------------------------------------------------------------------

" Language settings "{{{

" Go:
" nvim-go
let go#highlight#cgo = 1
let g:go#build#autosave = 1
let g:go#build#force = 0
let g:go#fmt#autosave  = 1
let g:go#fmt#mode = 'goimports'
let g:go#guru#keep_cursor = {
      \ 'callees'    : 0,
      \ 'callers'    : 0,
      \ 'callstack'  : 0,
      \ 'definition' : 1,
      \ 'describe'   : 0,
      \ 'freevars'   : 0,
      \ 'implements' : 0,
      \ 'peers'      : 0,
      \ 'pointsto'   : 0,
      \ 'referrers'  : 0,
      \ 'whicherrs'  : 0
      \ }
let g:go#guru#reflection = 0
let g:go#iferr#autosave = 0
let g:go#lint#golint#autosave = 1
let g:go#lint#golint#ignore = ['internal']
let g:go#lint#golint#mode = 'root'
let g:go#lint#govet#autosave = 0
let g:go#lint#govet#flags = ['-v', '-lostcancel']
let g:go#lint#metalinter#autosave = 0
let g:go#lint#metalinter#autosave#tools = ['vet', 'golint']
let g:go#lint#metalinter#deadline = '20s'
let g:go#lint#metalinter#skip_dir = ['internal', 'vendor', 'testdata', '__*.go', '*_test.go']
let g:go#lint#metalinter#tools = ['vet', 'golint']
let g:go#rename#prefill = 1
let g:go#terminal#height = 120
let g:go#terminal#start_insert = 1
let g:go#terminal#width = 120
let g:go#test#args = ['-v']
let g:go#test#autosave = 0
" debug
let g:go#debug = 1
let g:go#debug#pprof = 0

" vim-go
" options
let g:go#use_vimproc = 1
let g:go_asmfmt_autosave = 1
let g:go_auto_type_info = 0
let g:go_autodetect_gopath = 1
let g:go_def_mapping_enabled = 0
let g:go_def_mode = 'godef'
let g:go_doc_command = 'godoc'
let g:go_doc_options = ''
let g:go_fmt_autosave = 1
let g:go_fmt_command = 'goimports'
let g:go_fmt_experimental = 1
let g:go_loclist_height = 15
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'gotype']
let g:go_snippet_engine = 'ultisnips' " neosnippet
let g:go_template_enabled = 0
let g:go_term_enabled = 1
let g:go_term_height = 30
let g:go_term_width = 30
" highlight
let g:go_highlight_array_whitespace_error = 0    " default : 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 0     " default : 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 0                    " default : 0
let g:go_highlight_format_strings = 1
let g:go_highlight_functions = 1                 " default : 0
let g:go_highlight_generate_tags = 1             " default : 0
let g:go_highlight_interfaces = 1                " default : 0
let g:go_highlight_methods = 1                   " default : 0
let g:go_highlight_operators = 1                 " default : 0
let g:go_highlight_space_tab_error = 0           " default : 1
let g:go_highlight_string_spellcheck = 0         " default : 1
let g:go_highlight_structs = 1                   " default : 0
let g:go_highlight_trailing_whitespace_error = 0 " default : 1


" C CXX:
let g:c_syntax_for_h = 1
" Rtags:
let g:rtagsJumpStackMaxSize = 1000
let g:rtagsMaxSearchResultWindowHeight = 15
let g:rtagsMinCharsForCommandCompletion = 100
let g:rtagsUseDefaultMappings = 0
let g:rtagsUseLocationList = 1


" OCaml:
" let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
" execute 'set rtp+=' . g:opamshare . '/merlin/vim'
let g:merlin_python_version = 3


" YCM:
" execute 'source $XDG_CONFIG_HOME' . '/nvim/ycm.vim'

" Open the C family online document using OpenBrowser
" https://github.com/rhysd/dogfiles/blob/926f2b9c1856bbf3a8090f430831f2c94d7cc410/vimrc#L1399-L1423
function! s:open_online_cfamily_doc()
  call dein#source('open-browser.vim')
  let l:l = getline('.')

  if l:l =~# '^\s*#\s*include\s\+<.\+>'
    let l:header = matchstr(l, '^\s*#\s*include\s\+<\zs.\+\ze>')
    if header =~# '^boost'
      "https://www.google.co.jp/search?hl=en&as_q=int64_max&as_sitesearch=cpprefjp.github.io
      execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.matchstr(header, 'boost/\zs[^/>]\+\ze')
      return
    else
      execute 'OpenBrowser' 'http://ja.cppreference.com/mwiki/index.php?title=Special:Search&search='.matchstr(header, '\zs[^/>]\+\ze')
      return
    endif
  else
    let l:cword = expand('<cword>')
    if cword ==# ''
      return
    endif
    let l:line_head = getline('.')[:col('.')-1]
    if line_head =~# 'boost::[[:alnum:]:]*$'
      execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.l:cword
    elseif line_head =~# 'std::[[:alnum:]:]*$'
      execute 'OpenBrowser' 'https://www.google.co.jp/search?hl=en&as_sitesearch=cpprefjp.github.io&as_q='.l:cword
      execute 'OpenBrowser' 'http://ja.cppreference.com/mwiki/index.php?title=Special:Search&search='.l:cword
    else
      let l:name = synIDattr(synIDtrans(synID(line("."), col("."), 1)), 'name')
      if l:name == 'Statement'
        execute 'OpenBrowser' 'http://ja.cppreference.com/w/c/language/'.l:cword
      else
        execute 'OpenBrowser' 'http://ja.cppreference.com/mwiki/index.php?title=Special:Search&search='.l:cword
      endif
    endif
  endif
endfunction

Gautocmdft c,cpp nnoremap <silent><buffer>K :<C-u>call <SID>open_online_cfamily_doc()<CR>
Gautocmdft c,cpp inoremap <expr> e getline('.')[col('.') - 6:col('.') - 2] ==# 'const' ? 'expr ' : 'e'
Gautocmdft cpp setlocal matchpairs+=<:>
" }}}


" Python:
let g:python_highlight_all = 1
let g:flake8_cmd = '/Users/zchee/.local/bin/flake8'
let g:flake8_show_in_gutter = 1
" vim-autopep8
let g:autopep8_aggressive = 1
let g:autopep8_disable_show_diff = 1
let g:impsort_highlight_imported = 1
let g:impsort_highlight_star_imports = 1


" Markdown:
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_level = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_new_list_item_indent = 4
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
let g:markdownfmt_autosave = 0
Gautocmd InsertLeave *.md,*.slide call system("issw 'com.apple.keyboardlayout.Programmer Dvorak.keylayout.ProgrammerDvorak'")

" Quickfix:
" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
function! AdjustWindowHeight(minheight, maxheight)
  let s:l = 1
  let s:n_lines = 0
  let s:w_width = winwidth(0)
  while s:l <= line('$')
    " number to float for division
    let s:l_len = strlen(getline(s:l)) + 0.0
    let s:line_width = s:l_len/s:w_width
    let s:n_lines += float2nr(ceil(s:line_width))
    let s:l += 1
  endw
  exe max([min([s:n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction
Gautocmdft qf call AdjustWindowHeight(5, 10)


" http://mattn.kaoriya.net/software/vim/20140523124903.html
let g:markdown_fenced_languages = [
      \ 'c',
      \ 'cpp',
      \ 'go',
      \ 'python',
      \ 'sh',
      \ 'vim',
      \]
let g:slide_fenced_languages = [
      \ 'sh',
      \ 'c',
      \ 'cpp',
      \ 'go',
      \ 'python',
      \ 'vim',
      \]

" }}}
" -------------------------------------------------------------------------------------------------

" Plugin Setting: "{{{

" Treachey:
let g:treachery#enable_keylayout = 1


" Deoplete:
let g:deoplete#auto_complete_delay = 0
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#file#enable_buffer_path = 1
let g:deoplete#max_list = 10000

" debug:
" call deoplete#enable_logging('DEBUG', $XDG_LOG_HOME.'/nvim/python/deoplete.log')
" call deoplete#custom#set('core', 'debug_enabled', 1)
" call deoplete#custom#set('go', 'debug_enabled', 1)
" let g:deoplete#enable_profile = 1

" filters:
call deoplete#custom#set('_', 'converters', [
      \   'converter_auto_paren',
      \   'converter_remove_overlap',
      \ ])

" Omnifunc:
let g:deoplete#omni#input_patterns = {} " Initialize
Gautocmdft go,python,ruby setlocal omnifunc=

" Sources:
let g:deoplete#sources = {}
let g:deoplete#sources.gitcommit = ['buffer']
" Ignore:
let g:deoplete#ignore_sources = {} " Initialize
let g:deoplete#ignore_sources.go =
      \ ['dictionary', 'member', 'omni', 'tag', 'syntax']
let g:deoplete#ignore_sources.python =
      \ ['buffer', 'dictionary', 'member', 'omni', 'tag', 'syntax'] " file/include conflicting deoplete-jedi
let g:deoplete#ignore_sources.c =
      \ ['dictionary', 'member', 'omni', 'tag', 'syntax', 'file/include']
let g:deoplete#ignore_sources.cpp    = g:deoplete#ignore_sources.c
let g:deoplete#ignore_sources.objc   = g:deoplete#ignore_sources.c

" Support:
let g:echodoc_enable_at_startup = 1
let g:neopairs#enable = 1

" Go:
call deoplete#custom#set('go', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#set('go', 'sorters', [])
let g:deoplete#sources#go#auto_goos = 1
let g:deoplete#sources#go#cgo = 1
let g:deoplete#sources#go#cgo#libclang_path = '/usr/local/lib/libclang.dylib'
let g:deoplete#sources#go#cgo#sort_algo = 'alphabetical'
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#json_directory = $XDG_CACHE_HOME . '/deoplete/go/darwin_amd64'
let g:deoplete#sources#go#on_event = 1
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#sort_class = ['func', 'type', 'var', 'const', 'package']
let g:deoplete#sources#go#use_cache = 0

" Python:
call deoplete#custom#set('jedi', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#set('jedi', 'matchers', ['matcher_fuzzy'])
let g:deoplete#sources#jedi#statement_length = 0
let g:deoplete#sources#jedi#short_types = 0
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#worker_threads = 2
let g:deoplete#sources#jedi#python_path = g:python3_host_prog

" C Family:
let g:deoplete#sources#clang#libclang_path = '/usr/local/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header = '/usr/local/lib/clang'
let g:deoplete#sources#clang#flags = [
      \ "-I/usr/local/include",
      \ "-isysroot", $XCODE_DIR . "/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk",
      \ ] " echo | clang -v -E -x c -

" Vim:
call deoplete#custom#set('vim', 'disabled_syntaxes', ['Comment'])

" Ruby:
" let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']

" Neosnippet:
call deoplete#custom#set('neosnippet', 'disabled_syntaxes', ['goComment'])
let g:snips_author = 'Koichi Shiraishi'
let g:neosnippet_username = 'zchee'
let g:neosnippet#data_directory = $XDG_CACHE_HOME . '/nvim/neosnippet'
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#expand_word_boundary = 1
let g:neosnippet#disable_runtime_snippets = {
      \   'c': 1,
      \ 'cpp': 0,
      \  'go': 1,
      \ }
let g:neosnippet#snippets_directory =
      \ $XDG_CONFIG_HOME . "/nvim/neosnippets,"
      " \ . $DEIN_DIR . "/fatih/vim-go/gosnippets/snippets,"
      " \ . $DEIN_DIR . "/honza/vim-snippets/snippets,"


" Denite:
call denite#custom#source('file_rec', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])
call denite#custom#source('grep', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
call denite#custom#source('line', 'command', ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
let g:cpsm_unicode = 1
let g:ctrlp_match_current_file = 1
nnoremap <silent> <C-p> :let g:cpsm_match_empty_query = 1<CR>:CtrlP<CR>


" Caw:
let g:caw_hatpos_skip_blank_line = 0
let g:caw_no_default_keymappings = 1
let g:caw_operator_keymappings = 0

" Grepper:
let g:grepper = {
      \ 'tools': ['pt', 'ag', 'git'],
      \ 'pt': {
      \   'grepprg':    "pt --nocolor --nogroup --ignore=docs --ignore=doxygen --ignore=tags",
      \   'grepformat': '%f:%l:%m',
      \   'escape':     '\+*^$()[]',
      \ },
      \ 'open':  1,
      \ 'jump':  0,
      \ }


" Dirvish:
let g:dirvish_hijack_netrw = 1
let g:dirvish_relative_paths = 1
" Gautocmdft dirvish silent! keeppatterns g/\(-rplugin\|tags\|\.\(git\|hg\|svn\|DS_Store\|so\|dylib\|zwc\)\)/d
Gautocmdft dirvish setlocal colorcolumn=


" Gitgutter:
let g:gitgutter_eager = 1
let g:gitgutter_enabled = 1
let g:gItgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 1000
let g:gitgutter_realtime = 0
let g:gitgutter_sign_column_always = 1


" Airline:
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#exclude_preview = 1
let g:airline#extensions#tabline#excludes = []
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#wordcount#enabled = 0
let g:airline_inactive_collapse = 1
let g:airline_powerline_fonts = 1
" vim-airline theme
let g:airline_theme = 'hybridline'
" vim-airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_section_c = airline#section#create(['%<', 'readonly', ' ', 'path'])


" QuickRun:
Gautocmd WinEnter *
      \ if winnr('$') == 1 &&
      \   getbufvar(winbufnr(winnr()), "&filetype") == "quickrun" |
      \ q |
      \ endif
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
      \ 'runner' : 'vimproc',
      \ 'runner/vimproc/updatetime' : 50,
      \ 'outputter' : 'quickfix',
      \ 'outputter/quickfix/open_cmd' : 'copen 35',
      \ 'outputter/buffer/running_mark' : ''
      \ }
" Go
let g:quickrun_config.go = {
      \ 'command': 'run',
      \ 'cmdopt' : '',
      \ 'exec': ['go %c %s %o -'],
      \ 'outputter' : 'buffer',
      \ 'outputter/buffer/split' : 'vertical botright 100',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }


" Neomake:
let g:neomake_open_list = 2
let g:neomake_python_enabled_makers = ['pyflakes', 'flake8']

" Jedivim:
let g:jedi#auto_initialization = 0
let g:jedi#use_splits_not_buffers = ''
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#documentation_command = "K"
let g:jedi#force_py_version = 3
let g:jedi#max_doc_height = 150
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = 0
let g:jedi#smart_auto_mappings = 0


" Cursorword:
let g:cursorword = 0


" Wakatime:
let g:wakatime_PythonBinary = '/opt/intel/intelpython3/bin/python3'


" SonicTemplate:
let g:sonictemplate_vim_template_dir = [
      \ $HOME.'/.nvim/template'
      \]


" Tagbar:
let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
let g:tagbar_width = 80
" Gautocmd BufEnter *.go nested :call tagbar#autoopen(0)


" Vim Open Googletranslate:
let g:opengoogletranslate#openbrowsercmd = 'electron-open --without-focus'


" }}}
" -------------------------------------------------------------------------------------------------

" Command: "{{{

" Grepper:
" command! -nargs=* -complete=file G Grepper -tool ag -noprompt -grepprg ag --vimgrep <args> %
command! -nargs=* -complete=file G Grepper -tool pt -noprompt -query -grepprg pt --nocolor --nogroup <args> %

" Capture:
" http://qiita.com/sgur/items/9e243f13caa4ff294fa8
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

" FormatJson:
command! -nargs=0 -bang -complete=command FormatJson %!python -m json.tool

" SyntaxProfiling:
command! -nargs=0 -bang -complete=command ProfileSyntax call ProfileSyntax()

" }}}
" -------------------------------------------------------------------------------------------------

" Functions: "{{{

" https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
" When editing a file, always jump to the last known cursor position.  Don't
" do it when the position is invalid or when inside an event handler
" Also don't do it when the mark is in the first line, that is the default
" Posission when opening a file
Gautocmd BufWinEnter *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' |
      \ execute "keepjumps normal! g`\""


" Smart help window
" https://github.com/rhysd/dotfiles/blob/master/nvimrc#L380-L405
function! s:smart_help(args)
  try
    if winwidth(0) > winheight(0) * 2
      execute 'vertical rightbelow help ' . a:args
    else
      execute 'rightbelow help ' . a:args
    endif
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry
endfunction
command! -nargs=* -complete=help Help call <SID>smart_help(<q-args>)

" SmartHelpGrep
function! s:smart_helpgrep(args)
  try
    if winwidth(0) > winheight(0) * 2
      execute 'vertical rightbelow helpgrep ' . a:args . '@ja'
    else
      execute 'rightbelow helpgrep ' . a:args . '@ja'
    endif
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry
  copen
endfunction
command! -nargs=* -complete=help HelpGrep call <SID>smart_helpgrep(<q-args>)


" Display syntax infomation on under the current cursor
" for syntax ID
function! s:get_syn_id(transparent)
  let s:synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(s:synid)
  else
    return s:synid
  endif
endfunction
" for syntax attributes
function! s:get_syn_attr(synid)
  let s:name = synIDattr(a:synid, "name")
  if has('nvim')
    let s:guifg = synIDattr(a:synid, "fg", "gui")
    let s:guibg = synIDattr(a:synid, "bg", "gui")
    let s:attr = {
          \ "name": s:name,
          \ "guifg": s:guifg,
          \ "guibg": s:guibg,
          \ }
  else
    let s:ctermfg = synIDattr(a:synid, "fg", "cterm")
    let s:ctermbg = synIDattr(a:synid, "bg", "cterm")
    let s:attr = {
          \ "name": s:name,
          \ "ctermfg": s:ctermfg,
          \ "ctermbg": s:ctermbg,
          \ }
  endif
  return s:attr
endfunction
" return syntax information
function! s:get_syn_info(cword)
  let s:baseSyn = s:get_syn_attr(s:get_syn_id(0))
  if has('nvim')
    let s:baseSynInfo = "name: " . s:baseSyn.name .
          \ " guifg: " . s:baseSyn.guifg .
          \ " guibg: " . s:baseSyn.guibg
  else
    let s:baseSynInfo = "name: " . s:baseSyn.name .
          \ " ctermfg: " . s:baseSyn.ctermfg .
          \ " ctermbg: " . s:baseSyn.ctermbg
  endif
  let s:linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  if has('nvim')
    let s:linkedSynInfo =  "name: " . s:linkedSyn.name .
          \ " guifg: " . s:linkedSyn.guifg .
          \ " guibg: " . s:linkedSyn.guibg
  else
    let s:linkedSynInfo =  "name: " . s:linkedSyn.name .
          \ " ctermfg: " . s:linkedSyn.ctermfg .
          \ " ctermbg: " . s:linkedSyn.ctermbg
  endif
  echomsg a:cword . ':'
  echomsg s:baseSynInfo
  echomsg '  ' . "link to"
  echomsg s:linkedSynInfo
endfunction
command! SyntaxInfo call s:get_syn_info(expand('<cword>'))


" Clear message logs
command! ClearMessage for n in range(200) | echom "" | endfor


" Binary edit mode
" need open nvim with `-b` flag
function! BinaryMode() abort
  if !has('binary')
    echoerr "BinaryMode must be 'binary' option"
    return
  endif

  execute '%!xxd'
endfunction


" less like mappings
function! LessMap() "{{{
  set colorcolumn=""
  let b:gitgutter_enabled = 0
  " less likes keymap
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
endfunction "}}}


" Syntax Profiling
function! ProfileSyntax() abort "{{{
  " Initial and cleanup syntime
  redraw!
  syntime clear
  " Profiling syntax regexp
  syntime on
  redraw!
  QuickRun -type vim -src 'syntime report'
endfunction "}}}


" MarkdownSyntaxInclude
function! s:MarkdownRefreshGoSyntax()
  MarkdownSyntaxInclude go
  MarkdownSyntaxInclude sh
  MarkdownRefreshSyntax
endfunction

" Trailing whitespace
function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff' && &filetype != 'markdown'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction

" }}}
" -------------------------------------------------------------------------------------------------

" Keymap: "{{{

" - Global MapLeader: <Space>
" - Local prefix: .
" - Swaps semicolon and colon setting move to Karabiner or macOS keyboard custom.

" Kinesis Advantage + Center of Dvorak keyboard.
" inoremap <PageDown> <ESC>
" nnoremap <PageDown> <ESC>

nnoremap <Space> <Nop>

nnoremap <BS>    <Nop>
" Kinesis Advantage + Left of Dvorak keyboard.

" . Leader mappnig
nnoremap <silent> .d   :<C-u>Dirvish<CR>
nnoremap <silent> .D   :<C-u>tabnew \| Dirvish<CR>
nnoremap <silent> .g   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap <silent> .m   <C-w>W
nnoremap <silent> .n   gt
nnoremap <silent> .p   gT
nnoremap <silent> .r   <C-w>r<C-w>w
nnoremap <silent> .s   :bNext<CR>
nnoremap <silent> .t   :<C-u>tabnew<CR>:call feedkeys(":e")<CR>
nnoremap <silent> .v   :<C-u>vsplit<CR><C-w>w
nnoremap <silent> .w   <C-w>w
nnoremap <silent> .z   :<C-u>split<CR><C-w>w

nnoremap <silent><C-p> :<C-u>Denite file_rec<CR>
nnoremap <silent><C-g> :<C-u>Denite line<CR>

" }}}
" -------------------------------------------------------------------------------------------------
" Map Leader: "{{{

if !exists('g:mapleader')
  let g:mapleader = "\<Space>"
endif
if !exists('g:maplocalleader')
  let g:maplocalleader = "\<BS>"
endif

" Kinesis Advantage + Dvorak Lefthand
nnoremap <silent><Leader>g        :<C-u>HelpGrep<Space><C-l>
nnoremap <silent><Leader>h        :<C-u>Help<Space><C-l>
nnoremap <silent><Leader>pp       :<C-u>Unite -smartcase -no-split -buffer-name=files -start-insert directory:~<cr>
nnoremap <silent><Leader>q        :call ToggleCursorWord()<CR><Right><Left>
nnoremap <silent><Leader>w        :<C-u>w<CR>

" Kinesis Advantage + Dvorak Righthand
nnoremap <silent><LocalLeader>-   :<C-u>split<CR>
nnoremap <silent><LocalLeader>\   :<C-u>vsplit<CR>
nnoremap <silent><LocalLeader>gg  :Grepper -cword -noprompt<CR>
nnoremap <silent><LocalLeader>q   :<C-u>q<CR>
nnoremap <silent><LocalLeader>r   :<C-u>write<CR> :QuickRun<CR>
nnoremap <silent><LocalLeader>w   :<C-u>w<CR>
nmap     <silent><LocalLeader>sa  <Plug>(operator-surround-append)
nmap     <silent><LocalLeader>sd  <Plug>(operator-surround-delete)
nmap     <silent><LocalLeader>sr  <Plug>(operator-surround-replace)

" }}}
" -------------------------------------------------------------------------------------------------
" Map: {{{

" }}}
" -------------------------------------------------------------------------------------------------
" Normal: {{{

nnoremap     s     A
" When type 'x' key(delete), do not add yank register
nnoremap     x     "_x
" Jump marked line
nnoremap     zj    zjzt
nnoremap     zk    2zkzjzt
" Don't use Ex mode, use Q for formatting
nnoremap     Q     gq
" Disable suspend
nnoremap     ZQ    <Nop>
nmap <silent>*     <Plug>(asterisk-gz*)
" Go to first and end using capitalized directions
" Switch @ and ^ for Dvorak pinky
nnoremap @       ^
nnoremap ^       @
" Fast scroll
nnoremap <C-e> 2<C-e>
" Cancel highlight search word
nnoremap <silent><C-q>  :nohlsearch<CR>
" fast scroll
nnoremap <C-y> 2<C-y>

" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
nnoremap <silent><M-h>          :<C-u>Help<Space><C-r><C-w><CR>

" Jump to match pair brackets
" <Tab> and <C-i> are similar treatment. Need <C-i> for jump to next taglist
nnoremap <S-Tab> %


" Plugins:
"" Caw:
nmap <silent>gc  <Plug>(caw:hatpos:toggle)
"" OpenBrowser:
nmap <silent>gx  <Plug>(openbrowser-smart-search)


" FileTypes:

"" Go:
Gautocmdft go nmap  <silent><buffer>K                   <Plug>(go-doc)
Gautocmdft go nmap  <silent><buffer><LocalLeader>]      :<C-u>GoGeneDefinition<CR>
Gautocmdft go nmap  <silent><buffer><C-]>               :<C-u>call GoGuru('definition')<CR>
Gautocmdft go nmap  <silent><buffer><Leader>]           :<C-u>Godef<CR>
" MapLeader Left hand
Gautocmdft go nmap  <silent><buffer><Leader>a           <Plug>(nvim-go-analyze-buffer)
Gautocmdft go nmap  <silent><buffer><Leader>e           <Plug>(nvim-go-rename)
Gautocmdft go nmap  <silent><buffer><Leader>i           <Plug>(nvim-go-iferr)
" MapLeader Right hand
Gautocmdft go nmap  <silent><buffer><LocalLeader>db     :<C-u>DlvBreakpoint<CR>
Gautocmdft go nmap  <silent><buffer><LocalLeader>dc     :<C-u>DlvContinue<CR>
Gautocmdft go nmap  <silent><buffer><LocalLeader>dd     :<C-u>DlvDebug<CR>
Gautocmdft go nmap  <silent><buffer><LocalLeader>dn     :<C-u>DlvNext<CR>
Gautocmdft go nmap  <silent><buffer><LocalLeader>dr     :<C-u>DlvBreakpoint<CR>
Gautocmdft go nmap  <silent><buffer><LocalLeader>b      <Plug>(nvim-go-build)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gc     <Plug>(nvim-go-callers)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gcs    <Plug>(nvim-go-callstack)
Gautocmdft go nmap  <silent><buffer><LocalLeader>ge     <Plug>(nvim-go-callees)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gi     <Plug>(nvim-go-implements)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gl     <Plug>(nvim-go-metalinter)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gr     <Plug>(nvim-go-referrers)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gs     <Plug>(nvim-go-test-switch)
Gautocmdft go nmap  <silent><buffer><LocalLeader>l      <Plug>(nvim-go-lint)
Gautocmdft go nmap  <silent><buffer><LocalLeader>r      <Plug>(nvim-go-run)
Gautocmdft go nmap  <silent><buffer><LocalLeader>t      <Plug>(nvim-go-test)
Gautocmdft go nmap  <silent><buffer><LocalLeader>v      <Plug>(nvim-go-vet)

"" C CXX ObjC:
Gautocmdft c,cpp,objc,objcpp nmap     <buffer><Leader>x        <Plug>(operator-clang-format)
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><Space>]         :<C-u>YcmCompleter GoTo<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>]   :<C-u>tag <C-r>=expand("<cword>")<CR><CR>
""" Rtags:
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><C-]>            :<C-u>call rtags#JumpTo(g:SAME_WINDOW)<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cb  :<C-u>call rtags#JumpBack()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cc  :<C-u>call rtags#FindRefs()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cC  :<C-u>call rtags#FindSuperClasses()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cf  :<C-u>call rtags#FindSubClasses()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cn  :<C-u>call rtags#FindRefsByName(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cp  :<C-u>call rtags#JumpToParent()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cs  :<C-u>call rtags#FindSymbols(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><Leader>u        :<C-u>call rtags#SymbolInfo()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cu  :<C-u>call rtags#SymbolInfo()<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><LocalLeader>cv  :<C-u>call rtags#FindVirtuals()<CR>

"" Python Cython:
Gautocmdft python,cython nnoremap <silent><buffer>K          :<C-u>call jedi#show_documentation()<CR>
Gautocmdft python,cython nnoremap <silent><buffer><C-]>      :<C-u>call jedi#goto()<CR>
Gautocmdft python,cython nnoremap <silent><buffer><C-e>      :<C-u>call jedi#rename()<CR>
Gautocmdft python,cython nnoremap <silent><buffer><C-f>      :<C-u>call Flake8()<CR><C-w>w :call feedkeys("<Up>")<CR>
Gautocmdft python,cython nnoremap <silent><buffer><Leader>]  :<C-u>tag <c-r>=expand("<cword>")<CR><CR>
Gautocmdft python,cython nnoremap <silent><buffer><Leader>e  :<C-u>call jedi#rename_visual()<CR>
Gautocmdft python,cython nnoremap <silent><buffer><Leader>m  :<C-u>messages<CR>

"" Vim:
Gautocmdft vim nnoremap <silent><LocalLeader>h :<C-u>Help<Space><C-r><C-w><CR>
Gautocmdft vim nnoremap <silent><buffer>K      :<C-u>SmartHelp<Space><C-r><C-w><CR>

"" Help:
Gautocmdft help nnoremap <silent><buffer><C-n> :<C-u>cnext<CR>
Gautocmdft help nnoremap <silent><buffer><C-p> :<C-u>cprevious<CR>

"" Ouickfix:
" Re enable <CR> in quickfix and locationlist
Gautocmdft qf  nnoremap <buffer><CR>      <CR>

"" Markdown:
Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>

" }}}
" -------------------------------------------------------------------------------------------------
" Insert: {{{

" Move cursor to first or end of line
inoremap <silent><C-a>  <C-o><S-i>
inoremap <silent><C-e>  <C-o><S-a>
" Put +register word
inoremap <silent><C-p>  <C-r>+
inoremap <silent><C-j>  <C-r>+


" FileTypes:
"" Go:
Gautocmdft go inoremap  "    '
Gautocmdft go inoremap  '    "


" Plugins:
"" Deoplete:
inoremap <silent><expr><CR>     pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
inoremap <silent><expr><Tab>    pumvisible() ? "\<C-n>".deoplete#mappings#close_popup() : "\<Tab>"
inoremap <silent><expr><BS>     pumvisible() ? deoplete#mappings#refresh()."\<BS>" : "\<BS>"
inoremap <silent><expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
inoremap <silent><expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"
inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
inoremap <silent><expr><C-l>    pumvisible() ? deoplete#mappings#refresh() : "\<C-l>"
inoremap <silent><expr><C-z>    deoplete#mappings#undo_completion()

"" Neosnippet:
imap <expr><C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : ""

" }}}
" -------------------------------------------------------------------------------------------------
" Visual Select: {{{

" Do not add register to current cursor word
vnoremap c       "_c
vnoremap x       "_x
vnoremap P       "_dP
vnoremap p       "_dp
vnoremap @       ^
vnoremap ^       @
" sort alphabetically
vnoremap <silent>gs :<C-u>'<,'>sort i<CR>
vnoremap v $h
" Move to start of line
vnoremap V ^
" Jump to match pair brackets
vnoremap <S-Tab> %

vmap <silent>gx  <Plug>(openbrowser-smart-search)


" FileTypes:
"" Go:
Gautocmdft go vnoremap "  '
Gautocmdft go vnoremap '  "
"" C:
Gautocmdft c  vnoremap <buffer> <c-f> :call RangeUncrustify('c')<CR>


" Plugins:
"" Caw:
vmap <silent>gc  <Plug>(caw:hatpos:toggle)
"" OperatorUser:
""" operator-surround
vmap <silent>sa  <Plug>(operator-surround-append)
vmap <silent>sd  <Plug>(operator-surround-delete)
vmap <silent>sr  <Plug>(operator-surround-replace)

" }}}
" -------------------------------------------------------------------------------------------------
" Visual: {{{

" FileTypes:
"" Go:
Gautocmdft go xnoremap "  '
Gautocmdft go xnoremap '  "

" }}}
" -------------------------------------------------------------------------------------------------
" Select: {{{

" FileTypes:
"" Go:
Gautocmdft go snoremap "  '
Gautocmdft go snoremap '  "


" Plugins:
"" Neosnippet:
smap <expr><C-k> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : ""

" }}}
" -------------------------------------------------------------------------------------------------
" Command Line: {{{

" Move beginning of the command line
" http://superuser.com/a/988874/483994
cnoremap <C-a>    <Home>
cnoremap <C-d>    <Del>

" }}}
" -------------------------------------------------------------------------------------------------
" Terminal: {{{

" Emacs like mapping
tnoremap <S-Left>        <C-[>b
tnoremap <C-Left>        <C-[>b
tnoremap <S-Right>       <C-[>f
tnoremap <C-Right>       <C-[>f
tnoremap <nowait><buffer><BS>    <BS>

" qq to exit to terminal mode
tnoremap <silent>jj  <C-\><C-n>

" }}}
" -------------------------------------------------------------------------------------------------
" vim:ft=vim:cc=99
