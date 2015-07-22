"
" Init "{{{
"
set encoding=utf-8
scriptencoding 'utf-8'
" }}}


"
" vim-plug "{{{
"
filetype off
call plug#begin('~/.nvim/plugged')
Plug 'junegunn/vim-plug'

Plug 'airblade/vim-gitgutter'
Plug 'Align'
Plug 'benekastah/neomake'
Plug 'Blackrush/vim-gocode' " , { 'for': ['go'] }
Plug 'cespare/vim-toml'
Plug 'chrisbra/Colorizer'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
Plug 'deris/vim-operator-insert'
Plug 'dgryski/vim-godef' ", { 'for': ['go'] }
Plug 'docker/docker', { 'rtp': '/contrib/syntax/vim', 'for': ['Dockerfile'] }
Plug 'emonkak/vim-operator-comment'
Plug 'emonkak/vim-operator-sort'
Plug 'fatih/vim-go' ", { 'for': ['go'] }
Plug 'godlygeek/tabular'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'google/vim-maktaba'
Plug 'haya14busa/vital-exe-assert'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-dirvish'
Plug 'kamichidu/vim-textobj-function-go'
Plug 'kana/vim-arpeggio'
Plug 'kana/vim-operator-replace'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-lastpat'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'lambdalisue/vim-gista' ", { 'on': ['Gista'] }
Plug 'lambdalisue/vim-gita' ", { 'on': ['Gita'] }
Plug 'LanguageTool'
Plug 'LeafCage/yankround.vim'
Plug 'leafgarland/typescript-vim'
Plug 'majutsushi/tagbar' ", { 'on': ['TagbarToggle'] }
Plug 'mattn/benchvimrc-vim' ", { 'on': ['BenchVimrc'] }
Plug 'mattn/ctrlp-ghq'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'plasticboy/vim-markdown'
Plug 'Quramy/tsuquyomi'
Plug 'rhysd/vim-operator-surround'
Plug 'scrooloose/nerdtree'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/unite-outline' " , { 'on': ['Unite'] }
Plug 'Shougo/unite.vim' ", { 'on': ['Unite', 'UniteWithBufferDir'] }
Plug 'Shougo/vimfiler' ", { 'on': ['VimFilerTab', 'VimFiler', 'VimFilerExplorer'] }
Plug 'Shougo/vimproc.vim' ", { 'do': 'make -f make_mac.mak' }
Plug 'thinca/vim-operator-sequence'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-ref'
Plug 'thinca/vim-themis'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-surround'
Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'
Plug 'tyru/operator-camelize.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'wakatime/vim-wakatime'
Plug 'xu-cheng/brew.vim'
Plug 'yuku-t/vim-ref-ri'

" Archive plugins
" Plug 'cocopon/colorswatch.vim'
" Plug 'critiqjo/lldb.nvim'
" Plug 'drmikehenry/vim-fixkey'
" Plug 'guns/xterm-color-table.vim', { 'on': ['XtermColorTable'] }
" Plug 'haya14busa/incsearch.vim'
" Plug 'mattn/ctrlp-gist', { 'autoload': { 'commands': ['Gist'] } }
" Plug 'mattn/gist-vim', { 'depends': 'mattn/webapi-vim' }
" Plug 'rhysd/try-colorscheme.vim'
" Plug 'scrooloose/syntastic'
" Plug 'SirVer/ultisnips'
" Plug 'Yggdroot/indentLine'

" https://github.com/junegunn/vim-plug/blob/master/plug.vim#L169
" function! plug#helptags()
"   for spec in values(g:plugs)
"     let docd = join([spec.dir, 'doc'])
"     if isdirectory(docd)
"       silent! execute 'helptags' s:esc(docd)
"     endif
"   endfor
"   return 1
" endfunction

call plug#end()
" }}}


"
" Settings "{{{
"
syntax on
colorscheme ux
filetype on
filetype plugin indent on
" filetype indent on

" Environment variables
let $TERM = 'xterm-256color'
let $TERMINFO = $HOME . '/.terminfo'

" set
set autochdir
set autoindent " nvim set by default
set autoread
set backspace=indent,eol,start
set cindent
set clipboard+=unnamedplus
set cmdheight=1
set completeopt+=noselect " ,noinsert
set completeopt-=preview
set esckeys
set expandtab
set formatoptions+=j
set formatoptions+=l
set formatoptions-=c
set formatoptions-=o
set formatoptions-=r
set formatoptions-=t
set formatoptions-=v
set guicursor=n-v-c:block-blinkon0-nCursor,o:hor50,i-ci:hor15,r-cr:hor30,sm:block
set helpheight=12
set helplang=ja,en
set hidden
set history=10000
set hlsearch " nvim set by default
set ignorecase
set incsearch " nvim set by default
set infercase
set laststatus=2
set lazyredraw
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set number
set ruler
set scrolljump=4
set scrolloff=8
set shiftwidth=2
set showmode
set showtabline=2
set smartcase
set smartindent
set smarttab " nvim set by default
set switchbuf=useopen
set tabstop=2
set tags=./tags;,tags " nvim set by default
set textwidth=0
set timeout
set timeoutlen=350
set title
set titlelen=120
set ttimeout
set ttimeoutlen=0
set undodir=~/.nvim/undo
set undofile
set updatetime=10000
set wildignore+=*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore=.git,.hg,.svn
set wildmenu " nvim set by default
set nofoldenable
set wildmode=longest,full
set wrap

set nobackup
set nocursorcolumn
set nocursorline
set nodigraph
set noerrorbells
set noesckeys
set norelativenumber
set noshowcmd
set noshowmatch
set noswapfile
set novisualbell
set nowrapscan
set nowritebackup
"}}}


" nvimrc augroup "{{{
" syntax highlight's is ~/.nvim/after/syntax/vim.vim
augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>
" }}}


"
" Plugin settings "{{{
"

" vim-plug
let g:plug_window = 'vertical botright new'


" deoplete.nvim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 0
Gautocmd BufRead * silent :NeoSnippetSource<CR>
" Enable <expr><C-Space> keymap
imap     <Nul> <C-Space>
inoremap <expr><C-Space> deoplete#mappings#manual_complete()
inoremap <expr><BS>      deoplete#mappings#close_popup()."\<C-h>"
" Deoplete now support omni completion patterns is,
" https://github.com/Shougo/deoplete.nvim/blob/master/autoload/deoplete/init.vim#L111-L131
" g:deoplete#_omni_patterns, 'html,xhtml,xml,markdown,mkd', '<[^>]*')
" g:deoplete#_omni_patterns, 'css,scss,sass', ['^\s+\w+', '\w+[):;]?\s+\w*|[@!]'])
" g:deoplete#_omni_patterns, 'javascript', '[^. \t]\.([a-zA-Z_]\w*)?')
" g:deoplete#_omni_patterns, 'python', '[^. \t]\.\w*')
" g:deoplete#_omni_patterns, 'ruby', ['[^. \t]\.\w*', '[a-zA-Z_]\w*::\w*'])
" https://github.com/Shougo/neocomplete.vim/blob/master/autoload/neocomplete/sources/omni.vim
Gautocmd BufRead FileType * set omnifunc=&syntaxcomplete#Complete
let g:deoplete#omni_patterns          = {}
let g:deoplete#omni_patterns.c        = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:deoplete#omni_patterns.clojure  = '\%(([^)]\+\)\|\*[[:alnum:]_-]\+'
let g:deoplete#omni_patterns.cpp      = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:deoplete#omni_patterns.go       = '[^.[:digit:] *\t]\.\w*' " ? '\h\w*\.\?'
let g:deoplete#omni_patterns.java     = '\%(\h\w*\|)\)\.\w*'
let g:deoplete#omni_patterns.objc     = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:deoplete#omni_patterns.objj     = '[\[ \.]\w\+$\|:\w*$'
let g:deoplete#omni_patterns.perl     = '\h\w*->\h\w*\|\h\w*::\w*'
let g:deoplete#omni_patterns.php      = '[^. \t]->\h\w*\|\h\w*::\w*'
let g:deoplete#omni_patterns.rust     = '[^.[:digit:] *\t]\%(\.\|\::\)\%(\h\w*\)\?'

" Unite.vim
let g:unite_data_directory = $HOME . '/.cache/unite/'
let g:unite_split_rule = 'botright'
if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --parallel'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_encoding = 'utf-8'
endif


" vimfiler
let g:vimfiler_data_directory = $HOME . '/.cache/vimfiler'


" lightline
let g:lightline = { 'colorscheme': 'ux' }
let g:lightline.active = {
  \ 'left':  [ [ 'mode', 'paste' ],
  \            [ 'filetype' ],
  \            [ 'readonly', 'absolutepath' ] ],
  \ 'right': [ [ 'lineinfo', 'percent' ],
  \            [ 'fileencoding' ] ]
  \ }
let g:lightline.inactive = {
  \ 'left':  [ [ 'filename' ] ],
  \ 'right': [ [ 'lineinfo' ],
  \            [ 'percent' ] ]
  \ }
let g:lightline.tabline = {
  \  'left':  [ [ 'tabs' ] ],
  \  'right': [
  \    [ 'git_branch', 'git_traffic', 'git_status', 'cwd' ],
  \  ],
  \ }
let g:lightline.tab = {
  \ 'active': [ 'tabnum', 'filename', 'modified' ],
  \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
  \ }
let g:lightline.component = {
  \ 'mode': '%{lightline#mode()}',
  \ 'absolutepath': '%F',
  \ 'relativepath': '%f',
  \ 'filename': '%t',
  \ 'modified': '%M',
  \ 'bufnum': '%n',
  \ 'paste': '%{&paste?"PASTE":""}',
  \ 'readonly': '%{&readonly?"":""}',
  \ 'charvalue': '%b',
  \ 'charvaluehex': '%B',
  \ 'fileencoding': '%{strlen(&fenc)?&fenc:&enc}',
  \ 'fileformat': '%{&fileformat}',
  \ 'filetype': '%{strlen(&filetype)?&filetype:"no ft"}',
  \ 'percent': '%3p%%',
  \ 'percentwin': '%P',
  \ 'spell': '%{&spell?&spelllang:"no spell"}',
  \ 'lineinfo': '%3l:%-2v',
  \ 'line': '%l',
  \ 'column': '%c',
  \ 'close': '%999X X '
  \ }
" let g:lightline.component_visible_condition = {
"   \  'lineinfo': '(winwidth(0) >= 70)',
"   \ },
"   \ 'component_function': {
"   \   'git_branch': 'g:lightline.my.git_branch',
"   \   'git_traffic': 'g:lightline.my.git_traffic',
"   \   'git_status': 'g:lightline.my.git_status',
"   \ },
let g:lightline.tab_component_function = {
  \ 'pyenv': 'pyenv#statusline#component',
  \ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }


" CtrlP
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50,results:50'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_max_files = 100
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_user_command = 'files -p %s'


" Tagbar
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


" gitgutter
let g:gitgutter_enabled = 1
let g:gitgutter_realtime = 1
let g:gitgutter_sign_column_always = 1
let g:gitgutter_max_signs = 1000


" NERDTree
let NERDTreeHijackNetrw=1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1


" nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']


" yankround
let g:yankround_dir = $HOME . "/.cache/yankround"


" wakatime
let g:wakatime_PythonBinary = '/usr/local/bin/python'


" haya14busa/incsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)


" mattn/ctrlp-ghq
let g:ctrlp_ghq_actions = [
\ {"label": "open", "action": "e", "path": 1},
\ {"label": "look", "action": "!ghq look", "path": 0},
\]
let ctrlp_ghq_default_action = 'e'
let g:ctrlp_ghq_cache_enabled = 1


" tinca/quickrun
" Will rewrite port Neomake?
" https://github.com/rhysd/dotfiles/blob/master/nvimrc#L833-L888
"
" Init quickrun_config
let g:quickrun_config = get(g:, 'quickrun_config', {})
" Check file syntax
" https://github.com/rhysd/dotfiles/blob/master/vimrc#L2280-L2287

" Global config
let g:quickrun_config._ = {
  \ 'outputter' : 'error:buffer:quickfix',
  \ 'split' : 'rightbelow 12sp',
  \ }
" outputter
let g:quickrun_unite_quickfix_outputter_unite_context = { 'no_empty' : 1 }
" Polling interval use runner vimproc
let g:quickrun_config['_']['runner/vimproc/updatetime'] = 500
Gautocmd BufReadPost,BufNewFile [Rr]akefile{,.rb} let b:quickrun_config = {'exec': 'rake -f %s'}

" FileType config
function! s:check_syntax(ft) abort
    let type = 'syntax/' . a:ft
    if has_key(g:quickrun_config[type], 'command') && !executable(g:quickrun_config[type].command)
        return
    endif
    execute 'QuickRun' '-type' type
endfunction

" Go
let g:quickrun_config['syntax/go'] = {
  \ 'command' : 'go',
  \ 'exec' : '%c vet %o %s:p',
  \ 'outputter' : 'quickfix',
  \ 'runner' : 'vimproc',
  \ 'errorformat' : '%Evet: %.%\+: %f:%l:%c: %m,%W%f:%l: %m,%-G%.%#',
  \ }
let g:quickrun_config['lint/go'] = {
  \ 'command' : 'golint',
  \ 'exec' : '%c %o %s:p',
  \ 'outputter' : 'quickfix',
  \ 'runner' : 'vimproc',
  \ }
Gautocmd BufWritePost *.go call <SID>check_syntax('go')

" JavaScript
function! s:check_js_syntax() abort
  if &ft ==# 'javascript'
      \ && has_key(g:quickrun_config['syntax/javascript'], 'command')
      \ && executable(g:quickrun_config['syntax/javascript'].command)
      \ && getline(1) !~? '^//\s\+jsx'
      QuickRun -type syntax/javascript
  endif
endfunction
let g:quickrun_config['syntax/javascript'] = {
  \ 'command' : 'jshint',
  \ 'outputter' : 'quickfix',
  \ 'exec'    : '%c %o %s:p',
  \ 'runner' : 'vimproc',
  \ 'errorformat' : '%f: line %l\, col %c\, %m',
  \ }
Gautocmd BufWritePost *.js call <SID>check_js_syntax()

" Ruby
let g:quickrun_config['syntax/ruby'] = {
  \ 'runner' : 'vimproc',
  \ 'outputter' : 'quickfix',
  \ 'command' : 'ruby',
  \ 'exec' : '%c -c %s:p %o',
  \ }
Gautocmd BufWritePost *.rb call <SID>check_syntax('ruby')

" Crystal
let g:quickrun_config['syntax/crystal'] = {
  \   'command' : 'crystal',
  \   'cmdopt' : 'run --no-build --no-color',
  \   'exec' : '%c %o %s:p',
  \   'outputter' : 'quickfix',
  \   'runner' : 'vimproc',
  \ }
Gautocmd BufWritePost *.cr call <SID>check_syntax('crystal')

" Python
let g:quickrun_config['syntax/python'] = {
  \ 'command' : 'pyflakes',
  \ 'exec' : '%c %o %s:p',
  \ 'outputter' : 'quickfix',
  \ 'runner' : 'vimproc',
  \ 'errorformat' : '%f:%l:%m',
  \ }
Gautocmd BufWritePost *.py call <SID>check_syntax('python')

" Rust
let g:quickrun_config['syntax/rust'] = {
  \   'command' : 'rustc',
  \   'cmdopt' : '-Zparse-only',
  \   'exec' : '%c %o %s:p',
  \   'outputter' : 'quickfix',
  \ }
Gautocmd BufWritePost *.rs call <SID>check_syntax('rust')

" tmux
let g:quickrun_config['tmux'] = {
  \ 'command' : 'tmux',
  \ 'cmdopt' : 'source-file',
  \ 'exec' : ['%c %o %s:p', 'echo "sourced %s"'],
  \ }

" Haml
let g:quickrun_config['syntax/haml'] = {
  \ 'runner' : 'vimproc',
  \ 'command' : 'haml',
  \ 'outputter' : 'quickfix',
  \ 'exec'    : '%c -c %o %s:p',
  \ 'errorformat' : 'Haml error on line %l: %m,Syntax error on line %l: %m,%-G%.%#',
  \ }
Gautocmd BufWritePost *.haml call <SID>check_syntax('haml')

" C++
let g:quickrun_config.cpp = {
  \ 'command' : 'clang++',
  \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
  \ }
let g:quickrun_config['cpp/llvm'] = {
  \ 'type' : 'cpp/clang++',
  \ 'exec' : '%c %o -emit-llvm -S %s -o -',
  \ }
let g:quickrun_config['c/llvm'] = {
  \ 'type' : 'c/clang',
  \ 'exec' : '%c %o -emit-llvm -S %s -o -',
  \ }
let g:quickrun_config['dachs'] = {
  \ 'command' : './bin/dachs',
  \ }
let g:quickrun_config['dachs/llvm'] = {
  \ 'type' : 'dachs',
  \ 'cmdopt' : '--emit-llvm',
  \ }
let g:quickrun_config['llvm'] = {
  \ 'exec' : 'llvm-as-3.4 %s:p -o=- | lli-3.4 - %a',
  \ }
" Only pre-process
let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/clang'] = { 'command' : 'clang++', 'cmdopt' : '-stdlib=libc++ -std=c++11 -Wall -Wextra -O2' }
Gautocmd FileType cpp nnoremap <silent><buffer><Leader>qc :<C-u>QuickRun -type cpp/clang<CR>

" cpp/g++
let g:quickrun_config['syntax/cpp/g++'] = {
  \ 'runner' : 'vimproc',
  \ 'outputter' : 'quickfix',
  \ 'command' : 'g++',
  \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
  \ 'exec' : '%c %o -fsyntax-only %s:p'
  \ }

" llc
if executable('llc-3.5')
  let g:vimrc_llc_command = 'llc-3.5'
elseif executable('llc')
  let g:vimrc_llc_command = 'llc'
endif
if exists('g:vimrc_llc_command')
  let g:quickrun_config['syntax/llvm'] = {
    \ 'command' : g:vimrc_llc_command,
    \ 'cmdopt' : '-filetype=null -o=/dev/null',
    \ 'exec' : '%c %o %s:p',
    \ 'outputter' : 'quickfix',
    \ 'runner' : 'vimproc',
    \ }
  Gautocmd BufWritePost *.ll QuickRun -type syntax/llvm
endif


" vim-markdown
let g:vim_markdown_folding_disabled = 1

" }}}


" vital-exe-assert
let g:__vital_exe_assert_config = { '__debug__': 1, '__abort__': 0 }
let s:V = vital#of('vital')
let g:assert = s:V.import('ExeAssert').make()


" tyru/open-browser.vim
let g:netrw_nogx = 1 
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
map  gz <Plug>(operator-open-plugpath)

call operator#user#define('open-plugpath', 'OpenPlugPath')
function! OpenPlugPath(motion_wise)
  if line("'[") != line("']")
    return
  endif
  let start = col("'[") - 1
  let end = col("']")
  let sel = strpart(getline('.'), start, end - start)
  let sel = substitute(sel, '^\%(github\|gh\|git@github\.com\):\(.\+\)', 'https://github.com/\1', '')
  let sel = substitute(sel, '^\%(bitbucket\|bb\):\(.\+\)', 'https://bitbucket.org/\1', '')
  let sel = substitute(sel, '^gist:\(.\+\)', 'https://gist.github.com/\1', '')
  let sel = substitute(sel, '^git://', 'https://', '')
  if sel =~ '^https\?://'
    call openbrowser#open(sel)
  elseif sel =~ '/'
    call openbrowser#open('https://github.com/'.sel)
  else
    call openbrowser#open('https://github.com/vim-scripts/'.sel)
  endif
endfunction


" thinca/vim-ref
" let g:ref_open = 'call On_FileType_doc_define_mappings() botright 10split'
let g:ref_cache_dir = $HOME . '/.cache/vim-ref'
let g:red_use_vimproc = 1
let g:ref_noenter = 1


"
" File Syntax "{{{
"
" Go
" Cover all the vim-go settings
let g:play_browser_command = ''
let g:go_play_open_browser = 1
let g:go_auto_type_info = 0
let g:go_jump_to_error = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_options = ''
let g:go_fmt_fail_silently = 0
let g:go_fmt_experimental = 0
let g:go_doc_keywordprg_enabled = 1
let g:go_def_mapping_enabled = 1
let g:go_dispatch_enabled = 0
let g:go_doc_command = "godoc"
let g:go_doc_options = ''
let g:go_bin_path = $GOPATH . "/bin"
let g:go_snippet_engine = "neosnippet"
let g:go_oracle_scope = ''
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_build_constraints = 1
let g:go_autodetect_gopath = 1
let g:go_textobj_enabled = 1
" vim-gocode
let g:gocomplete#system_function = 'vimproc#system'
" vim-godef
let g:godef_split=0
Gautocmd BufWritePost *.go silent! !ctags -R &
" Switch horizontal and vertical open
Gautocmd FileType go nmap .g         :call GodefUnderCursor()<cr>
Gautocmd FileType go nmap .r         <Plug>(go-run)
Gautocmd FileType go nmap .f         :GoFmt<CR>


" ruby
" Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>
" Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
" }}}



"
" autocmd "{{{
"
" autocmd BufEnter * :syntax sync fromstart

" develop nvimrc helper
Gautocmd BufWritePost $MYVIMRC,~/.nvimrc,*.vim nested silent! source $MYVIMRC
Gautocmd FileType,WinEnter $MYVIMRC,~/.nvimrc,vim set tags=~/.nvim/tags
Gautocmd BufWritePost *.vim silent! !cd ~/.nvim/ && ctags -R --languages=Vim -F ~/.nvim &
Gautocmdft vim nnoremap ,m :ColorToggle<CR>

Gautocmd BufWritePost * Neomake

" Vimgrep results in quickfix window
Gautocmd QuickFixCmdPost *grep* cwindow

" for languages documents
Gautocmdft help   call On_FileType_doc_define_mappings()
Gautocmdft ref call On_FileType_doc_define_mappings()
" }}}


"
" Function "{{{
"

function! ToggleRelativeNumber()
  if(&relativenumber == 1) && (&number == 1)
    set nonumber
    set norelativenumber
  elseif(&number == 1)
    set number
    set relativenumber
  else
    set norelativenumber
    set number
  endif
endfunc

function! ToggleCursorline()
  if !(&cursorline)
    set cursorline
  else
    set nocursorline
  endif
endfunc

function! On_FileType_doc_define_mappings()
  if &l:readonly
    " Jump to under the cursor word tags
    nnoremap <buffer>J <C-]>
    " Back to the before tag jump buffer
    nnoremap <buffer>K <C-t>
    " Select the linked word
    nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
    " less like
    nnoremap <buffer>u <C-u>
    nnoremap <buffer>d <C-d>
    nnoremap <buffer>q :<C-u>q<CR>
  endif
endfunction

" }}}


"
" Hack "{{{
"

" Vsplit scroll hack
" http://qiita.com/kefir_/items/c725731d33de4d8fb096
if has('vertsplit')
  function! g:EnableVsplitMode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l\e[999H" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6;69h" ], "/dev/tty", "a")
  endfunction
  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>
  " new vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R g:EnableVsplitMode()
  set t_F9=[3;3R
  map <expr> <t_F9> g:EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" http://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if $TERM =~ '^xterm'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <Up>=\Eku"
  execute "set <Down>=\Ekd"
  execute "set <Right>=\Ekr"
  execute "set <Left>=\Ekl"
  execute "set <xUp>=\Eku"
  execute "set <xDown>=\Ekd"
  execute "set <xRight>=\Ekr"
  execute "set <xLeft>=\Ekl"
endif
if $TERM =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" http://vim.wikia.com/wiki/Fix_arrow_keys_that_display_A_B_C_D_on_remote_shell
noremap <silent> <Up> <Nop>
noremap <silent> <Down> <Nop>
noremap <silent> <Right> <Nop>
noremap <silent> <Left> <Nop>
nnoremap <silent> <Up>    <Nop>
nnoremap <silent> <Down>  <Nop>
nnoremap <silent> <Right> <Nop>
nnoremap <silent> <Left>  <Nop>
nnoremap <silent> <Left>  h
nnoremap <silent> <Down>  j
nnoremap <silent> <Up>    k
nnoremap <silent> <Right> l
vnoremap <silent> <Left>  <Left>
vnoremap <silent> <Down>  <Down>
vnoremap <silent> <Up>    <Up>
vnoremap <silent> <Right> <Right>

" When cursor key's digraphs, return triple <ESC>
Gautocmd InsertCharPre <buffer> if v:char == 'Û' | "\<ESC>\<ESC>\<ESC>" | endif
" }}}


"
" Syntax "{{{
"
Gautocmd BufRead,BufNewFile *dockerfile set filetype=Dockerfile.Bash
Gautocmd BufRead,BufNewFile Dockerfile* set filetype=Dockerfile.Bash
" }}}


"
" Temporary plugin "{{{
"

" Multiline search
" http://vim.wikia.com/wiki/Search_across_multiple_lines
" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

" https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
" When editing a file, always jump to the last known cursor position.  Don't
" do it when the position is invalid or when inside an event handler
" Also don't do it when the mark is in the first line, that is the default
" POSITIon when opening a file.
Gautocmd BufReadPost *
  \  if line("'\"") > 1 && line("'\"") <= line("$") |
  \    execute "normal! g`\"" |
  \  endif
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif

" Trim whitespace when write buffer
" Without mkd or markdown FileTypes
Gautocmd BufWritePre if FileType != 'mkd,markdown' ? :%s/\s\+$//ge : ''

" Auto cursorline when change window
" http://d.hatena.ne.jp/thinca/20090530/1243615055

Gautocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
Gautocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
Gautocmd WinEnter * call s:auto_cursorline('WinEnter')
Gautocmd WinLeave * call s:auto_cursorline('WinLeave')

let s:cursorline_lock = 0
function! s:auto_cursorline(event)
  if a:event ==# 'WinEnter'
    setlocal cursorline
    let s:cursorline_lock = 2
  elseif a:event ==# 'WinLeave'
    setlocal nocursorline
  elseif a:event ==# 'CursorMoved'
    if s:cursorline_lock
      if 1 < s:cursorline_lock
        let s:cursorline_lock = 1
      else
        setlocal nocursorline
        let s:cursorline_lock = 0
      endif
    endif
  elseif a:event ==# 'CursorHold'
    setlocal cursorline
    let s:cursorline_lock = 1
  endif
endfunction

" smart help window
" https://github.com/rhysd/dotfiles/blob/master/nvimrc#L380-L405
command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)
nnoremap <silent><Leader>h :<C-u>SmartHelp<Space><C-l>
function! s:smart_help(args)
    try
        if winwidth(0) > winheight(0) * 2
            execute 'vertical botright help ' . a:args
        else
            execute 'botright help ' . a:args
        endif
    catch /^Vim\%((\a\+)\)\=:E149/
        echohl ErrorMsg
        echomsg "E149: Sorry, no help for " . a:args
        echohl None
    endtry
    if &buftype ==# 'help'
        if winwidth(0) < 80
            execute 'quit'
            execute 'tab help ' . a:args
        endif
        silent! AdjustWindowWidth --direction=shrink
    endif
endfunction
" }}}


"
" Keymap "{{{
" Swap semicolon and colon is move to Karabiner
"

" kana/Arpeggio
call arpeggio#load()
Arpeggiomap oc <Plug>(operator-comment)
Arpeggiomap od <Plug>(operator-uncomment)
Arpeggiomap sh :<C-u>tabnew<CR>:<C-u>terminal<CR>

" Prefix
" <Space> q . (k) s
" Dvorak Center
nnoremap <Space> <Nop>
" Dvorak Leftside
nnoremap q       <Nop>
nnoremap .       <Nop>
" Dvorak Rightside
nnoremap s       <Nop>

nnoremap .b   :CtrlPBuffer<CR>
nnoremap .c   :CtrlPCmdline<CR>
nnoremap .l   :call ToggleCursorline()<CR>
nnoremap .n   gt
nnoremap .p   gT
nnoremap .r   :call ToggleRelativeNumber()<CR>
nnoremap .s   :<C-u>split<CR>
nnoremap .t   :<C-u>tabnew<CR>
nnoremap .u   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap .v   :<C-w>vsplit<CR>
nnoremap .w   <C-w>w
nnoremap .y   :CtrlPYankRound<CR>

" Map Leader
let mapleader = "\<Space>"
nnoremap <Leader>ct :!cd $PWD/$(git rev-parse --show-cdup) && !ctags -R .<CR>
nnoremap <Leader>h  :<C-u>SmartHelp<Space>
nnoremap <Leader>n  :TagbarToggle<CR>
nnoremap <Leader>r  :QuickRun<CR>
nnoremap <Leader>t  :NERDTreeToggle<CR>
nnoremap <Leader>w  :w<CR>
noremap  <Leader>g  :<C-u>CtrlPGhq<CR>

" yankround
nmap p  <Plug>(yankround-p)
xmap p  <Plug>(yankround-p)
nmap P  <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)

"
" Normal
"
" Switch dot(.) to comma(,)
nnoremap ,     .
" Disable suspend nvim
nnoremap Z     <Nop>
nnoremap ZZ    <Nop>
nnoremap ZQ    <Nop>
nnoremap <C-z> <Nop>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
" Don't use Ex mode, use Q for formatting
nnoremap Q gq
" Go to home and end using capitalized directions
nnoremap H ^
nnoremap L $
nnoremap <S-Left>  ^
nnoremap <S-Right> $
" Jump to match pair brackets
nnoremap <Tab> %
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
nnoremap <M-h> :<C-u>SmartHelp<Space><C-R><C-w><CR>
nnoremap zk    zkzkzj

" 
" Insert
" 
inoremap <silent> jj <ESC>
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
inoremap <silent> <M-l> <C-o><S-a>
" Delete before current cursor
inoremap <silent> <C-d>H <Esc>lc^
" Delete after current cursor
inoremap <silent> <C-d>L <Esc>lc$
" Yank before current cursor
inoremap <silent> <C-y>H <Esc>ly0<Insert>
" Yank after current cursor
inoremap <silent> <C-y>L <Esc>ly$<Insert>
" https://github.com/neovim/neovim/issues/2701
set <F37>=^?
inoremap <F37> <C-w>

"
" Visual
"

" When type 'x' key(delete), do not add yank register
vnoremap x "_x
" Enable increment | decrement when then state Visual mode
" http://vim-jp.org/blog/2015/06/30/visual-ctrl-a-ctrl-x.html
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
" Search current cursor words '*' key
vnoremap * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" Move to end of line to type double small 'v'
vnoremap v $h
" Jump to match pair brackets
vnoremap <Tab> %

" Command line
" Save on superuser
cmap w!! w !sudo tee > /dev/null %
" }}}


"
" Neovim configuration "{{{
"

" Most required absolude python path.
" Not works '~' of relative pathon path.
" And, installed neovim python client by `pip install neovim`
let g:python3_host_prog  = '/usr/local/bin/python3'
let g:python_host_prog   = '/usr/local/bin/python'
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

" Environment variables
let $NVIM_LISTEN_ADDRESS='/tmp/nvim'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" TERM config
if exists(':terminal')
  let g:terminal_color    = 'xterm-256color'
  " allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000
  " map esc to exit to normal mode in terminal too
  tnoremap <Esc><Esc> <C-\><C-n>
endif

" vim: foldmethod=marker
