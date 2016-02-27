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
let $XDG_CONFIG_HOME = $HOME . '/.config'
let $XDG_CACHE_HOME = $HOME . '/.cache'

" Init
set runtimepath+=$XDG_CONFIG_HOME/nvim/dein.vim
call dein#begin(expand($XDG_CACHE_HOME . '/benchmark/ycm/dein'))

if dein#load_cache([expand('<sfile>')])
  " Plugin Manager
  call dein#add('Shougo/dein.vim', {'rtp': ''})

  " YCM
  call dein#add('Valloric/YouCompleteMe')
  call dein#add('rdnetto/YCM-Generator', { 'branch' : 'develop', 'on' : ['YcmGenerateConfig'] })

  " Async
  call dein#add('Shougo/vimproc.vim', { 'do' : 'make' })

  " Interface
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('justinmk/vim-dirvish')

  " Utility
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('haya14busa/vim-asterisk')

  " Rewriting TODO
  call dein#add('tomtom/tcomment_vim')

  " }}}

  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  " Language syntax plugins "{{{

  " C family
  call dein#add('vim-jp/vim-cpp', { 'on_ft' : ['c', 'cpp', 'objc', 'objcpp'] })

  call dein#save_cache()
endif
call dein#end()

" if dein#check_install()
"   call dein#install()
" endif

filetype plugin indent on

let g:dein#types#git#clone_depth = 1

" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Global settings "{{{

syntax on
set background=dark
colorscheme hybrid_reverse
let g:hybrid_use_iTerm_colors = 1
let g:enable_bold_font = 1

" set
set clipboard=unnamedplus
set cmdheight=2
set completeopt+=noinsert,noselect
set completeopt-=preview
set expandtab
set foldlevel=0
set foldmethod=marker
set helplang=ja,en
set hidden
set history=10000
set ignorecase
set laststatus=2
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set matchtime=0
set number
set pumheight=0
set ruler
set scrolljump=1
set scrolloff=10
set shiftround
set shiftwidth=2
set showcmd
set showmatch
set showmode
set showtabline=2
set smartcase
set smartindent
set softtabstop=2
set tabstop=2
set tags=./tags; " http://d.hatena.ne.jp/thinca/20090723/1248286959
set textwidth=0
set timeout " Mappnig timeout
set timeoutlen=300
set ttimeout " Keycode timeout
set ttimeoutlen=10
set undodir=$XDG_DATA_HOME/nvim/undo
set undofile
set updatecount=0
set updatetime=500
set wildignore+=*.DS_Store
set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=tags,*.tags
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class,*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.swp,*.swo,*.swn
set wildmode=list:full
set wrap

set path=.,/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include
set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/7.0.0/include
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
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_netrw             = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1

"}}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color "{{{
hi! SpecialKey                         gui=NONE    guifg='#25262c'    guibg=NONE
hi! TermCursor                         gui=NONE    guifg='#000000'    guibg=NONE

" C
" Or link highlight cCustomFunc Function
Gautocmdft c,cpp,objc,objcpp highlight cCustomFunc gui=NONE guifg='#f0c674'

"}}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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


" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Filetype settings "{{{

" C_Cpp_Objc_Objcpp:
Gautocmdft c,cpp,objc,objcpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" Protect header library
Gautocmd BufNewFile,BufRead /System/Library/Frameworks/* setlocal readonly nomodified
Gautocmd BufNewFile,BufRead /Applications/Xcode.app/Contents/* setlocal readonly nomodified
Gautocmd BufNewFile,BufRead /Applications/Xcode-beta.app/Contents/* setlocal readonly nomodified


" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin settings "{{{

" YCM
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
let g:ycm_extra_conf_globlist = ['./*','../*','../../*','../../../*','../../../../*','~/.nvim/*']
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_global_ycm_extra_conf = $HOME . '/.nvim/.ycm_extra_conf.py'
let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_path_to_python_interpreter = '/usr/local/bin/python2'
let g:ycm_seed_identifiers_with_syntax = 1


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


" vim-dirvish
let g:dirvish_hijack_netrw = 1
let g:dirvish_relative_paths = 1
" :set ma<bar>g@\v/\.[^\/]+/?$@d<cr>:set noma<cr>
" https://github.com/IanConnolly/dotfiles/blob/master/vimrc#L449
" function! DirvishIgnore() abort
"   silent! setlocal ma
"   silent! g@\v[\/]\.DS_Store/?$@d
"   silent! g@\v[\/]\.git/?$@d
"   silent! g@\v[\/]\.o/?$@d
"   silent! g@\v[\/]\.so/?$@d
"   silent! g@\v[\/]\.dylib/?$@d
"   silent! g@\v[\/]\.ycm_extra_conf\.py/?$@d
"   silent! g@\v[\/]\.ycm_extra_conf\.pyc/?$@d
"   silent! g@\v[\/]tags/?$@d
"   silent! setlocal noma
" endfunction
" Gautocmdft dirvish nnoremap <silent><buffer> gh :<C-u>call DirvishIgnore()<CR>
Gautocmd BufWinEnter dirvish silent! call feedkeys('gh')<CR>


" tcomment_vim
let g:tcommentMaps = 0
let g:tcommentMapLeader1 = 0


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
" witch next or previous tab
nnoremap <silent> .s   :bNext<CR>
" Create new tab
nnoremap <silent> .t   :<C-u>tabnew<CR>
" Quick editing init.vim
nnoremap <silent> .r   :<C-u>tabedit $MYVIMRC<CR>
" Vsplit and focus new buffer
nnoremap <silent> .v   :<C-w>vsplit<CR><C-w>w
" CtrlP yankround
nnoremap <silent> .y   :CtrlPYankRound<CR>
" Split and focus new buffer
nnoremap <silent> .z   :<C-u>split<CR><C-w>w

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
" Disable suspend
" nnoremap ZQ      <Nop>
" Switch suspend! map
nnoremap ZZ      ZQ

" Search current word, but not move next search word
map      *       <Plug>(asterisk-z*)
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

" Insert "{{{

" inoremap <silent>jj  <ESC>
" inoremap <silent>qq  <ESC>

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


" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual "{{{

" Do not add register to current cursor word
vnoremap c  "_c
" When type 'x' key(delete), do not add yank register
vnoremap x  "_x
vnoremap P  "_dP
vnoremap p  "_dp
" vnoremap gp p


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

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Command line "{{{

" Save on superuser
cmap w!!  :<C-u>w !sudo tee > /dev/null %
" Misstype <Leader>w handle
cnoremap  <silent> w<Space>  :<C-u>w<CR>

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Language mappnigs "{{{

" Cfamily:
Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><silent><C-]>  :<C-u>YcmCompleter GoTo<CR>
Gautocmdft c,cpp,objc,objcpp map      <buffer><Leader>x      <Plug>(operator-clang-format)
" Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><C-f>          :<C-u>pyfile /usr/local/src/llvm/tools/clang/tools/clang-format/clang-format.py<CR>

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugins mappings "{{{

" for YCM
inoremap <silent><expr><CR>    pumvisible() ? "\<C-y>" : "\<CR>"

" tcomment
nmap <silent> gc <Plug>TComment_gcc
xmap <silent> gc  <Plug>TComment_gc

" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
