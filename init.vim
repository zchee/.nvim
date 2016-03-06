"                                                                                                  "
"                                                                                                  "
"                /\ \                                             __                               "
"  ____      ___ \ \ \___       __      __         ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\     /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/     /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\    \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                  "
" Prefix
" autocmd             is Gautocmd
" autocmd FileType    is Gautocmdft

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" init user augroup "{{{

" syntax highlight's is ~/.nvim/after/syntax/vim.vim
augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Environment variables "{{{

let $XDG_CACHE_HOME = expand($HOME.'/.cache')
let $XDG_CONFIG_DIRS = expand('/etc/xdg')
let $XDG_CONFIG_HOME = expand($HOME.'/.config')
let $XDG_DATA_DIRS = expand('/usr/local/share:/usr/share')
let $XDG_DATA_HOME = expand($HOME.'/.local/share')

" for llvm trunk
let $LD_LIBRARY_PATH='/opt/llvm/lib:/usr/local/lib:/usr/lib'

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" dein.vim settings "{{{

" let s:dein_dir = finddir('dein.vim', '.;')
let s:dein_dir = expand('$XDG_CACHE_HOME/nvim/dein').'/repos/github.com/Shougo/dein.vim'

if &runtimepath !~ '/dein.vim'
  if !isdirectory(s:dein_dir)
    call mkdir(expand($XDG_CACHE_HOME.'/nvim/dein/repos/github.com/Shougo'), 'p')
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif
  " Add dein_dir to &runtimepath
  " echomsg s:dein_dir
  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

" Set dein.vim variables
let g:dein#install_progress_type = 'statusline' " echo, statusline, tabline, title
let g:dein#types#git#default_protocol = 'ssh'
let g:dein#types#git#pull_command = 'pull --ff --ff-only'


" Start dark powered asynchronous...
call dein#begin(expand($XDG_CACHE_HOME.'/nvim/dein'))

" Load dein cache if exists cache file
if dein#load_cache([expand('<sfile>')])

  " Dark powered Vim/Neovim plugin manager
  call dein#add('Shougo/dein.vim', { 'rtp': '', 'rev': '8fbb18cf759de329cc23918dc2231cfab9b4c51f' })

  " Local develop plugins
  " call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['bufparser.nvim'])
  " call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['nvim-profiler'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['deogoto.nvim'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['nvim-go'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['treachery.nvim'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] }, ['deoplete-clang'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['go'] }, ['deoplete-go'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['python'] }, ['deoplete-jedi'])
  call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['python'] }, ['nvim-pep8'])

  " Dark powered asynchronous completion
  call dein#add('Shougo/deoplete.nvim')
  " deoplete.nvim sources
  " Swift:
  call dein#add('landaire/deoplete-swift')
  " Vim:
  call dein#add('Shougo/neco-vim', { 'on_ft': ['vim'] })
  " deoplete.nvim completion support
  call dein#add('Shougo/context_filetype.vim')
  call dein#add('Shougo/neopairs.vim')
  call dein#add('Shougo/neco-syntax')
  call dein#add('Shougo/neoinclude.vim')
  call dein#add('Shougo/echodoc.vim')
  call dein#add('Konfekt/FastFold')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('honza/vim-snippets')
  " call dein#add('SirVer/ultisnips')

  " YCM:
  call dein#local($HOME.'/src/github.com/Valloric/YouCompleteMe', {
        \   'frozen': 1,
        \   'on_ft': ['c', 'cpp', 'objc', 'objcpp'],
        \   'on_cmd': [
        \     'YcmGenerateConfig',
        \     'YcmShowDetailedDiagnostic',
        \     'YcmDebugInfo',
        \     'YcmToggleLogs',
        \     'YcmCompleter',
        \     'YcmForceCompileAndDiagnostics',
        \     'YcmDiags'
        \   ]
        \ })
  call dein#add('rdnetto/YCM-Generator', { 'on_cmd' : ['YcmGenerateConfig'] })

  " Build:
  call dein#add('benekastah/neomake')
  call dein#add('thinca/vim-quickrun')

  " Asynchronous:
  call dein#add('Shougo/vimproc.vim', {
        \   'build': {
        \     'windows': 'tools\\update-dll-mingw',
        \     'cygwin': 'make -f make_cygwin.mak',
        \     'mac': 'make -f make_mac.mak',
        \     'linux': 'make',
        \     'unix': 'gmake',
        \   }
        \ })

  " Fuzzy:
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('sgur/ctrlp-extensions.vim')
  call dein#add('nixprime/cpsm', {'build': './install.sh'})
  call dein#add('mattn/ctrlp-ghq', { 'on_cmd': ['CtrlPGhq'] } )

  " Interface:
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('justinmk/vim-dirvish')

  " Git:
  call dein#add('airblade/vim-gitgutter')
  call dein#add('lambdalisue/vim-gista', { 'on_cmd': ['Gista'] } )
  call dein#add('lambdalisue/vim-gita', { 'on_cmd': ['Gita'] } )
  call dein#add('rhysd/committia.vim')

  " Formatter:
  call dein#add('rhysd/vim-clang-format', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] })

  " Linter:
  call dein#add('syngan/vim-vimlint', { 'on_ft': ['vim'] })
  call dein#add('ynkdir/vim-vimlparser', { 'on_ft': ['vim'] })

  " Operator:
  call dein#add('kana/vim-operator-user')
  call dein#add('rhysd/vim-operator-surround')

  " References:
  call dein#add('thinca/vim-ref')
  call dein#add('yuku-t/vim-ref-ri')

  " Template:
  call dein#add('mattn/sonictemplate-vim')

  " Utility:
  call dein#add('bfredl/nvim-miniyank')
  call dein#add('haya14busa/vim-asterisk')
  call dein#add('vim-jp/vimdoc-ja')

  " Debugging:
  call dein#add('critiqjo/lldb.nvim')

  " TODO: rewriting
  call dein#add('tomtom/tcomment_vim')
  call dein#add('jiangmiao/auto-pairs')


  " FileType Plugins:
  " Go:
  call dein#add('fatih/vim-go', { 'on_ft' : ['go'] })
  call dein#add('zchee/vim-go-stdlib')
  call dein#local($HOME.'/src/github.com/garyburd', {'frozen': 1 }, ['vigor'])

  " Python:
  call dein#local($HOME.'/src/github.com/bfredl', {'frozen': 1 }, ['nvim-ipy'])
  call dein#add('davidhalter/jedi-vim', { 'on_func' : ['jedi'] } )
  call dein#add('tell-k/vim-autopep8')
  call dein#add('nvie/vim-flake8')
  call dein#add('hynek/vim-python-pep8-indent')

  " C Family:
  call dein#add('vim-jp/vim-cpp')

  " Bison Flex:
  call dein#add('justinmk/vim-syntax-extra')

  " Dockerfile:
  call dein#add('docker/docker', { 'rtp': 'contrib/syntax/vim/' })

  " Zsh:
  call dein#add('chrisbra/vim-zsh')

  " Ninja:
  call dein#add('zchee/ninja-misc')

  " CMake:
  call dein#add('zchee/vim-cmake')


  call dein#save_cache()
