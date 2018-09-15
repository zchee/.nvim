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

let $XDG_RUNTIME_DIR = expand('/run/user/501')
let $XDG_CACHE_HOME = expand($HOME.'/.cache')
let $XDG_CONFIG_DIRS = expand('/etc/xdg')
let $XDG_CONFIG_HOME = expand($HOME.'/.config')
let $XDG_DATA_DIRS = expand('/usr/local/share:/usr/share')
let $XDG_DATA_HOME = expand($HOME.'/.local/share')

let $ANSIBLE_VAULT_PASSWORD_FILE = expand($XDG_CONFIG_HOME . '/ansible-vault/vault_password')

let s:gopath = expand('$HOME/go') . '/src'
let s:srcpath = expand('$HOME/src/github.com')

" -------------------------------------------------------------------------------------------------
" Neovim Configs:

let g:python_host_prog = '/usr/local/bin/pypy'
let g:python3_host_prog = '/usr/local/bin/pypy3'
let g:loaded_python_provider = 1
let g:clipboard = {
      \   'name': 'macOS-clipboard',
      \   'copy': {
      \      '+': 'pbcopy',
      \      '*': 'pbcopy',
      \    },
      \   'paste': {
      \      '+': 'pbpaste',
      \      '*': 'pbpaste',
      \   },
      \   'cache_enabled': 1,
      \ }

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
set backup
set backupdir=$XDG_DATA_HOME/nvim/backup
set belloff=all
set cinoptions+=:0,g0,N-1,m1
set clipboard=unnamed,unnamedplus
set cmdheight=2
set complete=.  " default: .,w,b,u,t
set completeopt=menuone,noinsert,noselect  " longest
set concealcursor=niv
set conceallevel=1
set directory=$XDG_DATA_HOME/nvim/swap
set expandtab
set fillchars="diff:⣿,fold: ,vert:│"
set fileformats=unix,mac,dos
set foldcolumn=0
set foldmethod=indent
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
set list & listchars=nbsp:%,tab:»-,trail:_
set makeprg="make -j8"
set matchtime=0  " disable nvim matchparen
set maxmempattern=1000  " max: 2000000
set modeline
set modelines=5
set mouse=a
set noswapfile
set number
set packpath=
set path=$PWD/**
set previewheight=20
set pumheight=40
set regexpengine=2
set ruler
set scrollback=-1
set scrolljump=1
set scrolloff=10
set secure
set shiftround
set shiftwidth=2
set shortmess=filnxtToOFc  " default: shortmess=filnxtToOF
set showfulltag
set showmatch
set showmode
set showtabline=2
set sidescrolloff=3
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set switchbuf=useopen
set synmaxcol=3000  " 0: unlimited
set tabstop=2
set tags=./tags;  " http://d.hatena.ne.jp/thinca/20090723/1248286959
set termguicolors
set textwidth=0
set timeout  " mappnig timeout
set timeoutlen=500
set ttimeout  " keycode timeout
set ttimeoutlen=5
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set undolevels=10000
set updatetime=500
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
set nostartofline
set noswapfile
set notitle
set novisualbell
set nowrapscan
set nowritebackup

" mkdir backupdir
if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
endif
" mkdir swapdir
if !isdirectory(&directory)
  call mkdir(&directory, "p")
endif
" mkdir undodir
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
" Ignore Plugins:

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

let g:dein#install_max_processes = 8
let g:dein#types#git#default_protocol = 'https'
let g:dein#types#git#clone_depth = 1

if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir, expand('<sfile>'))

  " Develop Plugins:
  call dein#local(s:gopath.'/github.com/zchee',  { 'frozen': 1, 'merged': 0 }, ['nvim-go', 'nvim-kube', 'nvim-terraform', 'nvim-flycheck'])
  call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0 }, ['vim-flatbuffers', 'vim-gn', 'vim-vgo'])

  " Dein:
  call dein#add('Shougo/dein.vim')

  " Completion Deoplete:
  call dein#add('Shougo/deoplete.nvim')
  "" suorces
  call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0, 'on_ft': ['go'] }, ['deoplete-go'])
  call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0, 'on_ft': ['python', 'cython', 'pyrex'] }, ['deoplete-jedi'])
  " call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0, 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] }, ['deoplete-clang'])
  " call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0, 'on_ft': ['dockerfile'] }, ['deoplete-docker'])
  " call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0, 'on_ft': ['gas', 'masm'] }, ['deoplete-asm'])
  " call dein#local(s:srcpath.'/zchee', { 'frozen': 1, 'merged': 0, 'on_ft': ['zsh'] }, ['deoplete-zsh'])
  call dein#add('Shougo/neco-vim', { 'on_ft': ['vim'] })
  " call dein#add('LuXuryPro/deoplete-rtags', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] })
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neosnippet.vim', { 'depends': ['neosnippet-snippets'] })
  "" support
  " call dein#add('Shougo/context_filetype.vim')
  " call dein#add('Shougo/neoinclude.vim', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] })
  call dein#add('Shougo/echodoc.vim')
  call dein#add('Shougo/neopairs.vim', { 'on_event': 'CompleteDone' })
  call dein#add('Shougo/deoppet.nvim')

  " Denite:
  call dein#add('Shougo/denite.nvim')
  "" dependency
  " call dein#local(s:srcpath, { 'frozen': 1, 'merged': 0 }, ['nixprime/cpsm'])  " can't build with pypy3 
  "" suorces

  " LanguageClient:
  call dein#add('autozimu/LanguageClient-neovim', { 'rev': 'next', 'build': 'cargo build --release --all-features -v && command cp -f target/release/languageclient bin/' })
  call dein#add('junegunn/fzf')

  " Filer:
  call dein#add('cocopon/vaffle.vim')
  " call dein#add('Shougo/defx.nvim')
  call dein#add('philip-karlsson/bolt.nvim')

  " Git:
  call dein#add('airblade/vim-gitgutter')
  call dein#add('lambdalisue/gina.vim')

  " Linter:
  call dein#add('w0rp/ale')
  call dein#add('machakann/vim-vimhelplint')

  " Formatter:
  " call dein#add('rhysd/vim-clang-format', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp', 'proto', 'javascript', 'java', 'typescript'] })

  " References:

  " Interface:
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes', { 'depends': ['vim-airline/vim-airline'] })
  call dein#add('ryanoasis/vim-devicons')

  " Operator:
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-operator-replace', { 'on_map': '<Plug>', 'depends': 'vim-operator-user' })
  call dein#add('rhysd/vim-operator-surround', { 'on_map': '<Plug>', 'depends': 'vim-operator-user' })

  " Utility:
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#local(s:gopath.'/github.com',  { 'frozen': 1, 'merged': 0 }, ['utahta/trans.nvim'])
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
  call dein#add('tyru/open-browser-github.vim', { 'on_cmd': ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq'], 'depends': 'open-browser.vim' })
  call dein#add('tyru/open-browser.vim')

  " Lifelog:
  call dein#add('wakatime/vim-wakatime')

  " -----------------------------------------------------------------------------
  " Language Plugin:
  
  "" Go:
  call dein#add('fatih/vim-go', { 'lazy': 1 })
  call dein#add('tweekmonster/hl-goimport.vim', { 'on_ft': ['go'] })
  call dein#add('zchee/vim-go-slide')
  call dein#add('rhysd/vim-goyacc')
  call dein#local(s:gopath.'/github.com',  { 'frozen': 1, 'merged': 0, 'on_ft': ['go'] }, ['garyburd/vigor'])
  
  "" C Family:
  call dein#add('vim-jp/vim-cpp')
  call dein#add('octol/vim-cpp-enhanced-highlight')
  call dein#add('lyuts/vim-rtags', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] })
  "" Swift:
  call dein#add('keith/swift.vim')
  "" CMake:
  call dein#add('pboettch/vim-cmake-syntax')
  "" LLVM TableGen:
  call dein#local($HOME.'/src/', { 'frozen': 1, 'merged': 0, 'rtp': 'utils/vim' }, ['llvm.org/llvm'])
  
  "" Python:
  call dein#add('davidhalter/jedi-vim', {'lazy': 1, 'on_ft': ['python', 'cython', 'pyrex'] })
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#add('tell-k/vim-autopep8')
  call dein#local(s:srcpath, { 'on_ft': ['python', 'cython', 'pyrex'], 'frozen': 1, 'merged': 0 }, ['tweekmonster/impsort.vim'])
  
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
  call dein#add('google/vim-maktaba', { 'on_ft': ['bazel'] })
  call dein#add('bazelbuild/vim-bazel', { 'on_ft': ['bazel'] })
  
  "" Assembly:
  call dein#add('Shirk/vim-gas')

  "" TypeScript:
  call dein#add('HerringtonDarkholme/yats.vim')
  
  "" Binary:
  call dein#add('Shougo/vinarise.vim', { 'on_cmd': ['Vinarise', 'VinarisePluginDump'] })
  
  "" Markdown:
  call dein#add('moorereason/vim-markdownfmt')
  
  "" Vim:
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('vim-jp/syntax-vim-ex')
  
  "" Shell:
  call dein#add('chrisbra/vim-sh-indent')

  "" Yaml:
  call dein#add('stephpy/vim-yaml')
  
  "" Toml:
  call dein#add('cespare/vim-toml')
  
  "" Json:
  call dein#add('elzr/vim-json')

  "" JsonSchema:
  call dein#add('Quramy/vison')
  call dein#add('Quramy/vim-json-schema-nav')

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
  " call dein#add('xolox/vim-lua-ftplugin', { 'on_ft': ['lua'] })
  " call dein#add('racer-rust/vim-racer')
  " call dein#add('rhysd/rust-doc.vim', { 'on_ft': ['rust'] })
  " call dein#add('b4b4r07/vim-ansible-vault')
  " call dein#add('rhysd/vim-gfm-syntax', { 'on_ft': ['markdown'] })
  " call dein#add('juliosueiras/vim-terraform-completion')
  " call dein#local(s:srcpath, { 'frozen': 1, 'merged': 0, 'on_ft': ['c', 'cpp', 'objc', 'objcpp', 'typescript'] }, ['Valloric/YouCompleteMe'])
  " call dein#add('b4b4r07/vim-crowi', {'on_cmd': 'CrowiCreate'})
  " call dein#add('cocopon/pgmnt.vim', { 'on_cmd': ['PgmntDevInspect'] })
  " call dein#add('sbdchd/neoformat')
  " call dein#add('leafgarland/typescript-vim')
  " call dein#add('jsfaint/gen_tags.vim', { 'on_cmd': ['GenCtags', 'EditExt', 'ClearCtags', 'GenGTAGS', 'ClearGTAGS'] })

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

if !exists('g:syntax_on')
  syntax enable
endif
let g:enable_bold_font = 1
colorscheme hybrid_reverse

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

"" Vim:
Gautocmdft qf hi Search     gui=None    guifg=None  guibg=#373b41
""" Denite:
" guibg=#343941
highlight! DeniteMatchedChar guifg=#85678f
highlight! DeniteMatchedRange guifg=#f0c674
highlight! DenitePreviewLine guifg=#85678f
highlight! DeniteUnderlined guifg=#85678f

"" ParenMatch:
highlight! ParenMatch    gui=underline guifg=none       guibg=#343941

" -------------------------------------------------------------------------------------------------
" Initialize Syntax:

silent! filetype plugin indent on

" -------------------------------------------------------------------------------------------------
" Gautocmd:

" Global:
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
  if winnr('$') == 1 &&
        \ s:ft == "qf" || s:ft == 'vaffle'  " || s:ft == 'diff'
    quit!
  endif
endfunction
Gautocmd WinEnter * call s:autoClose()

" macOS Frameworks and system header protection
Gautocmd BufNewFile,BufReadPost
      \ /System/Library/*,/Applications/Xcode*,/usr/include*,/usr/lib*
      \ setlocal readonly nomodified

Gautocmdft godoc,help,man,qf,quickrun,ref call LessMap()  " less like keymappnig
Gautocmd BufEnter option-window call LessMap()  " :option have not filetype

"" Terminel Settings:
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
Gautocmd TermOpen * setlocal nonumber sidescrolloff=0 scrolloff=0 statusline=%{b:term_title}
Gautocmd BufNewFile,BufRead,BufEnter term://* startinsert
Gautocmd BufLeave term://* stopinsert

"" LanguageClient Neovim:
if dein#tap('LanguageClient-neovim')
  " Gautocmdft c,cpp,dockerfile,go,graphql,objc,python,rust,sh,yaml,zsh silent! LanguageClientStart
  Gautocmdft c,cpp,dockerfile,go,graphql,objc,python,rust,sh,yaml,zsh setlocal formatexpr=LanguageClient#textDocument_rangeFormatting()
  Gautocmd User LanguageClientBufReadPost call s:lsp_yaml_set_schema()

  "" go
  Gautocmdft go nnoremap     <silent><buffer><LocalLeader>] :<C-u>call LanguageClient#textDocument_definition()<CR>
  Gautocmdft go nnoremap     <silent><buffer>K              :<C-u>call LanguageClient#textDocument_hover()<CR>
  "" c, cpp
  Gautocmdft c,cpp nnoremap  <silent><buffer><C-]>          :<C-u>call LanguageClient#textDocument_definition()<CR>
  Gautocmdft c,cpp nnoremap  <silent><buffer><Leader>e      :<C-u>call LanguageClient#textDocument_rename()<CR>
  Gautocmdft c,cpp nnoremap  <silent><buffer>K              :<C-u>call LanguageClient#textDocument_hover()<CR>
  "" python
  Gautocmdft python nnoremap <silent><buffer><C-]>          :<C-u>call LanguageClient#textDocument_definition()<CR>
  Gautocmdft python nnoremap <silent><buffer><Leader>e      :<C-u>call LanguageClient#textDocument_rename()<CR>
  Gautocmdft python nnoremap <silent><buffer>K              :<C-u>call LanguageClient#textDocument_hover()<CR>
  "" rust
  Gautocmdft rust nnoremap   <silent><buffer><C-]>          :<C-u>call LanguageClient#textDocument_definition()<CR>
  Gautocmdft rust nnoremap   <silent><buffer><Leader>e      :<C-u>call LanguageClient#textDocument_rename()<CR>
  Gautocmdft rust nnoremap   <silent><buffer>K              :<C-u>call LanguageClient#textDocument_hover()<CR>
  "" yaml
  Gautocmdft yaml nnoremap   <silent><buffer><C-]>          :<C-u>call LanguageClient#textDocument_definition()<CR>
  Gautocmdft yaml nnoremap   <silent><buffer><Leader>e      :<C-u>call LanguageClient#textDocument_rename()<CR>
  Gautocmdft yaml nnoremap   <silent><buffer>K              :<C-u>call LanguageClient#textDocument_hover()<CR>
  "" swift
  Gautocmdft swift nnoremap   <silent><buffer><C-]>          :<C-u>call LanguageClient#textDocument_definition()<CR>
  Gautocmdft swift nnoremap   <silent><buffer><Leader>e      :<C-u>call LanguageClient#textDocument_rename()<CR>
  Gautocmdft swift nnoremap   <silent><buffer>K              :<C-u>call LanguageClient#textDocument_hover()<CR>
endif

" Language:
"" Go:
Gautocmd BufRead,BufNewFile *.tmpl set filetype=gohtmltmpl
Gautocmdft go let g:LanguageClient_diagnosticsEnable = 0
" Gautocmdft go let g:airline_section_c = airline#section#create(['%<', 'readonly', 'path', ' ', '%{go#statusline#Show()}'])

" Vim:
"" nested autoload
Gautocmd BufWritePost $MYVIMRC nested silent! source $MYVIMRC

"" Neosnippet:
Gautocmdft neosnippet call dein#source('neosnippet.vim')
if dein#source('neosnippet')
  Gautocmd InsertLeave * NeoSnippetClearMarkers
endif

"" Gitcommit:
Gautocmd BufEnter COMMIT_EDITMSG  startinsert

"" Gina:
Gautocmd BufEnter gina://*:commit startinsert
Gautocmd BufEnter gina://* nnoremap <silent><buffer>q :q<CR>
Gautocmdft jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000

"" Yaml:

"" FZF:
" Gautocmdft fzf setlocal laststatus=0 noshowmode noruler
Gautocmd BufEnter fzf setlocal laststatus=0 noshowmode noruler
Gautocmd BufLeave fzf setlocal laststatus=2 showmode ruler

" -------------------------------------------------------------------------------------------------
" Language Settings:

" Go:
"" Nvim Go:
let g:go#build#appengine = 0
let g:go#build#autosave = 1
let g:go#build#is_not_gb = 0
let go#highlight#cgo = 1
" let g:go#build#flags = ['-race']
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
let g:go#generate#test#subtest = 1
let g:go#guru#reflection = 0
let g:go#iferr#autosave = 0
let g:go#lint#golint#autosave = 0
let g:go#lint#golint#ignore = ['internal', 'vendor', 'pb', 'fbs']
let g:go#lint#golint#mode = 'root'
let g:go#lint#govet#autosave = 0
let g:go#lint#govet#flags = ['-v', '-all']
let g:go#lint#govet#ignore = ['vendor', 'testdata', '_tmp']
let g:go#lint#metalinter#autosave = 0
let g:go#lint#metalinter#autosave#tools = ['vet', 'golint']
let g:go#lint#metalinter#deadline = '20s'
let g:go#lint#metalinter#skip_dir = ['internal', 'vendor', 'testdata', '__*.go', '*_test.go']
let g:go#lint#metalinter#tools = ['vet', 'golint']
let g:go#rename#prefill = 1
let g:go#snippets#loaded = 1
let g:go#terminal#height = 120
let g:go#terminal#start_insert = 1
let g:go#terminal#width = 120
let g:go#test#all_package = 0
let g:go#test#autosave = 0
let g:go#test#flags = ['-v']
let g:go#debug = 1
let g:go#debug#pprof = 0
""" highlight
let g:go#highlight#terminal#test = 1


"" Vim Go:
" let g:go#use_vimproc = 1
" let g:go_asmfmt_autosave = 1
" let g:go_auto_type_info = 0
" let g:go_autodetect_gopath = 1
" let g:go_def_mapping_enabled = 0
" let g:go_def_mode = 'godef'
" let g:go_doc_command = 'godoc'
" let g:go_doc_options = ''
" let g:go_fmt_autosave = 1
" let g:go_fmt_command = 'goimports'
" let g:go_fmt_experimental = 1
" let g:go_loclist_height = 15
" let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck', 'gotype']
" let g:go_snippet_engine = 'neosnippet' " ultisnips
" let g:go_template_enabled = 0
" let g:go_term_enabled = 1
" let g:go_term_height = 30
" let g:go_term_width = 30
let g:go_doc_max_height = 30
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
let g:rust_clip_command = 'pbcopy'
let g:rustfmt_autosave = 0
let g:rustfmt_command = 'rustfmt'


"" Yaml:


" TerraForm:
let g:terraform_align = 1
let g:terraform_fmt_on_save = 1
let g:terraform_fold_sections = 1
let g:terraform_remap_spacebar = 1


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
let s:deoplete_custom_option = {
      \ 'auto_complete_delay': 3,
      \ 'auto_refresh_delay': 3,
      \ 'camel_case': v:false,
      \ 'ignore_case': v:true,
      \ 'ignore_sources': {
      \   '_': ['around', 'dictionary', 'omni', 'tag'],
      \   'c': ['around', 'dictionary', 'omni', 'tag', 'buffer', 'member', 'neosnippet'],
      \   'cpp': ['around', 'dictionary', 'omni', 'tag', 'buffer', 'member', 'neosnippet'],
      \   'go': ['around', 'dictionary', 'omni', 'tag', 'buffer', 'member', 'LanguageClient'],
      \   'python': ['around', 'dictionary', 'omni', 'tag', 'member', 'LanguageClient'],
      \   'sh': ['around', 'dictionary', 'omni', 'tag'],
      \   'yaml': ['around', 'dictionary', 'omni', 'tag', 'neosnippet'],
      \   'yaml.docker-compose': ['around', 'dictionary', 'omni', 'tag', 'neosnippet'],
      \   'zsh': ['around', 'dictionary', 'omni', 'tag'],
      \ },
      \ 'omni_patterns': {
      \   'c': '[^. *\t]\.\w*',
      \   'cpp': '[^. *\t]\.\w*',
      \   'sh': '[^ *\t"{=$]\w*',
      \   'terraform': '[^ *\t"{=$]\w*',
      \   'yaml': '[^ *\t"{=$]\w*',
      \   'yaml.docker-compose': '[^ *\t"{=$]\w*',
      \ },
      \ 'max_list': 10000,
      \ 'min_pattern_length': 1,
      \ 'num_processes': 6,
      \ 'on_insert_enter': v:false,
      \ 'on_text_changed_i': v:false,
      \ 'refresh_always': v:true,
      \ 'skip_chars': ['(', ')'],
      \ 'smart_case': v:true,
      \ }
call deoplete#custom#option(s:deoplete_custom_option)

let s:deoplete_omni_functions = {
      \ 'c':  'LanguageClient#complete',
      \ 'cpp':  'LanguageClient#complete',
      \ 'objc': 'LanguageClient#complete',
      \ 'sh':  'LanguageClient#complete',
      \ 'yaml': 'LanguageClient#complete',
      \ 'yaml.docker-compose': 'LanguageClient#complete',
      \ }
      " \ 'python':  'LanguageClient#complete',
if dein#tap('vim-terraform-completion')
  s:deoplete_omni_functions.terraform = ['terraformcomplete#Complete']
endif
call deoplete#custom#source('omni', 'functions', s:deoplete_omni_functions)

let s:deoplete_omni_input_patterns = {
      \ 'terraform': ['\h\w*'],
      \ }
call deoplete#custom#var('omni', 'input_patterns', s:deoplete_omni_input_patterns)

call deoplete#custom#source('_', 'converters', ['converter_auto_paren', 'converter_remove_overlap'])
" call deoplete#custom#source('_', 'matchers', ['matcher_cpsm'])  " not compatible pypy3
call deoplete#custom#source('_', 'sorters', [])
call deoplete#custom#source('buffer', 'rank', 0)
call deoplete#custom#source('go', 'matchers', ['matcher_fuzzy'])
call deoplete#custom#source('go', 'sorters', [])
call deoplete#custom#source('jedi', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('jedi', 'matchers', ['matcher_full_fuzzy'])
call deoplete#custom#source('LanguageClient', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('LanguageClient', 'matchers', ['matcher_fuzzy'])
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 1)
call deoplete#custom#source('neosnippet', 'rank', 0)
call deoplete#custom#source('vim', 'disabled_syntaxes', ['Comment'])
call deoplete#custom#source('vim', 'matchers', ['matcher_fuzzy'])
" Gautocmd VimEnter * call deoplete#initialize()

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
let g:deoplete#sources#go#gocode_binary = expand('$HOME/go/bin/gocode')
let g:deoplete#sources#go#gocode_flags = []
if s:use_gocode_mdempsky != 0
  let g:deoplete#sources#go#gocode_binary = expand('$HOME/go/bin/gocode-mdempsky')
  let g:deoplete#sources#go#gocode_flags = ['-builtin', '-sock=none', '-source']
endif
let g:deoplete#sources#go#auto_goos = 1
let g:deoplete#sources#go#pointer = 1
let g:deoplete#sources#go#sort_class = ['func', 'type', 'var', 'const', 'package']
let g:deoplete#sources#go#cgo = 1
let g:deoplete#sources#go#cgo#libclang_path = s:llvm_library_path . '/libclang.dylib'
let g:deoplete#sources#go#cgo#sort_algo = 'priority'  " 'alphabetical'
"" clang
let g:deoplete#sources#clang#clang_header = s:llvm_library_path . '/clang'
let g:deoplete#sources#clang#flags = [
      \ '-I/usr/local/include',
      \ '-I' . s:llvm_library_path . '/clang/' . s:llvm_clang_version . '/include',
      \ '-I/usr/include',
      \ '-F/System/Library/Frameworks',
      \ '-F/Library/Frameworks',
      \ '-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk',
      \ ] " echo | clang -v -E -x c -
let g:deoplete#sources#clang#libclang_path = s:llvm_library_path . '/libclang.dylib'
"" jedi
let g:deoplete#sources#jedi#statement_length = 0
let g:deoplete#sources#jedi#short_types = 0
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#worker_threads = 2
let g:deoplete#sources#jedi#python_path = g:python3_host_prog
let g:deoplete#sources#asm#go_mode = 1
" racer
let g:racer_cmd = "/usr/local/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1
" neopairs
let g:neopairs#enable = 1
" echodoc
let g:echodoc#enable_at_startup = 1
" neosnippet
let g:neosnippet#data_directory = $XDG_CACHE_HOME . '/nvim/neosnippet'
let g:neosnippet#enable_complete_done = 1
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#expand_word_boundary = 0
let g:neosnippet#snippets_directory = $XDG_CONFIG_HOME . '/nvim/neosnippets'
let g:neosnippet_username = 'zchee'
let g:neosnippet_author = 'Koichi Shiraishi'
" debug
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', $DEOPLETE_LOG_FILE)
" call deoplete#custom#source('asm', 'is_debug_enabled', 1)
" call deoplete#enable()

"" LanguageClient:
let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_completionPreferTextEdit = 1
let g:LanguageClient_diagnosticsList = 'Quickfix'  " default: Quickfix, Location, Disabled
" let g:LanguageClient_fzfOptions = ['--algo=v1', '--tac', '--prompt=> ', '--ansi', '--color=light,fg:232,bg:255,bg+:116,info:27', '--black', '--history=~/.history/fzf-history']
let g:LanguageClient_hasSnippetSupport = 1
let g:LanguageClient_hoverPreview = 'Always'  " Always, Auto, Never
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_selectionUI = 'fzf'  " fzf, quickfix, location-list
let g:LanguageClient_settingsPath = '.lsp.json'
let g:LanguageClient_windowLogMessageLevel = "Warning"  " Error, default: Warning, Info, Log
let g:LanguageClient_serverCommands_c = [
      \ 'clangd',
      \ '-compile-commands-dir='.expand('%:p:h'),
      \ '-compile_args_from=filesystem',
      \ '-completion-style=detailed',
      \ '-header-insertion-decorators',
      \ '-include-ineligible-results',
      \ '-index',
      \ '-j=6',
      \ '-limit-results=0',
      \ '-pch-storage=memory',
      \ '-resource-dir=/opt/llvm/devel/lib/clang/8.0.0',
      \ '-use-dbg-addr',
      \ '-use-dex-index',
      \ ]
let g:LanguageClient_serverCommands = {
      \ 'c': g:LanguageClient_serverCommands_c,
      \ 'cpp': g:LanguageClient_serverCommands_c,
      \ 'objc': g:LanguageClient_serverCommands_c,
      \ 'swift': ['langserver-swift'],
      \ 'dockerfile': ['docker-langserver', '--stdio'],
      \ 'go': ['go-langserver', '-format-tool=goimports', '-func-snippet-enabled=false', '-maxparallelism=6', '-mode=stdio', '-usebinarypkgcache'],
      \ 'graphql': ['graphql', 'autocomplete'],
      \ 'python': ['pyls'],
      \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
      \ 'sh': ['bash-language-server', 'start'],
      \ 'yaml': ['node', '--experimental-modules', '--experimental-vm-modules', '--experimental-worker', $HOME.'/src/github.com/redhat-developer/yaml-language-server/out/server/src/server.js', '--stdio'],
      \ 'yaml.docker-compose': ['node', '--experimental-modules', '--experimental-vm-modules', '--experimental-worker', $HOME.'/src/github.com/redhat-developer/yaml-language-server/out/server/src/server.js', '--stdio'],
      \ 'x': ['/opt/cquery/bin/cquery', '--log-file=/tmp/cq.log', '--init={"index":{"comments":2},"cacheFormat":"msgpack","cacheDirectory":"/Users/zchee/.cache/cquery","resourceDirectory":"/opt/llvm/stable/lib/clang/6.0.1"}'],
      \ 'zsh': ['bash-language-server', 'start'],
      \ }
let s:LanguageClient_rootMarkers_c = ['autogen.sh', 'configure', '.clang-format']
let g:LanguageClient_rootMarkers = {
      \ 'c': s:LanguageClient_rootMarkers_c,
      \ 'cpp': s:LanguageClient_rootMarkers_c,
      \ 'python': ['setup.py', 'LICENSE'],
      \ }
" let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
" let g:LanguageClient_loggingLevel = 'DEBUG'  " default: WARN
" let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'
" {\"index\": {\"comments\": 2},\"cacheFormat\": \"msgpack\",\"cacheDirectory\": ~/.cache/cquery\",\"resourceDirectory\": \"/opt/llvm/stable/lib/clang/6.0.1\"}


"" Denite:
call denite#custom#option('_', {
      \ 'auto_accel': v:false,
      \ 'highlight-matched-char': 'DeniteMatchedChar',
      \ 'highlight-matched-range': 'DeniteMatchedRange',
      \ 'highlight-preview-line': 'DenitePreviewLine',
      \ 'auto-highlight': v:false,
      \ 'empty': v:false,
      \ 'prompt': '>',
      \ 'sorter': 'sorter/word',
      \ 'source_names': 'short',
      \ 'unique': v:true,
      \ 'winheight': 20,
      \ })
call denite#custom#option('file_rec', {
      \ 'sorter': 'sorter/sublime',
      \ })
let s:denite_fd_command = ['fd', '--follow', '--hidden', '--type=f', '--full-path', '--color=never', '--exclude=.git', '--exclude=vendor', '']
let s:denite_ag_command = ['pt', '--follow', '--nocolor', '--nogroup', '-g', '']
let s:denite_pt_command = ['pt', '--follow', '--nocolor', '--nogroup', '-g', '']
let s:denite_rg_command = ['rg', '--files', '--mmap', '--threads=8', '--hidden', '--smart-case', '--no-ignore-vcs', '--no-heading', '--glob', '!.git', '--glob', '!vendor', '']
" if &filetype == 'go'
"   let s:denite_fd_command = ['fd', '--follow', '--hidden', '--type=f', '--full-path', '--color=never', '--exclude=".git"', '--exclude="vendor"', '']
"   let s:denite_rg_command = ['rg', '--files', '--mmap', '--threads=8', '--hidden', '--smart-case', '--no-ignore-vcs', '--no-heading', '--glob', '!.git', '--glob', '!vendor']
" endif
call denite#custom#var('file_rec/fd', 'command', s:denite_fd_command)
call denite#custom#var('file_rec/ag', 'command', s:denite_ag_command)
call denite#custom#var('file_rec/pt', 'command', s:denite_pt_command)
call denite#custom#var('file_rec/rg', 'command', s:denite_rg_command)
" call denite#custom#source('file_rec', 'matchers', ['matcher_cpsm'])
"" grep
call denite#custom#var('grep/rg', 'command', ['rg'])
call denite#custom#var('grep/rg', 'default_opts', ['--mmap', '--threads=8', '--hidden', '--smart-case', '--vimgrep', '--no-ignore-vcs', '--no-heading', '--glob', '!.git', '--glob', '!vendor'])
call denite#custom#var('grep/rg', 'recursive_opts', [])
call denite#custom#var('grep/rg', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep/rg', 'separator', ['--'])
call denite#custom#var('grep/rg', 'final_opts', [])
call denite#custom#var('grep/pt', 'command', ['pt'])
call denite#custom#var('grep/pt', 'default_opts', ['--follow', '--hidden', '--nogroup', '--nocolor', '--smart-case', '--ignore="_*"'])
call denite#custom#var('grep/pt', 'recursive_opts', [])
call denite#custom#var('grep/pt', 'pattern_opt', [])
call denite#custom#var('grep/pt', 'separator', ['--'])
call denite#custom#var('grep/pt', 'final_opts', [])
"" line
call denite#custom#var('line/rg', 'command', ['rg', '--files', '--glob', '!.git', ''])
call denite#custom#var('line/pt', 'command', ['pt', '--nocolor', '--nogroup', '--follow', '-g', ''])
"" map
call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
"" alias
call denite#custom#alias('source', 'file_rec/ag', 'file_rec')
call denite#custom#alias('source', 'file_rec/fd', 'file_rec')
call denite#custom#alias('source', 'file_rec/pt', 'file_rec')
call denite#custom#alias('source', 'file_rec/ag', 'file_rec')
call denite#custom#alias('source', 'grep/rg', 'grep')
call denite#custom#alias('source', 'grep/pt', 'grep')
call denite#custom#alias('source', 'line/rg', 'line')
call denite#custom#alias('source', 'line/pt', 'line')
"" filter
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])


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


" FZF:
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'DeniteSearch'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'DeniteSearch'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'],
      \ }
let g:fzf_history_dir = '~/.history/fzf-history'
" let g:fzf_layout = { 'window': '10split enew' }
" let g:fzf_layout = { 'left': '30%' }


" Vikube:
let g:vikube_autoupdate = 1
let g:vikube_default_logs_tail = 100
let g:vikube_use_current_namespace = 1


" Ale:
let g:ale_cache_executable_check_failures = 1
let g:ale_change_sign_column_color = 0
let g:ale_completion_enabled = 0
let g:ale_echo_cursor = 1
let g:ale_echo_delay = 1
let g:ale_emit_conflict_warnings = 0
let g:ale_fix_on_save = 0
let g:ale_keep_list_window_open = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_list_window_size = 10
let g:ale_open_list = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_sign_column_always = 1
"" linters
let g:ale_linters = {}
let g:ale_linters.dockerfile = ['hadolint']
let g:ale_linters.go = []  " let g:ale_linters.go = ['gofmt', 'goimports', 'go vet', 'golint', 'gometalinter']
let g:ale_linters.proto = ['prototool']
let g:ale_linters.python = ['flake8', 'mypy', 'pylint']
let g:ale_linters.rust = ['cargo']
let g:ale_linters.sh = ['shellcheck', 'sh-language-server', 'shfmt']
let g:ale_linters.yaml = ['yamllint', 'swaglint']
let g:ale_linters.zsh = ['sh-language-server']
"" fixers
let g:ale_fixers = {}
let g:ale_fixers.sh = ['remove_trailing_lines', 'trim_whitespace']
let g:ale_fixers.zsh = ['remove_trailing_lines', 'trim_whitespace']
"" Go:
let g:ale_go_gofmt_options = '-s'
let g:ale_go_gometalinter_options = '--fast --enable=staticcheck --enable=gosimple --enable=unused'
let g:ale_go_staticcheck_options = ''
let g:ale_go_staticcheck_package = 1
"" Shell ShellCheck Shfmt:
let g:ale_sh_shell_default_shell = 'bash'
let g:ale_sh_shellcheck_executable = '/usr/local/bin/shellcheck'
let g:ale_sh_shellcheck_options = '-x -s bash'
let g:ale_sh_shfmt_options = ''


" Caw:
let g:caw_hatpos_skip_blank_line = 0
let g:caw_no_default_keymappings = 1
let g:caw_operator_keymappings = 0


" Airline:
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'
let g:airline#extensions#ale#show_line_numbers = 1
let g:airline#extensions#ale#open_lnum_symbol = '(L'
let g:airline#extensions#ale#close_lnum_symbol = ')'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#custom_head = 'gina#component#repo#branch'
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#quickfix#location_text = 'Location'
let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffers_label = 'b'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#exclude_preview = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#languageclient#enabled = 1
" let g:airline#extensions#languageclient#error_symbol = 'E:'
" let g:airline#extensions#languageclient#warning_symbol = 'W:'
" let g:airline#extensions#languageclient#show_line_numbers = 1
" let g:airline#extensions#languageclient#open_lnum_symbol = '(L'
" let g:airline#extensions#languageclient#close_lnum_symbol = ')'
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#wordcount#enabled = 0
let g:airline_exclude_filetypes = ['fzf']
let g:airline_highlighting_cache = 1
let g:airline_inactive_collapse = 0
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline_theme = 'hybridline'
if dein#source('vim-airline')
  let g:airline_section_c = airline#section#create(['%<', 'readonly', 'path'])
endif

" GitGutter:
let g:gitgutter_async = 1
let g:gitgutter_eager = 1
let g:gitgutter_enabled = 1
let g:gItgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 100000


" Accelerated JK:
let g:accelerated_jk_acceleration_limit = 150  " 300
let g:accelerated_jk_acceleration_table = [7, 12, 17, 21, 24, 26, 28, 30]  " [1, 3, 7, 12, 17, 21, 24, 26, 28, 30]
" let g:accelerated_jk_acceleration_table = [1, 3, 7, 12, 17, 21, 24, 26, 28, 30]


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
let g:trans_lang_cutset = ['//', '#']
let g:trans_lang_locale = 'ja'

" OpenBrowser:
let g:openbrowser_search_engines = {
      \ 'google': 'http://google.com/search?q={query}&tbs=qdr:y',
      \}
let g:openbrowser_message_verbosity = 1

" TagBar:
let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }

" -------------------------------------------------------------------------------------------------
" Previous use plugins

" Jedivim:
" let g:jedi#auto_initialization = 0
" let g:jedi#use_splits_not_buffers = ''
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#completions_enabled = 0
" let g:jedi#documentation_command = "K"
" let g:jedi#force_py_version = 3
" let g:jedi#max_doc_height = 150
" let g:jedi#popup_select_first = 0
" let g:jedi#show_call_signatures = 0
" let g:jedi#smart_auto_mappings = 0

" NERDTree:
" let g:NERDTreeAutoDeleteBuffer = 1
" let g:NERDTreeMinimalUI = 1
" let g:NERDTreeMouseMode = 1
" let g:NERDTreeQuitOnOpen = 1
" let g:NERDTreeRespectWildIgnore = 1
" let g:NERDTreeShowHidden = 1
" let g:NERDTreeSortHiddenFirst = 1

" YouCompleteMe:
" let g:ycm_auto_trigger = 1
" let g:ycm_min_num_of_chars_for_completion = 1
" let g:ycm_filetype_blacklist = {
"       \ 'tagbar' : 1,
"       \ 'pandoc' : 1,
"       \ 'quickrun' : 1,
"       \ 'markdown' : 1,
"       \}
" let g:ycm_always_populate_location_list = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_collect_identifiers_from_comments_and_strings = 1
" let g:ycm_collect_identifiers_from_tags_files = 1
" let g:ycm_complete_in_comments = 1
" let g:ycm_confirm_extra_conf = 0
" let g:ycm_extra_conf_globlist = ['./*','../*']
" let g:ycm_filepath_completion_use_working_dir = 1
" let g:ycm_global_ycm_extra_conf = $XDG_CONFIG_HOME.'/nvim/.ycm_extra_conf.py'
" let g:ycm_goto_buffer_command = 'same-buffer'  " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
" let g:ycm_key_list_select_completion = ['<Down>']
" let g:ycm_server_python_interpreter = g:python3_host_prog
" let g:ycm_seed_identifiers_with_syntax = 1
"
" autocmd! FileType rust nmap <buffer><C-]>  <C-u>YcmCompleter GoTo<CR>

" Neomake:
" let g:neomake_highlight_lines = 0
" let g:neomake_list_height = 25
" let g:neomake_open_list = 2
" let g:neomake_python_enabled_makers = ['pyflakes', 'flake8']

" Neoformat:
" let g:neoformat_enabled_python = ['autopep8', 'yapf']

" CtrlP:
" let g:ctrlp_follow_symlinks = 1
" let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
" let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:25'
" let g:ctrlp_show_hidden = 1
" let g:ctrlp_custom_ignore = {
"       \ 'dir':  '\v[\/](\.(git|hg|svn|idea|)|vendor)$',
"       \ 'file': '\v\.(exe|so|dll)$',
"       \ }

" VimMarkdownPreview:
" let vim_markdown_preview_github = 1
" let vim_markdown_preview_hotkey = '<C-m>'

" VimFiler:
" let g:vimfiler_as_default_explorer = 0
" let g:vimfiler_safe_mode_by_default = 0
" let g:vimfiler_enable_auto_cd = 0
" let g:vimfiler_tree_leaf_icon = ''
" let g:vimfiler_tree_opened_icon = '▾'
" let g:vimfiler_tree_closed_icon = '▸'
" let g:vimfiler_marked_file_icon = '✓'

" Crowi:
" let g:crowi#api_url = "https://wiki.mercari.in"
" let g:crowi#access_token = expand($CROWI_TOKEN)
" let g:crowi#filetypes = ['markdown']
" let g:crowi#open_page = 'true'
" let g:crowi#default_create_path = expand($XDG_DATA_HOME).'crowi'
" let g:crowi#browser_command = 'open'

" -------------------------------------------------------------------------------------------------
" Functions:

" LanguageClient:
function! s:lsp_yaml_set_schema()
  if &filetype =~# "yaml.*"
    let l:filepath = expand('%:p')
    let l:filename = fnamemodify(l:filepath, ':t')
    let l:schema = 'default'

    if l:filename =~# '\v\.?appveyor\.yml$'
      let l:schema = 'appveyor'
    elseif l:filepath =~# '**/.circleci/config.yml'
      let l:schema = 'circleci'
    elseif l:filename =~# '\vdocker-compose.*\.ya?ml'
      let l:schema = 'docker-compose'
    elseif l:filepath =~# '**/kubernetes/*'
      let l:schema = 'kubernetes'
    elseif l:filename =~# '\vswagger.*\.ya?ml$'
      let l:schema = 'swagger-2.0'
    elseif l:filename ==# '.travis.yml'
      let l:schema = 'travis'
    endif
    echom "yaml-language-server: use " . l:schema . " schema"

    let l:config_file = expand('~/.config/nvim/lsp/yaml/' . l:schema . '.json')
    let config = json_decode(readfile(l:config_file))
    echom "yaml-language-server: load " . l:config_file . " config"

    call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': config })
  endif
