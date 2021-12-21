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

" filetype off
" filetype plugin indent off

let s:gopath         = expand('$HOME/go')
let s:gopath_src     = s:gopath . '/src/'
let s:srcpath        = expand('$HOME/src')
let s:srcpath_github = s:srcpath . '/github.com/'

" load lua plugin configs
lua require('init')

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
set autoread
set backup
set backupdir=$XDG_DATA_HOME/nvim/backup
set belloff=all
set cindent
set cinkeys-=0#             " comments don't fiddle with indenting
set cinoptions+=:0,g0,N-1,m1
set cinoptions=''                 " See :h cinoptions-values
set clipboard+=unnamedplus
set cmdheight=2
set cmdwinheight=50
set complete=.  " .,w,b,u,t  " default: .,w,b,u,t, .
set completeopt=noinsert,noselect,menuone  " noinsert,noselect,longest,menu,menuone,preview
set concealcursor=niv
set conceallevel=0
set copyindent
set cpoptions-=_
set cscopetag
set diffopt+=hiddenoff
set directory=$XDG_DATA_HOME/nvim/swap
set display-=msgsep
set emoji
set encoding=utf-8
set expandtab
set fileformats=unix,mac,dos
" set fillchars="diff:⣿,fold: ,vert:│"  " ,msgsep:‾
" set fillchars=vert:│,fold:·
set fillchars=vert:\|
set foldcolumn=0
set foldlevel=0
set foldlevelstart=99  "open all folds by default
set foldmethod=manual
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=1     " maximum fold depth
set formatoptions+=c  " Autowrap comments using textwidth - :help fo-table
set formatoptions+=j  " Delete comment character when joining commented lines
set formatoptions+=l  " do not wrap lines that have been longer when starting insert mode already
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=q  " Allow formatting of comments with "gq"
set formatoptions+=r  " Insert comment leader after hitting <Enter>
set formatoptions+=t  " Auto-wrap text using textwidth
set formatoptions-=o  " Automatically insert the current comment leader after hitting 'o' or'O' in Normal mode
set grepformat=%f:%l:%c:%m
" set grepprg=rg\ -H\ --no-heading\ --smart-case\ --vimgrep
set helplang=en,ja
set hidden
set history=10000
set iminsert=0
set imsearch=0
set inccommand=nosplit
set isfname-==
set keywordprg=:Help
set langmenu=none
set laststatus=2
set linebreak
set lazyredraw
set listchars=tab:»-,trail:-,nbsp:%,extends:›,precedes:‹
" set listchars=nbsp:%,extends:›,precedes:‹ " tab:»-,trail:_,nbsp:+
set makeprg=make
set matchtime=0  " disable nvim matchparen
set maxmempattern=2000000  " default: 1000, max: 2000000
set modelines=1
set mouse=a
set number
set path+=$PWD/**,**
set previewheight=5
set pumblend=25
set pumheight=30
set pyxversion=3
set redrawtime=2000
set regexpengine=2
set ruler
set scrollback=100000
set scrolljump=5
set scrolloff=8  " default: 0
set secure
set shada='20,<50,s10
set shiftround
set shiftwidth=2
set shortmess+=cI  " atOIc " default: filnxtToOF
set showfulltag
set showtabline=2
set sidescroll=1  " 0
set sidescrolloff=15  " 0
set signcolumn=yes:2
set sessionoptions=blank,buffers,curdir,folds,globals,help,resize,tabpages,terminal,winpos,winsize
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set suffixes+=.pyc
set switchbuf=uselast  " useopen
set synmaxcol=3000  " default: 3000, 0: unlimited, 400, 1500, 5000
set tabstop=2
set tagcase=smart
set tags=./tags;  " http://d.hatena.ne.jp/thinca/20090723/1248286959
set termguicolors
set textwidth=0
" set title
" set titlestring=%{getpid().':'.getcwd()}
set timeout         " mappnig timeout
set timeoutlen=200  " default: 1000
set ttimeout        " keycode timeout
set ttimeoutlen=20  " default: 50
set undodir=~/.local/share/nvim/undo
set undofile
set undolevels=100000
set updatetime=100  " default: 4000
set pumblend=15
set pumheight=30
set virtualedit=block
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png            " image
set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.out,*.class  " compiler
set wildignore+=*.swp,*.swo,*.swn                         " vim
set wildignore+=*/.git,*/.hg,*/.svn                       " vcs
set wildignore+=tags,*.tags                               " tags
set wildmenu
set wildmode=longest,full
set wildoptions=pum
set winblend=20
set wrap
set writebackup

set noautochdir
set nocursorcolumn
set nocursorline
set noerrorbells
set nofoldenable
set noignorecase
set noimdisable
set nojoinspaces
set nolist
set noshiftround
set noshowcmd
set noshowmatch
set noshowmode
set nospell
set noswapfile
set novisualbell
set nowrapscan

" -------------------------------------------------------------------------------------------------
" paths

