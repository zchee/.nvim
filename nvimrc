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

" NeoBundle settings "{{{

" Init
set encoding=utf-8
set fileencoding=utf-8
set runtimepath+=~/.nvim/bundle/neobundle.vim
call neobundle#begin(expand('~/.nvim/bundle/'))

" Code Completion
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'rdnetto/YCM-Generator'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'

" Build
NeoBundleLazy 'benekastah/neomake', { 'autoload' : { 'commands' : 'Neomake' } }
" NeoBundleLazy 'pgdouyon/vim-accio', { 'autoload' : { 'commands' : 'Accio' } }
NeoBundle 'thinca/vim-quickrun'

" Asynchronous
NeoBundle 'zchee/asynchronous.nvim'
NeoBundle 'Shougo/vimproc.vim', { 'build' : { 'mac' : 'make -f make_mac.mak', 'linux' : 'make' } }
NeoBundle 'tpope/vim-dispatch'
" NeoBundle 'fmoralesc/nvimfs'

" Terminal
NeoBundle 'kassio/neoterm'

" Fuzzy
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'sgur/ctrlp-extensions.vim'
NeoBundleLazy 'rking/ag.vim', { 'autoload': { 'commands': 'Ag' } }

" Interface
NeoBundle 'bling/vim-airline'
NeoBundle 'justinmk/vim-dirvish'
" NeoBundleLazy 'majutsushi/tagbar', { 'autoload' : { 'commands' : 'Tagbar' } }

" Color
NeoBundle 'zchee/vim-hybrid-material'

" Git
NeoBundle 'airblade/vim-gitgutter'
" NeoBundle 'zchee/gitgutter.nvim'
NeoBundleLazy 'cohama/agit.vim', { 'autoload' : { 'commands' : 'Agit' } }
NeoBundleLazy 'lambdalisue/vim-gista', { 'autoload' : { 'commands' : 'Gista' } }
NeoBundleLazy 'lambdalisue/vim-gita', { 'autoload' : { 'commands' : 'Gita' } }
" NeoBundle 'rhysd/github-complete.vim'

" References
NeoBundle 'powerman/vim-plugin-viewdoc'
NeoBundleLazy 'lambdalisue/vim-manpager', { 'autoload': { 'commands': 'MANPAGER' }}
" NeoBundle 'rizzatti/dash.vim'
" NeoBundle 'thinca/vim-ref'

" Template
" NeoBundle complete trick
" http://lingr.com/room/vim/archives/2015/10/15#message-22606866
NeoBundleLazy 'mattn/sonictemplate-vim' , { 'autoload' : { 'commands' : [{ 'name' : 'Template', 'complete' : 'customlist,sonictemplate#complete' }] } }

" Keymap extionsion
NeoBundle 'kana/vim-arpeggio'

" vim-operator-user
NeoBundle 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', { 'autoload' : { 'mappings' : '<Plug>(operator-replace)' } }
NeoBundleLazy 'emonkak/vim-operator-comment', { 'autoload' : { 'mappings' : '<Plug>(operator-comment)' } }
NeoBundleLazy 'emonkak/vim-operator-sort', { 'autoload' : { 'mappings' : '<Plug>(operator-sort)' } }

" Utility
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'tomtom/tcomment_vim'
" NeoBundle 'cazador481/fakeclip.neovim'

" Debugging
NeoBundle 'critiqjo/lldb.nvim'

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language syntax plugins "{{{

" Go
NeoBundle 'fatih/vim-go'
NeoBundle 'dgryski/vim-godef'
NeoBundle 'garyburd/go-explorer'
NeoBundleLazy 'godoctor/godoctor.vim', { 'autoload' : { 'filetypes' : 'go' } }

" C family
NeoBundleLazy 'rhysd/vim-clang-format', { 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] } }
NeoBundleLazy 'rhysd/wandbox-vim', { 'autoload' : { 'commands' : 'Wandbox' } }
NeoBundleLazy 'kana/vim-altr', { 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] } }
NeoBundleLazy 'vim-jp/vim-cpp', { 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] } }
" NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', { 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] } }

" Python
NeoBundleLazy 'nvie/vim-flake8', { 'autoload' : { 'filetypes' : 'python' } }

" Dockerfile
NeoBundleLazy 'ekalinin/Dockerfile.vim', { 'autoload' : { 'filetypes' : 'Dockerfile' } }

" Markdown
NeoBundleLazy 'godlygeek/tabular', { 'autoload' : { 'filetypes' : 'markdown' } }
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : { 'filetypes' : 'markdown' } }

" tmux
NeoBundleLazy 'tmux-plugins/vim-tmux', { 'autoload' : { 'filetypes' : 'tmux' } }

" Vim Help
NeoBundle 'vim-jp/vimdoc-ja'

