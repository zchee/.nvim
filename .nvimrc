"                                                                                                  '
" `                                                                                                `
"                  /\ \                                             __                              
"    ____      ___ \ \ \___       __      __         ___    __  __ /\_\     ___ ___    _ __   ___   
"   /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\     /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\ 
"   \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/     /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/ 
"     /\____\\ \____\ \ \_\ \_\\ \____\\ \____\    \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\
"     \/____/ \/____/  \/_/\/_/ \/____/ \/____/     \/_/\/_/ \/__/    \/_/ \/_/\/_/\/_/ \/_/ \/____/
" `                                                                                                `
"                                                                                                  '
" Prefix
" autocmd             is Gautocmd
" autocmd FileType    is Gautocmdft
" Other custom prefix is e(dit)
"
" e.g. g:lightline.!e!.git_branch()
" Warning - prefix is It might changes.
" It varies with my mood.


" Init "{{{
set encoding=utf-8
set cpo&vim
scriptencoding utf-8
" }}}

" NeoBundle "{{{
set runtimepath+=~/.nvim/bundle/neobundle.vim
call neobundle#begin(expand('~/.nvim/bundle/'))

NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'bruno-/vim-man'
NeoBundle 'cespare/vim-toml'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'godlygeek/tabular'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'jiangmiao/auto-pairs'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'justinmk/vim-dirvish'
NeoBundle 'kana/vim-arpeggio'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'sgur/ctrlp-extensions.vim'
NeoBundle 'Shougo/deoplete.nvim'
NeoBundle 'Shougo/unite-help'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'Shougo/neco-syntax'
NeoBundle 'Shougo/neco-vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/vimproc.vim', { 'build' : { 'mac' : 'make -f make_mac.mak', 'linux' : 'make', 'unix' : 'gmake' } }
NeoBundle 'thinca/vim-operator-sequence'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-singleton'
NeoBundle 'thinca/vim-themis'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/operator-camelize.vim'
NeoBundle 'wakatime/vim-wakatime'
NeoBundle 'yuku-t/vim-ref-ri'


NeoBundleLazy 'Shougo/unite.vim', {
        \       'autoload' : {
        \         'commands' : [{'name': 'Unite', 'complete' : 'customlist,unite#complete_source'},
        \                      {'name': 'UniteWithBufferDir', 'complete' : 'customlist,unite#complete_source'},
        \                      {'name': 'UniteWithCursorWord', 'complete' : 'customlist,unite#complete_source'},
        \                      {'name': 'UniteWithWithInput', 'complete' : 'customlist,unite#complete_source'}]
        \       }
        \     }
NeoBundleLazy 'Shougo/unite-outline', {
       \        'autoload' : {
       \          'commands' : 'Unite'
       \        }
       \      }
NeoBundleLazy 'Shougo/vimfiler.vim', {
       \        'depends' : 'Shougo/unite.vim',
       \          'autoload' : {
       \          'commands' : ['VimFiler', 'VimFilerCurrentDir',
       \                        'VimFilerBufferDir', 'VimFilerSplit',
       \                        'VimFilerExplorer', 'VimFilerDouble']
       \        }
       \      }
NeoBundleLazy 'benekastah/neomake', {
       \        'autoload' : {
       \          'commands' : 'Neomake'
       \        }
       \      }
NeoBundleLazy 'lambdalisue/vim-gista', {
       \        'autoload' : {
       \          'commands' : 'Gista'
       \        }
       \      }
NeoBundleLazy 'lambdalisue/vim-gita', {
       \        'autoload' : {
       \          'commands' : 'Gita'
       \        }
       \      }
NeoBundleLazy 'majutsushi/tagbar', {
       \        'autoload' : {
       \          'commands' : 'Tagbar'
       \        }
       \      }

" vim-operator-user
NeoBundleLazy 'kana/vim-operator-replace', {
       \        'autoload' : {
       \          'mappings' : '<Plug>(operator-replace)'
       \        }
       \      }
NeoBundleLazy 'emonkak/vim-operator-comment', {
       \        'autoload' : {
       \          'mappings' : '<Plug>(operator-comment)'
       \        }
       \      }
NeoBundleLazy 'emonkak/vim-operator-sort', {
       \        'autoload' : {
       \          'mappings' : '<Plug>(operator-sort)'
       \        }
       \      }

" open-browser
NeoBundleLazy 'tyru/open-browser.vim', {
       \        'autoload' : {
       \          'commands' : ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch'],
       \          'mappings' : '<Plug>(openbrowser-',
       \        }
       \      }
NeoBundleLazy 'tyru/open-browser-github.vim', {
       \        'depends' : 'tyru/open-browser.vim',
       \        'autoload' : {
       \          'commands' : ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq']
       \        }
       \      }

"
" Language syntax
"

" Go
NeoBundleLazy 'Blackrush/vim-gocode', {
        \       'autoload' : {
        \         'filetypes' : 'go',
        \       }
        \     }
NeoBundleLazy 'dgryski/vim-godef', {
        \       'autoload' : {
        \         'filetypes' : 'go',
        \       }
        \     }
NeoBundleLazy 'fatih/vim-go', {
        \       'autoload' : {
        \         'filetypes' : 'go',
        \       }
        \     }
NeoBundle 'kamichidu/vim-textobj-function-go', {
        \       'autoload' : {
        \         'filetypes' : 'go',
        \       }
        \     }

" Ruby
NeoBundleLazy 'basyura/unite-rails', {
       \        'autoload' : {'filetypes' : 'ruby'}
       \      }
NeoBundleLazy 'rhysd/vim-textobj-ruby', {
       \        'autoload' : {'filetypes' : 'ruby'}
       \      }
NeoBundleLazy 'rhysd/neco-ruby-keyword-args', {
       \        'autoload' : {'filetypes' : 'ruby'}
       \      }

" Python
NeoBundleLazy 'davidhalter/jedi-vim', {
        \       'autoload' : {
        \         'filetypes' : 'python',
        \       }
        \     }
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
        \       'autoload' : {
        \         'filetypes' : 'python',
        \       }
        \     }
NeoBundleLazy 'digitaltoad/vim-jade', {
        \       'autoload' : {
        \         'filetypes' : 'jade',
        \       }
        \     }

" Dockerfile
NeoBundleLazy 'ekalinin/Dockerfile.vim', {
        \       'autoload' : {
        \         'filetypes' : 'dockerfile',
        \       }
        \     }
NeoBundleLazy 'plasticboy/vim-markdown', {
        \       'autoload' : {
        \         'filetypes' : [ 'mkd', 'markdown' ]
        \       }
        \     }

" Vim Help
NeoBundleLazy 'vim-jp/vimdoc-ja', {
        \       'autoload' : {
        \         'filetypes' : 'help',
        \       }
        \     }

" Misc
NeoBundleLazy 'tmux-plugins/vim-tmux', {
        \       'autoload' : {
        \         'filetypes' : 'tmux',
        \       }
        \     }
NeoBundleLazy 'xu-cheng/brew.vim', {
        \       'autoload' : {
        \         'filetypes' : 'ruby',
        \       }
        \     }

" NeoBundle 'altercation/vim-colors-solarized'
" NeoBundle 'cocopon/colorswatch.vim'
" NeoBundle 'scrooloose/nerdtree'
" NeoBundle 'Align'
" NeoBundle 'critiqjo/lldb.nvim'
" NeoBundle 'docker/docker', { 'rtp': '/contrib/syntax/vim', 'for': ['Dockerfile'] }
" NeoBundle 'drmikehenry/vim-fixkey'
" NeoBundle 'google/vim-codefmt'
" NeoBundle 'google/vim-glaive'
" NeoBundle 'google/vim-maktaba'
" NeoBundle 'guns/xterm-color-table.vim', { 'on': ['XtermColorTable'] }
" NeoBundle 'haya14busa/incsearch.vim'
" NeoBundle 'haya14busa/vital-exe-assert'
" NeoBundle 'lambdalisue/vital-ArgumentParser'
" NeoBundle 'lambdalisue/vital-VCS-Git'
" NeoBundle 'LanguageTool'
" NeoBundle 'leafgarland/typescript-vim'
" NeoBundle 'mattn/benchvimrc-vim' ", { 'on': ['BenchVimrc'] }
" NeoBundle 'mattn/ctrlp-ghq'
" NeoBundle 'mattn/ctrlp-gist', { 'autoload': { 'commands': ['Gist'] } }
" NeoBundle 'mattn/gist-vim', { 'depends': 'mattn/webapi-vim' }
" NeoBundle 'tomtom/tcomment_vim'
" NeoBundle 'pgdouyon/vim-accio'
" NeoBundle 'Quramy/tsuquyomi'
" NeoBundle 'rhysd/try-colorscheme.vim'
" NeoBundle 'scrooloose/syntastic'
" NeoBundle 'Shougo/neoinclude.vim'
" NeoBundle 'Shougo/vimfiler' ", { 'on': ['VimFilerTab', 'VimFiler', 'VimFilerExplorer'] }
" NeoBundle 'SirVer/ultisnips'
" NeoBundle 'thinca/vim-quickrun'
" NeoBundle 'vim-jp/vital.vim'
" NeoBundle 'vimcommunity/vim-pi'
" NeoBundle 'Yggdroot/indentLine'

call neobundle#end()
filetype plugin indent on
" }}}



"
" Settings "{{{
"
syntax on
colorscheme ux
" filetype on
" filetype plugin indent on

" Environment variables
let $TERMINFO = "/usr/local/share/terminfo"
let $TERM = 'rxvt-unicode-256color'

" set
" set autochdir
set autoindent " nvim set by default
set autoread
set backspace=indent,eol,start
set cindent
set clipboard+=unnamedplus
set cmdheight=1
set completeopt+=noselect,noinsert
set completeopt-=preview
set expandtab
set formatoptions+=j
set formatoptions+=l
set formatoptions-=c
set formatoptions-=o
set formatoptions-=r
set formatoptions-=t
set formatoptions-=v
set guicursor=n-v-c:block-nCursor,o:hor50,i-ci:hor15,r-cr:hor30,sm:block,a:blinkon0,a:block-nCursorblock-nCursor
set helpheight=12
set helplang=ja,en
set hidden
set history=10000
set hlsearch " nvim set by default
set ignorecase
set incsearch " nvim set by default
set laststatus=2
set lazyredraw
set list
set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
set notimeout
set number
set ruler
set scrolljump=1
set scrolloff=10
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
set timeoutlen=100
set nottimeout
set title
set titlelen=120
set ttimeout
set undodir=~/.nvim/undo
set undofile
set updatetime=10000
set wildignore+=*.DS_Store
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
set wildignore+=*.swp,*.swo,*.swn
set wildignore=.git,.hg,.svn
set wildmenu " nvim set by default
set wildmode=longest,full
set wrap

set nobackup
set nocursorcolumn
set nocursorline
set nodigraph
set noerrorbells
set noesckeys
set nofoldenable
set noinfercase
set norelativenumber
set noshowcmd
set noshowmatch
set noswapfile
set novisualbell
set nowrapscan
set nowritebackup
"}}}


" nvimrc user augroup "{{{
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
let g:deoplete#auto_completion_start_length = 2

Gautocmd BufRead * silent :NeoSnippetSource<CR>
" Enable <expr><C-Space> keymap
imap     <Nul> <C-Space>
inoremap <expr><C-Space> deoplete#mappings#manual_complete()
inoremap <expr><BS>      deoplete#mappings#close_popup()."\<C-h>"
inoremap <expr><Left>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
inoremap <expr><Right> pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
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
" let g:vimfiler_data_directory = $HOME . '/.cache/vimfiler'


" lightline
let g:lightline = { 'colorscheme': 'ux' }
let g:lightline.enable = {
  \ 'statusline': 1,
  \ 'tabline': 1
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
let g:lightline.active = {
  \ 'left':  [ [ 'mode', 'paste' ],
  \            [ 'filetype' ],
  \            [ 'readonly', 'absolutepath' ] ],
  \ 'right': [ [ 'lineinfo', 'percent' ],
  \            [ 'fileencoding' ] ]
  \ }
let g:lightline.inactive = {
  \ 'left':  [ [ 'filename' ] ],
  \ 'right': [ [ 'lineinfo', 'percent' ],
  \            [ 'fileencoding' ] ]
  \ }
let g:lightline.tabline = {
  \  'left':  [ [ 'tabs' ] ],
  \  'right': [ [ 'git_branch', 'git_traffic', 'git_status', 'cmd'] ]
  \ }
let g:lightline.tab = {
  \ 'active':   [ 'tabnum', 'filename', 'modified' ],
  \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
  \ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.component_function = {
  \ 'git_branch':  'g:lightline.my.git_branch',
  \ 'git_traffic': 'g:lightline.my.git_traffic',
  \ 'git_status':  'g:lightline.my.git_status'
  \ }
let g:lightline.my = {}
function g:lightline.my.git_branch()
  return gita#statusline#preset('branch')
endfunction
function g:lightline.my.git_traffic()
  return gita#statusline#preset('traffic')
endfunction
function g:lightline.my.git_status()
  return gita#statusline#preset('status')
endfunction


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
let g:gitgutter_map_keys = 0

" vim-dirvish
let g:dirvish_hijack_netrw = 1

" NERDTree
let NERDTreeHijackNetrw = 0
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1

" nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']


" yankround
let g:yankround_dir = $HOME . "/.cache/yankround"


" wakatime
let g:wakatime_PythonBinary = '/usr/local/bin/python'


" vim-markdown
let g:vim_markdown_folding_disabled = 1

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

nmap <Leader>o <Plug>(openbrowser-smart-search)
xmap <Leader>o <Plug>(openbrowser-smart-search)
nnoremap <Leader>O :<C-u>OpenGithubFile<CR>
vnoremap <Leader>O :OpenGithubFile<CR>
"}}}


" thinca/vim-ref
" let g:ref_open = 'call On_FileType_doc_define_mappings() botright 10split'
let g:ref_cache_dir = $HOME . '/.cache/vim-ref'
let g:red_use_vimproc = 1
let g:ref_noenter = 1

" }}}



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
Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>
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

" Vimgrep results in quickfix window
Gautocmd QuickFixCmdPost *grep* cwindow

" for languages documents
Gautocmdft help,ref,man call On_FileType_doc_define_mappings()
function! On_FileType_doc_define_mappings()
  " Select the linked word
  nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
  " less like keymap
  nnoremap <buffer>u <C-u>
  nnoremap <buffer>d <C-d>
  nnoremap <buffer>q :<C-u>q<CR>
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


"
" Syntax "{{{
"
" Gautocmd BufRead,BufNewFile *dockerfile set filetype=Bash.Dockerfile
" Gautocmd BufRead,BufNewFile Dockerfile* set filetype=Bash.Dockerfile

" Enable bash syntax on /bin/sh shevang
" http://tyru.hatenablog.com/entry/20101007/
let g:is_bash = 1

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

" VimShowHlGroup Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
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
nnoremap <Leader>c :!cd $PWD/$(git rev-parse --show-cdup) && !ctags -R .<CR>
nnoremap <Leader>h :<C-u>SmartHelp<Space><C-l>
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

Gautocmdft tmux nnoremap <silent><buffer> K :call tmux#man()<CR>

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
let g:python3_host_prog  = '/Users/zchee/.pyenv/shims/python3'
let g:python_host_prog  = '/Users/zchee/.pyenv/shims/python'
let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

" Environment variables
let $NVIM_LISTEN_ADDRESS='/tmp/nvim'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" TERM config
if exists(':terminal')
  let g:terminal_color    = 'rxvt-unicode-256color'
  " allow terminal buffer size to be very large
  let g:terminal_scrollback_buffer_size = 100000
  " map esc to exit to normal mode in terminal too
  tnoremap <Esc><Esc> <C-\><C-n>
endif

" vim: foldmethod=marker