if has('mac')
  set wildignore+=.DS_Store  " macOS only

  function! s:path_add_macos_headers()
    let s:clt_dir        = '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer'
    let s:sdk_dir        = s:clt_dir . '/SDKs/MacOSX.sdk'
    let s:macos_paths =
          \ expand($HOME) . '/.local/include'
          \ . ',/usr/local/include'
          \ . ',' . s:sdk_dir . '/usr/include'
          \ . ',' . s:clt_dir . '/usr/lib/clang/12.0.5/include'
          \ . ',' . s:clt_dir . '/usr/include/c++/v1'  " /Library/Developer/CommandLineTools/usr/include/c++/v1

    execute 'set path+=' . s:macos_paths
    " for l:d in ['MacOSX11.3.sdk', 'Xcode-beta', 'Xcode']
    if isdirectory(expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks/Xcode')
      execute 'set path+=' . expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks/Xcode'
    endif
    " endfor
  endfunction

  Gautocmdft c,cpp,objc,objcpp,go call s:path_add_macos_headers()  " only Go and C family filetypes
endif

function! s:go_include()
  if isdirectory('/usr/local/go/pkg/include')
    set path+=/usr/local/go/pkg/include
  endif
endfunction
Gautocmdft goasm call s:go_include()  " only Go filetype

function! s:path_add_python_headers()
  if isdirectory('/usr/local/Frameworks/Python.framework/Headers')
    set path+=/usr/local/Frameworks/Python.framework/Headers
  endif
endfunction
Gautocmdft c,cpp,objc,objcpp call s:path_add_python_headers()  " only Go and C family filetypes

function! s:go_pkg_hearder() abort
  if isdirectory('/usr/local/go/pkg/include')
    set path+=/usr/local/go/pkg/include
  endif
endfunction
Gautocmdft go,goasm call s:path_add_python_headers()  " only Go and goasm filetypes

if !exists("syntax_on")
  filetype plugin indent on
  syntax enable
endif
colorscheme equinusocio_material

let g:vimsyn_embed = 'lP'

" -------------------------------------------------------------------------------------------------
"" Neovim:

let g:termdebugger = '/usr/local/bin/gdb'
let g:termdebug_useFloatingHover = 1

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

" -------------------------------------------------------------------------------------------------
" Color:

"" Go:
let g:go_highlight_error = 1
let g:go_highlight_return = 0

"" C:
let g:c_ansi_constants = 1
let g:c_ansi_typedefs = 1
let g:c_comment_strings = 1
let g:c_gnu = 0
let g:c_no_curly_error = 1
let g:c_no_tab_space_error = 1
let g:c_no_trail_space_error = 1
let g:c_syntax_for_h = 0

" CPP:
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" Perl:
let perl_include_pod = 1
let perl_no_scope_in_variables = 0
let perl_no_extended_vars = 0
let perl_string_as_statement = 1
let perl_no_sync_on_sub = 0
let perl_no_sync_on_global_var = 0
let perl_sync_dist = 100

" -------------------------------------------------------------------------------------------------
" Gautocmd:

" Global:
Gautocmd InsertLeave * setlocal nopaste

" always jump to the last known cursor position
" - https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
function! s:autoJump()
  if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' && &filetype != 'gitrebase'
    execute "silent! keepjumps normal! g`\"zz"
  endif
endfunction
Gautocmd BufWinEnter * call s:autoJump()

" automatically close window
" - http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
function! s:autoClose()
  let s:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if winnr('$') == 1
    if s:ft == 'qf' || s:ft == 'git' ||  s:ft == 'vista_kind'
      quit!
    endif
  endif
endfunction
Gautocmd WinEnter * call s:autoClose()

" macOS Frameworks and system header protection
Gautocmd BufNewFile,BufReadPost /System/Library/*,/Applications/Xcode*,/usr/include*,/usr/lib* setlocal readonly nomodified

"" less like mapping:
function! LessMap()
  setlocal colorcolumn=""
  let b:gitgutter_enabled = 0
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
endfunction
Gautocmdft godoc://*,godoc,help,man,qf,quickrun,ref,fern call LessMap()  " less like keymappnig
Gautocmd BufEnter option-window,__LanguageClient__,__GO_TEST__ call LessMap()  " :option have not filetype


" Plugins:
"" Neosnippet:
" if dein#source('neosnippet.vim')
"   Gautocmd InsertLeave * NeoSnippetClearMarkers
" endif

"" Gina:
Gautocmd BufEnter gina://*:commit startinsert
Gautocmd BufEnter gina://* nnoremap <silent><buffer>q :q<CR>

"" Man:
Gautocmdft man://* nmap  <buffer><nowait>j  <Plug>(accelerated_jk_gj_position)
Gautocmdft man://* nmap  <buffer><nowait>k  <Plug>(accelerated_jk_gk_position)


" Language:
"" Go:

"" C:

"" Protobuf:

"" Dockerfile:

" Python:

" Vim:
"" nested autoload
Gautocmdft vim setlocal tags+=$XDG_DATA_HOME/nvim/tags/runtime.tags
Gautocmdft qf hi Search  gui=None  guifg=None  guibg=#373b41
Gautocmd BufEnter $XDG_CONFIG_HOME/alacritty/*.yml     silent! HexokinaseTurnOn
Gautocmd BufEnter $XDG_CONFIG_HOME/kitty/*.conf        silent! HexokinaseTurnOn
Gautocmd BufEnter $XDG_CONFIG_HOME/nvim/init.vim       silent! HexokinaseTurnOn
Gautocmd BufEnter **/colors/*.vim,**/colorscheme/*.vim silent! HexokinaseTurnOn
Gautocmd BufEnter *.svg                                silent! HexokinaseTurnOn

"" Gitcommit:
Gautocmd BufEnter COMMIT_EDITMSG  startinsert

"" Yaml:

"" Misc:
Gautocmdft jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000

" -------------------------------------------------------------------------------------------------
" Plugin Setting:

"" GoldenRatio:
let g:loaded_golden_ratio = v:true
let g:golden_ratio_autocommand = 1
let g:golden_ratio_exclude_nonmodifiable = 1
let g:golden_ratio_wrap_ignored = 0

"" LSP:
" LLVM Library Path
if isdirectory('/opt/llvm/devel')
  let s:llvm_base_path = '/opt/llvm/devel'
  let s:llvm_clang_version = '14.0.0'
elseif isdirectory('/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr')
  let s:llvm_base_path = '/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr'
  let s:llvm_clang_version = '13.0.0'
elseif isdirectory('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr')
  let s:llvm_base_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr'
  let s:llvm_clang_version = '13.0.0'
elseif isdirectory('/Library/Developer/CommandLineTools/usr')
  let s:llvm_base_path = '/Library/Developer/CommandLineTools/usr'
  let s:llvm_clang_version = '13.0.0'
else
  echoerr 'not found s:llvm_base_path and s:llvm_clang_version'
endif
" elseif isdirectory('/opt/llvm/stable')
"   let s:llvm_base_path = '/opt/llvm/stable'
"   let s:llvm_clang_version = '12.0.0'

if isdirectory('/Applications/Xcode-beta.app')
  let s:xcode_path = '/Applications/Xcode-beta.app'
elseif isdirectory('/Applications/Xcode.app')
  let s:xcode_path = '/Applications/Xcode.app'
endif

let s:clang_flags = [
      \ '-I'.s:llvm_base_path.'/include/c++/v1',
      \ '-I'.s:llvm_base_path.'/lib/clang'.s:llvm_clang_version.'/include',
      \ '-I/usr/local/include',
      \ '-I'.$SDKROOT.'/usr/include',
      \ '-F'.s:xcode_path.'/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks',
      \ '-F'.s:xcode_path.'/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks',
      \
      \ '-isystem '.s:llvm_base_path.'/lib/clang/14.0.0',
      \ '-isysroot'.$SDKROOT,
      \
      \ '-mmacosx-version-min=12.0',
      \ ]  " clang++ -v -E -x c++ - -v < /dev/null
      "\ '-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
      "\ '-I' . s:llvm_base_path . '/include/c++/v1',
      "\ '-I' . s:llvm_base_path . '/include/c++/v1',
      "\ '-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3',
      "\ '-isysroot/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk',
      "\ '-isystem ' . s:llvm_base_path . '/lib/clang/' . s:llvm_clang_version,

let g:clangd_commands_cfamily = [
      \ '/opt/llvm/devel/bin/clangd',
      \
      \ '--all-scopes-completion',
      \ '--clang-tidy',
      \ '--compile_args_from=filesystem',
      \ '--completion-parse=auto',
      \ '--completion-style=detailed',
      \ '--folding-ranges',
      \ '--ranking-model=decision_forest',
      \ '--function-arg-placeholders',
      \ '--header-insertion-decorators',
      \ '--header-insertion=iwyu',
      \ '--include-ineligible-results',
      \ '--j=20',
      \ '--offset-encoding=utf-16',
      \ '--pch-storage=memory',
      \ '--static-func-full-module-prefix',
      \ '--resource-dir=/opt/llvm/devel/lib/clang/14.0.0',
      \ ]  " --resource-dir: $ /opt/llvm/devel/bin/clang -print-resource-dir
      "\ '--resource-dir='.s:llvm_base_path.'/lib/clang/'.s:llvm_clang_version,
      "\ '--info-output-file=/tmp/clangd.info.log', '--input-mirror-file=/tmp/clangd.lsp.log', '--log=verbose', '--pretty', '--input-style=standard', '--offset-encoding=utf-8',

let g:c_cpp_root_path = ''
Gautocmdft c,cpp,objc,objcpp ++once let g:c_cpp_root_path = fnamemodify(trim(finddir('.git', '.;'), '.git'), ':p:h')

let g:did_server_commands_cfamily_setup = v:false
function! s:clangd_commands_cfamily_setup() abort
  if g:did_server_commands_cfamily_setup
    return
  endif
  let g:did_server_commands_cfamily_setup = v:true

  " clangd.dex
  if filereadable(getcwd() . 'clangd.dex')
    let g:clangd_commands_cfamily += ['--index-file=' . getcwd() . '/clangd.idx']
  elseif filereadable(g:c_cpp_root_path . '/clangd.idx')
    let g:clangd_commands_cfamily += ['--index-file=' . g:c_cpp_root_path . '/clangd.idx']
  elseif filereadable(g:c_cpp_root_path . '/build/clangd.idx')
    let g:clangd_commands_cfamily += ['--index-file=' . g:c_cpp_root_path . '/build/clangd.idx']
  elseif filereadable(getcwd() . '/../build/clangd.idx')
    let g:clangd_commands_cfamily += ['--index-file=' . getcwd() . '/../build/clangd.dex']

  " compile_commands.json
  elseif filereadable(glob("`find " . getcwd() . " -maxdepth 1 -type d -iwholename '*build*' `").'/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . glob("`find " . getcwd() . " -maxdepth 1 -type d -iwholename '*build*' `")]
  elseif filereadable(getcwd() . '/../build/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . getcwd() . '/../build']
  elseif filereadable('compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . getcwd()]
  elseif filereadable(g:c_cpp_root_path . '/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . g:c_cpp_root_path]
  elseif filereadable(g:c_cpp_root_path . '/build/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . g:c_cpp_root_path . '/build']
  elseif filereadable(g:c_cpp_root_path . '/out/Release/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . g:c_cpp_root_path . '/out/Release']
  else
    let g:clangd_commands_cfamily += ['--index']
  endif
endfunction
Gautocmdft c,cpp,objc,objcpp,cuda call s:clangd_commands_cfamily_setup()

let s:lsp_root_markers_cfamily = ['WORKSPACE', '.clang-format', 'autogen.sh', 'configure', 'compile_commands.json']
let s:lsp_root_markers_go = ['go.mod', 'vendor']
let s:lsp_root_markers_js = ['package.json', 'yarn.lock']
let s:lsp_root_markers_python = ['setup.py', 'pyproject.toml', 'tox.ini', '.flake8']
let s:lsp_root_markers_rust = ['Cargo.toml', 'build.rs', 'rustfmt.toml']
let s:lsp_root_markers = {
      \ 'c': s:lsp_root_markers_cfamily,
      \ 'cpp': s:lsp_root_markers_cfamily,
      \ 'go': s:lsp_root_markers_go,
      \ 'javascript': s:lsp_root_markers_js,
      \ 'lua': ['.git/'],
      \ 'objc': s:lsp_root_markers_cfamily,
      \ 'objcpp': s:lsp_root_markers_cfamily,
      \ 'python': s:lsp_root_markers_python,
      \ 'ruby': ['Gemfile', '.git'],
      \ 'rust': s:lsp_root_markers_rust,
      \ 'typescript': s:lsp_root_markers_js,
      \ 'yaml': ['.git'],
      \ }

"" GoNvimSP:
let g:nvim_lsp_server_commands = {
      \ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ 'gomod': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ 'gowork': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ }
      " \ 'go': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-logfile=/tmp/gopls.log', '-remote=unix;/tmp/gopls.sock'],
      " \ 'gomod': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-logfile=/tmp/gopls.log', '-remote=unix;/tmp/gopls.sock'],
      " \ 'gowork': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-logfile=/tmp/gopls.log', '-remote=unix;/tmp/gopls.sock'],
let g:nvim_lsp#server_options = {
     \ 'go': {
     \   'env': [
     \     'GOPRIVATE="github.com/kouzoh"',
     \   ]}
     \ }
Gautocmd BufRead $HOME/go/src/gvisor.dev/gvisor/* let g:nvim_lsp#server_options = { 'go': { 'env': [ 'GOOS=linux'] }}
" Gautocmd BufRead $HOME/go/src/go-darwin.dev/tools/**/* let g:nvim_lsp#server_options = { 'go': { 'env': [ 'CGO_CFLAGS=-march=native -isysroot/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -I/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/13.0.0/include -Wno-deprecated-declarations', 'GOFLAGS=-tags=', 'CGO_LDFLAGS=-lc++ ' . system("find /opt/llvm/devel/lib -type f -name '*.a' | tr '\n' ' '") . ' -L/usr/lib -lz -lncurses.5.4' ] }}
let g:nvim_lsp_server_auto_start = v:true
let g:nvim_lsp_server_restart_on_crash = v:true
let g:nvim_lsp_server_stderr = v:false
let g:nvim_lsp_change_throttle = 0.5
let g:nvim_lsp_diagnostics_list = 'location-list'
let g:nvim_lsp_enable_diagnostics = v:true
let g:nvim_lsp_hover_highlight = 'Normal:NormalFloat'
let g:nvim_lsp_logLevel = 'debug'
let g:nvim_lsp_root_markers = s:lsp_root_markers
let g:nvim_lsp_selection_ui_auto_open = v:true
let g:nvim_lsp_selection_ui_type = 'quickfix'
let g:nvim_lsp_settings_paths = [ '.nvim/settings.json', $XDG_CONFIG_HOME.'/nvim/lsp/settings.json' ]
let g:nvim_lsp_trace = 'verbose'
let g:nvim_lsp_use_virtual_text = v:true
" debug
let g:nvim_lsp_debug = v:false
let g:nvim_lsp_enable_otel = v:true
let g:nvim_lsp_enable_datadog_profile = v:true
let g:nvim_lsp_enable_gops = v:false

function! s:nvim_lsp_setup()
  setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
  nnoremap                 <silent><buffer><C-]>             :<C-u>call LSPTextDocumentDefinition('')<CR>
  nnoremap                 <silent><buffer><C-]>v            :<C-u>call LSPTextDocumentDefinition('vsplit')<CR>
  nmap                     <silent><buffer><LocalLeader>]    <Plug>(lcn-definition)
  nmap     <nowait><silent><buffer><Leader>e                 <Plug>(lcn-rename)
  nmap     <nowait><silent><buffer><Leader>gdh               <Plug>(lcn-highlight)
  nnoremap    <silent><buffer><LocalLeader>gh                :<C-u>call LanguageClient#textDocument_signatureHelp()<CR>
  nmap        <silent><buffer><LocalLeader>gi                <Plug>(nvim-lsp-textdocument-implementation)
  nmap        <silent><buffer><LocalLeader>gr                <Plug>(nvim-lsp-textdocument-references)
  nmap        <silent><buffer><LocalLeader>gs                <Plug>(nvim-lsp-textdocument-symbol)
  nmap        <silent><buffer><LocalLeader>gt                <Plug>(nvim-lsp-textdocument-typedefinition)
  nmap             <nowait><silent><buffer>K                 <Plug>(nvim-lsp-textdocument-hover)
endfunction
Gautocmdft go call s:nvim_lsp_setup()


"" LanguageClient:

" let g:LanguageClient_serverCommands = {
"       \ 'c': g:clangd_commands_cfamily,
"       \ 'cmake': ['cmake-language-server'],
"       \ 'cpp': g:clangd_commands_cfamily,
"       \ 'cython': ['/usr/local/share/pipx/pyls'],
"       \ 'dockerfile': ['docker-langserver', '--stdio'],
"       \ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
"       \ 'hcl': ['terraform-ls', 'serve', '-log-file=/tmp/terraform-ls.log', '-req-concurrency=10', '-tf-exec=/usr/local/opt/terraform/bin/terraform', '-tf-log-file=/tmp/terraform-ls.tf.log'],
"       \ 'java': ['jdtls', '-data', getcwd()],
"       \ 'javascript': ['javascript-typescript-stdio'],
"       \ 'json': ['vscode-json-languageserver', '--stdio'],
"       \ 'json5': ['vscode-json-languageserver', '--stdio'],
"       \ 'jsonc': ['vscode-json-languageserver', '--stdio'],
"       \ 'jsonschema': ['vscode-json-languageserver', '--stdio'],
"       \ 'lua': [s:srcpath_github . 'sumneko/lua-language-server/bin/macOS/lua-language-server', '-E', s:srcpath_github . 'sumneko/lua-language-server/main.lua', '--locale=en-us'],
"       \ 'objc': g:clangd_commands_cfamily,
"       \ 'objcpp': g:clangd_commands_cfamily,
"       \ 'python': ['/usr/local/share/pipx/pyls'],
"       \ 'rust': ['rustup', 'run', 'nightly', 'rust-analyzer'],
"       \ 'sh': ['bash-language-server', 'start'],
"       \ 'swift': ['sourcekit-lsp', '--build-path', $XDG_CACHE_HOME.'/sourcekit-lsp', '--configuration', 'release','--log-lvel', 'debug'],
"       \ 'terraform': ['terraform-ls', 'serve', '-log-file=/tmp/terraform-ls.log', '-req-concurrency=10', '-tf-exec=/usr/local/opt/terraform/bin/terraform', '-tf-log-file=/tmp/terraform-ls.tf.log'],
"       \ 'typescript': ['typescript-language-server', '--stdio', '--tsserver-path=/usr/local/var/nodebrew/current/bin/tsserver'],
"       \ 'vim': ['vim-language-server', '--stdio'],
"       \ 'zsh': ['bash-language-server', 'start'],
"       \ }
      "\ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock', '-logfile=/tmp/gopls-lcn.log'],
      "\ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      "\ 'go': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-remote=unix;/tmp/gopls.sock', '-logfile=/tmp/gopls-lcn.log'],
      "\ 'go': [s:gopath . '/bin/gopls'],
      "\ 'go': [s:gopath . '/bin/gopls'],
      "\ 'lua': ['java', '-cp', '/usr/local/share/java/EmmyLua/EmmyLua-LS-all.jar', 'com.tang.vscode.MainKt'],
      "\ 'lua': ['lua-lsp'],
      "\ 'lua': [s:srcpath_github . 'sumneko/lua-language-server/bin/macOS/lua-language-server', '-E', s:srcpath_github . 'sumneko/lua-language-server/main.lua', '--logpath=/tmp/lualsp.log'],
      "\ 'proto': [s:gopath . '/bin/protocol-buffers-language-server'],
      "\ 'python': ['/usr/local/share/pipx/pyls', '--log-file=/tmp/pyls.log', '--verbose'],
      "\ 'python': ['/usr/local/share/pipx/pyls', '--log-file=/tmp/pyls.log', '--verbose'],
      "\ 'python': ['/usr/local/share/pipx/pyls'],
      "\ 'python': ['/usr/local/share/pipx/pyls'],
      "\ 'python': ['pyright-langserver', '--stdio'],
      "\ 'ruby': ['solargraph', 'stdio'],
      "\ 'rust': ['/usr/local/rust/cargo/bin/rustup', 'run', 'nightly', 'rls'],
      "\ 'rust': ['rustup', 'run', 'nightly', 'rust-analyzer', '-vv', '--log-file=/tmp/rust-analyzer.log'],
      "\ 'swift': ['/usr/local/bin/sourcekit-lsp'],
      "\ 'yaml': ['yaml-language-server', '--stdio'],
      "\ 'yaml.docker-compose': ['yaml-language-server', '--stdio'],
      "\ 'zsh': ['bash-language-server', 'start'],

" let g:LanguageClient_diagnosticsSignsMax                = v:null
" let g:LanguageClient_changeThrottle                     = 0.5  " default: v:null, 0.5
" let g:LanguageClient_autoStart                          = 0
" let g:LanguageClient_autoStop                           = 1
" let g:LanguageClient_selectionUI                        = 'location-list'  " fzf, quickfix, location-list
" let g:LanguageClient_selectionUI_autoOpen               = 1
" let g:LanguageClient_trace                              = 'off'  " 'verbose'
" let g:LanguageClient_diagnosticsList                    = 'Disabled'  " default: Quickfix, Location, Disabled
" let g:LanguageClient_diagnosticsEnable                  = 0
" let g:LanguageClient_windowLogMessageLevel              = 'Error'  " default: Warning, available: 'Error' 'Warning' 'Info' 'Log'
" let g:LanguageClient_settingsPath                       = [ '.nvim/lcn.json', $XDG_CONFIG_HOME.'/nvim/lsp/lcn.json' ]
" let g:LanguageClient_loadSettings                       = 1
" let g:LanguageClient_rootMarkers                        = s:lsp_root_markers
" let g:LanguageClient_fzfOptions                         = v:null
" let g:LanguageClient_hasSnippetSupport                  = 0
" let g:LanguageClient_waitOutputTimeout                  = 0  " default: 10
" let g:LanguageClient_hoverPreview                       = 'Always'  " Always, Auto, Never
" let g:LanguageClient_fzfContextMenu                     = 0
" let g:LanguageClient_completionPreferTextEdit           = 1
" let g:LanguageClient_useVirtualText                     = "All"
" let g:LanguageClient_useFloatingHover                   = 1
" let g:LanguageClient_floatingHoverHighlight             = 'Normal:HoverFloat'
" let g:LanguageClient_virtualTextPrefix                  = ''
" let g:LanguageClient_diagnosticsMaxSeverity             = 'Hint'  " Default: 'Hint', 'Error' 'Warning' 'Information' 'Hint'
" let g:LanguageClient_echoProjectRoot                    = 1
" let g:LanguageClient_semanticHighlightMaps              = {}
" let g:LanguageClient_applyCompletionAdditionalTextEdits = 0
" let g:LanguageClient_preferredMarkupKind                = [ 'plaintext', 'markdown' ]
" Gautocmdft go,python,yaml,zsh let g:LanguageClient_diagnosticsEnable = 0
" Gautocmdft go let g:LanguageClient_autoStop = 0
" Gautocmdft rust call LanguageClient#startServer()  " why?
" debug
" let g:LanguageClient_serverStderr = '/tmp/lcn.server.log'
" let g:LanguageClient_loggingFile  = '/tmp/lcn.server.log'
" let g:LanguageClient_loggingLevel = 'DEBUG'  " default: WARN

" function! s:languageclient_settings_setup()
"   let g:lcn_settings = ''
"   let g:lcn_settings_filepath = '/.nvim/lcn.json'
"   if filereadable(getcwd() . g:lcn_settings_filepath)
"     let g:lcn_settings = json_decode(readfile(getcwd() . g:lcn_settings_filepath))
"   endif
" 
"   if !empty(g:lcn_settings)
"     Gautocmd User LanguageClientTextDocumentDidOpenPost call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': g:lcn_settings })  " workspace/configuration, workspace/didChangeConfiguration, LanguageClientStarted, LanguageClientTextDocumentDidOpenPost
"   endif
" endfunction
" Gautocmdft go,c,cmake,cpp,dockerfile,hcl,java,javascript,json,jsonc,jsonschema,lua,objc,objcpp,proto,python,ruby,rust,sh,swift,terraform,typescript,vim call s:languageclient_settings_setup()

" function! LanguageClientCallback(output, ...) abort
"   normal! zz
" endfunction

" function! s:languageclient_mapping_setup()
"   " if &filetype ==# 'ruby'
"   "   nnoremap              <silent><buffer><C-]>v             :<C-u>call LanguageClient#textDocument_definition({'handle': v:true}, function('LanguageClientCallback'))<CR>
"   " else
"   "   nnoremap              <silent><buffer><C-]>              :<C-u>call LanguageClient#textDocument_definition({'handle': v:true}, function('LanguageClientCallback'))<CR>
"   "   nnoremap              <silent><buffer><C-]>v             :<C-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit', 'handle': v:true}, function('LanguageClientCallback'))<CR>
"   " endif
"   nnoremap              <silent><buffer><C-]>              :<C-u>call LanguageClient#textDocument_definition({'handle': v:true}, function('LanguageClientCallback'))<CR>
"   nnoremap              <silent><buffer><C-]>v             :<C-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit', 'handle': v:true}, function('LanguageClientCallback'))<CR>
"   nmap          <nowait><silent><buffer><Leader>e          <Plug>(lcn-rename)
"   nnoremap              <silent><buffer><LocalLeader>gh    :<C-u>call LanguageClient#textDocument_signatureHelp()<CR>
"   nmap                  <silent><buffer><LocalLeader>gdh   <Plug>(lcn-highlight)
"   nmap                  <silent><buffer><LocalLeader>gi    <Plug>(lcn-implementation)
"   nmap                  <silent><buffer><LocalLeader>gr    <Plug>(lcn-references)
"   nmap                  <silent><buffer><LocalLeader>gs    <Plug>(lcn-symbols)
"   nnoremap              <silent><buffer><LocalLeader>gt    :<C-u>call LanguageClient#textDocument_typeDefinition({'handle': v:true}, function('LanguageClientCallback'))<CR>
"   nmap          <nowait><silent><buffer>K                  <Plug>(lcn-hover)
"   setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" endfunction
" Gautocmdft c,cmake,cpp,dockerfile,hcl,java,javascript,json,jsonc,jsonschema,lua,objc,objcpp,proto,python,rust,sh,swift,terraform,typescript,vim call s:languageclient_mapping_setup()
" Gautocmd BufRead,BufNewFile $HOME/src/github.com/neovim/neovim/runtime/lua/vim/* let g:LanguageClient_rootMarkers['lua'] = ['lsp.lua']

"" Deoplete:
" let g:deoplete#enable_at_startup = 0

" let s:default_ignore_sources = ['ale', 'around', 'denite', 'file_include', 'floaterm', 'lsp', 'member', 'omni', 'tabnine', 'tag']
" let s:deoplete_custom_option = {
"       \ 'auto_preview': v:true,
"       \ 'auto_complete': v:true,
"       \ 'auto_complete_delay': 0,
"       \ 'auto_complete_popup': 'auto',
"       \ 'auto_refresh_delay': 50,
"       \ 'camel_case': v:true,
"       \ 'check_stderr': v:false,
"       \ 'complete_suffix': v:true,
"       \ 'ignore_case': &ignorecase,
"       \ 'ignore_sources': {
"       \   '_': ['ale', 'around', 'floaterm', 'lsp', 'member', 'omni', 'tabnine', 'tag'],
"       \   'c': s:default_ignore_sources,
"       \   'cpp': s:default_ignore_sources,
"       \   'dockerfile': s:default_ignore_sources,
"       \   'go': s:default_ignore_sources+['buffer'],
"       \   'javascript': s:default_ignore_sources,
"       \   'lua': s:default_ignore_sources,
"       \   'objc': s:default_ignore_sources+['buffer'],
"       \   'proto': s:default_ignore_sources,
"       \   'python': s:default_ignore_sources,
"       \   'rust': s:default_ignore_sources,
"       \   'sh': s:default_ignore_sources,
"       \   'swift': s:default_ignore_sources,
"       \   'TelescopePrompt': s:default_ignore_sources+['buffer', 'neosnippet'],
"       \   'typescript': s:default_ignore_sources,
"       \   'yaml': s:default_ignore_sources,
"       \   'yaml.docker-compose': s:default_ignore_sources+['buffer'],
"       \   'zsh': s:default_ignore_sources,
"       \ },
"       \ 'max_list': 10000,
"       \ 'min_pattern_length': 1,
"       \ 'num_processes': 1,
"       \ 'on_insert_enter': v:true,
"       \ 'on_text_changed_i': v:true,
"       \ 'prev_completion_mode': 'none',
"       \ 'profile': v:false,
"       \ 'refresh_always': v:true,
"       \ 'refresh_backspace': v:true,
"       \ 'skip_multibyte': v:false,
"       \ 'smart_case': &smartcase,
"       \ 'trigger_key': v:char,
"       \ }

