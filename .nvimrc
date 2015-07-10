set encoding=utf-8
scriptencoding 'utf-8'

call plug#begin('~/.nvim/plugged')

" Plug 'mattn/ctrlp-gist', { 'autoload': { 'commands': ['Gist'] } }
" Plug 'mattn/gist-vim', { 'depends': 'mattn/webapi-vim' }
" Plug 'critiqjo/lldb.nvim'
" Plug 'justinmk/vim-dirvish'
Plug 'Align'
Plug 'LeafCage/yankround.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neco-vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
Plug 'Shougo/vimshell.vim'
Plug 'ThomasAdam/tmux', { 'rtp': '/examples' }
Plug 'airblade/vim-gitgutter'
Plug 'benekastah/neomake'
Plug 'chrisbra/Colorizer', { 'on': ['Colorizer'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'drmikehenry/vim-fixkey'
Plug 'guns/xterm-color-table.vim'
Plug 'haya14busa/incsearch.vim'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'ujihisa/unite-colorscheme'
Plug 'Shougo/unite.vim', { 'on': ['Unite', 'UniteWithBufferDir'] }
Plug 'Shougo/vimfiler', { 'on': ['VimFilerTab', 'VimFiler', 'VimFilerExplorer'] }
Plug 'Blackrush/vim-gocode', { 'for': ['go'] }
Plug 'Shougo/unite-outline', { 'on': ['Unite'] }
Plug 'davidhalter/jedi-vim', { 'for': ['python'] }
Plug 'dgryski/vim-godef', { 'for': ['go'] }
Plug 'docker/docker', { 'rtp': '/contrib/syntax/vim', 'for': ['Dockerfile'] }
Plug 'fatih/vim-go', { 'for': ['go'] }
Plug 'lambdalisue/vim-gista', { 'on': ['Gista'] }
Plug 'lambdalisue/vim-gita', { 'on': ['Gita'] }
Plug 'majutsushi/tagbar', { 'on': ['TagbarToggle'] }
Plug 'mattn/benchvimrc-vim', { 'on': ['BenchVimrc'] }
Plug 'vim-jp/vimdoc-ja', { 'on': ['help'] }
call plug#end()

filetype plugin indent on

" Load config
set runtimepath+=~/.nvim/.config/
runtime! ./.config/*.vim

"
" Settings
"
colorscheme ux
syntax on
syntax sync ccomment
filetype on
filetype indent on

let $TERM = 'screen-256color'

" set timeout
" set timeoutlen=300
" set ttimeout
" set ttimeoutlen=0
set autochdir
set autoindent " nvim set by default
set autoread
set backspace=indent,eol,start
set cindent
set clipboard& clipboard+=unnamedplus,unnamed
set cmdheight=1
set cursorline
set dir=~/tmp
set encoding=utf-8
set esckeys
set expandtab
set guicursor=n-v-c:block-blinkon0-nCursor,o:hor50,i-ci:hor15,r-cr:hor30,sm:block
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
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set nobackup
set nocompatible
set nocursorcolumn
set nocursorline
set noerrorbells
set noesckeys
set noshowmode
set noswapfile
set notimeout
set novisualbell
set nowrapscan
set nowritebackup
set number norelativenumber
set ruler
set scrolloff=5
set shiftwidth=2
set showcmd
set showmatch
set showmode
set showtabline=2
set smartcase
set smartindent
set smarttab " nvim set by default
set switchbuf=useopen
set t_ut=
set t_vb=
set tabstop=2
set tags-=./.tags " nvim set by default
set textwidth=0
set title
set titlelen=90
set ttimeout
set ttyfast
set undodir=~/.vim/cache/undo
set undofile
set updatetime=8000
set wildmenu " nvim set by default
set wildmode=longest,full
set wrap

"
" autocmd
"
autocmd BufEnter * :syntax sync fromstart

let $MYRUNTIMEPATH = &runtimepath
augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
  autocmd bufwritepost %runtimepath source $MYVIMRC
augroup END

" Vimgrep results in quickfix window
autocmd QuickFixCmdPost *grep* cwindow


"
" Function
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


"
" Hack
"
" Vsplit scroll hack
" http://qiita.com/kefir_/items/c725731d33de4d8fb096
" Use vsplit mode
" if has("vim_starting") && !has('gui_running') && has('vertsplit')
if has("vim_starting")
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
  set t_F9=[3;3R
  map <expr> <t_F9> g:EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif


"
" Keymap
" Swap semicolon and colon is move to Karabiner
"

"
" Prefix
"
nnoremap <Space> <Nop>
" Dvorak Leftside
nnoremap q       <Nop>
nnoremap ,       <Nop>
nnoremap .       <Nop>
nnoremap e       <Nop>
" Dvorak Rightside
nnoremap t       <Nop>
nnoremap s       <Nop>


nnoremap .b   :CtrlPBuffer<CR>
nnoremap .p   :CtrlPYankRound<CR>
nnoremap .c   :CtrlPCmdline<CR>
nnoremap .m   :CtrlPMenu<CR>
nnoremap .u   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
nnoremap .n   :call ToggleRelativeNumber()<CR>
nnoremap .l   :call ToggleCursorline()<CR>

nnoremap ,s   :<C-u>split<CR>
nnoremap ,v   :<C-w>vsplit<CR>
nnoremap ,t   :<C-u>tabnew<CR>
nnoremap ,n   gt
nnoremap ,p   gT
nnoremap ,w   <C-w>w
nnoremap ,j   <C-w>j
nnoremap ,k   <C-w>k
nnoremap ,l   <C-w>l
nnoremap ,h   <C-w>h


" Map Leader
let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>h :<C-u>vert bo h<Space>
nnoremap <Leader>n :TagbarToggle<CR>
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>b <Plug>(quickrun)
nmap     <leader>v <Plug>TaskList
vmap     <Leader>y "+y
vmap     <Leader>d "+d
nmap     <Leader>p "+p
nmap     <Leader>P "+P
vmap     <Leader>p "+p
vmap     <Leader>P "+P


" Maps
" yankround
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)


"
" Normal
"
noremap <silent> <Esc><Esc> :nohlsearch<CR>
" Don't use Ex mode, use Q for formatting
noremap Q gq
" Goto line-first, line-end
nnoremap H ^
nnoremap L $
nnoremap <Tab> %
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
nnoremap <M-h> :<C-u>vert bo h<Space><C-R><C-w><CR>
" Visual
vnoremap H ^
vnoremap L $
" When 'x' key(delete), do not add yank register
vnoremap x "_x
" http://vim-jp.org/blog/2015/06/30/visual-ctrl-a-ctrl-x.html
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
" Search oncursor words '*' key
vnoremap * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
" Move to end of line double small 'v' key
vnoremap v $h
" Jump to match pair brackets
vnoremap <Tab> %


" Insert
inoremap <silent> jj <ESC>
inoremap <C-U> <C-G>u<C-U>
" https://github.com/neovim/neovim/issues/2701
set <F37>=<M-BS>
inoremap <F37> <C-W>


"
" Command line
"
" Save on superuser
cmap w!! w !sudo tee > /dev/null %


" http://superuser.com/questions/401926/how-to-get-shiftarrows-and-ctrlarrows-working-in-vim-in-tmux
if $TERM =~ '^screen'
  " tmux will send xterm-style keys when its xterm-keys option is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif


"
" Neovim configuration
"

" Most required absolude python path.
" Not works '~' of relative pathon path.
" And, installed neovim python client by `pip install --user neovim`
let g:python3_host_prog  = '/Users/zchee/.pyenv/shims/python3'
let g:python_host_prog  = '/usr/local/bin/python'

" TERM config
" let $TERM='screen-256color'
let $NVIM_LISTEN_ADDRESS='/tmp/nvim'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if exists(':terminal')
  let g:terminal_color    = 'xterm-256color'
  " allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000
  " map esc to exit to normal mode in terminal too
  tnoremap <Esc><Esc> <C-\><C-n>
endif


"
" Plugin settings
"
" Initialize autogroup in InitAutoCmd
augroup InitAutoCmd
  autocmd!
augroup END

" deoplete.vim
let g:deoplete#enable_at_startup = 1
autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType c          setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby       setlocal omnifunc=rubycomplete#Complete
set completeopt+=noinsert
let g:deoplete#enable_ignore_case = 'ignorecase'
" https://github.com/Shougo/neocomplete.vim/blob/master/autoload/neocomplete/sources/omni.vim
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.html = '<[^>]*'
let g:deoplete#omni_patterns.xml  = '<[^>]*'
let g:deoplete#omni_patterns.md   = '<[^>]*'
let g:deoplete#omni_patterns.css   = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni_patterns.scss   = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni_patterns.sass   = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni_patterns.javascript = '[^. \t]\.\%(\h\w*\)\?'
let g:deoplete#omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:deoplete#omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
"let g:deoplete#omni_patterns.go = '[^.[:digit:] *\t]\.\w*'
let g:deoplete#omni_patterns.go = '\h\w*\.\?'
let g:deoplete#omni_patterns.ruby = ['[^. *\t]\.\w*', '\h\w*::']
let g:deoplete#omni_patterns.python = '[^. \t]\.\w*'
let g:deoplete#omni_patterns.python = ['[^. *\t]\.\h\w*\','\h\w*::']
let g:deoplete#omni_patterns.python3 = ['[^. *\t]\.\h\w*\','\h\w*::']
autocmd CmdwinEnter * let b:deoplete_sources = ["buffer","tag", "neosnippet"]
imap     <Nul> <C-Space>
inoremap <expr><C-Space> deoplete#mappings#manual_complete()
inoremap <expr><BS>      deoplete#mappings#smart_close_popup()."\<C-h>"

" the_platinum_searcher
if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_encoding = 'utf-8'
endif

" haya14busa/incsearch
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Neomake
" autocmd! BufEnter * Neomake

" itchyny/lightline
let g:lightline = {
  \ 'colorscheme': 'wombat',
  \ 'active': {
      \   'left': [
      \       [ 'mode', 'paste' ],
      \       [ 'pyenv' ],
      \       [ 'fugitive', 'filename' ]
      \   ],
  \ },
  \ 'component': {
  \   'readonly': '%{&readonly?"":""}p',
  \ },
  \ 'component_function': {
  \   'pyenv': 'pyenv#statusline#component',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' }
  \ }

" CtrlP
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/nvim/ctrlp'
let g:ctrlp_max_files = 100
" let g:ctrlp_user_command = 'files -p -A %s'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
if executable('pt')
  set grepprg="pt\ --nogroup\ --nocolor"
  let g:ctrlp_user_command = 'pt %s -l --nocolor ""'
endif
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

" golang
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_snippet_engine = "neosnippet"
let g:gofmt_command = 'goimports'
let g:godef_split=0
autocmd BufWritePost *.go silent! !ctags -R &
set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim
" Switch horizontal and vertical open
autocmd FileType go nmap ,g         :call GodefUnderCursor()<cr>
autocmd FileType go nmap ,r         <Plug>(go-run)
autocmd FileType go nmap ,f         :GoFmt<CR>

" tagbar
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
let g:gitgutter_signs = 0
let g:gitgutter_sign_column_always = 1
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1
let g:gitgutter_enabled = 1

" NERDTree
let NERDTreeHijackNetrw=1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
" autocmd BufEnter * lcd %:p:h

" auto-pairs
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutBackInsert = '<M-b>'

" dirvish
" augroup my_dirvish_events
"     au!
"     au User DirvishEnter let b:dirvish.showhidden = 1
" augroup END

" nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']

" yankround
let g:yankround_dir = "~/.history/vim/yankround"
"
" Neovim configuration
"

" Most required absolude python path.
" Not works '~' of relative pathon path.
" And, installed neovim python client by `pip install --user neovim`
let g:python3_host_prog  = '/Users/zchee/.pyenv/shims/python3'
let g:python_host_prog  = '/usr/local/bin/python'

" TERM config
" let $TERM='screen-256color'
let $NVIM_LISTEN_ADDRESS='/tmp/nvim'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
if exists(':terminal')
  let g:terminal_color    = 'xterm-256color'
  " allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000
  " map esc to exit to normal mode in terminal too
  tnoremap <Esc><Esc> <C-\><C-n>
endif


"
" Syntax
"
augroup filetypedetect
" autocmd BufRead,BufNewFile .tmux.conf*,tmux.conf* set filetype=tmux
  autocmd BufRead,BufNewFile *dockerfile set filetype=Dockerfile
  autocmd BufRead,BufNewFile Dockerfile* set filetype=Dockerfile
  "syntax include @Bash Dockerfile
augroup END


"
" Temporary plugin
"

" Don't exit vim when closing last tab with :q and :wq, :qa, :wqa
" cabbrev q   <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 && tabpagenr('$') == 1 && winnr('$') == 1 ? 'enew' : 'q')<CR>
" cabbrev wq  <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 && tabpagenr('$') == 1 && winnr('$') == 1 ? 'w\|enew' : 'wq')<CR>
" cabbrev qa  <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'tabonly\|only\|enew' : 'qa')<CR>
" cabbrev wqa <C-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'wa\|tabonly\|only\|enew' : 'wqa')<CR>

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
autocmd BufReadPost *
     \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   execute "normal! g`\"" |
     \ endif
if !exists(":DiffOrig")
 command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" Trim whitespace when write buffer
autocmd BufWritePre * :%s/\s\+$//ge

augroup auto_cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

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
augroup END


