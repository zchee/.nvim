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
" //deplicated Other custom prefix is e(dit)
" //deplicated e.g. g:lightline.!e!.git_branch()
"
" Warning - prefix is It might changes.
" It varies with my mood.

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

" Code Completion
Plug 'Shougo/deoplete.nvim'
Plug 'zchee/deoplete-go'
Plug 'Shougo/neopairs.vim'
Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'Shougo/echodoc.vim'

" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/context_filetype.vim'
Plug 'davidhalter/jedi-vim'

Plug 'Valloric/YouCompleteMe', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'rdnetto/YCM-Generator', { 'branch' : 'develop' }
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Build
Plug 'benekastah/neomake', { 'on' : 'Neomake' }
Plug 'thinca/vim-quickrun'
" Plug 'pgdouyon/vim-accio', { 'on' : 'Accio' }

" Async
Plug 'Shougo/vimproc.vim', { 'do' : 'make -f make_mac.mak' }
Plug 'zchee/asynchronous.nvim'
" Plug 'fmoralesc/nvimfs'

" Terminal
Plug 'kassio/neoterm'

" Fuzzy
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'nixprime/cpsm'

" Interface
Plug 'bling/vim-airline'
Plug 'justinmk/vim-dirvish'
Plug 'majutsushi/tagbar', { 'on' : ['Tagbar', 'TagbarToggle'] }

" Color
Plug 'zchee/vim-hybrid-material'

" Git
Plug 'airblade/vim-gitgutter'
" Plug 'zchee/gitgutter.nvim'
Plug 'lambdalisue/vim-gista'
Plug 'lambdalisue/vim-gita'
Plug 'rhysd/committia.vim'
" Plug 'rhysd/github-complete.vim'

" Formatter
Plug 'Chiel92/vim-autoformat'
Plug 'rhysd/vim-clang-format'

" References
Plug 'lambdalisue/vim-manpager'
Plug 'rizzatti/dash.vim'
" Plug 'thinca/vim-ref'
" Plug 'powerman/vim-plugin-viewdoc'

" Template
Plug 'mattn/sonictemplate-vim'

" Keymap extionsion
" Plug 'kana/vim-arpeggio'

" vim-operator-user
Plug 'kana/vim-operator-user'
Plug 'rhysd/vim-operator-surround'
" Plug 'kana/vim-operator-replace'
" Plug 'emonkak/vim-operator-comment'
" Plug 'emonkak/vim-operator-sort'

" Utility
Plug 'LeafCage/yankround.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tyru/open-browser.vim'
" Plug 'rhysd/vim-grammarous'
" Plug 'AndrewRadev/sideways.vim'
" Plug 'haya14busa/incsearch.vim'
" Plug 'cazador481/fakeclip.neovim'

" Debugging
Plug 'critiqjo/lldb.nvim'

" Misc
Plug 'mattn/benchvimrc-vim', { 'on' : 'BenchVimrc' }
Plug 'Raimondi/delimitMate'
" Plug 'jiangmiao/auto-pairs'
" Plug 'junegunn/vim-easy-align', { 'on' : ['EasyAlign', 'LiveEasyAlign'] }

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language syntax plugins "{{{

" Go
Plug 'fatih/vim-go'
" Plug 'zchee/gocode', { 'rtp': '/nvim' }
Plug 'garyburd/go-explorer'
Plug 'godoctor/godoctor.vim'
Plug 'zchee/vim-go-stdlib'

" C family
Plug 'vim-jp/vim-cpp', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
" Plug 'rhysd/wandbox-vim', { 'on' : 'Wandbox' }
" Plug 'kana/vim-altr', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
" Plug 'octol/vim-cpp-enhanced-highlight', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
" Plug 'osyo-manga/vim-marching', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
" Plug 'Rip-Rip/clang_complete', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }

" Swift
Plug 'zchee/vim-swift'

" Python
Plug 'nvie/vim-flake8', { 'for' : 'python' }

" Ruby
Plug 'osyo-manga/vim-monster', { 'for' : 'ruby' }

" Dockerfile
Plug 'ekalinin/Dockerfile.vim', { 'for' : 'Dockerfile' }

