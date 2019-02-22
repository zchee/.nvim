"                                                                                                 "
"                 __                                                                              "
"  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                 "
"                                                                                                 "
" -------------------------------------------------------------------------------------------------
" Environment Variables:
"
filetype off
filetype plugin indent off

let s:gopath = expand('$HOME/go')
let s:srcpath = expand('$HOME/src')

" -------------------------------------------------------------------------------------------------
" GlobalAutoCmd:

augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

" -------------------------------------------------------------------------------------------------
" Global Settings:

set autoindent
set backup & backupdir=$XDG_DATA_HOME/nvim/backup
set belloff=all
set cinkeys-=0#             " Comments don't fiddle with indenting
set cinoptions+=:0,g0,N-1,m1
set cinoptions=''                 " See :h cinoptions-values
set clipboard+=unnamedplus
set cmdheight=2
set complete=.  " default: .,w,b,u,t
set completeopt=menuone,noinsert,noselect  " longest
set concealcursor=niv
set conceallevel=1
set copyindent
set directory=$XDG_DATA_HOME/nvim/swap
set emoji
set encoding=utf-8
set expandtab
set fileformats=unix,mac,dos
set fillchars="diff:⣿,fold: ,vert:│"
set foldcolumn=0
set foldlevel=0
set foldmethod=manual
set foldnestmax=1  " maximum fold depth
set formatoptions+=c  " Autowrap comments using textwidth
set formatoptions+=j  " Delete comment character when joining commented lines
set formatoptions+=l  " do not wrap lines that have been longer when starting insert mode already
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=q  " Allow formatting of comments with "gq".
set formatoptions+=r  " Insert comment leader after hitting <Enter>
set formatoptions+=t  " Auto-wrap text using textwidth
set helplang & helplang=en,ja  " Hey, if true Vim master, use English help language.
set hidden
set history=10000
set ignorecase
set inccommand=nosplit
set laststatus=2
set linebreak
set list & listchars=nbsp:%,tab:»-,trail:_,extends:›,precedes:‹
set makeprg="make -j12"
set matchtime=0  " disable nvim matchparen
set maxmempattern=2000000  " default: 1000, max: 2000000
set modeline
set modelines=5
set mouse=a
set noswapfile
set number
set packpath=
set path=$PWD/**
set previewheight=5
set pumblend=10
set pumheight=30
set regexpengine=2
set ruler
set scrollback=-1
set scrollback=100000
set scrolljump=3
set scrolloff=8  " default: 0
set secure
set shiftround
set shiftwidth=2
set shortmess+=c  " default: filnxtToOF
set showfulltag
set showmode
set showtabline=2
set sidescroll=1
set sidescrolloff=15
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set suffixes+=.pyc
set switchbuf=useopen
set synmaxcol=1500  " default: 3000, 0: unlimited, 400
set tabstop=2
set tags=./tags;  " http://d.hatena.ne.jp/thinca/20090723/1248286959
set termguicolors
set textwidth=0
set timeout         " mappnig timeout
" set timeoutlen=3000  " default: 1000
set timeoutlen=500  " default: 1000
set ttimeout        " keycode timeout
set ttimeoutlen=10 " 5   " default: 50
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set undolevels=10000
set updatetime=100  " default: 4000
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png            " image
set wildignore+=*.manifest                                " gb
set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.out,*.class  " compiler
set wildignore+=*.swp,*.swo,*.swn                         " vim
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc  " YCM
set wildignore+=*/.git,*/.hg,*/.svn                       " vcs
set wildignore+=tags,*.tags                               " tags
set wildmode=longest,list:full  " http://stackoverflow.com/a/526940/5228839
set wrap

set noautochdir
set noerrorbells
set nofoldenable
set nojoinspaces
set nolazyredraw
set noshiftround
set noshowcmd
set noshowmatch
set nostartofline
set noswapfile
set notitle
set novisualbell
set nowrapscan
set nowritebackup

if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
  call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
  call mkdir(&undodir, "p")
endif

if has('mac')
  set wildignore+=*.DS_Store  " macOS only
  Gautocmdft c,cpp,objc,objcpp source $XDG_CONFIG_HOME/nvim/path/macOS_header.vim  " only Go and C family filetype
endif

let s:python2_include_dir = '/usr/local/opt/python2/Frameworks/Python.framework/Headers'
let s:python3_include_dir = '/usr/local/opt/python3/Frameworks/Python.framework/Headers'
if isdirectory(s:python2_include_dir)
  set path+=s:python2_include_dir
endif
if isdirectory(s:python3_include_dir)
  set path+=s:python3_include_dir
endif

" add $CPATH directories to &path
for s:cpath in split($CPATH, ":")
  exec 'set path+=' . s:cpath
endfor

" -------------------------------------------------------------------------------------------------
" Dein:

let s:dein_cache_dir = $XDG_CACHE_HOME . '/nvim/dein'
if !isdirectory(s:dein_cache_dir)
  call mkdir(s:dein_cache_dir, 'p')
endif
let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
  if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
    let s:dein_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

let g:dein#install_max_processes = 12
let g:dein#types#git#default_protocol = 'https'
let g:dein#types#git#clone_depth = 1