" ninja
NeoBundleLazy 'martine/ninja', { 'rtp': '/misc', 'autoload' : { 'filetypes' : [ 'ninja' ] } }

" CMake
NeoBundleLazy 'Kitware/CMake', { 'rtp' : '/Auxiliary', 'autoload' : { 'filetypes' : ['cmake'] } }

" JavaScript
NeoBundleLazy 'millermedeiros/vim-esformatter', { 'autoload' : { 'commands' : 'Esformatter' } }

" Json
" NeoBundleLazy 'elzr/vim-json', { 'autoload' : { 'filetypes' : 'json' } }

" Misc
NeoBundle 'Raimondi/delimitMate'
NeoBundleLazy 'mattn/benchvimrc-vim', { 'autoload' : { 'commands' : 'BenchVimrc' } }
" NeoBundle 'jiangmiao/auto-pairs'
" NeoBundleLazy 'junegunn/vim-easy-align', { 'autoload' : { 'commands' : ['EasyAlign', 'LiveEasyAlign'] } }


" Close NeoBundle
call neobundle#end()
filetype plugin indent on

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Global settings "{{{

syntax enable
let g:hybrid_use_iTerm_colors = 0
let g:enable_bold_font = 1
colorscheme hybrid_reverse
" colorscheme hybrid_material
" colorscheme ux

" setting
set cindent
set cinoptions+=:0,g0,N-1,m1 " C++ under label https://github.com/rhysd/dotfiles/blob/master/vimrc#L1559-L1593
set clipboard=unnamedplus
set cmdheight=1
set colorcolumn=100
set completeopt+=preview
set expandtab
set formatoptions+=j
set formatoptions+=l
set formatoptions-=c
set formatoptions-=o
set formatoptions-=r
set formatoptions-=t
set formatoptions-=v
set helplang=ja,en
set hidden
set history=1000
set ignorecase
set laststatus=2
set lazyredraw
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set number
set pumheight=0 " 0 is Enable maximum displayed completion words in omnifunc list
set ruler
set scrolljump=1
set scrolloff=10
set shiftwidth=4
set showmode
set showtabline=2
set smartcase
set smartindent
set softtabstop=4
set switchbuf=useopen
set tabstop=4
set textwidth=0
set timeout
set timeoutlen=500
set ttimeoutlen=30
set undodir=~/.nvim/undo
set undofile
set wildignore+=*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore+=.git,.hg,.svn
set wrap

set noautochdir
set nobackup
set noerrorbells
set noshowcmd
set noesckeys
set nofoldenable
set noswapfile
set notitle
set novisualbell
set nowrapscan
set nowritebackup

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neovim configuration "{{{

" Most required absolude python path.
" Not works '~' of relative python path.
" And, installed neovim python client by `pip2or3 install git+https://github.com/neovim/python-client`
let g:python_host_prog  = '/usr/local/Frameworks/Python.framework/Versions/2.7/bin/python2'
let g:python3_host_prog  = '/usr/local/Frameworks/Python.framework/Versions/3.6/bin/python3'
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

" Environment variables
" let $NVIM_LISTEN_ADDRESS='/tmp/nvim'
" let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" TERM config
if exists(':terminal')
  let g:terminal_color    = 'xterm-256color'
  " allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000
  " map esc to exit to normal mode in terminal too
  tnoremap <Esc><Esc> <C-\><C-n>