" call deoplete#custom#option(s:deoplete_custom_option)
" Gautocmdft python call deoplete#custom#option('ignore_sources', { 'python': ['ale', 'around', 'dictionary', 'floaterm', 'lsp', 'member', 'omni', 'tag'] })
" call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])  " matcher_fuzzy, matcher_full_fuzzy, matcher_cpsm, matcher_head, matcher_length
" call deoplete#custom#source('_', 'sorters', ['sorter_rand', 'sorter_word'])  " 'sorter_word', 'sorter_rand'
" call deoplete#custom#source('_', 'converters', ['converter_auto_paren', 'converter_remove_overlap'])
" 
" call deoplete#custom#source('buffer', 'rank', 100)
" call deoplete#custom#source('file', 'rank', 150)
" call deoplete#custom#source('file', 'enable_buffer_path', v:true)
" call deoplete#custom#source('file', 'enable_slash_completion', v:true)
" call deoplete#custom#source('file', 'force_completion_length', -1)
" 
" call deoplete#custom#source('LanguageClient', 'matchers', [])
" call deoplete#custom#source('LanguageClient', 'sorters', [])
" call deoplete#custom#source('LanguageClient', 'max_candidates', 1000)
" call deoplete#custom#source('LanguageClient', 'converters', ['converter_auto_paren_lsp', 'converter_auto_paren'])
" Gautocmdft json,jsonschema,yaml call deoplete#custom#source('LanguageClientInternal', 'min_pattern_length', 0)
" 
" call deoplete#custom#source('asm', 'rank', 1000)
" 
" call deoplete#custom#source('python', 'refresh_always', v:false)
" 
" call deoplete#custom#source('neosnippet', 'rank', 500)
" call deoplete#custom#source('neosnippet', 'rank', 500)
" call deoplete#custom#source('neosnippet', 'min_pattern_length', 2)
" call deoplete#custom#source('neosnippet', 'converters', ['converter_auto_paren', 'converter_remove_overlap'])
" 
" call deoplete#custom#source('zsh', 'filetypes', ['sh', 'zsh'])

" source
"" cgo
let g:deoplete#sources#cgo#libclang_library_path = s:llvm_base_path.'/lib/libclang.dylib'
let g:deoplete#sources#cgo#sort_algo = 'alphabetical'
"" go
let g:deoplete#sources#go#gocode_binary = s:gopath.'/bin/gocode'
let g:deoplete#sources#go#auto_goos = 0
let g:deoplete#sources#go#pointer = 0
let g:deoplete#sources#go#cgo = 1
let g:deoplete#sources#go#cgo_only = 1
let g:deoplete#sources#go#cgo#flags = s:clang_flags
let g:deoplete#sources#go#cgo#libclang_path = s:llvm_base_path.'/lib/libclang.dylib'
let g:deoplete#sources#go#cgo#sort_algo = 'priority'  " 'priority', 'alphabetical'
"" jedi
let g:deoplete#sources#jedi#statement_length = 0
let g:deoplete#sources#jedi#short_types = 0
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#enable_typeinfo = 1
let g:deoplete#sources#jedi#ignore_errors = 1
let g:deoplete#sources#jedi#extra_path = []
let g:deoplete#sources#jedi#python_path = g:python3_host_prog
" asm
Gautocmdft goasm let g:deoplete#sources#asm#go_mode = 1
" debug
let s:deoplete_debug_mode = ''
let s:deoplete_profile_mode = v:false
if !empty(s:deoplete_debug_mode)
  call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')
  call deoplete#custom#source(s:deoplete#debugmode, 'is_debug_enabled', v:true)

  if get(s:, 'deoplete_profile_mode', v:false)
    call deoplete#custom#option('profile', v:true)
  endif
endif

" neosnippet
let g:neosnippet#data_directory = $XDG_CACHE_HOME . '/nvim/neosnippet'
let g:neosnippet#disable_select_mode_mappings = 0
let g:neosnippet#enable_auto_clear_markers = 1
let g:neosnippet#enable_complete_done = 0
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#expand_word_boundary = 0
let g:neosnippet#snippets_directory = $XDG_CONFIG_HOME . '/nvim/neosnippets'
let g:neosnippet_username = 'zchee'
let g:neosnippet_author = 'Koichi Shiraishi'
" echodoc
" Gautocmd BufWinEnter * call echodoc#enable()
" let g:echodoc#events = ['CompleteDone']            " default
" let g:echodoc#type = 'virtual'                     " echo, signature, virtual, floating
" let g:echodoc#highlight_identifier = 'Identifier'  " default
" let g:echodoc#highlight_arguments = 'Special'      " default
" let g:echodoc#highlight_trailing = 'Type'          " default
" let g:echodoc_max_blank_lines = 3                  " hidden params
" highlight link EchoDocFloat HoverFloat
" neopairs
let g:neopairs#enable = 1
" let g:neopairs#pairs = { '[': ']', '<': '>', '(': ')', '{': '}', '"': '"' }

"" Denite:
" call denite#custom#option('_', {
"       \ 'auto_action': "",
"       \ 'auto_resize': v:false,
"       \ 'buffer_name': 'default',
"       \ 'cursor_pos': '',
"       \ 'cursorline': v:true,
"       \ 'default_action': 'default',
"       \ 'direction': 'botright',
"       \ 'do': '',
"       \ 'empty': v:false,
"       \ 'highlight_filter_background': 'NormalFloat',
"       \ 'highlight_matched_char': 'Search',
"       \ 'highlight_matched_range': 'Underlined',
"       \ 'highlight_preview_line': 'Search',
"       \ 'highlight_prompt': 'Special',
"       \ 'highlight_window_background': 'NormalFloat',
"       \ 'ignorecase': v:false,
"       \ 'immediately': v:false,
"       \ 'immediately_1': v:false,
"       \ 'matchers': 'matcher/fuzzy',
"       \ 'prompt': '>',
"       \ 'sorter': 'sorter/sublime',
"       \ 'split': 'floating',
"       \ 'filter_split_direction': 'floating',
"       \ 'vertical_preview': v:true,
"       \ 'floating_preview': v:true,
"       \ 'smartcase': v:false,
"       \ 'statusline': v:true,
"       \ 'unique': v:true,
"       \ 'winheight': 20,
"       \ })
let s:denite_file_rec_command = ['fd', '.', '--threads=20', '--follow', '--hidden', '--no-ignore', '--full-path', '--color=never', '--type=f',
      \ '-E', '.git/',
      \ '-E', 'node_modules/',
      \ '-E', '.idea/',
      \ '-E', 'vendor/',
      \ '-E', '*.bak',
      \ '-E', '*.o',
      \ '-E', '*.obj',
      \ '-E', '*.pdb',
      \ '-E', '*.exe',
      \ '-E', '*.bin',
      \ '-E', '*.dll',
      \ '-E', '*.a',
      \ '-E', '*.lib',
      \ '-E', '.gitignore',
      \ '-E', '_tmp/',
      \ '-E', '.*.*',
      \ ]
" call denite#custom#var('file/rec', 'command', s:denite_file_rec_command)
" call denite#custom#var('file/rec', 'cache_threshold', 100000)
" call denite#custom#option('file/rec', 'expand', v:true)

" call denite#custom#alias('source', 'grep/rg', 'grep')
" call denite#custom#alias('source', 'grep/ugrep', 'grep')
" call denite#custom#var('grep/ugrep', {
"  \ 'command': ['ug'],
"  \ 'default_opts': ['--color=never', '--no-heading', '--hidden', '--ignore-binary', '--ignore-case', '--no-ignore-files', '--column-number', '--mmap', '--line-number', '--no-group-separator', '--recursive', '--tabs=1', '-J20'],
"  \ 'recursive_opts': [],
"  \ 'pattern_opt': [],
"  \ 'separator': ['--'],
"  \ 'final_opts': [],
"  \ })
" call denite#custom#var('grep/rg', {
"  \ 'command': ['rg'],
"  \ 'default_opts': ['-i', '--no-config', '--no-ignore-vcs', '--threads=20', '--mmap', '--hidden', '--no-heading', '--vimgrep'],
"  \ 'recursive_opts': [],
"  \ 'pattern_opt': ['--regexp'],
"  \ 'separator': ['--'],
"  \ 'final_opts': [],
"  \ })

"" map
function! DeniteActionZZ() abort
  normal! zz
endfunction
function! s:denite_mapping() abort
  nnoremap <silent><buffer>      <C-c>  :<C-u>quit<CR>
  nnoremap <silent><buffer><expr><C-v>  denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr><CR>   denite#do_map('do_action')
  nnoremap <silent><buffer>      q      :<C-u>quit<CR>
  nnoremap <silent><buffer><expr>i      denite#do_map('open_filter_buffer')

  inoremap <silent><buffer><expr><C-c>  denite#do_map('quit')
endfunction
" Gautocmdft denite call s:denite_mapping()

"" filter
" call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
"       \ ['*~', '*.o', '*.exe', '*.bak', '.DS_Store', '*.pyc', '*.sw[po]', '*.class', '.hg/', '.git/', '.bzr/', '.svn/', 'tags', 'tags-*', '.ropeproject/', '__pycache__/', 'venv/', 'images/', '*.min.*', 'img/', 'fonts/', 'node_modules/', '_tmp/'])


"" Defx:
" call defx#custom#option('_', {
"       \ 'columns': 'icons:indent:git:indent:filename:type',
"       \ 'ignored_files': '.git,.DS_Store,*.pyc,__pycache__',
"       \ })
let g:defx_git#indicators = {
      \ 'Modified'  : '✹',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Ignored'   : '☒',
      \ 'Deleted'   : '✖',
      \ 'Unknown'   : '?'
      \ }

function! s:defx_settings() abort
  nnoremap <silent><buffer><expr>*       defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr>-       defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr>.       defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr>c       defx#do_action('copy')
  nnoremap <silent><buffer><expr>C       defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr>cd      defx#do_action('change_vim_cwd')
  nnoremap <silent><buffer><expr>d       defx#do_action('remove')
  nnoremap <silent><buffer><expr>j       'j'
  nnoremap <silent><buffer><expr>K       defx#do_action('new_directory')
  nnoremap <silent><buffer><expr>k       'k'
  nnoremap <silent><buffer><expr>o       defx#do_action('open')
  nnoremap <silent><buffer><expr>m       defx#do_action('move')
  nnoremap <silent><buffer><expr>n       defx#do_action('new_file')
  nnoremap <silent><buffer><expr>N       defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr>p       defx#do_action('paste')
  nnoremap <silent><buffer><expr>P       defx#do_action('preview')
  nnoremap <silent><buffer><expr>q       defx#do_action('quit')
  nnoremap <silent><buffer><expr>r       defx#do_action('rename')
	nnoremap <silent><buffer><expr>s       defx#do_action('multi', [['drop', 'split'], 'quit'])
  nnoremap <silent><buffer><expr>S       defx#do_action('toggle_sort', 'time')
	nnoremap <silent><buffer><expr>v       defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
  nnoremap <silent><buffer><expr>x       defx#do_action('execute_system')
  nnoremap <silent><buffer><expr>yy      defx#do_action('yank_path')

  nnoremap <silent><buffer><expr><CR>    defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr><Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr><Down>  'j'
  nnoremap <silent><buffer><expr><Up>    'k'
  nnoremap <silent><buffer><expr><Left>  defx#do_action('close_tree')
  nnoremap <silent><buffer><expr><Right> defx#do_action('open_tree')

  nnoremap <silent><buffer><expr><C-g>   defx#do_action('print')
  nnoremap <silent><buffer><expr><C-l>   defx#do_action('redraw')
endfunction
" Gautocmdft defx call s:defx_settings()


"" VimSpector:
let g:vimspector_base_dir = expand('$XDG_CONFIG_HOME/nvim/vimspector')


"" FloatTerm:
let g:floaterm_keymap_toggle = '<F10>'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9