if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir, expand('<sfile>'))

  " Develop Plugins:
  call dein#local(s:gopath.'/src/',  { 'frozen': 1, 'merged': 0 }, ['github.com/zchee/nvim-go'])
  " call dein#local(s:gopath.'/src/',  { 'frozen': 1, 'merged': 0 }, ['github.com/zchee/nvim-kube', 'github.com/zchee/nvim-terraform', 'github.com/zchee/nvim-flycheck'])
  call dein#local(s:srcpath.'/github.com/', { 'on_ft': ['fbs'], 'frozen': 1, 'merged': 0 }, ['zchee/vim-flatbuffers'])
  call dein#local(s:srcpath.'/github.com/', { 'on_ft': ['gn'], 'frozen': 1, 'merged': 0 }, ['zchee/vim-gn'])
  call dein#local(s:srcpath.'/github.com/', { 'on_ft': ['vgo'], 'frozen': 1, 'merged': 0 }, ['zchee/vim-vgo'])

  " Dein:
  call dein#add('Shougo/dein.vim')

  " Deoplete:
  call dein#add('Shougo/deoplete.nvim')
  "" suorces
  call dein#local(s:srcpath.'github.com/', { 'on_ft': ['go'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-go'])
  call dein#local(s:srcpath.'github.com/', { 'on_ft': ['python', 'cython', 'pyrex'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-jedi'])
  " call dein#local(s:srcpath.'github.com/', { 'on_ft': ['cmake'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-clang'])
  " call dein#local(s:srcpath.'github.com/', { 'on_ft': ['dockerfile'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-docker'])
  call dein#local(s:srcpath.'github.com/', { 'on_ft': ['gas', 'masm'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-asm'])
  call dein#local(s:srcpath.'github.com/', { 'on_ft': ['zsh'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-zsh'])
  call dein#add('Shougo/neco-vim', { 'on_ft': ['vim'] })
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neosnippet.vim', { 'depends': ['neosnippet-snippets'] })
  "" support
  " call dein#add('Shougo/context_filetype.vim')
  call dein#add('Shougo/neoinclude.vim', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp', 'swift'] })
  call dein#add('Shougo/echodoc.vim')
  call dein#add('Shougo/neopairs.vim')
  " call dein#add('Shougo/deoppet.nvim')

  " Denite:
  call dein#add('Shougo/denite.nvim')
  "" dependency
  " call dein#local(s:srcpath, { 'frozen': 1, 'merged': 1 }, ['github.com/nixprime/cpsm'])
  "" suorces

  " LanguageClient:
  " call dein#add('autozimu/LanguageClient-neovim', { 'rev': 'next' })
  call dein#local(s:srcpath, { 'frozen': 1, 'merged': 1 }, ['github.com/autozimu/LanguageClient-neovim'])
  " call dein#add('google/ijaas')

  " Filer:
  call dein#add('cocopon/vaffle.vim')
  call dein#add('scrooloose/nerdtree', { 'on_cmd': ['NERDTree', 'NERDTreeVCS', 'NERDTreeFromBookmark', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeMirror', 'NERDTreeClose', 'NERDTreeFind', 'NERDTreeCWD', 'NERDTreeRefreshRoot'] })
  " call dein#add('google/vim-searchindex')
  " call dein#add('Shougo/defx.nvim')
  " call dein#add('godlygeek/tabular')

  " Git:
  call dein#add('airblade/vim-gitgutter')
  call dein#add('lambdalisue/gina.vim')

  " Linter:
  call dein#add('w0rp/ale')

  " Formatter:
  call dein#add('rhysd/vim-clang-format', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp', 'proto', 'javascript', 'java', 'typescript'] })

  " Insert:
  " call dein#add('tmsvg/pear-tree', { 'on_event': 'InsertEnter' })

  " References:
  call dein#add('simnalamburt/vim-mundo')
  " call dein#add('mbbill/undotree')

  " Interface:
  " call dein#add('vim-airline/vim-airline')
  " call dein#add('vim-airline/vim-airline-themes', { 'depends': ['vim-airline/vim-airline'] })
  call dein#add('itchyny/lightline.vim')
  call dein#add('maximbaz/lightline-ale')
  call dein#add('mgee/lightline-bufferline')
  call dein#add('ryanoasis/vim-devicons')

  " Debugger:
  call dein#add('sakhnik/nvim-gdb')

  " Operator:
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-operator-replace', { 'on_map': '<Plug>', 'depends': 'vim-operator-user' })
  call dein#add('rhysd/vim-operator-surround', { 'on_map': '<Plug>', 'depends': 'vim-operator-user' })
  call dein#add('kana/vim-niceblock')

  " Utility:
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#local(s:gopath.'/src/',  { 'frozen': 1, 'merged': 0 }, ['github.com/utahta/trans.nvim'])
  call dein#add('cocopon/colorswatch.vim', { 'on_cmd': ['ColorSwatchGenerate'] })
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('haya14busa/dein-command.vim', { 'on_cmd': ['Dein'] })
  call dein#add('haya14busa/vim-asterisk', { 'on_map': ['<Plug>'] })
  call dein#add('itchyny/vim-parenmatch')
  call dein#add('junegunn/vim-easy-align', {'on_map': '<Plug>'})
  call dein#add('mattn/benchvimrc-vim', { 'on_cmd': ['BenchVimrc'] })
  call dein#add('mattn/sonictemplate-vim', { 'on_cmd': ['Template'] })
  call dein#add('rhysd/accelerated-jk', { 'on_map': ['<Plug>'] })
  call dein#add('thinca/vim-quickrun', { 'on_cmd': ['Capture'] })
  call dein#add('tyru/caw.vim', { 'on_map': ['<Plug>'] })
  call dein#add('tyru/open-browser.vim')
  call dein#add('tyru/open-browser-github.vim', { 'on_cmd': ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq'], 'depends': 'open-browser.vim' })
  call dein#add('tweekmonster/helpful.vim', { 'on_cmd': ['HelpfulVersion'] })
  call dein#add('tweekmonster/startuptime.vim', { 'on_cmd': ['StartupTime'] })
  " call dein#add('sheerun/vim-polyglot')
  " call dein#add('wellle/targets.vim')

  " Lifelog:
  call dein#add('wakatime/vim-wakatime')

  " -----------------------------------------------------------------------------
  " Language Plugin:

  "" Go:
  " call dein#add('fatih/vim-go', { 'on_ft': ['go'], 'lazy': 1 })
  " call dein#local(s:srcpath, { 'frozen': 1, 'merged': 0, 'on_ft': ['go', 'asm', 'gomod'] }, ['github.com/fatih/vim-go'])
  " call dein#local(s:srcpath, { 'on_ft': ['go', 'asm', 'gomod'], 'augroup': 'VimEnter', 'frozen': 1, 'merged': 1 }, ['github.com/zchee/vim-go'])
  call dein#add('tweekmonster/hl-goimport.vim', { 'on_ft': ['go'] })
  call dein#add('zchee/vim-go-slide')
  call dein#add('rhysd/vim-goyacc')
  " call dein#local(s:gopath.'/src/',  { 'frozen': 1, 'merged': 0, 'on_ft': ['go'] }, ['github.com/garyburd/vigor'])

  "" C Family:
  call dein#add('vim-jp/vim-cpp')
  call dein#add('octol/vim-cpp-enhanced-highlight', { 'lazy': 1 })
  call dein#add('bfrg/vim-cpp-modern')
  "" Swift:
  call dein#add('keith/swift.vim')
  "" CMake:
  call dein#add('pboettch/vim-cmake-syntax')
  "" LLVM TableGen:
  call dein#local(s:srcpath, { 'on_ft': ['llvm'], 'frozen': 1, 'merged': 0, 'rtp': 'utils/vim' }, ['llvm.org/llvm'])

  "" Python:
  call dein#add('davidhalter/jedi-vim', {'lazy': 1, 'on_ft': ['python', 'cython', 'pyrex'] })
  " call dein#add('python-mode/python-mode')
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#local(s:srcpath, { 'on_ft': ['python', 'cython', 'pyrex'], 'frozen': 1, 'merged': 0 }, ['github.com/tweekmonster/impsort.vim'])

  "" Rust:
  call dein#add('rust-lang/rust.vim', { 'on_ft': ['rust'] })

  "" Docker:
  call dein#add('ekalinin/Dockerfile.vim')

  "" Kubernetes:
  call dein#add('andrewstuart/vim-kubernetes')

  "" Lua:

  "" Serializer:
  call dein#add('uarun/vim-protobuf')

  "" Bazel:
  call dein#add('google/vim-maktaba', { 'on_source': ['vim-bazel'] })
  call dein#add('bazelbuild/vim-bazel', { 'on_ft': ['bazel'] })

  "" Assembly:
  call dein#add('Shirk/vim-gas')

  "" TypeScript:
  call dein#add('HerringtonDarkholme/yats.vim')

  "" Binary:
  call dein#add('Shougo/vinarise.vim', { 'on_cmd': ['Vinarise', 'VinarisePluginDump'] })

  "" Markdown:
  call dein#add('moorereason/vim-markdownfmt')
  call dein#add('iamcco/markdown-preview.nvim')

  "" Vim:
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('vim-jp/syntax-vim-ex')
  call dein#add('google/vim-searchindex')

  "" Shell:
  call dein#add('chrisbra/vim-sh-indent')

  "" Yaml:
  call dein#add('stephpy/vim-yaml')
  call dein#add('mrk21/yaml-vim')

  "" Toml:
  call dein#add('cespare/vim-toml')

  "" Json JsonC:
  call dein#add('elzr/vim-json')

  "" JsonSchema:
  call dein#add('Quramy/vison')

  "" GraphQL:
  call dein#add('jparise/vim-graphql')

  "" Tmux:
  call dein#add('tmux-plugins/vim-tmux')

  "" TerraFrom:
  call dein#add('hashivim/vim-terraform')

  "" Protobuf:
  call dein#add('uarun/vim-protobuf')
  call dein#add('uber/prototool', {'rtp': 'vim/prototool'} )

  "" TinyScheme:  for macOS sandbox-exec profile *.sb tinyscheme filetype
  call dein#add('vim-scripts/vim-niji', { 'on_ft': ['scheme'] })

  "" PlantUML:
  call dein#add('aklt/plantuml-syntax')
  call dein#add('scrooloose/vim-slumlord')

  " Testing Plugin:
  " call dein#add('rhysd/vim-gfm-syntax', { 'on_ft': ['markdown'] })
  call dein#add('juliosueiras/vim-terraform-completion')
  " call dein#add('cocopon/pgmnt.vim', { 'on_cmd': ['PgmntDevInspect'] })

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

if !exists('g:syntax_on')
  silent! syntax enable
endif
colorscheme hybrid

" -------------------------------------------------------------------------------------------------
" Color:

"" Global:
highlight! TermCursor    gui=none      guifg=#222222    guibg=#ffffff
highlight! TermCursorNC  gui=reverse   guifg=#222222    guibg=#ffffff

"" Go:
" vim-go-stdlib:
let g:go_highlight_error = 1
let g:go_highlight_return = 0
" #cc6666
highlight! goStdlibErr        gui=Bold    guifg=#ff005f    guibg=None
highlight! goString           gui=None    guifg=#92999f    guibg=None
highlight! goComment          gui=None    guifg=#838c93    guibg=None
highlight! goField            gui=Bold    guifg=#a1cbc5    guibg=None
highlight! link               goStdlib          Statement
highlight! link               goStdlibReturn    PreProc
highlight! link               goImportedPkg     Statement
highlight! link               goFormatSpecifier PreProc

"" Python:
highlight! pythonSpaceError   gui=None    guifg=#787f86    guibg=#787f86
highlight! link pythonDelimiter    Special
highlight! link pythonNone    pythonFunction
highlight! link pythonSelf    pythonOperator
syn keyword pythonDecorator True False

"" C:
let g:c_ansi_constants = 1
let g:c_ansi_typedefs = 1
let g:c_comment_strings = 1
let g:c_gnu = 0
let g:c_no_curly_error = 1
let g:c_no_tab_space_error = 1
let g:c_no_trail_space_error = 1
let g:c_syntax_for_h = 0
highlight! cCustomFunc  gui=Bold    guifg=#f0c674    guibg=None
highlight! cErr         gui=Bold    guifg=#ff005f    guibg=None

" CPP:
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

highlight! doxygenBrief                gui=None guifg=#81a2be guibg=None
highlight! doxygenSpecialMultilineDesc gui=None guifg=#81a2be guibg=None
highlight! doxygenSpecialOnelineDesc   gui=None guifg=#81a2be guibg=None

"" Vim:
Gautocmdft qf hi Search     gui=None    guifg=None  guibg=#373b41