" Markdown
Plug 'godlygeek/tabular', { 'for' : 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }

" tmux
Plug 'tmux-plugins/vim-tmux', { 'for' : 'tmux' }

" Vim Help
Plug 'vim-jp/vimdoc-ja'

" ninja
Plug 'martine/ninja', { 'rtp': '/misc', 'for' : [ 'ninja' ] }

" CMake
Plug 'Kitware/CMake', { 'rtp' : '/Auxiliary', 'for' : 'cmake' }

" JavaScript
" Plug 'millermedeiros/vim-esformatter', { 'on' : 'Esformatter' }

" Json
" Plug 'elzr/vim-json', { 'for' : 'json' }

call plug#end()
filetype plugin indent on
syntax on

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Global settings "{{{
set encoding=utf-8
set fileencoding=utf-8

let g:hybrid_use_iTerm_colors = 1
let g:enable_bold_font = 1
colorscheme hybrid_reverse

" set
set ambiwidth=single
set autoindent
set cindent
" set cinoptions+=:0,g0,N-1,m1 " C++ under label https://github.com/rhysd/dotfiles/blob/master/vimrc#L1559-L1593
set clipboard=unnamedplus
set cmdheight=2
" set colorcolumn=120
set completeopt+=noinsert
set completeopt+=noselect
set completeopt-=preview
set expandtab
set helplang=ja,en
set hidden
set history=1000
set ignorecase
set iskeyword+=-
set laststatus=2
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set number
set path=.
set path+=/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include
set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/7.0.0/include
set path+=/usr/include
set path+=/usr/local/include
set path+=,
set pumheight=10 " 0 is Enable maximum displayed completion words in omnifunc list
set ruler
set scrolljump=1
set scrolloff=10
set shiftwidth=2
set showmode
set showtabline=2
set smartcase
set smartindent
set softtabstop=2
set tags=tags;
set tabstop=2
set textwidth=0
set timeout " More info, :help ttimeoutlen
set timeoutlen=500
set ttimeout
set ttimeoutlen=100
set undodir=~/.nvim/undo
set undofile
set updatetime=500
set wildignore+=*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=.git,.hg,.svn
set wildmenu
set wrap

set nobackup
set noerrorbells
set nofoldenable
set nolazyredraw
set noswapfile
set notitle
set novisualbell
set nowrapscan
set nowritebackup

" set switchbuf=useopen

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color "{{{
hi! SpecialKey                          gui=NONE    guifg='#25262c'    guibg=NONE

" Go
Gautocmdft go highlight goErr           gui=bold guifg='#ff005f'
Gautocmdft go match goErr /\<err\>/
Gautocmdft go highlight goStdlib        gui=bold guifg='#81a2be'

" C
" Gautocmdft c,cpp,objc,objcpp highlight link cCustomFunc Function
Gautocmdft c,cpp,objc,objcpp highlight cCustomFunc gui=NONE guifg='#f0c674'

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neovim configuration "{{{

" Most required absolude python path.
" Not works '~' of relative python path.
" And, installed neovim python client by `pip2or3 install git+https://github.com/neovim/python-client`
let g:python_host_prog  = '/usr/local/bin/python2'
let g:python3_host_prog  = '/usr/local/bin/python3'
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

" TERM config
if exists(':terminal')
  " let g:terminal_color    = 'xterm-256color'
  " let g:terminal_color_16777216 = 1
  " Allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000
  " tmap: <ESC><ESC> to exit to terminal mode (switch the normal mode)
  tnoremap <Esc><Esc> <C-\><C-n>
endif

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fix DECLRMM & DECSLRM
" DECLRMM - Left Right Margin Mode - http://www.vt100.net/docs/vt510-rm/DECLRMM
" DECSLRM - Set Left and Right Margins - http://www.vt100.net/docs/vt510-rm/DECSLRM
let &t_ti .= "\e[?6;69h"
let &t_te .= "\e7\e[?6;69l\e8"
let &t_CV = "\e[%i%p1%d;%p2%ds"
let &t_CS = "y"

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings "{{{