endif
call dein#end()

if dein#check_install()
  call dein#install()
endif

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Global settings "{{{

let g:hybrid_use_iTerm_colors = 1
let g:enable_bold_font = 1
silent! colorscheme hybrid_reverse
if !exists('g:syntax_on')
  syntax enable
endif
filetype plugin indent on

set autoindent
set clipboard=unnamedplus
set cmdheight=2
set colorcolumn=119
set completeopt=menuone,noinsert,noselect
set expandtab
set fillchars+=diff:⣿,vert:│
set foldlevel=0
set foldmethod=marker
set foldnestmax=10 " maximum fold depth
set helplang=ja,en
set hidden
set history=10000
set ignorecase
set laststatus=2
set linebreak
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set matchpairs+=<:>
set matchtime=0
set number
set pumheight=0
set ruler
set scrolljump=1
set scrolloff=10
set shiftround
set shiftwidth=2
set shortmess+=c
set showcmd
set showmatch
set showmode
set showtabline=2
set sidescrolloff=5
set smartcase
set smartindent
set softtabstop=2
set switchbuf=usetab
set synmaxcol=1000
set tabstop=2
set tags=./tags; " http://d.hatena.ne.jp/thinca/20090723/1248286959
set textwidth=0
set timeout " Mappnig timeout
set timeoutlen=500
set ttimeout " Keycode timeout
set ttimeoutlen=100
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set updatecount=0
set updatetime=500
set wildignore+=*.DS_Store
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class,*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=tags,*.tags
set wildmode=longest,list:full " http://stackoverflow.com/a/526940/5228839
set wrap

set nobackup
set noerrorbells
set nofoldenable
set nolazyredraw
set noshiftround
set noswapfile
set notitle
set novisualbell
set nowrapscan
set nowritebackup


" Ignore default plugins
" http://lambdalisue.hatenablog.com/entry/2015/12/25/000046
let g:loaded_2html_plugin      = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_man               = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
" let g:loaded_matchparen        = 1
let loaded_gzip                = 1
let loaded_rrhelper            = 1
let loaded_spellfile_plugin    = 1
" https://github.com/justinmk/config/blob/master/.vimrc#L23
let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)

" https://github.com/justinmk/config/blob/master/.vimrc#L325-L327
" Load matchit.vim, but only if the user hasn't installed a newer version.
" but runtime! macros/matchit.vim is empty.
" See ':help pi_matchit.txt'.