""" Denite:
" guibg=#343941
highlight! DeniteMatchedChar guifg=#85678f
highlight! DeniteMatchedRange guifg=#f0c674
highlight! DenitePreviewLine guifg=#85678f
highlight! DeniteUnderlined guifg=#85678f

"" ParenMatch:
highlight! ParenMatch    gui=underline guifg=none guibg=#343941

" -------------------------------------------------------------------------------------------------
" Initialize Syntax:

" silent! syntax   sync fromstart
" silent! syntax   sync minlines=10000
" silent! filetype on                " try to detect the filetype
" silent! filetype plugin indent on  " enable loading the plugin file and indent file for specific file types

" -------------------------------------------------------------------------------------------------
" Gautocmd:

" Global:
Gautocmd InsertEnter * setlocal timeoutlen=0
Gautocmd InsertLeave * setlocal timeoutlen=1000 nopaste

" always jump to the last known cursor position
"  https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
function! s:autoJump()
  if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' && &filetype != 'gitrebase'
    execute "silent! keepjumps normal! g`\"zz"
  endif
endfunction
Gautocmd BufWinEnter * call s:autoJump()

"" automatically close window
"  http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
function! s:autoClose()
  let s:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if winnr('$') == 1 && s:ft == "qf" || s:ft == 'vaffle' || s:ft == 'nerdtree'
    quit!
  endif
endfunction
Gautocmd WinEnter * call s:autoClose()

" macOS Frameworks and system header protection
Gautocmd BufNewFile,BufReadPost
      \ /System/Library/*,/Applications/Xcode*,/usr/include*,/usr/lib*
      \ setlocal readonly nomodified

Gautocmdft godoc://*,godoc,help,man,qf,quickrun,ref call LessMap()  " less like keymappnig
Gautocmd BufEnter option-window,__LanguageClient__ call LessMap()  " :option have not filetype

"" Terminel:
function! s:nvim_terminal_config()
  if exists('g:loaded_nvim_terminal_config')
    silent! finish
  endif
  let g:loaded_nvim_terminal_config = 1

  let g:terminal_scrollback_buffer_size = 100000
  let s:num = 0
  "        black      red        green      yellow     blue       magenta    cyan       white
  for s:color in [
        \ '#101112', '#b24e4e', '#9da45a', '#f0c674', '#5f819d', '#85678f', '#5e8d87', '#707880',
        \ '#373b41', '#cc6666', '#a0a85c', '#f0c674', '#81a2be', '#b294bb', '#8abeb7', '#c5c8c6',
        \ ]
    let g:terminal_color_{s:num} = s:color
    let s:num += 1
  endfor
endfunction
Gautocmd TermOpen * call s:nvim_terminal_config()
Gautocmd TermOpen * setlocal nonumber sidescrolloff=0 scrolloff=0 statusline=%{b:term_title} notimeout ttimeout timeoutlen=100
Gautocmd BufNewFile,BufRead,BufEnter term://* startinsert
Gautocmd BufLeave term://* stopinsert

" Language:
"" Go:
" Gautocmd BufRead,BufNewFile *.tmpl set filetype=gohtmltmpl
Gautocmdft go let g:LanguageClient_diagnosticsEnable = 0

"" Protobuf:
" Gautocmdft proto let g:prototool_format_enable = 1 | let g:prototool_format_fix_flag = '' | let g:prototool_create_enable = 0

"" Dockerfile:
Gautocmdft dockerfile let g:LanguageClient_diagnosticsEnable = 0

" Python:
Gautocmdft python call deoplete#custom#source('LanguageClient', 'sorter', ['sorter_word'])

" Vim:
"" nested autoload
" Gautocmd BufWritePost $MYVIMRC nested silent! source $MYVIMRC
Gautocmdft vim setlocal  tags+=$XDG_DATA_HOME/nvim/tags/runtime.tags
Gautocmdft qf hi Search  gui=None  guifg=None  guibg=#373b41

"" Gitcommit:
Gautocmd BufEnter COMMIT_EDITMSG  startinsert

"" Yaml:

"" Misc:
Gautocmdft jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000

" Plugins:
"" Neosnippet:
Gautocmdft neosnippet call dein#source('neosnippet.vim')
if dein#source('neosnippet')
  Gautocmd InsertLeave * NeoSnippetClearMarkers
endif

"" Gina:
Gautocmd BufEnter gina://*:commit startinsert
Gautocmd BufEnter gina://* nnoremap <silent><buffer>q :q<CR>

"" Man:
Gautocmdft man://* nmap  <buffer><nowait>j  <Plug>(accelerated_jk_gj_position)
Gautocmdft man://* nmap  <buffer><nowait>k  <Plug>(accelerated_jk_gk_position)

" -------------------------------------------------------------------------------------------------
" Language Settings:

" Go:
"" Nvim Go:
let g:go#build#appengine = v:false
let g:go#build#autosave = v:true
let g:go#build#is_not_gb = v:false
" let g:go#build#flags = ['-race']
let g:go#build#force = v:false
let g:go#fmt#autosave  = v:true
let g:go#fmt#mode = 'goimports'
let g:go#fmt#goimports_local = ['github.com/zchee/nvim-go', 'github.com/kouzoh/jarvis']
let g:go#guru#keep_cursor = {
      \ 'callees'    : v:false,
      \ 'callers'    : v:false,
      \ 'callstack'  : v:false,
      \ 'definition' : v:true,
      \ 'describe'   : v:false,
      \ 'freevars'   : v:false,
      \ 'implements' : v:false,
      \ 'peers'      : v:false,
      \ 'pointsto'   : v:false,
      \ 'referrers'  : v:false,
      \ 'whicherrs'  : v:false
      \ }
let g:go#generate#test#subtest = v:true
let g:go#guru#reflection = v:false
let g:go#highlight#cgo = v:true
let g:go#iferr#autosave = v:false
let g:go#lint#golint#autosave = v:false
let g:go#lint#golint#ignore = ['internal', 'vendor', 'pb', 'fbs']
let g:go#lint#golint#mode = 'root'
let g:go#lint#govet#autosave = v:false
let g:go#lint#govet#flags = ['-v', '-all']
let g:go#lint#govet#ignore = ['vendor', 'testdata', '_tmp']
let g:go#lint#metalinter#autosave = v:false
let g:go#lint#metalinter#autosave#tools = ['vet', 'golint']
let g:go#lint#metalinter#deadline = '20s'
let g:go#lint#metalinter#skip_dir = ['internal', 'vendor', 'testdata', '__*.go', '*_test.go']
let g:go#lint#metalinter#tools = ['vet', 'golint']
let g:go#rename#prefill = v:true
let g:go#snippets#loaded = v:true
let g:go#terminal#height = 120
let g:go#terminal#start_insert = v:true
let g:go#terminal#width = 120
let g:go#test#all_package = v:false
let g:go#test#autosave = v:false
let g:go#test#flags = ['-v']
let g:go#debug = v:true
let g:go#debug#pprof = v:false
""" highlight
let g:go#highlight#terminal#test = 1


"" Vim Go:
let g:go_asmfmt_autosave = 0
let g:go_auto_type_info = 0
let g:go_autodetect_gopath = 0
let g:go_def_mapping_enabled = 0
let g:go_def_mode = 'godef'
" let g:go_doc_command = 'godoc'
let g:go_doc_max_height = 30
" let g:go_doc_options = ''
let g:go_fmt_autosave = 0
let g:go_fmt_command = 'goimports'
let g:go_fmt_experimental = 1
" let g:go_loclist_height = 15
" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'gotype']
let g:go_snippet_engine = 'neosnippet'
let g:go_template_enabled = 0
let g:go_term_enabled = 1
let g:go_term_height = 30
let g:go_term_width = 30
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
"" VimCPPModern:
let g:cpp_simple_highlight = 1  " Put all standard C and C++ keywords under Vim's highlight group `Statement` (affects both C and C++ files)
let g:cpp_named_requirements_highlight = 1  " Enable highlighting of named requirements (C++20 library concepts)
"" Rtags:
let g:rtagsJumpStackMaxSize = 1000
let g:rtagsMaxSearchResultWindowHeight = 15
let g:rtagsMinCharsForCommandCompletion = 100
let g:rtagsUseDefaultMappings = 0
let g:rtagsUseLocationList = 1


" Asm:
let g:nasm_loose_syntax = 1
let g:nasm_ctx_outside_macro = 1


" Rust:
let g:rust_bang_comment_leader = 1
let g:rust_clip_command = 'pbcopy'
let g:rust_conceal = 0
let g:rust_conceal_mod_path = 0
let g:rust_conceal_pub = 0
let g:rust_fold = 1
let g:rust_playpen_url = 'https://play.rust-lang.org/'
let g:rust_recommended_style = 0
let g:rust_shortener_url = 'https://is.gd/'
let g:rustc_makeprg_no_percent = 1
let g:rustc_path = '/usr/local/rust/cargo/bin/rustc'
let g:rustfmt_autosave = 0
let g:rustfmt_autosave = 1
let g:rustfmt_command = '/usr/local/rust/cargo/bin/rustfmt'
let g:rustfmt_command = 'rustfmt'
let g:rustfmt_fail_silently = 1


"" Terraform:
let g:terraform_commentstring = '//%s'
let g:terraform_fmt_on_save = 1

"" Yaml:


" Binary:
let g:vinarise_enable_auto_detect = 1
if isdirectory('/usr/local/opt/binutils')
  let g:vinarise_objdump_command = '/usr/local/opt/binutils/bin/gobjdump'
endif


" Markdown:
" http://mattn.kaoriya.net/software/vim/20140523124903.html
let g:markdown_fenced_languages = [
      \ 'asm',
      \ 'c',
      \ 'cpp',
      \ 'go',
      \ 'javascript',
      \ 'json',
      \ 'python',
      \ 'sh',
      \ 'toml',
      \ 'vim',
      \ 'yaml',
      \ ]
let g:slide_fenced_languages = [
      \ 'asm',
      \ 'c',
      \ 'cpp',
      \ 'go',
      \ 'javascript',
      \ 'json',
      \ 'python',
      \ 'sh',
      \ 'toml',
      \ 'vim',
      \ 'yaml',
      \ ]
"" VimMarkdownfmt:
let g:markdownfmt_command = 'markdownfmt'
let g:markdownfmt_options = ''
let g:markdownfmt_autosave = 0
let g:markdownfmt_fail_silently = 0

" -------------------------------------------------------------------------------------------------
" Plugin Setting:

"" Deoplete:
" core
let g:deoplete#enable_at_startup = 1
" 'around', 'base', 'buffer', 'dictionary', 'file', 'member', 'omni', 'tag'
let s:default_ignore_sources = ['around', 'dictionary', 'member', 'omni', 'tag']
let s:deoplete_custom_option = {
      \ 'auto_complete': v:true,
      \ 'auto_complete_delay': 0,
      \ 'auto_refresh_delay': 20,
      \ 'camel_case': v:true,
      \ 'delimiters': ['/'],
      \ 'ignore_case': v:true,
      \ 'ignore_sources': {
      \   '_': s:default_ignore_sources+['LanguageClient'],
      \   'c': s:default_ignore_sources+['buffer', 'neosnippet'],
      \   'cpp': s:default_ignore_sources+['buffer', 'neosnippet'],
      \   'dockerfile': s:default_ignore_sources,
      \   'go': s:default_ignore_sources+['buffer', 'file', 'LanguageClient', 'neosnippet'],
      \   'javascript': s:default_ignore_sources,
      \   'objc': s:default_ignore_sources+['buffer', 'neosnippet'],
      \   'python': s:default_ignore_sources,
      \   'rust': s:default_ignore_sources,
      \   'sh': s:default_ignore_sources,
      \   'swift': s:default_ignore_sources,
      \   'typescript': s:default_ignore_sources,
      \   'yaml': s:default_ignore_sources+['buffer'],
      \   'yaml.docker-compose': s:default_ignore_sources+['buffer'],
      \   'zsh': s:default_ignore_sources,
      \ },
      \ 'max_list': 1000,
      \ 'min_pattern_length': 1,
      \ 'num_processes': 0,
      \ 'on_insert_enter': v:true,
      \ 'on_text_changed_i': v:true,
      \ 'prev_completion_mode': 'filter',
      \ 'refresh_always': v:true,
      \ 'skip_multibyte': v:true,
      \ 'skip_chars': ['(', ')'],
      \ 'smart_case': v:true,
      \ }
call deoplete#custom#option(s:deoplete_custom_option)
call deoplete#custom#source('_', 'converters', ['converter_remove_paren', 'converter_auto_paren', 'converter_remove_overlap'])
" call deoplete#custom#source('_', 'matchers', ['matcher_cpsm'])  " can't build with pypy3
call deoplete#custom#source('_', 'sorters', ['sorter_rank'])
call deoplete#custom#source('buffer', 'rank', 10)
call deoplete#custom#source('go', 'rank', 1000)
call deoplete#custom#source('go', 'sorters', ['sorter_rank'])
call deoplete#custom#source('go', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('jedi', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('LanguageClient', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('LanguageClient', 'mark', '[LSP]')
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 1)
call deoplete#custom#source('LanguageClient', 'rank', 1000)
call deoplete#custom#source('neosnippet', 'rank', 0)
call deoplete#custom#source('neosnippet', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('vim', 'disabled_syntaxes', ['Comment'])
Gautocmdft yaml call deoplete#custom#source('LanguageClient', 'min_pattern_length', 0)

" source
" LLVM library path
if isdirectory("/opt/llvm/devel/lib")
  let s:llvm_library_path = '/opt/llvm/devel/lib'
  let s:llvm_clang_version = '8.0.0'
elseif isdirectory("/opt/llvm/stable/lib")
  let s:llvm_library_path = '/opt/llvm/stable/lib'
  let s:llvm_clang_version = '6.0.0'
else
  let s:llvm_library_path = '/Library/Developer/CommandLineTools/usr/lib'
  let s:llvm_clang_version = '10.0.0'
endif
"" go
let s:use_gocode_mdempsky = 0
let s:use_gocode_stamblerre = 0
let g:deoplete#sources#go#gocode_binary = 'gocode'
let g:deoplete#sources#go#gocode_sock = 'tcp'
if get(s:, 'use_gocode_mdempsky', 0)
  let g:deoplete#sources#go#gocode_binary = s:gopath.'/bin/gocode-mdempsky'
  let g:deoplete#sources#go#builtin_objects = 1
  let g:deoplete#sources#go#cache = 1
  let g:deoplete#sources#go#fallback_to_source = 1
  let g:deoplete#sources#go#source_importer = 0
  let g:deoplete#sources#go#unimported_packages = 1
elseif get(s:, 'use_gocode_stamblerre', 0)
  let g:deoplete#sources#go#gocode_binary = s:gopath.'/bin/gocode-stamblerre'
  let g:deoplete#sources#go#builtin_objects = 1
  let g:deoplete#sources#go#cache = 1
  let g:deoplete#sources#go#fallback_to_source = 1
  let g:deoplete#sources#go#source_importer = 0
  let g:deoplete#sources#go#unimported_packages = 1
endif
let g:deoplete#sources#go#auto_goos = 0
let g:deoplete#sources#go#cgo = 0
let g:deoplete#sources#go#cgo#libclang_path = s:llvm_library_path . '/libclang.dylib'
" let g:deoplete#sources#go#cgo#sort_algo = 'priority'  " 'alphabetical'
let g:deoplete#sources#go#pointer = 0
" let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
"" clang
let g:deoplete#sources#clang#clang_header = s:llvm_library_path . '/clang'
let g:deoplete#sources#clang#libclang_path = s:llvm_library_path . '/libclang.dylib'
let g:deoplete#sources#clang#flags = [
      \ '-I' . $HOME . '/.local/include',
      \ '-I/usr/local/include',
      \ '-I' . s:llvm_library_path . '/clang/' . s:llvm_clang_version . '/include',
      \ '-I/usr/include',
      \ '-F/System/Library/Frameworks',
      \ '-F/Library/Frameworks',
      \ '-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk',
      \ ]  " clang++ -v -E -x c - -v < /dev/null
"" jedi
let g:deoplete#sources#jedi#statement_length = 0
let g:deoplete#sources#jedi#short_types = 0
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#enable_typeinfo = 1
let g:deoplete#sources#jedi#ignore_errors = 1
let g:deoplete#sources#jedi#extra_path = []
let g:deoplete#sources#jedi#python_path = g:python3_host_prog
" let g:deoplete#sources#jedi#worker_threads = 2
let g:deoplete#sources#jedi#python_path = g:python3_host_prog
let g:deoplete#sources#asm#go_mode = 1
" neopairs
let g:neopairs#enable = 1
" echodoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#highlight_identifier = "Identifier"
let g:echodoc#highlight_arguments = "Special"
let g:echodoc#highlight_trailing = "Type"
let g:echodoc#type = 'virtual'
" neosnippet
let g:neosnippet#data_directory = $XDG_CACHE_HOME . '/nvim/neosnippet'
let g:neosnippet#disable_runtime_snippets = {}
let g:neosnippet#disable_select_mode_mappings = 0
let g:neosnippet#enable_auto_clear_markers = 1
let g:neosnippet#enable_complete_done = 0
let g:neosnippet#enable_completed_snippet = 0
let g:neosnippet#expand_word_boundary = 1
let g:neosnippet#snippets_directory = $XDG_CONFIG_HOME . '/nvim/neosnippets'
let g:neosnippet_username = 'zchee'
let g:neosnippet_author = 'Koichi Shiraishi'
" debug
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', $DEOPLETE_LOG_FILE)
" call deoplete#custom#source('go', 'is_debug_enabled', 1)
" call deoplete#enable()