" deoplete
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_auto_pairs = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.go = ''
" let g:deoplete#omni_patterns.python = ''
let g:deoplete#sources#go = 'vim-go'

" jedi for deoplete
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#force_py_version = 3
let g:jedi#show_call_signatures = 0
let g:jedi#smart_auto_mappings = 0
Gautocmdft python setlocal omnifunc=jedi#completions

" clang_complete
" let g:clang_library_path = "/opt/llvm/lib/libclang.dylib"
" let g:clang_complete_auto = 0
" let g:clang_auto_select = 0
" let g:clang_default_keymappings = 0
" let g:clang_use_library = 1

" echodoc
let g:echodoc_enable_at_startup = 1

" YouCompleteMe
let g:ycm_auto_trigger = 1
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 1,
    \ 'infolog' : 1,
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
let g:UltiSnipsUsePythonVersion = 2
" g:UltiSnipsExpandTrigger               <tab>
" g:UltiSnipsListSnippets                <c-tab>
" g:UltiSnipsJumpForwardTrigger          <c-j>
" g:UltiSnipsJumpBackwardTrigger         <c-k>
let g:UltiSnipsExpandTrigger = "<C-t>"
let g:UltiSnipsJumpForwardTrigger = "<S-j>"
let g:UltiSnipsJumpBackwardTrigger = "<S-k>"

" CtrlP
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
" dir, file, link, func
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(DS_Store|o|exe|so|dll)$',
  \ 'func': 'expand("%:t")',
  \ }
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
let g:ctrlp_match_window = 'bottom,order:btt'
let g:ctrlp_mruf_default_order = 1
let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
let g:ctrlp_path_nolim = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_user_command = 'files -A %s'
" CtrlP : extensions
let g:ctrlp_yankring_disable = 1
" CtrlP : cpsm
let g:cpsm_max_threads = 8
let g:cpsm_unicode = 1

" clang-format
" Ref: http://algo13.net/clang/clang-format-style-oputions.html
" FIXME: Optios not works?
" let g:clang_format#code_style = 'google'
" let g:clang_format#detect_style_file = 1
" let g:clang_format#auto_format = 1

" Neomake
let g:neomake_serialize = 1
let g:neomake_error_sign = {
        \ 'text': 'E>',
        \ 'texthl': 'ErrorMsg',
        \ }
let g:neomake_airline = 1

" airline
let g:airline_theme = 'hybridline'
" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
" let g:airline_symbols.branch = ''
" let g:airline_symbols.readonly = ''
" let g:airline_symbols.linenr = ''
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
let g:quickrun_config['cpp/gcc'] = {
    \ 'command' : 'g++',
    \ 'cmdopt' : '-std=c++11 -Wall -Wextra',
    \ }
" only preprocess
let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }
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
" let g:tcommentMapLeader1 = 0

" dirvish
" http://stackoverflow.com/questions/6009698/autocmd-check-filename-in-vim
" Gautocmd BufRead * if &filetype != 'dirvish' | set autochdir | else | set noautochdir | endif
" Gautocmd BufRead * if &filetype == 'dirvish' | setlocal "ma|g/.DS_Store/d<cr>" | endif

" sonictemplate-vim
let g:sonictemplate_vim_vars = {
  \ '_': {
  \   'author': 'zchee',
  \   'email': 'zchee.io@gmail.com',
  \ },
  \}

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Filetype settings "{{{

" Go
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
let g:go_snippet_engine = 'ultisnips'
let g:go_loclist_height = 10
Gautocmdft go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
Gautocmd BufWritePost *.go :let b:gitdir=system("git rev-parse --show-toplevel") |
    \ cd `=b:gitdir` |
    \ call vimproc#system("gotags -fields +l -sort -f tags -R ./ &")
" Gautocmdft go setlocal tags+=/usr/local/go/tags
Gautocmdft go setlocal tags+=c.tags