"" Vista:
let g:vista#renderer#enable_icon = 1
let g:vista_blink = [0, 0]
let g:vista_cursor_delay = 400  " default
let g:vista_default_executive = 'lcn'
let g:vista_disable_statusline = 0
let g:vista_echo_cursor_strategy = 'floating_win'  " echo, scroll, floating_win, both
let g:vista_executive_for = {
      \ 'go': 'lcn',
      \ 'markdown': 'toc',
      \ }
let g:vista_sidebar_width = '150'
function! s:open_vista(mode)
  if len(a:mode)
    let l:save_vista_default_executive = g:vista_default_executive
    let g:vista_default_executive = a:mode
  endif

  Vista!!
  call timer_start(500, {-> execute('wincmd W')}, {'repeat': 1})

  if get(l:, 'save_vista_default_executive', 0)
    let g:vista_default_executive = l:save_vista_default_executive
  endif
endfunction
command! -nargs=* VistaOpen call s:open_vista(<q-args>)


" Ale:
"" ale-lint-file-linters
let g:ale_set_highlights = 0
let g:ale_set_balloons = 0

" ale-options
let g:airline#extensions#ale#enabled = 0
let g:ale_cache_executable_check_failures = 1
let g:ale_change_sign_column_color = 0
let g:ale_close_preview_on_inlet = 0
let g:ale_completion_enabled = 0
let g:ale_cursor_detail = 0
let g:ale_disable_lsp = 1
let g:ale_echo_cursor = 1
let g:ale_echo_delay = 10
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_enabled = 1
let g:ale_fix_on_save = 0
let g:ale_hover_to_preview = 0
let g:ale_keep_list_window_open = 0
let g:ale_list_window_size = 10
let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_linters_explicit = 1
let g:ale_max_signs = -1
let g:ale_open_list = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_shell = 'bash'
let g:ale_sign_column_always = 1
let g:ale_sign_highlight_linenrs = 1
let g:ale_update_tagstack = 0
let g:ale_use_global_executables = 1
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_delay = 10
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_linter_aliases = {
      \ 'zsh': 'sh',
      \ }
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'markdown': [],
      \ }
let g:ale_linters = {}  " initialize
let g:ale_pattern_options = {}

" :help ale-other-integration-options
"" Go:
let g:ale_linters.go = []  " ['gobuild', 'gopls', 'govet', 'staticcheck']  let g:ale_linters.go = ['gobuild', 'gofmt, 'golangci-lint'', 'golint', 'gopls', 'govet', 'staticcheck']
let g:ale_go_go111module = 'on'
let g:ale_go_golangci_lint_executable = s:gopath . 'bin/golangci-lint'
let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 0
let g:ale_go_golint_executable = s:gopath . 'bin/golint'
let g:ale_go_golint_options = ''
let g:ale_go_gopls_executable = s:gopath . '/bin/gopls'
let g:ale_go_gopls_options = ''
let g:ale_go_govet_options = ''
let g:ale_go_staticcheck_options = ''
let g:ale_go_staticcheck_lint_package = 0