"" LanguageClient:
let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_completionPreferTextEdit = 0  " should be 0
let g:LanguageClient_diagnosticsList = 'Quickfix'  " default: Quickfix, Location, Disabled
let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_hoverPreview = 'Auto'  " Always, Auto, Never
let g:LanguageClient_selectionUI = 'quickfix'  " fzf, quickfix, location-list
let g:LanguageClient_windowLogMessageLevel = "Warning"  " Error, default: Warning, Info, Log
let s:LanguageClient_serverCommands_c = [
      \ 'clangd',
      \ '-all-scopes-completion',
      \ '-background-index',
      \ '-clang-tidy',
      \ '-compile-commands-dir=' . trim(finddir('.git', '.;'), '.git') . 'build',
      \ '-compile_args_from=filesystem',
      \ '-completion-style=detailed',
      \ '-function-arg-placeholders',
      \ '-header-insertion-decorators',
      \ '-include-ineligible-results',
      \ '-index',
      \ '-index-file=clangd.dex',
      \ '-input-style=standard',
      \ '-j=12',
      \ '-pch-storage=disk',
      \ '-resource-dir=' . s:llvm_library_path . '/clang/' . s:llvm_clang_version . '/include',
      \ '-static-func-full-module-prefix',
      \ '-use-dbg-addr',
      \ '-use-dex-index',
      \ '-view-background',
      \ ]
let s:node_exec = ['node', '--experimental-modules', '--experimental-vm-modules', '--no-warnings']
let g:LanguageClient_serverCommands = {
      \ 'c': s:LanguageClient_serverCommands_c,
      \ 'cpp': s:LanguageClient_serverCommands_c,
      \ 'dockerfile': s:node_exec + [s:srcpath . '/github.com/rcjsuen/dockerfile-language-server-nodejs/bin/docker-langserver', '--stdio'],
      \ 'go': [s:gopath . '/bin/gopls'],
      \ 'javascript': s:node_exec + [$XDG_DATA_HOME . '/yarn/global/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js'],
      \ 'json': ['vscode-json-languageserver', '--stdio'],
      \ 'objc': s:LanguageClient_serverCommands_c,
      \ 'objcpp': s:LanguageClient_serverCommands_c,
      \ 'python': ['/usr/local/bin/pyls'],
      \ 'ruby': ['/usr/local/var/rbenv/shims/solargraph', 'stdio'],
      \ 'rust': ['/usr/local/rust/cargo/bin/rustup', 'run', 'beta', 'rls'],
      \ 'swift': ['/usr/local/bin/sourcekit-lsp'],
      \ 'typescript': s:node_exec + [s:srcpath . '/github.com/sourcegraph/typescript-language-server/server/lib/cli.js', '--stdio', '--tsserver-path=/usr/local/var/yarn/bin/tsserver'],
      \ 'yaml': s:node_exec + [s:srcpath . '/github.com/redhat-developer/yaml-language-server/out/server/src/server.js', '--stdio'],
      \ 'yaml.docker-compose': s:node_exec + [s:srcpath . '/github.com/redhat-developer/yaml-language-server/out/server/src/server.js', '--stdio'],
      \ }
      "\ 'go': [s:gopath . '/bin/gopls', 'serve', '-logfile', '/tmp/gopls.log'],
      "\ 'sh': ['/usr/local/var/yarn/bin/bash-language-server', 'start'],
      "\ 'zsh': ['/usr/local/var/yarn/bin/bash-language-server', 'start'],
let s:LanguageClient_rootMarkers_c = ['autogen.sh', 'configure', 'WORKSPACE']
let g:LanguageClient_rootMarkers = {
      \ 'c': s:LanguageClient_rootMarkers_c,
      \ 'cpp': s:LanguageClient_rootMarkers_c,
      \ 'go': ['go.mod', 'Gopkg.toml', 'Makefile'],
      \ 'objc': s:LanguageClient_rootMarkers_c,
      \ 'python': ['setup.py', 'LICENSE'],
      \ }
let g:LanguageClient_loadSettings = 1
" let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
" let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
" let g:LanguageClient_loggingLevel = 'DEBUG'  " default: WARN

function! s:languageclient_setup()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    setlocal formatexpr=LanguageClient#textDocument_rangeFormatting()
    nnoremap <silent><buffer><C-]>            :<C-u>call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent><buffer><Leader>e        :<C-u>call LanguageClient#textDocument_rename()<CR>
    nnoremap <silent><buffer>K                :<C-u>call LanguageClient#textDocument_hover()<CR>
  endif
endfunction

function! s:lsp_set_schema(args)
  if &filetype !=? "yaml"
    return
  endif

  let l:filepath = expand('%:p')
  let l:filename = fnamemodify(l:filepath, ':t')
  let l:schema = 'default'
  let l:config_file = ''
  let l:config = ''

  if len(a:args)
    let l:schema = a:args
    let l:config_file = expand($XDG_CONFIG_HOME . '/nvim/lsp/yaml/' . l:schema . '.json')
    let l:config = json_decode(readfile(l:config_file))
    call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': l:config })
    return
  endif

  if l:filepath =~# '**/kubernetes/.*/*.yaml' || l:filename =~# 'kubectl-edit-.*.yaml'
    let l:schema = 'kubernetes'
  elseif l:filepath =~# '**/openapi.*/.*/*.yaml'
    let l:schema = 'openapi'
  elseif l:filename =~# '\v\.?cloudbuild\.yaml$'
    let l:schema = 'cloudbuild'
  elseif l:filepath =~# '**/.circleci/config.yml'
    let l:schema = 'circleci'
  elseif l:filename =~# '\v\.?codecov\.yml$'
    let l:schema = 'codecov'
  elseif l:filename =~# '\vhelmfile\.yaml$'
    let l:schema = 'helmfile'
  elseif l:filename =~# '\v\.?appveyor\.yml$'
    let l:schema = 'appveyor'
  elseif l:filename =~# '\vswagger.*\.ya?ml$'
    let l:schema = 'swagger-2.0'
  elseif l:filename =~# '\vdocker-compose.*\.ya?ml'
    let l:schema = 'docker-compose'
  elseif l:filename ==# '.travis.yml'
    let l:schema = 'travis'
  endif

  let l:config_file = expand($XDG_CONFIG_HOME . '/nvim/lsp/yaml/' . l:schema . '.json')
  let l:config = json_decode(readfile(l:config_file))

  echom 'yaml-language-server: schema: ' . l:schema
  echom 'yaml-language-server: config_file: ' . l:config_file

  call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': l:config })
endfunction
command! -nargs=* LSPYamlSetSchema call <SID>lsp_set_schema(<q-args>)

if dein#tap('LanguageClient-neovim')
  Gautocmdft c,cpp,dockerfile,go,javascript,json,objc,python,ruby,rust,sh,swift,typescript,yaml,yaml.docker-compose,zsh call <SID>languageclient_setup()
  Gautocmd User LanguageClientTextDocumentDidOpenPost call <SID>lsp_set_schema('')  " LanguageClientStart, dLanguageClientStopped, LanguageClientDiagnosticsChanged, LanguageClientTextDocumentDidOpenPost
  " Gautocmd User LanguageClientTextDocumentDidOpenPost let g:LanguageClient_settingsPath = findfile('.lsp.json', '.;')
endif


"" Denite:
if dein#is_sourced('denite.nvim')
  call denite#custom#option('_', {
        \ 'auto-highlight': v:true,
        \ 'auto_accel': v:false,
        \ 'empty': v:false,
        \ 'highlight-matched-char': 'DeniteMatchedChar',
        \ 'highlight-matched-range': 'DeniteMatchedRange',
        \ 'highlight-preview-line': 'DenitePreviewLine',
        \ 'mode': 'insert',
        \ 'prompt': '>',
        \ 'short_source_names': v:true,
        \ 'sorter': 'sorter/word',
        \ 'unique': v:true,
        \ 'winheight': 30,
        \ })
  " call denite#custom#source('_', 'matchers', ['matcher/cpsm'])
  let s:denite_file_rec_fd_command = ['fd', '--type=f', '--follow', '--hidden', '--full-path', '--color=never', '--exclude=.git', '']
  call denite#custom#var('file_rec/fd', 'command', s:denite_file_rec_fd_command)
  call denite#custom#var('grep/rg', 'command', ['rg'])
  call denite#custom#var('grep/rg', 'default_opts', ['--mmap', '--threads=12', '--hidden', '--smart-case', '--vimgrep', '--no-ignore-vcs', '--no-heading', '--glob=!.git', '--glob=!node_modules'])
  call denite#custom#var('grep/rg', 'recursive_opts', [])
  call denite#custom#var('grep/rg', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep/rg', 'separator', ['--'])
  call denite#custom#var('grep/rg', 'final_opts', [])
  call denite#custom#var('line/rg', 'command', ['rg', '--files', '--glob', '!.git', ''])

  "" map
  call denite#custom#map('insert', '<CR>', '<denite:do_action:default>', 'noremap')
  call denite#custom#map('insert', '<C-v>', '<denite:multiple_mappings:denite:do_action:vsplit>', 'noremap')
  call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')

  "" alias
  call denite#custom#alias('source', 'file_rec/fd', 'file_rec')
  call denite#custom#alias('source', 'grep/rg', 'grep')
  call denite#custom#alias('source', 'line/rg', 'line')

  "" filter
  call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
        \ [ '.git/', '.ropeproject/', '__pycache__/',
        \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
endif

"" Gina:
call gina#custom#command#option('diff', '--opener', 'vsplit')
call gina#custom#command#option('commit', '-S')
call gina#custom#execute(
      \ '/\%(commit\)',
      \ 'setlocal colorcolumn=69 expandtab shiftwidth=2 softtabstop=2 tabstop=2 winheight=40',
      \)