"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color "{{{
hi! SpecialKey    gui=NONE    guifg=#25262c    guibg=NONE
hi! TermCursor    gui=NONE    guifg=#FFFFFF    guibg=NONE

" Go:
" highlight
let g:go_highlight_error = 1
Gautocmdft go
      \ hi goStdlib                gui=bold    guifg=#81A2BE    guibg=NONE
Gautocmdft go
      \ hi goStdlibErr             gui=bold    guifg=#FF005F    guibg=NONE

" C:
Gautocmdft c,cpp,objc,objcpp
      \ hi cCustomFunc             gui=bold    guifg=#F0C674    guibg=NONE

" Python:
Gautocmdft python
      \ hi pythonSelf              gui=None    guifg=#8abeb7    guibg=None

" Quickfix:
Gautocmdft qf
      \ hi Search                  gui=None guifg=None  guibg=#373b41

" link
" Python:
Gautocmdft python
      \ hi link pythonDelimiter    Special

" syn
" Python:
Gautocmdft python
      \ syn keyword pythonDecorator True None False self

"}}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neovim configuration "{{{

if has('mac')
  let g:python_host_prog   = '/usr/local/bin/python2'
  let g:python3_host_prog  = '/usr/local/bin/python3'
elseif has('unix')
  let g:python_host_prog   = '/usr/bin/python2'
  let g:python3_host_prog  = '/usr/bin/python3'
endif
" Skip neovim module check
let g:python_host_skip_check  = 1
let g:python3_host_skip_check = 1

" https://github.com/justinmk/config/blob/master/.vimrc#L263-L264
" https://github.com/neovim/neovim/issues/3463#issuecomment-148757691
Gautocmd CursorHold,FocusGained,FocusLost * rshada|wshada

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Filetype autocmd {{{
"
Gautocmdft vim
      \ setlocal foldmethod=marker tags=$HOME/.config/nvim/tags iskeyword+=:,#

Gautocmdft c,cpp
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab commentstring=//%s

Gautocmdft sh,bash,zsh
      \ setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2

Gautocmdft zsh
      \ runtime! indent/sh.vim

Gautocmdft go
      \ setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 copyindent

Gautocmd BufRead,BufNewFile *.asm  setlocal filetype=masm syntax=masm
Gautocmd BufRead,BufNewFile *.inc  setlocal filetype=masm syntax=masm
Gautocmd BufRead,BufNewFile *.[sS] setlocal filetype=gas  syntax=gas
Gautocmd BufRead,BufNewFile *.hla  setlocal filetype=hla  syntax=hla

Gautocmdft python
      \ setlocal tabstop=8 shiftwidth=4 smarttab softtabstop=4 colorcolumn=79 textwidth=80 nosmartindent

Gautocmdft dockerfile
      \ setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nocindent

Gautocmdft ruby
      \ setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

Gautocmdft gitconfig
      \ setlocal softtabstop=4 shiftwidth=4 noexpandtab

Gautocmdft dirvish
      \ let g:treachery#enable_autochdir = 0

Gautocmdft ipython
      \  let g:treachery#enable_autochdir = 0

" Gautocmdft c,cpp,java,php,js,python,twig,xml,yml
      " \ autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\\\s\\\\+$","","")'))

Gautocmdft c,cpp,python,ruby,zsh
      \ autocmd BufWritePost <buffer> call Ctags()

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Filetype settings "{{{

" Go:
" TODO: for nvim-go
let g:go#debuf = 0
let g:go#def#debug = 0
let g:go#def#filer = 'Dirvish'
let g:go#def#filer_mode = 'tab split'
let g:go#fmt#async = 0
let g:go#guru#keep_cursor = 1
let g:go#guru#reflection = 1
let g:go#rename#prefill = 1

" vim-go
let g:go#use_vimproc = 1
let g:go_auto_type_info = 0
let g:go_autodetect_gopath = 1
let g:go_def_mapping_enabled = 0
let g:go_doc_command = 'godoc'
let g:go_doc_options = ''
let g:go_fmt_autosave = 0
let g:go_fmt_command = 'goimports'
let g:go_fmt_experimental = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_snippet_engine = 'neosnippet'
let g:go_loclist_height = 10
let g:go_asmfmt_autosave = 1
let g:go_term_height = 30
let g:go_term_width = 30
let g:go_term_enabled = 1
" Lock golang/go source
function! GoSrcSetting()
  set readonly nomodified
  let g:gitgutter_enabled = 0
  " TODO: What?
  " Select the linked word
  nnoremap <silent><buffer><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
  " less likes mapping
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
endfunction
Gautocmd BufNewFile,BufRead /usr/local/go/* call GoSrcSetting()
" Gautocmdft go syn include @CSource syntax/c.vim
function! Gotags()
  let b:gitdir = system("git rev-parse --show-toplevel")
  if b:gitdir !~? "^fatal"
    cd `=b:gitdir`
    call vimproc#system("gotags -R -fields +l -sort -f tags ./ &")
  endif
endfunction
" Gautocmd BufWritePost *.go call Gotags()


" Python:
" Gautocmd BufWritePost *.py Neomake!
" let g:neomake_python_enabled_makers = ['pep257', 'pep8', 'pyflakes', 'flake8']
Gautocmd BufWinEnter .pythonrc set filetype=python
" vim-autopep8
let g:autopep8_disable_show_diff= 1
" vim-flake8
" flake8 global setting: $XDG_CONFIG_HOME/flake8
let g:flake8_cmd="/usr/local/bin/flake8"
let g:flake8_show_in_gutter = 1


" C CXX:
Gautocmd BufNewFile,BufRead *.c,*.cpp set omnifunc=
" Protect header library
Gautocmd BufNewFile,BufRead /System/Library/Frameworks/* setlocal readonly nomodified
Gautocmd BufNewFile,BufRead /Applications/Xcode.app/* setlocal readonly nomodified
Gautocmd BufNewFile,BufRead /Applications/Xcode-beta.app/* setlocal readonly nomodified
Gautocmdft cpp nnoremap <silent><buffer>X :<C-u>call <SID>open_online_cpp_doc()<CR>


" Ruby:
" Gautocmd BufWritePost *.rb :Autoformat
Gautocmd BufReadPost .pryrc setlocal filetype=ruby


" Zsh Sh Bash:
" http://tyru.hatenablog.com/entry/20101007/vim_syntax_sh
let g:is_bash = 1
Gautocmd BufNewFile,BufRead ~/.zsh/* setlocal filetype=zsh


" Markdown:
Gautocmd BufRead,BufNewFile *.md set filetype=markdown
Gautocmd BufRead,BufNewFile *.md let g:deoplete#disable_auto_complete = 0


" Dockerfile:
Gautocmd BufRead,BufNewFile *.[Dd]ockerfile set filetype=dockerfile


" Vim:
" develop nvimrc helper
Gautocmd BufWritePost $MYVIMRC nested
      \ silent! call vimproc#system("ctags -R --languages=Vim --sort=yes --fields=+l -f $HOME/.config/nvim/tags $HOME/.config/nvim &")

Gautocmd BufWritePost $MYVIMRC,*.vim nested
      \ call dein#clear_cache()
      \ | silent! source $MYVIMRC
      \ | call dein#save_cache()


" JavaScript:
Gautocmd BufRead,BufNewFile .eslintrc set filetype=json


" Quickfix:
" http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
Gautocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "qf" | quit | endif
" http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
function! AdjustWindowHeight(minheight, maxheight)
  let l = 1
  let n_lines = 0
  let w_width = winwidth(0)
  while l <= line('$')
    " number to float for division
    let l_len = strlen(getline(l)) + 0.0
    let line_width = l_len/w_width
    let n_lines += float2nr(ceil(line_width))
    let l += 1
  endw
  exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction
Gautocmdft qf call AdjustWindowHeight(3, 7)


" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings "{{{

" Deoplete:
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#file#enable_buffer_path = 1
" deoplete-filters
" call deoplete#custom#set('_', 'converters:', ['converter_auto_paren'])
" call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
" deoplete-debugging
let g:deoplete#enable_debug = 1
" let g:deoplete#enable_profile = 1
" deoplete-builtin:
" available values ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag']
" let g:deoplete#sources = {}
let g:deoplete#ignore_sources = {}
" let g:deoplete#ignore_sources._ = ['neosnippet']
let g:deoplete#omni#input_patterns = {}
" C Family:
" let g:deoplete#ignore_sources.c = ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag', 'syntax', 'neosnippet']
" let g:deoplete#ignore_sources.cpp = ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag', 'syntax', 'neosnippet']
" Swift:
let g:deoplete#sources#swift#daemon_autostart = 1
" Go:
" let g:deoplete#ignore_sources.go = ['buffer', 'tag', 'syntax']
" call deoplete#custom#set('go', 'rank', 10000)
" call deoplete#custom#set('go', 'disabled_syntaxes', ['Comment', 'String'])
let g:deoplete#sources#go#align_class = 1
let g:deoplete#sources#go#data_directory = $HOME.'/.config/gocode/json'
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
" Python:
" let g:deoplete#ignore_sources.python = ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag', 'syntax', 'neosnippet']
" call deoplete#custom#set('jedi', 'rank', 10000)
" disable jedi-vim
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#documentation_command = "K"
let g:jedi#force_py_version = 3
let g:jedi#max_doc_height = 100
let g:jedi#popup_select_first = 0
let g:jedi#show_call_signatures = 0
let g:jedi#smart_auto_mappings = 0

" neosnippets
call deoplete#custom#set('neosnippet', 'rank', 50)

" vim
call deoplete#custom#set('vim', 'rank', 10000)

" ruby
let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']


" neopairs.vim
let g:neopairs#enable = 1


" neosnippet
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#enable_snipmate_compatibility = 1


" echodoc
let g:echodoc_enable_at_startup = 1


" Konfekt/FastFold
let g:tex_fold_enabled=1
let g:vimsyn_folding='af'
let g:xml_syntax_folding = 1
let g:php_folding = 1
let g:perl_fold = 1


" treachey
let g:treachery#enable_autochdir = 1
let g:treachery#enable_keylayout = 1
let g:treachery#debug = 1


" nvim-ipy
let g:ipy_set_ft = 1
let g:ipy_shortprompt = 1
let g:ipy_truncate_input = 1
let g:nvim_ipy_perform_mappings = 0


" YouCompleteMe
let g:ycm_auto_trigger = 0
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_always_populate_location_list = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_confirm_extra_conf = 1
let g:ycm_extra_conf_globlist = ['./*','../*','../../*','../../../*','../../../../*','~/.nvim/*']
let g:ycm_global_ycm_extra_conf = $HOME.'/.nvim/.ycm_extra_conf.py'
let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python2'
let g:ycm_seed_identifiers_with_syntax = 1


" CtrlP
let g:ctrlp_by_filename = 0
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix\|dirvish'
let g:ctrlp_cache_dir = $XDG_CACHE_HOME.'/nvim/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
" CtrlP default match_func
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.git|\.hg|\.svn|__pycache__)$',
      \ 'file': '\v(\.DS_Store|\.a|\.o|\.exe|\.so|\.dll|tags)$'
      \ }
" files environment variable
let $FILES_IGNORE_PATTERN = "(\.git|\.hg|\.svn|_darcs|\.bzr|__pycache__|\.DS_Store|vendor|\.a|\.exe|\.so|\.dll|tags)$"
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_match_current_file = 0
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15'
let g:ctrlp_mruf_default_order = 1
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
let g:ctrlp_path_nolim = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_user_command = 'files -A %s'
" CtrlP : extensions
let g:ctrlp_yankring_disable = 1
" CtrlP : cpsm
let g:cpsm_match_empty_query = 0
let g:cpsm_highlight_mode = 'basic' " none, basic, detailed
let g:cpsm_unicode = 1
" CtrlP : ghq
let g:ctrlp_ghq_cache_enabled = 1
let g:ctrlp_ghq_default_action = 'e'
let g:ctrlp_ghq_actions = [
      \ {"label": "Open", "action": "e", "path": 1},
      \ {"label": "Look", "action": "!ghq look", "path": 0},
      \ ]


" vim-airline
let g:airline_inactive_collapse=1
let g:airline#extensions#tagbar#enabled = 0
let g:airline_powerline_fonts = 1
" vim-airline theme
let g:airline_theme = 'hybridline'
" vim-airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_section_c = airline#section#create(['%<', 'readonly', ' ', 'path'])


" Neomake
let g:neomake_open_list = 'loclist'
let g:neomake_serialize = 1
let g:neomake_error_sign = {
      \ 'text': 'E>',
      \ 'texthl': 'ErrorMsg',
      \ }
let g:neomake_airline = 1


" gitgutter
let g:gitgutter_enabled = 1
let g:gitgutter_realtime = 0
let g:gitgutter_sign_column_always = 1
let g:gitgutter_max_signs = 1000
let g:gitgutter_map_keys = 0


" vim-dirvish
let g:dirvish_hijack_netrw = 1
let g:dirvish_relative_paths = 1
" https://github.com/IanConnolly/dotfiles/blob/master/vimrc#L449
function! DirvishIgnore() abort
  setlocal ma
  silent! g/\.git/d
  silent! g/\.hg/d
  silent! g/\.svn/d
  silent! g/\.DS_Store/d
  silent! g/\.o/d
  silent! g/\.so/d
  silent! g/\.dylib/d
  silent! g/\.ycm_extra_conf\.py/d
  silent! g/\.ycm_extra_conf\.pyc/d
  silent! g/tags/d
  silent! g/\\*\.zwc/d
  setlocal noma

  nmap d  -
endfunction
Gautocmdft dirvish call DirvishIgnore()


" nvim-ipy
" TODO: More elegant way
function! FuncIPython(...) abort
  tab IPython
  wincmd w
  " bunload

  " Specific settings
  let g:treachery#enable_autochdir = 0
  let g:gitgutter_enabled = 0

  " Automatically run if leaved insert
  autocmd InsertLeave <buffer> call IPyRun(getline('.'))

  " Cleanup IPython buffer
  nmap <silent>q         :<C-u>call IPyTerminate()<CR> :bwipeout<CR>
  " Default mappings
  imap <silent><C-F>     <Plug>(IPy-Complete)
  map  <silent><F8>      <Plug>(IPy-Interrupt)
  map  <silent><leader>? <Plug>(IPy-WordObjInfo)
endfunction
function! OnIPythonComplete(A,L,P)
  return ['2', '3']
endfunction
command! -nargs=0 -bang -complete=customlist,OnIPythonComplete IPython3 call FuncIPython()


" vim-markdown
let g:vim_markdown_folding_disabled = 1


" QuickRun
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
      \ 'outputter/quickfix/open_cmd' : 'copen 15',
      \ 'outputter/buffer/running_mark' : ''
      \ }
" Go
let g:quickrun_config.go = {
      \ 'command': 'go',
      \ 'cmdopt' : 'run',
      \ 'exec': ['%c %o %s -o -'],
      \ 'outputter' : 'buffer',
      \ 'outputter/buffer/split' : 'vertical botright 80',
      \ 'outputter/buffer/close_on_empty' : 1,
      \ }


" vim-ref
Gautocmdft ruby nnoremap K :<C-u>Ref ri <C-r><C-w><CR>
" let g:ref_refe_cmd = '/usr/local/var/rbenv/shims/refe'
let g:ref_use_vimproc = 1
let g:ref_no_default_key_mappings = 1
let g:ref_pydoc_cmd = 'python3 -m pydoc'
let g:ref_pydoc_complete_head = 1


" committia.vim
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  " Additional settings
  " setlocal spell
  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    startinsert
  end
  " Scroll the diff window from insert mode
  " Map <C-n> and <C-p>
  imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
  imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction


" tcomment_vim
let g:tcommentMaps = 0
let g:tcommentMapLeader1 = 0


" sonictemplate-vim
let g:sonictemplate_vim_vars = {
      \ '_': {
      \   'author': 'zchee',
      \   'email': 'k@zchee.io',
      \ },
      \}


" vim-gista
let g:gista#update_on_write = 1


" nvim-miniyank
let g:miniyank_filename = $XDG_CACHE_HOME."/nvim/miniyank/.miniyank.mpack"


" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Temporary functions "{{{

" https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
" When editing a file, always jump to the last known cursor position.  Don't
" do it when the position is invalid or when inside an event handler
" Also don't do it when the mark is in the first line, that is the default
" Posission when opening a file
Gautocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' |
      \   execute "normal! g`\"" |
      \   execute "call feedkeys('zz')" |
      \ endif

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
command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)


" Display syntax infomation on under the current cursor
function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()


" Set parent git directory to current path
" http://michaelheap.com/set-parent-git-directory-to-current-path-in-vim/
function! Ctags()
  let b:gitdir = vimproc#system("git rev-parse --show-toplevel")
  if b:gitdir !~? "^fatal"
    cd `=b:gitdir`
    " call jobstart("ctags", 'ctags', ['-R', '--languages=' . l:current_ft, '--fields=+l', '--sort=yes', '.'])
    call vimproc#system("ctags -R --languages=" . &filetype . " --fields=+l --sort=yes &")
  endif
endfunction


" Json Format
command! -nargs=0 -bang -complete=command FormatJSON %!python -m json.tool


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


" https://github.com/tarruda/dot-files/blob/master/config/nvim/init.vim
function! s:GetVisual()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][:col2 - 2]
  let lines[0] = lines[0][col1 - 1:]
  return lines
endfunction

" https://github.com/tarruda/dot-files/blob/master/config/nvim/init.vim
function! REPLSend(lines)
  call jobsend(g:last_terminal_job_id, add(a:lines, ''))
endfunction
" }}}

" REPL integration {{{
command! -range=% REPLSendSelection call REPLSend(s:GetVisual())
command! REPLSendLine call REPLSend([getline('.')])

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Keymap "{{{
" - Swap semicolon and colon is move to Karabiner

" Leader Prefix
" <Space>, 'q', '.', '(k)', 's'

" <Space> Leader
"    .    Global prefix

" Dvorak Center
nnoremap <Space> <Nop>
nnoremap <Enter> <Nop>

" Dvorak Leftside
" Global prefix
nnoremap .       <Nop>
" Swap single-repeat keymap
nnoremap ,       .

" Dvorak Rightside
nnoremap f       <Nop>

" Mappnig leader prefix
" CtrlP buffer
nnoremap <silent> .b   :<C-u>CtrlPBuffer<CR>
" nnoremap <silent> .b   :<C-u>CtrlPMRU<CR>
" CtrlP commandline
nnoremap <silent> .c   :<C-u>CtrlPCmdline<CR>
" Launch Dirvish
nnoremap <silent> .d   :<C-u>Dirvish<CR>
" Launch Dirvish after tabnew
nnoremap <silent> .D   :<C-u>tabnew \| Dirvish<CR>
" Focus next buffer
nnoremap <silent> .m   <C-w>w
" Switch Next tab
nnoremap <silent> .n   gt
" Switch Previous tab
nnoremap <silent> .p   gT
" witch next or previous tab
nnoremap <silent> .s   :bNext<CR>
" Create new tab
nnoremap <silent> .t   :<C-u>tabnew<CR>:call feedkeys(':e<Space>')<CR>
" Quick editing init.vim
nnoremap <silent> .r   :<C-u>tabedit $MYVIMRC<CR>
" Vsplit and focus new buffer
nnoremap <silent> .v   :<C-w>vsplit<CR><C-w>w
" CtrlP yankround
nnoremap <silent> .y   :CtrlPYankRound<CR>
" Split and focus new buffer
nnoremap <silent> .z   :<C-u>split<CR><C-w>w

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map Leader "{{{

let mapleader = "\<Space>"
" let maplocalleader = "\<Enter>"

nnoremap <silent><Leader>h  :<C-u>SmartHelp<Space><C-l>
nnoremap <silent><Leader>m  <C-w>w
nnoremap <silent><Leader>n  :TagbarToggle<CR>
nnoremap <silent><Leader>r  :<C-u>QuickRun<CR>
nnoremap <silent><Leader>s  :%s///g<Left><Left><Left>
nnoremap <silent><Leader>w  :<C-u>w<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Normal "{{{

" Don't use Ex mode, use Q for formatting
nnoremap Q       gq
" When type 'x' key(delete), do not add yank register
nnoremap x       "_x
" Jump marked line
nnoremap zj      zjzt
nnoremap zk      2zkzjzt
" suspend!
nnoremap QQ      :<C-u>q!<CR>
" Switch suspend! map
nnoremap ZZ      ZQ
" Disable suspend
nnoremap ZQ      <Nop>

" Search current word, but not move next search word
nmap     <silent>*       <Plug>(asterisk-z*)
" nnoremap *       *:call feedkeys("\<S-n>")<CR>
" Go to home and end using capitalized directions
" Switch @ and ^ for Dvorak pinky
nnoremap @       ^
nnoremap ^       @

" fast scroll
nnoremap <C-e> 2<C-e>
" Back to tagjump with centernig
nnoremap <silent><C-o> <C-o>zz:echomsg ''<CR>
" <C-o>:<Delete>
" Move cursor to lines {upward|downward} on the first non-blank character
" nnoremap <C-j> <C-m>
" nnoremap <C-k> -
" Cancel highlight search word
nnoremap <silent><C-q>  :<C-u>nohlsearch<CR>
" fast scroll
nnoremap <C-y> 2<C-y>
" Disable suspend
nnoremap <C-z> <Nop>

" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
nnoremap <M-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
nnoremap <A-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>

" Jump to match pair brackets.
" <Tab> and <C-i> are similar treatment. Need <C-i> for jump to next taglist
nnoremap <S-Tab> %

" for language documents
function! DocMappings()
  set colorcolumn=""
  let g:gitgutter_enabled = 0
  " TODO(zchee): What?
  " Select the linked word
  nnoremap <silent><buffer><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
  " less likes keymap
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
  nnoremap <silent><buffer><C-]> <C-]>
endfunction
Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun,gita-blame-navi,rst
      \ call DocMappings()

" tmux like switch the next to each other of the buffer
function! SwitchBuffer()
  if &switchbuf != "useopen"
    let saveSwitchbuf = &switchbuf
    set switchbuf=useopen
  endif
  let b:currentBuffer = expand('%:p')
  echo expand('%:p')
  " call feedkeys("\<C-w>w") | let b:sideBuffer = expand('%:p')
  execute feedkeys("\<C-w>w")
  echo expand('%:p')
  " :edit b:currentBuffer<CR>
  " call feedkeys("\<C-w>w")
  " set switchbuf=expand(`=b:saveSwitchbuf`)
  " :edit b:sideBuffer<CR>
endfunction
nnoremap zo :call SwitchBuffer()<CR>


" Go:
Gautocmdft go nnoremap "                      '
Gautocmdft go nnoremap '                      "
Gautocmdft go nnoremap <silent><buffer><C-]>  :<C-u>Godef<CR>
Gautocmdft go nnoremap <silent><Leader>]      :<C-u>tag <c-r>=expand("<cword>")<CR><CR>
Gautocmdft go nnoremap <silent><Leader>b      :<C-u>Gobuild<CR>
Gautocmdft go nnoremap <silent>K              <Plug>(go-doc)
Gautocmdft go nnoremap <silent><Leader>f      <Plug>(go-def-split)
Gautocmdft go nnoremap <silent><Leader>gi     <Plug>(go-info)
Gautocmdft go nnoremap <silent><Leader>gm     <Plug>(go-metalinter)
Gautocmdft go nnoremap <silent><Leader>gr     :<C-u>Gorename<CR>
Gautocmdft go nnoremap <silent><Leader>gt     <Plug>(go-test)
" Go guru key map
Gautocmdft go nnoremap <silent><Leader>gge    :<C-u>GoGuru callees<CR>
Gautocmdft go nnoremap <silent><Leader>ggr    :<C-u>GoGuru callers<CR>
Gautocmdft go nnoremap <silent><Leader>ggs    :<C-u>GoGuru callstack<CR>
Gautocmdft go nnoremap <silent><Leader>ggd    :<C-u>GoGuru describe<CR>
Gautocmdft go nnoremap <silent><Leader>ggf    :<C-u>GoGuru referrers<CR>
" Open the GOROOT/src use dirvish
Gautocmdft go nnoremap <silent>.go            :<C-u>silent! tabnew<CR> \| :silent! Dirvish /usr/local/go/src<CR>

" Python:
Gautocmdft python nnoremap <silent><buffer><C-]>  :<C-u>call jedi#goto()<CR>
Gautocmdft python nnoremap <silent>K              :<C-u>call jedi#show_documentation()<CR>
Gautocmdft python nnoremap <silent><Leader>m      :<C-u>messages<CR>
Gautocmdft python nnoremap <silent><Leader>a     :<C-u>write<CR> :Autopep8<CR> :write<CR><Left><Left>
Gautocmdft python nnoremap <silent><C-f>          :<C-u>call Flake8()<CR><C-w>w :call feedkeys("<Up>")<CR>

" Cfamily:
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><silent><C-]>  :<C-u>YcmCompleter GoTo<CR>
Gautocmdft c,cpp,objc,objcpp nmap      <buffer><Leader>x      <Plug>(operator-clang-format)

" JavaScript:
Gautocmdft javascript nnoremap <silent> <leader>es :Esformatter<CR>

" TypeScript:
Gautocmdft typescript nnoremap <silent><buffer><C-]>  :<C-u>YcmCompleter GoTo<CR>

" Vim:
" <C-u>: http://d.hatena.ne.jp/e_v_e/20150101/1420067539
Gautocmdft vim nnoremap <silent>K :<C-u>SmartHelp<Space><C-r><C-w><CR>

" Dirvish:
" Gautocmdft dirvish  nmap d -

" Ouickfix:
Gautocmdft qf  nnoremap <Enter> <Enter>


" CtrlPghq:
function! CtrlPGhqFunc() abort
  " Ignore custom repository
  let $GIT_CONFIG = $XDG_CONFIG_HOME . '/ghq/.ctrlp'
  CtrlPGhq
endfunction
noremap <C-g> :<C-u>call CtrlPGhqFunc()<CR>

" Gita:
Gautocmdft 'gita-blame-navi' nnoremap <buffer>q :<C-u>q<CR>:q<CR>

" OperatorUser:
" operator-surround
nmap <silent>sa <Plug>(operator-surround-append)
nmap <silent>sd <Plug>(operator-surround-delete)
nmap <silent>sr <Plug>(operator-surround-replace)

" Tcomment:
nmap <silent> gc  <Plug>TComment_gcc

" Miniyank:
nmap p <Plug>(miniyank-autoput)
nmap P <Plug>(miniyank-autoPut)
" nmap <leader>p <Plug>(miniyank-startput)
" nmap <leader>P <Plug>(miniyank-startPut)
" map <leader>n <Plug>(miniyank-cycle)
" map <Leader>c <Plug>(miniyank-tochar)
" map <Leader>l <Plug>(miniyank-toline)
" map <Leader>b <Plug>(miniyank-toblock)

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert "{{{

" Move to first of line
" //TODO escape sequence
inoremap <silent><M-h> <C-o><S-i>
" //TODO escape sequence
inoremap <silent><C-l> <C-o><S-a>
inoremap <silent><M-l> <C-o><S-a>

" Delete before current cursor
inoremap <silent><C-d>H <Esc>lc^
" Delete after current cursor
inoremap <silent><C-d>L <Esc>lc$

" Yank before current cursor
inoremap <silent><C-y>H <Esc>ly0<Insert>
" Yank after current cursor
inoremap <silent><C-y>L <Esc>ly$<Insert>


Gautocmdft go inoremap "                      '
Gautocmdft go inoremap '                      "


" deoplete.nvim
" deoplete#mappings#cancel_popup():      Not insert seletion popupmenu word and close popup
" deoplete#mappings#close_popup():       Insert word on completion popup, and close popup
" deoplete#mappings#manual_complete():   Trigger deoplete manually,
" deoplete#mappings#refresh():           Refresh completion word list
" deoplete#mappings#smart_close_popup(): Insert candidate and re-generate popup menu for deoplete
" deoplete#mappings#undo_completion():   Undo insert use deoplete completion
inoremap <silent><expr><CR>     pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
inoremap <silent><expr><BS>     pumvisible() ? deoplete#mappings#smart_close_popup()."\<BS>" : "\<BS>"
inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
inoremap <silent><expr><S-Tab>  pumvisible() ? "\<S-Tab>" : deoplete#mappings#manual_complete()
inoremap <silent><expr><C-l>    pumvisible() ? deoplete#mappings#refresh() : "\<C-l>"
inoremap <silent><expr><C-z>    deoplete#mappings#undo_completion()

" neosnippet
imap <expr><C-S> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-S>"

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual & Select "{{{

" Do not add register to current cursor word
vnoremap c  "_c
" When type 'x' key(delete), do not add yank register
vnoremap x  "_x
vnoremap P  "_dP
vnoremap p  "_dp
" vnoremap gp p

" sort alphabetically
vnoremap <silent>gs :<C-u>'<,'>sort i<CR>

" Search current cursor words '*' key
" vnoremap <silent>* "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR>:call feedkey("\<S-n>")
" Move to end of line to type double small 'v'
" $ is end of line, h is forward char
vnoremap v $h
" Move to start of line
vnoremap V ^
" Jump to match pair brackets
vnoremap <Tab> %

" Cfamily:
Gautocmdft c,cpp,objc,objcpp vmap      <buffer><Leader>x      <Plug>(operator-clang-format)

" neosnippet
vmap <expr><C-S> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-S>"

" vim-operator-user
" operator-surround
vmap <silent>sa <Plug>(operator-surround-append)
vmap <silent>sd <Plug>(operator-surround-delete)
vmap <silent>sr <Plug>(operator-surround-replace)

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual "{{{

" tcomment
xmap <silent>gc  <Plug>TComment_gc

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Select "{{{
" smap, snoremap

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command line "{{{

" Move beginning of the command line
" http://superuser.com/a/988874/483994
cnoremap <C-A>    <Home>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal "{{{

" Open new terminal tab (tmux: bindkey c)
tmap <C-d>c <C-\><C-n>:tabnew \| :terminal<CR>
" Switch tab (tmux: bindkey {n|p})
tmap <C-d>n <C-\><C-n>:tabnext<CR>
tmap <C-d>p <C-\><C-n>:tabprevious<CR>

" jj to exit to terminal mode
tnoremap <silent>jj  <C-\><C-n>
tnoremap <silent>qq  <C-\><C-n>
" ZZ to quit terminal tab
tnoremap <silent>ZZ           <C-\><C-n>:quit!<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load external nvim settings "{{{

source $XDG_CONFIG_HOME/nvim/modules/osx_header.vim
source $XDG_CONFIG_HOME/nvim/modules/functions.vim
source $XDG_CONFIG_HOME/nvim/local.vim

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