endfunction


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


" InitEdit:
function! s:initEdit()
  vsplit $XDG_CONFIG_HOME/nvim/init.vim
endfunction
command! InitEdit call s:initEdit()


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
def Format_Json(start, end):
    start = start - 1
    jsonStr = "\n".join(vim.current.buffer[start:end])
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=True, indent=4, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[start:end] = prettyJson.split(b'\n')
EOF
  command! -bang -bar -complete=command -nargs=0 -range=% FormatJson :python3 Format_Json(<line1>, <line2>)
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
nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep/rg -buffer-name='grep/rg' -mode=insert<CR>
nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer' -mode=insert<CR>
nnoremap <silent><LocalLeader>g         :<C-u>Denite line/rg -buffer-name='line/rg' -mode=insert<CR>
nnoremap <silent><LocalLeader>q         :<C-u>q<CR>
nnoremap <silent><LocalLeader>w         :<C-u>w<CR>

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
nmap     <silent>ga          <Plug>(EasyAlign)
nmap     <silent>gx          <Plug>(openbrowser-smart-search)
nmap     <nowait>j           <Plug>(accelerated_jk_gj_position)
nmap     <nowait>k           <Plug>(accelerated_jk_gk_position)
nnoremap         Q           gq
nnoremap         s           A
nnoremap <nowait>x           "_x
nnoremap         zj          zjzt
nnoremap         zk          2zkzjzt
nnoremap         ZQ          <Nop>
" nnoremap <silent><C-o>       <C-o>zz
nnoremap <silent><C-g>       :<C-u>DeniteProjectDir grep/rg -buffer-name='grep/rg' -mode=insert<CR>
nnoremap <silent><C-p>       :<C-u>DeniteProjectDir file_rec/fd -buffer-name='file_rec/fd' -mode=insert<CR>
nnoremap <silent><C-q>       :<C-u>nohlsearch<CR>
" nnoremap <silent><C-w><C-r>  <C-w>r<C-w>x
nnoremap         <S-Tab>     %
nnoremap         <S-Down>    <Nop>
nnoremap         <S-Up>      <Nop>