call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)
call gina#custom#mapping#nmap(
      \ '/\%(commit\|status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'q', ':<C-u> q<CR>', {'noremap': 1, 'silent': 1},
      \)


" Ale:
let g:ale_cache_executable_check_failures = 1
let g:ale_change_sign_column_color = 0
let g:ale_completion_enabled = 0
let g:ale_cursor_detail = 1
let g:ale_echo_cursor = 1
let g:ale_echo_delay = 20
let g:ale_fix_on_save = 1
let g:ale_keep_list_window_open = 0
let g:ale_lint_delay = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_list_window_size = 10
let g:ale_open_list = 0
let g:ale_set_highlights = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_sign_column_always = 1
let g:ale_use_global_executables = 1
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_delay = 20
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_warn_about_trailing_whitespace = 1
"" linters
let g:ale_linters = {}
let g:ale_linters.dockerfile = ['hadolint']
let g:ale_linters.go = []  " let g:ale_linters.go = ['gofmt', 'go vet', 'golint', 'goimports', 'golangci-lint']
let g:ale_linters.markdown = ['textlint']
let g:ale_linters.proto = ['protoc-gen-lint']  " ['prototool', 'protoc-gen-lint']
let g:ale_linters.python = ['flake8', 'mypy', 'pylint', 'pyls']
let g:ale_linters.rust = ['cargo']
let g:ale_linters.sh = ['shellcheck', 'shfmt', 'sh-language-server', 'shell']
let g:ale_linters.terraform = ['fmt', 'tflint']
let g:ale_linters.yaml = ['yamllint']
let g:ale_linters.zsh = ['shell']  " ['shellcheck', 'shfmt', 'shell']
"" fixers
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'markdown': [],
      \ }
"" Go:
let g:ale_go_gofmt_options = '-s'
let g:ale_go_govet_options = '-all'
"" Sh:
let g:ale_sh_shell_default_shell = 'bash'
let g:ale_sh_shellcheck_options = '-x'
let g:ale_sh_shellcheck_exclusions = 'SC1072 SC1090'
let g:ale_sh_shfmt_options = '-s -ln bash'
"" Python:
let g:ale_yaml_yamllint_options = '--config-file=' . fnamemodify(findfile('.yamllint', '.;'), ':p')
"" Terraform:
let g:ale_terraform_fmt_executable = 'terraform'
let g:ale_terraform_fmt_options = ''
let g:ale_terraform_tflint_executable = s:gopath.'bin/tflint'
let g:ale_terraform_tflint_options = '-f json'
"" Dockerfile:
let g:ale_dockerfile_hadolint_use_docker = 'yes'
let g:ale_dockerfile_hadolint_image = 'gcr.io/container-image/cloud-builders/hadolint:1.16.0'


" Prototool:


" Caw:
let g:caw_hatpos_skip_blank_line = 0
let g:caw_no_default_keymappings = 1
let g:caw_operator_keymappings = 0


" LightLine:
" https://donniewest.com/a-guide-to-basic-neovim-plugins
let g:lightline = {}
let g:lightline.colorscheme = 'hybrid'
function! DeviconsGetFileTypeSymbol()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! DeviconsGetFileFormatSymbol()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction
" function! LightlineModified()
"   let map = { 'V': 'n', "\<C-v>": 'n', 's': 'n', 'v': 'n', "\<C-s>": 'n', 'c': 'n', 'R': 'n'}
"   let mode = get(map, mode()[0], mode()[0])
"   let bgcolor = {'n': [240, '#B5BD68'], 'i': [31, '#82AAFF']}
"   let color = get(bgcolor, mode, bgcolor.n)
"   exe printf('hi ModifiedColor ctermfg=196 ctermbg=%d guifg=#282a2e guibg=%s gui=bold term=bold cterm=bold', color[0], color[1])
"   return &modified ? '+' : &modifiable ? '' : '-'
" endfunction
function! LightlineModified()
  hi ModifiedColor ctermfg=167 guifg=#cf6a4c ctermbg=242 guibg=#666656 term=bold cterm=bold
  return &modified ? '+' : &modifiable ? '' : '-'
endfunction
let g:lightline.component = {
      \ 'absolutepath': '%F',
      \ 'bufnum': '%n',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'close': '%999X X ',
      \ 'column': '%c',
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'filename': '%{expand(''%:p'')}',
      \ 'line': '%l',
      \ 'lineinfo': '%3l  %-2v',
      \ 'mode': '%{lightline#mode()}',
      \ 'modified': '%( %#ModifiedColor#%{LightlineModified()} %)',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'percent': '%3p%%',
      \ 'percentwin': '%P',
      \ 'readonly': '%R',
      \ 'relativepath': '%f',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'winnr': '%{winnr()}',
      \ }
let g:lightline.component_expand = {
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_errors': 'lightline#ale#errors',
      \ 'linter_ok': 'lightline#ale#ok',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ }
let g:lightline.component_type = {
      \ 'modified': 'raw',
      \ 'linter_checking': 'left',
      \ 'linter_errors': 'error',
      \ 'linter_ok': 'left',
      \ 'linter_warnings': 'warning',
      \ }
let g:lightline.component_function = {
      \ 'fileformat': 'DeviconsGetFileFormatSymbol',
      \ 'filetype': 'DeviconsGetFileTypeSymbol',
      \ 'gitbranch': 'gina#component#repo#branch',
      \ }