"" CFamily:
""" global
let g:ale_c_build_dir_names = ['build']
let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 0
let s:ale_linters_c_cpp = ['clangd', 'clang-format', 'clangcheck']  " 'clangd', 'clangtidy', 'cppcheck', 'clangcheck'
let s:ale_c_cpp_clangd_executable = s:llvm_base_path . '/bin/clang'
let s:ale_c_cpp_clangd_options = g:clangd_commands_cfamily[1:len(g:clangd_commands_cfamily)]
let s:ale_c_cpp_clangformat_executable = s:llvm_base_path . '/bin/clang-format'
let s:ale_c_cpp_clangtidy_executable = s:llvm_base_path . '/bin/clang-tidy'

"" C:
let g:ale_linters.c = s:ale_linters_c_cpp
""" cc
let g:ale_c_cc_executable = s:llvm_base_path . '/bin/clang'
let g:ale_c_cc_options = '-std=c17 -Wall'
""" clangd
let g:ale_c_clangd_executable = s:ale_c_cpp_clangd_executable
let g:ale_c_clangd_options = s:ale_c_cpp_clangd_options
""" clang-format
let g:ale_c_clangformat_executable = s:ale_c_cpp_clangformat_executable
let g:ale_c_clangformat_use_local_file = 1
""" clang-tidy
let g:ale_c_clangtidy_checks = []
let g:ale_c_clangtidy_executable = s:ale_c_cpp_clangtidy_executable
let g:ale_c_clangtidy_options = ''
let g:ale_c_clangtidy_extra_options = ''
let g:ale_c_clangtidy_fix_errors = 1

"" CPP:
let g:ale_linters.cpp = s:ale_linters_c_cpp
""" cc
let g:ale_cpp_cc_executable = s:llvm_base_path . '/bin/clang++'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
""" clang-check
let g:ale_cpp_clangcheck_executable = s:llvm_base_path . '/bin/clang-check'
let g:ale_cpp_clangcheck_options = ''
""" clangd
let g:ale_cpp_clangd_executable = s:ale_c_cpp_clangd_executable
let g:ale_cpp_clangd_options = s:ale_c_cpp_clangd_options
""" clang-tidy
let g:ale_cpp_clangtidy_checks = []
let g:ale_cpp_clangtidy_executable = s:ale_c_cpp_clangtidy_executable
let g:ale_cpp_clangtidy_options = ''
let g:ale_cpp_clangtidy_extra_options = ''
let g:ale_cpp_clangtidy_fix_errors = 1

"" Python:
let g:ale_linters.python = ['black', 'pyright']  " ['flake8', 'pylint', 'pyls', 'mypy']
let g:ale_python_black_executable = 'black'
let g:ale_python_pyright_executable = '/usr/local/var/nodebrew/current/bin/pyright-langserver'
let g:ale_python_pyright_config = {
      \ 'python': {
      \   'pythonPath': g:python3_host_prog,
      \ },
      \}
let g:ale_python_pyright_config = {
      \ 'pyright': {
      \   'disableLanguageServices': v:false,
      \ },
      \}

"" Dockerfile:
" let g:ale_linters.dockerfile = ['hadolint']
let g:ale_dockerfile_hadolint_use_docker = 'never'

"" Markdown:
let g:ale_linters.markdown = ['textlint']

"" Protobuf:
let g:ale_linters.proto = ['api-linter']  " ['buf-check-lint', 'prototool-all']  'api_linter', 'protoc-gen-lint', 'prototool', 'prototool-compile', 'prototool-lint'
let g:ale_proto_api_linter_options = []
let g:ale_proto_api_linter_config_path = '.api-linter.yaml'
let g:ale_proto_api_linter_include_paths = ['.', 'third_party/googleapis']

"" Rust:
let g:ale_linters.rust = ['cargo']

"" Sh:
let g:ale_linters.sh = ['shellcheck', 'shfmt']  " 'shell', 'bashate', 'sh-language-server'
""" ShLanguageServer:
let g:ale_sh_language_server_executable = 'bash-language-server'
let g:ale_sh_language_server_use_global = 1
""" Shell:
let g:ale_sh_shell_default_shell = 'bash'
""" Shellcheck:
let g:ale_sh_shellcheck_executable = 'shellcheck'
let g:ale_sh_shellcheck_options = '-x --color=never --severity=style --wiki-link-count=10'
let g:ale_sh_shellcheck_exclusions = 'SC1072,SC1090,SC1091'
let g:ale_sh_shellcheck_change_directory = 1  " default
""" ShFmt:
let g:ale_sh_shfmt_options = '-bn -ci -sr -i 2'

"" Terraform:
let g:ale_linters.terraform = ['fmt', 'tflint']
let g:ale_terraform_fmt_executable = 'terraform'
let g:ale_terraform_fmt_options = ''
let g:ale_terraform_tflint_executable = s:gopath . '/bin/tflint'
let g:ale_terraform_tflint_options = '-f json'

"" Yaml:
let g:ale_linters.yaml = ['yamllint']
let s:yamllint_config_file = ''
if exists("$YAMLLINT_CONFIG_FILE")
  let s:yamllint_config_file = '--config-file=' . expand('$YAMLLINT_CONFIG_FILE')
else
  let g:yamllint_filepath = findfile(fnamemodify(resolve(expand('%')), ':p:h') . '/.yamllint.yaml', '.;')
  if filereadable(g:yamllint_filepath)
    let s:yamllint_config_file = '--config-file=' . g:yamllint_filepath
  endif
endif
let g:ale_yaml_yamllint_options = '--strict ' . s:yamllint_config_file

"" Zsh:
Gautocmdft zsh let b:ale_sh_shellcheck_exclusions = 'SC1071'

let g:ale_linters.css = ['stylelint']


" Caw:
let g:caw_hatpos_skip_blank_line = 0
let g:caw_no_default_keymappings = 1
let g:caw_operator_keymappings = 0


" VimDevIcons:
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 0
let g:webdevicons_enable_denite = 1
let g:webdevicons_enable_unite = 0
let g:webdevicons_enable_vimfiler = 0
let g:webdevicons_enable_ctrlp = 0
let g:webdevicons_enable_airline_statusline = 0
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0
let g:webdevicons_enable_airline_tabline = 0
let g:webdevicons_enable_flagship_statusline = 0
let g:webdevicons_enable_flagship_statusline_fileformat_symbols = 0
let g:webdevicons_enable_startify = 0
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:DevIconsAppendArtifactFix = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderPatternMatching = 0
let g:DevIconsEnableFolderExtensionPatternMatching = 1
let g:WebDevIconsUnicodeDecorateFolderNodesExactMatches = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1


" LightLine:
" https://donniewest.com/a-guide-to-basic-neovim-plugins
let g:lightline = {}
let g:lightline.colorscheme = 'equinusocio_material'

function! s:quickfix_get_type()
  if exists("*win_getid") && exists("*getwininfo")
    let dict = getwininfo(win_getid())
    if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
      return 'QuickFix'
    elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
      return 'LocationList'
    endif
  endif
  redir => buffers
  silent ls
  redir END
  let nr = bufnr('%')
  for buf in split(buffers, '\n')
    if match(buf, '\v^\s*'.nr) > -1
      if match(buf, '\cQuickfix') > -1
        return 'QuickFix'
      else
        return 'LocationList'
      endif
    endif
  endfor
  return ''
endfunction
function! LightlineMode()
  return &buftype ==# 'quickfix' ? s:quickfix_get_type() : lightline#mode()
endfunction
function! LightlineFilename()
  if &buftype ==# 'quickfix'
    return get(w:, "quickfix_title", "")
  endif
  let filename = expand('%:p') !=# '' ? expand('%:p') : '[No Name]'
  " let modified = &modified ? ' +' : ''
  let modified = &modified ? ' +' : &modifiable ? '' : ' -'
  " return filename
  return filename . modified
endfunction
function! LightlineModified()
  hi ModifiedColor guifg=#cf6a4c guibg=#373b41 gui=Bold
  return &modified ? ' +' : &modifiable ? '' : ' -'
endfunction
function! DeviconsGetFileTypeSymbol()
  return strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft'
endfunction
function! DeviconsGetFileFormatSymbol()
  return &fileformat . ' ' . WebDevIconsGetFileFormatSymbol()
endfunction
function! LightlineGitBranch()
  let l:branch_mark = ' '
  " if dein#tap('gina.vim')
  "   let l:branch_mark = ' ' . gina#component#repo#branch()
  " endif
  return l:branch_mark
endfunction
function! LightlineNearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
function! LanguageClientStatusLine() abort
  let l:diagnosticsDict = LanguageClient#statusLineDiagnosticsCounts()
  let l:errors          = get(l:diagnosticsDict, 'E', 0)
  let l:warnings        = get(l:diagnosticsDict, 'W', 0)
  let l:informations    = get(l:diagnosticsDict, 'I', 0)
  let l:hints           = get(l:diagnosticsDict, 'H', 0)
  return l:errors + l:warnings + l:informations + l:hints == 0 ? "✔ " : "E:" . l:errors . " " . "W :" . l:warnings . "I:" . l:informations . " " . "H:" . l:hints
endfunction

let g:lightline.component = {
      \ 'absolutepath': '%F',
      \ 'bufnum': '%n',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'close': '%999X X ',
      \ 'column': '%c',
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'filename': '%{LightlineFilename()}',
      \ 'modified': '%{LightlineModified()}',
      \ 'line': '%l',
      \ 'lineinfo': '%3l  %-2v',
      \ 'mode': '%{lightline#mode()}',
      \ 'method': '%{LightlineNearestMethodOrFunction()}',
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
      \ 'language_client_statusline': 'LanguageClientStatusLine',
      \ }
let g:lightline.component_type = {
      \ 'modified': 'raw',
      \ 'linter_checking': 'left',
      \ 'linter_errors': 'error',
      \ 'linter_ok': 'left',
      \ 'linter_warnings': 'warning',
      \ }
let g:lightline.component_function = {
      \ 'mode': 'LightlineMode',
      \ 'fileformat': 'DeviconsGetFileFormatSymbol',
      \ 'filetype': 'DeviconsGetFileTypeSymbol',
      \ 'gitbranch': 'LightlineGitBranch',
      \ }
" , [ 'method' ]
let g:lightline.active = {
      \ 'left':  [[ 'mode', 'paste'], ['filename', 'gitbranch' ]],
      \ 'right': [[ '', 'lineinfo', 'percent' ], [ '', 'filetype', 'fileformat', 'fileencoding' ], [ 'language_client_statusline' ], [ 'linter_checking', 'linter_errors', 'linter_warnings' ], [ 'linter_ok' ]]
      \ }
let g:lightline.inactive = {
      \ 'left':  [[ 'filename' ]],
      \ 'right': [[ 'lineinfo' ], [ 'percent' ]]
      \ }
let g:lightline.tabline = {
      \ 'left':  [[ ]],
      \ 'right': [[ 'close' ]]
      \ }
      "\ 'left':  [[ 'tabs' ]],
      "\ 'right': [[ 'close' ]]
let g:lightline.tab = {
      \ 'active':   [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }
let g:lightline.enable = { 'statusline': 1 }  " , 'tabline': 1
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '  ' }
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#enable_devicons = 1


"" Gina:
" if dein#source('gina.vim')
"   call gina#custom#command#option('diff', '--opener', 'vsplit')
"   call gina#custom#command#option('commit', '-S')
"   call gina#custom#execute(
"      \ '/\%(commit\)',
"      \ 'setlocal colorcolumn=69 expandtab shiftwidth=2 softtabstop=2 tabstop=2 winheight=40',
"      \)
"   call gina#custom#mapping#nmap(
"      \ '/\%(blame\)',
"      \ 'o', '<Plug>(gina-show-commit)', {'noremap': 0, 'silent': 1},
"      \)
"   call gina#custom#execute(
"      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
"      \ 'setlocal winfixheight',
"      \)
"   call gina#custom#mapping#nmap(
"      \ '/\%(commit\|status\|branch\|ls\|grep\|changes\|tag\)',
"      \ 'q', ':<C-u> q<CR>', {'noremap': 1, 'silent': 1},
"      \)
" endif


" GitGutter:
let g:gitgutter_async = 1
let g:gitgutter_diff_args = ' '
let g:gitgutter_enabled = 1
let g:gItgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 100000
let g:gitgutter_override_sign_column_highlight = 1
let g:gitgutter_terminal_reports_focus = 1
let g:gitgutter_sign_added              = '+'
let g:gitgutter_sign_modified           = '~'
let g:gitgutter_sign_removed            = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed   = '~_'


" Accelerated JK:
let g:accelerated_jk_enable_deceleration = 0
let g:accelerated_jk_acceleration_limit = 70  " 150, 250, 350
let g:accelerated_jk_acceleration_table = [1, 3, 7, 12, 17, 21, 24, 26, 28]


" EasyMotion:
let g:EasyMotion_keys = "aoeidtn:,.pyfgcrl'qjkxbmuhs"
let g:EasyMotion_do_shade = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_grouping = 1
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_use_migemo = 0
let g:EasyMotion_use_upper = 0
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_prompt = 'Search for {n} character(s): '  " '{n}>>> '
let g:EasyMotion_inc_highlight = 1
let g:EasyMotion_move_highlight = 1
let g:EasyMotion_landing_highlight = 0
let g:EasyMotion_add_search_history = 1
let g:EasyMotion_off_screen_search = 1
let g:EasyMotion_disable_two_key_combo = 0
let g:EasyMotion_verbose = 0

nmap <LocalLeader>f  <Plug>(easymotion-f)
nmap <LocalLeader>F  <Plug>(easymotion-F)
nmap <LocalLeader>t  <Plug>(easymotion-t)
nmap <LocalLeader>T  <Plug>(easymotion-T)
nmap <LocalLeader>w  <Plug>(easymotion-w)
nmap <LocalLeader>W  <Plug>(easymotion-W)
nmap <LocalLeader>b  <Plug>(easymotion-b)
nmap <LocalLeader>B  <Plug>(easymotion-B)
nmap <LocalLeader>e  <Plug>(easymotion-e)
nmap <LocalLeader>E  <Plug>(easymotion-E)
nmap <LocalLeader>ge <Plug>(easymotion-ge)
nmap <LocalLeader>gE <Plug>(easymotion-gE)
nmap <LocalLeader>j  <Plug>(easymotion-j)
nmap <LocalLeader>k  <Plug>(easymotion-k)
nmap <LocalLeader>n  <Plug>(easymotion-n)
nmap <LocalLeader>N  <Plug>(easymotion-N)
nmap <LocalLeader>s  <Plug>(easymotion-s)

" VimIlluminate:
let g:Illuminate_delay = 250
let g:Illuminate_ftblacklist = ['defx', 'man']


" VimHexokinase:
let g:Hexokinase_highlighters = ['backgroundfull']  " 'virtual', 'sign_column', 'background', 'backgroundfull', 'foreground', 'foregroundfull'
let g:Hexokinase_optInPatterns = [
      \ 'full_hex',
      \ 'triple_hex',
      \ 'rgb',
      \ 'rgba',
      \ 'hsl',
      \ 'hsla',
      \ ]


" ParenMatch:
let g:cursorword = 0


" Wakatime:
let g:wakatime_PythonBinary = g:python3_host_prog
let g:wakatime_OverrideCommandPrefix = 'wakatime'
let s:redraw_setting = 'auto'


" SonicTemplate:
let g:sonictemplate_vim_template_dir = [expand($XDG_CONFIG_HOME.'/nvim/template')]


" Editorconfig:
let g:EditorConfig_core_mode = 'python_external'


" Trans:
let g:trans_lang_credentials_file = $XDG_CONFIG_HOME.'/gcloud/credentials/kouzoh-p-zchee/trans-nvim.json'
let g:trans_lang_locale = 'ja'
let g:trans_lang_output = 'float'  " 'preview'
let g:trans_lang_cutset = ['//', '#']


" OpenBrowser:
let g:openbrowser_search_engines = {
      \ 'google': 'http://google.com/search?q={query}&tbs=qdr:y',
      \ }
let g:openbrowser_message_verbosity = 1


" EasyAlign:
let g:easy_align_ignore_groups = []


" Switchvim:
let g:switch_mapping = ""
let g:switch_custom_definitions = [ [1, 0], ['v:true', 'v:false'], ['yes', 'no'], ['on', 'off'], ['ON', 'OFF'], ['static', 'dynamic'] ]


" ISSW:
"" https://github.com/vovkasm/input-source-switcher
Gautocmd InsertLeave * call jobstart('issw com.apple.inputmethod.Kotoeri.RomajiTyping.Roman', { 'detach': v:true })

" Rainbow:
" let g:rainbow_active = 0
" let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
" let g:rainbow_load_separately = [
"      \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"      \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
"      \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"      \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
"      \ ]

" Operator Camelize:
" call operator#camelize#load()

highlight rainbowcol1                 gui=None      guifg=None     guibg=None

" -------------------------------------------------------------------------------------------------
" Language:

" Go:
"" NvimGo:
let g:go#build#appengine = v:false
let g:go#build#autosave = v:false
let g:go#build#is_not_gb = v:false
" let g:go#build#flags = ['-tags', 'gojay']
let g:go#build#force = v:false
let g:go#fmt#autosave  = v:true
let g:go#fmt#mode = 'goimports'
" let g:go#fmt#goimports_local = ['github.com/zchee/nvim-lsp']
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
let g:go#generate#test#parallel = v:true
let g:go#generate#test#template_dir = $XDG_CONFIG_HOME . '/go/template/gotests'
let g:go#generate#test#template_params_path = ''
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
let g:go#loaded#gosnippets = v:true
let g:go#terminal#height = 120
let g:go#terminal#start_insert = v:true
let g:go#terminal#width = 150
let g:go#test#all_package = v:false
let g:go#test#autosave = v:false
let g:go#test#flags = ['-v']
let g:go#debug = v:true
let g:go#debug#pprof = v:false
let g:go#loaded#gosnippets = 1
""" highlight
let g:go#highlight#terminal#test               = 1  " default : 0
let g:go_highlight_fold_enable_comment         = 1  " default : 0
let g:go_highlight_generate_tags               = 1  " default : 0
let g:go_highlight_string_spellcheck           = 0  " default : 1
let g:go_highlight_format_strings              = 1  " default : 1
let g:go_highlight_fold_enable_package_comment = 1  " default : 0
let g:go_highlight_fold_enable_block           = 1  " default : 0
let g:go_highlight_import                      = 1  " default : 0
let g:go_highlight_fold_enable_varconst        = 1  " default : 0
let g:go_highlight_array_whitespace_error      = 0  " default : 1
let g:go_highlight_trailing_whitespace_error   = 0  " default : 1
let g:go_highlight_chan_whitespace_error       = 0  " default : 1
let g:go_highlight_extra_types                 = 0  " default : 1
let g:go_highlight_space_tab_error             = 0  " default : 1
let g:go_highlight_operators                   = 1  " default : 0
let g:go_highlight_functions                   = 1  " default : 0
let g:go_highlight_function_parameters         = 0  " default : 0
let g:go_highlight_function_calls              = 1  " default : 0
let g:go_highlight_fields                      = 1  " default : 0
let g:go_highlight_types                       = 0  " default : 0
let g:go_highlight_variable_assignments        = 0  " default : 0
let g:go_highlight_variable_declarations       = 0  " default : 0
let g:go_highlight_build_constraints           = 1  " default : 0

" C CXX:
let c_no_curly_error = 1
"" VimCPPModern:
let g:cpp_simple_highlight = 1  " Put all standard C and C++ keywords under Vim's highlight group `Statement` (affects both C and C++ files)
let g:cpp_named_requirements_highlight = 1  " Enable highlighting of named requirements (C++20 library concepts)


" Protobuf:
let g:clang_format#code_style = 'google'
let g:clang_format#extra_args = '--sort-includes'  " '--fno-color-diagnostics'
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0
let g:clang_format#auto_format_on_insert_leave = 0
let g:clang_format#auto_formatexpr = 0


" Python:
"" Kite:
let g:kite_auto_complete = 1
let g:kite_snippets = 0
let g:kite_tab_complete = 0
let g:kite_deconflict_cr = 1

"" Semshi:
" let g:semshi#mark_selected_nodes = 0


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