" Language:

"" Go:
Gautocmdft go nnoremap       <silent><buffer><C-]>        :<C-u>call GoGuru('definition')<CR>
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
Gautocmdft c,cpp             nnoremap <silent><buffer>K   :<C-u>call <SID>open_online_cfamily_doc()<CR>
if dein#tap('vim-clang-format')
  Gautocmdft c,cpp,objc,objcpp,proto map      <buffer><Leader>x   <Plug>(operator-clang-format)
  Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>C   :<C-u>ClangFormatAutoToggle<CR>
  Gautocmdft c,cpp,objc,objcpp,proto nnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>
endif
""" Rtags:
if dein#tap('vim-rtags')
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>]   :<C-u>call rtags#JumpTo(g:SAME_WINDOW)<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cb  :<C-u>call rtags#JumpBack()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cc  :<C-u>call rtags#FindRefs()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cC  :<C-u>call rtags#FindSuperClasses()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cf  :<C-u>call rtags#FindSubClasses()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cn  :<C-u>call rtags#FindRefsByName(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cp  :<C-u>call rtags#JumpToParent()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cs  :<C-u>call rtags#FindSymbols(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><Leader>u        :<C-u>call rtags#SymbolInfo()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cu  :<C-u>call rtags#SymbolInfo()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><LocalLeader>cv  :<C-u>call rtags#FindVirtuals()<CR>
  Gautocmdft c,cpp,objc,objcpp nnoremap <silent><buffer><Space>]         :<C-u>YcmCompleter GoTo<CR>
endif

"" Rust:
Gautocmdft rust nmap <buffer><C-]>    <Plug>(rust-def)
Gautocmdft rust nmap <buffer><C-S-]>  <Plug>(rust-def-vertical)
Gautocmdft rust nmap <buffer>K        <Plug>(rust-doc)

"" Python Cython:
" Gautocmdft python,cython nnoremap <silent><buffer>K          :<C-u>call jedi#show_documentation()<CR>
" Gautocmdft python,cython nnoremap <silent><buffer><C-]>      :<C-u>call jedi#goto()<CR>
" Gautocmdft python,cython nnoremap <silent><buffer><C-e>      :<C-u>call jedi#rename()<CR>
" Gautocmdft python,cython nnoremap <silent><buffer><C-f>      :<C-u>call Flake8()<CR><C-w>w :call feedkeys("<Up>")<CR>
" Gautocmdft python,cython nnoremap <silent><buffer><Leader>]  :<C-u>tag <c-r>=expand("<cword>")<CR><CR>
" Gautocmdft python,cython nnoremap <silent><buffer><Leader>e  :<C-u>call jedi#rename_visual()<CR>

"" Protobuf:
if dein#tap('prototool')
  Gautocmdft proto nnoremap <silent><Leader>f   :<C-u>call PrototoolFormatToggle()<CR>
endif

"" Yaml:

"" Markdown:
Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>

"" Vim:
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
Gautocmdft vim nnoremap <silent><buffer>K  :<C-u>Help<Space><C-r><C-w><CR>

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
Gautocmdft go,yaml,toml inoremap <buffer> "    '
Gautocmdft go,yaml,toml inoremap <buffer> '    "

"" Swift:
Gautocmdft swift imap <buffer><C-k>  <Plug>(autocomplete_swift_jump_to_placeholder)

" Deoplete:
inoremap <silent><expr><CR>     pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
inoremap <silent><expr><Tab>    pumvisible() ? "\<C-n>".deoplete#mappings#close_popup() : "\<Tab>"
inoremap <silent><expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
inoremap <silent><expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"
inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
inoremap <silent><expr><C-l>    pumvisible() ? deoplete#mappings#refresh() : "\<C-l>"
inoremap <silent><expr><C-z>    deoplete#mappings#undo_completion()
" Neosnippet:
imap <expr><C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : ""

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


" Language:

"" Protobuf:
Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

"" C CXX ObjC:
Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

" -------------------------------------------------------------------------------------------------
" Visual: (x)
xmap  <LocalLeader>        <Plug>(operator-replace)
xmap     <silent>ga        <Plug>(EasyAlign)
" xnoremap <expr>r              <Plug>(niceblock#force_blockwise('r'))

" Language:
"" Go:
" Gautocmdft go xnoremap <buffer> "  '
" Gautocmdft go xnoremap <buffer> '  "

" -------------------------------------------------------------------------------------------------
" Select: (s)

" neosnippet
smap <expr><C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : ""

" Language:
"" Go:
" Gautocmdft go snoremap <buffer> "  '
" Gautocmdft go snoremap <buffer> '  "

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