let g:lightline.active = {
      \ 'left': [ ['mode', 'paste'], ['filename', 'gitbranch'] ],
      \ 'right': [ [ 'lineinfo', 'percent' ], [ 'filetype', 'fileformat', 'fileencoding' ], [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ]
      \ }
let g:lightline.inactive = {
      \ 'left': [ [ 'filename' ] ],
      \ 'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \ }
let g:lightline.tabline = {
      \ 'left': [ [ 'tabs' ] ],
      \ 'right': [ [ 'close' ] ]
      \ }
let g:lightline.tab = {
      \ 'active': [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }
let g:lightline.enable = { 'statusline': 1, 'tabline': 1 }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': ' ', 'right': ' ' }
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#enable_devicons = 1

function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction
Gautocmd User ALELint call s:MaybeUpdateLightline()


" GitGutter:
let g:gitgutter_async = 1
let g:gitgutter_eager = 0
let g:gitgutter_enabled = 1
let g:gItgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 100000
let g:gitgutter_diff_args = '--ignore-all-space'


" Accelerated JK:
let g:accelerated_jk_enable_deceleration = 0
let g:accelerated_jk_acceleration_limit = 150 " 250
let g:accelerated_jk_acceleration_table = [7,12,17,21,24,26,28,30]


" VimAutoPep8:
let g:autopep8_aggressive = 2
let g:autopep8_disable_show_diff = 1
let g:autopep8_max_line_length = 99


" ParenMatch:
let g:cursorword = 0


" Wakatime:
let g:wakatime_PythonBinary = '/usr/local/opt/python3/bin/python3'


" SonicTemplate:
let g:sonictemplate_vim_template_dir = [expand($XDG_CONFIG_HOME.'/nvim/template')]


" Vaffle:
let g:vaffle_auto_cd = 1
let g:vaffle_force_delete = 1
let g:vaffle_show_hidden_files = 1
let g:vaffle_use_default_mappings = 1


" Editorconfig:
let g:EditorConfig_core_mode = 'python_external'


" Trans:
let g:trans_lang_credentials_file = $XDG_CONFIG_HOME.'/gcloud/credentials/kouzoh-p-zchee/trans-nvim.json'
" let g:trans_lang_cutset = ['//', '#']
let g:trans_lang_locale = 'ja'


" OpenBrowser:
let g:openbrowser_search_engines = {
      \ 'google': 'http://google.com/search?q={query}&tbs=qdr:y',
      \}
let g:openbrowser_message_verbosity = 0

" EasyAlign:
let g:easy_align_ignore_groups = []

" NERDTree:
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeDirArrowCollapsible = '▼'
let g:NERDTreeDirArrowExpandable  = '▶'
let g:NERDTreeDirArrows = 1
let g:NERDTreeHijackNetrw = 0
let g:NERDTreeMinimalUI = 1
let g:NERDTreeMouseMode = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeSortHiddenFirst = 1
" mapping

" -------------------------------------------------------------------------------------------------
" Previous use plugins

" Airline:
" let g:airline#extensions#ale#enabled = 1
" let g:airline#extensions#ale#error_symbol = 'E:'
" let g:airline#extensions#ale#warning_symbol = 'W:'
" let g:airline#extensions#ale#show_line_numbers = 1
" let g:airline#extensions#ale#open_lnum_symbol = '(L'
" let g:airline#extensions#ale#close_lnum_symbol = ')'
" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#branch#custom_head = 'gina#component#repo#branch'
" let g:airline#extensions#hunks#enabled = 0
" let g:airline#extensions#quickfix#location_text = 'Location'
" let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
" let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#buffers_label = 'b'
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#exclude_preview = 1
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#show_buffers = 0
" let g:airline#extensions#tabline#show_splits = 1
" let g:airline#extensions#tabline#show_tab_nr = 0
" let g:airline#extensions#tabline#show_tab_type = 1
" let g:airline#extensions#tabline#show_tabs = 1
" let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
" let g:airline#extensions#tabline#tab_nr_type = 2
" let g:airline#extensions#tabline#tabs_label = 't'
" let g:airline#extensions#tagbar#enabled = 0
" let g:airline#extensions#languageclient#enabled = 1
" let g:airline#extensions#whitespace#mixed_indent_algo = 2
" let g:airline#extensions#wordcount#enabled = 0
" let g:airline_exclude_filetypes = ['fzf']
" let g:airline_highlighting_cache = 1
" let g:airline_inactive_collapse = 0
" let g:airline_powerline_fonts = 1
" let g:airline_skip_empty_sections = 1
" let g:airline_theme = 'hybridline'
" if dein#is_sourced('vim-airline')
"   let g:airline_section_c = airline#section#create(['%<', 'readonly', '%{expand(''%:p'')}'])
" endif

" -------------------------------------------------------------------------------------------------
" Functions:

" Filetye Execute:
function! s:filetype_exec(...)
  let s:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if s:ft == a:1
    execute a:2
  endif
endfunction


" Help:
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

" HelpGrep:
function! s:smart_helpgrep(args)
  try
    if winwidth(0) > winheight(0) * 2
      execute 'vertical rightbelow helpgrep ' . a:args . '@en'
    else
      execute 'rightbelow helpgrep ' . a:args . '@en'
    endif
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry
  copen
endfunction
command! -nargs=* -complete=help HelpGrep call <SID>smart_helpgrep(<q-args>)


" SyntaxInfo:
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
  let s:bold  = synIDattr(a:synid, "bold", "gui")
  let s:guifg = synIDattr(a:synid, "fg", "gui")
  let s:guibg = synIDattr(a:synid, "bg", "gui")
  let s:attr = {
        \ "name": s:name,
        \ "bold": s:bold,
        \ "guifg": s:guifg,
        \ "guibg": s:guibg,
        \ }
  return s:attr
endfunction
" return syntax information
function! s:get_syn_info(cword)
  let s:baseSyn = s:get_syn_attr(s:get_syn_id(0))
  let s:baseSynInfo = "name: " . s:baseSyn.name .
        \ " bold: " . (s:baseSyn.bold == 1 ? 'true' : 'false' ) . "," .
        \ " guifg: " . s:baseSyn.guifg . "," .
        \ " guibg: " . s:baseSyn.guibg
  let s:linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  let s:linkedSynInfo =  "name: " . s:linkedSyn.name .
        \ " bold: " .  (s:linkedSyn.bold == 1 ? 'true' : 'false' ) . "," .
        \ " guifg: " . s:linkedSyn.guifg . "," .
        \ " guibg: " . s:linkedSyn.guibg
  echomsg a:cword . ':'
  echomsg s:baseSynInfo
  echomsg '  ' . "link to"
  echomsg s:linkedSynInfo
endfunction
command! SyntaxInfo call s:get_syn_info(expand('<cword>'))


" ClearMessage:
command! ClearMessage for n in range(200) | echom "" | endfor


" Binary Edit Mode:
" need open nvim with `-b` flag
function! BinaryMode() abort
  if !has('binary')
    echoerr "BinaryMode must be 'binary' option"
    return
  endif

  execute '%!xxd'
endfunction


" Less Like Mapping:
function! LessMap()
  set colorcolumn=""
  let b:gitgutter_enabled = 0
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
endfunction


" Profiling Syntax:
function! ProfileSyntax() abort
  " Initial and cleanup syntime
  redraw!
  syntime clear
  " Profiling syntax regexp
  syntime on
  redraw!
  QuickRun -type vim -src 'syntime report'
endfunction


" Open the C/C++ online document
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


" Trim Whitespace:
function! s:trimSpace()
  if !&binary && &filetype != 'diff' && &filetype != 'markdown'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction
command! TrimSpace call s:trimSpace()


" EditInit:
function! s:editTnit()
  vsplit $XDG_CONFIG_HOME/nvim/init.vim
endfunction
command! EditInit call s:editTnit()


" Lr:
" <lr-args> to browse lr(1) results in a new window, press return to open file in new window.
command! -nargs=* -complete=file Lr
      \ new | setl bt=nofile noswf | silent exe '0r!lr -Q ' <q-args> |
      \ 0 | res | map <buffer><C-M> $<C-W>F<C-W>_

" -------------------------------------------------------------------------------------------------
" Command:

" Terminal:
command! -nargs=* Terminal split | terminal <args>
command! -nargs=* TerminalV vsplit | terminal <args>

" Capture:
" http://qiita.com/sgur/items/9e243f13caa4ff294fa8
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

" Shfmt:
command! -nargs=0 -bang -complete=command Shfmt %!shfmt -i 2

" FormatJson:
if has("python3")
python3 << EOF
import vim
import json
def Format_Json(indent, sort):
    jsonStr = "\n".join(vim.current.buffer)
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=indent, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[0:] = prettyJson.split(b'\n')

def Format_Json_Select(start, end):
    start = start - 1
    jsonStr = "\n".join(vim.current.buffer[start:end])
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=True, indent=indent, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[start:end] = prettyJson.split(b'\n')

def Format_JsonSchema(indent, sort):
    jsonStr = "\n".join(vim.current.buffer)
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=indent, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[0:] = prettyJson.split(b'\n')

def Format_JsonSchema_Select(start, end):
    start = start - 1
    jsonStr = "\n".join(vim.current.buffer[start:end])
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=2, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[start:end] = prettyJson.split(b'\n')
EOF
  command! -bang -bar -complete=command -nargs=* -range=% FormatJson :python3 Format_Json(<args>)
  command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSelect :python3 Format_Json_Select(<line1>, <line2>)

  command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSchema :python3 Format_JsonSchema(<args>)
  command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSchemaSelect :python3 Format_JsonSchema_Select(<line1>, <line2>)
else
  command! -nargs=0 -bang -complete=command FormatJson %!python3 -m json.tool
endif

" ProfileSyntax:
command! -nargs=0 -bang -complete=command ProfileSyntax call ProfileSyntax()

" -------------------------------------------------------------------------------------------------
" Keymap:
"
" For Kinesis Advantage With Programmer Dvorak.
" Global & Local MapLeader are arranged in the center of the keyboard.
"
"   - Global MapLeader: <Space> " Righthand
"   - Local MapLeader : <BS>    " Lefthand
"   - Local prefix    : ,       " Lefthand
"
" TODO(zchee):
"   Swaps semicolon and colon to ideal at Kinesis hardware level. Now use direct edited macOS key dictionary
"   Use Kinesis Advantage2 instead of.
"
" Vim remappable keys
"   - <Space>
"   - ,       : Reverse repeat for f, t, F, T
"   - s       : replace to cl
"   - t       : Never use it in normal mode, f -> ... -> h instead of
"   - m       : For sets marker, never use it also
"
"   - http://deris.hatenablog.jp/entry/2013/05/02/192415
"
" -------------------------------------------------------------------------------------------------
" Map Leader:

" nmap <Nop> for g:mapleader and g:maplocalleader keys
nnoremap <nowait><Space> <Nop>
nnoremap <nowait><BS>    <Nop>
if !exists('g:mapleader')
  let g:mapleader = "\<Space>"
endif
if !exists('g:maplocalleader')
  let g:maplocalleader = "\<BS>"
endif

"" <Leader>
nnoremap              <Leader>ga        :<C-u>Gina add %<CR>
nnoremap              <Leader>gc        :<C-u>Gina commit<CR>
nnoremap              <Leader>gp        :<C-u>Gina push<CR>
nnoremap              <Leader>gs        :<C-u>Gina status<CR>

"" <LocalLeader>
nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep/rg -buffer-name='grep/rg'<CR>
nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer'<CR>
nnoremap <silent><LocalLeader>g         :<C-u>Denite line/rg -buffer-name='line/rg'<CR>
nnoremap <silent><LocalLeader>q         :<C-u>q<CR>
nnoremap <silent><LocalLeader>w         :<C-u>w<CR>
nnoremap <silent><LocalLeader><Space>   :<C-u>NERDTreeToggle<CR>

"" ,
nnoremap              <silent>,m        <C-w>W
nnoremap              <silent>,n        <C-w>w
nnoremap              <silent>,p        <C-w>W
nnoremap              <silent>,r        <C-w>x
nnoremap              <silent>,s        :<C-u>bNext<CR>
nnoremap              <silent>,t        :<C-u>tabnew<CR>
nnoremap              <silent>,w        <C-w>w

" -------------------------------------------------------------------------------------------------
" Map: (m)

"" Operator:
map <silent>ti  <Plug>(operator-surround-append)
map <silent>td  <Plug>(operator-surround-delete)
map <silent>tr  <Plug>(operator-surround-replace)

" -------------------------------------------------------------------------------------------------
" Normal: (n)

"        *) asterisk-gz*
"        -) 'Vaffle %:p:h' or 'VimFilerExplorer -find<CR>'
"      @,^) ^,@: switch '@' and '^' for Dvorak pinky
"       ga) EasyAlign
"       gx) openbrowser-smart-search
"        j) accelerated_jk_gj_position
"        k) accelerated_jk_gk_position
"        p) Paste
"        Q) gq: do not use Ex mode. Use 'gq' is the format the lines that {motion} moves over
"        s) A: Append text at the end of the line [count] times
"        x) "_x: do not add yank register
"       zj)       zjzt
"       zk)       2zkzjzt
"       ZQ) <Nop>: disable suspend
"    <C-g>) 'DeniteProjectDir grep'
"    <C-p>) 'DeniteProjectDir file_rec'
"    <C-q>) nohlsearch: Stop the highlighting for the 'hlsearch' option
" <S-Tab>>) %: Jump to match pair brackets. *<Tab>* and *<C-i>* are similar treatment.
"              Note that needs <C-i>(<Tab>) for jump to next taglist
" <S-Down>) <Nop>
"   <S-Up>) <Nop>

nmap     <silent>*           <Plug>(asterisk-gz*)
nnoremap <silent>-           :<C-u>Vaffle %:p:h<CR>
" nnoremap <silent>-           :<C-u>NERDTreeToggle<CR>
nnoremap <nowait>@           ^
nnoremap <nowait>^           @
nmap             ga          <Plug>(LiveEasyAlign)
nmap     <silent>gx          <Plug>(openbrowser-smart-search)
nmap     <nowait>j           <Plug>(accelerated_jk_j)
nmap     <nowait>k           <Plug>(accelerated_jk_k)
nnoremap         Q           gq
nnoremap         s           A
nnoremap <nowait>x           "_x
nnoremap         zj          zjzt
nnoremap         zk          2zkzjzt
nnoremap         ZQ          <Nop>
" nnoremap <silent><C-o>       <C-o>zz
nnoremap <silent><C-g>       :<C-u>DeniteProjectDir grep/rg -buffer-name='grep/rg'<CR>
nnoremap <silent><C-p>       :<C-u>DeniteProjectDir file_rec/fd -buffer-name='file_rec/fd' -path=`getcwd()`<CR>
nnoremap <silent><C-q>       :<C-u>nohlsearch<CR>
" nnoremap <silent><C-w><C-r>  <C-w>r<C-w>x
nnoremap <nowait><Up>        <Up>
nnoremap <nowait><Down>      <Down>
nnoremap         <S-Tab>     %
nnoremap         <S-Down>    <Nop>
nnoremap         <S-Up>      <Nop>

nnoremap <C-y> <C-y><C-y><C-y><C-y>
nnoremap <C-e> <C-e><C-e><C-e><C-e>


" Language:

"" Go:
Gautocmdft go nnoremap  <silent><buffer><LocalLeader>]    :<C-u>call GoGuru('definition')<CR>
""" normal
""" <Leader>
Gautocmdft go nmap  <silent><buffer><Leader>e             <Plug>(nvim-go-rename)
""" <LocalLeader>
Gautocmdft go nmap  <silent><buffer><LocalLeader>gc       <Plug>(nvim-go-callers)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gcs      <Plug>(nvim-go-callstack)
Gautocmdft go nmap  <silent><buffer><LocalLeader>ge       <Plug>(nvim-go-callees)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gi       <Plug>(nvim-go-implements)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gr       <Plug>(nvim-go-referrers)
Gautocmdft go nmap  <silent><buffer><LocalLeader>gs       <Plug>(nvim-go-switch-test)
Gautocmdft go nmap  <silent><buffer><LocalLeader>i        <Plug>(nvim-go-iferr)
Gautocmdft go nmap  <silent><buffer><LocalLeader>l        <Plug>(nvim-go-lint)
Gautocmdft go nmap  <silent><buffer><LocalLeader>m        <Plug>(nvim-go-metalinter)
Gautocmdft go nmap  <silent><buffer><LocalLeader>r        <Plug>(nvim-go-run)
Gautocmdft go nmap  <silent><buffer><LocalLeader>t        <Plug>(nvim-go-test)
Gautocmdft go nmap  <silent><buffer><LocalLeader>v        <Plug>(nvim-go-vet)
Gautocmd BufNewFile,BufRead,BufEnter godoc://** nmap <C-]> <CR>

"" C CXX ObjC:
Gautocmdft c,cpp  nnoremap <silent><buffer><C-k>       :<C-u>call <SID>open_online_cfamily_doc()<CR>
if dein#tap('vim-clang-format')
  Gautocmdft c,cpp,objc,objcpp,proto map      <buffer><Leader>x   <Plug>(operator-clang-format)
  Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>C   :<C-u>ClangFormatAutoToggle<CR>
  Gautocmdft c,cpp,objc,objcpp,proto nnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>
endif

"" Protobuf:
" Gautocmdft proto nmap <silent><LocalLeader>f  :<C-u>call PrototoolFormat()<CR>

"" Yaml:

"" Markdown:
Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>

"" Vim:
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
Gautocmdft vim nnoremap <silent><buffer>K      :<C-u>Help<Space><C-r><C-w><CR>
Gautocmdft vim nnoremap <silent><buffer><C-]>  :<C-u>tag <c-r>=expand("<cword>")<CR><CR>zz

"" Ouickfix:
Gautocmdft qf  nnoremap <buffer><CR>      <CR>

"" Help:
Gautocmdft help nnoremap <silent><buffer><C-n> :<C-u>cnext<CR>
Gautocmdft help nnoremap <silent><buffer><C-p> :<C-u>cprevious<CR>

" -------------------------------------------------------------------------------------------------
" Insert: (i)

" <C-c> doesn't trigger the InsertLeave autocmd
inoremap <C-c> <ESC>

" Move cursor to first or end of line
inoremap <silent><C-a>  <C-o><S-i>
inoremap <silent><C-e>  <C-o><S-a>

" Put +register word
inoremap <silent><C-p>  <C-r>*
inoremap <silent><C-j>  <C-r>*

" Language:
"" Go:
" Gautocmdft go inoremap <buffer> "    '
" Gautocmdft go inoremap <buffer> '    "
"" Yaml:
" Gautocmdft yaml inoremap <buffer> "    '
" Gautocmdft yaml inoremap <buffer> '    "
"" Swift:
Gautocmdft swift imap <buffer><C-k>  <Plug>(autocomplete_swift_jump_to_placeholder)

" Plugins:
"" Deoplete:
inoremap <silent><expr><CR>     pumvisible() ? deoplete#close_popup() : "\<CR>"
" inoremap <silent><expr><Tab>    pumvisible() ? "\<C-n>".deoplete#mappings#close_popup() : "\<Tab>"
inoremap <silent><expr><BS>     pumvisible() ? deoplete#smart_close_popup()."\<C-h>" : "\<C-h>"
inoremap <silent><expr><C-h>    pumvisible() ? deoplete#smart_close_popup()."\<C-h>" : "\<C-h>"
inoremap <silent><expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
inoremap <silent><expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"
inoremap <silent><expr><C-z>    pumvisible() ? "\<C-z>" : deoplete#mappings#undo_completion()
"" Neosnippet:
imap     <silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

" -------------------------------------------------------------------------------------------------
" Visual Select: (v)

" Do not add register to current cursor word
vnoremap c       "_c
vnoremap x       "_x
vnoremap P       "_dP
vnoremap p       "_dp
vnoremap @       ^
vnoremap ^       @
" sort by ignorecase alphabetically.
vnoremap <silent>gs :<C-u>'<,'>sort i<CR>
vnoremap v       <End>h
" Move to start of line
vnoremap V ^
" Jump to match pair brackets
vnoremap <S-Tab> %

vmap <silent>gx  <Plug>(openbrowser-smart-search)
nmap <silent>gc  <Plug>(caw:hatpos:toggle)
vmap <silent>gc  <Plug>(caw:hatpos:toggle)
vmap <silent><LocalLeader>t  :<C-u>Trans<CR>
vmap         ga   <Plug>(LiveEasyAlign)


" Language:

"" Protobuf:
Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

"" C CXX ObjC:
Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

" -------------------------------------------------------------------------------------------------
" Visual: (x)
xmap  <LocalLeader>        <Plug>(operator-replace)

xnoremap <silent><C-t>     :<C-u>Trans<CR>

" Language:

" -------------------------------------------------------------------------------------------------
" Select: (s)

" neosnippet
smap     <silent><expr><C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

" Language:

" -------------------------------------------------------------------------------------------------
" CommandLine: (c)

" Move beginning of the command line
" http://superuser.com/a/988874/483994
cnoremap <C-a>    <Home>
cnoremap <C-d>    <Del>

" -------------------------------------------------------------------------------------------------
" Terminal: (t)

" Emacs like mapping
tnoremap <silent>qq      <C-\><C-n>
tnoremap <S-Left>        <C-[>b
tnoremap <C-Left>        <C-[>b
tnoremap <S-Right>       <C-[>f
tnoremap <C-Right>       <C-[>f
tnoremap <nowait><buffer><BS>    <BS>

" -------------------------------------------------------------------------------------------------

filetype plugin indent on
