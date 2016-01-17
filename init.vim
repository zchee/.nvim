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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" init user augroup "{{{

" syntax highlight's is ~/.nvim/after/syntax/vim.vim
augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plug settings "{{{

" Init
call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')

" Code Completion Shougo ware
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/echodoc.vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neopairs.vim'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Go
Plug 'zchee/deoplete-go'
" Python
Plug 'davidhalter/jedi-vim'

" Code completion
Plug 'Valloric/YouCompleteMe', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'rdnetto/YCM-Generator', { 'branch' : 'develop', 'on' : ['YcmGenerateConfig'] }
Plug 'Konfekt/FastFold'

" Build
Plug 'benekastah/neomake'
Plug 'thinca/vim-quickrun'
" Plug 'pgdouyon/vim-accio', { 'on' : 'Accio' }

" Async
Plug 'Shougo/vimproc.vim', { 'do' : 'make -f make_mac.mak' }

" Terminal
" Plug 'kassio/neoterm'

" Fuzzy
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'nixprime/cpsm'

" Interface
Plug 'bling/vim-airline'
Plug 'justinmk/vim-dirvish'
Plug 'majutsushi/tagbar', { 'on' : ['Tagbar', 'TagbarToggle'] }

" Git
Plug 'airblade/vim-gitgutter'
" Plug 'zchee/gitgutter.nvim'
Plug 'lambdalisue/vim-gista', { 'on' : ['Gista'] }
Plug 'lambdalisue/vim-gita', { 'on' : ['Gita'] }
Plug 'rhysd/committia.vim'

" Formatter
Plug 'rhysd/vim-clang-format'
Plug 'Chiel92/vim-autoformat'
Plug 'mattn/vim-rubyfmt', { 'for' : 'ruby' }

" References
" Plug 'lambdalisue/vim-manpager'
" Plug 'thinca/vim-ref'

" Template
Plug 'mattn/sonictemplate-vim'

" vim-operator-user
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
" Plug 'kana/vim-operator-replace'
" Plug 'emonkak/vim-operator-comment'
" Plug 'emonkak/vim-operator-sort'

" Color
Plug 'atelierbram/vim-colors_duotones'

" Utility
Plug 'LeafCage/yankround.vim'
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'
Plug 'tyru/open-browser.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'zchee/neoutil.nvim'
" Plug 'fmoralesc/nvimfs'
" Plug 'jiangmiao/auto-pairs'

" Debugging
" Plug 'critiqjo/lldb.nvim'

" Misc
Plug 'mattn/benchvimrc-vim', { 'on' : 'BenchVimrc' }

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" neovim-go
Plug '$XDG_CONFIG_HOME/nvim/plugged/nvim-go'

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language syntax plugins "{{{

" Go
Plug 'fatih/vim-go'
Plug 'zchee/vim-go-stdlib'
Plug 'zchee/vim-goiferr'
" Plug 'garyburd/go-explorer'
" Plug 'godoctor/godoctor.vim'

" C family
Plug 'vim-jp/vim-cpp', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
" Plug 'Rip-Rip/clang_complete'
" Plug 'justmao945/vim-clang'

" TypeScript
Plug 'leafgarland/typescript-vim', { 'for' : 'typescript' }
Plug 'clausreinke/typescript-tools', { 'for' : 'typescript' }

" Swift
Plug 'zchee/vim-swift-syntax', { 'for' : 'swift' }

" Python
Plug 'nvie/vim-flake8', { 'for' : 'python' }
Plug 'tell-k/vim-autopep8', { 'for' : 'python' }

" Ruby
Plug 'osyo-manga/vim-monster', { 'for' : 'ruby' }

" Dockerfile
Plug 'ekalinin/Dockerfile.vim', { 'for' : 'Dockerfile' }

" Markdown
Plug 'godlygeek/tabular', { 'for' : 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }

" tmux
Plug 'tmux-plugins/vim-tmux', { 'for' : 'tmux' }

" yml
Plug 'stephpy/vim-yaml', { 'for' : 'yaml' }

" ninja
Plug 'martine/ninja', { 'rtp': '/misc', 'for' : [ 'ninja' ] }

" CMake
Plug 'Kitware/CMake', { 'rtp' : '/Auxiliary', 'for' : 'cmake' }

call plug#end()
filetype plugin indent on
" syntax on

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Environment variable
" Global
let $LANG = 'ja_JP.UTF-8'
let $MANPATH = '/usr/local/share/man:/usr/share/man:/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/share/man'

" Global settings "{{{

" colorscheme
" syntax sync minlines=100
syntax on
set background=dark

colorscheme hybrid_reverse
let g:hybrid_use_iTerm_colors = 1
let g:enable_bold_font = 1
" colorscheme base16-duotone-dark

" set
set cindent
set clipboard=unnamedplus
set cmdheight=2
" set colorcolumn=120
set completeopt+=noinsert,noselect
set completeopt-=preview
set expandtab
set foldmethod=marker
set helplang=ja,en
set hidden
set history=10000
set ignorecase
set laststatus=2
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set number
set pumheight=0 " 0 is Enable maximum displayed completion words in omnifunc list
set ruler
set scrolljump=1
set scrolloff=10
set shiftwidth=2
set showcmd
set showmode
set showtabline=2
set smartcase
set smartindent
set softtabstop=2
set tabstop=2
set tags=./tags; " http://d.hatena.ne.jp/thinca/20090723/1248286959
set textwidth=0
set timeout " Mappnig timeout
set timeoutlen=250
set ttimeout " Keycode timeout
set ttimeoutlen=10
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set updatecount=0
set updatetime=200
set wildignore+=*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=tags,*.tags
set wrap

set path=.,/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include
set path+=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
set path+=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
set path+=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/7.0.0/include
set path+=/usr/local/include
set path+=/usr/include,

set noautoindent
set nobackup
set noerrorbells
set nofoldenable
set nolazyredraw
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
let g:loaded_gzip              = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color "{{{
hi! SpecialKey                         gui=NONE    guifg='#25262c'    guibg=NONE

hi! TermCursor                         gui=NONE    guifg='#000000'    guibg=NONE

" Go
Gautocmdft go highlight goStdlib       gui=bold guifg='#81a2be'
let g:go_highlight_error = 1
Gautocmdft go highlight goStdlibErr    gui=bold guifg='#ff005f'

" C
" Or link highlight cCustomFunc Function
Gautocmdft c,cpp,objc,objcpp highlight cCustomFunc gui=NONE guifg='#f0c674'

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neovim configuration "{{{

let $TERM = 'xterm-256color'
let $GOOS = 'darwin'
let $GOARCH = 'amd64'

" Most required absolude python path.
" Not works '~' of relative python path.
" And, installed neovim python client by `pip2or3 install git+https://github.com/neovim/python-client`
let g:python_host_prog   = '/usr/local/bin/python2'
let g:python3_host_prog  = '/usr/local/bin/python3'
let g:python_host_skip_check  = 1
let g:python3_host_skip_check = 1


" libvterm mode config
" Disable all listchars
if mode() == "t"
  setlocal listchars=
  setlocal nonumber
endif

" Allow terminal buffer size to be very large
let g:terminal_scrollback_buffer_size = 100000

" Set pandemonium theme color
let          g:terminal_color_0="#5a5a5a"
let          g:terminal_color_1="#a54242"
let          g:terminal_color_2="#9da45a"
let          g:terminal_color_3="#f0c674"
let          g:terminal_color_4="#5f819d"
let          g:terminal_color_5="#85678f"
let          g:terminal_color_6="#5e8d87"
let          g:terminal_color_7="#c5c8c6"
let          g:terminal_color_8="#373b41"
let          g:terminal_color_9="#cc6666"
let         g:terminal_color_10="#b5bd68"
let         g:terminal_color_11="#f0c674"
let         g:terminal_color_12="#81a2be"
let         g:terminal_color_13="#b294bb"
let         g:terminal_color_14="#8abeb7"
let         g:terminal_color_15="#c5c8c6"
let g:terminal_color_background="#101112"
let g:terminal_color_foreground="#c5c8c6"


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fix DECLRMM & DECSLRM
" DECLRMM - Left Right Margin Mode - http://www.vt100.net/docs/vt510-rm/DECLRMM
" DECSLRM - Set Left and Right Margins - http://www.vt100.net/docs/vt510-rm/DECSLRM
" let &t_ti .= "\e[?6;69h"
" let &t_te .= "\e7\e[?6;69l\e8"
" let &t_CV = "\e[%i%p1%d;%p2%ds"
" let &t_CS = "y"

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings "{{{

" deoplete
let ignoredeoplete = ['c', 'cpp', 'objc', 'objcpp', 'gitcommit']
Gautocmd BufWinEnter * if index(ignoredeoplete, &filetype) == -1 | DeopleteEnable | endif
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#enable_auto_pairs = 'true'
" let g:deoplete#omni#_input_patterns = {}
" let g:deoplete#omni#_input_patterns.go = ''
" let g:deoplete#omni#_input_patterns.python = ''
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources.go = ['omni']
let g:deoplete#ignore_sources.python = ['omni']
" Go deoplete source config
let g:deoplete#sources#go = 'vim-go'
call deoplete#custom#set('go', 'rank', 9999)
call deoplete#custom#set('go', 'min_pattern_length', 0)


" jedi for deoplete
Gautocmdft python setlocal omnifunc=jedi#completions
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#force_py_version = 3
let g:jedi#smart_auto_mappings = 0
let g:jedi#show_call_signatures = 0
let g:jedi#max_doc_height = 100

" neosnippet
let g:neosnippet#enable_completed_snippet = 1


" vim-autopep8
let g:autopep8_max_line_length=99
let g:autopep8_disable_show_diff=1


" echodoc
let g:echodoc_enable_at_startup = 1


" Konfekt/FastFold
let g:tex_fold_enabled=1
let g:vimsyn_folding='af'
let g:xml_syntax_folding = 1
let g:php_folding = 1
let g:perl_fold = 1


" YouCompleteMe
let g:ycm_auto_trigger = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'pandoc' : 1,
    \ 'quickrun' : 1,
    \ 'markdown' : 1,
    \}
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 1
let g:ycm_extra_conf_globlist = ['./*','../*','~/.nvim/*']
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_global_ycm_extra_conf = $HOME . '/.nvim/.ycm_extra_conf.py'
let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python2'
let g:ycm_seed_identifiers_with_syntax = 1


" CtrlP
let g:ctrlp_by_filename = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 1
" dir, file, link, func
"   \ 'func': expand("%:t"),
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v(\.DS_Store|\.o|\.exe|\.so|\.dll|tags)$'
  \ }
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15'
let g:ctrlp_mruf_default_order = 1
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
let g:ctrlp_path_nolim = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_user_command = 'files -A -M 1000 %s'
" CtrlP : extensions
let g:ctrlp_yankring_disable = 1
" CtrlP : cpsm
let g:cpsm_highlight_mode = 'detailed' " none, basic, detailed
let g:cpsm_query_inverting_delimiter = ' '
let g:cpsm_unicode = 1
" CtrlP : files
let $FILES_IGNORE_PATTERN = "^(\.git|\.hg|\.svn|_darcs|\.bzr|\.DS_Store|tags)$"


" clang-format
" Ref: http://algo13.net/clang/clang-format-style-oputions.html
" FIXME: Optios not works?
let g:clang_format#code_style = 'google'
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 1


" Neomake
let g:neomake_serialize = 1
let g:neomake_error_sign = {
        \ 'text': 'E>',
        \ 'texthl': 'ErrorMsg',
        \ }
let g:neomake_airline = 1
let g:neomake_go_enabled_makers = ['golint', 'govet']


" airline
let g:airline_theme = 'hybridline'
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline#extensions#tagbar#enabled = 0


" gitgutter
let g:gitgutter_enabled = 1
let g:gitgutter_realtime = 0
let g:gitgutter_sign_column_always = 1
let g:gitgutter_max_signs = 1000
let g:gitgutter_map_keys = 0


" vim-dirvish
let g:dirvish_hijack_netrw = 1


" vim-markdown
let g:vim_markdown_folding_disabled = 1


" QuickRun
Gautocmd BufEnter quickrun quit
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

" C++
let g:quickrun_config.c = {
    \ 'command' : 'clang',
    \ 'cmdopt' : '-O0',
    \ 'outputter' : 'buffer',
    \ 'outputter/buffer/split'   : ':vertical botright',
    \ 'outputter/buffer/close_on_empty' : 1,
    \ }
let g:quickrun_config['c/llvm/error'] = {
    \ 'type' : 'c/llvm/error',
    \ 'command' : 'clang',
    \ 'cmdopt' : '-Wall -Wextra -O2',
    \ }
let g:quickrun_config['c/llvm/run'] = {
    \ 'type' : 'c/llvm/run',
    \ 'command' : 'clang',
    \ 'cmdopt' : '-Wall -Wextra -O2',
    \ 'exec' : '%c %o -emit-llvm -S %s -o -',
    \ }
let g:quickrun_config['c/llvm'] = {
    \ 'type' : 'c/clang',
    \ 'command' : 'clang',
    \ 'exec' : '%c %o -emit-llvm -S %s -o -',
    \ }
let g:quickrun_config.cpp = {
    \ 'command' : 'clang++',
    \ 'cmdopt' : '-stdlib=libc++ -std=c++1y -Wall -Wextra -O2',
    \ }
let g:quickrun_config['cpp/llvm'] = {
    \ 'type' : 'cpp/clang++',
    \ 'exec' : '%c %o -emit-llvm -S %s -o -',
    \ }
" outputter
" Problem runner vimproc polling interval
let g:quickrun_config['_']['runner/vimproc/updatetime'] = 50

" FIXME: Automatically quit Vim if quickfix window is the last
" Gautocmdft quickrun :quit<CR>


" committia.vim
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  " Additional settings
  setlocal spell
  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
      startinsert
  end
  " Scroll the diff window from insert mode
  " Map <C-n> and <C-p>
  imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
  imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction


" vim-autoformat
" C
let g:formatdef_astyle_c = '"astyle --mode=c --style=google -pcH".(&expandtab ? "s".shiftwidth() : "t")'
" let g:formatdef_astyle = '"astyle --mode=cs --style=ansi -pcHs4"'
let g:formatters_c = ['astyle_c']


" tcomment_vim
let g:tcommentMapLeader1 = 0


" Dirvish
" https://github.com/IanConnolly/dotfiles/blob/master/vimrc#L449
function! DirvishIgnore()
  silent! setlocal ma
  silent! g@\v[\/]\.DS_Store/?$@d
  silent! g@\v[\/]\.git/?$@d
  silent! g@\v[\/]\.o/?$@d
  silent! g@\v[\/]\.so/?$@d
  silent! g@\v[\/]\.dylib/?$@d
  silent! g@\v[\/]\.ycm_extra_conf\.py/?$@d
  silent! g@\v[\/]\.ycm_extra_conf\.pyc/?$@d
  silent! g@\v[\/]tags/?$@d
  silent! setlocal noma
endfunction
Gautocmdft dirvish nnoremap <buffer> gh :<C-u>call DirvishIgnore()<cr>
Gautocmdft dirvish call feedkeys('gh')


" sonictemplate-vim
let g:sonictemplate_vim_vars = {
  \ '_': {
  \   'author': 'zchee',
  \   'email': 'k@zchee.io',
  \ },
  \}


" tcomment_vim
let g:tcommentMaps = 0

" }}}


" vim-gista
let g:gista#update_on_write = 1


" vim-rubyfmt
let g:rubyfmt_auto = 0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Filetype settings "{{{

" Go:
let g:go#use_vimproc = 1
let g:go_auto_type_info = 0
let g:go_def_mapping_enabled = 0
let g:go_doc_command = 'go'
let g:go_doc_options = 'doc'
let g:go_fmt_autosave = 1
let g:go_fmt_command = 'goimports'
let g:go_fmt_experimental = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_snippet_engine = 'neosnippet'
let g:go_loclist_height = 10
Gautocmdft go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

function! GotagsGitRoot()
  let b:gitdir = system("git rev-parse --show-toplevel")
  if b:gitdir !~? "^fatal"
    cd `=b:gitdir`
    call vimproc#system("gotags -fields +l -sort -f tags -R ./ &")
  endif
endfunction
Gautocmd BufWritePost *.go call GotagsGitRoot()
Gautocmd BufWritePost *.go Neomake
" for golang/go source
Gautocmd BufNewFile,BufRead /usr/local/go/* setlocal readonly nomodified filetype=go.godef
Gautocmd BufNewFile,BufRead /usr/local/go/* let g:gitgutter_enabled = 0
" Gautocmdft go setlocal tags+=/usr/local/go/tags
" Gautocmdft go setlocal tags+=c.tags
" Gautocmdft go syn include @CSource syntax/c.vim


" Python:
" Gautocmdft python setlocal tabstop=8 softtabstop=8 shiftwidth=4
" " Gautocmd BufWritePost *.py call Flake8()
" " let g:flake8_cmd="/usr/local/bin/flake8-3.6"


" Cfamily:
" Gautocmdft c,cpp setlocal tags+=/usr/local/tags/c.tags
Gautocmdft c,cpp,objc,objcpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
" Gautocmdft c,cpp,objc,objcpp let g:deoplete#enable_at_startup = 0
" Gautocmdft c,cpp,objc,objcpp let g:deoplete#disable_auto_complete = 1
" Gautocmd BufReadPost * if index(g:cfamily, &filetype) == 1 | echoerr 'true' | echoerr 'false' | endif
Gautocmd BufWritePost *.c,*.cpp,*.objc,*.objcpp call CtagsGitRoot()
" Gautocmdft cpp setlocal matchpairs+=<:>
" let c_no_curly_error = 1 " https://github.com/vim-jp/vim-cpp/issues/16
" let c_no_bracket_error = 1
" let cpp_no_cpp11 = 1

" Open cppreference.com
function! s:open_online_cpp_doc()
    let l = getline('.')

    if l =~# '^\s*#\s*include\s\+<.\+>'
        let header = matchstr(l, '^\s*#\s*include\s\+<\zs.\+\ze>')
        if header =~# '^boost'
            execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.matchstr(header, 'boost/\zs[^/>]\+\ze')
        else
            execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.matchstr(header, '\zs[^/>]\+\ze')
        endif
    else
        let cword = expand('<cword>')
        if cword ==# ''
            return
        endif
        let line_head = getline('.')[:col('.')-1]
        if line_head =~# 'boost::[[:alnum:]:]*$'
            execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.cword
        elseif line_head =~# 'std::[[:alnum:]:]*$'
            execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.cword
        else
            normal! K
        endif
    endif
endfunction
Gautocmdft cpp nnoremap <silent><buffer>X :<C-u>call <SID>open_online_cpp_doc()<CR>


" TypeScript
let g:typescript_compiler_options = '-sourcemap'


" Ruby
Gautocmdft ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
Gautocmd BufWritePost *.rb :Autoformat
Gautocmd BufWritePost *.rb call CtagsGitRoot()


" zsh
Gautocmdft zsh setlocal tabstop=4 softtabstop=4 shiftwidth=4


" tmux
Gautocmdft tmux nnoremap <silent><buffer> K :call tmux#man()<CR>


" markdown
Gautocmd BufRead,BufNewFile *.md set filetype=markdown
Gautocmd BufRead,BufNewFile *.md let g:deoplete#disable_auto_complete = 0
Gautocmd InsertLeave *.md call vimproc#system("issw 'com.apple.keylayout.US' &")


" Dockerfile
Gautocmd BufRead,BufNewFile *.dockerfile,Dockerfile.* set filetype=dockerfile
Gautocmdft Dockerfile setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nocindent


" vim
" develop nvimrc helper
Gautocmd BufWritePost $MYVIMRC,*.vim nested silent! source $MYVIMRC
" Gautocmd BufRead,BufNewFile $MYVIMRC, init.vim setlocal tags=$MYVIMRC . '/tags'
Gautocmdft vim setlocal tags=$XDG_CONFIG_HOME/nvim/tags
" Gautocmd BufWritePost $MYVIMRC cd ~/.nvim; call vimproc#system("ctags -R --fields=+l --sort=yes &")
Gautocmd BufWritePost $MYVIMRC silent! call vimproc#system("ctags -R --fields=+l -f $XDG_CONFIG_HOME/nvim/tags $XDG_CONFIG_HOME/nvim &")


" Bash
" Enable bash syntax on /bin/sh shevang
" http://tyru.hatenablog.com/entry/20101007/
let g:is_bash = 1


" Xcode
Gautocmd BufRead,BufNewFile *.xcconfig setlocal filetype=sh " TODO Dedicated syntax


" gitconfig
Gautocmdft gitconfig setlocal softtabstop=4 shiftwidth=4 noexpandtab


" Json
Gautocmd BufRead,BufNewFile .eslintrc set filetype=json " eslint


" Vagrant
Gautocmd BufRead,BufNewFile Vagrantfile set filetype=ruby


" goslide
Gautocmd BufRead,BufNewFile *.slide set filetype=goslide
Gautocmd BufRead,BufNewFile *.slide setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
Gautocmd BufRead,BufNewFile *.slide let g:deoplete#disable_auto_complete = 1


" vim-codic
let g:vim_codic_access_token = "jjSSDATDsXde1Nru6yEvzl1kPSCfVVJK9v"


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)
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


" Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')


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
          \ " CTERMFG: " . BASEsYN.CTERMFG .
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
function! CtagsGitRoot()
  let b:gitdir = system("git rev-parse --show-toplevel")
  if b:gitdir !~? "^fatal"
    cd `=b:gitdir`
    call vimproc#system("ctags -R --fields=+l --sort=yes &")
  endif
endfunction


" Protect header library
Gautocmd BufNewFile,BufRead /System/Library/Frameworks/* setlocal readonly nomodified
Gautocmd BufNewFile,BufRead /Applications/Xcode.app/Contents/* setlocal readonly nomodified
Gautocmd BufNewFile,BufRead /Applications/Xcode-beta.app/Contents/* setlocal readonly nomodified


" Json Format
command! -nargs=0 -bang -complete=command FormatJSON %!python -m json.tool


" Unload plugin in runtimepath
function! PlugUnload(name)
  execute 'set rtp-=~/.config/nvim/plugged/' . a:name . '/'
endfunction


" Clear message logs
command! MessageClear for n in range(200) | echom "" | endfor


" Change input source to US keylayout after focused of nvim
" Tool : vovkasm/input-source-switcher
" com.apple.keylayout.US:                 Apple English
" com.apple.inputmethod.Kotoeri.Roman:    Kotoeri ASCII
" com.apple.inputmethod.Kotoeri.Japanese: Kotoeri Hiragana
" com.google.inputmethod.Japanese.Roman:  Google Japanese Input ASCII
" com.google.inputmethod.Japanese.base:   Google Japanese Input Hiragana
Gautocmd FocusGained * call vimproc#system("issw 'com.apple.keylayout.US' &")

" Binary edit mode
" need open nvim with `-b` flag
function! BinaryMode() abort
  if !has('binary')
    echoerr "BinaryMode must be 'binary' option"
    return
  endif

  execute '%!xxd'
endfunction


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Keymap "{{{
" - Swap semicolon and colon is move to Karabiner

" Leader Prefix
" <Space>, 'q', '.', '(k)', 's'

" <Space> Leader
"    .    Global prefix

" Dvorak Center
nnoremap <Space> <Nop>

" Dvorak Leftside
nnoremap .       <Nop> " Global prefix
nnoremap ,       .     " Swap single-repeat keymap

" Dvorak Rightside
nnoremap f       <Nop>

" Mappnig leader prefix
" CtrlP buffer
nnoremap <silent> .b   :<C-u>CtrlPBuffer<CR>
" CtrlP commandline
nnoremap <silent> .c   :<C-u>CtrlPCmdline<CR>
" Launch Dirvish
nnoremap <silent> .d   :<C-u>Dirvish<CR>
" Focus next buffer
nnoremap <silent> .m   <C-w>w
" Switch Next tab
nnoremap <silent> .n   gt
" Switch Previous tab
nnoremap <silent> .p   gT
" Split and focus new buffer
nnoremap <silent> .s   :<C-u>split<CR><C-w>w
" Create new tab
nnoremap <silenT> .t   :<C-u>tabnew<CR>
" Vsplit and focus new buffer
nnoremap <silent> .v   :<C-w>vsplit<CR><C-w>w
" CtrlP yankround
nnoremap <silent> .y   :CtrlPYankRound<CR>
" Switch next or previous tab
nnoremap <silent> .z   :bNext<CR>
" nnoremap <silent> .<Left>  "_yiw?\v\w+\_W+%#<CR>:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o><C-l>:set nohlsearch<CR>
" nnoremap <silent> .<Right> "_yiw:s/\v(%#\w+)(\_W+)(\w+)/\3\2\1/<CR><C-o>/\v\w+\_W+<CR><C-l>:set nohlsearch<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map Leader "{{{

if mode() != "t"
  let mapleader = "\<Space>"
elseif mode() == "t"
  " set mapleader to tmux like bindkey on terminal buffer
  let mapleader = "\<C-b>"
endif


nnoremap  <silent> <Leader>h  :<C-u>SmartHelp<Space><C-l>
nnoremap  <silent> <Leader>n  :TagbarToggle<CR>
nnoremap  <silent> <Leader>t  :<C-u>tabnew \| :terminal<CR>
nnoremap  <silent> <Leader>r  :<C-u>QuickRun<CR>
nnoremap  <silent> <Leader>s  :%s///g<Left><Left><Left>
nnoremap  <silent> <Leader>w  :<C-u>w<CR>

" Go
Gautocmdft go nmap <Leader>]  :tag <c-r>=expand("<cword>")<CR><CR>
Gautocmdft go nmap <silent> <Leader>b  <Plug>(go-build)
Gautocmdft go nmap <silent> <Leader>d  <Plug>(go-doc)
Gautocmdft go nmap <silent> <Leader>e  :GoIferr<CR>
Gautocmdft go nmap <silent> <Leader>f  <Plug>(go-def-split)
Gautocmdft go nmap <silent> <Leader>gi <Plug>(go-info)
Gautocmdft go nmap <silent> <Leader>gl <Plug>(go-metalinter)
Gautocmdft go nmap <silent> <Leader>gr <Plug>(go-rename)
Gautocmdft go nmap <silent> <Leader>gs <Plug>(go-install)
Gautocmdft go nmap <silent> <Leader>gt  <Plug>(go-test)

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Normal "{{{
"

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" Go to home and end using capitalized directions
" Switch @ and ^
" for Dvorak pinky
nnoremap @ ^
nnoremap ^ @

" Search current word, but not move next search word
nnoremap * *:call feedkeys("\<S-n>")<CR>

" Cancel highlight search word
nnoremap <silent> <C-q>  :<C-u>nohlsearch<CR>
" When type 'x' key(delete), do not add yank register
nnoremap x "_x
" Jump marked line
nnoremap zj    zjzt
nnoremap zk    2zkzjzt
" Switch suspend! map
nnoremap ZZ    ZQ
" Disable suspend
nnoremap ZQ    <Nop>
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
nnoremap <M-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
nnoremap <A-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
" fast scroll
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
" Move cursor to lines {upward|downward},
" on the first non-blank character
nnoremap <C-j> <C-m>
nnoremap <C-k> -

nnoremap <C-z> <Nop>



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


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Insert "{{{
"

inoremap <silent> jj <ESC>
inoremap <silent> qq <ESC>

" Move to first of line
" //TODO escape sequence
inoremap <silent> <M-h> <C-o><S-i>
" //TODO escape sequence
inoremap <silent> <C-l> <C-o><S-a>
inoremap <silent> <M-l> <C-o><S-a>

" Delete before current cursor
inoremap <silent> <C-d>H <Esc>lc^
" Delete after current cursor
inoremap <silent> <C-d>L <Esc>lc$

" Yank before current cursor
inoremap <silent> <C-y>H <Esc>ly0<Insert>
" Yank after current cursor
inoremap <silent> <C-y>L <Esc>ly$<Insert>


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Visual "{{{
"
"

" Do not add register to current cursor word
vnoremap c  "_c
" When type 'x' key(delete), do not add yank register
vnoremap x  "_x
vnoremap P  "_dP
" If enable, can not multi-line replace
" vnoremap p  "_dp
" vnoremap gp p

" yankround
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)

nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)

nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)


" sort alphabetically
vnoremap gs :<C-u>'<,'>sort i<CR>

" Search current cursor words '*' key
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR>:call feedkey("\<S-n>")
" Move to end of line to type double small 'v'
" $ is end of line, h is forward char
vnoremap v $h
" Move to start of line
vnoremap V ^
" Jump to match pair brackets
vnoremap <Tab> %


" What?
" nnoremap y  "+y
" nnoremap Y  "+Y
" nnoremap dd "+Y dd
" vnoremap y  "+y
" vnoremap Y  "+Y
" vnoremap d  "+y dp
" nnoremap p  "+p
" nnoremap P  "+P

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Command line "{{{

" Save on superuser
cmap w!!  :<C-u>w !sudo tee > /dev/null %
" Misstype <Leader>w handle
cnoremap  <silent> w<Space>  :<C-u>w<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" Terminal "{{{
" Open new terminal tab (tmux: bindkey c)
tmap <C-d>c <C-\><C-n>:tabnew \| :terminal<CR>
" Switch tab (tmux: bindkey {n|p})
tmap <C-d>n <C-\><C-n>:tabnext<CR>
tmap <C-d>p <C-\><C-n>:tabprevious<CR>

" jj to exit to terminal mode
tnoremap <silent> jj  <C-\><C-n>
tnoremap <silent> qq  <C-\><C-n>
" ZZ to quit terminal tab
tnoremap ZZ           <C-\><C-n>:quit!<CR>


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language mappnigs "{{{

let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction


" Go
Gautocmdft go     nmap <silent><buffer><C-]>  <Plug>(go-def)
"
" " for Go master repository
" function! GoDefJumpBack()
"   let l:bufft = getbufvar("%", "&filetype")
"   if l:bufft == 'go'
"     quit!
"   endif
" endfunction
" Gautocmdft go.godef nmap <silent><buffer><C-]>  <Plug>(go-def)
" Gautocmdft go.godef nmap <silent><buffer><C-o>  <C-o>:<C-u>call GoDefJumpBack()<CR>
" Gautocmd BufNewFile,BufRead /usr/local/go/*  nmap <silent><buffer><C-]>  <Plug>(go-def)
" Gautocmd BufNewFile,BufRead /usr/local/go/*  nmap <silent><buffer><C-o>  <C-o>:<C-u>call GoDefJumpBack()<CR>

" Disable display line info when jumpback. Too hacky...
" Gautocmdft go nmap <C-o>     <C-o>:<Delete>


" Python
" Gautocmdft python nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>
Gautocmdft python nnoremap <buffer><silent><C-]>     :<C-u>call jedi#goto()<CR>


" C family
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><silent><C-]> :<C-u>YcmCompleter GoTo<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><C-f>         :<C-u>pyfile /usr/local/src/llvm/tools/clang/tools/clang-format/clang-format.py<CR>
Gautocmdft c,cpp,objc,objcpp map      <buffer><Leader>x      <Plug>(operator-clang-format)


" JavaScript
Gautocmdft json nnoremap <silent> <leader>es :Esformatter<CR>


" TypeScript
Gautocmdft typescript nnoremap <buffer> <silent> <C-]> :<C-u>YcmCompleter GoTo<CR>


" Vim
" <C-u>: http://d.hatena.ne.jp/e_v_e/20150101/1420067539
Gautocmdft vim nnoremap <silent> K :<C-u>SmartHelp<Space><C-r><C-w><CR>


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins mappings "{{{

" deoplete
" deoplete#mappings#close_popup():       Insert word on completion popup, and close popup
" deoplete#mappings#smart_close_popup(): Insert candidate and re-generate popup menu for deoplete
" deoplete#mappings#cancel_popup():      Not insert and close popup
"
" If not &filetype is cfamily, Enable deoplete
" If &filetype is cfamily, Enable YouCompleteMe
Gautocmd BufReadPost * if index(ignoredeoplete, &filetype) == -1
            \| inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
            \| inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
            \| inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
            \| inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
            \| inoremap <silent><expr><BS>     pumvisible() ? deoplete#mappings#smart_close_popup()."\<BS>" : "\<BS>"
            \| inoremap <silent><expr><C-t>    pumvisible() ? "\<C-r>=\<SID>deoplete_smart_close()\<CR>" : "\<C-s>"
            \| inoremap <silent><expr><S-Tab>  pumvisible() ? "\<S-Tab>" : deoplete#mappings#manual_complete()
            \ | else
            \| inoremap <silent><expr><CR>    pumvisible() ? "\<C-y>" : "\<CR>"
            \ | endif

" YouCompleteMe
" inoremap <silent><expr><CR>     pumvisible() ? "\<C-y>" : "\<CR>"

" neosnippet
imap <C-s> <Plug>(neosnippet_expand_or_jump)
smap <C-s> <Plug>(neosnippet_expand_or_jump)

" vim-operator-user
" operator-surround
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

" vim-altr
nmap <Leader>a  <Plug>(altr-forward)

" Dash.vim
nmap <silent> <Leader>gd <Plug>DashSearch

" kana/Arpeggio
" call arpeggio#load()
" Arpeggiomap oc <Plug>(operator-comment)
" Arpeggiomap od <Plug>(operator-uncomment)
" Arpeggiomap sh :<C-u>tabnew<CR>:<C-u>terminal<CR>

" vim-Gita
Gautocmdft 'gita-blame-navi' nnoremap <buffer>q :<C-u>q<CR>:q<CR>

" Tagbar

" for languages documents
Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun,gita-blame-navi,go.godef,dirvish call On_FileType_doc_define_mappings()
" Gautocmd BufWinEnter <buffer> if &readonly | call On_FileType_doc_define_mappings() | endif
function! On_FileType_doc_define_mappings()
  " Select the linked word
  nnoremap <silent><buffer><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
  " less likes keymap
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
endfunction

" incsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)

" tcomment
nmap <silent> gcc <Plug>TComment_gcc
xmap <silent> gc  <Plug>TComment_gc


" }}}

if filereadable(expand("$XDG_CONFIG_HOME/nvim/init.local"))
  source $XDG_CONFIG_HOME/nvim/local.vim
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