endif

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" nvimrc user augroup "{{{

" syntax highlight's is ~/.nvim/after/syntax/vim.vim
augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings "{{{

" YouCompleteMe
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_filetype_blacklist = {
        \ 'tagbar' : 1,
        \ 'qf' : 1,
        \ 'notes' : 1,
        \ 'vimwiki' : 1,
        \ 'pandoc' : 1,
        \ 'infolog' : 1,
        \ 'quickrun' : 1,
        \}
let g:ycm_always_populate_location_list = 1
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python2'
let g:ycm_global_ycm_extra_conf = '~/.nvim/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 1
let g:ycm_extra_conf_globlist = ['./*','../*','~/.nvim/*']
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
let g:UltiSnipsUsePythonVersion = 2

let g:UltiSnipsExpandTrigger = "<S-y>"
let g:UltiSnipsJumpForwardTrigger = "<S-j>"
let g:UltiSnipsJumpBackwardTrigger = "<S-k>"

" CtrlP
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50,results:50'
let g:cpsm_max_threads = 9
let g:cpsm_unicode = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
" let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_max_files = 100
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" let g:ctrlp_user_command = 'files -p %s'
let g:ctrlp_yankring_disable = 1

" clang-format
" Ref: http://algo13.net/clang/clang-format-style-oputions.html
" FIXME: Optios not works?
" let g:clang_format#code_style = 'google'
" let g:clang_format#detect_style_file = 1

" Neomake
let g:neomake_serialize = 1
let g:neomake_error_sign = {
        \ 'text': 'E>',
        \ 'texthl': 'ErrorMsg',
        \ }
let g:neomake_airline = 1

" airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_theme = 'hybridline'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

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
let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
            \ 'runner' : 'vimproc',
            \ 'runner/vimproc/updatetime' : 50,
            \ 'outputter' : 'quickfix',
            \ 'outputter/quickfix/open_cmd' : 'copen 15'
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

" Only preprocess
let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }

" Outputter
" Problem runner vimproc polling interval
let g:quickrun_config['_']['runner/vimproc/updatetime'] = 50

" Automatically quit Vim if quickfix window is the last
" Gautocmdft quickrun :quit<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" File Syntax "{{{

" Go
Gautocmdft go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
let g:go_auto_type_info = 0
let g:go_fmt_autosave = 1
let g:go_fmt_command = 'goimports'
let g:go_fmt_experimental = 0
let g:go_def_mapping_enabled = 0
let g:go_doc_command = 'godoc'
let g:go_doc_options = ''
let g:go_snippet_engine = 'ultisnips'
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_build_constraints = 1
let g:go#use_vimproc = 1
let g:gocomplete#system_function = 'vimproc#system'
let g:godef_split = 0
let g:godef_same_file_in_same_window = 1
Gautocmd BufWritePost *.go :let b:gitdir=system("git rev-parse --show-toplevel") |
    \ cd `=b:gitdir` |
    \ call vimproc#system("gotags -fields +l -sort -tag-relative -f tags -R ./ &")
" Gautocmd BufWritePost *.go Neomake

" C family
" Gautocmd BufRead,BufNewFile *.c set filetype=cpp
Gautocmdft c,cpp,objc,objcpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
Gautocmdft c,cpp,objc,objcpp setlocal path=.,/usr/local/include/c++/v1,/usr/local/lib/clang/3.8.0/include,/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1,/usr/local/include,/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/7.0.0/include,/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include,/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include,/usr/include,
" Gautocmdft c,cpp,objc,objcpp let g:load_doxygen_syntax=1
" Gautocmdft cpp setlocal matchpairs+=<:>
Gautocmdft c,cpp,objc,objcpp call CtagsGit()

let c_no_curly_error = 1 " https://github.com/vim-jp/vim-cpp/issues/16
" let g:c_syntax_for_h = 1
" let g:cpp_class_scope_highlight = 1
" let g:cpp_experimental_template_highlight = 1
" let c_no_bracket_error = 1
" let cpp_no_cpp11 = 1

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
Gautocmdft cpp nnoremap <silent><buffer>K :<C-u>call <SID>open_online_cpp_doc()<CR>


" Python
Gautocmdft python setlocal tabstop=8 softtabstop=8 shiftwidth=4


" Ruby
" Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
" Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>


" zsh
Gautocmdft zsh setlocal softtabstop=4 shiftwidth=4


" tmux
Gautocmdft tmux nnoremap <silent><buffer> K :call tmux#man()<CR>


" markdown
Gautocmd BufRead,BufNewFile *.md set filetype=markdown
" Gautocmd Filetype godoc set filetype=gedoc
" Japanese input auto change
" Use https://github.com/hnakamur/inputsource
" Ref http://superuser.com/questions/224161/switch-to-specific-input-source
Gautocmd InsertLeave *.md call vimproc#system("inputsource 'com.apple.keylayout.US' &")


" Dockerfile


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

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Temporary plugin "{{{

" https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
" When editing a file, always jump to the last known cursor position.  Don't
" do it when the position is invalid or when inside an event handler
" Also don't do it when the mark is in the first line, that is the default
" Posission when opening a file.
Gautocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

" Trim whitespace when write buffer without mkd or markdown FileTypes
Gautocmd BufWritePre if FileType != 'markdown' ? :%s/\s\+$//ge : ''

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

" Set parent git directory to current path
" http://michaelheap.com/set-parent-git-directory-to-current-path-in-vim/
function! CtagsGit()
    let b:gitdir=system("git rev-parse --show-toplevel")
    cd `=b:gitdir`
    call vimproc#system("ctags -R --fields=+l --sort=yes &")
endfunction

" Json Format
command! -nargs=0 -bang -complete=command FormatJSON %!python -m json.tool

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Keymap "{{{

" Swap semicolon and colon is move to Karabiner
"
" kana/Arpeggio
call arpeggio#load()
Arpeggiomap oc <Plug>(operator-comment)
Arpeggiomap od <Plug>(operator-uncomment)
" Arpeggiomap sh :<C-u>tabnew<CR>:<C-u>terminal<CR>


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
nnoremap s       <Nop>

" nnoremap .c   :let start_time = reltime()<CR> :CtrlPCmdline<CR> :echo reltimestr(reltime(start_time))<CR>
" nnoremap .u   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

nnoremap <C-j> 2j
nnoremap <C-k> 2k
nnoremap .b   :CtrlPBuffer<CR>
nnoremap .c   :CtrlPCmdline<CR>
nnoremap .n   gt
" nnoremap .p   gT
nnoremap .s   :<C-u>split<CR>
nnoremap .t   :<C-u>tabnew<CR>
nnoremap .v   :<C-w>vsplit<CR>
nnoremap .w   <C-w>w
nnoremap .p   :CtrlPYankRound<CR>
" Enable increment | decrement when then state Visual mode
" http://vim-jp.org/blog/2015/06/30/visual-ctrl-a-ctrl-x.html
noremap <C-a> <C-a>gv
noremap <C-x> <C-x>gv

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map Leader "{{{

let mapleader = "\<Space>"
" nnoremap <Leader>gc :let b:gitdir=system("git rev-parse --show-toplevel") | :cd `=b:gitdir` | :call vimproc#system("ctags -R &")<CR>
nnoremap <silent> <Leader>c :call CtagsGit()<CR>
nnoremap <Leader>h  :<C-u>SmartHelp<Space><C-l>
nnoremap <Leader>n  :TagbarToggle<CR>
nnoremap <Leader>r  :QuickRun<CR>
nnoremap <Leader>t  :VimFilerExplorer -split -simple -winwidth=35 -toggle -no-quit -direction=botright<CR>
nnoremap <Leader>w  :w<CR>
nnoremap <Leader>s  :%s///g<Left><Left><Left>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Normal "{{{

" Disable suspend nvim
nnoremap Z     <Nop>
nnoremap ZZ    <Nop>
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

" for languages documents
Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun call On_FileType_doc_define_mappings()
function! On_FileType_doc_define_mappings()
  " Select the linked word
  nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
  " less like keymap
  nnoremap <buffer>u <C-u>
  nnoremap <buffer>d <C-d>
  nnoremap <buffer>q :<C-u>q<CR>
endfunction

" nmap <silent> <Down> gj
" nmap <silent> <Up> gk
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Insert "{{{

inoremap <silent> jj <ESC>
" YouCompleteMe complete decide words to <Enter>
inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
" Move cursor with Ctrl
" http://qiita.com/y_uuki/items/14389dbaaa43d25f3254
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-l> <Right>
inoremap <C-h> <Left>
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

" Visual "{{{
" When type 'x' key(delete), do not add yank register
vnoremap x "_x
vnoremap p "_dp
vnoremap P "_dP
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
Gautocmdft go nmap <Leader>f :GoFmt<CR>
Gautocmdft go nmap <Leader>r :GoRun %<CR>
Gautocmdft go nmap <Leader>g <Plug>(go-def-split)
Gautocmdft go nmap <Leader>t <Plug>(go-doc)
Gautocmdft go nmap <Leader>i <Plug>(go-info)
Gautocmdft go nmap <Leader>l :GoMetaLinter<CR>
Gautocmdft go nmap <C-]>     <Plug>(go-def)
Gautocmdft go nmap <C-o>     <C-o>:<Delete>
Gautocmdft go nmap <Leader>] :tag <c-r>=expand("<cword>")<CR><CR>
" Gautocmdft go nmap <C-]>     :call GodefUnderCursor()<CR>

" C family
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>
Gautocmdft c,cpp,objc,objcpp nnoremap <Leader>a <Plug>(altr-forward)
Gautocmdft c,cpp,objc,objcpp noremap  <C-K> :pyfile /usr/local/src/llvm/tools/clang/tools/clang-format/clang-format.py<CR>
" Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
" Gautocmdft c,cpp,objc,objcpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
" Gautocmdft c,cpp,objc,objcpp map <buffer><Leader>x <Plug>(operator-clang-format)

" Python
Gautocmdft python nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>

" Vim
Gautocmdft vim nnoremap K :<C-u>SmartHelp<Space><C-r><C-w><CR>

" Js
Gautocmdft json nnoremap <silent> <leader>es :Esformatter<CR>

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins mappings "{{{

" QuickRun
nnoremap <Leader>q  <Nop>
nnoremap <silent><Leader>qr :<C-u>QuickRun<CR>
vnoremap <silent><Leader>qr :QuickRun<CR>
nnoremap <silent><Leader>qR :<C-u>QuickRun<Space>
" use clang
Gautocmdft c nnoremap <silent><buffer><Leader>qr :<C-u>QuickRun -type c/llvm/error<CR>
Gautocmdft cpp nnoremap <silent><buffer><Leader>qc :<C-u>QuickRun -type cpp/clang++<CR>


" vim-altr
nmap <Leader>a  <Plug>(altr-forward)

" }}}

" " vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