" C family
Gautocmdft c,cpp setlocal tags+=/usr/local/tags/c.tags
Gautocmdft c,cpp,objc,objcpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
Gautocmdft c,cpp,objc,objcpp let g:deoplete#enable_at_startup = 0
Gautocmdft c,cpp,objc,objcpp let g:deoplete#disable_auto_complete = 1
Gautocmd BufReadPre if &filetype=c,cpp,objc,objcpp call PlugUnload('deoplete.nvim')
Gautocmdft c,cpp,objc,objcpp call CtagsGitRoot()
" Gautocmdft cpp setlocal matchpairs+=<:>
" let c_no_curly_error = 1 " https://github.com/vim-jp/vim-cpp/issues/16
" let c_no_bracket_error = 1
" let cpp_no_cpp11 = 1

" http://qiita.com/termoshtt/items/00552cbd776348f75750
" function! s:clang_format()
"   let now_line = line(".")
"   exec ":%! clang-format"
"   exec ":" . now_line
" endfunction
"
" if executable('clang-format')
"   Gautocmd BufWritePre *.c silent call s:clang_format()
" endif

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


" Python
Gautocmdft python setlocal tabstop=8 softtabstop=8 shiftwidth=4


" Ruby
Gautocmdft ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
" Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
" Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>


" zsh
" Gautocmdft zsh setlocal softtabstop=4 shiftwidth=4


" tmux
Gautocmdft tmux nnoremap <silent><buffer> K :call tmux#man()<CR>


" markdown
Gautocmd BufRead,BufNewFile *.md set filetype=markdown
" Gautocmdft godoc set filetype=gedoc

" |inputsource|
" Japanese input auto change
" Use https://github.com/hnakamur/inputsource
" Ref http://superuser.com/questions/224161/switch-to-specific-input-source
Gautocmd InsertLeave *.md call vimproc#system("inputsource 'com.apple.keylayout.US' &")


" Dockerfile
Gautocmd BufRead,BufNewFile *.dockerfile,Dockerfile.* set filetype=Dockerfile
Gautocmdft Dockerfile setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nocindent


" vim
" develop nvimrc helper
" Gautocmd BufWritePost $MYVIMRC,~/.nvim/nvimrc,*.vim nested silent! source $MYVIMRC
" Gautocmd WinEnter $MYVIMRC,~/.nvim/nvimrc set tags=~/.nvim/tags
" Gautocmdft vim set tags=~/.nvim/tags
" Gautocmd BufWritePost $MYVIMRC cd ~/.nvim; call vimproc#system("ctags -R --fields=+l --sort=yes &")
" Gautocmd BufWritePost $MYVIMRC silent! call vimproc#system("ctags --fields=+l -f ~/.nvim/tags ~/.nvim/ &")


" bash
" Enable bash syntax on /bin/sh shevang
" http://tyru.hatenablog.com/entry/20101007/
let g:is_bash = 1


" Xcode
Gautocmd BufRead,BufNewFile *.xcconfig setlocal filetype=sh " TODO Dedicated syntax


" gitconfig
Gautocmdft gitconfig setlocal softtabstop=4 shiftwidth=4 noexpandtab


" Config files
Gautocmd BufRead,BufNewFile .eslintrc set filetype=json " eslint


" Vagrant
Gautocmd BufRead,BufNewFile Vagrantfile set filetype=ruby


" Go slide
Gautocmd BufRead,BufNewFile *.slide set filetype=goslide
Gautocmd BufRead,BufNewFile *.slide setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
Gautocmd BufRead,BufNewFile *.slide let g:deoplete#disable_auto_complete = 1
" |inputsource|
Gautocmd InsertEnter *.slide call vimproc#system("inputsource 'com.apple.inputmethod.Kotoeri.Japanese' &")
Gautocmd InsertLeave *.slide call vimproc#system("inputsource 'com.apple.keylayout.US' &")

" *inputsource*
" com.apple.keylayout.US:                 Apple English
" com.apple.inputmethod.Kotoeri.Roman:    Kotoeri ASCII
" com.apple.inputmethod.Kotoeri.Japanese: Kotoeri Hiragana
" com.google.inputmethod.Japanese.Roman:  Google Japanese Input ASCII
" com.google.inputmethod.Japanese.base:   Google Japanese Input Hiragana
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Temporary plugin "{{{