"" Lua:
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0


"" Terraform:
let g:terraform_commentstring = '//%s'
let g:terraform_fmt_on_save = 1


"" Yaml:


"" TypeScript:
let g:yats_host_keyword = 1


"" Binary:
let g:vinarise_enable_auto_detect = 1
if isdirectory('/usr/local/opt/binutils')
  let g:vinarise_objdump_command = '/usr/local/opt/binutils/bin/gobjdump'
endif


"" Markdown:
let g:markdown_fenced_languages = [
      \ 'c',
      \ 'cpp',
      \ 'dockerfile',
      \ 'go',
      \ 'help',
      \ 'objective-c',
      \ 'proto',
      \ 'python',
      \ 'sh',
      \ 'typescript',
      \ 'vim'
      \]
"" VimMarkdownfmt:
let g:markdownfmt_command = 'markdownfmt'
let g:markdownfmt_options = ''
let g:markdownfmt_autosave = 0
let g:markdownfmt_fail_silently = 0

"" MarkdownPreview:
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = $XDG_CONFIG_HOME . '/nvim/plugin/markdown-preview.nvim/github.css'

function! s:markdown_preview_forcus_gain()
  call mkdp#util#open_preview_page()
  call timer_start(700, {-> system('kitty @ focus-window')}, {'repeat': 1})
endfunction
command! -nargs=* MarkdownPreviews call s:markdown_preview_forcus_gain()


"" PlantUML:
let g:plantuml_previewer#plantuml_jar_path = '/usr/local/opt/plantuml/libexec/plantuml.jar'
let g:plantuml_previewer#viewer_path = '/tmp/plantuml'

" -------------------------------------------------------------------------------------------------
" testing plugins

" -------------------------------------------------------------------------------------------------
" Functions:

"" Filetye:
" TODO(zchee): unused
function! s:is_filetype(args)
  let l:ft = &filetype
  " let l:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if (index(a:args, l:ft) >= 0)
    return v:true
  endif
  return v:false
endfunction


"" Help:
" https://github.com/rhysd/dogfiles/blob/69529ec4a22c/vimrc#L318-L341
function! s:smart_help(args)
  if winwidth(0) > winheight(0) * 2
    let l:help_args = 'vertical rightbelow help ' . a:args
  else
    let l:help_args = 'rightbelow help ' . a:args
  endif

  try
    execute l:help_args
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry
endfunction
command! -nargs=* -complete=help Help call s:smart_help(<q-args>)

"" HelpGrep:
function! s:smart_helpgrep(args)
  if winwidth(0) > winheight(0) * 2
    let l:help_args = 'vertical rightbelow helpgrep ' . a:args
  else
    let l:help_args = 'rightbelow helpgrep ' . a:args
  endif

  try
    execute l:help_args
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry

  silent! copen
endfunction
command! -nargs=* -complete=help HelpGrep call s:smart_helpgrep(<q-args>)


"" SyntaxInfo:
" Display syntax infomation on under the current cursor for syntax ID
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
  let s:guisp = synIDattr(a:synid, "sp")
  let s:attr = {
        \ "name": s:name,
        \ "bold": s:bold,
        \ "guifg": s:guifg,
        \ "guibg": s:guibg,
        \ "guisp": s:guisp,
        \ }
  return s:attr
endfunction

function! s:get_syn_info(cword)
  let s:baseSyn = s:get_syn_attr(s:get_syn_id(0))
  let s:baseSynInfo = "name: " . s:baseSyn.name .
       \ " bold=" . (s:baseSyn.bold == 1 ? 'true' : 'false' ) .
       \ " guifg=" . ((s:baseSyn.guifg != '') ? s:baseSyn.guifg . "," : "NONE" ) .
       \ " guibg=" . ((s:baseSyn.guibg != '') ? s:baseSyn.guibg . "," : "NONE" ) .
       \ " guisp=" . ((s:baseSyn.guisp != '') ? s:baseSyn.guisp . "," : "NONE" )
  let s:linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  let s:linkedSynInfo =  "name: " . s:linkedSyn.name .
       \ " bold=" .  (s:linkedSyn.bold == 1 ? 'true' : 'false' ) .
       \ " guifg=" . ((s:linkedSyn.guifg != '') ? s:linkedSyn.guifg : "NONE" ) .
       \ " guibg=" . ((s:linkedSyn.guibg != '') ? s:linkedSyn.guibg : "NONE" ) .
       \ " guisp=" . ((s:linkedSyn.guisp != '') ? s:linkedSyn.guisp : "NONE" )
  echomsg a:cword . ':'
  echomsg s:baseSynInfo
  echomsg '  ' . "link to"
  echomsg s:linkedSynInfo
endfunction
command! SyntaxInfo call s:get_syn_info(expand('<cword>'))


"" ClearMessage:
command! ClearMessage for n in range(200) | echom "" | endfor


"" Binary Edit Mode:
" need open nvim with `-b` flag
function! BinaryMode() abort
  if !has('binary')
    echoerr "BinaryMode must be 'binary' option"
    return
  endif

  execute '%!xxd'
endfunction


"" Open the C/C++ Online Document:
" https://github.com/rhysd/dogfiles/blob/926f2b9c1856bbf3a8090f430831f2c94d7cc410/vimrc#L1399-L1423
function! s:open_online_cfamily_doc()
  " call dein#source('open-browser.vim')
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


"" Trim Whitespace:
function! s:trimSpace()
  if !&binary && &filetype !=# 'diff' && &filetype !=# 'markdown'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction
command! TrimSpace call s:trimSpace()


"" EditInit:
function! s:editTnit()
  vsplit $XDG_CONFIG_HOME/nvim/init.vim
endfunction
command! EditInit call s:editTnit()


"" Lr:
" <lr-args> to browse lr(1) results in a new window, press return to open file in new window.
command! -nargs=* -complete=file Lr
      \ new | setl bt=nofile noswf | silent exe '0r!lr -Q ' <q-args> |
      \ 0 | res | map <buffer><C-M> $<C-W>F<C-W>_


"" LSPYamlSetSchema:
function! s:lsp_set_schema(args)
  if &filetype !=? "yaml" || !len(a:args)
    return
  endif

  let l:filepath = expand('%:p')
  let l:filename = fnamemodify(l:filepath, ':t')

  let l:schema = a:args
  let l:config_file = expand($XDG_CONFIG_HOME . '/nvim/lsp/schema/' . l:schema . '.schema.json')
  let l:config = json_decode(readfile(l:config_file))

  echom 'yaml-language-server: schema: ' . l:schema . ', config_file: ' . l:config_file
  call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': l:config })
endfunction
command! -nargs=* LSPYamlSetSchema call <SID>lsp_set_schema(<q-args>)

" -------------------------------------------------------------------------------------------------
" Command:

"" LuaVimInspect:
command! -complete=lua -nargs=* LuaVimInspect lua print(vim.inspect(<args>))

"" ManV:
"" Man with vertical split
command! -bang -bar -range=-1 -complete=customlist,man#complete -nargs=* ManV vertical Man <args>

"" CheckColor:
function s:check_colorscheme() abort
  Capture call nvim_command("edit ~/.nvim/colors/equinusocio_material.vim | source $VIMRUNTIME/tools/check_colors.vim")
  wincmd x
  setlocal filetype=vim
endfunction
command! CheckColorScheme call s:check_colorscheme()

"" TerminalV:
command! -nargs=* TerminalV vsplit | terminal <args>

"" Capture:
"" http://qiita.com/sgur/items/9e243f13caa4ff294fa8
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

"" Shfmt:
command! -nargs=1 -bang -complete=command Shfmt %!shfmt -i 2

"" FormatJson:
" if has("python3")
" python3 << EOF
" import vim
" import json
" def Format_Json(indent, sort):
"     jsonStr = "\n".join(vim.current.buffer)
"     prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=indent, separators=(',', ': '), ensure_ascii=False)
"     prettyJson = prettyJson.encode('utf8')
"     vim.current.buffer[0:] = prettyJson.split(b'\n')
" 
" def Format_Json_Select(start, end):
"     start = start - 1
"     jsonStr = "\n".join(vim.current.buffer[start:end])
"     prettyJson = json.dumps(json.loads(jsonStr), sort_keys=False, indent=2, separators=(',', ': '), ensure_ascii=False)
"     prettyJson = prettyJson.encode('utf8')
"     vim.current.buffer[start:end] = prettyJson.split(b'\n')
" 
" def Format_JsonSchema(indent, sort):
"     jsonStr = "\n".join(vim.current.buffer)
"     prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=indent, separators=(',', ': '), ensure_ascii=False)
"     prettyJson = prettyJson.encode('utf8')
"     vim.current.buffer[0:] = prettyJson.split(b'\n')
" 
" def Format_JsonSchema_Select(start, end):
"     start = start - 1
"     jsonStr = "\n".join(vim.current.buffer[start:end])
"     prettyJson = json.dumps(json.loads(jsonStr), sort_keys=False, indent=2, separators=(',', ': '), ensure_ascii=False)
"     prettyJson = prettyJson.encode('utf8')
"     vim.current.buffer[start:end] = prettyJson.split(b'\n')
" EOF
"   command! -bang -bar -complete=command -nargs=* -range=% FormatJson :python3 Format_Json(<args>)
"   command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSelect :python3 Format_Json_Select(<line1>, <line2>)
" 
"   command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSchema :python3 Format_JsonSchema(<args>)
"   command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSchemaSelect :python3 Format_JsonSchema_Select(<line1>, <line2>)
" else
"   command! -nargs=0 -bang -complete=command FormatJson %!python3 -m json.tool
" endif
" 
" "" ProfileSyntax:
" function! ProfileSyntax() abort
"   " Initial and cleanup syntime
"   redraw!
"   syntime clear
"   " Profiling syntax regexp
"   syntime on
"   redraw!
"   QuickRun -type vim -src 'syntime report'
" endfunction
" command! -nargs=1 -bang -complete=command ProfileSyntax call ProfileSyntax()
" 
" " from https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
" command! ConvertBlockComment keeppatterns .,/\*\//s/\v^((\s*\/\*)|(\s*\*\/)|(\s*\*))(.*)/\/\/\/\5/
" command! StartuptimeNvim     execute "v:progpath . ' --startuptime ' . expand('~/vimprofile.txt') '-c \"e ~/vimprofile.txt\"'"
" function! Cxn_py() abort
"   vsplit
"   terminal
"   call chansend(&channel, "python3\nimport pynvim\n")
"   call chansend(&channel, "n = pynvim.attach('socket', path='".g:cxn."')\n")
" endfunction
" function! Cxn(addr) abort
"   silent! unlet g:cxn
"   tabnew
"   if !empty(a:addr)  " Only start the client.
"     let g:cxn = a:addr
"     call Cxn_py()
"     return
"   endif
" 
"   terminal
"   let nvim_path = executable('build/bin/nvim') ? 'build/bin/nvim' : 'nvim'
"   call chansend(&channel, "NVIM_LISTEN_ADDRESS= ".nvim_path." -u NORC\n")
"   call chansend(&channel, ":let j=jobstart('nc -U ".v:servername."',{'rpc':v:true})\n")
"   call chansend(&channel, ":call rpcrequest(j, 'nvim_set_var', 'cxn', v:servername)\n")
"   call chansend(&channel, ":call rpcrequest(j, 'nvim_command', 'call Cxn_py()')\n")
" endfunction
" command! -nargs=* NvimCxn call Cxn(<q-args>)

command! Sha256Put -nargs=1 call nvim_paste(system("sha256sum-check " . expand(<line1>) . " | perl -pe 's/\n//g'"), v:false, -1)