" https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
" When editing a file, always jump to the last known cursor position.  Don't
" do it when the position is invalid or when inside an event handler
" Also don't do it when the mark is in the first line, that is the default
" Posission when opening a file.
Gautocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' |
    \   execute "normal! g`\"" |
    \   execute "call feedkeys('zz')" |
    \ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" if !(exists(":DiffOrig") && &ft!='gitcommit')
"   command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis
" endif

" Trim whitespace when write buffer without markdown FileTypes
" Gautocmd BufWritePre <buffer> if &filetype != 'markdown' | execute '%s/\s\+$//ge'

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

" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')

" SyntaxInfo: Display syntax infomation on under the current cursor
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

" https://github.com/Valloric/YouCompleteMe/issues/234#issuecomment-146774088
" function! MyOnCompleteDone()
"     if !exists('v:completed_item') || empty(v:completed_item)
"         return
"     endif
"
"     let complete_str = v:completed_item.word
"     if complete_str == ''
"         return
"     endif
"     let abbr = v:completed_item.abbr
"     let startIdx = match(abbr,"(")
"     let endIdx = match(abbr,")")
"     echo startIdx
"     echo endIdx
"     if endIdx - startIdx > 1
"         let argsStr = strpart(abbr, startIdx+1, endIdx - startIdx -1)
"         let argsList = split(argsStr, ",")
"         let snippet = ""
"         let c = 1
"         for i in argsList
"             if c > 1
"                 let snippet = snippet. ", "
"             endif
"             " strip space
"             let arg = substitute(i, '^\s*\(.\{-}\)\s*$', '\1', '')
"             let snippet = snippet . '${'.c.":".arg.'}'
"             let c += 1
"         endfor
"         let snippet = snippet . ")$0"
"         call UltiSnips#Anon(snippet)
"     endif
" endfunction
" Gautocmd CompleteDone *.go call MyOnCompleteDone()

" Set parent git directory to current path
" http://michaelheap.com/set-parent-git-directory-to-current-path-in-vim/
function! CtagsGitRoot()
  let b:gitdir = system("git rev-parse --show-toplevel")
  if b:gitdir !~? "^fatal"
    cd `=b:gitdir`
    call vimproc#system("ctags -R --fields=+l --sort=yes &")
  endif
endfunction

" Json Format
command! -nargs=0 -bang -complete=command FormatJSON %!python -m json.tool

" auto pair completion
" function! AutoPairDeoplete()
"   let g:lineword = getline('.')
"   let g:linelenght = len(getline('.')) - 1
"   if g:lineword[g:linelenght] == "("
"     call feedkeys("\)\<Left>")
"   endif
" endfunction
" "   echo matchstr(getline('.'), printf('^.*\%%%dc%s', col('.'), (mode() ==# 'i' ? '' : '.')))
" " endfunction
"
" Gautocmd CompleteDone <buffer> call AutoPairDeoplete()
" Gautocmd CompleteDone error expand("<cword>")

" Unload plugin in runtimepath
function! PlugUnload(name)
  execute 'set rtp-='."~/.nvim/plugged/".a:name."/"
endfunction

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Keymap "{{{
" Swap semicolon and colon is move to Karabiner


" Leader Prefix
" <Space> q . (k) s
"    .    Global prefix
"    s    Window manage prefix
"    q    FileTypes specific prefix
" <Space> Leader

" Dvorak Center
nnoremap <Space> <Nop>
" Dvorak Leftside
nnoremap .       <Nop>
" Dvorak Rightside
nnoremap f       <Nop>

" nnoremap .c   :let start_time = reltime()<CR> :CtrlPCmdline<CR> :echo reltimestr(reltime(start_time))<CR>
" nnoremap .u   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" Dirvish
" nnoremap <silent> .d   :set noautochdir<CR>:Dirvish<CR>

" CtrlP
" nnoremap .b   :CtrlPBuffer<CR>
nnoremap .b   :CtrlPMixed<CR>
nnoremap .c   :CtrlPCmdline<CR>
nnoremap .d   :Dirvish<CR>
nnoremap .y   :CtrlPYankRound<CR>
nnoremap .n   gt
nnoremap .p   gT
" Split and focus new buffer
nnoremap .h   :<C-u>split<CR><C-w>w
nnoremap .v   :<C-w>vsplit<CR><C-w>w
" Create new tab
nnoremap .t   :<C-u>tabnew<CR>
" Focus next buffer
nnoremap .w   <C-w>w
" Switch next or previous tab
nnoremap .z   :bNext<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map Leader "{{{

let mapleader = "\<Space>"

nnoremap  <silent> <Leader>c  :call CtagsGitRoot()<CR>
nnoremap  <silent> <Leader>h  :<C-u>SmartHelp<Space><C-l>
nnoremap  <silent> <Leader>n  :TagbarToggle<CR>
nnoremap  <silent> <Leader>r  :<C-u>QuickRun<CR>
nnoremap  <silent> <Leader>s  :%s///g<Left><Left><Left>
nnoremap  <silent> <Leader>w  :<C-u>w<CR>

" Go
Gautocmdft go nmap <Leader>]  :tag <c-r>=expand("<cword>")<CR><CR>
Gautocmdft go nmap <silent> <Leader>b  <Plug>(go-build)
Gautocmdft go nmap <silent> <Leader>d  <Plug>(go-doc)
Gautocmdft go nmap <silent> <Leader>f  <Plug>(go-def-split)
Gautocmdft go nmap <silent> <Leader>gi <Plug>(go-info)
Gautocmdft go nmap <silent> <Leader>gl <Plug>(go-metalinter)
Gautocmdft go nmap <silent> <Leader>gr <Plug>(go-rename)
Gautocmdft go nmap <silent> <Leader>gs <Plug>(go-install)
Gautocmdft go nmap <silent> <Leader>t  <Plug>(go-test)

" nnoremap  <silent> <Leader>q  <Nop> " QuickRun
" nnoremap  <silent> <Leader>qR :<C-u>QuickRun<Space> " QuickRun
" nnoremap  <silent> <Leader>qr :<C-u>QuickRun<CR> " QuickRun

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Normal "{{{

" Disable suspend nvim
" nnoremap Z     <Nop>
" nnoremap ZZ    <Nop>
nnoremap ZQ    <Nop>
nnoremap <C-z> <Nop>
" Disable hlsearch double hit <ESC>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
" Don't use Ex mode, use Q for formatting
nnoremap Q gq
" Go to home and end using capitalized directions
nnoremap H ^
nnoremap <C-h> ^
nnoremap L $
nnoremap x "_x
nnoremap <S-Left>  ^
nnoremap <S-Right> $
" Jump to match pair brackets
nnoremap <Tab> %
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
nnoremap <M-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
nnoremap <A-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
" fast scroll
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>
" Jump marked header
nnoremap zj    zjzt
nnoremap zk    2zkzjzt
nnoremap ZZ    :q!<CR>

nnoremap <C-j> <C-m>
nnoremap <C-k> -

" Enable increment | decrement when then state Visual mode
" http://vim-jp.org/blog/2015/06/30/visual-ctrl-a-ctrl-x.html
noremap <C-a> <C-a>gv
noremap <C-x> <C-x>gv

" Back to before jump list and centering buffer
nnoremap <silent><C-o> <C-o>zz

" tmux like switch the next to each other of the buffer
function! SwitchBuffer()
  if &switchbuf != "useopen"
    let saveSwitchbuf = &switchbuf
    set switchbuf=useopen
  endif
  let b:currentBuffer = expand('%:p')
  echo expand('%:p')
  " call feedkeys("\<C-w>w") | let b:sideBuffer = expand('%:p')
  exec feedkeys("\<C-w>w") echo.expand('%:p')
  " :edit b:currentBuffer<CR>
  " call feedkeys("\<C-w>w")
  " set switchbuf=expand(`=b:saveSwitchbuf`)
  " :edit b:sideBuffer<CR>
endfunction
nnoremap zo :call SwitchBuffer()<CR>

" http://qiita.com/nyarla/items/8ad44a30d529443a765a
nmap <ESC>OA <Up>
nmap <ESC>OB <Down>
nmap <ESC>OC <Right>
nmap <ESC>OD <Left>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Insert "{{{

inoremap <silent> qq <ESC>
inoremap <silent> qv <ESC>

" YouCompleteMe complete decide words to <Enter>
" inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Move cursor with Ctrl
" http://qiita.com/y_uuki/items/14389dbaaa43d25f3254
" inoremap <C-k> <Up>
" inoremap <C-j> <Down>
" inoremap <C-l> <Right>
" inoremap <C-h> <Left>

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

" http://qiita.com/nyarla/items/8ad44a30d529443a765a
" imap <ESC>OA <Up>
" imap <ESC>OB <Down>
" imap <ESC>OC <Right>
" imap <ESC>OD <Left>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual "{{{
" When type 'x' key(delete), do not add yank register
vnoremap x  "_x
vnoremap P  "_dP
" If enable, can not multi-line replace
vnoremap p  "_dp
vnoremap gp p

" nnoremap y  "+y
" nnoremap Y  "+Y
" nnoremap dd "+Y dd
" vnoremap y  "+y
" vnoremap Y  "+Y
" vnoremap d  "+y d
" nnoremap p  "+p
" nnoremap P  "+P

" Search current cursor words '*' key
vnoremap * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" Move to end of line to type double small 'v'
" $ is end of line, h is forward char
vnoremap v $h
" Move to start of line
vnoremap V ^
" Jump to match pair brackets
vnoremap <Tab> %

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Command line "{{{

" Save on superuser
cmap w!! w !sudo tee > /dev/null %

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
Gautocmdft go nmap <C-]>     <Plug>(go-def)
Gautocmdft godoc nmap <C-]>  :<C-u>tag <c-r>=expand("<cword>")<CR><CR>
" Disable display line info when jumpback. Too hacky...
" Gautocmdft go nmap <C-o>     <C-o>:<Delete>

" C family
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <Leader>a <Plug>(altr-forward)
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><C-f> :pyfile /usr/local/src/llvm/tools/clang/tools/clang-format/clang-format.py<CR>
" Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
" Gautocmdft c,cpp,objc,objcpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
" Gautocmdft c,cpp,objc,objcpp map <buffer><Leader>x <Plug>(operator-clang-format)
Gautocmdft c,cpp,objc,objcpp let g:deoplete#disable_auto_complete = 1
Gautocmdft c,cpp,objc,objcpp let g:deoplete#enable_at_startup = 0

" Python
" Gautocmdft python nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>
Gautocmdft python nnoremap <buffer> <silent> <C-]> :call jedi#goto()<CR>

" Vim
" <C-u>: http://d.hatena.ne.jp/e_v_e/20150101/1420067539
Gautocmdft vim nnoremap <silent> K :<C-u>SmartHelp<Space><C-r><C-w><CR>

" JavaScript
Gautocmdft json nnoremap <silent> <leader>es :Esformatter<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins mappings "{{{

" deoplete
" deoplete#mappings#close_popup():       Insert word on completion popup, and close popup
" deoplete#mappings#smart_close_popup(): Insert candidate and re-generate popup menu for deoplete
" deoplete#mappings#cancel_popup():      Not insert and close popup
" function! s:deoplete_smart_close()
"   return deoplete#mappings#smart_close_popup() . "\<CR>"
" endfunction
inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"

inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
inoremap <silent><expr><BS>     pumvisible() ? deoplete#mappings#smart_close_popup()."\<BS>" : "\<BS>"
" inoremap <silent><expr><CR>     pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
" inoremap <silent><expr><C-t>    pumvisible() ? "\<C-r>=\<SID>deoplete_smart_close()\<CR>" : "\<C-s>"
inoremap <silent><expr><S-Tab>  pumvisible() ? "\<S-Tab>" : deoplete#mappings#manual_complete()

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
Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun,gita-blame-navi call On_FileType_doc_define_mappings()
function! On_FileType_doc_define_mappings()
  " Select the linked word
  nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
  " less likes keymap
  nnoremap <buffer>u <C-u>
  nnoremap <buffer>d <C-d>
  nnoremap <buffer>q :<C-u>q<CR>
endfunction

" incsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)


" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