" TODO(zchee): unused
function! TextEntered(text)
  if a:text == 'exit' || a:text == 'quit'
    stopinsert
    close
  else
    call append(line('$') - 1, 'Entered: "' . a:text . '"')
    " Reset 'modified' to allow the buffer to be closed.
    set nomodified
  endif
endfunc
" call prompt_setcallback(bufnr(''), function('TextEntered'))

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
" nnoremap              <Leader>ga        :<C-u>Gina add %<CR>
" nnoremap              <Leader>gc        :<C-u>Gina commit<CR>
" nnoremap              <Leader>gp        :<C-u>Gina push<CR>
" nnoremap              <Leader>gs        :<C-u>Gina status<CR>
     map           <Leader><Leader>     <Plug>(easymotion-prefix)

"" <LocalLeader>
" nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep -buffer-name='grep/rg'<CR>
nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
" nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer'<CR>
" nnoremap <silent><LocalLeader>g         :<C-u>Denite line -buffer-name='line'<CR>
nnoremap <silent><LocalLeader>gs        :<C-u>call switch#Switch()<CR>
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

nmap     <silent><nowait>*        <Plug>(asterisk-gz*)
nnoremap         <silent>-        :<C-u>Defx -auto-cd -direction=topleft -split=vertical -search=`expand('%:p')` `expand('%:p:h')`<CR>
" nnoremap         <silent>-        :<C-u>CHADopen<CR>

nnoremap         <nowait>@        ^
nnoremap         <nowait>^        @

nmap                     ga       <Plug>(LiveEasyAlign)
nmap             <silent>gc       <Plug>(caw:hatpos:toggle)
nnoremap         <silent>gs       :<C-u>Switch<CR>
nmap             <silent>gx       <Plug>(openbrowser-smart-search)
nmap     <silent><nowait>j        <Plug>(accelerated_jk_j)
nmap     <silent><nowait>k        <Plug>(accelerated_jk_k)
" accelerated <Left>
" nmap     <silent><nowait><Left>   :<C-u>call accelerated#time_driven#command('h')<CR>
" accelerated <Right>
" nmap     <silent><nowait><Right>  :<C-u>call accelerated#time_driven#command('l')<CR>

nnoremap                 Q        gq
nnoremap         <nowait>s        A
nnoremap         <nowait>x        "_x
nnoremap                 zj       zjzt
nnoremap                 zk       2zkzjzt
nnoremap                 ZQ       <Nop>
nnoremap         <nowait><Up>     <Up>
nnoremap         <nowait><Down>   <Down>

nnoremap         <silent><C-e>    <C-e><C-e><C-e><C-e>
" nnoremap         <silent><C-g>    :<C-u>DeniteProjectDir grep/rg -buffer-name='grep' -path=`expand('%:p:h')` -winheight=40 -preview-height=200 -sorters=sorter/path -empty<CR>
nnoremap         <silent><C-g>    :<C-u>Telescope live_grep<CR>
nnoremap         <silent><C-p>    <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap         <silent><C-q>    :<C-u>nohlsearch<CR>
nmap             <silent><C-w>z   <Plug>(zoom-toggle)
nnoremap         <silent><C-y>    <C-y><C-y><C-y><C-y>

nnoremap              <S-Down>    <Nop>
nnoremap               <S-Tab>    %
" nnoremap         <nowait><S-Tab>  %
nnoremap                 <S-Up>   <Nop>


" Language:

"" Go:
Gautocmdft go nnoremap <LocalLeader>go  :<C-u>DeniteProjectDir grep -buffer-name='grep' -path=/usr/local/go/src<CR>
Gautocmd BufNewFile,BufRead,BufEnter godoc://** nmap <C-]> <CR>

"" C CXX ObjC:
Gautocmdft c,cpp  nnoremap <silent><buffer><C-k>       :<C-u>call <SID>open_online_cfamily_doc()<CR>
" if dein#tap('vim-clang-format')
"   Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>x        <Plug>(operator-clang-format)
"   Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>C        :<C-u>ClangFormatAutoToggle<CR>
"   Gautocmdft c,cpp,objc,objcpp,proto nnoremap <buffer><LocalLeader>f   :<C-u>ClangFormat<CR>
" endif

"" Protobuf:

"" Yaml:

"" Markdown:
Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>

"" Vim:
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
Gautocmdft vim nnoremap <silent><buffer>K      :<C-u>Help<Space><C-r><C-w><CR>

"" Ouickfix:
Gautocmdft qf  nnoremap <buffer><CR>      <CR>zz

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
inoremap <silent><C-y>  <C-r>*
inoremap <silent><C-j>  <C-r>*

" Language:

"" Go Yaml Json:
" Gautocmdft go,yaml,json,jsonschema inoremap <buffer><expr>'    <cmd>lua require('nvim-autopairs').autopairs_map(1,'"')<CR>
" Gautocmdft go,yaml,json,jsonschema inoremap <buffer><expr>"    <cmd>lua require('nvim-autopairs').autopairs_map(1,"'")<CR>
" inoremap <buffer><expr>'    <cmd>lua require('nvim-autopairs').autopairs_map(1,'"')<CR>
" inoremap <buffer><expr>"    <cmd>lua require('nvim-autopairs').autopairs_map(1,"'")<CR>

"" Swift:
" Gautocmdft swift imap <buffer><C-k>  <Plug>(autocomplete_swift_jump_to_placeholder)

" Plugins:
"" Neosnippet:
imap     <silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"


"" GitHub Copilot
" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true
" Gautocmd BufNewFile,BufRead,BufEnter Copilot disable

highlight CopilotSuggestion guifg=#555555 ctermfg=8

" -------------------------------------------------------------------------------------------------
" Visual Select: (v)

" Do not add register to current cursor word
" move to start of line
"        c : do not add register to current cursor word
"        x : do not add register to current cursor word
"        P : do not add register to current cursor word
"        p : do not add register to current cursor word
"        @ : swap @ and ^ for dvorak
"        ^ : swap @ and ^ for dvorak
"       ga :
"       gc :
"       gs : sort by ignorecase alphabetically
"       tu :
"        v : move to the  last non-blank character of the line
"        V : move to the first non-blank character of the line

vnoremap                  <S-Tab>    %
vnoremap                <nowait>c    "_c
vnoremap                <nowait>P    "_dP
vnoremap                <nowait>p    "_dp
vnoremap                <nowait>x    "_x
vnoremap                <nowait>@    ^
vnoremap                <nowait>^    @
vmap                    <silent>ga   <Plug>(LiveEasyAlign)
vmap                    <silent>gc   <Plug>(caw:hatpos:toggle)
vnoremap                <silent>gs   :<C-u>'<,'>sort i<CR>
vmap                    <silent>gx   <Plug>(openbrowser-smart-search)
vmap                    <silent>tu   <Plug>(operator-convert-case-upper-camel)
vnoremap                <nowait>v    g_
vnoremap                <nowait>V    ^


" Language:

"" Protobuf:
Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

"" C CXX ObjC:
Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

" -------------------------------------------------------------------------------------------------
" Visual: (x)

" xmap                <LocalLeader>    <Plug>(operator-replace)
xnoremap            <silent><C-t>    :<C-u>Trans<CR>

xnoremap               <silent>nu :lua require"treesitter-unit".select()<CR>
xnoremap               <silent>tu :lua require"treesitter-unit".select(true)<CR>

" Language:

" -------------------------------------------------------------------------------------------------
" Operator Pending: (o)

onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>

" -------------------------------------------------------------------------------------------------
" Select: (s)

" neosnippet
smap  <nowait><silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

" Language:

"" Go Yaml Json:
Gautocmdft go,yaml,json,jsonschema snoremap <buffer> "    '
Gautocmdft go,yaml,json,jsonschema snoremap <buffer> '    "

" -------------------------------------------------------------------------------------------------
" Command Line: (c)

" Move beginning of the command line
" http://superuser.com/a/988874/483994
cnoremap       <C-a>    <Home>
cnoremap       <C-d>    <Del>
cnoremap       <C-k>    <C-\>e(strpart(getcmdline(), 0, getcmdpos()-1))<CR>
cnoremap <expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
cnoremap <expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"
cnoremap       <S-Tab>  <C-p>

" -------------------------------------------------------------------------------------------------
" Terminal: (t)

" Emacs like mapping
tnoremap <silent>qq                <C-\><C-n>
tnoremap <silent><buffer><expr>jj  <SID>find_proc_in_tree(b:terminal_job_pid, 'nvim', 0) ? '<ESC>' : '<C-\><C-N>'
tnoremap <buffer><S-Left>          <C-[>b
tnoremap <buffer><C-Left>          <C-[>b
tnoremap <buffer><S-Right>         <C-[>f
tnoremap <buffer><C-Right>         <C-[>f
tnoremap <nowait><buffer><BS>      <BS>

" -------------------------------------------------------------------------------------------------

" Highlight:

"" Go:
highlight! goErrorType                 gui=bold      guifg=#ff5370  guibg=NONE     guisp=fg_indexed,bg_indexed
" highlight! goField                     gui=NONE      guifg=#d9d9f0  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goField                     gui=NONE      guifg=NONE  guibg=NONE     guisp=fg_indexed,bg_indexed
" highlight! goFunction                  gui=bold      guifg=#82aaff  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goFunctionCall              gui=bold      guifg=#ffcb6b  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goImportedPkg               gui=NONE      guifg=#62d2ff  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goPackageComment            gui=italic    guifg=#838c93  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goString                    gui=NONE      guifg=#92999f  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goReceiverType              gui=bold      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! link                        goBuiltins                   Keyword
highlight! link                        goFormatSpecifier            PreProc
highlight! link                        goImportedPkg                Statement
highlight! link                        goStdlib                     Statement
highlight! link                        goStdlibReturn               PreProc

"" Python:
highlight! pythonSpaceError            gui=NONE      guifg=#787f86  guibg=#787f86     guisp=fg_indexed,bg_indexed
highlight! link                        pythonDelimiter              Special
highlight! link                        pythonNONE                   pythonFunction
highlight! link                        pythonSelf                   pythonOperator

" CPP:
highlight! doxygenBrief                gui=NONE      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! doxygenSpecialMultilineDesc gui=NONE      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! doxygenSpecialOnelineDesc   gui=NONE      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed

"" Yaml:
" highlight! yamlString                  gui=NONE      guifg=NONE     guibg=NONE     guisp=fg_indexed,bg_indexed

"" Vim:
Gautocmdft qf hi Search                gui=NONE      guifg=NONE     guibg=#373b41  guisp=fg_indexed,bg_indexed

"" Plugin:

""" Denite:
" guibg=#343941
highlight! DeniteMatchedChar           gui=NONE      guifg=#85678f  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! DeniteMatchedRange          gui=NONE      guifg=#f0c674  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! DenitePreviewLine           gui=NONE      guifg=#85678f  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! DeniteUnderlined            gui=NONE      guifg=#85678f  guibg=NONE     guisp=fg_indexed,bg_indexed

"" ParenMatch:
highlight! ParenMatch                  gui=underline guifg=NONE     guibg=#343941  guisp=fg_indexed,bg_indexed

"" VimIlluminate:
highlight! illuminatedWord             gui=underline guifg=NONE     guibg=NONE     guisp=fg_indexed,bg_indexed

"" MatchUp
highlight! MatchParen                  gui=NONE      guifg=NONE     guibg=#343941  guisp=fg_indexed,bg_indexed
highlight! MatchWord                   gui=NONE      guifg=NONE     guibg=#343941  guisp=fg_indexed,bg_indexed
