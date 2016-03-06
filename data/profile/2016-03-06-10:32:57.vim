SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/init.vim
Sourced 1 time
Total time:   0.032607
 Self time:   0.003408

count  total (s)   self (s)
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
    1              0.000002 augroup GlobalAutoCmd
    1              0.000002   autocmd!
    1              0.000001 augroup END
    1              0.000012 command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
    1              0.000004 command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Environment variables "{{{
                            
    1              0.000021 let $XDG_CACHE_HOME = $HOME.'/.cache'
    1              0.000002 let $XDG_CONFIG_DIRS = '/etc/xdg'
    1              0.000003 let $XDG_CONFIG_HOME = $HOME.'/.config'
    1              0.000002 let $XDG_DATA_DIRS = '/usr/local/share:/usr/share'
    1              0.000003 let $XDG_DATA_HOME = $HOME.'/.local/share'
                            
                            " for llvm trunk
    1              0.000002 let $LD_LIBRARY_PATH='/opt/llvm/lib:/usr/local/lib:/usr/lib'
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " dein.vim settings "{{{
                            
                            " Initialize dein_dir : expect Fetch dein.vim automatically
    1              0.000008 let s:dein_dir = $XDG_CACHE_HOME . '/nvim/dein/repos/github.com/Shougo/dein.vim'
    1              0.000016 if !isdirectory(s:dein_dir)
    1              0.000003   let s:dein_dir = $XDG_CONFIG_HOME.'/nvim/dein.vim'
    1              0.000007   if !isdirectory(s:dein_dir)
                                execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
                              endif
    1              0.000001 endif
                            " Add dein_dir to &runtimepath
    1              0.000004 if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
                              " Use local dein.vim repository: mpack caching
                              " let s:dein_dir = $XDG_CONFIG_HOME.'/nvim/dein.vim'
    1              0.000034   execute 'set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
                              " echomsg s:dein_dir
    1              0.000001 endif
                            
                            " Set dein.vim variables
    1              0.000002 let g:dein#install_progress_type = 'statusline' " echo, statusline, tabline, title
    1              0.000047 let g:dein#types#git#default_protocol = 'ssh'
    1              0.000002 let g:dein#types#git#pull_command = 'pull --ff --ff-only'
                            
                            
                            " Start dark powered asynchronous...
    1              0.000057 call dein#begin(expand($XDG_CACHE_HOME . '/nvim/dein'))
                            
                            " Load dein cache if exists cache file
    1   0.003038   0.000011 if dein#load_cache([expand('<sfile>')])
                            
                              " Dark powered Vim/Neovim plugin manager
                              " call dein#add('Shougo/dein.vim', {'rtp': ''})
                              call dein#add('Shougo/dein.vim', { 'rtp': '', 'rev': '5615d50e937d7661c94fe7b4032ed612714b6e09' })
                            
                              " Local develop plugins
                              " call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['bufparser.nvim'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['deogoto.nvim'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['nvim-go'])
                              " call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['nvim-profiler'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1 }, ['treachery.nvim'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['c', 'cpp', 'objc', 'objcpp'] }, ['deoplete-clang'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['go'] }, ['deoplete-go'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['python'] }, ['nvim-pep8'])
                              call dein#local($HOME.'/src/github.com/zchee', {'frozen': 1, 'on_ft': ['python'] }, ['deoplete-jedi'])
                            
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
    1   0.000948   0.000016 call dein#end()
                            
    1   0.000289   0.000005 if dein#check_install()
                              call dein#install()
                            endif
                            
    1              0.000085 filetype plugin indent on
                            
                            " }}}
                            
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Global settings "{{{
                            
    1              0.000002 let g:hybrid_use_iTerm_colors = 1
    1              0.000001 let g:enable_bold_font = 1
    1              0.000037 colorscheme hybrid_reverse
    1              0.000037 syntax enable
                            
    1              0.000005 set autoindent
    1              0.000003 set clipboard=unnamedplus
    1              0.000005 set cmdheight=2
    1              0.000002 set colorcolumn=119
    1              0.000002 set completeopt=menuone,noinsert,noselect
    1              0.000001 set expandtab
    1              0.000007 set fillchars+=diff:⣿,vert:│
    1              0.000002 set foldlevel=0
    1              0.000002 set foldmethod=marker
    1              0.000001 set foldnestmax=10 " maximum fold depth
    1              0.000001 set helplang=ja,en
    1              0.000004 set hidden
    1              0.000001 set history=10000
    1              0.000001 set ignorecase
    1              0.000001 set laststatus=2
    1              0.000001 set list
    1              0.000003 set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
    1              0.000001 set matchtime=0
    1              0.000002 set matchpairs+=<:>
    1              0.000001 set number
    1              0.000001 set pumheight=0
    1              0.000001 set ruler
    1              0.000001 set scrolljump=1
    1              0.000001 set scrolloff=10
    1              0.000001 set shiftround
    1              0.000001 set shiftwidth=2
    1              0.000002 set shortmess+=c
    1              0.000001 set showcmd
    1              0.000001 set showmatch
    1              0.000001 set showmode
    1              0.000008 set showtabline=2
    1              0.000001 set sidescrolloff=5
    1              0.000001 set synmaxcol=300
    1              0.000001 set smartcase
    1              0.000001 set smartindent
    1              0.000001 set softtabstop=2
    1              0.000001 set tabstop=2
    1              0.000002 set tags=./tags; " http://d.hatena.ne.jp/thinca/20090723/1248286959
    1              0.000003 set textwidth=0
    1              0.000001 set timeout " Mappnig timeout
    1              0.000001 set timeoutlen=500
    1              0.000002 set switchbuf=usetab
    1              0.000001 set ttimeout " Keycode timeout
    1              0.000001 set ttimeoutlen=10
    1              0.000003 set undodir=$XDG_DATA_HOME/nvim/undo
    1              0.000001 set undofile
    1              0.000001 set updatecount=0
    1              0.000001 set updatetime=500
    1              0.000001 set wildignore+=*.DS_Store
    1              0.000002 set wildignore+=*.ycm_extra_conf.py,*.ycm_extra_conf.pyc
    1              0.000002 set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
    1              0.000002 set wildignore+=tags,*.tags
    1              0.000002 set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class,*.jpg,*.jpeg,*.bmp,*.gif,*.png
    1              0.000002 set wildignore+=*.swp,*.swo,*.swn
    1              0.000001 set wildmode=longest,list:full " http://stackoverflow.com/a/526940/5228839
    1              0.000001 set wrap
                            
    1              0.000001 set nobackup
    1              0.000001 set noerrorbells
    1              0.000001 set nofoldenable
    1              0.000001 set nolazyredraw
    1              0.000001 set noshiftround
    1              0.000003 set noswapfile
    1              0.000001 set notitle
    1              0.000001 set novisualbell
    1              0.000001 set nowrapscan
    1              0.000001 set nowritebackup
                            
                            
                            " Ignore default plugins
                            " http://lambdalisue.hatenablog.com/entry/2015/12/25/000046
    1              0.000002 let g:loaded_2html_plugin      = 1
    1              0.000001 let g:loaded_getscript         = 1
    1              0.000001 let g:loaded_getscriptPlugin   = 1
    1              0.000001 let g:loaded_man               = 1
    1              0.000001 let g:loaded_netrw             = 1
    1              0.000001 let g:loaded_netrwFileHandlers = 1
    1              0.000001 let g:loaded_netrwPlugin       = 1
    1              0.000001 let g:loaded_netrwSettings     = 1
    1              0.000001 let g:loaded_tar               = 1
    1              0.000001 let g:loaded_tarPlugin         = 1
    1              0.000001 let g:loaded_tutor_mode_plugin = 1
    1              0.000001 let g:loaded_vimball           = 1
    1              0.000001 let g:loaded_vimballPlugin     = 1
    1              0.000001 let g:loaded_zip               = 1
    1              0.000001 let g:loaded_zipPlugin         = 1
                            " let g:loaded_matchparen        = 1
    1              0.000001 let loaded_gzip                = 1
    1              0.000001 let loaded_rrhelper            = 1
    1              0.000001 let loaded_spellfile_plugin    = 1
                            
                            " Load matchit.vim, but only if the user hasn't installed a newer version.
    1              0.000478 if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
                              runtime! macros/matchit.vim
                            endif
                            
                            "}}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Color "{{{
    1              0.000005 hi! SpecialKey    gui=NONE    guifg=#25262c    guibg=NONE
    1              0.000003 hi! TermCursor    gui=NONE    guifg=#FFFFFF    guibg=NONE
                            
                            " Go:
                            " highlight
    1              0.000002 let g:go_highlight_error = 1
    1              0.000007 Gautocmdft go
                                  \ hi goStdlib                gui=bold    guifg=#81A2BE    guibg=NONE
    1              0.000004 Gautocmdft go
                                  \ hi goStdlibErr             gui=bold    guifg=#FF005F    guibg=NONE
                            
                            " C:
    1              0.000008 Gautocmdft c,cpp,objc,objcpp
                                  \ hi cCustomFunc             gui=bold    guifg=#F0C674    guibg=NONE
                            
                            " Python:
    1              0.000004 Gautocmdft python
                                  \ hi pythonSelf              gui=None    guifg=#8abeb7    guibg=None
                            
                            " Quickfix:
    1              0.000004 Gautocmdft qf
                                  \ hi Search                  gui=None guifg=None  guibg=#373b41
                            
                            " link
                            " Python:
    1              0.000007 Gautocmdft python
                                  \ hi link pythonDelimiter    Special
                            
                            "}}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Neovim configuration "{{{
                            
    1              0.000003 if has('mac')
    1              0.000003   let g:python_host_prog   = '/usr/local/bin/python2'
    1              0.000002   let g:python3_host_prog  = '/usr/local/bin/python3'
    1              0.000001 elseif has('unix')
                              let g:python_host_prog   = '/usr/bin/python2'
                              let g:python3_host_prog  = '/usr/bin/python3'
                            endif
                            " Skip neovim module check
    1              0.000001 let g:python_host_skip_check  = 1
    1              0.000001 let g:python3_host_skip_check = 1
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Filetype autocmd {{{
                            "
    1              0.000005 Gautocmdft vim
                                  \ setlocal foldmethod=marker tags=$HOME/.config/nvim/tags
                            
    1              0.000005 Gautocmdft c,cpp
                                  \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab commentstring=//%s
                            
    1              0.000006 Gautocmdft sh,bash,zsh
                                  \ setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
                            
    1              0.000003 Gautocmdft zsh
                                  \ runtime! indent/sh.vim
                            
    1              0.000006 Gautocmdft go
                                  \ setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
                            
    1              0.000007 Gautocmdft python
                                  \ setlocal tabstop=8 shiftwidth=4 softtabstop=4 colorcolumn=79 textwidth=79
                            
    1              0.000004 Gautocmdft dockerfile
                                  \ setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nocindent
                            
    1              0.000004 Gautocmdft ruby
                                  \ setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
                            
    1              0.000004 Gautocmdft gitconfig
                                  \ setlocal softtabstop=4 shiftwidth=4 noexpandtab
                            
    1              0.000006 Gautocmdft dirvish
                                  \ let g:treachery#enable_autochdir = 0
                            
    1              0.000004 Gautocmdft ipython
                                  \  let g:treachery#enable_autochdir = 0
                            
                            " Gautocmdft c,cpp,java,php,js,python,twig,xml,yml
                                  " \ autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\\\s\\\\+$","","")'))
                            
                            
    1              0.000009 Gautocmdft c,cpp,python,ruby,zsh
                                  \ autocmd BufWritePost <buffer> call Ctags()
                            
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Filetype settings "{{{
                            
                            " Go:
                            " TODO: for nvim-go
    1              0.000001 let g:go#debuf = 0
    1              0.000003 let g:go#def#debug = 0
    1              0.000002 let g:go#def#filer = 'Dirvish'
    1              0.000002 let g:go#def#filer_mode = 'tab split'
    1              0.000002 let g:go#fmt#async = 0
    1              0.000002 let g:go#guru#keep_cursor = 1
    1              0.000002 let g:go#guru#reflection = 1
    1              0.000002 let g:go#rename#prefill = 1
                            
                            " vim-go
    1              0.000001 let g:go#use_vimproc = 1
    1              0.000002 let g:go_auto_type_info = 0
    1              0.000002 let g:go_autodetect_gopath = 1
    1              0.000001 let g:go_def_mapping_enabled = 0
    1              0.000001 let g:go_doc_command = 'godoc'
    1              0.000001 let g:go_doc_options = ''
    1              0.000001 let g:go_fmt_autosave = 0
    1              0.000001 let g:go_fmt_command = 'goimports'
    1              0.000001 let g:go_fmt_experimental = 1
    1              0.000001 let g:go_highlight_array_whitespace_error = 1
    1              0.000001 let g:go_highlight_build_constraints = 1
    1              0.000001 let g:go_highlight_chan_whitespace_error = 1
    1              0.000001 let g:go_highlight_extra_types = 1
    1              0.000003 let g:go_highlight_functions = 1
    1              0.000001 let g:go_highlight_interfaces = 1
    1              0.000001 let g:go_highlight_methods = 1
    1              0.000001 let g:go_highlight_operators = 1
    1              0.000001 let g:go_highlight_space_tab_error = 1
    1              0.000001 let g:go_highlight_string_spellcheck = 1
    1              0.000001 let g:go_highlight_structs = 1
    1              0.000001 let g:go_highlight_trailing_whitespace_error = 1
    1              0.000001 let g:go_snippet_engine = 'neosnippet'
    1              0.000001 let g:go_loclist_height = 10
    1              0.000002 let g:go_asmfmt_autosave = 1
    1              0.000001 let g:go_term_height = 30
    1              0.000001 let g:go_term_width = 30
    1              0.000001 let g:go_term_enabled = 1
                            " Lock golang/go source
    1              0.000002 function! GoSrcSetting()
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
    1              0.000035 Gautocmd BufNewFile,BufRead /usr/local/go/* call GoSrcSetting()
                            " Gautocmdft go syn include @CSource syntax/c.vim
    1              0.000001 function! Gotags()
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
    1              0.000006 Gautocmd BufWinEnter .pythonrc set filetype=python
                            " vim-autopep8
    1              0.000002 let g:autopep8_disable_show_diff= 1
                            " vim-flake8
                            " flake8 global setting: $XDG_CONFIG_HOME/flake8
    1              0.000002 let g:flake8_cmd="/usr/local/bin/flake8"
    1              0.000001 let g:flake8_show_in_gutter = 1
                            
                            
                            " C CXX:
    1              0.000046 Gautocmd BufNewFile,BufRead *.c,*.cpp set omnifunc=
                            " Protect header library
    1              0.000031 Gautocmd BufNewFile,BufRead /System/Library/Frameworks/* setlocal readonly nomodified
    1              0.000031 Gautocmd BufNewFile,BufRead /Applications/Xcode.app/* setlocal readonly nomodified
    1              0.000034 Gautocmd BufNewFile,BufRead /Applications/Xcode-beta.app/* setlocal readonly nomodified
    1              0.000005 Gautocmdft cpp nnoremap <silent><buffer>X :<C-u>call <SID>open_online_cpp_doc()<CR>
                            
                            
                            " Ruby:
                            " Gautocmd BufWritePost *.rb :Autoformat
    1              0.000012 Gautocmd BufReadPost .pryrc setlocal filetype=ruby
                            
                            
                            " Zsh Sh Bash:
                            " http://tyru.hatenablog.com/entry/20101007/vim_syntax_sh
    1              0.000001 let g:is_bash = 1
    1              0.000032 Gautocmd BufNewFile,BufRead ~/.zsh/* setlocal filetype=zsh
                            
                            
                            " Markdown:
    1              0.000026 Gautocmd BufRead,BufNewFile *.md set filetype=markdown
    1              0.000028 Gautocmd BufRead,BufNewFile *.md let g:deoplete#disable_auto_complete = 0
                            
                            
                            " Dockerfile:
    1              0.000032 Gautocmd BufRead,BufNewFile *.[Dd]ockerfile set filetype=dockerfile
                            
                            
                            " Vim:
                            " develop nvimrc helper
    1              0.000011 Gautocmd BufWritePost $MYVIMRC nested
                                  \ silent! call vimproc#system("ctags -R --languages=Vim --sort=yes --fields=+l -f $HOME/.config/nvim/tags $HOME/.config/nvim &")
                            
    1              0.000006 Gautocmd BufWritePost $MYVIMRC,*.vim nested
                                  \ call dein#clear_cache()
                                  \ | silent! source $MYVIMRC
                                  \ | call dein#save_cache()
                            
                            
                            " JavaScript:
    1              0.000034 Gautocmd BufRead,BufNewFile .eslintrc set filetype=json
                            
                            
                            " Quickfix:
                            " http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
    1              0.000005 Gautocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "qf" | quit | endif
                            " http://vim.wikia.com/wiki/Automatically_fitting_a_quickfix_window_height
    1              0.000002 function! AdjustWindowHeight(minheight, maxheight)
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
    1              0.000004 Gautocmdft qf call AdjustWindowHeight(3, 7)
                            
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Plugin settings "{{{
                            
                            " Deoplete:
    1              0.000002 let g:deoplete#auto_completion_start_length = 1
    1              0.000001 let g:deoplete#enable_at_startup = 1
    1              0.000001 let g:deoplete#enable_camel_case = 1
    1              0.000001 let g:deoplete#enable_refresh_always = 1
    1              0.000001 let g:deoplete#file#enable_buffer_path = 1
                            " deoplete-filters
                            " call deoplete#custom#set('_', 'converters:', ['converter_auto_paren'])
                            " call deoplete#custom#set('_', 'matchers', ['matcher_full_fuzzy'])
                            " deoplete-debugging
    1              0.000001 let g:deoplete#enable_debug = 1
                            " let g:deoplete#enable_profile = 1
                            " deoplete-builtin:
                            " available values ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag']
                            " let g:deoplete#sources = {}
    1              0.000001 let g:deoplete#ignore_sources = {}
                            " let g:deoplete#ignore_sources._ = ['neosnippet']
    1              0.000001 let g:deoplete#omni#input_patterns = {}
                            " C Family:
                            " let g:deoplete#ignore_sources.c = ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag', 'syntax', 'neosnippet']
                            " let g:deoplete#ignore_sources.cpp = ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag', 'syntax', 'neosnippet']
                            " Swift:
    1              0.000002 let g:deoplete#sources#swift#daemon_autostart = 1
                            " Go:
                            " let g:deoplete#ignore_sources.go = ['buffer', 'tag', 'syntax']
                            " call deoplete#custom#set('go', 'rank', 10000)
                            " call deoplete#custom#set('go', 'disabled_syntaxes', ['Comment', 'String'])
    1              0.000001 let g:deoplete#sources#go#align_class = 1
    1              0.000003 let g:deoplete#sources#go#data_directory = $HOME.'/.config/gocode/json'
    1              0.000002 let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
    1              0.000001 let g:deoplete#sources#go#package_dot = 1
    1              0.000005 let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
                            " Python:
                            " let g:deoplete#ignore_sources.python = ['buffer', 'dictionary', 'file', 'member', 'omni', 'tag', 'syntax', 'neosnippet']
                            " call deoplete#custom#set('jedi', 'rank', 10000)
                            " disable jedi-vim
    1              0.000001 let g:jedi#auto_initialization = 0
    1              0.000001 let g:jedi#auto_vim_configuration = 0
    1              0.000001 let g:jedi#completions_enabled = 0
    1              0.000001 let g:jedi#documentation_command = "K"
    1              0.000001 let g:jedi#force_py_version = 3
    1              0.000001 let g:jedi#max_doc_height = 100
    1              0.000001 let g:jedi#popup_select_first = 0
    1              0.000001 let g:jedi#show_call_signatures = 0
    1              0.000001 let g:jedi#smart_auto_mappings = 0
                            
                            " neosnippets
    1              0.000082 call deoplete#custom#set('neosnippet', 'rank', 50)
                            
                            " vim
    1   0.000031   0.000005 call deoplete#custom#set('vim', 'rank', 10000)
                            
                            " ruby
    1              0.000003 let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
                            
                            
                            " neopairs.vim
    1              0.000001 let g:neopairs#enable = 1
                            
                            
                            " neosnippet
    1              0.000002 let g:neosnippet#enable_completed_snippet = 1
    1              0.000002 let g:neosnippet#enable_snipmate_compatibility = 1
                            
                            
                            " echodoc
    1              0.000001 let g:echodoc_enable_at_startup = 1
                            
                            
                            " Konfekt/FastFold
    1              0.000001 let g:tex_fold_enabled=1
    1              0.000001 let g:vimsyn_folding='af'
    1              0.000003 let g:xml_syntax_folding = 1
    1              0.000001 let g:php_folding = 1
    1              0.000001 let g:perl_fold = 1
                            
                            
                            " treachey
    1              0.000001 let g:treachery#enable_autochdir = 1
    1              0.000001 let g:treachery#enable_keylayout = 1
    1              0.000001 let g:treachery#debug = 1
                            
                            
                            " nvim-ipy
    1              0.000001 let g:ipy_set_ft = 1
    1              0.000001 let g:ipy_shortprompt = 1
    1              0.000001 let g:ipy_truncate_input = 1
    1              0.000001 let g:nvim_ipy_perform_mappings = 0
                            
                            
                            " YouCompleteMe
    1              0.000004 let g:ycm_auto_trigger = 0
    1              0.000002 let g:ycm_min_num_of_chars_for_completion = 99
    1              0.000001 let g:ycm_always_populate_location_list = 1
    1              0.000002 let g:ycm_collect_identifiers_from_comments_and_strings = 1
    1              0.000002 let g:ycm_collect_identifiers_from_tags_files = 1
    1              0.000001 let g:ycm_confirm_extra_conf = 1
    1              0.000003 let g:ycm_extra_conf_globlist = ['./*','../*','../../*','../../../*','../../../../*','~/.nvim/*']
    1              0.000003 let g:ycm_global_ycm_extra_conf = $HOME . '/.nvim/.ycm_extra_conf.py'
    1              0.000002 let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
    1              0.000002 let g:ycm_path_to_python_interpreter = '/usr/local/bin/python2'
    1              0.000001 let g:ycm_seed_identifiers_with_syntax = 1
                            
                            
                            " CtrlP
    1              0.000001 let g:ctrlp_by_filename = 0
    1              0.000002 let g:ctrlp_reuse_window = 'netrw\|help\|quickfix\|dirvish'
    1              0.000002 let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
    1              0.000001 let g:ctrlp_clear_cache_on_exit = 0
                            " CtrlP default match_func
    1              0.000005 let g:ctrlp_custom_ignore = {
                                  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|__pycache__)$',
                                  \ 'file': '\v(\.DS_Store|\.a|\.o|\.exe|\.so|\.dll|tags)$'
                                  \ }
                            " files environment variable
    1              0.000004 let $FILES_IGNORE_PATTERN = "(\.git|\.hg|\.svn|_darcs|\.bzr|__pycache__|\.DS_Store|vendor|\.a|\.exe|\.so|\.dll|tags)$"
    1              0.000001 let g:ctrlp_follow_symlinks = 1
    1              0.000001 let g:ctrlp_match_current_file = 0
    1              0.000004 let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
    1              0.000002 let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15'
    1              0.000001 let g:ctrlp_mruf_default_order = 1
    1              0.000001 let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
    1              0.000001 let g:ctrlp_path_nolim = 1
    1              0.000001 let g:ctrlp_show_hidden = 1
    1              0.000001 let g:ctrlp_use_caching = 1
    1              0.000001 let g:ctrlp_user_command = 'files -A %s'
                            " CtrlP : extensions
    1              0.000001 let g:ctrlp_yankring_disable = 1
                            " CtrlP : cpsm
    1              0.000001 let g:cpsm_match_empty_query = 0
    1              0.000001 let g:cpsm_highlight_mode = 'basic' " none, basic, detailed
    1              0.000001 let g:cpsm_unicode = 1
                            " CtrlP : ghq
    1              0.000001 let g:ctrlp_ghq_cache_enabled = 1
                            
                            
                            " vim-airline
    1              0.000001 let g:airline_inactive_collapse=1
    1              0.000001 let g:airline#extensions#tagbar#enabled = 0
    1              0.000001 let g:airline_powerline_fonts = 1
                            " vim-airline theme
    1              0.000001 let g:airline_theme = 'hybridline'
                            " vim-airline symbols
    1              0.000002 if !exists('g:airline_symbols')
    1              0.000001   let g:airline_symbols = {}
    1              0.000001 endif
    1              0.000078 let g:airline_section_c = airline#section#create(['%<', 'readonly', ' ', 'path'])
                            
                            
                            " Neomake
    1              0.000004 let g:neomake_open_list = 'loclist'
    1              0.000004 let g:neomake_serialize = 1
    1              0.000007 let g:neomake_error_sign = {
                                  \ 'text': 'E>',
                                  \ 'texthl': 'ErrorMsg',
                                  \ }
    1              0.000003 let g:neomake_airline = 1
                            
                            
                            " gitgutter
    1              0.000003 let g:gitgutter_enabled = 1
    1              0.000003 let g:gitgutter_realtime = 0
    1              0.000003 let g:gitgutter_sign_column_always = 1
    1              0.000003 let g:gitgutter_max_signs = 1000
    1              0.000003 let g:gitgutter_map_keys = 0
                            
                            
                            " vim-dirvish
    1              0.000002 let g:dirvish_hijack_netrw = 1
    1              0.000003 let g:dirvish_relative_paths = 1
                            " https://github.com/IanConnolly/dotfiles/blob/master/vimrc#L449
    1              0.000001 function! DirvishIgnore() abort
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
    1              0.000008 Gautocmdft dirvish call DirvishIgnore()
                            
                            
                            " nvim-ipy
                            " TODO: More elegant way
    1              0.000001 function! FuncIPython(...) abort
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
    1              0.000002 function! OnIPythonComplete(A,L,P)
                              return ['2', '3']
                            endfunction
    1              0.000004 command! -nargs=0 -bang -complete=customlist,OnIPythonComplete IPython3 call FuncIPython()
                            
                            
                            " vim-markdown
    1              0.000003 let g:vim_markdown_folding_disabled = 1
                            
                            
                            " QuickRun
    1              0.000005 Gautocmd WinEnter *
                                  \ if winnr('$') == 1 &&
                                  \   getbufvar(winbufnr(winnr()), "&filetype") == "quickrun" |
                                  \ q |
                                  \ endif
    1              0.000004 let g:quickrun_config = get(g:, 'quickrun_config', {})
    1              0.000010 let g:quickrun_config._ = {
                                  \ 'runner' : 'vimproc',
                                  \ 'runner/vimproc/updatetime' : 50,
                                  \ 'outputter' : 'quickfix',
                                  \ 'outputter/quickfix/open_cmd' : 'copen 15',
                                  \ 'outputter/buffer/running_mark' : ''
                                  \ }
                            " Go
    1              0.000008 let g:quickrun_config.go = {
                                  \ 'command': 'go',
                                  \ 'cmdopt' : 'run',
                                  \ 'exec': ['%c %o %s -o -'],
                                  \ 'outputter' : 'buffer',
                                  \ 'outputter/buffer/split' : 'vertical botright 80',
                                  \ 'outputter/buffer/close_on_empty' : 1,
                                  \ }
                            
                            
                            " vim-ref
    1              0.000006 Gautocmdft ruby nnoremap K :<C-u>Ref ri <C-r><C-w><CR>
                            " let g:ref_refe_cmd = '/usr/local/var/rbenv/shims/refe'
    1              0.000003 let g:ref_use_vimproc = 1
    1              0.000003 let g:ref_no_default_key_mappings = 1
    1              0.000003 let g:ref_pydoc_cmd = 'python3 -m pydoc'
    1              0.000003 let g:ref_pydoc_complete_head = 1
                            
                            
                            " committia.vim
    1              0.000003 let g:committia_hooks = {}
    1              0.000002 function! g:committia_hooks.edit_open(info)
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
    1              0.000003 let g:tcommentMaps = 0
    1              0.000003 let g:tcommentMapLeader1 = 0
                            
                            
                            " sonictemplate-vim
    1              0.000006 let g:sonictemplate_vim_vars = {
                                  \ '_': {
                                  \   'author': 'zchee',
                                  \   'email': 'k@zchee.io',
                                  \ },
                                  \}
                            
                            
                            " vim-gista
    1              0.000003 let g:gista#update_on_write = 1
                            
                            
                            " nvim-miniyank
    1              0.000004 let g:miniyank_filename = $XDG_CACHE_HOME."/nvim/miniyank/.miniyank.mpack"
                            
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Temporary functions "{{{
                            
                            " https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
                            " When editing a file, always jump to the last known cursor position.  Don't
                            " do it when the position is invalid or when inside an event handler
                            " Also don't do it when the mark is in the first line, that is the default
                            " Posission when opening a file
    1              0.000024 Gautocmd BufReadPost *
                                  \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' |
                                  \   execute "normal! g`\"" |
                                  \   execute "call feedkeys('zz')" |
                                  \ endif
                            
                            " Smart help window
                            " https://github.com/rhysd/dotfiles/blob/master/nvimrc#L380-L405
    1              0.000002 function! s:smart_help(args)
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
    1              0.000004 command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)
                            
                            
                            " Display syntax infomation on under the current cursor
    1              0.000002 function! s:get_syn_id(transparent)
                              let synid = synID(line("."), col("."), 1)
                              if a:transparent
                                return synIDtrans(synid)
                              else
                                return synid
                              endif
                            endfunction
    1              0.000002 function! s:get_syn_attr(synid)
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
    1              0.000001 function! s:get_syn_info()
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
    1              0.000002 command! SyntaxInfo call s:get_syn_info()
                            
                            
                            " Set parent git directory to current path
                            " http://michaelheap.com/set-parent-git-directory-to-current-path-in-vim/
    1              0.000003 function! Ctags()
                              let b:gitdir = vimproc#system("git rev-parse --show-toplevel")
                              if b:gitdir !~? "^fatal"
                                cd `=b:gitdir`
                                let l:current_ft = &filetype
                                call vimproc#system("ctags -R --languages=" . l:current_ft . " --fields=+l --sort=yes &")
                              endif
                            endfunction
                            
                            
                            " Json Format
    1              0.000003 command! -nargs=0 -bang -complete=command FormatJSON %!python -m json.tool
                            
                            
                            " Clear message logs
    1              0.000003 command! ClearMessage for n in range(200) | echom "" | endfor
                            
                            
                            " Binary edit mode
                            " need open nvim with `-b` flag
    1              0.000001 function! BinaryMode() abort
                              if !has('binary')
                                echoerr "BinaryMode must be 'binary' option"
                                return
                              endif
                            
                              execute '%!xxd'
                            endfunction
                            
                            
                            " https://github.com/tarruda/dot-files/blob/master/config/nvim/init.vim
    1              0.000001 function! s:GetVisual()
                              let [lnum1, col1] = getpos("'<")[1:2]
                              let [lnum2, col2] = getpos("'>")[1:2]
                              let lines = getline(lnum1, lnum2)
                              let lines[-1] = lines[-1][:col2 - 2]
                              let lines[0] = lines[0][col1 - 1:]
                              return lines
                            endfunction
                            
                            " https://github.com/tarruda/dot-files/blob/master/config/nvim/init.vim
    1              0.000001 function! REPLSend(lines)
                              call jobsend(g:last_terminal_job_id, add(a:lines, ''))
                            endfunction
                            " }}}
                            
                            " REPL integration {{{
    1              0.000003 command! -range=% REPLSendSelection call REPLSend(s:GetVisual())
    1              0.000002 command! REPLSendLine call REPLSend([getline('.')])
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Keymap "{{{
                            " - Swap semicolon and colon is move to Karabiner
                            
                            " Leader Prefix
                            " <Space>, 'q', '.', '(k)', 's'
                            
                            " <Space> Leader
                            "    .    Global prefix
                            
                            " Dvorak Center
    1              0.000011 nnoremap <Space> <Nop>
    1              0.000003 nnoremap <Enter> <Nop>
                            
                            " Dvorak Leftside
                            " Global prefix
    1              0.000002 nnoremap .       <Nop>
                            " Swap single-repeat keymap
    1              0.000002 nnoremap ,       .
                            
                            " Dvorak Rightside
    1              0.000002 nnoremap f       <Nop>
                            
                            " Mappnig leader prefix
                            " CtrlP buffer
    1              0.000004 nnoremap <silent> .b   :<C-u>CtrlPBuffer<CR>
                            " nnoremap <silent> .b   :<C-u>CtrlPMRU<CR>
                            " CtrlP commandline
    1              0.000003 nnoremap <silent> .c   :<C-u>CtrlPCmdline<CR>
                            " Launch Dirvish
    1              0.000003 nnoremap <silent> .d   :<C-u>Dirvish<CR>
                            " Launch Dirvish after tabnew
    1              0.000003 nnoremap <silent> .D   :<C-u>tabnew \| Dirvish<CR>
                            " Focus next buffer
    1              0.000002 nnoremap <silent> .m   <C-w>w
                            " Switch Next tab
    1              0.000002 nnoremap <silent> .n   gt
                            " Switch Previous tab
    1              0.000003 nnoremap <silent> .p   gT
                            " witch next or previous tab
    1              0.000002 nnoremap <silent> .s   :bNext<CR>
                            " Create new tab
    1              0.000004 nnoremap <silent> .t   :<C-u>tabnew<CR>:call feedkeys(':e<Space>')<CR>
                            " Quick editing init.vim
    1              0.000003 nnoremap <silent> .r   :<C-u>tabedit $MYVIMRC<CR>
                            " Vsplit and focus new buffer
    1              0.000003 nnoremap <silent> .v   :<C-w>vsplit<CR><C-w>w
                            " CtrlP yankround
    1              0.000003 nnoremap <silent> .y   :CtrlPYankRound<CR>
                            " Split and focus new buffer
    1              0.000003 nnoremap <silent> .z   :<C-u>split<CR><C-w>w
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Map Leader "{{{
                            
    1              0.000004 let mapleader = "\<Space>"
                            " let maplocalleader = "\<Enter>"
                            
    1              0.000004 nnoremap <silent><Leader>h  :<C-u>SmartHelp<Space><C-l>
    1              0.000004 nnoremap <silent><Leader>m  <C-w>w
    1              0.000004 nnoremap <silent><Leader>n  :TagbarToggle<CR>
    1              0.000004 nnoremap <silent><Leader>r  :<C-u>QuickRun<CR>
    1              0.000004 nnoremap <silent><Leader>s  :%s///g<Left><Left><Left>
    1              0.000003 nnoremap <silent><Leader>w  :<C-u>w<CR>
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            
                            " Normal "{{{
                            
                            " Don't use Ex mode, use Q for formatting
    1              0.000002 nnoremap Q       gq
                            " When type 'x' key(delete), do not add yank register
    1              0.000002 nnoremap x       "_x
                            " Jump marked line
    1              0.000002 nnoremap zj      zjzt
    1              0.000002 nnoremap zk      2zkzjzt
                            " suspend!
    1              0.000003 nnoremap QQ      :<C-u>q!<CR>
                            " Switch suspend! map
    1              0.000002 nnoremap ZZ      ZQ
                            " Disable suspend
    1              0.000002 nnoremap ZQ      <Nop>
                            
                            " Search current word, but not move next search word
    1              0.000005 nmap     <silent>*       <Plug>(asterisk-z*)
                            " nnoremap *       *:call feedkeys("\<S-n>")<CR>
                            " Go to home and end using capitalized directions
                            " Switch @ and ^ for Dvorak pinky
    1              0.000002 nnoremap @       ^
    1              0.000002 nnoremap ^       @
                            
                            " fast scroll
    1              0.000003 nnoremap <C-e> 2<C-e>
                            " Back to tagjump with centernig
    1              0.000003 nnoremap <silent><C-o> <C-o>zz:echomsg ''<CR>
                            " <C-o>:<Delete>
                            " Move cursor to lines {upward|downward} on the first non-blank character
                            " nnoremap <C-j> <C-m>
                            " nnoremap <C-k> -
                            " Cancel highlight search word
    1              0.000004 nnoremap <silent><C-q>  :<C-u>nohlsearch<CR>
                            " fast scroll
    1              0.000003 nnoremap <C-y> 2<C-y>
                            " Disable suspend
    1              0.000002 nnoremap <C-z> <Nop>
                            
                            " http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
    1              0.000004 nnoremap <M-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
    1              0.000004 nnoremap <A-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
                            
                            " Jump to match pair brackets.
                            " <Tab> and <C-i> are similar treatment. Need <C-i> for jump to next taglist
    1              0.000003 nnoremap <S-Tab> %
                            
                            " for language documents
    1              0.000001 function! DocMappings()
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
    1              0.000021 Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun,gita-blame-navi,rst
                                  \ call DocMappings()
                            
                            " tmux like switch the next to each other of the buffer
    1              0.000002 function! SwitchBuffer()
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
    1              0.000004 nnoremap zo :call SwitchBuffer()<CR>
                            
                            
                            " Go:
    1              0.000005 Gautocmdft go nnoremap "                      '
    1              0.000003 Gautocmdft go nnoremap '                      "
    1              0.000003 Gautocmdft go nnoremap <silent><buffer><C-]>  :<C-u>Godef<CR>
    1              0.000003 Gautocmdft go nnoremap <silent><Leader>]      :<C-u>tag <c-r>=expand("<cword>")<CR><CR>
    1              0.000003 Gautocmdft go nnoremap <silent><Leader>b      :<C-u>Gobuild<CR>
    1              0.000003 Gautocmdft go nnoremap <silent>K              <Plug>(go-doc)
    1              0.000003 Gautocmdft go nnoremap <silent><Leader>f      <Plug>(go-def-split)
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>gi     <Plug>(go-info)
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>gm     <Plug>(go-metalinter)
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>gr     :<C-u>Gorename<CR>
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>gt     <Plug>(go-test)
                            " Go guru key map
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>gge    :<C-u>GoGuru callees<CR>
    1              0.000004 Gautocmdft go nnoremap <silent><Leader>ggr    :<C-u>GoGuru callers<CR>
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>ggs    :<C-u>GoGuru callstack<CR>
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>ggd    :<C-u>GoGuru describe<CR>
    1              0.000002 Gautocmdft go nnoremap <silent><Leader>ggf    :<C-u>GoGuru referrers<CR>
                            " Open the GOROOT/src use dirvish
    1              0.000003 Gautocmdft go nnoremap <silent>.go            :<C-u>silent! tabnew<CR> \| :silent! Dirvish /usr/local/go/src<CR>
                            
                            " Python:
    1              0.000004 Gautocmdft python nnoremap <silent><buffer><C-]>  :<C-u>call jedi#goto()<CR>
    1              0.000003 Gautocmdft python nnoremap <silent>K              :<C-u>call jedi#show_documentation()<CR>
    1              0.000003 Gautocmdft python nnoremap <silent><Leader>m      :<C-u>messages<CR>
    1              0.000003 Gautocmdft python nnoremap <silent><Leader>a     :<C-u>write<CR> :Autopep8<CR> :write<CR><Left><Left>
    1              0.000003 Gautocmdft python nnoremap <silent><C-f>          :<C-u>call Flake8()<CR><C-w>w :call feedkeys("<Up>")<CR>
                            
                            " Cfamily:
    1              0.000009 Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><silent><C-]>  :<C-u>YcmCompleter GoTo<CR>
    1              0.000009 Gautocmdft c,cpp,objc,objcpp nmap      <buffer><Leader>x      <Plug>(operator-clang-format)
                            
                            " JavaScript:
    1              0.000004 Gautocmdft javascript nnoremap <silent> <leader>es :Esformatter<CR>
                            
                            " TypeScript:
    1              0.000004 Gautocmdft typescript nnoremap <silent><buffer><C-]>  :<C-u>YcmCompleter GoTo<CR>
                            
                            " Vim:
                            " <C-u>: http://d.hatena.ne.jp/e_v_e/20150101/1420067539
    1              0.000004 Gautocmdft vim nnoremap <silent>K :<C-u>SmartHelp<Space><C-r><C-w><CR>
                            
                            " Dirvish:
                            " Gautocmdft dirvish  nmap d -
                            
                            " Ouickfix:
    1              0.000005 Gautocmdft qf  nnoremap <Enter> <Enter>
                            
                            
                            " CtrlPghq:
    1              0.000004 noremap <silent><C-g> :<c-u>CtrlPGhq<CR>
                            
                            " Gita:
    1              0.000006 Gautocmdft 'gita-blame-navi' nnoremap <buffer>q :<C-u>q<CR>:q<CR>
                            
                            " OperatorUser:
                            " operator-surround
    1              0.000004 nmap <silent>sa <Plug>(operator-surround-append)
    1              0.000004 nmap <silent>sd <Plug>(operator-surround-delete)
    1              0.000004 nmap <silent>sr <Plug>(operator-surround-replace)
                            
                            " Tcomment:
    1              0.000004 nmap <silent> gc  <Plug>TComment_gcc
                            
                            " Miniyank:
    1              0.000004 nmap p <Plug>(miniyank-autoput)
    1              0.000004 nmap P <Plug>(miniyank-autoPut)
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
    1              0.000003 inoremap <silent><M-h> <C-o><S-i>
                            " //TODO escape sequence
    1              0.000003 inoremap <silent><C-l> <C-o><S-a>
    1              0.000003 inoremap <silent><M-l> <C-o><S-a>
                            
                            " Delete before current cursor
    1              0.000003 inoremap <silent><C-d>H <Esc>lc^
                            " Delete after current cursor
    1              0.000003 inoremap <silent><C-d>L <Esc>lc$
                            
                            " Yank before current cursor
    1              0.000003 inoremap <silent><C-y>H <Esc>ly0<Insert>
                            " Yank after current cursor
    1              0.000003 inoremap <silent><C-y>L <Esc>ly$<Insert>
                            
                            
    1              0.000004 Gautocmdft go inoremap "                      '
    1              0.000003 Gautocmdft go inoremap '                      "
                            
                            
                            " deoplete.nvim
                            " deoplete#mappings#cancel_popup():      Not insert seletion popupmenu word and close popup
                            " deoplete#mappings#close_popup():       Insert word on completion popup, and close popup
                            " deoplete#mappings#manual_complete():   Trigger deoplete manually,
                            " deoplete#mappings#refresh():           Refresh completion word list
                            " deoplete#mappings#smart_close_popup(): Insert candidate and re-generate popup menu for deoplete
                            " deoplete#mappings#undo_completion():   Undo insert use deoplete completion
    1              0.000005 inoremap <silent><expr><CR>     pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
    1              0.000006 inoremap <silent><expr><BS>     pumvisible() ? deoplete#mappings#smart_close_popup()."\<BS>" : "\<BS>"
    1              0.000006 inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
    1              0.000007 inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
    1              0.000006 inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
    1              0.000008 inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
    1              0.000005 inoremap <silent><expr><S-Tab>  pumvisible() ? "\<S-Tab>" : deoplete#mappings#manual_complete()
    1              0.000005 inoremap <silent><expr><C-l>    pumvisible() ? deoplete#mappings#refresh() : "\<C-l>"
    1              0.000004 inoremap <silent><expr><C-z>    deoplete#mappings#undo_completion()
                            
                            " neosnippet
    1              0.000006 imap <expr><C-S> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-S>"
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Visual & Select "{{{
                            
                            " Do not add register to current cursor word
    1              0.000003 vnoremap c  "_c
                            " When type 'x' key(delete), do not add yank register
    1              0.000002 vnoremap x  "_x
    1              0.000002 vnoremap P  "_dP
    1              0.000002 vnoremap p  "_dp
                            " vnoremap gp p
                            
                            " sort alphabetically
    1              0.000003 vnoremap <silent>gs :<C-u>'<,'>sort i<CR>
                            
                            " Search current cursor words '*' key
                            " vnoremap <silent>* "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR>:call feedkey("\<S-n>")
                            " Move to end of line to type double small 'v'
                            " $ is end of line, h is forward char
    1              0.000002 vnoremap v $h
                            " Move to start of line
    1              0.000002 vnoremap V ^
                            " Jump to match pair brackets
    1              0.000003 vnoremap <Tab> %
                            
                            " Cfamily:
    1              0.000010 Gautocmdft c,cpp,objc,objcpp vmap      <buffer><Leader>x      <Plug>(operator-clang-format)
                            
                            " neosnippet
    1              0.000007 vmap <expr><C-S> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-S>"
                            
                            " vim-operator-user
                            " operator-surround
    1              0.000004 vmap <silent>sa <Plug>(operator-surround-append)
    1              0.000004 vmap <silent>sd <Plug>(operator-surround-delete)
    1              0.000004 vmap <silent>sr <Plug>(operator-surround-replace)
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Visual "{{{
                            
                            " tcomment
    1              0.000004 xmap <silent>gc  <Plug>TComment_gc
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Select "{{{
                            " smap, snoremap
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Command line "{{{
                            " cnoremap
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Terminal "{{{
                            
                            " Open new terminal tab (tmux: bindkey c)
    1              0.000005 tmap <C-d>c <C-\><C-n>:tabnew \| :terminal<CR>
                            " Switch tab (tmux: bindkey {n|p})
    1              0.000004 tmap <C-d>n <C-\><C-n>:tabnext<CR>
    1              0.000004 tmap <C-d>p <C-\><C-n>:tabprevious<CR>
                            
                            " jj to exit to terminal mode
    1              0.000003 tnoremap <silent>jj  <C-\><C-n>
    1              0.000003 tnoremap <silent>qq  <C-\><C-n>
                            " ZZ to quit terminal tab
    1              0.000003 tnoremap <silent>ZZ           <C-\><C-n>:quit!<CR>
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                            " Load external nvim settings "{{{
                            
    1              0.000033 source $XDG_CONFIG_HOME/nvim/modules/osx_header.vim
    1              0.000028 source $XDG_CONFIG_HOME/nvim/modules/functions.vim
    1              0.000034 source $XDG_CONFIG_HOME/nvim/local.vim
                            
                            " }}}
                            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/dein.vim/autoload/dein.vim
Sourced 1 time
Total time:   0.000677
 Self time:   0.000576

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: dein.vim
                            " AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000006 function! dein#_msg2list(expr) abort "{{{
                              return type(a:expr) ==# type([]) ? a:expr : split(a:expr, '\n')
                            endfunction"}}}
                            
    1              0.000002 function! dein#_error(msg) abort "{{{
                              for mes in dein#_msg2list(a:msg)
                                echohl WarningMsg | echomsg '[dein] ' . mes | echohl None
                              endfor
                            endfunction"}}}
                            
    1              0.000002 if v:version < 704
                              call dein#_error('Does not work this version of Vim (' . v:version . ').')
                              finish
                            endif
                            
    1              0.000008 let s:is_windows = has('win32') || has('win64')
                            
    1              0.000002 function! dein#_substitute_path(path) abort "{{{
                              return (s:is_windows && a:path =~ '\\') ? tr(a:path, '\', '/') : a:path
                            endfunction"}}}
    1              0.000001 function! dein#_expand(path) abort "{{{
                              let path = (a:path =~ '^\~') ? fnamemodify(a:path, ':p') :
                                    \ (a:path =~ '^\$\h\w*') ? substitute(a:path,
                                    \               '^\$\h\w*', '\=eval(submatch(0))', '') :
                                    \ a:path
                              return (s:is_windows && path =~ '\\') ?
                                    \ dein#_substitute_path(path) : path
                            endfunction"}}}
    1              0.000002 function! dein#_set_default(var, val, ...) abort "{{{
                              if !exists(a:var) || type({a:var}) != type(a:val)
                                let alternate_var = get(a:000, 0, '')
                            
                                let {a:var} = exists(alternate_var) ?
                                      \ {alternate_var} : a:val
                              endif
                            endfunction"}}}
    1              0.000002 function! dein#_uniq(list, ...) abort "{{{
                              let list = a:0 ? map(copy(a:list), printf('[v:val, %s]', a:1)) : copy(a:list)
                              let i = 0
                              let seen = {}
                              while i < len(list)
                                let key = string(a:0 ? list[i][1] : list[i])
                                if has_key(seen, key)
                                  call remove(list, i)
                                else
                                  let seen[key] = 1
                                  let i += 1
                                endif
                              endwhile
                              return a:0 ? map(list, 'v:val[0]') : list
                            endfunction"}}}
    1              0.000001 function! dein#_is_windows() abort "{{{
                              return s:is_windows
                            endfunction"}}}
    1              0.000001 function! dein#_is_mac() abort "{{{
                              return !s:is_windows && !has('win32unix')
                                  \ && (has('mac') || has('macunix') || has('gui_macvim') ||
                                  \   (!isdirectory('/proc') && executable('sw_vers')))
                            endfunction"}}}
    1              0.000001 function! dein#_is_cygwin() abort "{{{
                              return has('win32unix')
                            endfunction"}}}
                            
                            " Global options definition." "{{{
    1              0.000005 let g:dein#enable_name_conversion =
                                  \ get(g:, 'dein#enable_name_conversion', 0)
    1              0.000003 let g:dein#install_max_processes =
                                  \ get(g:, 'dein#install_max_processes', 8)
    1              0.000003 let g:dein#install_process_timeout =
                                  \ get(g:, 'dein#install_process_timeout', 120)
    1              0.000003 let g:dein#install_progress_type =
                                  \ get(g:, 'dein#install_progress_type', 'statusline')
                            "}}}
                            
    1              0.000001 function! dein#_init() abort "{{{
                              let s:runtime_path = ''
                              let s:base_path = ''
                              let s:block_level = 0
                              let s:prev_plugins = []
                              let g:dein#_plugins = {}
                              let g:dein#name = ''
                            
                              augroup dein
                                autocmd!
                                autocmd InsertEnter * call dein#autoload#_on_i()
                                autocmd FileType * nested call s:on_ft()
                                autocmd FuncUndefined * call s:on_func(expand('<afile>'))
                                autocmd VimEnter * call dein#_call_hook('post_source')
                              augroup END
                            
                              if exists('##CmdUndefined')
                                autocmd CmdUndefined *
                                      \ call dein#autoload#_on_pre_cmd(expand('<afile>'))
                              endif
                            
                              for event in [
                                    \ 'BufRead', 'BufCreate', 'BufEnter',
                                    \ 'BufWinEnter', 'BufNew', 'VimEnter'
                                    \ ]
                                execute 'autocmd dein' event
                                      \ "* call s:on_path(expand('<afile>'), " .string(event) . ")"
                              endfor
                            endfunction"}}}
    1              0.000002 function! dein#_get_base_path() abort "{{{
                              return s:base_path
                            endfunction"}}}
    1              0.000002 function! dein#_get_runtime_path() abort "{{{
                              if !isdirectory(s:runtime_path)
                                call mkdir(s:runtime_path, 'p')
                              endif
                            
                              return s:runtime_path
                            endfunction"}}}
    1              0.000001 function! dein#_get_tags_path() abort "{{{
                              if s:runtime_path == '' || dein#_is_sudo()
                                return ''
                              endif
                            
                              let dir = s:runtime_path . '/doc'
                              if !isdirectory(dir)
                                call mkdir(dir, 'p')
                              endif
                              return dir
                            endfunction"}}}
                            
    1   0.000115   0.000015 call dein#_init()
                            
    1              0.000002 function! dein#begin(path) abort "{{{
                              if a:path == '' || s:block_level != 0
                                call dein#_error('Invalid begin/end block usage.')
                                return 1
                              endif
                            
                              let s:block_level += 1
                              let s:base_path = dein#_chomp(dein#_expand(a:path))
                              let s:runtime_path = s:base_path . '/.dein'
                            
                              call dein#_filetype_off()
                            
                              if !has('vim_starting')
                                let s:prev_plugins = keys(filter(copy(g:dein#_plugins), 'v:val.merged'))
                                execute 'set rtp-='.fnameescape(s:runtime_path)
                                execute 'set rtp-='.fnameescape(s:runtime_path.'/after')
                              endif
                            
                              " Join to the tail in runtimepath.
                              let rtps = dein#_split_rtp(&runtimepath)
                              let n = index(rtps, $VIMRUNTIME)
                              if n < 0
                                call dein#_error('Invalid runtimepath.')
                                return 1
                              endif
                              let &runtimepath = dein#_join_rtp(
                                    \ add(insert(rtps, s:runtime_path, n-1), s:runtime_path.'/after'),
                                    \ &runtimepath, s:runtime_path)
                            endfunction"}}}
                            
    1              0.000001 function! dein#end() abort "{{{
                              if s:block_level != 1
                                call dein#_error('Invalid begin/end block usage.')
                                return 1
                              endif
                            
                              let s:block_level -= 1
                            
                              " Add runtimepath
                              let rtps = dein#_split_rtp(&runtimepath)
                              let index = index(rtps, s:runtime_path)
                              if index < 0
                                call dein#_error('Invalid runtimepath.')
                                return 1
                              endif
                            
                              let sourced = []
                              for plugin in filter(values(g:dein#_plugins),
                                    \ "!v:val.lazy && !v:val.sourced && v:val.rtp != ''")
                                " Load dependencies
                                if !empty(plugin.depends)
                                  if s:load_depends(plugin, rtps, index)
                                    return 1
                                  endif
                                  continue
                                endif
                            
                                if !plugin.merged
                                  call insert(rtps, plugin.rtp, index)
                                  if isdirectory(plugin.rtp.'/after')
                                    call add(rtps, plugin.rtp.'/after')
                                  endif
                                endif
                            
                                let plugin.sourced = 1
                                call add(sourced, plugin)
                              endfor
                              let &runtimepath = dein#_join_rtp(rtps, &runtimepath, '')
                            
                              call dein#_call_hook('source', sourced)
                            
                              if !has('vim_starting')
                                let merged_plugins = keys(filter(copy(g:dein#_plugins), 'v:val.merged'))
                                if merged_plugins !=# s:prev_plugins
                                  call dein#install#_recache_runtimepath()
                                endif
                                call dein#_call_hook('post_source')
                                call dein#_reset_ftplugin()
                              endif
                            endfunction"}}}
                            
    1              0.000002 function! dein#add(repo, ...) abort "{{{
                              if s:block_level != 1
                                call dein#_error('Invalid add usage.')
                                return 1
                              endif
                            
                              let plugin = dein#parse#_dict(
                                    \ dein#parse#_init(a:repo, get(a:000, 0, {})))
                              if (has_key(g:dein#_plugins, plugin.name)
                                    \ && g:dein#_plugins[plugin.name].sourced)
                                    \ || !plugin.if
                                " Skip already loaded or not enabled plugin.
                                return
                              endif
                            
                              let g:dein#_plugins[plugin.name] = plugin
                            endfunction"}}}
                            
    1              0.000002 function! dein#local(dir, ...) abort "{{{
                              return dein#parse#_local(a:dir, get(a:000, 0, {}), get(a:000, 1, ['*']))
                            endfunction"}}}
                            
    1              0.000001 function! dein#get(...) abort "{{{
                              return empty(a:000) ? copy(g:dein#_plugins) : get(g:dein#_plugins, a:1, {})
                            endfunction"}}}
                            
    1              0.000001 function! dein#source(...) abort "{{{
                              let plugins = empty(a:000) ? copy(g:dein#_plugins)
                                    \ : map(dein#_convert2list(a:1), 'get(g:dein#_plugins, v:val, {})')
                              return dein#autoload#_source(plugins)
                            endfunction"}}}
                            
    1              0.000002 function! dein#tap(name) abort "{{{
                              if !has_key(g:dein#_plugins, a:name)
                                    \ || !isdirectory(g:dein#_plugins[a:name].path)
                                return 0
                              endif
                            
                              let g:dein#name = a:name
                              return 1
                            endfunction"}}}
                            
    1              0.000002 function! dein#is_sourced(name) abort "{{{
                              return get(get(g:dein#_plugins, a:name, {}), 'sourced', 0)
                            endfunction"}}}
                            
    1              0.000001 function! dein#save_cache() abort "{{{
                              if dein#_get_base_path() == '' || !exists('s:vimrcs')
                                " Ignore
                                return 1
                              endif
                            
                              " Set function prefixes before save cache
                              call dein#autoload#_set_function_prefixes(dein#_get_lazy_plugins())
                            
                              let plugins = deepcopy(dein#get())
                              for plugin in values(plugins)
                                let plugin.sourced = 0
                              endfor
                            
                              call writefile([s:get_cache_version(),
                                    \ string(s:vimrcs), string(plugins)],
                                    \ dein#_get_cache_file())
                            endfunction"}}}
    1              0.000001 function! dein#load_cache(...) abort "{{{
                              let s:vimrcs = a:0 ? a:1 : [$MYVIMRC]
                              let starting = a:0 > 1 ? a:2 : has('vim_starting')
                            
                              let cache = dein#_get_cache_file()
                              if !starting || !filereadable(cache) | return 1 | endif
                            
                              if !empty(filter(map(copy(s:vimrcs), 'getftime(dein#_expand(v:val))'),
                                    \ 'getftime(cache) < v:val'))
                                return 1
                              endif
                            
                              try
                                let list = readfile(cache)
                                if len(list) != 3
                                      \ || list[0] !=# s:get_cache_version()
                                      \ || string(s:vimrcs) !=# list[1]
                                  call dein#clear_cache()
                                  return 1
                                endif
                            
                                sandbox let plugins = eval(list[2])
                            
                                if type(plugins) != type({})
                                  call dein#clear_cache()
                                  return 1
                                endif
                            
                                let g:dein#_plugins = plugins
                                for plugin in filter(dein#_get_lazy_plugins(),
                                      \ '!empty(v:val.on_cmd) || !empty(v:val.on_map)')
                                  if !empty(plugin.on_cmd)
                                    call dein#_add_dummy_commands(plugin)
                                  endif
                                  if !empty(plugin.on_map)
                                    call dein#_add_dummy_mappings(plugin)
                                  endif
                                endfor
                              catch
                                call dein#_error('Error occurred while loading cache : ' . v:exception)
                                call dein#clear_cache()
                                return 1
                              endtry
                            endfunction"}}}
    1              0.000001 function! dein#clear_cache() abort "{{{
                              let cache = dein#_get_cache_file()
                              if !filereadable(cache)
                                return
                              endif
                            
                              call delete(cache)
                            endfunction"}}}
    1              0.000002 function! dein#_get_cache_file() abort "{{{
                              return dein#_get_base_path() . '/cache_' . v:progname
                            endfunction"}}}
    1              0.000009 let s:parser_vim_path = fnamemodify(expand('<sfile>'), ':h')
                                  \ . '/dein/parser.vim'
    1              0.000002 function! s:get_cache_version() abort "{{{
                              return getftime(s:parser_vim_path)
                            endfunction "}}}
                            
    1              0.000001 function! dein#install(...) abort "{{{
                              return dein#install#_update(get(a:000, 0, []), 0, s:is_async())
                            endfunction"}}}
    1              0.000001 function! dein#update(...) abort "{{{
                              return dein#install#_update(get(a:000, 0, []), 1, s:is_async())
                            endfunction"}}}
    1              0.000002 function! dein#reinstall(plugins) abort "{{{
                              call dein#install#_reinstall(a:plugins)
                            endfunction"}}}
    1              0.000001 function! dein#remote_plugins() abort "{{{
                              if !has('nvim')
                                return
                              endif
                            
                              " Load not loaded neovim remote plugins
                              call dein#autoload#_source(filter(
                                    \ values(dein#get()),
                                    \ "isdirectory(v:val.rtp . '/rplugin')"))
                            
                              if exists(':UpdateRemotePlugins')
                                UpdateRemotePlugins
                              endif
                            endfunction"}}}
    1              0.000002 function! dein#recache_runtimepath() abort "{{{
                              call dein#install#_recache_runtimepath()
                            endfunction"}}}
                            
    1              0.000001 function! dein#check_install(...) abort "{{{
                              let plugins = empty(a:000) ?
                                    \ values(dein#get()) :
                                    \ map(copy(a:1), 'dein#get(v:val)')
                            
                              call filter(plugins, '!empty(v:val) && !isdirectory(v:val.path)')
                              if empty(plugins)
                                return 0
                              endif
                            
                              echomsg 'Not installed plugins: '
                                    \ string(map(copy(plugins), 'v:val.name'))
                              return 1
                            endfunction"}}}
    1              0.000002 function! dein#check_lazy_plugins() abort "{{{
                              let no_meaning_plugins = map(filter(dein#_get_lazy_plugins(),
                                    \   "!v:val.local && isdirectory(v:val.rtp)
                                    \    && !isdirectory(v:val.rtp . '/plugin')
                                    \    && !isdirectory(v:val.rtp . '/after/plugin')"),
                                    \   'v:val.name')
                              echomsg 'No meaning lazy plugins: ' string(no_meaning_plugins)
                              return len(no_meaning_plugins)
                            endfunction"}}}
                            
    1              0.000004 function! dein#load_toml(filename, ...) abort "{{{
                              return dein#parse#_load_toml(a:filename, get(a:000, 0, {}))
                            endfunction"}}}
                            
    1              0.000001 function! dein#get_log() abort "{{{
                              return join(dein#install#_get_log(), "\n")
                            endfunction"}}}
    1              0.000001 function! dein#get_updates_log() abort "{{{
                              return join(dein#install#_get_updates_log(), "\n")
                            endfunction"}}}
                            
                            " Helper functions
    1              0.000001 function! dein#_has_vimproc() abort "{{{
                              if !exists('*vimproc#version')
                                try
                                  call vimproc#version()
                                catch
                                endtry
                              endif
                            
                              return exists('*vimproc#version')
                            endfunction"}}}
    1              0.000002 function! dein#_split_rtp(runtimepath) abort "{{{
                              if stridx(a:runtimepath, '\,') < 0
                                return split(a:runtimepath, ',')
                              endif
                            
                              let split = split(a:runtimepath, '\\\@<!\%(\\\\\)*\zs,')
                              return map(split,'substitute(v:val, ''\\\([\\,]\)'', "\\1", "g")')
                            endfunction"}}}
    1              0.000002 function! dein#_join_rtp(list, runtimepath, rtp) abort "{{{
                              return (stridx(a:runtimepath, '\,') < 0 && stridx(a:rtp, ',') < 0) ?
                                    \ join(a:list, ',') : join(map(copy(a:list), 's:escape(v:val)'), ',')
                            endfunction"}}}
    1              0.000001 function! dein#_chomp(str) abort "{{{
                              return a:str != '' && a:str[-1:] == '/' ? a:str[: -2] : a:str
                            endfunction"}}}
    1              0.000002 function! dein#_convert2list(expr) abort "{{{
                              return type(a:expr) ==# type([]) ? copy(a:expr) :
                                    \ type(a:expr) ==# type('') ?
                                    \   (a:expr == '' ? [] : split(a:expr, '\r\?\n', 1))
                                    \ : [a:expr]
                            endfunction"}}}
    1              0.000002 function! dein#_get_lazy_plugins() abort "{{{
                              return filter(values(g:dein#_plugins), '!v:val.sourced')
                            endfunction"}}}
    1              0.000001 function! dein#_filetype_off() abort "{{{
                              let filetype_out = dein#_redir('filetype')
                            
                              if filetype_out =~# 'plugin:ON'
                                    \ || filetype_out =~# 'indent:ON'
                                filetype plugin indent off
                              endif
                            
                              if filetype_out =~# 'detection:ON'
                                filetype off
                              endif
                            
                              return filetype_out
                            endfunction"}}}
    1              0.000002 function! dein#_reset_ftplugin() abort "{{{
                              let filetype_out = dein#_filetype_off()
                            
                              if filetype_out =~# 'detection:ON'
                                    \ && filetype_out =~# 'plugin:ON'
                                    \ && filetype_out =~# 'indent:ON'
                                silent! filetype plugin indent on
                              else
                                if filetype_out =~# 'detection:ON'
                                  silent! filetype on
                                endif
                            
                                if filetype_out =~# 'plugin:ON'
                                  silent! filetype plugin on
                                endif
                            
                                if filetype_out =~# 'indent:ON'
                                  silent! filetype indent on
                                endif
                              endif
                            
                              if filetype_out =~# 'detection:ON'
                                filetype detect
                              endif
                            
                              " Reload filetype plugins.
                              let &l:filetype = &l:filetype
                            
                              " Recall FileType autocmd
                              execute 'doautocmd FileType' &filetype
                            endfunction"}}}
    1              0.000002 function! dein#_call_hook(hook_name, ...) abort "{{{
                              let prefix = '#User#dein#'.a:hook_name.'#'
                              let plugins = filter(dein#_convert2list(
                                    \ (empty(a:000) ? dein#get() : a:1)),
                                    \ "get(v:val, 'sourced', 0) && exists(prefix . v:val.name)")
                            
                              for plugin in dein#_tsort(plugins)
                                let autocmd = 'dein#' . a:hook_name . '#' . plugin.name
                                if exists('#User#'.autocmd)
                                  execute 'doautocmd User' autocmd
                                endif
                              endfor
                            endfunction"}}}
    1              0.000002 function! dein#_tsort(plugins) abort "{{{
                              let sorted = []
                              let mark = {}
                              for target in a:plugins
                                call s:tsort_impl(target, mark, sorted)
                              endfor
                            
                              return sorted
                            endfunction"}}}
    1              0.000001 function! dein#_is_sudo() abort "{{{
                              return $SUDO_USER != '' && $USER !=# $SUDO_USER
                                  \ && $HOME !=# expand('~'.$USER)
                                  \ && $HOME ==# expand('~'.$SUDO_USER)
                            endfunction"}}}
    1              0.000002 function! dein#_writefile(path, list) abort "{{{
                              if dein#_is_sudo() || !filewritable(dein#_get_base_path())
                                return 1
                              endif
                            
                              let path = dein#_get_base_path() . '/' . a:path
                              let dir = fnamemodify(path, ':h')
                              if !isdirectory(dir)
                                call mkdir(dir, 'p')
                              endif
                            
                              return writefile(a:list, path)
                            endfunction"}}}
    1              0.000002 function! dein#_add_dummy_commands(plugin) abort "{{{
                              if empty(a:plugin.dummy_commands)
                                call s:generate_dummy_commands(a:plugin)
                              endif
                              for command in a:plugin.dummy_commands
                                silent! execute command[1]
                              endfor
                            endfunction"}}}
    1              0.000002 function! s:generate_dummy_commands(plugin) abort "{{{
                              for name in a:plugin.on_cmd
                                " Define dummy commands.
                                let raw_cmd = 'command '
                                      \ . '-complete=customlist,dein#autoload#_dummy_complete'
                                      \ . ' -bang -bar -range -nargs=* '. name
                                      \ . printf(" call dein#autoload#_on_cmd(%s, %s, <q-args>,
                                      \  expand('<bang>'), expand('<line1>'), expand('<line2>'))",
                                      \   string(name), string(a:plugin.name))
                            
                                call add(a:plugin.dummy_commands, [name, raw_cmd])
                              endfor
                            endfunction"}}}
    1              0.000003 function! dein#_add_dummy_mappings(plugin) abort "{{{
                              if empty(a:plugin.dummy_mappings)
                                call s:generate_dummy_mappings(a:plugin)
                              endif
                              for mapping in a:plugin.dummy_mappings
                                silent! execute mapping[2]
                              endfor
                            endfunction"}}}
    1              0.000002 function! s:generate_dummy_mappings(plugin) abort "{{{
                              for [modes, mappings] in map(copy(a:plugin.on_map), "
                                    \   type(v:val) == type([]) ?
                                    \     [split(v:val[0], '\\zs'), v:val[1:]] :
                                    \     [['n', 'x', 'o'], [v:val]]
                                    \ ")
                                if mappings ==# ['<Plug>']
                                  " Use plugin name.
                                  let mappings = ['<Plug>(' . a:plugin.normalized_name]
                                  if stridx(a:plugin.normalized_name, '-') >= 0
                                    " The plugin mappings may use "_" instead of "-".
                                    call add(mappings, '<Plug>(' .
                                          \ substitute(a:plugin.normalized_name, '-', '_', 'g'))
                                  endif
                                endif
                            
                                for mapping in mappings
                                  " Define dummy mappings.
                                  let prefix = printf("call dein#autoload#_on_map(%s, %s,",
                                        \ string(substitute(mapping, '<', '<lt>', 'g')),
                                        \ string(a:plugin.name))
                                  for mode in modes
                                    let raw_map = mode.'noremap <unique><silent> '.mapping
                                        \ . (mode ==# 'c' ? " \<C-r>=" :
                                        \    mode ==# 'i' ? " \<C-o>:" : " :\<C-u>") . prefix
                                        \ . string(mode) . ")<CR>"
                                    call add(a:plugin.dummy_mappings, [mode, mapping, raw_map])
                                  endfor
                                endfor
                              endfor
                            endfunction"}}}
    1              0.000002 function! dein#_get_type(name) abort "{{{
                              return get({'git': dein#types#git#define()}, a:name, {})
                            endfunction"}}}
                            
                            
                            " Executes a command and returns its output.
                            " This wraps Vim's `:redir`, and makes sure that the `verbose` settings have
                            " no influence.
    1              0.000001 function! dein#_redir(cmd) abort "{{{
                              let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
                              set verbose=0 verbosefile=
                              redir => res
                              silent! execute a:cmd
                              redir END
                              let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
                              return res
                            endfunction"}}}
                            
                            " Escape a path for runtimepath.
    1              0.000001 function! s:escape(path) abort "{{{
                              return substitute(a:path, ',\|\\,\@=', '\\\0', 'g')
                            endfunction"}}}
                            
    1              0.000002 function! s:tsort_impl(target, mark, sorted) abort "{{{
                              if empty(a:target) || has_key(a:mark, a:target.name)
                                return
                              endif
                            
                              let a:mark[a:target.name] = 1
                              for depend in a:target.depends
                                call s:tsort_impl(dein#get(depend), a:mark, a:sorted)
                              endfor
                            
                              call add(a:sorted, a:target)
                            endfunction"}}}
                            
    1              0.000002 function! s:on_path(path, event) abort "{{{
                              if a:path == ''
                                return
                              endif
                            
                              call dein#autoload#_on_path(a:path, a:event)
                            endfunction"}}}
    1              0.000001 function! s:on_ft() abort "{{{
                              if &filetype == ''
                                return
                              endif
                            
                              call dein#autoload#_on_ft()
                            endfunction"}}}
    1              0.000001 function! s:on_func(name) abort "{{{
                              let function_prefix = substitute(a:name, '[^#]*$', '', '')
                              if function_prefix =~# '^dein#'
                                    \ || function_prefix ==# 'vital#'
                                    \ || has('vim_starting')
                                return
                              endif
                            
                              call dein#autoload#_on_func(a:name)
                            endfunction"}}}
                            
    1              0.000002 function! s:load_depends(plugin, rtps, index) abort "{{{
                              for name in a:plugin.depends
                                if !has_key(g:dein#_plugins, name)
                                  call dein#_error(printf('Plugin name "%s" is not found.', name))
                                  return 1
                                endif
                              endfor
                            
                              for depend in dein#_tsort([a:plugin])
                                if depend.sourced
                                  return
                                endif
                            
                                let depend.sourced = 1
                            
                                if !depend.merged
                                  call insert(a:rtps, depend.rtp, a:index)
                                  if isdirectory(depend.rtp.'/after')
                                    call add(a:rtps, depend.rtp.'/after')
                                  endif
                                endif
                              endfor
                            endfunction"}}}
                            
    1              0.000001 function! s:is_async() abort "{{{
                              return (has('nvim') || (has('job') && !s:is_windows))
                                    \ && !has('vim_starting')
                            endfunction"}}}
                            
                            " vim: foldmethod=marker

SCRIPT  /usr/local/share/nvim/runtime/filetype.vim
Sourced 1 time
Total time:   0.016473
 Self time:   0.016230

count  total (s)   self (s)
                            " Vim support file to detect file types
                            "
                            " Maintainer:	Bram Moolenaar <Bram@vim.org>
                            " Last Change:	2015 Apr 06
                            
                            " Listen very carefully, I will say this only once
    1              0.000003 if exists("did_load_filetypes")
                              finish
                            endif
    1              0.000002 let did_load_filetypes = 1
                            
                            " Line continuation is used here, remove 'C' from 'cpoptions'
    1              0.000004 let s:cpo_save = &cpo
    1              0.000003 set cpo&vim
                            
    1              0.000001 augroup filetypedetect
                            
                            " Ignored extensions
    1              0.000003 if exists("*fnameescape")
    1              0.000048 au BufNewFile,BufRead ?\+.orig,?\+.bak,?\+.old,?\+.new,?\+.dpkg-dist,?\+.dpkg-old,?\+.dpkg-new,?\+.dpkg-bak,?\+.rpmsave,?\+.rpmnew,?\+.pacsave,?\+.pacnew
                            	\ exe "doau filetypedetect BufRead " . fnameescape(expand("<afile>:r"))
    1              0.000009 au BufNewFile,BufRead *~
                            	\ let s:name = expand("<afile>") |
                            	\ let s:short = substitute(s:name, '\~$', '', '') |
                            	\ if s:name != s:short && s:short != "" |
                            	\   exe "doau filetypedetect BufRead " . fnameescape(s:short) |
                            	\ endif |
                            	\ unlet! s:name s:short
    1              0.000006 au BufNewFile,BufRead ?\+.in
                            	\ if expand("<afile>:t") != "configure.in" |
                            	\   exe "doau filetypedetect BufRead " . fnameescape(expand("<afile>:r")) |
                            	\ endif
    1              0.000001 elseif &verbose > 0
                              echomsg "Warning: some filetypes will not be recognized because this version of Vim does not have fnameescape()"
                            endif
                            
                            " Pattern used to match file names which should not be inspected.
                            " Currently finds compressed files.
    1              0.000002 if !exists("g:ft_ignore_pat")
    1              0.000002   let g:ft_ignore_pat = '\.\(Z\|gz\|bz2\|zip\|tgz\)$'
    1              0.000001 endif
                            
                            " Function used for patterns that end in a star: don't set the filetype if the
                            " file name matches ft_ignore_pat.
    1              0.000003 func! s:StarSetf(ft)
                              if expand("<amatch>") !~ g:ft_ignore_pat
                                exe 'setf ' . a:ft
                              endif
                            endfunc
                            
                            " Abaqus or Trasys
    1              0.000005 au BufNewFile,BufRead *.inp			call s:Check_inp()
                            
    1              0.000001 func! s:Check_inp()
                              if getline(1) =~ '^\*'
                                setf abaqus
                              else
                                let n = 1
                                if line("$") > 500
                                  let nmax = 500
                                else
                                  let nmax = line("$")
                                endif
                                while n <= nmax
                                  if getline(n) =~? "^header surface data"
                            	setf trasys
                            	break
                                  endif
                                  let n = n + 1
                                endwhile
                              endif
                            endfunc
                            
                            " A-A-P recipe
    1              0.000004 au BufNewFile,BufRead *.aap			setf aap
                            
                            " A2ps printing utility
    1              0.000018 au BufNewFile,BufRead */etc/a2ps.cfg,*/etc/a2ps/*.cfg,a2psrc,.a2psrc setf a2ps
                            
                            " ABAB/4
    1              0.000004 au BufNewFile,BufRead *.abap			setf abap
                            
                            " ABC music notation
    1              0.000004 au BufNewFile,BufRead *.abc			setf abc
                            
                            " ABEL
    1              0.000004 au BufNewFile,BufRead *.abl			setf abel
                            
                            " AceDB
    1              0.000003 au BufNewFile,BufRead *.wrm			setf acedb
                            
                            " Ada (83, 9X, 95)
    1              0.000010 au BufNewFile,BufRead *.adb,*.ads,*.ada		setf ada
    1              0.000005 au BufNewFile,BufRead *.gpr			setf ada
                            
                            " AHDL
    1              0.000004 au BufNewFile,BufRead *.tdf			setf ahdl
                            
                            " AMPL
    1              0.000003 au BufNewFile,BufRead *.run			setf ampl
                            
                            " Ant
    1              0.000005 au BufNewFile,BufRead build.xml			setf ant
                            
                            " Arduino
    1              0.000008 au BufNewFile,BufRead *.ino,*.pde		setf arduino
                            
                            " Apache style config file
    1              0.000005 au BufNewFile,BufRead proftpd.conf*		call s:StarSetf('apachestyle')
                            
                            " Apache config file
    1              0.000010 au BufNewFile,BufRead .htaccess,*/etc/httpd/*.conf		setf apache
                            
                            " XA65 MOS6510 cross assembler
    1              0.000006 au BufNewFile,BufRead *.a65			setf a65
                            
                            " Applescript
    1              0.000004 au BufNewFile,BufRead *.scpt			setf applescript
                            
                            " Applix ELF
    1              0.000005 au BufNewFile,BufRead *.am
                            	\ if expand("<afile>") !~? 'Makefile.am\>' | setf elf | endif
                            
                            " ALSA configuration
    1              0.000015 au BufNewFile,BufRead .asoundrc,*/usr/share/alsa/alsa.conf,*/etc/asound.conf setf alsaconf
                            
                            " Arc Macro Language
    1              0.000004 au BufNewFile,BufRead *.aml			setf aml
                            
                            " APT config file
    1              0.000007 au BufNewFile,BufRead apt.conf		       setf aptconf
    1              0.000006 au BufNewFile,BufRead */.aptitude/config       setf aptconf
    1              0.000015 au BufNewFile,BufRead */etc/apt/apt.conf.d/{[-_[:alnum:]]\+,[-_.[:alnum:]]\+.conf} setf aptconf
                            
                            " Arch Inventory file
    1              0.000009 au BufNewFile,BufRead .arch-inventory,=tagging-method	setf arch
                            
                            " ART*Enterprise (formerly ART-IM)
    1              0.000006 au BufNewFile,BufRead *.art			setf art
                            
                            " AsciiDoc
    1              0.000005 au BufNewFile,BufRead *.asciidoc		setf asciidoc
                            
                            " ASN.1
    1              0.000007 au BufNewFile,BufRead *.asn,*.asn1		setf asn
                            
                            " Active Server Pages (with Visual Basic Script)
    1              0.000008 au BufNewFile,BufRead *.asa
                            	\ if exists("g:filetype_asa") |
                            	\   exe "setf " . g:filetype_asa |
                            	\ else |
                            	\   setf aspvbs |
                            	\ endif
                            
                            " Active Server Pages (with Perl or Visual Basic Script)
    1              0.000011 au BufNewFile,BufRead *.asp
                            	\ if exists("g:filetype_asp") |
                            	\   exe "setf " . g:filetype_asp |
                            	\ elseif getline(1) . getline(2) . getline(3) =~? "perlscript" |
                            	\   setf aspperl |
                            	\ else |
                            	\   setf aspvbs |
                            	\ endif
                            
                            " Grub (must be before catch *.lst)
    1              0.000016 au BufNewFile,BufRead */boot/grub/menu.lst,*/boot/grub/grub.conf,*/etc/grub.conf setf grub
                            
                            " Assembly (all kinds)
                            " *.lst is not pure assembly, it has two extra columns (address, byte codes)
    1              0.000018 au BufNewFile,BufRead *.asm,*.[sS],*.[aA],*.mac,*.lst	call s:FTasm()
                            
                            " This function checks for the kind of assembly that is wanted by the user, or
                            " can be detected from the first five lines of the file.
    1              0.000002 func! s:FTasm()
                              " make sure b:asmsyntax exists
                              if !exists("b:asmsyntax")
                                let b:asmsyntax = ""
                              endif
                            
                              if b:asmsyntax == ""
                                call s:FTasmsyntax()
                              endif
                            
                              " if b:asmsyntax still isn't set, default to asmsyntax or GNU
                              if b:asmsyntax == ""
                                if exists("g:asmsyntax")
                                  let b:asmsyntax = g:asmsyntax
                                else
                                  let b:asmsyntax = "asm"
                                endif
                              endif
                            
                              exe "setf " . fnameescape(b:asmsyntax)
                            endfunc
                            
    1              0.000001 func! s:FTasmsyntax()
                              " see if file contains any asmsyntax=foo overrides. If so, change
                              " b:asmsyntax appropriately
                              let head = " ".getline(1)." ".getline(2)." ".getline(3)." ".getline(4).
                            	\" ".getline(5)." "
                              let match = matchstr(head, '\sasmsyntax=\zs[a-zA-Z0-9]\+\ze\s')
                              if match != ''
                                let b:asmsyntax = match
                              elseif ((head =~? '\.title') || (head =~? '\.ident') || (head =~? '\.macro') || (head =~? '\.subtitle') || (head =~? '\.library'))
                                let b:asmsyntax = "vmasm"
                              endif
                            endfunc
                            
                            " Macro (VAX)
    1              0.000005 au BufNewFile,BufRead *.mar			setf vmasm
                            
                            " Atlas
    1              0.000009 au BufNewFile,BufRead *.atl,*.as		setf atlas
                            
                            " Autoit v3
    1              0.000004 au BufNewFile,BufRead *.au3			setf autoit
                            
                            " Autohotkey
    1              0.000004 au BufNewFile,BufRead *.ahk			setf autohotkey
                            
                            " Automake
    1              0.000011 au BufNewFile,BufRead [mM]akefile.am,GNUmakefile.am	setf automake
                            
                            " Autotest .at files are actually m4
    1              0.000004 au BufNewFile,BufRead *.at			setf m4
                            
                            " Avenue
    1              0.000006 au BufNewFile,BufRead *.ave			setf ave
                            
                            " Awk
    1              0.000006 au BufNewFile,BufRead *.awk			setf awk
                            
                            " B
    1              0.000011 au BufNewFile,BufRead *.mch,*.ref,*.imp		setf b
                            
                            " BASIC or Visual Basic
    1              0.000004 au BufNewFile,BufRead *.bas			call s:FTVB("basic")
                            
                            " Check if one of the first five lines contains "VB_Name".  In that case it is
                            " probably a Visual Basic file.  Otherwise it's assumed to be "alt" filetype.
    1              0.000002 func! s:FTVB(alt)
                              if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'VB_Name\|Begin VB\.\(Form\|MDIForm\|UserControl\)'
                                setf vb
                              else
                                exe "setf " . a:alt
                              endif
                            endfunc
                            
                            " Visual Basic Script (close to Visual Basic) or Visual Basic .NET
    1              0.000014 au BufNewFile,BufRead *.vb,*.vbs,*.dsm,*.ctl	setf vb
                            
                            " IBasic file (similar to QBasic)
    1              0.000009 au BufNewFile,BufRead *.iba,*.ibi		setf ibasic
                            
                            " FreeBasic file (similar to QBasic)
    1              0.000007 au BufNewFile,BufRead *.fb,*.bi			setf freebasic
                            
                            " Batch file for MSDOS.
    1              0.000009 au BufNewFile,BufRead *.bat,*.sys		setf dosbatch
                            " *.cmd is close to a Batch file, but on OS/2 Rexx files also use *.cmd.
    1              0.000005 au BufNewFile,BufRead *.cmd
                            	\ if getline(1) =~ '^/\*' | setf rexx | else | setf dosbatch | endif
                            
                            " Batch file for 4DOS
    1              0.000004 au BufNewFile,BufRead *.btm			call s:FTbtm()
    1              0.000001 func! s:FTbtm()
                              if exists("g:dosbatch_syntax_for_btm") && g:dosbatch_syntax_for_btm
                                setf dosbatch
                              else
                                setf btm
                              endif
                            endfunc
                            
                            " BC calculator
    1              0.000006 au BufNewFile,BufRead *.bc			setf bc
                            
                            " BDF font
    1              0.000004 au BufNewFile,BufRead *.bdf			setf bdf
                            
                            " BibTeX bibliography database file
    1              0.000004 au BufNewFile,BufRead *.bib			setf bib
                            
                            " BibTeX Bibliography Style
    1              0.000004 au BufNewFile,BufRead *.bst			setf bst
                            
                            " BIND configuration
    1              0.000011 au BufNewFile,BufRead named.conf,rndc.conf	setf named
                            
                            " BIND zone
    1              0.000007 au BufNewFile,BufRead named.root		setf bindzone
    1              0.000007 au BufNewFile,BufRead *.db			call s:BindzoneCheck('')
                            
    1              0.000002 func! s:BindzoneCheck(default)
                              if getline(1).getline(2).getline(3).getline(4) =~ '^; <<>> DiG [0-9.]\+ <<>>\|BIND.*named\|$ORIGIN\|$TTL\|IN\s\+SOA'
                                setf bindzone
                              elseif a:default != ''
                                exe 'setf ' . a:default
                              endif
                            endfunc
                            
                            " Blank
    1              0.000005 au BufNewFile,BufRead *.bl			setf blank
                            
                            " Blkid cache file
    1              0.000012 au BufNewFile,BufRead */etc/blkid.tab,*/etc/blkid.tab.old   setf xml
                            
                            " C or lpc
    1              0.000005 au BufNewFile,BufRead *.c			call s:FTlpc()
                            
    1              0.000003 func! s:FTlpc()
                              if exists("g:lpc_syntax_for_c")
                                let lnum = 1
                                while lnum <= 12
                                  if getline(lnum) =~# '^\(//\|inherit\|private\|protected\|nosave\|string\|object\|mapping\|mixed\)'
                            	setf lpc
                            	return
                                  endif
                                  let lnum = lnum + 1
                                endwhile
                              endif
                              setf c
                            endfunc
                            
                            " Calendar
    1              0.000008 au BufNewFile,BufRead calendar			setf calendar
                            
                            " C#
    1              0.000005 au BufNewFile,BufRead *.cs			setf cs
                            
                            " CSDL
    1              0.000005 au BufNewFile,BufRead *.csdl			setf csdl
                            
                            " Cabal
    1              0.000007 au BufNewFile,BufRead *.cabal			setf cabal
                            
                            " Cdrdao TOC
    1              0.000005 au BufNewFile,BufRead *.toc			setf cdrtoc
                            
                            " Cdrdao config
    1              0.000020 au BufNewFile,BufRead */etc/cdrdao.conf,*/etc/defaults/cdrdao,*/etc/default/cdrdao,.cdrdao	setf cdrdaoconf
                            
                            " Cfengine
    1              0.000008 au BufNewFile,BufRead cfengine.conf		setf cfengine
                            
                            " ChaiScript
    1              0.000005 au BufRead,BufNewFile *.chai			setf chaiscript
                            
                            " Comshare Dimension Definition Language
    1              0.000005 au BufNewFile,BufRead *.cdl			setf cdl
                            
                            " Conary Recipe
    1              0.000007 au BufNewFile,BufRead *.recipe			setf conaryrecipe
                            
                            " Controllable Regex Mutilator
    1              0.000005 au BufNewFile,BufRead *.crm			setf crm
                            
                            " Cyn++
    1              0.000005 au BufNewFile,BufRead *.cyn			setf cynpp
                            
                            " Cynlib
                            " .cc and .cpp files can be C++ or Cynlib.
    1              0.000008 au BufNewFile,BufRead *.cc
                            	\ if exists("cynlib_syntax_for_cc")|setf cynlib|else|setf cpp|endif
    1              0.000006 au BufNewFile,BufRead *.cpp
                            	\ if exists("cynlib_syntax_for_cpp")|setf cynlib|else|setf cpp|endif
                            
                            " C++
    1              0.000033 au BufNewFile,BufRead *.cxx,*.c++,*.hh,*.hxx,*.hpp,*.ipp,*.moc,*.tcc,*.inl setf cpp
    1              0.000003 if has("fname_case")
    1              0.000010   au BufNewFile,BufRead *.C,*.H setf cpp
    1              0.000001 endif
                            
                            " .h files can be C, Ch C++, ObjC or ObjC++.
                            " Set c_syntax_for_h if you want C, ch_syntax_for_h if you want Ch. ObjC is
                            " detected automatically.
    1              0.000005 au BufNewFile,BufRead *.h			call s:FTheader()
                            
    1              0.000001 func! s:FTheader()
                              if match(getline(1, min([line("$"), 200])), '^@\(interface\|end\|class\)') > -1
                                if exists("g:c_syntax_for_h")
                                  setf objc
                                else
                                  setf objcpp
                                endif
                              elseif exists("g:c_syntax_for_h")
                                setf c
                              elseif exists("g:ch_syntax_for_h")
                                setf ch
                              else
                                setf cpp
                              endif
                            endfunc
                            
                            " Ch (CHscript)
    1              0.000006 au BufNewFile,BufRead *.chf			setf ch
                            
                            " TLH files are C++ headers generated by Visual C++'s #import from typelibs
    1              0.000005 au BufNewFile,BufRead *.tlh			setf cpp
                            
                            " Cascading Style Sheets
    1              0.000007 au BufNewFile,BufRead *.css			setf css
                            
                            " Century Term Command Scripts (*.cmd too)
    1              0.000005 au BufNewFile,BufRead *.con			setf cterm
                            
                            " Changelog
    1              0.000023 au BufNewFile,BufRead changelog.Debian,changelog.dch,NEWS.Debian,NEWS.dch
                            					\	setf debchangelog
                            
    1              0.000009 au BufNewFile,BufRead [cC]hange[lL]og
                            	\  if getline(1) =~ '; urgency='
                            	\|   setf debchangelog
                            	\| else
                            	\|   setf changelog
                            	\| endif
                            
    1              0.000010 au BufNewFile,BufRead NEWS
                            	\  if getline(1) =~ '; urgency='
                            	\|   setf debchangelog
                            	\| endif
                            
                            " CHILL
    1              0.000006 au BufNewFile,BufRead *..ch			setf chill
                            
                            " Changes for WEB and CWEB or CHILL
    1              0.000005 au BufNewFile,BufRead *.ch			call s:FTchange()
                            
                            " This function checks if one of the first ten lines start with a '@'.  In
                            " that case it is probably a change file.
                            " If the first line starts with # or ! it's probably a ch file.
                            " If a line has "main", "include", "//" ir "/*" it's probably ch.
                            " Otherwise CHILL is assumed.
    1              0.000001 func! s:FTchange()
                              let lnum = 1
                              while lnum <= 10
                                if getline(lnum)[0] == '@'
                                  setf change
                                  return
                                endif
                                if lnum == 1 && (getline(1)[0] == '#' || getline(1)[0] == '!')
                                  setf ch
                                  return
                                endif
                                if getline(lnum) =~ "MODULE"
                                  setf chill
                                  return
                                endif
                                if getline(lnum) =~ 'main\s*(\|#\s*include\|//'
                                  setf ch
                                  return
                                endif
                                let lnum = lnum + 1
                              endwhile
                              setf chill
                            endfunc
                            
                            " ChordPro
    1              0.000025 au BufNewFile,BufRead *.chopro,*.crd,*.cho,*.crdpro,*.chordpro	setf chordpro
                            
                            " Clean
    1              0.000009 au BufNewFile,BufRead *.dcl,*.icl		setf clean
                            
                            " Clever
    1              0.000007 au BufNewFile,BufRead *.eni			setf cl
                            
                            " Clever or dtd
    1              0.000005 au BufNewFile,BufRead *.ent			call s:FTent()
                            
    1              0.000001 func! s:FTent()
                              " This function checks for valid cl syntax in the first five lines.
                              " Look for either an opening comment, '#', or a block start, '{".
                              " If not found, assume SGML.
                              let lnum = 1
                              while lnum < 6
                                let line = getline(lnum)
                                if line =~ '^\s*[#{]'
                                  setf cl
                                  return
                                elseif line !~ '^\s*$'
                                  " Not a blank line, not a comment, and not a block start,
                                  " so doesn't look like valid cl code.
                                  break
                                endif
                                let lnum = lnum + 1
                              endw
                              setf dtd
                            endfunc
                            
                            " Clipper (or FoxPro; could also be eviews)
    1              0.000008 au BufNewFile,BufRead *.prg
                            	\ if exists("g:filetype_prg") |
                            	\   exe "setf " . g:filetype_prg |
                            	\ else |
                            	\   setf clipper |
                            	\ endif
                            
                            " Clojure
    1              0.000019 au BufNewFile,BufRead *.clj,*.cljs,*.cljx,*.cljc		setf clojure
                            
                            " Cmake
    1              0.000017 au BufNewFile,BufRead CMakeLists.txt,*.cmake,*.cmake.in		setf cmake
                            
                            " Cmusrc
    1              0.000011 au BufNewFile,BufRead */.cmus/{autosave,rc,command-history,*.theme} setf cmusrc
    1              0.000008 au BufNewFile,BufRead */cmus/{rc,*.theme}			setf cmusrc
                            
                            " Cobol
    1              0.000015 au BufNewFile,BufRead *.cbl,*.cob,*.lib	setf cobol
                            "   cobol or zope form controller python script? (heuristic)
    1              0.000009 au BufNewFile,BufRead *.cpy
                            	\ if getline(1) =~ '^##' |
                            	\   setf python |
                            	\ else |
                            	\   setf cobol |
                            	\ endif
                            
                            " Coco/R
    1              0.000008 au BufNewFile,BufRead *.atg			setf coco
                            
                            " Cold Fusion
    1              0.000013 au BufNewFile,BufRead *.cfm,*.cfi,*.cfc		setf cf
                            
                            " Configure scripts
    1              0.000013 au BufNewFile,BufRead configure.in,configure.ac setf config
                            
                            " CUDA  Cumpute Unified Device Architecture
    1              0.000008 au BufNewFile,BufRead *.cu			setf cuda
                            
                            " Dockerfile
    1              0.000007 au BufNewFile,BufRead Dockerfile		setf dockerfile
                            
                            " WildPackets EtherPeek Decoder
    1              0.000006 au BufNewFile,BufRead *.dcd			setf dcd
                            
                            " Enlightenment configuration files
    1              0.000008 au BufNewFile,BufRead *enlightenment/*.cfg	setf c
                            
                            " Eterm
    1              0.000009 au BufNewFile,BufRead *Eterm/*.cfg		setf eterm
                            
                            " Euphoria 3 or 4
    1              0.000022 au BufNewFile,BufRead *.eu,*.ew,*.ex,*.exu,*.exw  call s:EuphoriaCheck()
    1              0.000002 if has("fname_case")
    1              0.000023    au BufNewFile,BufRead *.EU,*.EW,*.EX,*.EXU,*.EXW  call s:EuphoriaCheck()
    1              0.000001 endif
                            
    1              0.000002 func! s:EuphoriaCheck()
                              if exists('g:filetype_euphoria')
                                exe 'setf ' . g:filetype_euphoria
                              else
                                setf euphoria3
                              endif
                            endfunc
                            
                            " Lynx config files
    1              0.000010 au BufNewFile,BufRead lynx.cfg			setf lynx
                            
                            " Quake
    1              0.000015 au BufNewFile,BufRead *baseq[2-3]/*.cfg,*id1/*.cfg	setf quake
    1              0.000007 au BufNewFile,BufRead *quake[1-3]/*.cfg			setf quake
                            
                            " Quake C
    1              0.000006 au BufNewFile,BufRead *.qc			setf c
                            
                            " Configure files
    1              0.000008 au BufNewFile,BufRead *.cfg			setf cfg
                            
                            " Cucumber
    1              0.000007 au BufNewFile,BufRead *.feature			setf cucumber
                            
                            " Communicating Sequential Processes
    1              0.000010 au BufNewFile,BufRead *.csp,*.fdr		setf csp
                            
                            " CUPL logic description and simulation
    1              0.000008 au BufNewFile,BufRead *.pld			setf cupl
    1              0.000006 au BufNewFile,BufRead *.si			setf cuplsim
                            
                            " Debian Control
    1              0.000009 au BufNewFile,BufRead */debian/control		setf debcontrol
    1              0.000008 au BufNewFile,BufRead control
                            	\  if getline(1) =~ '^Source:'
                            	\|   setf debcontrol
                            	\| endif
                            
                            " Debian Sources.list
    1              0.000008 au BufNewFile,BufRead */etc/apt/sources.list		setf debsources
    1              0.000009 au BufNewFile,BufRead */etc/apt/sources.list.d/*.list	setf debsources
                            
                            " Deny hosts
    1              0.000009 au BufNewFile,BufRead denyhosts.conf		setf denyhosts
                            
                            " dnsmasq(8) configuration files
    1              0.000007 au BufNewFile,BufRead */etc/dnsmasq.conf	setf dnsmasq
                            
                            " ROCKLinux package description
    1              0.000007 au BufNewFile,BufRead *.desc			setf desc
                            
                            " the D language or dtrace
    1              0.000008 au BufNewFile,BufRead *.d			call s:DtraceCheck()
                            
    1              0.000002 func! s:DtraceCheck()
                              let lines = getline(1, min([line("$"), 100]))
                              if match(lines, '^module\>\|^import\>') > -1
                                " D files often start with a module and/or import statement.
                                setf d
                              elseif match(lines, '^#!\S\+dtrace\|#pragma\s\+D\s\+option\|:\S\{-}:\S\{-}:') > -1
                                setf dtrace
                              else
                                setf d
                              endif
                            endfunc
                            
                            " Desktop files
    1              0.000013 au BufNewFile,BufRead *.desktop,.directory	setf desktop
                            
                            " Dict config
    1              0.000014 au BufNewFile,BufRead dict.conf,.dictrc		setf dictconf
                            
                            " Dictd config
    1              0.000009 au BufNewFile,BufRead dictd.conf		setf dictdconf
                            
                            " Diff files
    1              0.000016 au BufNewFile,BufRead *.diff,*.rej,*.patch	setf diff
                            
                            " Dircolors
    1              0.000021 au BufNewFile,BufRead .dir_colors,.dircolors,*/etc/DIR_COLORS	setf dircolors
                            
                            " Diva (with Skill) or InstallShield
    1              0.000009 au BufNewFile,BufRead *.rul
                            	\ if getline(1).getline(2).getline(3).getline(4).getline(5).getline(6) =~? 'InstallShield' |
                            	\   setf ishd |
                            	\ else |
                            	\   setf diva |
                            	\ endif
                            
                            " DCL (Digital Command Language - vms) or DNS zone file
    1              0.000007 au BufNewFile,BufRead *.com			call s:BindzoneCheck('dcl')
                            
                            " DOT
    1              0.000008 au BufNewFile,BufRead *.dot			setf dot
                            
                            " Dylan - lid files
    1              0.000007 au BufNewFile,BufRead *.lid			setf dylanlid
                            
                            " Dylan - intr files (melange)
    1              0.000007 au BufNewFile,BufRead *.intr			setf dylanintr
                            
                            " Dylan
    1              0.000007 au BufNewFile,BufRead *.dylan			setf dylan
                            
                            " Microsoft Module Definition
    1              0.000008 au BufNewFile,BufRead *.def			setf def
                            
                            " Dracula
    1              0.000023 au BufNewFile,BufRead *.drac,*.drc,*lvs,*lpe	setf dracula
                            
                            " Datascript
    1              0.000007 au BufNewFile,BufRead *.ds			setf datascript
                            
                            " dsl
    1              0.000007 au BufNewFile,BufRead *.dsl			setf dsl
                            
                            " DTD (Document Type Definition for XML)
    1              0.000006 au BufNewFile,BufRead *.dtd			setf dtd
                            
                            " DTS/DSTI (device tree files)
    1              0.000013 au BufNewFile,BufRead *.dts,*.dtsi		setf dts
                            
                            " EDIF (*.edf,*.edif,*.edn,*.edo)
    1              0.000009 au BufNewFile,BufRead *.ed\(f\|if\|n\|o\)	setf edif
                            
                            " Embedix Component Description
    1              0.000009 au BufNewFile,BufRead *.ecd			setf ecd
                            
                            " Eiffel or Specman or Euphoria
    1              0.000011 au BufNewFile,BufRead *.e,*.E			call s:FTe()
                            
                            " Elinks configuration
    1              0.000017 au BufNewFile,BufRead */etc/elinks.conf,*/.elinks/elinks.conf	setf elinks
                            
    1              0.000001 func! s:FTe()
                              if exists('g:filetype_euphoria')
                                exe 'setf ' . g:filetype_euphoria
                              else
                                let n = 1
                                while n < 100 && n < line("$")
                                  if getline(n) =~ "^\\s*\\(<'\\|'>\\)\\s*$"
                                    setf specman
                                    return
                                  endif
                                  let n = n + 1
                                endwhile
                                setf eiffel
                              endif
                            endfunc
                            
                            " ERicsson LANGuage; Yaws is erlang too
    1              0.000020 au BufNewFile,BufRead *.erl,*.hrl,*.yaws	setf erlang
                            
                            " Elm Filter Rules file
    1              0.000008 au BufNewFile,BufRead filter-rules		setf elmfilt
                            
                            " ESMTP rc file
    1              0.000007 au BufNewFile,BufRead *esmtprc			setf esmtprc
                            
                            " ESQL-C
    1              0.000014 au BufNewFile,BufRead *.ec,*.EC			setf esqlc
                            
                            " Esterel
    1              0.000007 au BufNewFile,BufRead *.strl			setf esterel
                            
                            " Essbase script
    1              0.000007 au BufNewFile,BufRead *.csc			setf csc
                            
                            " Exim
    1              0.000010 au BufNewFile,BufRead exim.conf			setf exim
                            
                            " Expect
    1              0.000007 au BufNewFile,BufRead *.exp			setf expect
                            
                            " Exports
    1              0.000007 au BufNewFile,BufRead exports			setf exports
                            
                            " Falcon
    1              0.000009 au BufNewFile,BufRead *.fal			setf falcon
                            
                            " Fantom
    1              0.000012 au BufNewFile,BufRead *.fan,*.fwt		setf fan
                            
                            " Factor
    1              0.000007 au BufNewFile,BufRead *.factor			setf factor
                            
                            " Fetchmail RC file
    1              0.000010 au BufNewFile,BufRead .fetchmailrc		setf fetchmail
                            
                            " FlexWiki - disabled, because it has side effects when a .wiki file
                            " is not actually FlexWiki
                            "au BufNewFile,BufRead *.wiki			setf flexwiki
                            
                            " Focus Executable
    1              0.000015 au BufNewFile,BufRead *.fex,*.focexec		setf focexec
                            
                            " Focus Master file (but not for auto.master)
    1              0.000008 au BufNewFile,BufRead auto.master		setf conf
    1              0.000014 au BufNewFile,BufRead *.mas,*.master		setf master
                            
                            " Forth
    1              0.000012 au BufNewFile,BufRead *.fs,*.ft			setf forth
                            
                            " Reva Forth
    1              0.000007 au BufNewFile,BufRead *.frt			setf reva
                            
                            " Fortran
    1              0.000002 if has("fname_case")
    1              0.000055   au BufNewFile,BufRead *.F,*.FOR,*.FPP,*.FTN,*.F77,*.F90,*.F95,*.F03,*.F08	 setf fortran
    1              0.000001 endif
    1              0.000059 au BufNewFile,BufRead   *.f,*.for,*.fortran,*.fpp,*.ftn,*.f77,*.f90,*.f95,*.f03,*.f08  setf fortran
                            
                            " Framescript
    1              0.000007 au BufNewFile,BufRead *.fsl			setf framescript
                            
                            " FStab
    1              0.000017 au BufNewFile,BufRead fstab,mtab		setf fstab
                            
                            " GDB command files
    1              0.000008 au BufNewFile,BufRead .gdbinit			setf gdb
                            
                            " GDMO
    1              0.000016 au BufNewFile,BufRead *.mo,*.gdmo		setf gdmo
                            
                            " Gedcom
    1              0.000017 au BufNewFile,BufRead *.ged,lltxxxxx.txt	setf gedcom
                            
                            " Git
    1              0.000009 au BufNewFile,BufRead COMMIT_EDITMSG		setf gitcommit
    1              0.000008 au BufNewFile,BufRead MERGE_MSG			setf gitcommit
    1              0.000024 au BufNewFile,BufRead *.git/config,.gitconfig,.gitmodules setf gitconfig
    1              0.000010 au BufNewFile,BufRead *.git/modules/*/config	setf gitconfig
    1              0.000009 au BufNewFile,BufRead */.config/git/config	setf gitconfig
    1              0.000003 if !empty($XDG_CONFIG_HOME)
    1              0.000013   au BufNewFile,BufRead $XDG_CONFIG_HOME/git/config	setf gitconfig
    1              0.000001 endif
    1              0.000009 au BufNewFile,BufRead git-rebase-todo		setf gitrebase
    1              0.000010 au BufNewFile,BufRead .msg.[0-9]*
                                  \ if getline(1) =~ '^From.*# This line is ignored.$' |
                                  \   setf gitsendemail |
                                  \ endif
    1              0.000011 au BufNewFile,BufRead *.git/*
                                  \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
                                  \   setf git |
                                  \ endif
                            
                            " Gkrellmrc
    1              0.000015 au BufNewFile,BufRead gkrellmrc,gkrellmrc_?	setf gkrellmrc
                            
                            " GP scripts (2.0 and onward)
    1              0.000017 au BufNewFile,BufRead *.gp,.gprc		setf gp
                            
                            " GPG
    1              0.000010 au BufNewFile,BufRead */.gnupg/options		setf gpg
    1              0.000011 au BufNewFile,BufRead */.gnupg/gpg.conf		setf gpg
    1              0.000012 au BufNewFile,BufRead */usr/*/gnupg/options.skel setf gpg
                            
                            " gnash(1) configuration files
    1              0.000031 au BufNewFile,BufRead gnashrc,.gnashrc,gnashpluginrc,.gnashpluginrc setf gnash
                            
                            " Gitolite
    1              0.000010 au BufNewFile,BufRead gitolite.conf		setf gitolite
    1              0.000010 au BufNewFile,BufRead */gitolite-admin/conf/*	call s:StarSetf('gitolite')
    1              0.000019 au BufNewFile,BufRead {,.}gitolite.rc,example.gitolite.rc	setf perl
                            
                            " Gnuplot scripts
    1              0.000009 au BufNewFile,BufRead *.gpi			setf gnuplot
                            
                            " Go (Google)
    1              0.000008 au BufNewFile,BufRead *.go			setf go
                            
                            " GrADS scripts
    1              0.000007 au BufNewFile,BufRead *.gs			setf grads
                            
                            " Gretl
    1              0.000011 au BufNewFile,BufRead *.gretl			setf gretl
                            
                            " Groovy
    1              0.000008 au BufNewFile,BufRead *.groovy			setf groovy
                            
                            " GNU Server Pages
    1              0.000008 au BufNewFile,BufRead *.gsp			setf gsp
                            
                            " Group file
    1              0.000064 au BufNewFile,BufRead */etc/group,*/etc/group-,*/etc/group.edit,*/etc/gshadow,*/etc/gshadow-,*/etc/gshadow.edit,*/var/backups/group.bak,*/var/backups/gshadow.bak  setf group
                            
                            " GTK RC
    1              0.000020 au BufNewFile,BufRead .gtkrc,gtkrc		setf gtkrc
                            
                            " Haml
    1              0.000009 au BufNewFile,BufRead *.haml			setf haml
                            
                            " Hamster Classic | Playground files
    1              0.000017 au BufNewFile,BufRead *.hsc,*.hsm		setf hamster
                            
                            " Haskell
    1              0.000015 au BufNewFile,BufRead *.hs,*.hs-boot		setf haskell
    1              0.000008 au BufNewFile,BufRead *.lhs			setf lhaskell
    1              0.000011 au BufNewFile,BufRead *.chs			setf chaskell
                            
                            " Haste
    1              0.000008 au BufNewFile,BufRead *.ht			setf haste
    1              0.000008 au BufNewFile,BufRead *.htpp			setf hastepreproc
                            
                            " Hercules
    1              0.000036 au BufNewFile,BufRead *.vc,*.ev,*.rs,*.sum,*.errsum	setf hercules
                            
                            " HEX (Intel)
    1              0.000017 au BufNewFile,BufRead *.hex,*.h32		setf hex
                            
                            " Tilde (must be before HTML)
    1              0.000009 au BufNewFile,BufRead *.t.html			setf tilde
                            
                            " HTML (.shtml and .stm for server side)
    1              0.000030 au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call s:FThtml()
                            
                            " Distinguish between HTML, XHTML and Django
    1              0.000002 func! s:FThtml()
                              let n = 1
                              while n < 10 && n < line("$")
                                if getline(n) =~ '\<DTD\s\+XHTML\s'
                                  setf xhtml
                                  return
                                endif
                                if getline(n) =~ '{%\s*\(extends\|block\|load\)\>\|{#\s\+'
                                  setf htmldjango
                                  return
                                endif
                                let n = n + 1
                              endwhile
                              setf html
                            endfunc
                            
                            " HTML with Ruby - eRuby
    1              0.000018 au BufNewFile,BufRead *.erb,*.rhtml		setf eruby
                            
                            " HTML with M4
    1              0.000009 au BufNewFile,BufRead *.html.m4			setf htmlm4
                            
                            " HTML Cheetah template
    1              0.000011 au BufNewFile,BufRead *.tmpl			setf htmlcheetah
                            
                            " Host config
    1              0.000010 au BufNewFile,BufRead */etc/host.conf		setf hostconf
                            
                            " Hosts access
    1              0.000019 au BufNewFile,BufRead */etc/hosts.allow,*/etc/hosts.deny  setf hostsaccess
                            
                            " Hyper Builder
    1              0.000009 au BufNewFile,BufRead *.hb			setf hb
                            
                            " Httest
    1              0.000018 au BufNewFile,BufRead *.htt,*.htb		setf httest
                            
                            " Icon
    1              0.000009 au BufNewFile,BufRead *.icn			setf icon
                            
                            " IDL (Interface Description Language)
    1              0.000010 au BufNewFile,BufRead *.idl			call s:FTidl()
                            
                            " Distinguish between standard IDL and MS-IDL
    1              0.000001 func! s:FTidl()
                              let n = 1
                              while n < 50 && n < line("$")
                                if getline(n) =~ '^\s*import\s\+"\(unknwn\|objidl\)\.idl"'
                                  setf msidl
                                  return
                                endif
                                let n = n + 1
                              endwhile
                              setf idl
                            endfunc
                            
                            " Microsoft IDL (Interface Description Language)  Also *.idl
                            " MOF = WMI (Windows Management Instrumentation) Managed Object Format
    1              0.000016 au BufNewFile,BufRead *.odl,*.mof		setf msidl
                            
                            " Icewm menu
    1              0.000012 au BufNewFile,BufRead */.icewm/menu		setf icemenu
                            
                            " Indent profile (must come before IDL *.pro!)
    1              0.000010 au BufNewFile,BufRead .indent.pro		setf indent
    1              0.000009 au BufNewFile,BufRead indent.pro		call s:ProtoCheck('indent')
                            
                            " IDL (Interactive Data Language)
    1              0.000012 au BufNewFile,BufRead *.pro			call s:ProtoCheck('idlang')
                            
                            " Distinguish between "default" and Cproto prototype file. */
    1              0.000002 func! s:ProtoCheck(default)
                              " Cproto files have a comment in the first line and a function prototype in
                              " the second line, it always ends in ";".  Indent files may also have
                              " comments, thus we can't match comments to see the difference.
                              " IDL files can have a single ';' in the second line, require at least one
                              " chacter before the ';'.
                              if getline(2) =~ '.;$'
                                setf cpp
                              else
                                exe 'setf ' . a:default
                              endif
                            endfunc
                            
                            
                            " Indent RC
    1              0.000010 au BufNewFile,BufRead indentrc			setf indent
                            
                            " Inform
    1              0.000018 au BufNewFile,BufRead *.inf,*.INF		setf inform
                            
                            " Initng
    1              0.000018 au BufNewFile,BufRead */etc/initng/*/*.i,*.ii	setf initng
                            
                            " Innovation Data Processing
    1              0.000030 au BufRead,BufNewFile upstream.dat\c,upstream.*.dat\c,*.upstream.dat\c 	setf upstreamdat
    1              0.000031 au BufRead,BufNewFile upstream.log\c,upstream.*.log\c,*.upstream.log\c 	setf upstreamlog
    1              0.000030 au BufRead,BufNewFile upstreaminstall.log\c,upstreaminstall.*.log\c,*.upstreaminstall.log\c setf upstreaminstalllog
    1              0.000030 au BufRead,BufNewFile usserver.log\c,usserver.*.log\c,*.usserver.log\c 	setf usserverlog
    1              0.000030 au BufRead,BufNewFile usw2kagt.log\c,usw2kagt.*.log\c,*.usw2kagt.log\c 	setf usw2kagtlog
                            
                            " Ipfilter
    1              0.000027 au BufNewFile,BufRead ipf.conf,ipf6.conf,ipf.rules	setf ipfilter
                            
                            " Informix 4GL (source - canonical, include file, I4GL+M4 preproc.)
    1              0.000025 au BufNewFile,BufRead *.4gl,*.4gh,*.m4gl	setf fgl
                            
                            " .INI file for MSDOS
    1              0.000012 au BufNewFile,BufRead *.ini			setf dosini
                            
                            " SysV Inittab
    1              0.000010 au BufNewFile,BufRead inittab			setf inittab
                            
                            " Inno Setup
    1              0.000009 au BufNewFile,BufRead *.iss			setf iss
                            
                            " J
    1              0.000009 au BufNewFile,BufRead *.ijs			setf j
                            
                            " JAL
    1              0.000018 au BufNewFile,BufRead *.jal,*.JAL		setf jal
                            
                            " Jam
    1              0.000018 au BufNewFile,BufRead *.jpl,*.jpr		setf jam
                            
                            " Java
    1              0.000017 au BufNewFile,BufRead *.java,*.jav		setf java
                            
                            " JavaCC
    1              0.000019 au BufNewFile,BufRead *.jj,*.jjt		setf javacc
                            
                            " JavaScript, ECMAScript
    1              0.000037 au BufNewFile,BufRead *.js,*.javascript,*.es,*.jsx   setf javascript
                            
                            " Java Server Pages
    1              0.000010 au BufNewFile,BufRead *.jsp			setf jsp
                            
                            " Java Properties resource file (note: doesn't catch font.properties.pl)
    1              0.000031 au BufNewFile,BufRead *.properties,*.properties_??,*.properties_??_??	setf jproperties
    1              0.000014 au BufNewFile,BufRead *.properties_??_??_*	call s:StarSetf('jproperties')
                            
                            " Jess
    1              0.000011 au BufNewFile,BufRead *.clp			setf jess
                            
                            " Jgraph
    1              0.000009 au BufNewFile,BufRead *.jgr			setf jgraph
                            
                            " Jovial
    1              0.000027 au BufNewFile,BufRead *.jov,*.j73,*.jovial	setf jovial
                            
                            " JSON
    1              0.000020 au BufNewFile,BufRead *.json,*.jsonp		setf json
                            
                            " Kixtart
    1              0.000010 au BufNewFile,BufRead *.kix			setf kix
                            
                            " Kimwitu[++]
    1              0.000009 au BufNewFile,BufRead *.k			setf kwt
                            
                            " Kivy
    1              0.000011 au BufNewFile,BufRead *.kv			setf kivy
                            
                            " KDE script
    1              0.000011 au BufNewFile,BufRead *.ks			setf kscript
                            
                            " Kconfig
    1              0.000021 au BufNewFile,BufRead Kconfig,Kconfig.debug	setf kconfig
                            
                            " Lace (ISE)
    1              0.000019 au BufNewFile,BufRead *.ace,*.ACE		setf lace
                            
                            " Latte
    1              0.000030 au BufNewFile,BufRead *.latte,*.lte		setf latte
                            
                            " Limits
    1              0.000033 au BufNewFile,BufRead */etc/limits,*/etc/*limits.conf,*/etc/*limits.d/*.conf	setf limits
                            
                            " LambdaProlog (*.mod too, see Modsim)
    1              0.000011 au BufNewFile,BufRead *.sig			setf lprolog
                            
                            " LDAP LDIF
    1              0.000010 au BufNewFile,BufRead *.ldif			setf ldif
                            
                            " Ld loader
    1              0.000010 au BufNewFile,BufRead *.ld			setf ld
                            
                            " Less
    1              0.000012 au BufNewFile,BufRead *.less			setf less
                            
                            " Lex
    1              0.000037 au BufNewFile,BufRead *.lex,*.l,*.lxx,*.l++	setf lex
                            
                            " Libao
    1              0.000023 au BufNewFile,BufRead */etc/libao.conf,*/.libao	setf libao
                            
                            " Libsensors
    1              0.000024 au BufNewFile,BufRead */etc/sensors.conf,*/etc/sensors3.conf	setf sensors
                            
                            " LFTP
    1              0.000031 au BufNewFile,BufRead lftp.conf,.lftprc,*lftp/rc	setf lftp
                            
                            " Lifelines (or Lex for C++!)
    1              0.000011 au BufNewFile,BufRead *.ll			setf lifelines
                            
                            " Lilo: Linux loader
    1              0.000011 au BufNewFile,BufRead lilo.conf			setf lilo
                            
                            " Lisp (*.el = ELisp, *.cl = Common Lisp, *.jl = librep Lisp)
    1              0.000003 if has("fname_case")
    1              0.000077   au BufNewFile,BufRead *.lsp,*.lisp,*.el,*.cl,*.jl,*.L,.emacs,.sawfishrc setf lisp
    1              0.000001 else
                              au BufNewFile,BufRead *.lsp,*.lisp,*.el,*.cl,*.jl,.emacs,.sawfishrc setf lisp
                            endif
                            
                            " SBCL implementation of Common Lisp
    1              0.000021 au BufNewFile,BufRead sbclrc,.sbclrc		setf lisp
                            
                            " Liquid
    1              0.000013 au BufNewFile,BufRead *.liquid			setf liquid
                            
                            " Lite
    1              0.000020 au BufNewFile,BufRead *.lite,*.lt		setf lite
                            
                            " LiteStep RC files
    1              0.000014 au BufNewFile,BufRead */LiteStep/*/*.rc		setf litestep
                            
                            " Login access
    1              0.000014 au BufNewFile,BufRead */etc/login.access	setf loginaccess
                            
                            " Login defs
    1              0.000013 au BufNewFile,BufRead */etc/login.defs		setf logindefs
                            
                            " Logtalk
    1              0.000013 au BufNewFile,BufRead *.lgt			setf logtalk
                            
                            " LOTOS
    1              0.000020 au BufNewFile,BufRead *.lot,*.lotos		setf lotos
                            
                            " Lout (also: *.lt)
    1              0.000022 au BufNewFile,BufRead *.lou,*.lout		setf lout
                            
                            " Lua
    1              0.000011 au BufNewFile,BufRead *.lua			setf lua
                            
                            " Luarocks
    1              0.000022 au BufNewFile,BufRead *.rockspec		setf lua
                            
                            " Linden Scripting Language (Second Life)
    1              0.000014 au BufNewFile,BufRead *.lsl			setf lsl
                            
                            " Lynx style file (or LotusScript!)
    1              0.000011 au BufNewFile,BufRead *.lss			setf lss
                            
                            " M4
    1              0.000013 au BufNewFile,BufRead *.m4
                            	\ if expand("<afile>") !~? 'html.m4$\|fvwm2rc' | setf m4 | endif
                            
                            " MaGic Point
    1              0.000017 au BufNewFile,BufRead *.mgp			setf mgp
                            
                            " Mail (for Elm, trn, mutt, muttng, rn, slrn)
    1              0.000134 au BufNewFile,BufRead snd.\d\+,.letter,.letter.\d\+,.followup,.article,.article.\d\+,pico.\d\+,mutt{ng,}-*-\w\+,mutt[[:alnum:]_-]\\\{6\},ae\d\+.txt,/tmp/SLRN[0-9A-Z.]\+,*.eml setf mail
                            
                            " Mail aliases
    1              0.000026 au BufNewFile,BufRead */etc/mail/aliases,*/etc/aliases	setf mailaliases
                            
                            " Mailcap configuration file
    1              0.000022 au BufNewFile,BufRead .mailcap,mailcap		setf mailcap
                            
                            " Makefile
    1              0.000043 au BufNewFile,BufRead *[mM]akefile,*.mk,*.mak,*.dsp setf make
                            
                            " MakeIndex
    1              0.000024 au BufNewFile,BufRead *.ist,*.mst		setf ist
                            
                            " Mallard
    1              0.000013 au BufNewFile,BufRead *.page			setf mallard
                            
                            " Manpage
    1              0.000011 au BufNewFile,BufRead *.man			setf man
                            
                            " Man config
    1              0.000025 au BufNewFile,BufRead */etc/man.conf,man.config	setf manconf
                            
                            " Maple V
    1              0.000032 au BufNewFile,BufRead *.mv,*.mpl,*.mws		setf maple
                            
                            " Map (UMN mapserver config file)
    1              0.000013 au BufNewFile,BufRead *.map			setf map
                            
                            " Markdown
    1              0.000063 au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md  setf markdown
                            
                            " Mason
    1              0.000033 au BufNewFile,BufRead *.mason,*.mhtml,*.comp	setf mason
                            
                            " Matlab or Objective C
    1              0.000012 au BufNewFile,BufRead *.m			call s:FTm()
                            
    1              0.000002 func! s:FTm()
                              let n = 1
                              while n < 10
                                let line = getline(n)
                                if line =~ '^\s*\(#\s*\(include\|import\)\>\|/\*\|//\)'
                                  setf objc
                                  return
                                endif
                                if line =~ '^\s*%'
                                  setf matlab
                                  return
                                endif
                                if line =~ '^\s*(\*'
                                  setf mma
                                  return
                                endif
                                let n = n + 1
                              endwhile
                              if exists("g:filetype_m")
                                exe "setf " . g:filetype_m
                              else
                                setf matlab
                              endif
                            endfunc
                            
                            " Mathematica notebook
    1              0.000016 au BufNewFile,BufRead *.nb			setf mma
                            
                            " Maya Extension Language
    1              0.000014 au BufNewFile,BufRead *.mel			setf mel
                            
                            " Mercurial (hg) commit file
    1              0.000014 au BufNewFile,BufRead hg-editor-*.txt		setf hgcommit
                            
                            " Mercurial config (looks like generic config file)
    1              0.000026 au BufNewFile,BufRead *.hgrc,*hgrc		setf cfg
                            
                            " Messages (logs mostly)
    1              0.000027 au BufNewFile,BufRead */log/{auth,cron,daemon,debug,kern,lpr,mail,messages,news/news,syslog,user}{,.log,.err,.info,.warn,.crit,.notice}{,.[0-9]*,-[0-9]*} setf messages
                            
                            " Metafont
    1              0.000012 au BufNewFile,BufRead *.mf			setf mf
                            
                            " MetaPost
    1              0.000013 au BufNewFile,BufRead *.mp			setf mp
                            
                            " MGL
    1              0.000015 au BufNewFile,BufRead *.mgl			setf mgl
                            
                            " MIX - Knuth assembly
    1              0.000022 au BufNewFile,BufRead *.mix,*.mixal		setf mix
                            
                            " MMIX or VMS makefile
    1              0.000014 au BufNewFile,BufRead *.mms			call s:FTmms()
                            
                            " Symbian meta-makefile definition (MMP)
    1              0.000014 au BufNewFile,BufRead *.mmp			setf mmp
                            
    1              0.000002 func! s:FTmms()
                              let n = 1
                              while n < 10
                                let line = getline(n)
                                if line =~ '^\s*\(%\|//\)' || line =~ '^\*'
                                  setf mmix
                                  return
                                endif
                                if line =~ '^\s*#'
                                  setf make
                                  return
                                endif
                                let n = n + 1
                              endwhile
                              setf mmix
                            endfunc
                            
                            
                            " Modsim III (or LambdaProlog)
    1              0.000016 au BufNewFile,BufRead *.mod
                            	\ if getline(1) =~ '\<module\>' |
                            	\   setf lprolog |
                            	\ else |
                            	\   setf modsim3 |
                            	\ endif
                            
                            " Modula 2  (.md removed in favor of Markdown)
    1              0.000043 au BufNewFile,BufRead *.m2,*.DEF,*.MOD,*.mi	setf modula2
                            
                            " Modula 3 (.m3, .i3, .mg, .ig)
    1              0.000017 au BufNewFile,BufRead *.[mi][3g]		setf modula3
                            
                            " Monk
    1              0.000046 au BufNewFile,BufRead *.isc,*.monk,*.ssc,*.tsc	setf monk
                            
                            " MOO
    1              0.000014 au BufNewFile,BufRead *.moo			setf moo
                            
                            " Modconf
    1              0.000047 au BufNewFile,BufRead */etc/modules.conf,*/etc/modules,*/etc/conf.modules setf modconf
                            
                            " Mplayer config
    1              0.000028 au BufNewFile,BufRead mplayer.conf,*/.mplayer/config	setf mplayerconf
                            
                            " Motorola S record
    1              0.000055 au BufNewFile,BufRead *.s19,*.s28,*.s37,*.mot,*.srec	setf srec
                            
                            " Mrxvtrc
    1              0.000024 au BufNewFile,BufRead mrxvtrc,.mrxvtrc		setf mrxvtrc
                            
                            " Msql
    1              0.000015 au BufNewFile,BufRead *.msql			setf msql
                            
                            " Mysql
    1              0.000013 au BufNewFile,BufRead *.mysql			setf mysql
                            
                            " Mutt setup files (must be before catch *.rc)
    1              0.000016 au BufNewFile,BufRead */etc/Muttrc.d/*		call s:StarSetf('muttrc')
                            
                            " M$ Resource files
    1              0.000025 au BufNewFile,BufRead *.rc,*.rch		setf rc
                            
                            " MuPAD source
    1              0.000014 au BufRead,BufNewFile *.mu			setf mupad
                            
                            " Mush
    1              0.000012 au BufNewFile,BufRead *.mush			setf mush
                            
                            " Mutt setup file (also for Muttng)
    1              0.000016 au BufNewFile,BufRead Mutt{ng,}rc		setf muttrc
                            
                            " Nano
    1              0.000026 au BufNewFile,BufRead */etc/nanorc,*.nanorc  	setf nanorc
                            
                            " Nastran input/DMAP
                            "au BufNewFile,BufRead *.dat			setf nastran
                            
                            " Natural
    1              0.000014 au BufNewFile,BufRead *.NS[ACGLMNPS]		setf natural
                            
                            " Netrc
    1              0.000013 au BufNewFile,BufRead .netrc			setf netrc
                            
                            " Ninja file
    1              0.000015 au BufNewFile,BufRead *.ninja			setf ninja
                            
                            " Novell netware batch files
    1              0.000015 au BufNewFile,BufRead *.ncf			setf ncf
                            
                            " Nroff/Troff (*.ms and *.t are checked below)
    1              0.000019 au BufNewFile,BufRead *.me
                            	\ if expand("<afile>") != "read.me" && expand("<afile>") != "click.me" |
                            	\   setf nroff |
                            	\ endif
    1              0.000058 au BufNewFile,BufRead *.tr,*.nr,*.roff,*.tmac,*.mom	setf nroff
    1              0.000016 au BufNewFile,BufRead *.[1-9]			call s:FTnroff()
                            
                            " This function checks if one of the first five lines start with a dot.  In
                            " that case it is probably an nroff file: 'filetype' is set and 1 is returned.
    1              0.000002 func! s:FTnroff()
                              if getline(1)[0] . getline(2)[0] . getline(3)[0] . getline(4)[0] . getline(5)[0] =~ '\.'
                                setf nroff
                                return 1
                              endif
                              return 0
                            endfunc
                            
                            " Nroff or Objective C++
    1              0.000014 au BufNewFile,BufRead *.mm			call s:FTmm()
                            
    1              0.000001 func! s:FTmm()
                              let n = 1
                              while n < 10
                                let line = getline(n)
                                if line =~ '^\s*\(#\s*\(include\|import\)\>\|/\*\)'
                                  setf objcpp
                                  return
                                endif
                                let n = n + 1
                              endwhile
                              setf nroff
                            endfunc
                            
                            " Not Quite C
    1              0.000017 au BufNewFile,BufRead *.nqc			setf nqc
                            
                            " NSIS
    1              0.000027 au BufNewFile,BufRead *.nsi,*.nsh		setf nsis
                            
                            " OCAML
    1              0.000072 au BufNewFile,BufRead *.ml,*.mli,*.mll,*.mly,.ocamlinit	setf ocaml
                            
                            " Occam
    1              0.000016 au BufNewFile,BufRead *.occ			setf occam
                            
                            " Omnimark
    1              0.000022 au BufNewFile,BufRead *.xom,*.xin		setf omnimark
                            
                            " OpenROAD
    1              0.000015 au BufNewFile,BufRead *.or			setf openroad
                            
                            " OPL
    1              0.000015 au BufNewFile,BufRead *.[Oo][Pp][Ll]		setf opl
                            
                            " Oracle config file
    1              0.000014 au BufNewFile,BufRead *.ora			setf ora
                            
                            " Packet filter conf
    1              0.000015 au BufNewFile,BufRead pf.conf			setf pf
                            
                            " Pam conf
    1              0.000014 au BufNewFile,BufRead */etc/pam.conf		setf pamconf
                            
                            " PApp
    1              0.000033 au BufNewFile,BufRead *.papp,*.pxml,*.pxsl	setf papp
                            
                            " Password file
    1              0.000095 au BufNewFile,BufRead */etc/passwd,*/etc/passwd-,*/etc/passwd.edit,*/etc/shadow,*/etc/shadow-,*/etc/shadow.edit,*/var/backups/passwd.bak,*/var/backups/shadow.bak setf passwd
                            
                            " Pascal (also *.p)
    1              0.000017 au BufNewFile,BufRead *.pas			setf pascal
                            
                            " Delphi project file
    1              0.000015 au BufNewFile,BufRead *.dpr			setf pascal
                            
                            " PDF
    1              0.000014 au BufNewFile,BufRead *.pdf			setf pdf
                            
                            " Perl
    1              0.000002 if has("fname_case")
    1              0.000027   au BufNewFile,BufRead *.pl,*.PL		call s:FTpl()
    1              0.000001 else
                              au BufNewFile,BufRead *.pl			call s:FTpl()
                            endif
    1              0.000025 au BufNewFile,BufRead *.plx,*.al		setf perl
    1              0.000036 au BufNewFile,BufRead *.p6,*.pm6,*.pl6	setf perl6
                            
    1              0.000002 func! s:FTpl()
                              if exists("g:filetype_pl")
                                exe "setf " . g:filetype_pl
                              else
                                " recognize Prolog by specific text in the first non-empty line
                                " require a blank after the '%' because Perl uses "%list" and "%translate"
                                let l = getline(nextnonblank(1))
                                if l =~ '\<prolog\>' || l =~ '^\s*\(%\+\(\s\|$\)\|/\*\)' || l =~ ':-'
                                  setf prolog
                                else
                                  setf perl
                                endif
                              endif
                            endfunc
                            
                            " Perl, XPM or XPM2
    1              0.000020 au BufNewFile,BufRead *.pm
                            	\ if getline(1) =~ "XPM2" |
                            	\   setf xpm2 |
                            	\ elseif getline(1) =~ "XPM" |
                            	\   setf xpm |
                            	\ else |
                            	\   setf perl |
                            	\ endif
                            
                            " Perl POD
    1              0.000016 au BufNewFile,BufRead *.pod			setf pod
    1              0.000014 au BufNewFile,BufRead *.pod6		setf pod6
                            
                            " Php, php3, php4, etc.
                            " Also Phtml (was used for PHP 2 in the past)
                            " Also .ctp for Cake template file
    1              0.000047 au BufNewFile,BufRead *.php,*.php\d,*.phtml,*.ctp	setf php
                            
                            " Pike
    1              0.000047 au BufNewFile,BufRead *.pike,*.lpc,*.ulpc,*.pmod setf pike
                            
                            " Pinfo config
    1              0.000028 au BufNewFile,BufRead */etc/pinforc,*/.pinforc	setf pinfo
                            
                            " Palm Resource compiler
    1              0.000015 au BufNewFile,BufRead *.rcp			setf pilrc
                            
                            " Pine config
    1              0.000052 au BufNewFile,BufRead .pinerc,pinerc,.pinercex,pinercex		setf pine
                            
                            " PL/1, PL/I
    1              0.000026 au BufNewFile,BufRead *.pli,*.pl1		setf pli
                            
                            " PL/M (also: *.inp)
    1              0.000037 au BufNewFile,BufRead *.plm,*.p36,*.pac		setf plm
                            
                            " PL/SQL
    1              0.000027 au BufNewFile,BufRead *.pls,*.plsql		setf plsql
                            
                            " PLP
    1              0.000016 au BufNewFile,BufRead *.plp			setf plp
                            
                            " PO and PO template (GNU gettext)
    1              0.000028 au BufNewFile,BufRead *.po,*.pot		setf po
                            
                            " Postfix main config
    1              0.000018 au BufNewFile,BufRead main.cf			setf pfmain
                            
                            " PostScript (+ font files, encapsulated PostScript, Adobe Illustrator)
    1              0.000083 au BufNewFile,BufRead *.ps,*.pfa,*.afm,*.eps,*.epsf,*.epsi,*.ai	  setf postscr
                            
                            " PostScript Printer Description
    1              0.000017 au BufNewFile,BufRead *.ppd			setf ppd
                            
                            " Povray
    1              0.000016 au BufNewFile,BufRead *.pov			setf pov
                            
                            " Povray configuration
    1              0.000015 au BufNewFile,BufRead .povrayrc			setf povini
                            
                            " Povray, PHP or assembly
    1              0.000020 au BufNewFile,BufRead *.inc			call s:FTinc()
                            
    1              0.000002 func! s:FTinc()
                              if exists("g:filetype_inc")
                                exe "setf " . g:filetype_inc
                              else
                                let lines = getline(1).getline(2).getline(3)
                                if lines =~? "perlscript"
                                  setf aspperl
                                elseif lines =~ "<%"
                                  setf aspvbs
                                elseif lines =~ "<?"
                                  setf php
                                else
                                  call s:FTasmsyntax()
                                  if exists("b:asmsyntax")
                            	exe "setf " . fnameescape(b:asmsyntax)
                                  else
                            	setf pov
                                  endif
                                endif
                              endif
                            endfunc
                            
                            " Printcap and Termcap
    1              0.000019 au BufNewFile,BufRead *printcap
                            	\ let b:ptcap_type = "print" | setf ptcap
    1              0.000018 au BufNewFile,BufRead *termcap
                            	\ let b:ptcap_type = "term" | setf ptcap
                            
                            " PCCTS / ANTRL
                            "au BufNewFile,BufRead *.g			setf antrl
    1              0.000016 au BufNewFile,BufRead *.g			setf pccts
                            
                            " PPWizard
    1              0.000025 au BufNewFile,BufRead *.it,*.ih			setf ppwiz
                            
                            " Obj 3D file format
                            " TODO: is there a way to avoid MS-Windows Object files?
    1              0.000018 au BufNewFile,BufRead *.obj			setf obj
                            
                            " Oracle Pro*C/C++
    1              0.000017 au BufNewFile,BufRead *.pc			setf proc
                            
                            " Privoxy actions file
    1              0.000015 au BufNewFile,BufRead *.action			setf privoxy
                            
                            " Procmail
    1              0.000027 au BufNewFile,BufRead .procmail,.procmailrc	setf procmail
                            
                            " Progress or CWEB
    1              0.000015 au BufNewFile,BufRead *.w			call s:FTprogress_cweb()
                            
    1              0.000002 func! s:FTprogress_cweb()
                              if exists("g:filetype_w")
                                exe "setf " . g:filetype_w
                                return
                              endif
                              if getline(1) =~ '&ANALYZE' || getline(3) =~ '&GLOBAL-DEFINE'
                                setf progress
                              else
                                setf cweb
                              endif
                            endfunc
                            
                            " Progress or assembly
    1              0.000016 au BufNewFile,BufRead *.i			call s:FTprogress_asm()
                            
    1              0.000001 func! s:FTprogress_asm()
                              if exists("g:filetype_i")
                                exe "setf " . g:filetype_i
                                return
                              endif
                              " This function checks for an assembly comment the first ten lines.
                              " If not found, assume Progress.
                              let lnum = 1
                              while lnum <= 10 && lnum < line('$')
                                let line = getline(lnum)
                                if line =~ '^\s*;' || line =~ '^\*'
                                  call s:FTasm()
                                  return
                                elseif line !~ '^\s*$' || line =~ '^/\*'
                                  " Not an empty line: Doesn't look like valid assembly code.
                                  " Or it looks like a Progress /* comment
                                  break
                                endif
                                let lnum = lnum + 1
                              endw
                              setf progress
                            endfunc
                            
                            " Progress or Pascal
    1              0.000016 au BufNewFile,BufRead *.p			call s:FTprogress_pascal()
                            
    1              0.000001 func! s:FTprogress_pascal()
                              if exists("g:filetype_p")
                                exe "setf " . g:filetype_p
                                return
                              endif
                              " This function checks for valid Pascal syntax in the first ten lines.
                              " Look for either an opening comment or a program start.
                              " If not found, assume Progress.
                              let lnum = 1
                              while lnum <= 10 && lnum < line('$')
                                let line = getline(lnum)
                                if line =~ '^\s*\(program\|unit\|procedure\|function\|const\|type\|var\)\>'
                            	\ || line =~ '^\s*{' || line =~ '^\s*(\*'
                                  setf pascal
                                  return
                                elseif line !~ '^\s*$' || line =~ '^/\*'
                                  " Not an empty line: Doesn't look like valid Pascal code.
                                  " Or it looks like a Progress /* comment
                                  break
                                endif
                                let lnum = lnum + 1
                              endw
                              setf progress
                            endfunc
                            
                            
                            " Software Distributor Product Specification File (POSIX 1387.2-1995)
    1              0.000022 au BufNewFile,BufRead *.psf			setf psf
    1              0.000032 au BufNewFile,BufRead INDEX,INFO
                            	\ if getline(1) =~ '^\s*\(distribution\|installed_software\|root\|bundle\|product\)\s*$' |
                            	\   setf psf |
                            	\ endif
                            
                            " Prolog
    1              0.000020 au BufNewFile,BufRead *.pdb			setf prolog
                            
                            " Promela
    1              0.000019 au BufNewFile,BufRead *.pml			setf promela
                            
                            " Google protocol buffers
    1              0.000017 au BufNewFile,BufRead *.proto			setf proto
                            
                            " Protocols
    1              0.000017 au BufNewFile,BufRead */etc/protocols		setf protocols
                            
                            " Pyrex
    1              0.000030 au BufNewFile,BufRead *.pyx,*.pxd		setf pyrex
                            
                            " Python
    1              0.000029 au BufNewFile,BufRead *.py,*.pyw		setf python
                            
                            " Quixote (Python-based web framework)
    1              0.000019 au BufNewFile,BufRead *.ptl			setf python
                            
                            " Radiance
    1              0.000030 au BufNewFile,BufRead *.rad,*.mat		setf radiance
                            
                            " Ratpoison config/command files
    1              0.000031 au BufNewFile,BufRead .ratpoisonrc,ratpoisonrc	setf ratpoison
                            
                            " RCS file
    1              0.000016 au BufNewFile,BufRead *\,v			setf rcs
                            
                            " Readline
    1              0.000029 au BufNewFile,BufRead .inputrc,inputrc		setf readline
                            
                            " Registry for MS-Windows
    1              0.000020 au BufNewFile,BufRead *.reg
                            	\ if getline(1) =~? '^REGEDIT[0-9]*\s*$\|^Windows Registry Editor Version \d*\.\d*\s*$' | setf registry | endif
                            
                            " Renderman Interface Bytestream
    1              0.000019 au BufNewFile,BufRead *.rib			setf rib
                            
                            " Rexx
    1              0.000110 au BufNewFile,BufRead *.rex,*.orx,*.rxo,*.rxj,*.jrexx,*.rexxj,*.rexx,*.testGroup,*.testUnit	setf rexx
                            
                            " R (Splus)
    1              0.000002 if has("fname_case")
    1              0.000030   au BufNewFile,BufRead *.s,*.S			setf r
    1              0.000001 else
                              au BufNewFile,BufRead *.s			setf r
                            endif
                            
                            " R Help file
    1              0.000002 if has("fname_case")
    1              0.000028   au BufNewFile,BufRead *.rd,*.Rd		setf rhelp
    1              0.000001 else
                              au BufNewFile,BufRead *.rd			setf rhelp
                            endif
                            
                            " R noweb file
    1              0.000002 if has("fname_case")
    1              0.000056   au BufNewFile,BufRead *.Rnw,*.rnw,*.Snw,*.snw		setf rnoweb
    1              0.000001 else
                              au BufNewFile,BufRead *.rnw,*.snw			setf rnoweb
                            endif
                            
                            " R Markdown file
    1              0.000002 if has("fname_case")
    1              0.000056   au BufNewFile,BufRead *.Rmd,*.rmd,*.Smd,*.smd		setf rmd
    1              0.000001 else
                              au BufNewFile,BufRead *.rmd,*.smd			setf rmd
                            endif
                            
                            " R reStructuredText file
    1              0.000002 if has("fname_case")
    1              0.000054   au BufNewFile,BufRead *.Rrst,*.rrst,*.Srst,*.srst	setf rrst
    1              0.000001 else
                              au BufNewFile,BufRead *.rrst,*.srst			setf rrst
                            endif
                            
                            " Rexx, Rebol or R
    1              0.000029 au BufNewFile,BufRead *.r,*.R			call s:FTr()
                            
    1              0.000001 func! s:FTr()
                              let max = line("$") > 50 ? 50 : line("$")
                            
                              for n in range(1, max)
                                " Rebol is easy to recognize, check for that first
                                if getline(n) =~? '\<REBOL\>'
                                  setf rebol
                                  return
                                endif
                              endfor
                            
                              for n in range(1, max)
                                " R has # comments
                                if getline(n) =~ '^\s*#'
                                  setf r
                                  return
                                endif
                                " Rexx has /* comments */
                                if getline(n) =~ '^\s*/\*'
                                  setf rexx
                                  return
                                endif
                              endfor
                            
                              " Nothing recognized, use user default or assume Rexx
                              if exists("g:filetype_r")
                                exe "setf " . g:filetype_r
                              else
                                " Rexx used to be the default, but R appears to be much more popular.
                                setf r
                              endif
                            endfunc
                            
                            " Remind
    1              0.000049 au BufNewFile,BufRead .reminders,*.remind,*.rem		setf remind
                            
                            " Resolv.conf
    1              0.000020 au BufNewFile,BufRead resolv.conf		setf resolv
                            
                            " Relax NG Compact
    1              0.000019 au BufNewFile,BufRead *.rnc			setf rnc
                            
                            " Relax NG XML
    1              0.000018 au BufNewFile,BufRead *.rng			setf rng
                            
                            " RPL/2
    1              0.000018 au BufNewFile,BufRead *.rpl			setf rpl
                            
                            " Robots.txt
    1              0.000021 au BufNewFile,BufRead robots.txt		setf robots
                            
                            " Rpcgen
    1              0.000017 au BufNewFile,BufRead *.x			setf rpcgen
                            
                            " reStructuredText Documentation Format
    1              0.000020 au BufNewFile,BufRead *.rst			setf rst
                            
                            " RTF
    1              0.000022 au BufNewFile,BufRead *.rtf			setf rtf
                            
                            " Interactive Ruby shell
    1              0.000035 au BufNewFile,BufRead .irbrc,irbrc		setf ruby
                            
                            " Ruby
    1              0.000031 au BufNewFile,BufRead *.rb,*.rbw		setf ruby
                            
                            " RubyGems
    1              0.000020 au BufNewFile,BufRead *.gemspec			setf ruby
                            
                            " Rackup
    1              0.000018 au BufNewFile,BufRead *.ru			setf ruby
                            
                            " Bundler
    1              0.000017 au BufNewFile,BufRead Gemfile			setf ruby
                            
                            " Ruby on Rails
    1              0.000043 au BufNewFile,BufRead *.builder,*.rxml,*.rjs	setf ruby
                            
                            " Rantfile and Rakefile is like Ruby
    1              0.000060 au BufNewFile,BufRead [rR]antfile,*.rant,[rR]akefile,*.rake	setf ruby
                            
                            " S-lang (or shader language, or SmallLisp)
    1              0.000018 au BufNewFile,BufRead *.sl			setf slang
                            
                            " Samba config
    1              0.000017 au BufNewFile,BufRead smb.conf			setf samba
                            
                            " SAS script
    1              0.000020 au BufNewFile,BufRead *.sas			setf sas
                            
                            " Sass
    1              0.000021 au BufNewFile,BufRead *.sass			setf sass
                            
                            " Sather
    1              0.000018 au BufNewFile,BufRead *.sa			setf sather
                            
                            " Scilab
    1              0.000033 au BufNewFile,BufRead *.sci,*.sce		setf scilab
                            
                            " SCSS
    1              0.000019 au BufNewFile,BufRead *.scss			setf scss
                            
                            " SD: Streaming Descriptors
    1              0.000017 au BufNewFile,BufRead *.sd			setf sd
                            
                            " SDL
    1              0.000032 au BufNewFile,BufRead *.sdl,*.pr		setf sdl
                            
                            " sed
    1              0.000020 au BufNewFile,BufRead *.sed			setf sed
                            
                            " Sieve (RFC 3028)
    1              0.000020 au BufNewFile,BufRead *.siv			setf sieve
                            
                            " Sendmail
    1              0.000023 au BufNewFile,BufRead sendmail.cf		setf sm
                            
                            " Sendmail .mc files are actually m4.  Could also be MS Message text file.
    1              0.000019 au BufNewFile,BufRead *.mc			call s:McSetf()
                            
    1              0.000001 func! s:McSetf()
                              " Rely on the file to start with a comment.
                              " MS message text files use ';', Sendmail files use '#' or 'dnl'
                              for lnum in range(1, min([line("$"), 20]))
                                let line = getline(lnum)
                                if line =~ '^\s*\(#\|dnl\)'
                                  setf m4  " Sendmail .mc file
                                  return
                                elseif line =~ '^\s*;'
                                  setf msmessages  " MS Message text file
                                  return
                                endif
                              endfor
                              setf m4  " Default: Sendmail .mc file
                            endfunc
                            
                            " Services
    1              0.000020 au BufNewFile,BufRead */etc/services		setf services
                            
                            " Service Location config
    1              0.000020 au BufNewFile,BufRead */etc/slp.conf		setf slpconf
                            
                            " Service Location registration
    1              0.000021 au BufNewFile,BufRead */etc/slp.reg		setf slpreg
                            
                            " Service Location SPI
    1              0.000019 au BufNewFile,BufRead */etc/slp.spi		setf slpspi
                            
                            " Setserial config
    1              0.000021 au BufNewFile,BufRead */etc/serial.conf		setf setserial
                            
                            " SGML
    1              0.000038 au BufNewFile,BufRead *.sgm,*.sgml
                            	\ if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'linuxdoc' |
                            	\   setf sgmllnx |
                            	\ elseif getline(1) =~ '<!DOCTYPE.*DocBook' || getline(2) =~ '<!DOCTYPE.*DocBook' |
                            	\   let b:docbk_type = "sgml" |
                            	\   let b:docbk_ver = 4 |
                            	\   setf docbk |
                            	\ else |
                            	\   setf sgml |
                            	\ endif
                            
                            " SGMLDECL
    1              0.000050 au BufNewFile,BufRead *.decl,*.dcl,*.dec
                            	\ if getline(1).getline(2).getline(3) =~? '^<!SGML' |
                            	\    setf sgmldecl |
                            	\ endif
                            
                            " SGML catalog file
    1              0.000019 au BufNewFile,BufRead catalog			setf catalog
    1              0.000019 au BufNewFile,BufRead sgml.catalog*		call s:StarSetf('catalog')
                            
                            " Shell scripts (sh, ksh, bash, bash2, csh); Allow .profile_foo etc.
                            " Gentoo ebuilds and Arch Linux PKGBUILDs are actually bash scripts
    1              0.000123 au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash_profile*,.bash_logout*,.bash_aliases*,*.bash,*.ebuild,PKGBUILD* call SetFileTypeSH("bash")
    1              0.000035 au BufNewFile,BufRead .kshrc*,*.ksh call SetFileTypeSH("ksh")
    1              0.000062 au BufNewFile,BufRead */etc/profile,.profile*,*.sh,*.env call SetFileTypeSH(getline(1))
                            
                            " Shell script (Arch Linux) or PHP file (Drupal)
    1              0.000021 au BufNewFile,BufRead *.install
                            	\ if getline(1) =~ '<?php' |
                            	\   setf php |
                            	\ else |
                            	\   call SetFileTypeSH("bash") |
                            	\ endif
                            
                            " Also called from scripts.vim.
    1              0.000002 func! SetFileTypeSH(name)
                              if expand("<amatch>") =~ g:ft_ignore_pat
                                return
                              endif
                              if a:name =~ '\<csh\>'
                                " Some .sh scripts contain #!/bin/csh.
                                call SetFileTypeShell("csh")
                                return
                              elseif a:name =~ '\<tcsh\>'
                                " Some .sh scripts contain #!/bin/tcsh.
                                call SetFileTypeShell("tcsh")
                                return
                              elseif a:name =~ '\<zsh\>'
                                " Some .sh scripts contain #!/bin/zsh.
                                call SetFileTypeShell("zsh")
                                return
                              elseif a:name =~ '\<ksh\>'
                                let b:is_kornshell = 1
                                if exists("b:is_bash")
                                  unlet b:is_bash
                                endif
                                if exists("b:is_sh")
                                  unlet b:is_sh
                                endif
                              elseif exists("g:bash_is_sh") || a:name =~ '\<bash\>' || a:name =~ '\<bash2\>'
                                let b:is_bash = 1
                                if exists("b:is_kornshell")
                                  unlet b:is_kornshell
                                endif
                                if exists("b:is_sh")
                                  unlet b:is_sh
                                endif
                              elseif a:name =~ '\<sh\>'
                                let b:is_sh = 1
                                if exists("b:is_kornshell")
                                  unlet b:is_kornshell
                                endif
                                if exists("b:is_bash")
                                  unlet b:is_bash
                                endif
                              endif
                              call SetFileTypeShell("sh")
                            endfunc
                            
                            " For shell-like file types, check for an "exec" command hidden in a comment,
                            " as used for Tcl.
                            " Also called from scripts.vim, thus can't be local to this script.
    1              0.000001 func! SetFileTypeShell(name)
                              if expand("<amatch>") =~ g:ft_ignore_pat
                                return
                              endif
                              let l = 2
                              while l < 20 && l < line("$") && getline(l) =~ '^\s*\(#\|$\)'
                                " Skip empty and comment lines.
                                let l = l + 1
                              endwhile
                              if l < line("$") && getline(l) =~ '\s*exec\s' && getline(l - 1) =~ '^\s*#.*\\$'
                                " Found an "exec" line after a comment with continuation
                                let n = substitute(getline(l),'\s*exec\s\+\([^ ]*/\)\=', '', '')
                                if n =~ '\<tclsh\|\<wish'
                                  setf tcl
                                  return
                                endif
                              endif
                              exe "setf " . a:name
                            endfunc
                            
                            " tcsh scripts
    1              0.000062 au BufNewFile,BufRead .tcshrc*,*.tcsh,tcsh.tcshrc,tcsh.login	call SetFileTypeShell("tcsh")
                            
                            " csh scripts, but might also be tcsh scripts (on some systems csh is tcsh)
    1              0.000102 au BufNewFile,BufRead .login*,.cshrc*,csh.cshrc,csh.login,csh.logout,*.csh,.alias  call s:CSH()
                            
    1              0.000001 func! s:CSH()
                              if exists("g:filetype_csh")
                                call SetFileTypeShell(g:filetype_csh)
                              elseif &shell =~ "tcsh"
                                call SetFileTypeShell("tcsh")
                              else
                                call SetFileTypeShell("csh")
                              endif
                            endfunc
                            
                            " Z-Shell script
    1              0.000049 au BufNewFile,BufRead .zprofile,*/etc/zprofile,.zfbfmarks  setf zsh
    1              0.000049 au BufNewFile,BufRead .zsh*,.zlog*,.zcompdump*  call s:StarSetf('zsh')
    1              0.000023 au BufNewFile,BufRead *.zsh			setf zsh
                            
                            " Scheme
    1              0.000053 au BufNewFile,BufRead *.scm,*.ss,*.rkt		setf scheme
                            
                            " Screen RC
    1              0.000038 au BufNewFile,BufRead .screenrc,screenrc	setf screen
                            
                            " Simula
    1              0.000022 au BufNewFile,BufRead *.sim			setf simula
                            
                            " SINDA
    1              0.000034 au BufNewFile,BufRead *.sin,*.s85		setf sinda
                            
                            " SiSU
    1              0.000079 au BufNewFile,BufRead *.sst,*.ssm,*.ssi,*.-sst,*._sst setf sisu
    1              0.000048 au BufNewFile,BufRead *.sst.meta,*.-sst.meta,*._sst.meta setf sisu
                            
                            " SKILL
    1              0.000053 au BufNewFile,BufRead *.il,*.ils,*.cdf		setf skill
                            
                            " SLRN
    1              0.000021 au BufNewFile,BufRead .slrnrc			setf slrnrc
    1              0.000019 au BufNewFile,BufRead *.score			setf slrnsc
                            
                            " Smalltalk (and TeX)
    1              0.000020 au BufNewFile,BufRead *.st			setf st
    1              0.000030 au BufNewFile,BufRead *.cls
                            	\ if getline(1) =~ '^%' |
                            	\  setf tex |
                            	\ elseif getline(1)[0] == '#' && getline(1) =~ 'rexx' |
                            	\  setf rexx |
                            	\ else |
                            	\  setf st |
                            	\ endif
                            
                            " Smarty templates
    1              0.000023 au BufNewFile,BufRead *.tpl			setf smarty
                            
                            " SMIL or XML
    1              0.000023 au BufNewFile,BufRead *.smil
                            	\ if getline(1) =~ '<?\s*xml.*?>' |
                            	\   setf xml |
                            	\ else |
                            	\   setf smil |
                            	\ endif
                            
                            " SMIL or SNMP MIB file
    1              0.000027 au BufNewFile,BufRead *.smi
                            	\ if getline(1) =~ '\<smil\>' |
                            	\   setf smil |
                            	\ else |
                            	\   setf mib |
                            	\ endif
                            
                            " SMITH
    1              0.000035 au BufNewFile,BufRead *.smt,*.smith		setf smith
                            
                            " Snobol4 and spitbol
    1              0.000037 au BufNewFile,BufRead *.sno,*.spt		setf snobol4
                            
                            " SNMP MIB files
    1              0.000039 au BufNewFile,BufRead *.mib,*.my		setf mib
                            
                            " Snort Configuration
    1              0.000052 au BufNewFile,BufRead *.hog,snort.conf,vision.conf	setf hog
    1              0.000024 au BufNewFile,BufRead *.rules			call s:FTRules()
                            
    1              0.000003 let s:ft_rules_udev_rules_pattern = '^\s*\cudev_rules\s*=\s*"\([^"]\{-1,}\)/*".*'
    1              0.000001 func! s:FTRules()
                              let path = expand('<amatch>:p')
                              if path =~ '^/\(etc/udev/\%(rules\.d/\)\=.*\.rules\|lib/udev/\%(rules\.d/\)\=.*\.rules\)$'
                                setf udevrules
                                return
                              endif
                              if path =~ '^/etc/ufw/'
                                setf conf  " Better than hog
                                return
                              endif
                              if path =~ '^/\(etc\|usr/share\)/polkit-1/rules\.d'
                                setf javascript
                                return
                              endif
                              try
                                let config_lines = readfile('/etc/udev/udev.conf')
                              catch /^Vim\%((\a\+)\)\=:E484/
                                setf hog
                                return
                              endtry
                              let dir = expand('<amatch>:p:h')
                              for line in config_lines
                                if line =~ s:ft_rules_udev_rules_pattern
                                  let udev_rules = substitute(line, s:ft_rules_udev_rules_pattern, '\1', "")
                                  if dir == udev_rules
                                    setf udevrules
                                  endif
                                  break
                                endif
                              endfor
                              setf hog
                            endfunc
                            
                            
                            " Spec (Linux RPM)
    1              0.000024 au BufNewFile,BufRead *.spec			setf spec
                            
                            " Speedup (AspenTech plant simulator)
    1              0.000051 au BufNewFile,BufRead *.speedup,*.spdata,*.spd	setf spup
                            
                            " Slice
    1              0.000023 au BufNewFile,BufRead *.ice			setf slice
                            
                            " Spice
    1              0.000038 au BufNewFile,BufRead *.sp,*.spice		setf spice
                            
                            " Spyce
    1              0.000036 au BufNewFile,BufRead *.spy,*.spi		setf spyce
                            
                            " Squid
    1              0.000024 au BufNewFile,BufRead squid.conf		setf squid
                            
                            " SQL for Oracle Designer
    1              0.000081 au BufNewFile,BufRead *.tyb,*.typ,*.tyc,*.pkb,*.pks	setf sql
                            
                            " SQL
    1              0.000025 au BufNewFile,BufRead *.sql			call s:SQL()
                            
    1              0.000001 func! s:SQL()
                              if exists("g:filetype_sql")
                                exe "setf " . g:filetype_sql
                              else
                                setf sql
                              endif
                            endfunc
                            
                            " SQLJ
    1              0.000024 au BufNewFile,BufRead *.sqlj			setf sqlj
                            
                            " SQR
    1              0.000036 au BufNewFile,BufRead *.sqr,*.sqi		setf sqr
                            
                            " OpenSSH configuration
    1              0.000041 au BufNewFile,BufRead ssh_config,*/.ssh/config	setf sshconfig
                            
                            " OpenSSH server configuration
    1              0.000022 au BufNewFile,BufRead sshd_config		setf sshdconfig
                            
                            " Stata
    1              0.000090 au BufNewFile,BufRead *.ado,*.class,*.do,*.imata,*.mata   setf stata
                            
                            " SMCL
    1              0.000054 au BufNewFile,BufRead *.hlp,*.ihlp,*.smcl	setf smcl
                            
                            " Stored Procedures
    1              0.000024 au BufNewFile,BufRead *.stp			setf stp
                            
                            " Standard ML
    1              0.000026 au BufNewFile,BufRead *.sml			setf sml
                            
                            " Sratus VOS command macro
    1              0.000027 au BufNewFile,BufRead *.cm			setf voscm
                            
                            " Sysctl
    1              0.000038 au BufNewFile,BufRead */etc/sysctl.conf,*/etc/sysctl.d/*.conf	setf sysctl
                            
                            " Synopsys Design Constraints
    1              0.000023 au BufNewFile,BufRead *.sdc			setf sdc
                            
                            " Sudoers
    1              0.000039 au BufNewFile,BufRead */etc/sudoers,sudoers.tmp	setf sudoers
                            
                            " SVG (Scalable Vector Graphics)
    1              0.000023 au BufNewFile,BufRead *.svg			setf svg
                            
                            " If the file has an extension of 't' and is in a directory 't' or 'xt' then
                            " it is almost certainly a Perl test file.
                            " If the first line starts with '#' and contains 'perl' it's probably a Perl
                            " file.
                            " (Slow test) If a file contains a 'use' statement then it is almost certainly
                            " a Perl file.
    1              0.000001 func! s:FTperl()
                              let dirname = expand("%:p:h:t")
                              if expand("%:e") == 't' && (dirname == 't' || dirname == 'xt')
                                setf perl
                                return 1
                              endif
                              if getline(1)[0] == '#' && getline(1) =~ 'perl'
                                setf perl
                                return 1
                              endif
                              if search('^use\s\s*\k', 'nc', 30)
                                setf perl
                                return 1
                              endif
                              return 0
                            endfunc
                            
                            " Tads (or Nroff or Perl test file)
    1              0.000026 au BufNewFile,BufRead *.t
                            	\ if !s:FTnroff() && !s:FTperl() | setf tads | endif
                            
                            " Tags
    1              0.000021 au BufNewFile,BufRead tags			setf tags
                            
                            " TAK
    1              0.000023 au BufNewFile,BufRead *.tak			setf tak
                            
                            " Task
    1              0.000025 au BufRead,BufNewFile {pending,completed,undo}.data  setf taskdata
    1              0.000023 au BufRead,BufNewFile *.task			setf taskedit
                            
                            " Tcl (JACL too)
    1              0.000085 au BufNewFile,BufRead *.tcl,*.tk,*.itcl,*.itk,*.jacl	setf tcl
                            
                            " TealInfo
    1              0.000025 au BufNewFile,BufRead *.tli			setf tli
                            
                            " Telix Salt
    1              0.000026 au BufNewFile,BufRead *.slt			setf tsalt
                            
                            " Terminfo
    1              0.000026 au BufNewFile,BufRead *.ti			setf terminfo
                            
                            " TeX
    1              0.000088 au BufNewFile,BufRead *.latex,*.sty,*.dtx,*.ltx,*.bbl	setf tex
    1              0.000025 au BufNewFile,BufRead *.tex			call s:FTtex()
                            
                            " Choose context, plaintex, or tex (LaTeX) based on these rules:
                            " 1. Check the first line of the file for "%&<format>".
                            " 2. Check the first 1000 non-comment lines for LaTeX or ConTeXt keywords.
                            " 3. Default to "latex" or to g:tex_flavor, can be set in user's vimrc.
    1              0.000001 func! s:FTtex()
                              let firstline = getline(1)
                              if firstline =~ '^%&\s*\a\+'
                                let format = tolower(matchstr(firstline, '\a\+'))
                                let format = substitute(format, 'pdf', '', '')
                                if format == 'tex'
                                  let format = 'plain'
                                endif
                              else
                                " Default value, may be changed later:
                                let format = exists("g:tex_flavor") ? g:tex_flavor : 'plain'
                                " Save position, go to the top of the file, find first non-comment line.
                                let save_cursor = getpos('.')
                                call cursor(1,1)
                                let firstNC = search('^\s*[^[:space:]%]', 'c', 1000)
                                if firstNC " Check the next thousand lines for a LaTeX or ConTeXt keyword.
                                  let lpat = 'documentclass\>\|usepackage\>\|begin{\|newcommand\>\|renewcommand\>'
                                  let cpat = 'start\a\+\|setup\a\+\|usemodule\|enablemode\|enableregime\|setvariables\|useencoding\|usesymbols\|stelle\a\+\|verwende\a\+\|stel\a\+\|gebruik\a\+\|usa\a\+\|imposta\a\+\|regle\a\+\|utilisemodule\>'
                                  let kwline = search('^\s*\\\%(' . lpat . '\)\|^\s*\\\(' . cpat . '\)',
                            			      \ 'cnp', firstNC + 1000)
                                  if kwline == 1	" lpat matched
                            	let format = 'latex'
                                  elseif kwline == 2	" cpat matched
                            	let format = 'context'
                                  endif		" If neither matched, keep default set above.
                                  " let lline = search('^\s*\\\%(' . lpat . '\)', 'cn', firstNC + 1000)
                                  " let cline = search('^\s*\\\%(' . cpat . '\)', 'cn', firstNC + 1000)
                                  " if cline > 0
                                  "   let format = 'context'
                                  " endif
                                  " if lline > 0 && (cline == 0 || cline > lline)
                                  "   let format = 'tex'
                                  " endif
                                endif " firstNC
                                call setpos('.', save_cursor)
                              endif " firstline =~ '^%&\s*\a\+'
                            
                              " Translation from formats to file types.  TODO:  add AMSTeX, RevTex, others?
                              if format == 'plain'
                                setf plaintex
                              elseif format == 'context'
                                setf context
                              else " probably LaTeX
                                setf tex
                              endif
                              return
                            endfunc
                            
                            " ConTeXt
    1              0.000059 au BufNewFile,BufRead tex/context/*/*.tex,*.mkii,*.mkiv   setf context
                            
                            " Texinfo
    1              0.000055 au BufNewFile,BufRead *.texinfo,*.texi,*.txi	setf texinfo
                            
                            " TeX configuration
    1              0.000025 au BufNewFile,BufRead texmf.cnf			setf texmf
                            
                            " Tidy config
    1              0.000038 au BufNewFile,BufRead .tidyrc,tidyrc		setf tidy
                            
                            " TF mud client
    1              0.000056 au BufNewFile,BufRead *.tf,.tfrc,tfrc		setf tf
                            
                            " TPP - Text Presentation Program
    1              0.000028 au BufNewFile,BufReadPost *.tpp			setf tpp
                            
                            " Treetop
    1              0.000021 au BufRead,BufNewFile *.treetop			setf treetop
                            
                            " Trustees
    1              0.000021 au BufNewFile,BufRead trustees.conf		setf trustees
                            
                            " TSS - Geometry
    1              0.000024 au BufNewFile,BufReadPost *.tssgm		setf tssgm
                            
                            " TSS - Optics
    1              0.000021 au BufNewFile,BufReadPost *.tssop		setf tssop
                            
                            " TSS - Command Line (temporary)
    1              0.000021 au BufNewFile,BufReadPost *.tsscl		setf tsscl
                            
                            " Tutor mode
    1              0.000023 au BufNewFile,BufReadPost *.tutor		setf tutor
                            
                            " TWIG files
    1              0.000023 au BufNewFile,BufReadPost *.twig		setf twig
                            
                            " Motif UIT/UIL files
    1              0.000043 au BufNewFile,BufRead *.uit,*.uil		setf uil
                            
                            " Udev conf
    1              0.000027 au BufNewFile,BufRead */etc/udev/udev.conf	setf udevconf
                            
                            " Udev permissions
    1              0.000026 au BufNewFile,BufRead */etc/udev/permissions.d/*.permissions setf udevperm
                            "
                            " Udev symlinks config
    1              0.000023 au BufNewFile,BufRead */etc/udev/cdsymlinks.conf	setf sh
                            
                            " UnrealScript
    1              0.000023 au BufNewFile,BufRead *.uc			setf uc
                            
                            " Updatedb
    1              0.000025 au BufNewFile,BufRead */etc/updatedb.conf	setf updatedb
                            
                            " Upstart (init(8)) config files
    1              0.000026 au BufNewFile,BufRead */usr/share/upstart/*.conf	       setf upstart
    1              0.000024 au BufNewFile,BufRead */usr/share/upstart/*.override	       setf upstart
    1              0.000041 au BufNewFile,BufRead */etc/init/*.conf,*/etc/init/*.override  setf upstart
    1              0.000040 au BufNewFile,BufRead */.init/*.conf,*/.init/*.override        setf upstart
    1              0.000027 au BufNewFile,BufRead */.config/upstart/*.conf		       setf upstart
    1              0.000024 au BufNewFile,BufRead */.config/upstart/*.override	       setf upstart
                            
                            " Vera
    1              0.000061 au BufNewFile,BufRead *.vr,*.vri,*.vrh		setf vera
                            
                            " Verilog HDL
    1              0.000024 au BufNewFile,BufRead *.v			setf verilog
                            
                            " Verilog-AMS HDL
    1              0.000040 au BufNewFile,BufRead *.va,*.vams		setf verilogams
                            
                            " SystemVerilog
    1              0.000046 au BufNewFile,BufRead *.sv,*.svh		setf systemverilog
                            
                            " VHDL
    1              0.000097 au BufNewFile,BufRead *.hdl,*.vhd,*.vhdl,*.vbe,*.vst  setf vhdl
    1              0.000027 au BufNewFile,BufRead *.vhdl_[0-9]*		call s:StarSetf('vhdl')
                            
                            " Vim script
    1              0.000107 au BufNewFile,BufRead *.vim,*.vba,.exrc,_exrc	setf vim
                            
                            " Viminfo file
    1              0.000042 au BufNewFile,BufRead .viminfo,_viminfo		setf viminfo
                            
                            " Virata Config Script File or Drupal module
    1              0.000072 au BufRead,BufNewFile *.hw,*.module,*.pkg
                            	\ if getline(1) =~ '<?php' |
                            	\   setf php |
                            	\ else |
                            	\   setf virata |
                            	\ endif
                            
                            " Visual Basic (also uses *.bas) or FORM
    1              0.000026 au BufNewFile,BufRead *.frm			call s:FTVB("form")
                            
                            " SaxBasic is close to Visual Basic
    1              0.000028 au BufNewFile,BufRead *.sba			setf vb
                            
                            " Vgrindefs file
    1              0.000029 au BufNewFile,BufRead vgrindefs			setf vgrindefs
                            
                            " VRML V1.0c
    1              0.000027 au BufNewFile,BufRead *.wrl			setf vrml
                            
                            " Vroom (vim testing and executable documentation)
    1              0.000029 au BufNewFile,BufRead *.vroom			setf vroom
                            
                            " Webmacro
    1              0.000026 au BufNewFile,BufRead *.wm			setf webmacro
                            
                            " Wget config
    1              0.000043 au BufNewFile,BufRead .wgetrc,wgetrc		setf wget
                            
                            " Website MetaLanguage
    1              0.000028 au BufNewFile,BufRead *.wml			setf wml
                            
                            " Winbatch
    1              0.000027 au BufNewFile,BufRead *.wbt			setf winbatch
                            
                            " WSML
    1              0.000028 au BufNewFile,BufRead *.wsml			setf wsml
                            
                            " WvDial
    1              0.000042 au BufNewFile,BufRead wvdial.conf,.wvdialrc	setf wvdial
                            
                            " CVS RC file
    1              0.000026 au BufNewFile,BufRead .cvsrc			setf cvsrc
                            
                            " CVS commit file
    1              0.000026 au BufNewFile,BufRead cvs\d\+			setf cvs
                            
                            " WEB (*.web is also used for Winbatch: Guess, based on expecting "%" comment
                            " lines in a WEB file).
    1              0.000031 au BufNewFile,BufRead *.web
                            	\ if getline(1)[0].getline(2)[0].getline(3)[0].getline(4)[0].getline(5)[0] =~ "%" |
                            	\   setf web |
                            	\ else |
                            	\   setf winbatch |
                            	\ endif
                            
                            " Windows Scripting Host and Windows Script Component
    1              0.000029 au BufNewFile,BufRead *.ws[fc]			setf wsh
                            
                            " XHTML
    1              0.000045 au BufNewFile,BufRead *.xhtml,*.xht		setf xhtml
                            
                            " X Pixmap (dynamically sets colors, use BufEnter to make it work better)
    1              0.000004 au BufEnter *.xpm
                            	\ if getline(1) =~ "XPM2" |
                            	\   setf xpm2 |
                            	\ else |
                            	\   setf xpm |
                            	\ endif
    1              0.000002 au BufEnter *.xpm2				setf xpm2
                            
                            " XFree86 config
    1              0.000031 au BufNewFile,BufRead XF86Config
                            	\ if getline(1) =~ '\<XConfigurator\>' |
                            	\   let b:xf86conf_xfree86_version = 3 |
                            	\ endif |
                            	\ setf xf86conf
    1              0.000033 au BufNewFile,BufRead */xorg.conf.d/*.conf
                            	\ let b:xf86conf_xfree86_version = 4 |
                            	\ setf xf86conf
                            
                            " Xorg config
    1              0.000043 au BufNewFile,BufRead xorg.conf,xorg.conf-4	let b:xf86conf_xfree86_version = 4 | setf xf86conf
                            
                            " Xinetd conf
    1              0.000026 au BufNewFile,BufRead */etc/xinetd.conf		setf xinetd
                            
                            " XS Perl extension interface language
    1              0.000028 au BufNewFile,BufRead *.xs			setf xs
                            
                            " X resources file
    1              0.000090 au BufNewFile,BufRead .Xdefaults,.Xpdefaults,.Xresources,xdm-config,*.ad setf xdefaults
                            
                            " Xmath
    1              0.000053 au BufNewFile,BufRead *.msc,*.msf		setf xmath
    1              0.000028 au BufNewFile,BufRead *.ms
                            	\ if !s:FTnroff() | setf xmath | endif
                            
                            " XML  specific variants: docbk and xbl
    1              0.000029 au BufNewFile,BufRead *.xml			call s:FTxml()
                            
    1              0.000002 func! s:FTxml()
                              let n = 1
                              while n < 100 && n < line("$")
                                let line = getline(n)
                                " DocBook 4 or DocBook 5.
                                let is_docbook4 = line =~ '<!DOCTYPE.*DocBook'
                                let is_docbook5 = line =~ ' xmlns="http://docbook.org/ns/docbook"'
                                if is_docbook4 || is_docbook5
                                  let b:docbk_type = "xml"
                                  if is_docbook5
                            	let b:docbk_ver = 5
                                  else
                            	let b:docbk_ver = 4
                                  endif
                                  setf docbk
                                  return
                                endif
                                if line =~ 'xmlns:xbl="http://www.mozilla.org/xbl"'
                                  setf xbl
                                  return
                                endif
                                let n += 1
                              endwhile
                              setf xml
                            endfunc
                            
                            " XMI (holding UML models) is also XML
    1              0.000031 au BufNewFile,BufRead *.xmi			setf xml
                            
                            " CSPROJ files are Visual Studio.NET's XML-based project config files
    1              0.000046 au BufNewFile,BufRead *.csproj,*.csproj.user	setf xml
                            
                            " Qt Linguist translation source and Qt User Interface Files are XML
    1              0.000042 au BufNewFile,BufRead *.ts,*.ui			setf xml
                            
                            " TPM's are RDF-based descriptions of TeX packages (Nikolai Weibull)
    1              0.000029 au BufNewFile,BufRead *.tpm			setf xml
                            
                            " Xdg menus
    1              0.000031 au BufNewFile,BufRead */etc/xdg/menus/*.menu	setf xml
                            
                            " ATI graphics driver configuration
    1              0.000029 au BufNewFile,BufRead fglrxrc			setf xml
                            
                            " XLIFF (XML Localisation Interchange File Format) is also XML
    1              0.000029 au BufNewFile,BufRead *.xlf			setf xml
    1              0.000027 au BufNewFile,BufRead *.xliff			setf xml
                            
                            " XML User Interface Language
    1              0.000031 au BufNewFile,BufRead *.xul			setf xml
                            
                            " X11 xmodmap (also see below)
    1              0.000027 au BufNewFile,BufRead *Xmodmap			setf xmodmap
                            
                            " Xquery
    1              0.000110 au BufNewFile,BufRead *.xq,*.xql,*.xqm,*.xquery,*.xqy	setf xquery
                            
                            " XSD
    1              0.000030 au BufNewFile,BufRead *.xsd			setf xsd
                            
                            " Xslt
    1              0.000046 au BufNewFile,BufRead *.xsl,*.xslt		setf xslt
                            
                            " Yacc
    1              0.000067 au BufNewFile,BufRead *.yy,*.yxx,*.y++		setf yacc
                            
                            " Yacc or racc
    1              0.000026 au BufNewFile,BufRead *.y			call s:FTy()
                            
    1              0.000001 func! s:FTy()
                              let n = 1
                              while n < 100 && n < line("$")
                                let line = getline(n)
                                if line =~ '^\s*%'
                                  setf yacc
                                  return
                                endif
                                if getline(n) =~ '^\s*\(#\|class\>\)' && getline(n) !~ '^\s*#\s*include'
                                  setf racc
                                  return
                                endif
                                let n = n + 1
                              endwhile
                              setf yacc
                            endfunc
                            
                            
                            " Yaml
    1              0.000051 au BufNewFile,BufRead *.yaml,*.yml		setf yaml
                            
                            " yum conf (close enough to dosini)
    1              0.000028 au BufNewFile,BufRead */etc/yum.conf		setf dosini
                            
                            " Zimbu
    1              0.000026 au BufNewFile,BufRead *.zu			setf zimbu
                            " Zimbu Templates
    1              0.000031 au BufNewFile,BufRead *.zut			setf zimbutempl
                            
                            " Zope
                            "   dtml (zope dynamic template markup language), pt (zope page template),
                            "   cpt (zope form controller page template)
    1              0.000065 au BufNewFile,BufRead *.dtml,*.pt,*.cpt		call s:FThtml()
                            "   zsql (zope sql method)
    1              0.000029 au BufNewFile,BufRead *.zsql			call s:SQL()
                            
                            " Z80 assembler asz80
    1              0.000031 au BufNewFile,BufRead *.z8a			setf z8a
                            
    1              0.000001 augroup END
                            
                            
                            " Source the user-specified filetype file, for backwards compatibility with
                            " Vim 5.x.
    1              0.000004 if exists("myfiletypefile") && filereadable(expand(myfiletypefile))
                              execute "source " . myfiletypefile
                            endif
                            
                            
                            " Check for "*" after loading myfiletypefile, so that scripts.vim is only used
                            " when there are no matching file name extensions.
                            " Don't do this for compressed files.
    1              0.000001 augroup filetypedetect
    1              0.000029 au BufNewFile,BufRead *
                            	\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
                            	\ | runtime! scripts.vim | endif
    1              0.000003 au StdinReadPost * if !did_filetype() | runtime! scripts.vim | endif
                            
                            
                            " Extra checks for when no filetype has been detected now.  Mostly used for
                            " patterns that end in "*".  E.g., "zsh*" matches "zsh.vim", but that's a Vim
                            " script file.
                            " Most of these should call s:StarSetf() to avoid names ending in .gz and the
                            " like are used.
                            
                            " More Apache config files
    1              0.000093 au BufNewFile,BufRead access.conf*,apache.conf*,apache2.conf*,httpd.conf*,srm.conf*	call s:StarSetf('apache')
    1              0.000096 au BufNewFile,BufRead */etc/apache2/*.conf*,*/etc/apache2/conf.*/*,*/etc/apache2/mods-*/*,*/etc/apache2/sites-*/*,*/etc/httpd/conf.d/*.conf*		call s:StarSetf('apache')
                            
                            " Asterisk config file
    1              0.000030 au BufNewFile,BufRead *asterisk/*.conf*		call s:StarSetf('asterisk')
    1              0.000028 au BufNewFile,BufRead *asterisk*/*voicemail.conf* call s:StarSetf('asteriskvm')
                            
                            " Bazaar version control
    1              0.000026 au BufNewFile,BufRead bzr_log.*			setf bzr
                            
                            " BIND zone
    1              0.000044 au BufNewFile,BufRead */named/db.*,*/bind/db.*	call s:StarSetf('bindzone')
                            
                            " Calendar
    1              0.000064 au BufNewFile,BufRead */.calendar/*,
                            	\*/share/calendar/*/calendar.*,*/share/calendar/calendar.*
                            	\					call s:StarSetf('calendar')
                            
                            " Changelog
    1              0.000029 au BufNewFile,BufRead [cC]hange[lL]og*
                            	\ if getline(1) =~ '; urgency='
                            	\|  call s:StarSetf('debchangelog')
                            	\|else
                            	\|  call s:StarSetf('changelog')
                            	\|endif
                            
                            " Crontab
    1              0.000062 au BufNewFile,BufRead crontab,crontab.*,*/etc/cron.d/*		call s:StarSetf('crontab')
                            
                            " dnsmasq(8) configuration
    1              0.000029 au BufNewFile,BufRead */etc/dnsmasq.d/*		call s:StarSetf('dnsmasq')
                            
                            " Dracula
    1              0.000028 au BufNewFile,BufRead drac.*			call s:StarSetf('dracula')
                            
                            " Fvwm
    1              0.000029 au BufNewFile,BufRead */.fvwm/*			call s:StarSetf('fvwm')
    1              0.000050 au BufNewFile,BufRead *fvwmrc*,*fvwm95*.hook
                            	\ let b:fvwm_version = 1 | call s:StarSetf('fvwm')
    1              0.000029 au BufNewFile,BufRead *fvwm2rc*
                            	\ if expand("<afile>:e") == "m4"
                            	\|  call s:StarSetf('fvwm2m4')
                            	\|else
                            	\|  let b:fvwm_version = 2 | call s:StarSetf('fvwm')
                            	\|endif
                            
                            " Gedcom
    1              0.000029 au BufNewFile,BufRead */tmp/lltmp*		call s:StarSetf('gedcom')
                            
                            " GTK RC
    1              0.000043 au BufNewFile,BufRead .gtkrc*,gtkrc*		call s:StarSetf('gtkrc')
                            
                            " Jam
    1              0.000044 au BufNewFile,BufRead Prl*.*,JAM*.*		call s:StarSetf('jam')
                            
                            " Jargon
    1              0.000029 au! BufNewFile,BufRead *jarg*
                            	\ if getline(1).getline(2).getline(3).getline(4).getline(5) =~? 'THIS IS THE JARGON FILE'
                            	\|  call s:StarSetf('jargon')
                            	\|endif
                            
                            " Kconfig
    1              0.000039 au BufNewFile,BufRead Kconfig.*			call s:StarSetf('kconfig')
                            
                            " Lilo: Linux loader
    1              0.000037 au BufNewFile,BufRead lilo.conf*		call s:StarSetf('lilo')
                            
                            " Logcheck
    1              0.000029 au BufNewFile,BufRead */etc/logcheck/*.d*/*	call s:StarSetf('logcheck')
                            
                            " Makefile
    1              0.000029 au BufNewFile,BufRead [mM]akefile*		call s:StarSetf('make')
                            
                            " Ruby Makefile
    1              0.000028 au BufNewFile,BufRead [rR]akefile*		call s:StarSetf('ruby')
                            
                            " Mail (also matches muttrc.vim, so this is below the other checks)
    1              0.000033 au BufNewFile,BufRead mutt[[:alnum:]._-]\\\{6\}	setf mail
                            
                            " Modconf
    1              0.000029 au BufNewFile,BufRead */etc/modutils/*
                            	\ if executable(expand("<afile>")) != 1
                            	\|  call s:StarSetf('modconf')
                            	\|endif
    1              0.000030 au BufNewFile,BufRead */etc/modprobe.*		call s:StarSetf('modconf')
                            
                            " Mutt setup file
    1              0.000046 au BufNewFile,BufRead .mutt{ng,}rc*,*/.mutt{ng,}/mutt{ng,}rc*	call s:StarSetf('muttrc')
    1              0.000046 au BufNewFile,BufRead mutt{ng,}rc*,Mutt{ng,}rc*		call s:StarSetf('muttrc')
                            
                            " Nroff macros
    1              0.000029 au BufNewFile,BufRead tmac.*			call s:StarSetf('nroff')
                            
                            " Pam conf
    1              0.000029 au BufNewFile,BufRead */etc/pam.d/*		call s:StarSetf('pamconf')
                            
                            " Printcap and Termcap
    1              0.000031 au BufNewFile,BufRead *printcap*
                            	\ if !did_filetype()
                            	\|  let b:ptcap_type = "print" | call s:StarSetf('ptcap')
                            	\|endif
    1              0.000031 au BufNewFile,BufRead *termcap*
                            	\ if !did_filetype()
                            	\|  let b:ptcap_type = "term" | call s:StarSetf('ptcap')
                            	\|endif
                            
                            " ReDIF
                            " Only used when the .rdf file was not detected to be XML.
    1              0.000030 au BufRead,BufNewFile *.rdf			call s:Redif()
    1              0.000002 func! s:Redif()
                              let lnum = 1
                              while lnum <= 5 && lnum < line('$')
                                if getline(lnum) =~ "^\ctemplate-type:"
                                  setf redif
                                  return
                                endif
                                let lnum = lnum + 1
                              endwhile
                            endfunc
                            
                            " Remind
    1              0.000027 au BufNewFile,BufRead .reminders*		call s:StarSetf('remind')
                            
                            " Vim script
    1              0.000030 au BufNewFile,BufRead *vimrc*			call s:StarSetf('vim')
                            
                            " Subversion commit file
    1              0.000029 au BufNewFile,BufRead svn-commit*.tmp		setf svn
                            
                            " X resources file
    1              0.000065 au BufNewFile,BufRead Xresources*,*/app-defaults/*,*/Xresources/* call s:StarSetf('xdefaults')
                            
                            " XFree86 config
    1              0.000030 au BufNewFile,BufRead XF86Config-4*
                            	\ let b:xf86conf_xfree86_version = 4 | call s:StarSetf('xf86conf')
    1              0.000029 au BufNewFile,BufRead XF86Config*
                            	\ if getline(1) =~ '\<XConfigurator\>'
                            	\|  let b:xf86conf_xfree86_version = 3
                            	\|endif
                            	\|call s:StarSetf('xf86conf')
                            
                            " X11 xmodmap
    1              0.000031 au BufNewFile,BufRead *xmodmap*			call s:StarSetf('xmodmap')
                            
                            " Xinetd conf
    1              0.000029 au BufNewFile,BufRead */etc/xinetd.d/*		call s:StarSetf('xinetd')
                            
                            " yum conf (close enough to dosini)
    1              0.000030 au BufNewFile,BufRead */etc/yum.repos.d/*	call s:StarSetf('dosini')
                            
                            " Z-Shell script
    1              0.000049 au BufNewFile,BufRead zsh*,zlog*		call s:StarSetf('zsh')
                            
                            
                            " Plain text files, needs to be far down to not override others.  This avoids
                            " the "conf" type being used if there is a line starting with '#'.
    1              0.000073 au BufNewFile,BufRead *.txt,*.text,README	setf text
                            
                            
                            " Use the filetype detect plugins.  They may overrule any of the previously
                            " detected filetypes.
    1              0.000165 runtime! ftdetect/*.vim
                            
                            " NOTE: The above command could have ended the filetypedetect autocmd group
                            " and started another one. Let's make sure it has ended to get to a consistent
                            " state.
    1              0.000001 augroup END
                            
                            " Generic configuration file (check this last, it's just guessing!)
    1              0.000035 au filetypedetect BufNewFile,BufRead,StdinReadPost *
                            	\ if !did_filetype() && expand("<amatch>") !~ g:ft_ignore_pat
                            	\    && (getline(1) =~ '^#' || getline(2) =~ '^#' || getline(3) =~ '^#'
                            	\	|| getline(4) =~ '^#' || getline(5) =~ '^#') |
                            	\   setf conf |
                            	\ endif
                            
                            
                            " If the GUI is already running, may still need to install the Syntax menu.
                            " Don't do it when the 'M' flag is included in 'guioptions'.
    1              0.000008 if has("menu") && has("gui_running")
                                  \ && !exists("did_install_syntax_menu") && &guioptions !~# "M"
                              source <sfile>:p:h/menu.vim
                            endif
                            
                            " Function called for testing all functions defined here.  These are
                            " script-local, thus need to be executed here.
                            " Returns a string with error messages (hopefully empty).
    1              0.000002 func! TestFiletypeFuncs(testlist)
                              let output = ''
                              for f in a:testlist
                                try
                                  exe f
                                catch
                                  let output = output . "\n" . f . ": " . v:exception
                                endtry
                              endfor
                              return output
                            endfunc
                            
                            " Restore 'cpoptions'
    1              0.000007 let &cpo = s:cpo_save
    1              0.000003 unlet s:cpo_save

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/ftdetect/ftdetect.vim
Sourced 1 time
Total time:   0.000234
 Self time:   0.000234

count  total (s)   self (s)
                            au BufNewFile,BufRead [Dd]ockerfile,Dockerfile.* set filetype=dockerfile
                            " We take care to preserve the user's fileencodings and fileformats,
                            " because those settings are global (not buffer local), yet we want
                            " to override them for loading Go files, which are defined to be UTF-8.
    1              0.000003 let s:current_fileformats = ''
    1              0.000001 let s:current_fileencodings = ''
                            
                            " define fileencodings to open as utf-8 encoding even if it's ascii.
    1              0.000003 function! s:gofiletype_pre(type)
                                let s:current_fileformats = &g:fileformats
                                let s:current_fileencodings = &g:fileencodings
                                set fileencodings=utf-8 fileformats=unix
                                let &l:filetype = a:type
                            endfunction
                            
                            " restore fileencodings as others
    1              0.000001 function! s:gofiletype_post()
                                let &g:fileformats = s:current_fileformats
                                let &g:fileencodings = s:current_fileencodings
                            endfunction
                            
    1              0.000018 au BufNewFile *.go setfiletype go | setlocal fileencoding=utf-8 fileformat=unix
    1              0.000017 au BufRead *.go call s:gofiletype_pre("go")
    1              0.000010 au BufReadPost *.go call s:gofiletype_post()
                            
    1              0.000015 au BufNewFile *.s setfiletype asm | setlocal fileencoding=utf-8 fileformat=unix
    1              0.000014 au BufRead *.s call s:gofiletype_pre("asm")
    1              0.000009 au BufReadPost *.s call s:gofiletype_post()
                            
    1              0.000025 au BufRead,BufNewFile *.tmpl set filetype=gohtmltmpl
                            
                            " vim:ts=4:sw=4:et
                            " Detect syntax file.
    1              0.000048 autocmd BufNewFile,BufRead *.snip,*.snippets set filetype=neosnippet

SCRIPT  /usr/local/share/nvim/runtime/ftplugin.vim
Sourced 1 time
Total time:   0.000037
 Self time:   0.000037

count  total (s)   self (s)
                            " Vim support file to switch on loading plugins for file types
                            "
                            " Maintainer:	Bram Moolenaar <Bram@vim.org>
                            " Last change:	2006 Apr 30
                            
    1              0.000003 if exists("did_load_ftplugin")
                              finish
                            endif
    1              0.000002 let did_load_ftplugin = 1
                            
    1              0.000001 augroup filetypeplugin
    1              0.000004   au FileType * call s:LoadFTPlugin()
                            
    1              0.000002   func! s:LoadFTPlugin()
                                if exists("b:undo_ftplugin")
                                  exe b:undo_ftplugin
                                  unlet! b:undo_ftplugin b:did_ftplugin
                                endif
                            
                                let s = expand("<amatch>")
                                if s != ""
                                  if &cpo =~# "S" && exists("b:did_ftplugin")
                            	" In compatible mode options are reset to the global values, need to
                            	" set the local values also when a plugin was already used.
                            	unlet b:did_ftplugin
                                  endif
                            
                                  " When there is a dot it is used to separate filetype names.  Thus for
                                  " "aaa.bbb" load "aaa" and then "bbb".
                                  for name in split(s, '\.')
                            	exe 'runtime! ftplugin/' . name . '.vim ftplugin/' . name . '_*.vim ftplugin/' . name . '/*.vim'
                                  endfor
                                endif
                              endfunc
    1              0.000002 augroup END

SCRIPT  /usr/local/share/nvim/runtime/indent.vim
Sourced 1 time
Total time:   0.000028
 Self time:   0.000028

count  total (s)   self (s)
                            " Vim support file to switch on loading indent files for file types
                            "
                            " Maintainer:	Bram Moolenaar <Bram@vim.org>
                            " Last Change:	2008 Feb 22
                            
    1              0.000003 if exists("did_indent_on")
                              finish
                            endif
    1              0.000002 let did_indent_on = 1
                            
    1              0.000001 augroup filetypeindent
    1              0.000004   au FileType * call s:LoadIndent()
    1              0.000002   func! s:LoadIndent()
                                if exists("b:undo_indent")
                                  exe b:undo_indent
                                  unlet! b:undo_indent b:did_indent
                                endif
                                let s = expand("<amatch>")
                                if s != ""
                                  if exists("b:did_indent")
                            	unlet b:did_indent
                                  endif
                            
                                  " When there is a dot it is used to separate filetype names.  Thus for
                                  " "aaa.bbb" load "indent/aaa.vim" and then "indent/bbb.vim".
                                  for name in split(s, '\.')
                            	exe 'runtime! indent/' . name . '.vim'
                                  endfor
                                endif
                              endfunc
    1              0.000002 augroup END

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/colors/hybrid_reverse.vim
Sourced 2 times
Total time:   0.002585
 Self time:   0.002272

count  total (s)   self (s)
                            " File:       hybrid_reverse.vim
                            " Maintainer: Kristijan Husak (kristijanhusak)
                            " URL:        https://github.com/w0ng/vim-hybrid-material
                            " BASED ON:   https://github.com/w0ng/vim-hybrid
                            " Modified:   24 June 2015 by Kristijan Husak (kristijanhusak) <husakkristijan@gmail.com>
                            " License:    MIT
                            
                            " Description:"{{{
                            " ----------------------------------------------------------------------------
                            " The RGB colour palette is taken from Tomorrow-Night.vim:
                            " https://github.com/chriskempson/vim-tomorrow-theme
                            "
                            " The syntax highlighting scheme is taken from jellybeans.vim:
                            " https://github.com/nanotech/jellybeans.vim
                            "
                            " The code taken from solarized.vim
                            " https://github.com/altercation/vim-colors-solarized
                            
                            "}}}
                            " Requirements And Recommendations:"{{{
                            " ----------------------------------------------------------------------------
                            " This colourscheme is intended for use on:
                            "   - gVim 7.3 for Linux, Mac and Windows.
                            "   - Vim 7.3 for Linux, using a 256 colour enabled terminal.
                            "
                            " By default, Vim will use the closest matching cterm equivalent of the RGB
                            " colours.
                            "
                            " However, Due to the limited 256 palette, colours in Vim and gVim will still
                            " be noticeably different. In order to get a uniform appearance and the way
                            " that this colourscheme was intended, it is HIGHLY recommended that you:
                            "
                            " 1.  Add these colours to ~/.Xresources:
                            "
                            "       https://gist.github.com/3278077
                            "
                            " 2.  Use Xresources colours by setting in ~/.vimrc:
                            "
                            "       let g:hybrid_use_Xresources = 1
                            "       colorscheme hybrid
                            "
                            " For iTerm2 users:
                            " 1.  Install this color preset on your iTerm2:
                            "
                            "       https://gist.github.com/luan/6362811
                            "
                            " 2. Use iTerm colours by setting in ~/.vimrc:
                            "
                            "       let g:hybrid_use_iTerm_colors = 1
                            "       colorscheme hybrid
                            "
                            
                            "}}}
                            
                            
                            " xter 256 colorname list
                            
                            "  | 016 | Grey0 | ctermfg=16 | guifg=#000000 "rgb=0,0,0 |
                            "  | 017 | NavyBlue | ctermfg=17 | guifg=#00005f | "rgb=0,0,95 |
                            "  | 018 | DarkBlue | ctermfg=18 | guifg=#000087 | "rgb=0,0,135 |
                            "  | 019 | Blue3 | ctermfg=19 | guifg=#0000af | "rgb=0,0,175 |
                            "  | 020 | Blue3 | ctermfg=20 | guifg=#0000d7 | "rgb=0,0,215 |
                            "  | 021 | Blue1 | ctermfg=21 | guifg=#0000ff | "rgb=0,0,255 |
                            "  | 022 | DarkGreen | ctermfg=22 | guifg=#005f00 | "rgb=0,95,0 |
                            "  | 023 | DeepSkyBlue4 | ctermfg=23 | guifg=#005f5f | "rgb=0,95,95 |
                            "  | 024 | DeepSkyBlue4 | ctermfg=24 | guifg=#005f87 | "rgb=0,95,135 |
                            "  | 025 | DeepSkyBlue4 | ctermfg=25 | guifg=#005faf | "rgb=0,95,175 |
                            "  | 026 | DodgerBlue3 | ctermfg=26 | guifg=#005fd7 | "rgb=0,95,215 |
                            "  | 027 | DodgerBlue2 | ctermfg=27 | guifg=#005fff | "rgb=0,95,255 |
                            "  | 028 | Green4 | ctermfg=28 | guifg=#008700 | "rgb=0,135,0 |
                            "  | 029 | SpringGreen4 | ctermfg=29 | guifg=#00875f | "rgb=0,135,95 |
                            "  | 030 | Turquoise4 | ctermfg=30 | guifg=#008787 | "rgb=0,135,135 |
                            "  | 031 | DeepSkyBlue3 | ctermfg=31 | guifg=#0087af | "rgb=0,135,175 |
                            "  | 032 | DeepSkyBlue3 | ctermfg=32 | guifg=#0087d7 | "rgb=0,135,215 |
                            "  | 033 | DodgerBlue1 | ctermfg=33 | guifg=#0087ff | "rgb=0,135,255 |
                            "  | 034 | Green3 | ctermfg=34 | guifg=#00af00 | "rgb=0,175,0 |
                            "  | 035 | SpringGreen3 | ctermfg=35 | guifg=#00af5f | "rgb=0,175,95 |
                            "  | 036 | DarkCyan | ctermfg=36 | guifg=#00af87 | "rgb=0,175,135 |
                            "  | 037 | LightSeaGreen | ctermfg=37 | guifg=#00afaf | "rgb=0,175,175 |
                            "  | 038 | DeepSkyBlue2 | ctermfg=38 | guifg=#00afd7 | "rgb=0,175,215 |
                            "  | 039 | DeepSkyBlue1 | ctermfg=39 | guifg=#00afff | "rgb=0,175,255 |
                            "  | 040 | Green3 | ctermfg=40 | guifg=#00d700 | "rgb=0,215,0 |
                            "  | 041 | SpringGreen3 | ctermfg=41 | guifg=#00d75f | "rgb=0,215,95 |
                            "  | 042 | SpringGreen2 | ctermfg=42 | guifg=#00d787 | "rgb=0,215,135 |
                            "  | 043 | Cyan3 | ctermfg=43 | guifg=#00d7af | "rgb=0,215,175 |
                            "  | 044 | DarkTurquoise | ctermfg=44 | guifg=#00d7d7 | "rgb=0,215,215 |
                            "  | 045 | Turquoise2 | ctermfg=45 | guifg=#00d7ff | "rgb=0,215,255 |
                            "  | 046 | Green1 | ctermfg=46 | guifg=#00ff00 | "rgb=0,255,0 |
                            "  | 047 | SpringGreen2 | ctermfg=47 | guifg=#00ff5f | "rgb=0,255,95 |
                            "  | 048 | SpringGreen1 | ctermfg=48 | guifg=#00ff87 | "rgb=0,255,135 |
                            "  | 049 | MediumSpringGreen | ctermfg=49 | guifg=#00ffaf | "rgb=0,255,175 |
                            "  | 050 | Cyan2 | ctermfg=50 | guifg=#00ffd7 | "rgb=0,255,215 |
                            "  | 051 | Cyan1 | ctermfg=51 | guifg=#00ffff | "rgb=0,255,255 |
                            "  | 052 | DarkRed | ctermfg=52 | guifg=#5f0000 | "rgb=95,0,0 |
                            "  | 053 | DeepPink4 | ctermfg=53 | guifg=#5f005f | "rgb=95,0,95 |
                            "  | 054 | Purple4 | ctermfg=54 | guifg=#5f0087 | "rgb=95,0,135 |
                            "  | 055 | Purple4 | ctermfg=55 | guifg=#5f00af | "rgb=95,0,175 |
                            "  | 056 | Purple3 | ctermfg=56 | guifg=#5f00d7 | "rgb=95,0,215 |
                            "  | 057 | BlueViolet | ctermfg=57 | guifg=#5f00ff | "rgb=95,0,255 |
                            "  | 058 | Orange4 | ctermfg=58 | guifg=#5f5f00 | "rgb=95,95,0 |
                            "  | 059 | Grey37 | ctermfg=59 | guifg=#5f5f5f | "rgb=95,95,95 |
                            "  | 060 | MediumPurple4 | ctermfg=60 | guifg=#5f5f87 | "rgb=95,95,135 |
                            "  | 061 | SlateBlue3 | ctermfg=61 | guifg=#5f5faf | "rgb=95,95,175 |
                            "  | 062 | SlateBlue3 | ctermfg=62 | guifg=#5f5fd7 | "rgb=95,95,215 |
                            "  | 063 | RoyalBlue1 | ctermfg=63 | guifg=#5f5fff | "rgb=95,95,255 |
                            "  | 064 | Chartreuse4 | ctermfg=64 | guifg=#5f8700 | "rgb=95,135,0 |
                            "  | 065 | DarkSeaGreen4 | ctermfg=65 | guifg=#5f875f | "rgb=95,135,95 |
                            "  | 066 | PaleTurquoise4 | ctermfg=66 | guifg=#5f8787 | "rgb=95,135,135 |
                            "  | 067 | SteelBlue | ctermfg=67 | guifg=#5f87af | "rgb=95,135,175 |
                            "  | 068 | SteelBlue3 | ctermfg=68 | guifg=#5f87d7 | "rgb=95,135,215 |
                            "  | 069 | CornflowerBlue | ctermfg=69 | guifg=#5f87ff | "rgb=95,135,255 |
                            "  | 070 | Chartreuse3 | ctermfg=70 | guifg=#5faf00 | "rgb=95,175,0 |
                            "  | 071 | DarkSeaGreen4 | ctermfg=71 | guifg=#5faf5f | "rgb=95,175,95 |
                            "  | 072 | CadetBlue | ctermfg=72 | guifg=#5faf87 | "rgb=95,175,135 |
                            "  | 073 | CadetBlue | ctermfg=73 | guifg=#5fafaf | "rgb=95,175,175 |
                            "  | 074 | SkyBlue3 | ctermfg=74 | guifg=#5fafd7 | "rgb=95,175,215 |
                            "  | 075 | SteelBlue1 | ctermfg=75 | guifg=#5fafff | "rgb=95,175,255 |
                            "  | 076 | Chartreuse3 | ctermfg=76 | guifg=#5fd700 | "rgb=95,215,0 |
                            "  | 077 | PaleGreen3 | ctermfg=77 | guifg=#5fd75f | "rgb=95,215,95 |
                            "  | 078 | SeaGreen3 | ctermfg=78 | guifg=#5fd787 | "rgb=95,215,135 |
                            "  | 079 | Aquamarine3 | ctermfg=79 | guifg=#5fd7af | "rgb=95,215,175 |
                            "  | 080 | MediumTurquoise | ctermfg=80 | guifg=#5fd7d7 | "rgb=95,215,215 |
                            "  | 081 | SteelBlue1 | ctermfg=81 | guifg=#5fd7ff | "rgb=95,215,255 |
                            "  | 082 | Chartreuse2 | ctermfg=82 | guifg=#5fff00 | "rgb=95,255,0 |
                            "  | 083 | SeaGreen2 | ctermfg=83 | guifg=#5fff5f | "rgb=95,255,95 |
                            "  | 084 | SeaGreen1 | ctermfg=84 | guifg=#5fff87 | "rgb=95,255,135 |
                            "  | 085 | SeaGreen1 | ctermfg=85 | guifg=#5fffaf | "rgb=95,255,175 |
                            "  | 086 | Aquamarine1 | ctermfg=86 | guifg=#5fffd7 | "rgb=95,255,215 |
                            "  | 087 | DarkSlateGray2 | ctermfg=87 | guifg=#5fffff | "rgb=95,255,255 |
                            "  | 088 | DarkRed | ctermfg=88 | guifg=#870000 | "rgb=135,0,0 |
                            "  | 089 | DeepPink4 | ctermfg=89 | guifg=#87005f | "rgb=135,0,95 |
                            "  | 090 | DarkMagenta | ctermfg=90 | guifg=#870087 | "rgb=135,0,135 |
                            "  | 091 | DarkMagenta | ctermfg=91 | guifg=#8700af | "rgb=135,0,175 |
                            "  | 092 | DarkViolet | ctermfg=92 | guifg=#8700d7 | "rgb=135,0,215 |
                            "  | 093 | Purple | ctermfg=93 | guifg=#8700ff | "rgb=135,0,255 |
                            "  | 094 | Orange4 | ctermfg=94 | guifg=#875f00 | "rgb=135,95,0 |
                            "  | 095 | LightPink4 | ctermfg=95 | guifg=#875f5f | "rgb=135,95,95 |
                            "  | 096 | Plum4 | ctermfg=96 | guifg=#875f87 | "rgb=135,95,135 |
                            "  | 097 | MediumPurple3 | ctermfg=97 | guifg=#875faf | "rgb=135,95,175 |
                            "  | 098 | MediumPurple3 | ctermfg=98 | guifg=#875fd7 | "rgb=135,95,215 |
                            "  | 099 | SlateBlue1 | ctermfg=99 | guifg=#875fff | "rgb=135,95,255 |
                            "  | 100 | Yellow4 | ctermfg=100 | guifg=#878700 | "rgb=135,135,0 |
                            "  | 101 | Wheat4 | ctermfg=101 | guifg=#87875f | "rgb=135,135,95 |
                            "  | 102 | Grey53 | ctermfg=102 | guifg=#878787 | "rgb=135,135,135 |
                            "  | 103 | LightSlateGrey | ctermfg=103 | guifg=#8787af | "rgb=135,135,175 |
                            "  | 104 | MediumPurple | ctermfg=104 | guifg=#8787d7 | "rgb=135,135,215 |
                            "  | 105 | LightSlateBlue | ctermfg=105 | guifg=#8787ff | "rgb=135,135,255 |
                            "  | 106 | Yellow4 | ctermfg=106 | guifg=#87af00 | "rgb=135,175,0 |
                            "  | 107 | DarkOliveGreen3 | ctermfg=107 | guifg=#87af5f | "rgb=135,175,95 |
                            "  | 108 | DarkSeaGreen | ctermfg=108 | guifg=#87af87 | "rgb=135,175,135 |
                            "  | 109 | LightSkyBlue3 | ctermfg=109 | guifg=#87afaf | "rgb=135,175,175 |
                            "  | 110 | LightSkyBlue3 | ctermfg=110 | guifg=#87afd7 | "rgb=135,175,215 |
                            "  | 111 | SkyBlue2 | ctermfg=111 | guifg=#87afff | "rgb=135,175,255 |
                            "  | 112 | Chartreuse2 | ctermfg=112 | guifg=#87d700 | "rgb=135,215,0 |
                            "  | 113 | DarkOliveGreen3 | ctermfg=113 | guifg=#87d75f | "rgb=135,215,95 |
                            "  | 114 | PaleGreen3 | ctermfg=114 | guifg=#87d787 | "rgb=135,215,135 |
                            "  | 115 | DarkSeaGreen3 | ctermfg=115 | guifg=#87d7af | "rgb=135,215,175 |
                            "  | 116 | DarkSlateGray3 | ctermfg=116 | guifg=#87d7d7 | "rgb=135,215,215 |
                            "  | 117 | SkyBlue1 | ctermfg=117 | guifg=#87d7ff | "rgb=135,215,255 |
                            "  | 118 | Chartreuse1 | ctermfg=118 | guifg=#87ff00 | "rgb=135,255,0 |
                            "  | 119 | LightGreen | ctermfg=119 | guifg=#87ff5f | "rgb=135,255,95 |
                            "  | 120 | LightGreen | ctermfg=120 | guifg=#87ff87 | "rgb=135,255,135 |
                            "  | 121 | PaleGreen1 | ctermfg=121 | guifg=#87ffaf | "rgb=135,255,175 |
                            "  | 122 | Aquamarine1 | ctermfg=122 | guifg=#87ffd7 | "rgb=135,255,215 |
                            "  | 123 | DarkSlateGray1 | ctermfg=123 | guifg=#87ffff | "rgb=135,255,255 |
                            "  | 124 | Red3 | ctermfg=124 | guifg=#af0000 | "rgb=175,0,0 |
                            "  | 125 | DeepPink4 | ctermfg=125 | guifg=#af005f | "rgb=175,0,95 |
                            "  | 126 | MediumVioletRed | ctermfg=126 | guifg=#af0087 | "rgb=175,0,135 |
                            "  | 127 | Magenta3 | ctermfg=127 | guifg=#af00af | "rgb=175,0,175 |
                            "  | 128 | DarkViolet | ctermfg=128 | guifg=#af00d7 | "rgb=175,0,215 |
                            "  | 129 | Purple | ctermfg=129 | guifg=#af00ff | "rgb=175,0,255 |
                            "  | 130 | DarkOrange3 | ctermfg=130 | guifg=#af5f00 | "rgb=175,95,0 |
                            "  | 131 | IndianRed | ctermfg=131 | guifg=#af5f5f | "rgb=175,95,95 |
                            "  | 132 | HotPink3 | ctermfg=132 | guifg=#af5f87 | "rgb=175,95,135 |
                            "  | 133 | MediumOrchid3 | ctermfg=133 | guifg=#af5faf | "rgb=175,95,175 |
                            "  | 134 | MediumOrchid | ctermfg=134 | guifg=#af5fd7 | "rgb=175,95,215 |
                            "  | 135 | MediumPurple2 | ctermfg=135 | guifg=#af5fff | "rgb=175,95,255 |
                            "  | 136 | DarkGoldenrod | ctermfg=136 | guifg=#af8700 | "rgb=175,135,0 |
                            "  | 137 | LightSalmon3 | ctermfg=137 | guifg=#af875f | "rgb=175,135,95 |
                            "  | 138 | RosyBrown | ctermfg=138 | guifg=#af8787 | "rgb=175,135,135 |
                            "  | 139 | Grey63 | ctermfg=139 | guifg=#af87af | "rgb=175,135,175 |
                            "  | 140 | MediumPurple2 | ctermfg=140 | guifg=#af87d7 | "rgb=175,135,215 |
                            "  | 141 | MediumPurple1 | ctermfg=141 | guifg=#af87ff | "rgb=175,135,255 |
                            "  | 142 | Gold3 | ctermfg=142 | guifg=#afaf00 | "rgb=175,175,0 |
                            "  | 143 | DarkKhaki | ctermfg=143 | guifg=#afaf5f | "rgb=175,175,95 |
                            "  | 144 | NavajoWhite3 | ctermfg=144 | guifg=#afaf87 | "rgb=175,175,135 |
                            "  | 145 | Grey69 | ctermfg=145 | guifg=#afafaf | "rgb=175,175,175 |
                            "  | 146 | LightSteelBlue3 | ctermfg=146 | guifg=#afafd7 | "rgb=175,175,215 |
                            "  | 147 | LightSteelBlue | ctermfg=147 | guifg=#afafff | "rgb=175,175,255 |
                            "  | 148 | Yellow3 | ctermfg=148 | guifg=#afd700 | "rgb=175,215,0 |
                            "  | 149 | DarkOliveGreen3 | ctermfg=149 | guifg=#afd75f | "rgb=175,215,95 |
                            "  | 150 | DarkSeaGreen3 | ctermfg=150 | guifg=#afd787 | "rgb=175,215,135 |
                            "  | 151 | DarkSeaGreen2 | ctermfg=151 | guifg=#afd7af | "rgb=175,215,175 |
                            "  | 152 | LightCyan3 | ctermfg=152 | guifg=#afd7d7 | "rgb=175,215,215 |
                            "  | 153 | LightSkyBlue1 | ctermfg=153 | guifg=#afd7ff | "rgb=175,215,255 |
                            "  | 154 | GreenYellow | ctermfg=154 | guifg=#afff00 | "rgb=175,255,0 |
                            "  | 155 | DarkOliveGreen2 | ctermfg=155 | guifg=#afff5f | "rgb=175,255,95 |
                            "  | 156 | PaleGreen1 | ctermfg=156 | guifg=#afff87 | "rgb=175,255,135 |
                            "  | 157 | DarkSeaGreen2 | ctermfg=157 | guifg=#afffaf | "rgb=175,255,175 |
                            "  | 158 | DarkSeaGreen1 | ctermfg=158 | guifg=#afffd7 | "rgb=175,255,215 |
                            "  | 159 | PaleTurquoise1 | ctermfg=159 | guifg=#afffff | "rgb=175,255,255 |
                            "  | 160 | Red3 | ctermfg=160 | guifg=#d70000 | "rgb=215,0,0 |
                            "  | 161 | DeepPink3 | ctermfg=161 | guifg=#d7005f | "rgb=215,0,95 |
                            "  | 162 | DeepPink3 | ctermfg=162 | guifg=#d70087 | "rgb=215,0,135 |
                            "  | 163 | Magenta3 | ctermfg=163 | guifg=#d700af | "rgb=215,0,175 |
                            "  | 164 | Magenta3 | ctermfg=164 | guifg=#d700d7 | "rgb=215,0,215 |
                            "  | 165 | Magenta2 | ctermfg=165 | guifg=#d700ff | "rgb=215,0,255 |
                            "  | 166 | DarkOrange3 | ctermfg=166 | guifg=#d75f00 | "rgb=215,95,0 |
                            "  | 167 | IndianRed | ctermfg=167 | guifg=#d75f5f | "rgb=215,95,95 |
                            "  | 168 | HotPink3 | ctermfg=168 | guifg=#d75f87 | "rgb=215,95,135 |
                            "  | 169 | HotPink2 | ctermfg=169 | guifg=#d75faf | "rgb=215,95,175 |
                            "  | 170 | Orchid | ctermfg=170 | guifg=#d75fd7 | "rgb=215,95,215 |
                            "  | 171 | MediumOrchid1 | ctermfg=171 | guifg=#d75fff | "rgb=215,95,255 |
                            "  | 172 | Orange3 | ctermfg=172 | guifg=#d78700 | "rgb=215,135,0 |
                            "  | 173 | LightSalmon3 | ctermfg=173 | guifg=#d7875f | "rgb=215,135,95 |
                            "  | 174 | LightPink3 | ctermfg=174 | guifg=#d78787 | "rgb=215,135,135 |
                            "  | 175 | Pink3 | ctermfg=175 | guifg=#d787af | "rgb=215,135,175 |
                            "  | 176 | Plum3 | ctermfg=176 | guifg=#d787d7 | "rgb=215,135,215 |
                            "  | 177 | Violet | ctermfg=177 | guifg=#d787ff | "rgb=215,135,255 |
                            "  | 178 | Gold3 | ctermfg=178 | guifg=#d7af00 | "rgb=215,175,0 |
                            "  | 179 | LightGoldenrod3 | ctermfg=179 | guifg=#d7af5f | "rgb=215,175,95 |
                            "  | 180 | Tan | ctermfg=180 | guifg=#d7af87 | "rgb=215,175,135 |
                            "  | 181 | MistyRose3 | ctermfg=181 | guifg=#d7afaf | "rgb=215,175,175 |
                            "  | 182 | Thistle3 | ctermfg=182 | guifg=#d7afd7 | "rgb=215,175,215 |
                            "  | 183 | Plum2 | ctermfg=183 | guifg=#d7afff | "rgb=215,175,255 |
                            "  | 184 | Yellow3 | ctermfg=184 | guifg=#d7d700 | "rgb=215,215,0 |
                            "  | 185 | Khaki3 | ctermfg=185 | guifg=#d7d75f | "rgb=215,215,95 |
                            "  | 186 | LightGoldenrod2 | ctermfg=186 | guifg=#d7d787 | "rgb=215,215,135 |
                            "  | 187 | LightYellow3 | ctermfg=187 | guifg=#d7d7af | "rgb=215,215,175 |
                            "  | 188 | Grey84 | ctermfg=188 | guifg=#d7d7d7 | "rgb=215,215,215 |
                            "  | 189 | LightSteelBlue1 | ctermfg=189 | guifg=#d7d7ff | "rgb=215,215,255 |
                            "  | 190 | Yellow2 | ctermfg=190 | guifg=#d7ff00 | "rgb=215,255,0 |
                            "  | 191 | DarkOliveGreen1 | ctermfg=191 | guifg=#d7ff5f | "rgb=215,255,95 |
                            "  | 192 | DarkOliveGreen1 | ctermfg=192 | guifg=#d7ff87 | "rgb=215,255,135 |
                            "  | 193 | DarkSeaGreen1 | ctermfg=193 | guifg=#d7ffaf | "rgb=215,255,175 |
                            "  | 194 | Honeydew2 | ctermfg=194 | guifg=#d7ffd7 | "rgb=215,255,215 |
                            "  | 195 | LightCyan1 | ctermfg=195 | guifg=#d7ffff | "rgb=215,255,255 |
                            "  | 196 | Red1 | ctermfg=196 | guifg=#ff0000 | "rgb=255,0,0 |
                            "  | 197 | DeepPink2 | ctermfg=197 | guifg=#ff005f | "rgb=255,0,95 |
                            "  | 198 | DeepPink1 | ctermfg=198 | guifg=#ff0087 | "rgb=255,0,135 |
                            "  | 199 | DeepPink1 | ctermfg=199 | guifg=#ff00af | "rgb=255,0,175 |
                            "  | 200 | Magenta2 | ctermfg=200 | guifg=#ff00d7 | "rgb=255,0,215 |
                            "  | 201 | Magenta1 | ctermfg=201 | guifg=#ff00ff | "rgb=255,0,255 |
                            "  | 202 | OrangeRed1 | ctermfg=202 | guifg=#ff5f00 | "rgb=255,95,0 |
                            "  | 203 | IndianRed1 | ctermfg=203 | guifg=#ff5f5f | "rgb=255,95,95 |
                            "  | 204 | IndianRed1 | ctermfg=204 | guifg=#ff5f87 | "rgb=255,95,135 |
                            "  | 205 | HotPink | ctermfg=205 | guifg=#ff5faf | "rgb=255,95,175 |
                            "  | 206 | HotPink | ctermfg=206 | guifg=#ff5fd7 | "rgb=255,95,215 |
                            "  | 207 | MediumOrchid1 | ctermfg=207 | guifg=#ff5fff | "rgb=255,95,255 |
                            "  | 208 | DarkOrange | ctermfg=208 | guifg=#ff8700 | "rgb=255,135,0 |
                            "  | 209 | Salmon1 | ctermfg=209 | guifg=#ff875f | "rgb=255,135,95 |
                            "  | 210 | LightCoral | ctermfg=210 | guifg=#ff8787 | "rgb=255,135,135 |
                            "  | 211 | PaleVioletRed1 | ctermfg=211 | guifg=#ff87af | "rgb=255,135,175 |
                            "  | 212 | Orchid2 | ctermfg=212 | guifg=#ff87d7 | "rgb=255,135,215 |
                            "  | 213 | Orchid1 | ctermfg=213 | guifg=#ff87ff | "rgb=255,135,255 |
                            "  | 214 | Orange1 | ctermfg=214 | guifg=#ffaf00 | "rgb=255,175,0 |
                            "  | 215 | SandyBrown | ctermfg=215 | guifg=#ffaf5f | "rgb=255,175,95 |
                            "  | 216 | LightSalmon1 | ctermfg=216 | guifg=#ffaf87 | "rgb=255,175,135 |
                            "  | 217 | LightPink1 | ctermfg=217 | guifg=#ffafaf | "rgb=255,175,175 |
                            "  | 218 | Pink1 | ctermfg=218 | guifg=#ffafd7 | "rgb=255,175,215 |
                            "  | 219 | Plum1 | ctermfg=219 | guifg=#ffafff | "rgb=255,175,255 |
                            "  | 220 | Gold1 | ctermfg=220 | guifg=#ffd700 | "rgb=255,215,0 |
                            "  | 221 | LightGoldenrod2 | ctermfg=221 | guifg=#ffd75f | "rgb=255,215,95 |
                            "  | 222 | LightGoldenrod2 | ctermfg=222 | guifg=#ffd787 | "rgb=255,215,135 |
                            "  | 223 | NavajoWhite1 | ctermfg=223 | guifg=#ffd7af | "rgb=255,215,175 |
                            "  | 224 | MistyRose1 | ctermfg=224 | guifg=#ffd7d7 | "rgb=255,215,215 |
                            "  | 225 | Thistle1 | ctermfg=225 | guifg=#ffd7ff | "rgb=255,215,255 |
                            "  | 226 | Yellow1 | ctermfg=226 | guifg=#ffff00 | "rgb=255,255,0 |
                            "  | 227 | LightGoldenrod1 | ctermfg=227 | guifg=#ffff5f | "rgb=255,255,95 |
                            "  | 228 | Khaki1 | ctermfg=228 | guifg=#ffff87 | "rgb=255,255,135 |
                            "  | 229 | Wheat1 | ctermfg=229 | guifg=#ffffaf | "rgb=255,255,175 |
                            "  | 230 | Cornsilk1 | ctermfg=230 | guifg=#ffffd7 | "rgb=255,255,215 |
                            "  | 231 | Grey100 | ctermfg=231 | guifg=#ffffff | "rgb=255,255,255 |
                            "  | 232 | Grey3 | ctermfg=232 | guifg=#080808 | "rgb=8,8,8 |
                            "  | 233 | Grey7 | ctermfg=233 | guifg=#121212 | "rgb=18,18,18 |
                            "  | 234 | Grey11 | ctermfg=234 | guifg=#1c1c1c | "rgb=28,28,28 |
                            "  | 235 | Grey15 | ctermfg=235 | guifg=#262626 | "rgb=38,38,38 |
                            "  | 236 | Grey19 | ctermfg=236 | guifg=#303030 | "rgb=48,48,48 |
                            "  | 237 | Grey23 | ctermfg=237 | guifg=#3a3a3a | "rgb=58,58,58 |
                            "  | 238 | Grey27 | ctermfg=238 | guifg=#444444 | "rgb=68,68,68 |
                            "  | 239 | Grey30 | ctermfg=239 | guifg=#4e4e4e | "rgb=78,78,78 |
                            "  | 240 | Grey35 | ctermfg=240 | guifg=#585858 | "rgb=88,88,88 |
                            "  | 241 | Grey39 | ctermfg=241 | guifg=#626262 | "rgb=98,98,98 |
                            "  | 242 | Grey42 | ctermfg=242 | guifg=#6c6c6c | "rgb=108,108,108 |
                            "  | 243 | Grey46 | ctermfg=243 | guifg=#767676 | "rgb=118,118,118 |
                            "  | 244 | Grey50 | ctermfg=244 | guifg=#808080 | "rgb=128,128,128 |
                            "  | 245 | Grey54 | ctermfg=245 | guifg=#8a8a8a | "rgb=138,138,138 |
                            "  | 246 | Grey58 | ctermfg=246 | guifg=#949494 | "rgb=148,148,148 |
                            "  | 247 | Grey62 | ctermfg=247 | guifg=#9e9e9e | "rgb=158,158,158 |
                            "  | 248 | Grey66 | ctermfg=248 | guifg=#a8a8a8 | "rgb=168,168,168 |
                            "  | 249 | Grey70 | ctermfg=249 | guifg=#b2b2b2 | "rgb=178,178,178 |
                            "  | 250 | Grey74 | ctermfg=250 | guifg=#bcbcbc | "rgb=188,188,188 |
                            "  | 251 | Grey78 | ctermfg=251 | guifg=#c6c6c6 | "rgb=198,198,198 |
                            "  | 252 | Grey82 | ctermfg=252 | guifg=#d0d0d0 | "rgb=208,208,208 |
                            "  | 253 | Grey85 | ctermfg=253 | guifg=#dadada | "rgb=218,218,218 |
                            "  | 254 | Grey89 | ctermfg=254 | guifg=#e4e4e4 | "rgb=228,228,228 |
                            "  | 255 | Grey93 | ctermfg=255 | guifg=#eeeeee | "rgb=238,238,238 |
                            
                            
                            " Initialisation:"{{{
                            " ----------------------------------------------------------------------------
                            " if !has("gui_running") && &t_Co < 256
    2              0.000013 if !has("gui_running") && &t_Co < 256
                              finish
                            endif
                            
    2              0.000005 if !exists("g:hybrid_use_Xresources")
    1              0.000002   let g:hybrid_use_Xresources = 0
    1              0.000001 endif
                            
    2              0.000004 if !exists("g:hybrid_use_iTerm_colors")
                              let g:hybrid_use_iTerm_colors = 0
                            endif
                            
    2              0.000003 if !exists("g:enable_bold_font")
                                let g:enable_bold_font = 0
                            endif
                            
    2              0.000074 set background=dark
    2              0.000281 hi clear
                            
    2              0.000007 if exists("syntax_on")
    1              0.000079   syntax reset
    1              0.000001 endif
                            
    2              0.000004 let colors_name = "hybrid_reverse"
    2              0.000007 execute "colorscheme " . colors_name
                            
                            "}}}
                            " GUI And Cterm Palettes:"{{{
                            " ----------------------------------------------------------------------------
                            " if has("gui_running") || ($NVIM_TUI_ENABLE_TRUE_COLOR && has("nvim"))
    2              0.000003   let s:vmode      = "gui"
    2              0.000003   let s:background = "#101010"
    2              0.000003   let s:foreground = "#c5c8c6"
                              " let s:foreground = "#b3b5b4"
    2              0.000003   let s:selection  = "#343941"
    2              0.000002   let s:line       = "#282a2e"
    2              0.000003   let s:comment    = "#707880"
    2              0.000002   let s:red        = "#cc6666"
    2              0.000002   let s:orange     = "#de935f"
    2              0.000002   let s:yellow     = "#f0c674"
    2              0.000002   let s:green      = "#a0a85c"
    2              0.000002   let s:aqua       = "#8abeb7"
    2              0.000004   let s:blue       = "#81a2be"
    2              0.000002   let s:purple     = "#b294bb"
    2              0.000002   let s:window     = "#303030"
    2              0.000003   let s:darkcolumn = "#1c1c1c"
    2              0.000002   let s:addbg      = "#5F875F"
    2              0.000002   let s:addfg      = "#d7ffaf"
    2              0.000002   let s:changebg   = "#5F5F87"
    2              0.000002   let s:changefg   = "#d7d7ff"
    2              0.000002   let s:darkblue   = "#00005f"
    2              0.000003   let s:darkcyan   = "#005f5f"
    2              0.000002   let s:darkred    = "#5f0000"
    2              0.000002   let s:darkpurple = "#5f005f"
    2              0.000002   let s:gray       = "#585858"
                              " let s:cyan       = "#81a2be"
    2              0.000002   let s:cyan       = "#92a7b9"
    2              0.000002   let s:darkbar    = "#292d34"
                            
                            
                            " else
                            "   let s:vmode      = "cterm"
                            "   let s:background = "234"
                            "   let s:window     = "236"
                            "   let s:darkcolumn = "234"
                            "   let s:addbg      = "65"
                            "   let s:addfg      = "193"
                            "   let s:changebg   = "60"
                            "   let s:changefg   = "189"
                            "   let s:darkblue   = "17"
                            "   let s:darkcyan   = "24"
                            "   let s:darkred    = "52"
                            "   let s:darkpurple = "53"
                            "   if g:hybrid_use_Xresources == 1
                            "     let s:foreground = "15"   " White
                            "     let s:selection  = "8"    " DarkGrey
                            "     let s:line       = "0"    " Black
                            "     let s:comment    = "7"    " LightGrey
                            "     let s:red        = "9"    " LightRed
                            "     let s:orange     = "3"    " DarkYellow
                            "     let s:yellow     = "11"   " LightYellow
                            "     let s:green      = "10"   " LightGreen
                            "     let s:aqua       = "14"   " LightCyan
                            "     let s:blue       = "12"   " LightBlue
                            "     let s:purple     = "13"   " LightMagenta
                            "   elseif g:hybrid_use_iTerm_colors == 1
                            "     let s:background = "8"
                            "     let s:foreground = "15"
                            "     let s:selection  = "13"
                            "     let s:line       = "0"
                            "     let s:comment    = "7"
                            "     let s:red        = "1"
                            "     let s:orange     = "9"
                            "     let s:yellow     = "3"
                            "     let s:green      = "2"
                            "     let s:aqua       = "6"
                            "     let s:blue       = "4"
                            "     let s:purple     = "5"
                            "     let s:darkcolumn = "11"
                            "     let s:addbg      = "10"
                            "     let s:changebg   = "12"
                            "   else
                            "     let s:foreground = "250"
                            "     let s:selection  = "237"
                            "     let s:line       = "235"
                            "     let s:comment    = "243"
                            "     let s:red        = "167"
                            "     let s:orange     = "173"
                            "     let s:yellow     = "221"
                            "     let s:green      = "143"
                            "     let s:aqua       = "109"
                            "     let s:blue       = "110"
                            "     let s:purple     = "139"
                            "   endif
                            " endif
                            
                            "}}}
                            " Formatting Options:"{{{
                            " ----------------------------------------------------------------------------
    2              0.000002 let s:none   = "NONE"
    2              0.000002 let s:t_none = "NONE"
    2              0.000002 let s:n      = "NONE"
    2              0.000002 let s:c      = ",undercurl"
    2              0.000002 let s:r      = ",reverse"
    2              0.000002 let s:s      = ",standout"
    2              0.000002 let s:b      = ",bold"
    2              0.000002 let s:u      = ",underline"
    2              0.000002 let s:i      = ",italic"
                            
                            "}}}
                            " Highlighting Primitives:"{{{
                            " ----------------------------------------------------------------------------
    2              0.000010 exe "let s:bg_none       = ' ".s:vmode."bg=".s:none      ."'"
    2              0.000009 exe "let s:bg_foreground = ' ".s:vmode."bg=".s:foreground."'"
    2              0.000008 exe "let s:bg_background = ' ".s:vmode."bg=".s:background."'"
    2              0.000008 exe "let s:bg_selection  = ' ".s:vmode."bg=".s:selection ."'"
    2              0.000007 exe "let s:bg_line       = ' ".s:vmode."bg=".s:line      ."'"
    2              0.000007 exe "let s:bg_comment    = ' ".s:vmode."bg=".s:comment   ."'"
    2              0.000008 exe "let s:bg_red        = ' ".s:vmode."bg=".s:red       ."'"
    2              0.000008 exe "let s:bg_orange     = ' ".s:vmode."bg=".s:orange    ."'"
    2              0.000008 exe "let s:bg_yellow     = ' ".s:vmode."bg=".s:yellow    ."'"
    2              0.000008 exe "let s:bg_green      = ' ".s:vmode."bg=".s:green     ."'"
    2              0.000008 exe "let s:bg_aqua       = ' ".s:vmode."bg=".s:aqua      ."'"
    2              0.000008 exe "let s:bg_blue       = ' ".s:vmode."bg=".s:blue      ."'"
    2              0.000008 exe "let s:bg_purple     = ' ".s:vmode."bg=".s:purple    ."'"
    2              0.000008 exe "let s:bg_window     = ' ".s:vmode."bg=".s:window    ."'"
    2              0.000008 exe "let s:bg_darkcolumn = ' ".s:vmode."bg=".s:darkcolumn."'"
    2              0.000009 exe "let s:bg_addbg      = ' ".s:vmode."bg=".s:addbg     ."'"
    2              0.000007 exe "let s:bg_addfg      = ' ".s:vmode."bg=".s:addfg     ."'"
    2              0.000008 exe "let s:bg_changebg   = ' ".s:vmode."bg=".s:changebg  ."'"
    2              0.000007 exe "let s:bg_changefg   = ' ".s:vmode."bg=".s:changefg  ."'"
    2              0.000007 exe "let s:bg_darkblue   = ' ".s:vmode."bg=".s:darkblue  ."'"
    2              0.000007 exe "let s:bg_darkcyan   = ' ".s:vmode."bg=".s:darkcyan  ."'"
    2              0.000007 exe "let s:bg_darkred    = ' ".s:vmode."bg=".s:darkred   ."'"
    2              0.000007 exe "let s:bg_darkpurple = ' ".s:vmode."bg=".s:darkpurple."'"
    2              0.000007 exe "let s:bg_gray       = ' ".s:vmode."bg=".s:gray      ."'"
    2              0.000007 exe "let s:bg_cyan       = ' ".s:vmode."bg=".s:cyan      ."'"
    2              0.000007 exe "let s:bg_darkbar    = ' ".s:vmode."bg=".s:darkbar   ."'"
                            
    2              0.000007 exe "let s:fg_none       = ' ".s:vmode."fg=".s:none      ."'"
    2              0.000007 exe "let s:fg_foreground = ' ".s:vmode."fg=".s:foreground."'"
    2              0.000007 exe "let s:fg_background = ' ".s:vmode."fg=".s:background."'"
    2              0.000008 exe "let s:fg_selection  = ' ".s:vmode."fg=".s:selection ."'"
    2              0.000007 exe "let s:fg_line       = ' ".s:vmode."fg=".s:line      ."'"
    2              0.000007 exe "let s:fg_comment    = ' ".s:vmode."fg=".s:comment   ."'"
    2              0.000010 exe "let s:fg_red        = ' ".s:vmode."fg=".s:red       ."'"
    2              0.000007 exe "let s:fg_orange     = ' ".s:vmode."fg=".s:orange    ."'"
    2              0.000007 exe "let s:fg_yellow     = ' ".s:vmode."fg=".s:yellow    ."'"
    2              0.000007 exe "let s:fg_green      = ' ".s:vmode."fg=".s:green     ."'"
    2              0.000007 exe "let s:fg_aqua       = ' ".s:vmode."fg=".s:aqua      ."'"
    2              0.000008 exe "let s:fg_blue       = ' ".s:vmode."fg=".s:blue      ."'"
    2              0.000007 exe "let s:fg_purple     = ' ".s:vmode."fg=".s:purple    ."'"
    2              0.000007 exe "let s:fg_window     = ' ".s:vmode."fg=".s:window    ."'"
    2              0.000008 exe "let s:fg_darkcolumn = ' ".s:vmode."fg=".s:darkcolumn."'"
    2              0.000007 exe "let s:fg_addbg      = ' ".s:vmode."fg=".s:addbg     ."'"
    2              0.000007 exe "let s:fg_addfg      = ' ".s:vmode."fg=".s:addfg     ."'"
    2              0.000007 exe "let s:fg_changebg   = ' ".s:vmode."fg=".s:changebg  ."'"
    2              0.000007 exe "let s:fg_changefg   = ' ".s:vmode."fg=".s:changefg  ."'"
    2              0.000007 exe "let s:fg_darkblue   = ' ".s:vmode."fg=".s:darkblue  ."'"
    2              0.000008 exe "let s:fg_darkcyan   = ' ".s:vmode."fg=".s:darkcyan  ."'"
    2              0.000007 exe "let s:fg_darkred    = ' ".s:vmode."fg=".s:darkred   ."'"
    2              0.000008 exe "let s:fg_darkpurple = ' ".s:vmode."fg=".s:darkpurple."'"
    2              0.000007 exe "let s:fg_gray       = ' ".s:vmode."fg=".s:gray      ."'"
    2              0.000007 exe "let s:fg_cyan       = ' ".s:vmode."fg=".s:cyan      ."'"
    2              0.000007 exe "let s:fg_darkbar    = ' ".s:vmode."fg=".s:darkbar   ."'"
                            
    2              0.000008 exe "let s:fmt_none      = ' ".s:vmode."=NONE".          " term=NONE"        ."'"
    2              0.000010 exe "let s:fmt_bold      = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b    ."'"
    2              0.000009 exe "let s:fmt_bldi      = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b    ."'"
    2              0.000009 exe "let s:fmt_undr      = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u    ."'"
    2              0.000011 exe "let s:fmt_undb      = ' ".s:vmode."=NONE".s:u.s:b.  " term=NONE".s:u.s:b."'"
    2              0.000009 exe "let s:fmt_undi      = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u    ."'"
    2              0.000009 exe "let s:fmt_curl      = ' ".s:vmode."=NONE".s:c.      " term=NONE".s:c    ."'"
    2              0.000009 exe "let s:fmt_ital      = ' ".s:vmode."=NONE".s:i.      " term=NONE".s:i    ."'"
    2              0.000009 exe "let s:fmt_stnd      = ' ".s:vmode."=NONE".s:s.      " term=NONE".s:s    ."'"
    2              0.000008 exe "let s:fmt_revr      = ' ".s:vmode."=NONE".s:r.      " term=NONE".s:r    ."'"
    2              0.000010 exe "let s:fmt_revb      = ' ".s:vmode."=NONE".s:r.s:b.  " term=NONE".s:r.s:b."'"
                            
    2              0.000006 if has("gui_running")
                              exe "let s:sp_none       = ' guisp=".s:none      ."'"
                              exe "let s:sp_foreground = ' guisp=".s:foreground."'"
                              exe "let s:sp_background = ' guisp=".s:background."'"
                              exe "let s:sp_selection  = ' guisp=".s:selection ."'"
                              exe "let s:sp_line       = ' guisp=".s:line      ."'"
                              exe "let s:sp_comment    = ' guisp=".s:comment   ."'"
                              exe "let s:sp_red        = ' guisp=".s:red       ."'"
                              exe "let s:sp_orange     = ' guisp=".s:orange    ."'"
                              exe "let s:sp_yellow     = ' guisp=".s:yellow    ."'"
                              exe "let s:sp_green      = ' guisp=".s:green     ."'"
                              exe "let s:sp_aqua       = ' guisp=".s:aqua      ."'"
                              exe "let s:sp_blue       = ' guisp=".s:blue      ."'"
                              exe "let s:sp_purple     = ' guisp=".s:purple    ."'"
                              exe "let s:sp_window     = ' guisp=".s:window    ."'"
                              exe "let s:sp_addbg      = ' guisp=".s:addbg     ."'"
                              exe "let s:sp_addfg      = ' guisp=".s:addfg     ."'"
                              exe "let s:sp_changebg   = ' guisp=".s:changebg  ."'"
                              exe "let s:sp_changefg   = ' guisp=".s:changefg  ."'"
                              exe "let s:sp_darkblue   = ' guisp=".s:darkblue  ."'"
                              exe "let s:sp_darkcyan   = ' guisp=".s:darkcyan  ."'"
                              exe "let s:sp_darkred    = ' guisp=".s:darkred   ."'"
                              exe "let s:sp_darkpurple = ' guisp=".s:darkpurple."'"
                            else
    2              0.000003   let s:sp_none       = ""
    2              0.000003   let s:sp_foreground = ""
    2              0.000002   let s:sp_background = ""
    2              0.000002   let s:sp_selection  = ""
    2              0.000002   let s:sp_line       = ""
    2              0.000002   let s:sp_comment    = ""
    2              0.000002   let s:sp_red        = ""
    2              0.000002   let s:sp_orange     = ""
    2              0.000002   let s:sp_yellow     = ""
    2              0.000002   let s:sp_green      = ""
    2              0.000002   let s:sp_aqua       = ""
    2              0.000002   let s:sp_blue       = ""
    2              0.000005   let s:sp_purple     = ""
    2              0.000002   let s:sp_window     = ""
    2              0.000002   let s:sp_addbg      = ""
    2              0.000002   let s:sp_addfg      = ""
    2              0.000002   let s:sp_changebg   = ""
    2              0.000002   let s:sp_changefg   = ""
    2              0.000002   let s:sp_darkblue   = ""
    2              0.000002   let s:sp_darkcyan   = ""
    2              0.000002   let s:sp_darkred    = ""
    2              0.000003   let s:sp_darkpurple = ""
    2              0.000001 endif
                            
                            " Set bold font depending on options
    2              0.000003 if g:enable_bold_font == 1
    2              0.000003     let s:fg_bold = s:fmt_bold
    2              0.000001 else
                                let s:fg_bold = s:fmt_none
                            endif
                            
                            "}}}
                            
                            " Vim Highlighting: (see :help highlight-groups)"{{{
                            " ColorColumn
                            " Conceal
                            " Cursor
                            " CursorIM
                            " CursorColumn
                            " CursorLine
                            " Directory
                            " DiffAdd
                            " DiffChange
                            " DiffDelete
                            " DiffText
                            " EndOfBuffer
                            " TermCursor
                            " TermCursorNC
                            " ErrorMsg
                            " VertSplit
                            " Folded
                            " FoldColumn
                            " SignColumn
                            " IncSearch
                            " LineNr
                            " CursorLineNr
                            " MatchParen
                            " ModeMsg
                            " MoreMsg
                            " NonText
                            " Normal
                            " Pmenu
                            " PmenuSel
                            " PmenuSbar
                            " PmenuThumb
                            " Question
                            " Search
                            " SpecialKey
                            " SpellBad
                            " SpellCap
                            " SpellLocal
                            " SpellRare
                            " StatusLine
                            " StatusLineNC
                            " TabLine
                            " TabLineFill
                            " TabLineSel
                            " Title
                            " Visual
                            " VisualNOS
                            " WarningMsg
                            " WildMenu
                            
                            " GUI only
                            " Menu
                            " Scrollbar
                            " Tooltip
                            " ----------------------------------------------------------------------------
    2              0.000016 exe "hi! ColorColumn"   .s:fg_none        .s:bg_line        .s:fmt_none
                            " exe "hi! Conceal"       .s:fg_none        .s:bg_line        .s:fmt_none
                            " exe "hi! Cursor"        .s:fg_none        .s:bg_red        .s:fmt_none
                            " exe "hi! lCursor"        .s:fg_none        .s:bg_red        .s:fmt_none
                            " exe "hi! CursorIM"      .s:fg_none        .s:bg_line        .s:fmt_none
    2              0.000010 exe "hi! CursorColumn"  .s:fg_none        .s:bg_line        .s:fmt_none
    2              0.000009 exe "hi! CursorLine"    .s:fg_none        .s:bg_line        .s:fmt_none
    2              0.000010 exe "hi! Directory"     .s:fg_blue        .s:bg_none        .s:fmt_none
    2              0.000010 exe "hi! DiffAdd"       .s:fg_addfg       .s:bg_addbg       .s:fmt_none
    2              0.000010 exe "hi! DiffChange"    .s:fg_changefg    .s:bg_changebg    .s:fmt_none
    2              0.000010 exe "hi! DiffDelete"    .s:fg_background  .s:bg_red         .s:fmt_none
    2              0.000010 exe "hi! DiffText"      .s:fg_background  .s:bg_blue        .s:fmt_none
                            " exe "hi! EndOfBuffer"   .s:fg_background  .s:bg_blue        .s:fmt_none
                            " exe "hi! TermCursor"    .s:fg_background  .s:bg_blue        .s:fmt_none
                            " exe "hi! TermCursorNC"  .s:fg_background  .s:bg_blue        .s:fmt_none
    2              0.000012 exe "hi! ErrorMsg"      .s:fg_background  .s:bg_red         .s:fmt_stnd
    2              0.000010 exe "hi! VertSplit"     .s:fg_window      .s:bg_none        .s:fmt_none
    2              0.000010 exe "hi! Folded"        .s:fg_comment     .s:bg_darkcolumn  .s:fmt_none
    2              0.000009 exe "hi! FoldColumn"    .s:fg_none        .s:bg_darkcolumn  .s:fmt_none
    2              0.000009 exe "hi! SignColumn"    .s:fg_none        .s:bg_darkcolumn  .s:fmt_none
                            " exe "hi! Incsearch"     .s:fg_none        .s:bg_darkcolumn  .s:fmt_none
    2              0.000009 exe "hi! LineNr"        .s:fg_selection   .s:bg_none        .s:fmt_none
    2              0.000011 exe "hi! CursorLineNr"  .s:fg_yellow      .s:bg_none        .s:fmt_bold
    2              0.000010 exe "hi! MatchParen"    .s:fg_background  .s:bg_changebg    .s:fmt_none
    2              0.000009 exe "hi! ModeMsg"       .s:fg_green       .s:bg_none        .s:fmt_none
    2              0.000009 exe "hi! MoreMsg"       .s:fg_green       .s:bg_none        .s:fmt_none
    2              0.000009 exe "hi! NonText"       .s:fg_selection   .s:bg_none        .s:fmt_none
    2              0.000011 exe "hi! Normal"        .s:fg_foreground  .s:bg_none        .s:fmt_none
    2              0.000010 exe "hi! Pmenu"         .s:fg_foreground  .s:bg_darkbar     .s:fmt_none
    2              0.000012 exe "hi! PmenuSel"      .s:fg_foreground  .s:bg_selection   .s:fmt_revr
    2              0.000010 exe "hi! PmenuSbar"     .s:fg_background  .s:bg_gray        .s:fmt_none
                            " exe "hi! PmenuThumb"    .s:fg_foreground  .s:bg_selection   .s:fmt_none
    2              0.000009 exe "hi! Question"      .s:fg_green       .s:bg_none        .s:fmt_none
    2              0.000009 exe "hi! Search"        .s:fg_none        .s:bg_selection   .s:fmt_none
    2              0.000009 exe "hi! SpecialKey"    .s:fg_selection   .s:bg_none        .s:fmt_none
    2              0.000011 exe "hi! SpellBad"      .s:fg_red         .s:bg_darkred     .s:fmt_undr
    2              0.000011 exe "hi! SpellCap"      .s:fg_blue        .s:bg_darkblue    .s:fmt_undr
    2              0.000011 exe "hi! SpellLocal"    .s:fg_aqua        .s:bg_darkcyan    .s:fmt_undr
    2              0.000011 exe "hi! SpellRare"     .s:fg_purple      .s:bg_darkpurple  .s:fmt_undr
    2              0.000011 exe "hi! StatusLine"    .s:fg_comment     .s:bg_background  .s:fmt_revr
    2              0.000010 exe "hi! StatusLineNC"  .s:fg_window      .s:bg_comment     .s:fmt_revr
    2              0.000010 exe "hi! TabLine"       .s:fg_foreground  .s:bg_line        .s:fmt_none
    2              0.000009 exe "hi! TabLineFill"   .s:fg_line        .s:bg_window      .s:fmt_none
    2              0.000009 exe "hi! TabLineSel"    .s:fg_foreground  .s:bg_gray        .s:fmt_none
    2              0.000009 exe "hi! Title"         .s:fg_yellow      .s:bg_none        .s:fmt_none
    2              0.000013 exe "hi! Visual"        .s:fg_none        .s:bg_selection   .s:fmt_none
    2              0.000010 exe "hi! VisualNos"     .s:fg_none        .s:bg_selection   .s:fmt_none
    2              0.000010 exe "hi! WarningMsg"    .s:fg_red         .s:bg_none        .s:fmt_none
    2              0.000010 exe "hi! WildMenu"      .s:fg_red         .s:bg_none        .s:fmt_none
                            
                            "}}}
                            " Generic Syntax Highlighting: (see :help group-name)"{{{
                            " ----------------------------------------------------------------------------
    2              0.000010 exe "hi! Comment"         .s:fg_comment     .s:bg_none        .s:fmt_none
                            
    2              0.000009 exe "hi! Constant"        .s:fg_purple      .s:bg_none        .s:fmt_none
    2              0.000010 exe "hi! String"          .s:fg_green       .s:bg_none        .s:fmt_none
                            "		Character"
                            "		Number"
                            "		Boolean"
                            "		Float"
                            
    2              0.000010 exe "hi! Identifier"      .s:fg_red         .s:bg_none        .s:fmt_none
    2              0.000011 exe "hi! Function"        .s:fg_yellow      .s:bg_none        .s:fg_bold
                            
    2              0.000010 exe "hi! Statement"       .s:fg_blue        .s:bg_none        .s:fg_bold
                            "		Conditional"
                            "		Repeat"
                            "		Label"
    2              0.000010 exe "hi! Operator"        .s:fg_aqua        .s:bg_none        .s:fmt_none
                            "		Keyword"
                            "		Exception"
                            
    2              0.000010 exe "hi! PreProc"         .s:fg_aqua        .s:bg_none        .s:fg_bold
                            "		Include"
                            "		Define"
                            "		Macro"
                            "		PreCondit"
                            
    2              0.000011 exe "hi! Type"            .s:fg_orange      .s:bg_none        .s:fg_bold
                            "		StorageClass"
    2              0.000009 exe "hi! Structure"       .s:fg_aqua        .s:bg_none        .s:fmt_none
                            "		Typedef"
                            
    2              0.000011 exe "hi! Special"         .s:fg_green       .s:bg_none        .s:fmt_none
                            "		SpecialChar"
                            "		Tag"
                            "		Delimiter"
                            "		SpecialComment"
                            "		Debug"
                            "
    2              0.000009 exe "hi! Underlined"      .s:fg_blue        .s:bg_none        .s:fmt_none
                            
    2              0.000011 exe "hi! Ignore"          .s:fg_none        .s:bg_none        .s:fmt_none
                            
    2              0.000011 exe "hi! Error"           .s:fg_purple      .s:bg_darkred     .s:fmt_undr
                            
    2              0.000010 exe "hi! Todo"            .s:fg_addfg       .s:bg_none        .s:fg_bold
                            
                            " Quickfix window highlighting
    2              0.000010 exe "hi! qfLineNr"        .s:fg_yellow      .s:bg_none        .s:fmt_none
                            "   qfFileName"
                            "   qfLineNr"
                            "   qfError"
                            
                            "}}}
                            " Diff Syntax Highlighting:"{{{
                            " ----------------------------------------------------------------------------
                            " Diff
                            "		diffOldFile
                            "		diffNewFile
                            "		diffFile
                            "		diffOnly
                            "		diffIdentical
                            "		diffDiffer
                            "		diffBDiffer
                            "		diffIsA
                            "		diffNoEOL
                            "		diffCommon
    2              0.000003 hi! link diffRemoved Constant
                            "		diffChanged
    2              0.000003 hi! link diffAdded Special
                            "		diffLine
                            "		diffSubname
                            "		diffComment
                            
                            "}}}
                            " Legal:"{{{
                            " ----------------------------------------------------------------------------
                            " Copyright (c) 2011 Ethan Schoonover
                            " Copyright (c) 2009-2012 NanoTech
                            " Copyright (c) 2012 w0ng
                            "
                            " Permission is hereby granted, free of charge, to any per‐
                            " son obtaining a copy of this software and associated doc‐
                            " umentation files (the “Software”), to deal in the Soft‐
                            " ware without restriction, including without limitation
                            " the rights to use, copy, modify, merge, publish, distrib‐
                            " ute, sublicense, and/or sell copies of the Software, and
                            " to permit persons to whom the Software is furnished to do
                            " so, subject to the following conditions:
                            "
                            " The above copyright notice and this permission notice
                            " shall be included in all copies or substantial portions
                            " of the Software.
                            "
                            " THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
                            " KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
                            " THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICU‐
                            " LAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                            " AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
                            " DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CON‐
                            " TRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CON‐
                            " NECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
                            " THE SOFTWARE.
                            
                            " }}}

SCRIPT  /usr/local/share/nvim/runtime/syntax/syntax.vim
Sourced 1 time
Total time:   0.001758
 Self time:   0.000121

count  total (s)   self (s)
                            " Vim syntax support file
                            " Maintainer:	Bram Moolenaar <Bram@vim.org>
                            " Last Change:	2001 Sep 04
                            
                            " This file is used for ":syntax on".
                            " It installs the autocommands and starts highlighting for all buffers.
                            
    1              0.000004 if !has("syntax")
                              finish
                            endif
                            
                            " If Syntax highlighting appears to be on already, turn it off first, so that
                            " any leftovers are cleared.
    1              0.000003 if exists("syntax_on") || exists("syntax_manual")
                              so <sfile>:p:h/nosyntax.vim
                            endif
                            
                            " Load the Syntax autocommands and set the default methods for highlighting.
    1              0.000076 runtime syntax/synload.vim
                            
                            " Load the FileType autocommands if not done yet.
    1              0.000002 if exists("did_load_filetypes")
    1              0.000001   let s:did_ft = 1
    1              0.000001 else
                              filetype on
                              let s:did_ft = 0
                            endif
                            
                            " Set up the connection between FileType and Syntax autocommands.
                            " This makes the syntax automatically set when the file type is detected.
    1              0.000001 augroup syntaxset
    1              0.000004   au! FileType *	exe "set syntax=" . expand("<amatch>")
    1              0.000001 augroup END
                            
                            
                            " Execute the syntax autocommands for the each buffer.
                            " If the filetype wasn't detected yet, do that now.
                            " Always do the syntaxset autocommands, for buffers where the 'filetype'
                            " already was set manually (e.g., help buffers).
    1              0.000004 doautoall syntaxset FileType
    1              0.000001 if !s:did_ft
                              doautoall filetypedetect BufRead
                            endif

SCRIPT  /usr/local/share/nvim/runtime/syntax/synload.vim
Sourced 1 time
Total time:   0.001631
 Self time:   0.000122

count  total (s)   self (s)
                            " Vim syntax support file
                            " Maintainer:	Bram Moolenaar <Bram@vim.org>
                            " Last Change:	2012 Sep 25
                            
                            " This file sets up for syntax highlighting.
                            " It is loaded from "syntax.vim" and "manual.vim".
                            " 1. Set the default highlight groups.
                            " 2. Install Syntax autocommands for all the available syntax files.
                            
    1              0.000003 if !has("syntax")
                              finish
                            endif
                            
                            " let others know that syntax has been switched on
    1              0.000002 let syntax_on = 1
                            
                            " Set the default highlighting colors.  Use a color scheme if specified.
    1              0.000002 if exists("colors_name")
    1              0.000039   exe "colors " . colors_name
    1              0.000001 else
                              runtime! syntax/syncolor.vim
                            endif
                            
                            " Line continuation is used here, remove 'C' from 'cpoptions'
    1              0.000003 let s:cpo_save = &cpo
    1              0.000003 set cpo&vim
                            
                            " First remove all old syntax autocommands.
    1              0.000002 au! Syntax
                            
    1              0.000004 au Syntax *		call s:SynSet()
                            
    1              0.000002 fun! s:SynSet()
                              " clear syntax for :set syntax=OFF  and any syntax name that doesn't exist
                              syn clear
                              if exists("b:current_syntax")
                                unlet b:current_syntax
                              endif
                            
                              let s = expand("<amatch>")
                              if s == "ON"
                                " :set syntax=ON
                                if &filetype == ""
                                  echohl ErrorMsg
                                  echo "filetype unknown"
                                  echohl None
                                endif
                                let s = &filetype
                              elseif s == "OFF"
                                let s = ""
                              endif
                            
                              if s != ""
                                " Load the syntax file(s).  When there are several, separated by dots,
                                " load each in sequence.
                                for name in split(s, '\.')
                                  exe "runtime! syntax/" . name . ".vim syntax/" . name . "/*.vim"
                                endfor
                              endif
                            endfun
                            
                            
                            " Handle adding doxygen to other languages (C, C++, C#, IDL)
    1              0.000010 au Syntax c,cpp,cs,idl,php
                            	\ if (exists('b:load_doxygen_syntax') && b:load_doxygen_syntax)
                            	\	|| (exists('g:load_doxygen_syntax') && g:load_doxygen_syntax)
                            	\   | runtime! syntax/doxygen.vim
                            	\ | endif
                            
                            
                            " Source the user-specified syntax highlighting file
    1              0.000004 if exists("mysyntaxfile") && filereadable(expand(mysyntaxfile))
                              execute "source " . mysyntaxfile
                            endif
                            
                            " Restore 'cpoptions'
    1              0.000004 let &cpo = s:cpo_save
    1              0.000003 unlet s:cpo_save

SCRIPT  /usr/local/share/nvim/runtime/syntax/syncolor.vim
Sourced 2 times
Total time:   0.000306
 Self time:   0.000306

count  total (s)   self (s)
                            " Vim syntax support file
                            " Maintainer:	Bram Moolenaar <Bram@vim.org>
                            " Last Change:	2001 Sep 12
                            
                            " This file sets up the default methods for highlighting.
                            " It is loaded from "synload.vim" and from Vim for ":syntax reset".
                            " Also used from init_highlight().
                            
    2              0.000008 if !exists("syntax_cmd") || syntax_cmd == "on"
                              " ":syntax on" works like in Vim 5.7: set colors but keep links
                              command -nargs=* SynColor hi <args>
                              command -nargs=* SynLink hi link <args>
                            else
    2              0.000003   if syntax_cmd == "enable"
                                " ":syntax enable" keeps any existing colors
    1              0.000007     command -nargs=* SynColor hi def <args>
    1              0.000003     command -nargs=* SynLink hi def link <args>
    1              0.000001   elseif syntax_cmd == "reset"
                                " ":syntax reset" resets all colors to the default
    1              0.000003     command -nargs=* SynColor hi <args>
    1              0.000003     command -nargs=* SynLink hi! link <args>
    1              0.000001   else
                                " User defined syncolor file has already set the colors.
                                finish
                              endif
    2              0.000001 endif
                            
                            " Many terminals can only use six different colors (plus black and white).
                            " Therefore the number of colors used is kept low. It doesn't look nice with
                            " too many colors anyway.
                            " Careful with "cterm=bold", it changes the color to bright for some terminals.
                            " There are two sets of defaults: for a dark and a light background.
    2              0.000003 if &background == "dark"
    2              0.000016   SynColor Comment	term=bold cterm=NONE ctermfg=Cyan ctermbg=NONE gui=NONE guifg=#80a0ff guibg=NONE
    2              0.000010   SynColor Constant	term=underline cterm=NONE ctermfg=Magenta ctermbg=NONE gui=NONE guifg=#ffa0a0 guibg=NONE
    2              0.000009   SynColor Special	term=bold cterm=NONE ctermfg=LightRed ctermbg=NONE gui=NONE guifg=Orange guibg=NONE
    2              0.000008   SynColor Identifier	term=underline cterm=bold ctermfg=Cyan ctermbg=NONE gui=NONE guifg=#40ffff guibg=NONE
    2              0.000009   SynColor Statement	term=bold cterm=NONE ctermfg=Yellow ctermbg=NONE gui=bold guifg=#ffff60 guibg=NONE
    2              0.000008   SynColor PreProc	term=underline cterm=NONE ctermfg=LightBlue ctermbg=NONE gui=NONE guifg=#ff80ff guibg=NONE
    2              0.000009   SynColor Type		term=underline cterm=NONE ctermfg=LightGreen ctermbg=NONE gui=bold guifg=#60ff60 guibg=NONE
    2              0.000008   SynColor Underlined	term=underline cterm=underline ctermfg=LightBlue gui=underline guifg=#80a0ff
    2              0.000013   SynColor Ignore	term=NONE cterm=NONE ctermfg=black ctermbg=NONE gui=NONE guifg=bg guibg=NONE
    2              0.000001 else
                              SynColor Comment	term=bold cterm=NONE ctermfg=DarkBlue ctermbg=NONE gui=NONE guifg=Blue guibg=NONE
                              SynColor Constant	term=underline cterm=NONE ctermfg=DarkRed ctermbg=NONE gui=NONE guifg=Magenta guibg=NONE
                              SynColor Special	term=bold cterm=NONE ctermfg=DarkMagenta ctermbg=NONE gui=NONE guifg=SlateBlue guibg=NONE
                              SynColor Identifier	term=underline cterm=NONE ctermfg=DarkCyan ctermbg=NONE gui=NONE guifg=DarkCyan guibg=NONE
                              SynColor Statement	term=bold cterm=NONE ctermfg=Brown ctermbg=NONE gui=bold guifg=Brown guibg=NONE
                              SynColor PreProc	term=underline cterm=NONE ctermfg=DarkMagenta ctermbg=NONE gui=NONE guifg=Purple guibg=NONE
                              SynColor Type		term=underline cterm=NONE ctermfg=DarkGreen ctermbg=NONE gui=bold guifg=SeaGreen guibg=NONE
                              SynColor Underlined	term=underline cterm=underline ctermfg=DarkMagenta gui=underline guifg=SlateBlue
                              SynColor Ignore	term=NONE cterm=NONE ctermfg=white ctermbg=NONE gui=NONE guifg=bg guibg=NONE
                            endif
    2              0.000011 SynColor Error		term=reverse cterm=NONE ctermfg=White ctermbg=Red gui=NONE guifg=White guibg=Red
    2              0.000011 SynColor Todo		term=standout cterm=NONE ctermfg=Black ctermbg=Yellow gui=NONE guifg=Blue guibg=Yellow
                            
                            " Common groups that link to default highlighting.
                            " You can specify other highlighting easily.
    2              0.000005 SynLink String		Constant
    2              0.000005 SynLink Character	Constant
    2              0.000004 SynLink Number		Constant
    2              0.000004 SynLink Boolean		Constant
    2              0.000004 SynLink Float		Number
    2              0.000004 SynLink Function	Identifier
    2              0.000005 SynLink Conditional	Statement
    2              0.000006 SynLink Repeat		Statement
    2              0.000004 SynLink Label		Statement
    2              0.000004 SynLink Operator	Statement
    2              0.000004 SynLink Keyword		Statement
    2              0.000004 SynLink Exception	Statement
    2              0.000004 SynLink Include		PreProc
    2              0.000004 SynLink Define		PreProc
    2              0.000004 SynLink Macro		PreProc
    2              0.000005 SynLink PreCondit	PreProc
    2              0.000004 SynLink StorageClass	Type
    2              0.000004 SynLink Structure	Type
    2              0.000004 SynLink Typedef		Type
    2              0.000004 SynLink Tag		Special
    2              0.000004 SynLink SpecialChar	Special
    2              0.000004 SynLink Delimiter	Special
    2              0.000004 SynLink SpecialComment	Special
    2              0.000004 SynLink Debug		Special
                            
    2              0.000002 delcommand SynColor
    2              0.000004 delcommand SynLink

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/deoplete/custom.vim
Sourced 1 time
Total time:   0.000037
 Self time:   0.000037

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: custom.vim
                            " AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 function! deoplete#custom#get(source_name) abort "{{{
                              let source = copy(deoplete#custom#get_source_var(a:source_name))
                              return extend(source, s:custom._, 'keep')
                            endfunction"}}}
                            
    1              0.000002 function! deoplete#custom#get_source_var(source_name) abort "{{{
                              if !exists('s:custom')
                                let s:custom = {}
                                let s:custom._ = {}
                              endif
                            
                              if !has_key(s:custom, a:source_name)
                                let s:custom[a:source_name] = {}
                              endif
                            
                              return s:custom[a:source_name]
                            endfunction"}}}
                            
    1              0.000002 function! deoplete#custom#set(source_name, option_name, value) abort "{{{
                              for key in split(a:source_name, '\s*,\s*')
                                let custom_source = deoplete#custom#get_source_var(key)
                                let custom_source[a:option_name] = a:value
                              endfor
                            endfunction"}}}
                            
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/section.vim
Sourced 1 time
Total time:   0.001003
 Self time:   0.000138

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000071 call airline#init#bootstrap()
    1              0.000002 let s:spc = g:airline_symbols.space
                            
    1              0.000002 function! s:wrap_accent(part, value)
                              if exists('a:part.accent')
                                call airline#highlighter#add_accent(a:part.accent)
                                return '%#__accent_'.(a:part.accent).'#'.a:value.'%#__restore__#'
                              endif
                              return a:value
                            endfunction
                            
    1              0.000002 function! s:create(parts, append)
                              let _ = ''
                              for idx in range(len(a:parts))
                                let part = airline#parts#get(a:parts[idx])
                                let val = ''
                            
                                if exists('part.function')
                                  let func = (part.function).'()'
                                elseif exists('part.text')
                                  let func = '"'.(part.text).'"'
                                else
                                  if a:append > 0 && idx != 0
                                    let val .= s:spc.g:airline_left_alt_sep.s:spc
                                  endif
                                  if a:append < 0 && idx != 0
                                    let val = s:spc.g:airline_right_alt_sep.s:spc.val
                                  endif
                                  if exists('part.raw')
                                    let _ .= s:wrap_accent(part, val.(part.raw))
                                    continue
                                  else
                                    let _ .= s:wrap_accent(part, val.a:parts[idx])
                                    continue
                                  endif
                                endif
                            
                                let minwidth = get(part, 'minwidth', 0)
                            
                                if a:append > 0 && idx != 0
                                  let partval = printf('%%{airline#util#append(%s,%s)}', func, minwidth)
                                elseif a:append < 0 && idx != len(a:parts) - 1
                                  let partval = printf('%%{airline#util#prepend(%s,%s)}', func, minwidth)
                                else
                                  let partval = printf('%%{airline#util#wrap(%s,%s)}', func, minwidth)
                                endif
                            
                                if exists('part.condition')
                                  let partval = substitute(partval, '{', '\="{".(part.condition)." ? "', '')
                                  let partval = substitute(partval, '}', ' : ""}', '')
                                endif
                            
                                let val .= s:wrap_accent(part, partval)
                                let _ .= val
                              endfor
                              return _
                            endfunction
                            
    1              0.000002 function! airline#section#create(parts)
                              return s:create(a:parts, 0)
                            endfunction
                            
    1              0.000002 function! airline#section#create_left(parts)
                              return s:create(a:parts, 1)
                            endfunction
                            
    1              0.000002 function! airline#section#create_right(parts)
                              return s:create(a:parts, -1)
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/init.vim
Sourced 1 time
Total time:   0.000084
 Self time:   0.000084

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000003 function! s:check_defined(variable, default)
                              if !exists(a:variable)
                                let {a:variable} = a:default
                              endif
                            endfunction
                            
    1              0.000002 let s:loaded = 0
    1              0.000002 function! airline#init#bootstrap()
                              if s:loaded
                                return
                              endif
                              let s:loaded = 1
                            
                              let g:airline#init#bootstrapping = 1
                              call s:check_defined('g:airline_left_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b0":">")
                              call s:check_defined('g:airline_left_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b1":">")
                              call s:check_defined('g:airline_right_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b2":"<")
                              call s:check_defined('g:airline_right_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b3":"<")
                              call s:check_defined('g:airline_detect_modified', 1)
                              call s:check_defined('g:airline_detect_paste', 1)
                              call s:check_defined('g:airline_detect_crypt', 1)
                              call s:check_defined('g:airline_detect_iminsert', 0)
                              call s:check_defined('g:airline_inactive_collapse', 1)
                              call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
                              call s:check_defined('g:airline_exclude_filetypes', [])
                              call s:check_defined('g:airline_exclude_preview', 0)
                              call s:check_defined('g:airline_gui_mode', airline#init#gui_mode())
                            
                              call s:check_defined('g:airline_mode_map', {})
                              call extend(g:airline_mode_map, {
                                    \ '__' : '------',
                                    \ 'n'  : 'NORMAL',
                                    \ 'i'  : 'INSERT',
                                    \ 'R'  : 'REPLACE',
                                    \ 'v'  : 'VISUAL',
                                    \ 'V'  : 'V-LINE',
                                    \ 'c'  : 'COMMAND',
                                    \ '' : 'V-BLOCK',
                                    \ 's'  : 'SELECT',
                                    \ 'S'  : 'S-LINE',
                                    \ '' : 'S-BLOCK',
                                    \ 't'  : 'TERMINAL',
                                    \ }, 'keep')
                            
                              call s:check_defined('g:airline_theme_map', {})
                              call extend(g:airline_theme_map, {
                                    \ '\CTomorrow': 'tomorrow',
                                    \ 'base16': 'base16',
                                    \ 'mo[l|n]okai': 'molokai',
                                    \ 'wombat': 'wombat',
                                    \ 'zenburn': 'zenburn',
                                    \ 'solarized': 'solarized',
                                    \ }, 'keep')
                            
                              call s:check_defined('g:airline_symbols', {})
                              call extend(g:airline_symbols, {
                                    \ 'paste': 'PASTE',
                                    \ 'readonly': get(g:, 'airline_powerline_fonts', 0) ? "\ue0a2" : 'RO',
                                    \ 'whitespace': get(g:, 'airline_powerline_fonts', 0) ? "\u2739" : '!',
                                    \ 'linenr': get(g:, 'airline_powerline_fonts', 0) ? "\ue0a1" : ':',
                                    \ 'branch': get(g:, 'airline_powerline_fonts', 0) ? "\ue0a0" : '',
                                    \ 'notexists': "\u2204",
                                    \ 'modified': '+',
                                    \ 'space': ' ',
                                    \ 'crypt': get(g:, 'airline_crypt_symbol', nr2char(0x1F512)),
                                    \ }, 'keep')
                            
                              call airline#parts#define('mode', {
                                    \ 'function': 'airline#parts#mode',
                                    \ 'accent': 'bold',
                                    \ })
                              call airline#parts#define_function('iminsert', 'airline#parts#iminsert')
                              call airline#parts#define_function('paste', 'airline#parts#paste')
                              call airline#parts#define_function('crypt', 'airline#parts#crypt')
                              call airline#parts#define_function('filetype', 'airline#parts#filetype')
                              call airline#parts#define('readonly', {
                                    \ 'function': 'airline#parts#readonly',
                                    \ 'accent': 'red',
                                    \ })
                              call airline#parts#define_raw('file', '%f%m')
                              call airline#parts#define_raw('path', '%F%m')
                              call airline#parts#define('linenr', {
                                    \ 'raw': '%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#',
                                    \ 'accent': 'bold'})
                              call airline#parts#define_function('ffenc', 'airline#parts#ffenc')
                              call airline#parts#define_empty(['hunks', 'branch', 'tagbar', 'syntastic',
                                    \ 'eclim', 'whitespace','windowswap', 'ycm_error_count', 'ycm_warning_count'])
                              call airline#parts#define_text('capslock', '')
                            
                              unlet g:airline#init#bootstrapping
                            endfunction
                            
    1              0.000002 function! airline#init#gui_mode()
                              return ((has('nvim') && exists('$NVIM_TUI_ENABLE_TRUE_COLOR'))
                                    \ || has('gui_running') || (has("termtruecolor") && &guicolors == 1)) ?
                                    \ 'gui' : 'cterm'
                            endfunction
                            
    1              0.000002 function! airline#init#sections()
                              let spc = g:airline_symbols.space
                              if !exists('g:airline_section_a')
                                let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'capslock', 'iminsert'])
                              endif
                              if !exists('g:airline_section_b')
                                let g:airline_section_b = airline#section#create(['hunks', 'branch'])
                              endif
                              if !exists('g:airline_section_c')
                                if exists("+autochdir") && &autochdir == 1
                                  let g:airline_section_c = airline#section#create(['%<', 'path', spc, 'readonly'])
                                else
                                  let g:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly'])
                                endif
                              endif
                              if !exists('g:airline_section_gutter')
                                let g:airline_section_gutter = airline#section#create(['%='])
                              endif
                              if !exists('g:airline_section_x')
                                let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype'])
                              endif
                              if !exists('g:airline_section_y')
                                let g:airline_section_y = airline#section#create_right(['ffenc'])
                              endif
                              if !exists('g:airline_section_z')
                                let g:airline_section_z = airline#section#create(['windowswap', '%3p%%'.spc, 'linenr', ':%3v '])
                              endif
                              if !exists('g:airline_section_error')
                                let g:airline_section_error = airline#section#create(['ycm_error_count', 'syntastic', 'eclim'])
                              endif
                              if !exists('g:airline_section_warning')
                                let g:airline_section_warning = airline#section#create(['ycm_warning_count', 'whitespace'])
                              endif
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/parts.vim
Sourced 1 time
Total time:   0.000083
 Self time:   0.000083

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000005 let s:parts = {}
                            
                            " PUBLIC API {{{
                            
    1              0.000003 function! airline#parts#define(key, config)
                              let s:parts[a:key] = get(s:parts, a:key, {})
                              if exists('g:airline#init#bootstrapping')
                                call extend(s:parts[a:key], a:config, 'keep')
                              else
                                call extend(s:parts[a:key], a:config, 'force')
                              endif
                            endfunction
                            
    1              0.000002 function! airline#parts#define_function(key, name)
                              call airline#parts#define(a:key, { 'function': a:name })
                            endfunction
                            
    1              0.000002 function! airline#parts#define_text(key, text)
                              call airline#parts#define(a:key, { 'text': a:text })
                            endfunction
                            
    1              0.000002 function! airline#parts#define_raw(key, raw)
                              call airline#parts#define(a:key, { 'raw': a:raw })
                            endfunction
                            
    1              0.000002 function! airline#parts#define_minwidth(key, width)
                              call airline#parts#define(a:key, { 'minwidth': a:width })
                            endfunction
                            
    1              0.000002 function! airline#parts#define_condition(key, predicate)
                              call airline#parts#define(a:key, { 'condition': a:predicate })
                            endfunction
                            
    1              0.000002 function! airline#parts#define_accent(key, accent)
                              call airline#parts#define(a:key, { 'accent': a:accent })
                            endfunction
                            
    1              0.000002 function! airline#parts#define_empty(keys)
                              for key in a:keys
                                call airline#parts#define_raw(key, '')
                              endfor
                            endfunction
                            
    1              0.000002 function! airline#parts#get(key)
                              return get(s:parts, a:key, {})
                            endfunction
                            
                            " }}}
                            
    1              0.000001 function! airline#parts#mode()
                              return get(w:, 'airline_current_mode', '')
                            endfunction
                            
    1              0.000002 function! airline#parts#crypt()
                              return g:airline_detect_crypt && exists("+key") && !empty(&key) ? g:airline_symbols.crypt : ''
                            endfunction
                            
    1              0.000001 function! airline#parts#paste()
                              return g:airline_detect_paste && &paste ? g:airline_symbols.paste : ''
                            endfunction
                            
    1              0.000002 function! airline#parts#iminsert()
                              if g:airline_detect_iminsert && &iminsert && exists('b:keymap_name')
                                return toupper(b:keymap_name)
                              endif
                              return ''
                            endfunction
                            
    1              0.000002 function! airline#parts#readonly()
                              if &readonly && &modifiable && !filereadable(bufname('%'))
                                return '[noperm]'
                              else
                                return &readonly ? g:airline_symbols.readonly : ''
                              endif
                            endfunction
                            
    1              0.000002 function! airline#parts#filetype()
                              return &filetype
                            endfunction
                            
    1              0.000001 function! airline#parts#ffenc()
                              return printf('%s%s%s', &fenc, &l:bomb ? '[BOM]' : '', strlen(&ff) > 0 ? '['.&ff.']' : '')
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/highlighter.vim
Sourced 1 time
Total time:   0.000142
 Self time:   0.000142

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000008 let s:is_win32term = (has('win32') || has('win64')) && !has('gui_running') && (empty($CONEMUBUILD) || &term !=? 'xterm')
                            
    1              0.000001 let s:separators = {}
    1              0.000001 let s:accents = {}
                            
    1              0.000003 function! s:gui2cui(rgb, fallback)
                              if a:rgb == ''
                                return a:fallback
                              elseif match(a:rgb, '^\%(NONE\|[fb]g\)$') > -1
                                return a:rgb
                              endif
                              let rgb = map(split(a:rgb[1:], '..\zs'), '0 + ("0x".v:val)')
                              return airline#msdos#round_msdos_colors(rgb)
                            endfunction
                            
    1              0.000002 function! s:get_syn(group, what)
                              if !exists("g:airline_gui_mode")
                                let g:airline_gui_mode = airline#init#gui_mode()
                              endif
                              let color = synIDattr(synIDtrans(hlID(a:group)), a:what, g:airline_gui_mode)
                              if empty(color) || color == -1
                                let color = synIDattr(synIDtrans(hlID('Normal')), a:what, g:airline_gui_mode)
                              endif
                              if empty(color) || color == -1
                                let color = 'NONE'
                              endif
                              return color
                            endfunction
                            
    1              0.000002 function! s:get_array(fg, bg, opts)
                              let fg = a:fg
                              let bg = a:bg
                              return g:airline_gui_mode ==# 'gui'
                                    \ ? [ fg, bg, '', '', join(a:opts, ',') ]
                                    \ : [ '', '', fg, bg, join(a:opts, ',') ]
                            endfunction
                            
    1              0.000003 function! airline#highlighter#get_highlight(group, ...)
                              let fg = s:get_syn(a:group, 'fg')
                              let bg = s:get_syn(a:group, 'bg')
                              let reverse = g:airline_gui_mode ==# 'gui'
                                    \ ? synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'gui')
                                    \ : synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')
                                    \|| synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'term')
                              return reverse ? s:get_array(bg, fg, a:000) : s:get_array(fg, bg, a:000)
                            endfunction
                            
    1              0.000002 function! airline#highlighter#get_highlight2(fg, bg, ...)
                              let fg = s:get_syn(a:fg[0], a:fg[1])
                              let bg = s:get_syn(a:bg[0], a:bg[1])
                              return s:get_array(fg, bg, a:000)
                            endfunction
                            
    1              0.000002 function! airline#highlighter#exec(group, colors)
                              if pumvisible()
                                return
                              endif
                              let colors = a:colors
                              if s:is_win32term
                                let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
                                let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
                              endif
                              let cmd= printf('hi %s %s %s %s %s %s %s %s',
                                    \ a:group, s:Get(colors, 0, 'guifg=', ''), s:Get(colors, 1, 'guibg=', ''),
                                    \ s:Get(colors, 2, 'ctermfg=', ''), s:Get(colors, 3, 'ctermbg=', ''),
                                    \ s:Get(colors, 4, 'gui=', ''), s:Get(colors, 4, 'cterm=', ''),
                                    \ s:Get(colors, 4, 'term=', ''))
                              let old_hi = airline#highlighter#get_highlight(a:group)
                              if len(colors) == 4
                                call add(colors, '')
                              endif
                              if old_hi != colors
                                exe cmd
                              endif
                            endfunction
                            
    1              0.000002 function! s:Get(dict, key, prefix, default)
                              if get(a:dict, a:key, a:default) isnot# a:default
                                return a:prefix. get(a:dict, a:key)
                              else
                                return ''
                              endif
                            endfunction
                            
    1              0.000002 function! s:exec_separator(dict, from, to, inverse, suffix)
                              if pumvisible()
                                return
                              endif
                              let l:from = airline#themes#get_highlight(a:from.a:suffix)
                              let l:to = airline#themes#get_highlight(a:to.a:suffix)
                              let group = a:from.'_to_'.a:to.a:suffix
                              if a:inverse
                                let colors = [ l:from[1], l:to[1], l:from[3], l:to[3] ]
                              else
                                let colors = [ l:to[1], l:from[1], l:to[3], l:from[3] ]
                              endif
                              let a:dict[group] = colors
                              call airline#highlighter#exec(group, colors)
                            endfunction
                            
    1              0.000002 function! airline#highlighter#load_theme()
                              if pumvisible()
                                return
                              endif
                              for winnr in filter(range(1, winnr('$')), 'v:val != winnr()')
                                call airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
                              endfor
                              call airline#highlighter#highlight(['inactive'])
                              call airline#highlighter#highlight(['normal'])
                            endfunction
                            
    1              0.000002 function! airline#highlighter#add_separator(from, to, inverse)
                              let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
                              call <sid>exec_separator({}, a:from, a:to, a:inverse, '')
                            endfunction
                            
    1              0.000002 function! airline#highlighter#add_accent(accent)
                              let s:accents[a:accent] = 1
                            endfunction
                            
    1              0.000002 function! airline#highlighter#highlight_modified_inactive(bufnr)
                              if getbufvar(a:bufnr, '&modified')
                                let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c')
                                      \ ? g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c : []
                              else
                                let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive.airline_c')
                                      \ ? g:airline#themes#{g:airline_theme}#palette.inactive.airline_c : []
                              endif
                            
                              if !empty(colors)
                                call airline#highlighter#exec('airline_c'.(a:bufnr).'_inactive', colors)
                              endif
                            endfunction
                            
    1              0.000002 function! airline#highlighter#highlight(modes)
                              let p = g:airline#themes#{g:airline_theme}#palette
                            
                              " draw the base mode, followed by any overrides
                              let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
                              let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
                              for mode in mapped
                                if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
                                  let dict = g:airline#themes#{g:airline_theme}#palette[mode]
                                  for kvp in items(dict)
                                    let mode_colors = kvp[1]
                                    call airline#highlighter#exec(kvp[0].suffix, mode_colors)
                            
                                    for accent in keys(s:accents)
                                      if !has_key(p.accents, accent)
                                        continue
                                      endif
                                      let colors = copy(mode_colors)
                                      if p.accents[accent][0] != ''
                                        let colors[0] = p.accents[accent][0]
                                      endif
                                      if p.accents[accent][2] != ''
                                        let colors[2] = p.accents[accent][2]
                                      endif
                                      if len(colors) >= 5
                                        let colors[4] = get(p.accents[accent], 4, '')
                                      else
                                        call add(colors, get(p.accents[accent], 4, ''))
                                      endif
                                      call airline#highlighter#exec(kvp[0].suffix.'_'.accent, colors)
                                    endfor
                                  endfor
                            
                                  " TODO: optimize this
                                  for sep in items(s:separators)
                                    call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
                                  endfor
                                endif
                              endfor
                            endfunction
                            

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/modules/osx_header.vim
Sourced 1 time
Total time:   0.002913
 Self time:   0.002913

count  total (s)   self (s)
                            " define Xcode directory path
    1              0.000005 let s:developer_dir  = '/Applications/Xcode-beta.app/Contents/Developer'
    1              0.000003 let s:sdk_dir        = s:developer_dir . '/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk'
    1              0.000002 let s:framework_dir  = s:sdk_dir . '/System/Library/Frameworks'
    1              0.000002 let s:toolchains_dir = s:developer_dir . '/Toolchains/XcodeDefault.xctoolchain'
                            
                            " Xcode Frameworks headers
                            " set path=.,/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
    1              0.000007 execute 'set path=.,' . s:sdk_dir . '/usr/include'
    1              0.000008 execute  'set path+=' . s:framework_dir . '/AGL.framework/Headers'
    1              0.000006 execute  'set path+=' . s:framework_dir . '/AVFoundation.framework/Headers'
    1              0.000006 execute  'set path+=' . s:framework_dir . '/AVKit.framework/Headers'
    1              0.000006 execute  'set path+=' . s:framework_dir . '/Accelerate.framework/Headers'
    1              0.000006 execute  'set path+=' . s:framework_dir . '/Accounts.framework/Headers'
    1              0.000006 execute  'set path+=' . s:framework_dir . '/AddressBook.framework/Headers'
    1              0.000007 execute  'set path+=' . s:framework_dir . '/AppKit.framework/Headers'
    1              0.000007 execute  'set path+=' . s:framework_dir . '/AppKitScripting.framework/Headers'
    1              0.000007 execute  'set path+=' . s:framework_dir . '/AppleScriptKit.framework/Headers'
    1              0.000007 execute  'set path+=' . s:framework_dir . '/AppleScriptObjC.framework/Headers'
    1              0.000008 execute  'set path+=' . s:framework_dir . '/ApplicationServices.framework/Headers'
    1              0.000008 execute  'set path+=' . s:framework_dir . '/AudioToolbox.framework/Headers'
    1              0.000008 execute  'set path+=' . s:framework_dir . '/AudioUnit.framework/Headers'
    1              0.000008 execute  'set path+=' . s:framework_dir . '/AudioVideoBridging.framework/Headers'
    1              0.000008 execute  'set path+=' . s:framework_dir . '/Automator.framework/Headers'
    1              0.000009 execute  'set path+=' . s:framework_dir . '/CFNetwork.framework/Headers'
    1              0.000009 execute  'set path+=' . s:framework_dir . '/CalendarStore.framework/Headers'
    1              0.000009 execute  'set path+=' . s:framework_dir . '/Carbon.framework/Headers'
    1              0.000009 execute  'set path+=' . s:framework_dir . '/CloudKit.framework/Headers'
    1              0.000009 execute  'set path+=' . s:framework_dir . '/Cocoa.framework/Headers'
    1              0.000010 execute  'set path+=' . s:framework_dir . '/Collaboration.framework/Headers'
    1              0.000010 execute  'set path+=' . s:framework_dir . '/Contacts.framework/Headers'
    1              0.000010 execute  'set path+=' . s:framework_dir . '/ContactsUI.framework/Headers'
    1              0.000010 execute  'set path+=' . s:framework_dir . '/CoreAudio.framework/Headers'
    1              0.000012 execute  'set path+=' . s:framework_dir . '/CoreAudioKit.framework/Headers'
    1              0.000011 execute  'set path+=' . s:framework_dir . '/CoreBluetooth.framework/Headers'
    1              0.000011 execute  'set path+=' . s:framework_dir . '/CoreData.framework/Headers'
    1              0.000011 execute  'set path+=' . s:framework_dir . '/CoreFoundation.framework/Headers'
    1              0.000012 execute  'set path+=' . s:framework_dir . '/CoreGraphics.framework/Headers'
    1              0.000012 execute  'set path+=' . s:framework_dir . '/CoreImage.framework/Headers/Headers'
    1              0.000012 execute  'set path+=' . s:framework_dir . '/CoreLocation.framework/Headers'
    1              0.000012 execute  'set path+=' . s:framework_dir . '/CoreMIDI.framework/Headers'
    1              0.000013 execute  'set path+=' . s:framework_dir . '/CoreMIDIServer.framework/Headers'
    1              0.000012 execute  'set path+=' . s:framework_dir . '/CoreMedia.framework/Headers'
    1              0.000013 execute  'set path+=' . s:framework_dir . '/CoreMediaIO.framework/Headers'
    1              0.000013 execute  'set path+=' . s:framework_dir . '/CoreServices.framework/Headers'
    1              0.000013 execute  'set path+=' . s:framework_dir . '/CoreTelephony.framework/Headers'
    1              0.000014 execute  'set path+=' . s:framework_dir . '/CoreText.framework/Headers'
    1              0.000014 execute  'set path+=' . s:framework_dir . '/CoreVideo.framework/Headers'
    1              0.000014 execute  'set path+=' . s:framework_dir . '/CoreWLAN.framework/Headers'
    1              0.000014 execute  'set path+=' . s:framework_dir . '/CryptoTokenKit.framework/Headers'
    1              0.000015 execute  'set path+=' . s:framework_dir . '/DVComponentGlue.framework/Headers'
    1              0.000015 execute  'set path+=' . s:framework_dir . '/DVDPlayback.framework/Headers'
    1              0.000015 execute  'set path+=' . s:framework_dir . '/DirectoryService.framework/Headers'
    1              0.000019 execute  'set path+=' . s:framework_dir . '/DiscRecording.framework/Headers'
    1              0.000016 execute  'set path+=' . s:framework_dir . '/DiscRecordingUI.framework/Headers'
    1              0.000018 execute  'set path+=' . s:framework_dir . '/DiskArbitration.framework/Headers'
    1              0.000016 execute  'set path+=' . s:framework_dir . '/DrawSprocket.framework/Headers'
    1              0.000016 execute  'set path+=' . s:framework_dir . '/EventKit.framework/Headers'
    1              0.000017 execute  'set path+=' . s:framework_dir . '/ExceptionHandling.framework/Headers'
    1              0.000017 execute  'set path+=' . s:framework_dir . '/FWAUserLib.framework/Headers'
    1              0.000017 execute  'set path+=' . s:framework_dir . '/FinderSync.framework/Headers'
    1              0.000017 execute  'set path+=' . s:framework_dir . '/ForceFeedback.framework/Headers'
    1              0.000017 execute  'set path+=' . s:framework_dir . '/Foundation.framework/Headers'
    1              0.000021 execute  'set path+=' . s:framework_dir . '/GLKit.framework/Headers'
    1              0.000018 execute  'set path+=' . s:framework_dir . '/GLUT.framework/Headers'
    1              0.000019 execute  'set path+=' . s:framework_dir . '/GSS.framework/Headers'
    1              0.000018 execute  'set path+=' . s:framework_dir . '/GameController.framework/Headers'
    1              0.000018 execute  'set path+=' . s:framework_dir . '/GameKit.framework/Headers'
    1              0.000019 execute  'set path+=' . s:framework_dir . '/GameplayKit.framework/Headers'
    1              0.000019 execute  'set path+=' . s:framework_dir . '/Hypervisor.framework/Headers'
    1              0.000019 execute  'set path+=' . s:framework_dir . '/ICADevices.framework/Headers'
    1              0.000020 execute  'set path+=' . s:framework_dir . '/IMServicePlugIn.framework/Headers'
    1              0.000020 execute  'set path+=' . s:framework_dir . '/IOBluetooth.framework/Headers'
    1              0.000020 execute  'set path+=' . s:framework_dir . '/IOBluetoothUI.framework/Headers'
    1              0.000020 execute  'set path+=' . s:framework_dir . '/IOKit.framework/Headers'
    1              0.000020 execute  'set path+=' . s:framework_dir . '/IOSurface.framework/Headers'
    1              0.000021 execute  'set path+=' . s:framework_dir . '/ImageCaptureCore.framework/Headers'
    1              0.000021 execute  'set path+=' . s:framework_dir . '/ImageIO.framework/Headers'
    1              0.000021 execute  'set path+=' . s:framework_dir . '/InputMethodKit.framework/Headers'
    1              0.000021 execute  'set path+=' . s:framework_dir . '/InstallerPlugins.framework/Headers'
    1              0.000022 execute  'set path+=' . s:framework_dir . '/InstantMessage.framework/Headers'
    1              0.000022 execute  'set path+=' . s:framework_dir . '/JavaFrameEmbedding.framework/Headers'
    1              0.000022 execute  'set path+=' . s:framework_dir . '/JavaScriptCore.framework/Headers'
    1              0.000022 execute  'set path+=' . s:framework_dir . '/JavaVM.framework/Headers'
    1              0.000022 execute  'set path+=' . s:framework_dir . '/Kerberos.framework/Headers'
    1              0.000022 execute  'set path+=' . s:framework_dir . '/Kernel.framework/Headers'
    1              0.000023 execute  'set path+=' . s:framework_dir . '/LDAP.framework/Headers'
    1              0.000028 execute  'set path+=' . s:framework_dir . '/LatentSemanticMapping.framework/Headers'
    1              0.000024 execute  'set path+=' . s:framework_dir . '/LocalAuthentication.framework/Headers'
    1              0.000023 execute  'set path+=' . s:framework_dir . '/MapKit.framework/Headers'
    1              0.000024 execute  'set path+=' . s:framework_dir . '/MediaAccessibility.framework/Headers'
    1              0.000024 execute  'set path+=' . s:framework_dir . '/MediaLibrary.framework/Headers'
    1              0.000024 execute  'set path+=' . s:framework_dir . '/MediaToolbox.framework/Headers'
    1              0.000024 execute  'set path+=' . s:framework_dir . '/Message.framework/Headers'
    1              0.000025 execute  'set path+=' . s:framework_dir . '/Metal.framework/Headers'
    1              0.000025 execute  'set path+=' . s:framework_dir . '/MetalKit.framework/Headers'
    1              0.000025 execute  'set path+=' . s:framework_dir . '/ModelIO.framework/Headers'
    1              0.000033 execute  'set path+=' . s:framework_dir . '/MultipeerConnectivity.framework/Headers'
    1              0.000026 execute  'set path+=' . s:framework_dir . '/NetFS.framework/Headers'
    1              0.000026 execute  'set path+=' . s:framework_dir . '/NetworkExtension.framework/Headers'
    1              0.000027 execute  'set path+=' . s:framework_dir . '/NotificationCenter.framework/Headers'
    1              0.000026 execute  'set path+=' . s:framework_dir . '/OSAKit.framework/Headers'
    1              0.000027 execute  'set path+=' . s:framework_dir . '/OpenAL.framework/Headers'
    1              0.000027 execute  'set path+=' . s:framework_dir . '/OpenCL.framework/Headers'
    1              0.000027 execute  'set path+=' . s:framework_dir . '/OpenDirectory.framework/Headers'
    1              0.000027 execute  'set path+=' . s:framework_dir . '/OpenGL.framework/Headers'
    1              0.000027 execute  'set path+=' . s:framework_dir . '/PCSC.framework/Headers'
    1              0.000028 execute  'set path+=' . s:framework_dir . '/Photos.framework/Headers'
    1              0.000028 execute  'set path+=' . s:framework_dir . '/PhotosUI.framework/Headers'
    1              0.000028 execute  'set path+=' . s:framework_dir . '/PreferencePanes.framework/Headers'
    1              0.000030 execute  'set path+=' . s:framework_dir . '/PubSub.framework/Headers'
    1              0.000035 execute  'set path+=' . s:framework_dir . '/Python.framework/Headers'
    1              0.000029 execute  'set path+=' . s:framework_dir . '/QTKit.framework/Headers'
    1              0.000029 execute  'set path+=' . s:framework_dir . '/Quartz.framework/Headers'
    1              0.000029 execute  'set path+=' . s:framework_dir . '/QuartzCore.framework/Headers'
    1              0.000030 execute  'set path+=' . s:framework_dir . '/QuickLook.framework/Headers'
    1              0.000030 execute  'set path+=' . s:framework_dir . '/QuickTime.framework/Headers'
    1              0.000030 execute  'set path+=' . s:framework_dir . '/Ruby.framework/Headers'
    1              0.000030 execute  'set path+=' . s:framework_dir . '/SceneKit.framework/Headers'
    1              0.000031 execute  'set path+=' . s:framework_dir . '/ScreenSaver.framework/Headers'
    1              0.000031 execute  'set path+=' . s:framework_dir . '/Scripting.framework/Headers'
    1              0.000031 execute  'set path+=' . s:framework_dir . '/ScriptingBridge.framework/Headers'
    1              0.000031 execute  'set path+=' . s:framework_dir . '/Security.framework/Headers'
    1              0.000032 execute  'set path+=' . s:framework_dir . '/SecurityFoundation.framework/Headers'
    1              0.000032 execute  'set path+=' . s:framework_dir . '/SecurityInterface.framework/Headers'
    1              0.000032 execute  'set path+=' . s:framework_dir . '/ServiceManagement.framework/Headers'
    1              0.000032 execute  'set path+=' . s:framework_dir . '/Social.framework/Headers'
    1              0.000033 execute  'set path+=' . s:framework_dir . '/SpriteKit.framework/Headers'
    1              0.000033 execute  'set path+=' . s:framework_dir . '/StoreKit.framework/Headers'
    1              0.000035 execute  'set path+=' . s:framework_dir . '/SyncServices.framework/Headers'
    1              0.000033 execute  'set path+=' . s:framework_dir . '/System.framework/Headers'
    1              0.000034 execute  'set path+=' . s:framework_dir . '/SystemConfiguration.framework/Headers'
    1              0.000034 execute  'set path+=' . s:framework_dir . '/TWAIN.framework/Headers'
    1              0.000034 execute  'set path+=' . s:framework_dir . '/Tcl.framework/Headers'
    1              0.000034 execute  'set path+=' . s:framework_dir . '/Tk.framework/Headers'
    1              0.000035 execute  'set path+=' . s:framework_dir . '/VideoDecodeAcceleration.framework/Headers'
    1              0.000035 execute  'set path+=' . s:framework_dir . '/VideoToolbox.framework/Headers'
    1              0.000035 execute  'set path+=' . s:framework_dir . '/WebKit.framework/Headers'
    1              0.000057 execute  'set path+=' . s:framework_dir . '/vecLib.framework/Headers'
    1              0.000047 execute  'set path+=' . s:framework_dir . '/vmnet.framework/Headers'
                            " Toolchains headers
    1              0.000036 execute 'set path+=' . s:toolchains_dir . '/usr/include'
    1              0.000036 execute 'set path+=' . s:toolchains_dir . '/usr/include/c++/v1'
    1              0.000036 execute 'set path+=' . s:toolchains_dir . '/usr/lib/clang/7.3.0/include'
                            " Users headers
    1              0.000032 execute 'set path+=/usr/local/include'
    1              0.000032 execute 'set path+=/usr/include'
                            

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/modules/functions.vim
Sourced 1 time
Total time:   0.000023
 Self time:   0.000023

count  total (s)   self (s)
                            "
                            " Temporary functions
                            "
                            
                            " C_Cpp_Objc_Objcpp:
                            " Open cppreference.com
    1              0.000003 function! s:open_online_cpp_doc()
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
                            

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/local.vim
Sourced 1 time
Total time:   0.000059
 Self time:   0.000059

count  total (s)   self (s)
                            " deoplete-clang
    1              0.000008 let g:deoplete#sources#clang#libclang_path = "/opt/llvm/lib/libclang.dylib"
    1              0.000004 let g:deoplete#sources#clang#clang_header = '/opt/llvm/lib/clang'
                            " let g:deoplete#sources#clang#std#c = 'c11'
                            " let g:deoplete#sources#clang#std#cpp = 'c++1z'
                            " echo | clang -v -E -x c -
                            " let g:deoplete#sources#clang#flags = [
                            "       \ "-cc1",
                            "       \ "-triple",
                            "       \ "x86_64-apple-macosx10.11.0",
                            "       \ "-Wdeprecated-objc-isa-usage",
                            "       \ "-Werror=deprecated-objc-isa-usage",
                            "       \ "-emit-obj",
                            "       \ "-mrelax-all",
                            "       \ "-disable-free",
                            "       \ "-disable-llvm-verifier",
                            "       \ "-mrelocation-model", "pic",
                            "       \ "-pic-level", "2",
                            "       \ "-mthread-model", "posix",
                            "       \ "-mdisable-fp-elim",
                            "       \ "-masm-verbose",
                            "       \ "-munwind-tables",
                            "       \ "-target-cpu", "core2",
                            "       \ "-target-linker-version", "264.3",
                            "       \ "-dwarf-column-info",
                            "       \ "-debugger-tuning=lldb",
                            "       \ "-coverage-file",
                            "       \ "-resource-dir", "/opt/llvm/lib/clang/3.9.0",
                            "       \ "-isysroot", "/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk",
                            "       \ "-ferror-limit", "19",
                            "       \ "-fmessage-length", "213",
                            "       \ "-stack-protector", "1",
                            "       \ "-fblocks",
                            "       \ "-fobjc-runtime=macosx-10.11.0",
                            "       \ "-fencode-extended-block-signature",
                            "       \ "-fmax-type-align=16",
                            "       \ "-fdiagnostics-show-option",
                            "       \ ]
                            " let g:deoplete#sources#clang#sort_algo = 'priority'
                            " let g:deoplete#sources#clang#sort_algo = 'alphabetical'
                            " let g:deoplete#sources#clang#style = 'a'
    1              0.000004 let g:deoplete#sources#clang#clang_complete_database = '/Users/zchee/src/github.com/neovim/neovim/build'
    1              0.000001 let g:deoplete#enable_debug = 1
    1              0.000004 let g:deoplete#sources#clang#debug#log_file = '~/.log/nvim/python/deoplete-clang.log'
    1              0.000003 let g:deoplete#sources#jedi#debug#log_file = '~/.log/nvim/python/deoplete-jedi.log'
    1              0.000003 let deoplete#sources#go#debug#log_file = '~/.log/nvim/python/deoplete-go.log'
                            
                            " Rip-Rip/clang_complete
                            " let g:clang_auto_select = 1
    1              0.000003 let g:clang_use_library = 1
    1              0.000003 let g:clang_library_path = '/opt/llvm/trunk/lib/libclang.dylib'
    1              0.000003 let g:clang_compilation_database = '/Users/zchee/src/github.com/neovim/neovim/build'
    1              0.000002 let g:clang_snippets = 0
    1              0.000004 let g:clang_user_options = '-std=c++11'

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/plugin/go.vim
Sourced 1 time
Total time:   0.000015
 Self time:   0.000015

count  total (s)   self (s)
                            " if exists('g:loaded_go_rplugin')
                            "   finish
                            " endif
                            " let g:loaded_go_rplugin = 1
                            "
                            " let s:goos = $GOOS
                            " let s:goarch = $GOARCH
                            " let s:plugin_name = ['nvim-go', 'buffer-parser']
                            " let s:plugin_src = $HOME . 'github.com/zchee/'
                            
                            " let s:plugin_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/bin/' . s:plugin_name . '-' . s:goos . '-' . s:goarch
                            
                            " function! RequireGoHost(host) abort
                            "   for s:p in s:plugin_name
                            "     return rpcstart(fnamemodify(s:p, ':h:h') . '/bin/' . s:p . '-' . s:goos . '-' . s:goarch, ['plugin'])
                            "   endfor
                            " endfunction
                            
                            " function! RequireGoHost(host) abort
                            "   let args = []
                            "   try
                            "     for plugin in remote#host#PluginsForHost(a:host.name)
                            "         call add(args, plugin.path)
                            "     endfor
                            "     return rpcstart(s:plugin_path, args)
                            "   catch
                            "     echomsg v:exception
                            "   endtry
                            "   throw 'Failed to load ' . s:plugin_name . ' host'.
                            " endfunction
                            
                            " for x in s:plugin_name
                              " let s:plugin_path = s:plugin_src . x . '/bin/' . x  . '-' . s:goos . '-' . s:goarch
                            " call remote#host#Register('go', 'nvim-go', function('s:RequireGoHost'))
                            " endfor

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/plugin/matchparen.vim
Sourced 1 time
Total time:   0.000044
 Self time:   0.000044

count  total (s)   self (s)
                            let s:paren_hl_on = 0
    1              0.000004 function! s:Highlight_Matching_Paren()
                              if s:paren_hl_on
                                match none
                                let s:paren_hl_on = 0
                              endif
                            
                              let c_lnum = line('.')
                              let c_col = col('.')
                            
                              let c = getline(c_lnum)[c_col - 1]
                              let plist = split(&matchpairs, ':\|,')
                              let i = index(plist, c)
                              if i < 0
                                return
                              endif
                              if i % 2 == 0
                                let s_flags = 'nW'
                                let c2 = plist[i + 1]
                              else
                                let s_flags = 'nbW'
                                let c2 = c
                                let c = plist[i - 1]
                              endif
                              if c == '['
                                let c = '\['
                                let c2 = '\]'
                              endif
                              let s_skip ='synIDattr(synID(line("."), col("."), 0), "name") ' .
                              \ '=~?	"string\\|comment"'
                              execute 'if' s_skip '| let s_skip = 0 | endif'
                            
                              let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip)
                            
                              if m_lnum > 0 && m_lnum >= line('w0') && m_lnum <= line('w$')
                                exe 'match Search /\(\%' . c_lnum . 'l\%' . c_col .
                                \ 'c\)\|\(\%' . m_lnum . 'l\%' . m_col . 'c\)/'
                                let s:paren_hl_on = 1
                              endif
                            endfunction
                            
    1              0.000006 autocmd! CursorMoved,CursorMovedI * call s:Highlight_Matching_Paren()
    1              0.000004 autocmd! InsertEnter * match none

SCRIPT  /Users/zchee/src/github.com/zchee/nvim-go/plugin/nvim-go.vim
Sourced 1 time
Total time:   0.000410
 Self time:   0.000167

count  total (s)   self (s)
                            if exists('g:loaded_nvim_go')
                              finish
                            endif
    1              0.000002 let g:loaded_nvim_go = 1
                            
                            
    1              0.000003 let g:go#def#filer = get(g:, 'go#def#filer', 'Explore')
    1              0.000003 let g:go#guru#reflection = get(g:, 'go#guru#reflection', 0)
    1              0.000002 let g:go#fmt#async = get(g:, 'go#fmt#async', 0)
                            
    1              0.000001 let s:plugin_name = 'nvim-go'
    1              0.000002 let s:goos = $GOOS
    1              0.000002 let s:goarch = $GOARCH
    1              0.000031 let s:plugin_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/bin/' . s:plugin_name . '-' . s:goos . '-' . s:goarch
                            
                            " function! s:RequireNvimGo(host) abort
                            "     return rpcstart(s:plugin_path, ['plugin'])
                            " endfunction
                            
    1              0.000003 function! s:RequireNvimGo(host) abort
                              let args = []
                              try
                                for plugin in remote#host#PluginsForHost(a:host.name)
                                    call add(args, plugin.path)
                                endfor
                                return rpcstart(s:plugin_path, args)
                              catch
                                echomsg v:exception
                              endtry
                              throw 'Failed to load ' . s:plugin_name . ' host'.
                            endfunction
                            
    1              0.000082 call remote#host#Register('go/' . s:plugin_name, '*', function('s:RequireNvimGo'))

SCRIPT  /usr/local/share/nvim/runtime/autoload/remote/host.vim
Sourced 1 time
Total time:   0.000227
 Self time:   0.000204

count  total (s)   self (s)
                            let s:hosts = {}
    1              0.000003 let s:plugin_patterns = {}
    1              0.000016 let s:remote_plugins_manifest = fnamemodify(expand($MYVIMRC, 1), ':h')
                                  \.'/.'.fnamemodify($MYVIMRC, ':t').'-rplugin~'
                            
                            
                            " Register a host by associating it with a factory(funcref)
    1              0.000003 function! remote#host#Register(name, pattern, factory) abort
                              let s:hosts[a:name] = {'factory': a:factory, 'channel': 0, 'initialized': 0}
                              let s:plugin_patterns[a:name] = a:pattern
                              if type(a:factory) == type(1) && a:factory
                                " Passed a channel directly
                                let s:hosts[a:name].channel = a:factory
                              endif
                            endfunction
                            
                            
                            " Register a clone to an existing host. The new host will use the same factory
                            " as `source`, but it will run as a different process. This can be used by
                            " plugins that should run isolated from other plugins created for the same host
                            " type
    1              0.000002 function! remote#host#RegisterClone(name, orig_name) abort
                              if !has_key(s:hosts, a:orig_name)
                                throw 'No host named "'.a:orig_name.'" is registered'
                              endif
                              let Factory = s:hosts[a:orig_name].factory
                              let s:hosts[a:name] = {
                                    \ 'factory': Factory,
                                    \ 'channel': 0,
                                    \ 'initialized': 0,
                                    \ 'orig_name': a:orig_name
                                    \ }
                            endfunction
                            
                            
                            " Get a host channel, bootstrapping it if necessary
    1              0.000002 function! remote#host#Require(name) abort
                              if !has_key(s:hosts, a:name)
                                throw 'No host named "'.a:name.'" is registered'
                              endif
                              let host = s:hosts[a:name]
                              if !host.channel && !host.initialized
                                let host_info = {
                                      \ 'name': a:name,
                                      \ 'orig_name': get(host, 'orig_name', a:name)
                                      \ }
                                let host.channel = call(host.factory, [host_info])
                                let host.initialized = 1
                              endif
                              return host.channel
                            endfunction
                            
                            
    1              0.000002 function! remote#host#IsRunning(name) abort
                              if !has_key(s:hosts, a:name)
                                throw 'No host named "'.a:name.'" is registered'
                              endif
                              return s:hosts[a:name].channel != 0
                            endfunction
                            
                            
                            " Example of registering a Python plugin with two commands (one async), one
                            " autocmd (async) and one function (sync):
                            "
                            " let s:plugin_path = expand('<sfile>:p:h').'/nvim_plugin.py'
                            " call remote#host#RegisterPlugin('python', s:plugin_path, [
                            "   \ {'type': 'command', 'name': 'PyCmd', 'sync': 1, 'opts': {}},
                            "   \ {'type': 'command', 'name': 'PyAsyncCmd', 'sync': 0, 'opts': {'eval': 'cursor()'}},
                            "   \ {'type': 'autocmd', 'name': 'BufEnter', 'sync': 0, 'opts': {'eval': 'expand("<afile>")'}},
                            "   \ {'type': 'function', 'name': 'PyFunc', 'sync': 1, 'opts': {}}
                            "   \ ])
                            "
                            " The third item in a declaration is a boolean: non zero means the command,
                            " autocommand or function will be executed synchronously with rpcrequest.
    1              0.000002 function! remote#host#RegisterPlugin(host, path, specs) abort
                              let plugins = remote#host#PluginsForHost(a:host)
                            
                              for plugin in plugins
                                if plugin.path == a:path
                                  throw 'Plugin "'.a:path.'" is already registered'
                                endif
                              endfor
                            
                              if has_key(s:hosts, a:host) && remote#host#IsRunning(a:host)
                                " For now we won't allow registration of plugins when the host is already
                                " running.
                                throw 'Host "'.a:host.'" is already running'
                              endif
                            
                              for spec in a:specs
                                let type = spec.type
                                let name = spec.name
                                let sync = spec.sync
                                let opts = spec.opts
                                let rpc_method = a:path
                                if type == 'command'
                                  let rpc_method .= ':command:'.name
                                  call remote#define#CommandOnHost(a:host, rpc_method, sync, name, opts)
                                elseif type == 'autocmd'
                                  " Since multiple handlers can be attached to the same autocmd event by a
                                  " single plugin, we need a way to uniquely identify the rpc method to
                                  " call.  The solution is to append the autocmd pattern to the method
                                  " name(This still has a limit: one handler per event/pattern combo, but
                                  " there's no need to allow plugins define multiple handlers in that case)
                                  let rpc_method .= ':autocmd:'.name.':'.get(opts, 'pattern', '*')
                                  call remote#define#AutocmdOnHost(a:host, rpc_method, sync, name, opts)
                                elseif type == 'function'
                                  let rpc_method .= ':function:'.name
                                  call remote#define#FunctionOnHost(a:host, rpc_method, sync, name, opts)
                                else
                                  echoerr 'Invalid declaration type: '.type
                                endif
                              endfor
                            
                              call add(plugins, {'path': a:path, 'specs': a:specs})
                            endfunction
                            
                            
    1              0.000002 function! remote#host#LoadRemotePlugins() abort
                              if filereadable(s:remote_plugins_manifest)
                                exe 'source '.s:remote_plugins_manifest
                              endif
                            endfunction
                            
                            
    1              0.000002 function! s:RegistrationCommands(host) abort
                              " Register a temporary host clone for discovering specs
                              let host_id = a:host.'-registration-clone'
                              call remote#host#RegisterClone(host_id, a:host)
                              let pattern = s:plugin_patterns[a:host]
                              let paths = globpath(&rtp, 'rplugin/'.a:host.'/'.pattern, 0, 1)
                              if empty(paths)
                                return []
                              endif
                            
                              for path in paths
                                call remote#host#RegisterPlugin(host_id, path, [])
                              endfor
                              let channel = remote#host#Require(host_id)
                              let lines = []
                              for path in paths
                                let specs = rpcrequest(channel, 'specs', path)
                                if type(specs) != type([])
                                  " host didn't return a spec list, indicates a failure while loading a
                                  " plugin
                                  continue
                                endif
                                call add(lines, "call remote#host#RegisterPlugin('".a:host
                                      \ ."', '".path."', [")
                                for spec in specs
                                  call add(lines, "      \\ ".string(spec).",")
                                endfor
                                call add(lines, "     \\ ])")
                              endfor
                              echomsg printf("remote/host: %s host registered plugins %s",
                                    \ a:host, string(map(copy(paths), "fnamemodify(v:val, ':t')")))
                            
                              " Delete the temporary host clone
                              call rpcstop(s:hosts[host_id].channel)
                              call remove(s:hosts, host_id)
                              call remove(s:plugins_for_host, host_id)
                              return lines
                            endfunction
                            
                            
    1              0.000001 function! s:UpdateRemotePlugins() abort
                              let commands = []
                              let hosts = keys(s:hosts)
                              for host in hosts
                                if has_key(s:plugin_patterns, host)
                                  try
                                    let commands +=
                                          \   ['" '.host.' plugins']
                                          \ + s:RegistrationCommands(host)
                                          \ + ['', '']
                                  catch
                                    echomsg v:throwpoint
                                    echomsg v:exception
                                  endtry
                                endif
                              endfor
                              call writefile(commands, s:remote_plugins_manifest)
                              echomsg printf('remote/host: generated the manifest file in "%s"',
                                    \ s:remote_plugins_manifest)
                            endfunction
                            
                            
    1              0.000003 command! UpdateRemotePlugins call s:UpdateRemotePlugins()
                            
                            
    1              0.000002 let s:plugins_for_host = {}
    1              0.000002 function! remote#host#PluginsForHost(host) abort
                              if !has_key(s:plugins_for_host, a:host)
                                let s:plugins_for_host[a:host] = []
                              end
                              return s:plugins_for_host[a:host]
                            endfunction
                            
                            
                            " Registration of standard hosts
                            
                            " Python/Python3 {{{
    1              0.000002 function! s:RequirePythonHost(host) abort
                              let ver = (a:host.orig_name ==# 'python') ? 2 : 3
                            
                              " Python host arguments
                              let args = ['-c', 'import sys; sys.path.remove(""); import neovim; neovim.start_host()']
                            
                              " Collect registered Python plugins into args
                              let python_plugins = remote#host#PluginsForHost(a:host.name)
                              for plugin in python_plugins
                                call add(args, plugin.path)
                              endfor
                            
                              try
                                let channel_id = rpcstart((ver == '2' ?
                                      \ provider#python#Prog() : provider#python3#Prog()), args)
                                if rpcrequest(channel_id, 'poll') == 'ok'
                                  return channel_id
                                endif
                              catch
                                echomsg v:throwpoint
                                echomsg v:exception
                              endtry
                              throw 'Failed to load '. a:host.orig_name . ' host. '.
                                \ 'You can try to see what happened '.
                                \ 'by starting Neovim with the environment variable '.
                                \ '$NVIM_PYTHON_LOG_FILE set to a file and opening '.
                                \ 'the generated log file. Also, the host stderr will be available '.
                                \ 'in Neovim log, so it may contain useful information. '.
                                \ 'See also ~/.nvimlog.'
                            endfunction
                            
    1   0.000024   0.000010 call remote#host#Register('python', '*.py', function('s:RequirePythonHost'))
    1   0.000018   0.000008 call remote#host#Register('python3', '*.py', function('s:RequirePythonHost'))
                            " }}}

SCRIPT  /Users/zchee/src/github.com/bfredl/nvim-ipy/plugin/ipy.vim
Sourced 1 time
Total time:   0.000204
 Self time:   0.000204

count  total (s)   self (s)
                            command! -nargs=* IPython :call IPyConnect(<f-args>)
    1              0.000005 command! -nargs=* IPython2 :call IPyConnect("--kernel", "python2")
    1              0.000003 command! -nargs=* IJulia :call IPyConnect("--kernel", "julia-0.4")
                            
    1              0.000007 nnoremap <Plug>(IPy-Run) :call IPyRun(getline('.'))<cr>
    1              0.000007 vnoremap <Plug>(IPy-Run) :<c-u>call IPyRun(<SID>get_visual_selection())<cr>
    1              0.000006 inoremap <Plug>(IPy-Complete) <c-o>:<c-u>call IPyComplete()<cr>
    1              0.000007 noremap <Plug>(IPy-WordObjInfo) :call IPyObjInfo(<SID>get_current_word(), 0)<cr>
    1              0.000005 noremap <Plug>(IPy-Interrupt) :call IPyInterrupt()<cr>
    1              0.000005 noremap <Plug>(IPy-Terminate) :call IPyTerminate()<cr>
                            
                            " make this overrideable
    1              0.000004 hi IPyIn ctermfg=green cterm=bold
    1              0.000003 hi IPyOut ctermfg=red cterm=bold
                            
    1              0.000002 hi IPyBold cterm=bold
   10              0.000011 for i in range(0,8)
    9              0.000042     execute "hi IPyFg".i." ctermfg=".i
    9              0.000044     execute "hi IPyFg".i."Bold ctermfg=".i." cterm=bold"
    9              0.000005 endfor
                            
    1              0.000002 function! s:get_current_word()
                                let isk_save = &isk
                                let &isk = '@,48-57,_,192-255,.'
                                let word = expand("<cword>")
                                let &isk = isk_save
                                return word
                            endfunction
                            
                            " thanks to @xolox on stackoverflow
    1              0.000002 function! s:get_visual_selection()
                                let [lnum1, col1] = getpos("'<")[1:2]
                                let [lnum2, col2] = getpos("'>")[1:2]
                                let lines = getline(lnum1, lnum2)
                                let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
                                let lines[0] = lines[0][col1 - 1:]
                                return join(lines, "\n")
                            endfunction
                            
    1              0.000003 if !exists('g:nvim_ipy_perform_mappings')
                                let g:nvim_ipy_perform_mappings = 1
                            endif
                            
    1              0.000002 let g:ipy_status = ""
                            
    1              0.000001 if g:nvim_ipy_perform_mappings
                                map <silent> <F5>           <Plug>(IPy-Run)
                                imap <silent> <C-F> <Plug>(IPy-Complete)
                                map <silent> <F8> <Plug>(IPy-Interrupt)
                                map <silent> <leader>? <Plug>(IPy-WordObjInfo)
                                "set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)%(\ -\ %{g:ipy_status}%)
                            endif
                            
                            

SCRIPT  /Users/zchee/src/github.com/garyburd/vigor/plugin/vigor.vim
Sourced 1 time
Total time:   0.001458
 Self time:   0.000153

count  total (s)   self (s)
                            if exists('g:loaded_vigor')
                              finish
                            endif
    1              0.000002 let g:loaded_vigor = 1
                            
    1              0.000002 let s:plugin_name = 'vigor'
    1              0.000002 let s:goos = $GOOS
    1              0.000002 let s:goarch = $GOARCH
    1              0.000031 let s:plugin_path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h') . '/bin/' . s:plugin_name . '-' . s:goos . '-' . s:goarch
                            
    1              0.000013 function! s:RequireVigor(host) abort
                              let args = []
                              try
                                for plugin in remote#host#PluginsForHost(a:host.name)
                                    call add(args, plugin.path)
                                endfor
                                return rpcstart(s:plugin_path, args)
                              catch
                                echomsg v:exception
                              endtry
                              throw 'Failed to load ' . s:plugin_name . ' host'.
                            endfunction
                            
                            " function! s:RequireVigor(host) abort
                            "     return rpcstart(s:plugin_path, ['plugin'])
                            " endfunction
                            
    1              0.000048 let s:specs = [
                            \ {'type': 'autocmd', 'name': 'BufReadCmd', 'sync': 1, 'opts': {'eval': '[expand(''%''), getcwd()]', 'pattern': 'godoc://**'}},
                            \ {'type': 'command', 'name': 'Fmt', 'sync': 1, 'opts': {'eval': 'expand(''%:p'')', 'range': '%'}},
                            \ {'type': 'command', 'name': 'Godef', 'sync': 1, 'opts': {'complete': 'customlist,QQQDocComplete', 'eval': 'getcwd()', 'nargs': '*'}},
                            \ {'type': 'command', 'name': 'Godoc', 'sync': 1, 'opts': {'complete': 'customlist,QQQDocComplete', 'eval': '[getcwd(), 0]', 'nargs': '*'}},
                            \ {'type': 'command', 'name': 'Pgodoc', 'sync': 1, 'opts': {'complete': 'customlist,QQQDocComplete', 'eval': '[getcwd(), 1]', 'nargs': '*'}},
                            \ {'type': 'function', 'name': 'QQQDocComplete', 'sync': 1, 'opts': {'eval': 'getcwd()'}},
                            \ ]
                            
    1   0.000021   0.000008 call remote#host#Register('go/vigor', '*', function('s:RequireVigor'))
    1   0.001302   0.000008 call remote#host#RegisterPlugin('vigor', 'plugin', s:specs)
                            
                            " vim:ts=4:sw=4:et

SCRIPT  /usr/local/share/nvim/runtime/autoload/remote/define.vim
Sourced 1 time
Total time:   0.000219
 Self time:   0.000219

count  total (s)   self (s)
                            function! remote#define#CommandOnHost(host, method, sync, name, opts)
                              let prefix = ''
                            
                              if has_key(a:opts, 'range') 
                                if a:opts.range == '' || a:opts.range == '%'
                                  " -range or -range=%, pass the line range in a list
                                  let prefix = '<line1>,<line2>'
                                elseif matchstr(a:opts.range, '\d') != ''
                                  " -range=N, pass the count
                                  let prefix = '<count>'
                                endif
                              elseif has_key(a:opts, 'count')
                                let prefix = '<count>'
                              endif
                            
                              let forward_args = [prefix.a:name]
                            
                              if has_key(a:opts, 'bang')
                                call add(forward_args, '<bang>')
                              endif
                            
                              if has_key(a:opts, 'register')
                                call add(forward_args, ' <register>')
                              endif
                            
                              if has_key(a:opts, 'nargs')
                                call add(forward_args, ' <args>')
                              endif
                            
                              exe s:GetCommandPrefix(a:name, a:opts)
                                    \ .' call remote#define#CommandBootstrap("'.a:host.'"'
                                    \ .                                ', "'.a:method.'"'
                                    \ .                                ', "'.a:sync.'"'
                                    \ .                                ', "'.a:name.'"'
                                    \ .                                ', '.string(a:opts).''
                                    \ .                                ', "'.join(forward_args, '').'"'
                                    \ .                                ')'
                            endfunction
                            
                            
    1              0.000003 function! remote#define#CommandBootstrap(host, method, sync, name, opts, forward)
                              let channel = remote#host#Require(a:host)
                            
                              if channel
                                call remote#define#CommandOnChannel(channel, a:method, a:sync, a:name, a:opts)
                                exe a:forward
                              else
                                exe 'delcommand '.a:name
                                echoerr 'Host "'a:host.'" is not available, deleting command "'.a:name.'"'
                              endif
                            endfunction
                            
                            
    1              0.000003 function! remote#define#CommandOnChannel(channel, method, sync, name, opts)
                              let rpcargs = [a:channel, '"'.a:method.'"']
                              if has_key(a:opts, 'nargs')
                                " -nargs, pass arguments in a list
                                call add(rpcargs, '[<f-args>]')
                              endif
                            
                              if has_key(a:opts, 'range')
                                if a:opts.range == '' || a:opts.range == '%'
                                  " -range or -range=%, pass the line range in a list
                                  call add(rpcargs, '[<line1>, <line2>]')
                                elseif matchstr(a:opts.range, '\d') != ''
                                  " -range=N, pass the count
                                  call add(rpcargs, '<count>')
                                endif
                              elseif has_key(a:opts, 'count')
                                " count
                                call add(rpcargs, '<count>')
                              endif
                            
                              if has_key(a:opts, 'bang')
                                " bang
                                call add(rpcargs, '<q-bang> == "!"')
                              endif
                            
                              if has_key(a:opts, 'register')
                                " register
                                call add(rpcargs, '<q-reg>')
                              endif
                            
                              call s:AddEval(rpcargs, a:opts)
                              exe s:GetCommandPrefix(a:name, a:opts)
                                    \ . ' call '.s:GetRpcFunction(a:sync).'('.join(rpcargs, ', ').')'
                            endfunction
                            
                            
    1              0.000002 function! remote#define#AutocmdOnHost(host, method, sync, name, opts)
                              let group = s:GetNextAutocmdGroup()
                              let forward = '"doau '.group.' '.a:name.' ".'.'expand("<amatch>")'
                              let a:opts.group = group
                              let bootstrap_def = s:GetAutocmdPrefix(a:name, a:opts)
                                    \ .' call remote#define#AutocmdBootstrap("'.a:host.'"'
                                    \ .                                ', "'.a:method.'"'
                                    \ .                                ', "'.a:sync.'"'
                                    \ .                                ', "'.a:name.'"'
                                    \ .                                ', '.string(a:opts).''
                                    \ .                                ', "'.escape(forward, '"').'"'
                                    \ .                                ')'
                              exe bootstrap_def
                            endfunction
                            
                            
    1              0.000003 function! remote#define#AutocmdBootstrap(host, method, sync, name, opts, forward)
                              let channel = remote#host#Require(a:host)
                            
                              exe 'autocmd! '.a:opts.group
                              if channel
                                call remote#define#AutocmdOnChannel(channel, a:method, a:sync, a:name,
                                      \ a:opts)
                                exe eval(a:forward)
                              else
                                exe 'augroup! '.a:opts.group
                                echoerr 'Host "'a:host.'" for "'.a:name.'" autocmd is not available'
                              endif
                            endfunction
                            
                            
    1              0.000002 function! remote#define#AutocmdOnChannel(channel, method, sync, name, opts)
                              let rpcargs = [a:channel, '"'.a:method.'"']
                              call s:AddEval(rpcargs, a:opts)
                            
                              let autocmd_def = s:GetAutocmdPrefix(a:name, a:opts)
                                    \ . ' call '.s:GetRpcFunction(a:sync).'('.join(rpcargs, ', ').')'
                              exe autocmd_def
                            endfunction
                            
                            
    1              0.000003 function! remote#define#FunctionOnHost(host, method, sync, name, opts)
                              let group = s:GetNextAutocmdGroup()
                              exe 'autocmd! '.group.' FuncUndefined '.a:name
                                    \ .' call remote#define#FunctionBootstrap("'.a:host.'"'
                                    \ .                                 ', "'.a:method.'"'
                                    \ .                                 ', "'.a:sync.'"'
                                    \ .                                 ', "'.a:name.'"'
                                    \ .                                 ', '.string(a:opts)
                                    \ .                                 ', "'.group.'"'
                                    \ .                                 ')'
                            endfunction
                            
                            
    1              0.000003 function! remote#define#FunctionBootstrap(host, method, sync, name, opts, group)
                              let channel = remote#host#Require(a:host)
                            
                              exe 'autocmd! '.a:group
                              exe 'augroup! '.a:group
                              if channel
                                call remote#define#FunctionOnChannel(channel, a:method, a:sync, a:name,
                                      \ a:opts)
                              else
                                echoerr 'Host "'a:host.'" for "'.a:name.'" function is not available'
                              endif
                            endfunction
                            
                            
    1              0.000003 function! remote#define#FunctionOnChannel(channel, method, sync, name, opts)
                              let rpcargs = [a:channel, '"'.a:method.'"', 'a:000']
                              call s:AddEval(rpcargs, a:opts)
                            
                              let function_def = s:GetFunctionPrefix(a:name, a:opts)
                                    \ . 'return '.s:GetRpcFunction(a:sync).'('.join(rpcargs, ', ').')'
                                    \ . "\nendfunction"
                              exe function_def
                            endfunction
                            
                            
    1              0.000002 function! s:GetRpcFunction(sync)
                              if a:sync
                                return 'rpcrequest'
                              endif
                              return 'rpcnotify'
                            endfunction
                            
                            
    1              0.000002 function! s:GetCommandPrefix(name, opts)
                              return 'command!'.s:StringifyOpts(a:opts, ['nargs', 'complete', 'range',
                                    \ 'count', 'bang', 'bar', 'register']).' '.a:name
                            endfunction
                            
                            
                            " Each msgpack-rpc autocommand has it's own unique group, which is derived
                            " from an autoincrementing gid(group id). This is required for replacing the
                            " autocmd implementation with the lazy-load mechanism
    1              0.000002 let s:next_gid = 1
    1              0.000002 function! s:GetNextAutocmdGroup()
                              let gid = s:next_gid
                              let s:next_gid += 1
                              
                              let group_name = 'RPC_DEFINE_AUTOCMD_GROUP_'.gid
                              " Ensure the group is defined
                              exe 'augroup '.group_name.' | augroup END'
                              return group_name
                            endfunction
                            
                            
    1              0.000002 function! s:GetAutocmdPrefix(name, opts)
                              if has_key(a:opts, 'group')
                                let group = a:opts.group
                              else
                                let group = s:GetNextAutocmdGroup()
                              endif
                              let rv = ['autocmd!', group, a:name]
                            
                              if has_key(a:opts, 'pattern')
                                call add(rv, a:opts.pattern)
                              else
                                call add(rv, '*')
                              endif
                            
                              if has_key(a:opts, 'nested') && a:opts.nested
                                call add(rv, 'nested')
                              endif
                            
                              return join(rv, ' ')
                            endfunction
                            
                            
    1              0.000004 function! s:GetFunctionPrefix(name, opts)
                              return "function! ".a:name."(...)\n"
                            endfunction
                            
                            
    1              0.000002 function! s:StringifyOpts(opts, keys)
                              let rv = []
                              for key in a:keys
                                if has_key(a:opts, key)
                                  call add(rv, ' -'.key)
                                  let val = a:opts[key]
                                  if type(val) != type('') || val != ''
                                    call add(rv, '='.val)
                                  endif
                                endif
                              endfor
                              return join(rv, '')
                            endfunction
                            
                            
    1              0.000002 function! s:AddEval(rpcargs, opts)
                              if has_key(a:opts, 'eval')
                                if type(a:opts.eval) != type('') || a:opts.eval == ''
                                  throw "Eval option must be a non-empty string"
                                endif
                                " evaluate an expression and pass as argument
                                call add(a:rpcargs, 'eval("'.escape(a:opts.eval, '"').'")')
                              endif
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/airline-themes.vim
Sourced 1 time
Total time:   0.000013
 Self time:   0.000013

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling & Contributors.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000004 if (exists('g:loaded_airline_themes') && g:loaded_airline_themes)
                              finish
                            endif
    1              0.000003 let g:loaded_airline_themes = 1

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/airline.vim
Sourced 1 time
Total time:   0.000474
 Self time:   0.000200

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000006 if &cp || v:version < 702 || (exists('g:loaded_airline') && g:loaded_airline)
                              finish
                            endif
    1              0.000001 let g:loaded_airline = 1
                            
    1              0.000002 let s:airline_initialized = 0
    1              0.000002 function! s:init()
                              if s:airline_initialized
                                return
                              endif
                              let s:airline_initialized = 1
                            
                              call airline#extensions#load()
                              call airline#init#sections()
                            
                              let s:theme_in_vimrc = exists('g:airline_theme')
                              if s:theme_in_vimrc
                                try
                                  let palette = g:airline#themes#{g:airline_theme}#palette
                                catch
                                  echom 'Could not resolve airline theme "' . g:airline_theme . '". Themes have been migrated to github.com/vim-airline/vim-airline-themes.'
                                  let g:airline_theme = 'dark'
                                endtry
                                silent call airline#switch_theme(g:airline_theme)
                              else
                                let g:airline_theme = 'dark'
                                silent call s:on_colorscheme_changed()
                              endif
                            
                              silent doautocmd User AirlineAfterInit
                            endfunction
                            
    1              0.000002 function! s:on_window_changed()
                              if pumvisible() && (!&previewwindow || g:airline_exclude_preview)
                                return
                              endif
                              call s:init()
                              call airline#update_statusline()
                            endfunction
                            
    1              0.000001 function! s:on_colorscheme_changed()
                              call s:init()
                              let g:airline_gui_mode = airline#init#gui_mode()
                              if !s:theme_in_vimrc
                                call airline#switch_matching_theme()
                              endif
                            
                              " couldn't find a match, or theme was defined, just refresh
                              call airline#load_theme()
                            endfunction
                            
    1              0.000071 function airline#cmdwinenter(...)
                              call airline#extensions#apply_left_override('Command Line', '')
                            endfunction
                            
    1              0.000003 function! s:airline_toggle()
                              if exists("#airline")
                                augroup airline
                                  au!
                                augroup END
                                augroup! airline
                            
                                if exists("s:stl")
                                  let &stl = s:stl
                                endif
                            
                                silent doautocmd User AirlineToggledOff
                              else
                                let s:stl = &statusline
                                augroup airline
                                  autocmd!
                            
                                  autocmd CmdwinEnter *
                                        \ call airline#add_statusline_func('airline#cmdwinenter')
                                        \ | call <sid>on_window_changed()
                                  autocmd CmdwinLeave * call airline#remove_statusline_func('airline#cmdwinenter')
                            
                                  autocmd GUIEnter,ColorScheme * call <sid>on_colorscheme_changed()
                                  autocmd VimEnter,WinEnter,BufWinEnter,FileType,BufUnload,VimResized *
                                        \ call <sid>on_window_changed()
                            
                                  autocmd TabEnter * :unlet! w:airline_lastmode
                                  autocmd BufWritePost */autoload/airline/themes/*.vim
                                        \ exec 'source '.split(globpath(&rtp, 'autoload/airline/themes/'.g:airline_theme.'.vim', 1), "\n")[0]
                                        \ | call airline#load_theme()
                                augroup END
                            
                                if s:airline_initialized
                                  call s:on_window_changed()
                                endif
                            
                                silent doautocmd User AirlineToggledOn
                              endif
                            endfunction
                            
    1              0.000002 function! s:get_airline_themes(a, l, p)
                              let files = split(globpath(&rtp, 'autoload/airline/themes/'.a:a.'*'), "\n")
                              return map(files, 'fnamemodify(v:val, ":t:r")')
                            endfunction
                            
    1              0.000001 function! s:airline_theme(...)
                              if a:0
                                call airline#switch_theme(a:1)
                              else
                                echo g:airline_theme
                              endif
                            endfunction
                            
    1              0.000001 function! s:airline_refresh()
                              silent doautocmd User AirlineBeforeRefresh
                              call airline#load_theme()
                              call airline#update_statusline()
                            endfunction
                            
    1              0.000005 command! -bar -nargs=? -complete=customlist,<sid>get_airline_themes AirlineTheme call <sid>airline_theme(<f-args>)
    1              0.000003 command! -bar AirlineToggleWhitespace call airline#extensions#whitespace#toggle()
    1              0.000002 command! -bar AirlineToggle call s:airline_toggle()
    1              0.000002 command! -bar AirlineRefresh call s:airline_refresh()
                            
    1   0.000008   0.000006 call airline#init#bootstrap()
    1   0.000112   0.000007 call s:airline_toggle()

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline.vim
Sourced 1 time
Total time:   0.000157
 Self time:   0.000157

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000005 let g:airline_statusline_funcrefs = get(g:, 'airline_statusline_funcrefs', [])
                            
    1              0.000003 let s:sections = ['a','b','c','gutter','x','y','z', 'error', 'warning']
    1              0.000001 let s:inactive_funcrefs = []
                            
    1              0.000002 function! airline#add_statusline_func(name)
                              call airline#add_statusline_funcref(function(a:name))
                            endfunction
                            
    1              0.000002 function! airline#add_statusline_funcref(function)
                              if index(g:airline_statusline_funcrefs, a:function) >= 0
                                echohl WarningMsg
                                echo 'The airline statusline funcref '.string(a:function).' has already been added.'
                                echohl NONE
                                return
                              endif
                              call add(g:airline_statusline_funcrefs, a:function)
                            endfunction
                            
    1              0.000002 function! airline#remove_statusline_func(name)
                              let i = index(g:airline_statusline_funcrefs, function(a:name))
                              if i > -1
                                call remove(g:airline_statusline_funcrefs, i)
                              endif
                            endfunction
                            
    1              0.000002 function! airline#add_inactive_statusline_func(name)
                              call add(s:inactive_funcrefs, function(a:name))
                            endfunction
                            
    1              0.000003 function! airline#load_theme()
                              if exists('*airline#themes#{g:airline_theme}#refresh')
                                call airline#themes#{g:airline_theme}#refresh()
                              endif
                            
                              let palette = g:airline#themes#{g:airline_theme}#palette
                              call airline#themes#patch(palette)
                            
                              if exists('g:airline_theme_patch_func')
                                let Fn = function(g:airline_theme_patch_func)
                                call Fn(palette)
                              endif
                            
                              call airline#highlighter#load_theme()
                              call airline#extensions#load_theme()
                              call airline#update_statusline()
                            endfunction
                            
    1              0.000002 function! airline#switch_theme(name)
                              try
                                let palette = g:airline#themes#{a:name}#palette "also lazy loads the theme
                                let g:airline_theme = a:name
                              catch
                                echohl WarningMsg | echo 'The specified theme cannot be found.' | echohl NONE
                                if exists('g:airline_theme')
                                  return
                                else
                                  let g:airline_theme = 'dark'
                                endif
                              endtry
                            
                              let w:airline_lastmode = ''
                              call airline#load_theme()
                            
                              " this is required to prevent clobbering the startup info message, i don't know why...
                              call airline#check_mode(winnr())
                            endfunction
                            
    1              0.000002 function! airline#switch_matching_theme()
                              if exists('g:colors_name')
                                let existing = g:airline_theme
                                let theme = substitute(g:colors_name, '-', '_', 'g')
                                try
                                  let palette = g:airline#themes#{theme}#palette
                                  call airline#switch_theme(theme)
                                  return 1
                                catch
                                  for map in items(g:airline_theme_map)
                                    if match(g:colors_name, map[0]) > -1
                                      try
                                        let palette = g:airline#themes#{map[1]}#palette
                                        call airline#switch_theme(map[1])
                                      catch
                                        call airline#switch_theme(existing)
                                      endtry
                                      return 1
                                    endif
                                  endfor
                                endtry
                              endif
                              return 0
                            endfunction
                            
    1              0.000001 function! airline#update_statusline()
                              if airline#util#getwinvar(winnr(), 'airline_disabled', 0)
                                return
                              endif
                              for nr in filter(range(1, winnr('$')), 'v:val != winnr()')
                                if airline#util#getwinvar(nr, 'airline_disabled', 0)
                                  continue
                                endif
                                call setwinvar(nr, 'airline_active', 0)
                                let context = { 'winnr': nr, 'active': 0, 'bufnr': winbufnr(nr) }
                                call s:invoke_funcrefs(context, s:inactive_funcrefs)
                              endfor
                            
                              unlet! w:airline_render_left
                              unlet! w:airline_render_right
                              for section in s:sections
                                unlet! w:airline_section_{section}
                              endfor
                            
                              let w:airline_active = 1
                              let context = { 'winnr': winnr(), 'active': 1, 'bufnr': winbufnr(winnr()) }
                              call s:invoke_funcrefs(context, g:airline_statusline_funcrefs)
                            endfunction
                            
    1              0.000002 let s:contexts = {}
    1              0.000005 let s:core_funcrefs = [
                                  \ function('airline#extensions#apply'),
                                  \ function('airline#extensions#default#apply') ]
    1              0.000002 function! s:invoke_funcrefs(context, funcrefs)
                              let builder = airline#builder#new(a:context)
                              let err = airline#util#exec_funcrefs(a:funcrefs + s:core_funcrefs, builder, a:context)
                              if err == 1
                                let a:context.line = builder.build()
                                let s:contexts[a:context.winnr] = a:context
                                call setwinvar(a:context.winnr, '&statusline', '%!airline#statusline('.a:context.winnr.')')
                              endif
                            endfunction
                            
    1              0.000004 function! airline#statusline(winnr)
                              if has_key(s:contexts, a:winnr)
                                return '%{airline#check_mode('.a:winnr.')}'.s:contexts[a:winnr].line
                              endif
                            
                              " in rare circumstances this happens...see #276
                              return ''
                            endfunction
                            
    1              0.000002 function! airline#check_mode(winnr)
                              let context = s:contexts[a:winnr]
                            
                              if get(w:, 'airline_active', 1)
                                let l:m = mode()
                                if l:m ==# "i"
                                  let l:mode = ['insert']
                                elseif l:m ==# "R"
                                  let l:mode = ['replace']
                                elseif l:m =~# '\v(v|V||s|S|)'
                                  let l:mode = ['visual']
                                elseif l:m ==# "t"
                                  let l:mode = ['terminal']
                                else
                                  let l:mode = ['normal']
                                endif
                                let w:airline_current_mode = get(g:airline_mode_map, l:m, l:m)
                              else
                                let l:mode = ['inactive']
                                let w:airline_current_mode = get(g:airline_mode_map, '__')
                              endif
                            
                              if g:airline_detect_modified && &modified
                                call add(l:mode, 'modified')
                              endif
                            
                              if g:airline_detect_paste && &paste
                                call add(l:mode, 'paste')
                              endif
                            
                              if g:airline_detect_crypt && exists("+key") && !empty(&key)
                                call add(l:mode, 'crypt')
                              endif
                            
                              if &readonly || ! &modifiable
                                call add(l:mode, 'readonly')
                              endif
                            
                              let mode_string = join(l:mode)
                              if get(w:, 'airline_lastmode', '') != mode_string
                                call airline#highlighter#highlight_modified_inactive(context.bufnr)
                                call airline#highlighter#highlight(l:mode)
                                let w:airline_lastmode = mode_string
                              endif
                            
                              return ''
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/asterisk.vim
Sourced 1 time
Total time:   0.000118
 Self time:   0.000118

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: plugin/asterisk.vim
                            " AUTHOR: haya14busa
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
    1              0.000002 scriptencoding utf-8
                            " Load Once {{{
    1              0.000017 if expand('%:p') ==# expand('<sfile>:p')
                                unlet! g:loaded_asterisk
                            endif
    1              0.000002 if exists('g:loaded_asterisk')
                                finish
                            endif
    1              0.000002 let g:loaded_asterisk = 1
                            " }}}
                            
                            " Saving 'cpoptions' {{{
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            " }}}
                            
    1              0.000010 noremap <expr><silent> <Plug>(asterisk-*)   asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 1, 'is_whole' : 1})
    1              0.000008 noremap <expr><silent> <Plug>(asterisk-g*)  asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 1, 'is_whole' : 0})
    1              0.000009 noremap <expr><silent> <Plug>(asterisk-z*)  asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 0, 'is_whole' : 1})
    1              0.000007 noremap <expr><silent> <Plug>(asterisk-gz*) asterisk#do(mode(1), {'direction' : 1, 'do_jump' : 0, 'is_whole' : 0})
    1              0.000007 noremap <expr><silent> <Plug>(asterisk-#)   asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 1, 'is_whole' : 1})
    1              0.000007 noremap <expr><silent> <Plug>(asterisk-g#)  asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 1, 'is_whole' : 0})
    1              0.000007 noremap <expr><silent> <Plug>(asterisk-z#)  asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 0, 'is_whole' : 1})
    1              0.000007 noremap <expr><silent> <Plug>(asterisk-gz#) asterisk#do(mode(1), {'direction' : 0, 'do_jump' : 0, 'is_whole' : 0})
                            
                            " Restore 'cpoptions' {{{
    1              0.000004 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            " }}}
                            " __END__  {{{
                            " vim: expandtab softtabstop=4 shiftwidth=4
                            " vim: foldmethod=marker
                            " }}}

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/auto-pairs.vim
Sourced 1 time
Total time:   0.000383
 Self time:   0.000383

count  total (s)   self (s)
                            " Insert or delete brackets, parens, quotes in pairs.
                            " Maintainer:	JiangMiao <jiangfriend@gmail.com>
                            " Contributor: camthompson
                            " Last Change:  2013-07-13
                            " Version: 1.3.2
                            " Homepage: http://www.vim.org/scripts/script.php?script_id=3599
                            " Repository: https://github.com/jiangmiao/auto-pairs
                            " License: MIT
                            
    1              0.000004 if exists('g:AutoPairsLoaded') || &cp
                              finish
                            end
    1              0.000002 let g:AutoPairsLoaded = 1
                            
    1              0.000002 if !exists('g:AutoPairs')
    1              0.000004   let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
    1              0.000001 end
                            
    1              0.000002 if !exists('g:AutoPairsParens')
    1              0.000002   let g:AutoPairsParens = {'(':')', '[':']', '{':'}'}
    1              0.000001 end
                            
    1              0.000001 if !exists('g:AutoPairsMapBS')
    1              0.000001   let g:AutoPairsMapBS = 1
    1              0.000001 end
                            
    1              0.000001 if !exists('g:AutoPairsMapCR')
    1              0.000001   let g:AutoPairsMapCR = 1
    1              0.000001 end
                            
    1              0.000002 if !exists('g:AutoPairsMapSpace')
    1              0.000001   let g:AutoPairsMapSpace = 1
    1              0.000001 end
                            
    1              0.000002 if !exists('g:AutoPairsCenterLine')
    1              0.000001   let g:AutoPairsCenterLine = 1
    1              0.000001 end
                            
    1              0.000002 if !exists('g:AutoPairsShortcutToggle')
    1              0.000001   let g:AutoPairsShortcutToggle = '<M-p>'
    1              0.000001 end
                            
    1              0.000002 if !exists('g:AutoPairsShortcutFastWrap')
    1              0.000001   let g:AutoPairsShortcutFastWrap = '<M-e>'
    1              0.000000 end
                            
    1              0.000002 if !exists('g:AutoPairsShortcutJump')
    1              0.000001   let g:AutoPairsShortcutJump = '<M-n>'
    1              0.000001 endif
                            
                            " Fly mode will for closed pair to jump to closed pair instead of insert.
                            " also support AutoPairsBackInsert to insert pairs where jumped.
    1              0.000001 if !exists('g:AutoPairsFlyMode')
    1              0.000001   let g:AutoPairsFlyMode = 0
    1              0.000001 endif
                            
                            " When skipping the closed pair, look at the current and
                            " next line as well.
    1              0.000002 if !exists('g:AutoPairsMultilineClose')
    1              0.000001   let g:AutoPairsMultilineClose = 1
    1              0.000001 endif
                            
                            " Work with Fly Mode, insert pair where jumped
    1              0.000002 if !exists('g:AutoPairsShortcutBackInsert')
    1              0.000001   let g:AutoPairsShortcutBackInsert = '<M-b>'
    1              0.000002 endif
                            
    1              0.000002 if !exists('g:AutoPairsSmartQuotes')
    1              0.000001   let g:AutoPairsSmartQuotes = 1
    1              0.000001 endif
                            
                            
                            " Will auto generated {']' => '[', ..., '}' => '{'}in initialize.
    1              0.000001 let g:AutoPairsClosedPairs = {}
                            
                            
    1              0.000002 function! AutoPairsInsert(key)
                              if !b:autopairs_enabled
                                return a:key
                              end
                            
                              let line = getline('.')
                              let pos = col('.') - 1
                              let before = strpart(line, 0, pos)
                              let after = strpart(line, pos)
                              let next_chars = split(after, '\zs')
                              let current_char = get(next_chars, 0, '')
                              let next_char = get(next_chars, 1, '')
                              let prev_chars = split(before, '\zs')
                              let prev_char = get(prev_chars, -1, '')
                            
                              let eol = 0
                              if col('$') -  col('.') <= 1
                                let eol = 1
                              end
                            
                              " Ignore auto close if prev character is \
                              if prev_char == '\'
                                return a:key
                              end
                            
                              " The key is difference open-pair, then it means only for ) ] } by default
                              if !has_key(b:AutoPairs, a:key)
                                let b:autopairs_saved_pair = [a:key, getpos('.')]
                            
                                " Skip the character if current character is the same as input
                                if current_char == a:key
                                  return "\<Right>"
                                end
                            
                                if !g:AutoPairsFlyMode
                                  " Skip the character if next character is space
                                  if current_char == ' ' && next_char == a:key
                                    return "\<Right>\<Right>"
                                  end
                            
                                  " Skip the character if closed pair is next character
                                  if current_char == ''
                                    if g:AutoPairsMultilineClose
                                      let next_lineno = line('.')+1
                                      let next_line = getline(nextnonblank(next_lineno))
                                      let next_char = matchstr(next_line, '\s*\zs.')
                                    else
                                      let next_char = matchstr(line, '\s*\zs.')
                                    end
                                    if next_char == a:key
                                      return "\<ESC>e^a"
                                    endif
                                  endif
                                endif
                            
                                " Fly Mode, and the key is closed-pairs, search closed-pair and jump
                                if g:AutoPairsFlyMode && has_key(b:AutoPairsClosedPairs, a:key)
                                  if search(a:key, 'W')
                                    return "\<Right>"
                                  endif
                                endif
                            
                                " Insert directly if the key is not an open key
                                return a:key
                              end
                            
                              let open = a:key
                              let close = b:AutoPairs[open]
                            
                              if current_char == close && open == close
                                return "\<Right>"
                              end
                            
                              " Ignore auto close ' if follows a word
                              " MUST after closed check. 'hello|'
                              if a:key == "'" && prev_char =~ '\v\w'
                                return a:key
                              end
                            
                              " support for ''' ``` and """
                              if open == close
                                " The key must be ' " `
                                let pprev_char = line[col('.')-3]
                                if pprev_char == open && prev_char == open
                                  " Double pair found
                                  return repeat(a:key, 4) . repeat("\<LEFT>", 3)
                                end
                              end
                            
                              let quotes_num = 0
                              " Ignore comment line for vim file
                              if &filetype == 'vim' && a:key == '"'
                                if before =~ '^\s*$'
                                  return a:key
                                end
                                if before =~ '^\s*"'
                                  let quotes_num = -1
                                end
                              end
                            
                              " Keep quote number is odd.
                              " Because quotes should be matched in the same line in most of situation
                              if g:AutoPairsSmartQuotes && open == close
                                " Remove \\ \" \'
                                let cleaned_line = substitute(line, '\v(\\.)', '', 'g')
                                let n = quotes_num
                                let pos = 0
                                while 1
                                  let pos = stridx(cleaned_line, open, pos)
                                  if pos == -1
                                    break
                                  end
                                  let n = n + 1
                                  let pos = pos + 1
                                endwhile
                                if n % 2 == 1
                                  return a:key
                                endif
                              endif
                            
                              return open.close."\<Left>"
                            endfunction
                            
    1              0.000001 function! AutoPairsDelete()
                              if !b:autopairs_enabled
                                return "\<BS>"
                              end
                            
                              let line = getline('.')
                              let pos = col('.') - 1
                              let current_char = get(split(strpart(line, pos), '\zs'), 0, '')
                              let prev_chars = split(strpart(line, 0, pos), '\zs')
                              let prev_char = get(prev_chars, -1, '')
                              let pprev_char = get(prev_chars, -2, '')
                            
                              if pprev_char == '\'
                                return "\<BS>"
                              end
                            
                              " Delete last two spaces in parens, work with MapSpace
                              if has_key(b:AutoPairs, pprev_char) && prev_char == ' ' && current_char == ' '
                                return "\<BS>\<DEL>"
                              endif
                            
                              " Delete Repeated Pair eg: '''|''' [[|]] {{|}}
                              if has_key(b:AutoPairs, prev_char)
                                let times = 0
                                let p = -1
                                while get(prev_chars, p, '') == prev_char
                                  let p = p - 1
                                  let times = times + 1
                                endwhile
                            
                                let close = b:AutoPairs[prev_char]
                                let left = repeat(prev_char, times)
                                let right = repeat(close, times)
                            
                                let before = strpart(line, pos-times, times)
                                let after  = strpart(line, pos, times)
                                if left == before && right == after
                                  return repeat("\<BS>\<DEL>", times)
                                end
                              end
                            
                            
                              if has_key(b:AutoPairs, prev_char) 
                                let close = b:AutoPairs[prev_char]
                                if match(line,'^\s*'.close, col('.')-1) != -1
                                  " Delete (|___)
                                  let space = matchstr(line, '^\s*', col('.')-1)
                                  return "\<BS>". repeat("\<DEL>", len(space)+1)
                                elseif match(line, '^\s*$', col('.')-1) != -1
                                  " Delete (|__\n___)
                                  let nline = getline(line('.')+1)
                                  if nline =~ '^\s*'.close
                                    if &filetype == 'vim' && prev_char == '"'
                                      " Keep next line's comment
                                      return "\<BS>"
                                    end
                            
                                    let space = matchstr(nline, '^\s*')
                                    return "\<BS>\<DEL>". repeat("\<DEL>", len(space)+1)
                                  end
                                end
                              end
                            
                              return "\<BS>"
                            endfunction
                            
    1              0.000001 function! AutoPairsJump()
                              call search('["\]'')}]','W')
                            endfunction
                            " string_chunk cannot use standalone
    1              0.000002 let s:string_chunk = '\v%(\\\_.|[^\1]|[\r\n]){-}'
    1              0.000003 let s:ss_pattern = '\v''' . s:string_chunk . ''''
    1              0.000002 let s:ds_pattern = '\v"'  . s:string_chunk . '"'
                            
    1              0.000002 func! s:RegexpQuote(str)
                              return substitute(a:str, '\v[\[\{\(\<\>\)\}\]]', '\\&', 'g')
                            endf
                            
    1              0.000002 func! s:RegexpQuoteInSquare(str)
                              return substitute(a:str, '\v[\[\]]', '\\&', 'g')
                            endf
                            
                            " Search next open or close pair
    1              0.000001 func! s:FormatChunk(open, close)
                              let open = s:RegexpQuote(a:open)
                              let close = s:RegexpQuote(a:close)
                              let open2 = s:RegexpQuoteInSquare(a:open)
                              let close2 = s:RegexpQuoteInSquare(a:close)
                              if open == close
                                return '\v'.open.s:string_chunk.close
                              else
                                return '\v%(' . s:ss_pattern . '|' . s:ds_pattern . '|' . '[^'.open2.close2.']|[\r\n]' . '){-}(['.open2.close2.'])'
                              end
                            endf
                            
                            " Fast wrap the word in brackets
    1              0.000001 function! AutoPairsFastWrap()
                              let line = getline('.')
                              let current_char = line[col('.')-1]
                              let next_char = line[col('.')]
                              let open_pair_pattern = '\v[({\[''"]'
                              let at_end = col('.') >= col('$') - 1
                              normal x
                              " Skip blank
                              if next_char =~ '\v\s' || at_end
                                call search('\v\S', 'W')
                                let line = getline('.')
                                let next_char = line[col('.')-1]
                              end
                            
                              if has_key(b:AutoPairs, next_char)
                                let followed_open_pair = next_char
                                let inputed_close_pair = current_char
                                let followed_close_pair = b:AutoPairs[next_char]
                                if followed_close_pair != followed_open_pair
                                  " TODO replace system searchpair to skip string and nested pair.
                                  " eg: (|){"hello}world"} will transform to ({"hello})world"}
                                  call searchpair('\V'.followed_open_pair, '', '\V'.followed_close_pair, 'W')
                                else
                                  call search(s:FormatChunk(followed_open_pair, followed_close_pair), 'We')
                                end
                                return "\<RIGHT>".inputed_close_pair."\<LEFT>"
                              else
                                normal he
                                return "\<RIGHT>".current_char."\<LEFT>"
                              end
                            endfunction
                            
    1              0.000001 function! AutoPairsMap(key)
                              " | is special key which separate map command from text
                              let key = a:key
                              if key == '|'
                                let key = '<BAR>'
                              end
                              let escaped_key = substitute(key, "'", "''", 'g')
                              " use expr will cause search() doesn't work
                              execute 'inoremap <buffer> <silent> '.key." <C-R>=AutoPairsInsert('".escaped_key."')<CR>"
                            endfunction
                            
    1              0.000001 function! AutoPairsToggle()
                              if b:autopairs_enabled
                                let b:autopairs_enabled = 0
                                echo 'AutoPairs Disabled.'
                              else
                                let b:autopairs_enabled = 1
                                echo 'AutoPairs Enabled.'
                              end
                              return ''
                            endfunction
                            
    1              0.000001 function! AutoPairsReturn()
                              if b:autopairs_enabled == 0
                                return ''
                              end
                              let line = getline('.')
                              let pline = getline(line('.')-1)
                              let prev_char = pline[strlen(pline)-1]
                              let cmd = ''
                              let cur_char = line[col('.')-1]
                              if has_key(b:AutoPairs, prev_char) && b:AutoPairs[prev_char] == cur_char
                                if g:AutoPairsCenterLine && winline() * 3 >= winheight(0) * 2
                                  " Use \<BS> instead of \<ESC>cl will cause the placeholder deleted
                                  " incorrect. because <C-O>zz won't leave Normal mode.
                                  " Use \<DEL> is a bit wierd. the character before cursor need to be deleted.
                                  let cmd = " \<C-O>zz\<ESC>cl"
                                end
                            
                                " If equalprg has been set, then avoid call =
                                " https://github.com/jiangmiao/auto-pairs/issues/24
                                if &equalprg != ''
                                  return "\<ESC>O".cmd
                                endif
                            
                                " conflict with javascript and coffee
                                " javascript   need   indent new line
                                " coffeescript forbid indent new line
                                if &filetype == 'coffeescript' || &filetype == 'coffee'
                                  return "\<ESC>k==o".cmd
                                else
                                  return "\<ESC>=ko".cmd
                                endif
                              end
                              return ''
                            endfunction
                            
    1              0.000001 function! AutoPairsSpace()
                              let line = getline('.')
                              let prev_char = line[col('.')-2]
                              let cmd = ''
                              let cur_char =line[col('.')-1]
                              if has_key(g:AutoPairsParens, prev_char) && g:AutoPairsParens[prev_char] == cur_char
                                let cmd = "\<SPACE>\<LEFT>"
                              endif
                              return "\<SPACE>".cmd
                            endfunction
                            
    1              0.000001 function! AutoPairsBackInsert()
                              if exists('b:autopairs_saved_pair')
                                let pair = b:autopairs_saved_pair[0]
                                let pos  = b:autopairs_saved_pair[1]
                                call setpos('.', pos)
                                return pair
                              endif
                              return ''
                            endfunction
                            
    1              0.000001 function! AutoPairsInit()
                              let b:autopairs_loaded  = 1
                              let b:autopairs_enabled = 1
                              let b:AutoPairsClosedPairs = {}
                            
                              if !exists('b:AutoPairs')
                                let b:AutoPairs = g:AutoPairs
                              end
                            
                              " buffer level map pairs keys
                              for [open, close] in items(b:AutoPairs)
                                call AutoPairsMap(open)
                                if open != close
                                  call AutoPairsMap(close)
                                end
                                let b:AutoPairsClosedPairs[close] = open
                              endfor
                            
                              " Still use <buffer> level mapping for <BS> <SPACE>
                              if g:AutoPairsMapBS
                                " Use <C-R> instead of <expr> for issue #14 sometimes press BS output strange words
                                execute 'inoremap <buffer> <silent> <BS> <C-R>=AutoPairsDelete()<CR>'
                                execute 'inoremap <buffer> <silent> <C-H> <C-R>=AutoPairsDelete()<CR>'
                              end
                            
                              if g:AutoPairsMapSpace
                                " Try to respect abbreviations on a <SPACE>
                                let do_abbrev = ""
                                if v:version == 703 && has("patch489") || v:version > 703
                                  let do_abbrev = "<C-]>"
                                endif
                                execute 'inoremap <buffer> <silent> <SPACE> '.do_abbrev.'<C-R>=AutoPairsSpace()<CR>'
                              end
                            
                              if g:AutoPairsShortcutFastWrap != ''
                                execute 'inoremap <buffer> <silent> '.g:AutoPairsShortcutFastWrap.' <C-R>=AutoPairsFastWrap()<CR>'
                              end
                            
                              if g:AutoPairsShortcutBackInsert != ''
                                execute 'inoremap <buffer> <silent> '.g:AutoPairsShortcutBackInsert.' <C-R>=AutoPairsBackInsert()<CR>'
                              end
                            
                              if g:AutoPairsShortcutToggle != ''
                                " use <expr> to ensure showing the status when toggle
                                execute 'inoremap <buffer> <silent> <expr> '.g:AutoPairsShortcutToggle.' AutoPairsToggle()'
                                execute 'noremap <buffer> <silent> '.g:AutoPairsShortcutToggle.' :call AutoPairsToggle()<CR>'
                              end
                            
                              if g:AutoPairsShortcutJump != ''
                                execute 'inoremap <buffer> <silent> ' . g:AutoPairsShortcutJump. ' <ESC>:call AutoPairsJump()<CR>a'
                                execute 'noremap <buffer> <silent> ' . g:AutoPairsShortcutJump. ' :call AutoPairsJump()<CR>'
                              end
                            
                            endfunction
                            
    1              0.000002 function! s:ExpandMap(map)
                              let map = a:map
                              let map = substitute(map, '\(<Plug>\w\+\)', '\=maparg(submatch(1), "i")', 'g')
                              return map
                            endfunction
                            
    1              0.000001 function! AutoPairsTryInit()
                              if exists('b:autopairs_loaded')
                                return
                              end
                            
                              " for auto-pairs starts with 'a', so the priority is higher than supertab and vim-endwise
                              "
                              " vim-endwise doesn't support <Plug>AutoPairsReturn
                              " when use <Plug>AutoPairsReturn will cause <Plug> isn't expanded
                              "
                              " supertab doesn't support <SID>AutoPairsReturn
                              " when use <SID>AutoPairsReturn  will cause Duplicated <CR>
                              "
                              " and when load after vim-endwise will cause unexpected endwise inserted. 
                              " so always load AutoPairs at last
                              
                              " Buffer level keys mapping
                              " comptible with other plugin
                              if g:AutoPairsMapCR
                                if v:version == 703 && has('patch32') || v:version > 703
                                  " VIM 7.3 supports advancer maparg which could get <expr> info
                                  " then auto-pairs could remap <CR> in any case.
                                  let info = maparg('<CR>', 'i', 0, 1)
                                  if empty(info)
                                    let old_cr = '<CR>'
                                    let is_expr = 0
                                  else
                                    let old_cr = info['rhs']
                                    let old_cr = s:ExpandMap(old_cr)
                                    let old_cr = substitute(old_cr, '<SID>', '<SNR>' . info['sid'] . '_', 'g')
                                    let is_expr = info['expr']
                                    let wrapper_name = '<SID>AutoPairsOldCRWrapper73'
                                  endif
                                else
                                  " VIM version less than 7.3
                                  " the mapping's <expr> info is lost, so guess it is expr or not, it's
                                  " not accurate.
                                  let old_cr = maparg('<CR>', 'i')
                                  if old_cr == ''
                                    let old_cr = '<CR>'
                                    let is_expr = 0
                                  else
                                    let old_cr = s:ExpandMap(old_cr)
                                    " old_cr contain (, I guess the old cr is in expr mode
                                    let is_expr = old_cr =~ '\V(' && toupper(old_cr) !~ '\V<C-R>'
                            
                                    " The old_cr start with " it must be in expr mode
                                    let is_expr = is_expr || old_cr =~ '\v^"'
                                    let wrapper_name = '<SID>AutoPairsOldCRWrapper'
                                  end
                                end
                            
                                if old_cr !~ 'AutoPairsReturn'
                                  if is_expr
                                    " remap <expr> to `name` to avoid mix expr and non-expr mode
                                    execute 'inoremap <buffer> <expr> <script> '. wrapper_name . ' ' . old_cr
                                    let old_cr = wrapper_name
                                  end
                                  " Always silent mapping
                                  execute 'inoremap <script> <buffer> <silent> <CR> '.old_cr.'<SID>AutoPairsReturn'
                                end
                              endif
                              call AutoPairsInit()
                            endfunction
                            
                            " Always silent the command
    1              0.000008 inoremap <silent> <SID>AutoPairsReturn <C-R>=AutoPairsReturn()<CR>
    1              0.000005 imap <script> <Plug>AutoPairsReturn <SID>AutoPairsReturn
                            
                            
    1              0.000005 au BufEnter * :call AutoPairsTryInit()

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/committia.vim
Sourced 1 time
Total time:   0.000080
 Self time:   0.000080

count  total (s)   self (s)
                            if (exists('g:loaded_committia') && g:loaded_committia) || &cp
                                finish
                            endif
                            
    1              0.000004 let g:committia_open_only_vim_starting = get(g:, 'committia_open_only_vim_starting', 1)
                            
    1              0.000002 function! s:should_open(ft) abort
                                return &ft ==# a:ft && (!g:committia_open_only_vim_starting || has('vim_starting')) && !exists('b:committia_opened')
                            endfunction
                            
    1              0.000001 augroup plugin-committia
    1              0.000031     autocmd!
    1              0.000025     autocmd BufReadPost COMMIT_EDITMSG,MERGE_MSG if s:should_open('gitcommit') | call committia#open('git') | endif
                            
                                " ... Add other VCSs' commit editor filetypes
    1              0.000001 augroup END
                            
    1              0.000003 let g:loaded_committia = 1

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/ctrlp.vim
Sourced 1 time
Total time:   0.000558
 Self time:   0.000235

count  total (s)   self (s)
                            " =============================================================================
                            " File:          plugin/ctrlp.vim
                            " Description:   Fuzzy file, buffer, mru, tag, etc finder.
                            " Author:        Kien Nguyen <github.com/kien>
                            " =============================================================================
                            " GetLatestVimScripts: 3736 1 :AutoInstall: ctrlp.zip
                            
    1              0.000006 if ( exists('g:loaded_ctrlp') && g:loaded_ctrlp ) || v:version < 700 || &cp
                            	fini
                            en
    1              0.000001 let g:loaded_ctrlp = 1
                            
    1              0.000008 let [g:ctrlp_lines, g:ctrlp_allfiles, g:ctrlp_alltags, g:ctrlp_alldirs,
                            	\ g:ctrlp_allmixes, g:ctrlp_buftags, g:ctrlp_ext_vars, g:ctrlp_builtins]
                            	\ = [[], [], [], [], {}, {}, [], 2]
                            
    1              0.000004 if !exists('g:ctrlp_map') | let g:ctrlp_map = '<c-p>' | en
    1              0.000003 if !exists('g:ctrlp_cmd') | let g:ctrlp_cmd = 'CtrlP' | en
                            
    1              0.000004 com! -n=? -com=dir CtrlP         cal ctrlp#init(0, { 'dir': <q-args> })
    1              0.000003 com! -n=? -com=dir CtrlPMRUFiles cal ctrlp#init(2, { 'dir': <q-args> })
                            
    1              0.000004 com! -bar CtrlPBuffer   cal ctrlp#init(1)
    1              0.000003 com! -n=? CtrlPLastMode cal ctrlp#init(-1, { 'args': <q-args> })
                            
    1              0.000002 com! -bar CtrlPClearCache     cal ctrlp#clr()
    1              0.000002 com! -bar CtrlPClearAllCaches cal ctrlp#clra()
                            
    1              0.000002 com! -bar ClearCtrlPCache     cal ctrlp#clr()
    1              0.000002 com! -bar ClearAllCtrlPCaches cal ctrlp#clra()
                            
    1              0.000003 com! -bar CtrlPCurWD   cal ctrlp#init(0, { 'mode': '' })
    1              0.000003 com! -bar CtrlPCurFile cal ctrlp#init(0, { 'mode': 'c' })
    1              0.000004 com! -bar CtrlPRoot    cal ctrlp#init(0, { 'mode': 'r' })
                            
    1              0.000010 exe 'nn <silent> <plug>(ctrlp) :<c-u>'.g:ctrlp_cmd.'<cr>'
                            
    1              0.000009 if g:ctrlp_map != '' && !hasmapto('<plug>(ctrlp)')
    1              0.000007 	exe 'map' g:ctrlp_map '<plug>(ctrlp)'
    1              0.000001 en
                            
    1              0.000077 cal ctrlp#mrufiles#init()
                            
    1              0.000004 com! -bar CtrlPTag      cal ctrlp#init(ctrlp#tag#id())
    1              0.000003 com! -bar CtrlPQuickfix cal ctrlp#init(ctrlp#quickfix#id())
                            
    1              0.000005 com! -n=? -com=dir CtrlPDir
                            	\ cal ctrlp#init(ctrlp#dir#id(), { 'dir': <q-args> })
                            
    1              0.000004 com! -n=? -com=buffer CtrlPBufTag
                            	\ cal ctrlp#init(ctrlp#buffertag#cmd(0, <q-args>))
                            
    1              0.000003 com! -bar CtrlPBufTagAll cal ctrlp#init(ctrlp#buffertag#cmd(1))
    1              0.000003 com! -bar CtrlPRTS       cal ctrlp#init(ctrlp#rtscript#id())
    1              0.000003 com! -bar CtrlPUndo      cal ctrlp#init(ctrlp#undo#id())
                            
    1              0.000004 com! -n=? -com=buffer CtrlPLine
                            	\ cal ctrlp#init(ctrlp#line#cmd(1, <q-args>))
                            
    1              0.000004 com! -n=? -com=buffer CtrlPChange
                            	\ cal ctrlp#init(ctrlp#changes#cmd(0, <q-args>))
                            
    1              0.000003 com! -bar CtrlPChangeAll   cal ctrlp#init(ctrlp#changes#cmd(1))
    1              0.000003 com! -bar CtrlPMixed       cal ctrlp#init(ctrlp#mixed#id())
    1              0.000003 com! -bar CtrlPBookmarkDir cal ctrlp#init(ctrlp#bookmarkdir#id())
                            
    1              0.000007 com! -n=? -com=dir -bang CtrlPBookmarkDirAdd
                            	\ cal ctrlp#call('ctrlp#bookmarkdir#add', '<bang>', <q-args>)
                            
                            " vim:ts=2:sw=2:sts=2

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/ctrlp/mrufiles.vim
Sourced 1 time
Total time:   0.000246
 Self time:   0.000127

count  total (s)   self (s)
                            " =============================================================================
                            " File:          autoload/ctrlp/mrufiles.vim
                            " Description:   Most Recently Used Files extension
                            " Author:        Kien Nguyen <github.com/kien>
                            " =============================================================================
                            
                            " Static variables {{{1
    1              0.000004 let [s:mrbs, s:mrufs] = [[], []]
    1              0.000002 let s:mruf_map_string = '!stridx(v:val, cwd) ? strpart(v:val, idx) : v:val'
                            
    1              0.000002 fu! ctrlp#mrufiles#opts()
                            	let [pref, opts] = ['g:ctrlp_mruf_', {
                            		\ 'max': ['s:max', 250],
                            		\ 'include': ['s:in', ''],
                            		\ 'exclude': ['s:ex', ''],
                            		\ 'case_sensitive': ['s:cseno', 1],
                            		\ 'relative': ['s:re', 0],
                            		\ 'save_on_update': ['s:soup', 1],
                            		\ 'map_string': ['g:ctrlp_mruf_map_string', s:mruf_map_string],
                            		\ }]
                            	for [ke, va] in items(opts)
                            		let [{va[0]}, {pref.ke}] = [pref.ke, exists(pref.ke) ? {pref.ke} : va[1]]
                            	endfo
                            endf
    1   0.000129   0.000010 cal ctrlp#mrufiles#opts()
                            " Utilities {{{1
    1              0.000002 fu! s:excl(fn)
                            	retu !empty({s:ex}) && a:fn =~# {s:ex}
                            endf
                            
    1              0.000001 fu! s:mergelists()
                            	let diskmrufs = ctrlp#utils#readfile(ctrlp#mrufiles#cachefile())
                            	cal filter(diskmrufs, 'index(s:mrufs, v:val) < 0')
                            	let mrufs = s:mrufs + diskmrufs
                            	retu s:chop(mrufs)
                            endf
                            
    1              0.000001 fu! s:chop(mrufs)
                            	if len(a:mrufs) > {s:max} | cal remove(a:mrufs, {s:max}, -1) | en
                            	retu a:mrufs
                            endf
                            
    1              0.000001 fu! s:reformat(mrufs, ...)
                            	let cwd = getcwd()
                            	let cwd .= cwd !~ '[\/]$' ? ctrlp#utils#lash() : ''
                            	if {s:re}
                            		let cwd = exists('+ssl') ? tr(cwd, '/', '\') : cwd
                            		cal filter(a:mrufs, '!stridx(v:val, cwd)')
                            	en
                            	if a:0 && a:1 == 'raw' | retu a:mrufs | en
                            	let idx = strlen(cwd)
                            	if exists('+ssl') && &ssl
                            		let cwd = tr(cwd, '\', '/')
                            		cal map(a:mrufs, 'tr(v:val, "\\", "/")')
                            	en
                            	retu map(a:mrufs, g:ctrlp_mruf_map_string)
                            endf
                            
    1              0.000001 fu! s:record(bufnr)
                            	if s:locked | retu | en
                            	let bufnr = a:bufnr + 0
                            	let bufname = bufname(bufnr)
                            	if bufnr > 0 && !empty(bufname)
                            		cal filter(s:mrbs, 'v:val != bufnr')
                            		cal insert(s:mrbs, bufnr)
                            		cal s:addtomrufs(bufname)
                            	en
                            endf
                            
    1              0.000001 fu! s:addtomrufs(fname)
                            	let fn = fnamemodify(a:fname, get(g:, 'ctrlp_tilde_homedir', 0) ? ':p:~' : ':p')
                            	let fn = exists('+ssl') ? tr(fn, '/', '\') : fn
                            	let abs_fn = fnamemodify(fn,':p')
                            	if ( !empty({s:in}) && fn !~# {s:in} ) || ( !empty({s:ex}) && fn =~# {s:ex} )
                            		\ || !empty(getbufvar('^' . abs_fn . '$', '&bt'))
                            		retu
                            	en
                            	let idx = index(s:mrufs, fn, 0, !{s:cseno})
                            	if idx
                            		cal filter(s:mrufs, 'v:val !='.( {s:cseno} ? '#' : '?' ).' fn')
                            		cal insert(s:mrufs, fn)
                            		if {s:soup} && idx < 0
                            			cal s:savetofile(s:mergelists())
                            		en
                            	en
                            endf
                            
    1              0.000001 fu! s:savetofile(mrufs)
                            	cal ctrlp#utils#writecache(a:mrufs, s:cadir, s:cafile)
                            endf
                            " Public {{{1
    1              0.000002 fu! ctrlp#mrufiles#refresh(...)
                            	let mrufs = s:mergelists()
                            	cal filter(mrufs, '!empty(ctrlp#utils#glob(v:val, 1)) && !s:excl(v:val)')
                            	if exists('+ssl')
                            		cal map(mrufs, 'tr(v:val, "/", "\\")')
                            		cal map(s:mrufs, 'tr(v:val, "/", "\\")')
                            		let cond = 'count(mrufs, v:val, !{s:cseno}) == 1'
                            		cal filter(mrufs, cond)
                            		cal filter(s:mrufs, cond)
                            	en
                            	cal s:savetofile(mrufs)
                            	retu a:0 && a:1 == 'raw' ? [] : s:reformat(mrufs)
                            endf
                            
    1              0.000002 fu! ctrlp#mrufiles#remove(files)
                            	let mrufs = []
                            	if a:files != []
                            		let mrufs = s:mergelists()
                            		let cond = 'index(a:files, v:val, 0, !{s:cseno}) < 0'
                            		cal filter(mrufs, cond)
                            		cal filter(s:mrufs, cond)
                            	en
                            	cal s:savetofile(mrufs)
                            	retu s:reformat(mrufs)
                            endf
                            
    1              0.000002 fu! ctrlp#mrufiles#add(fn)
                            	if !empty(a:fn)
                            		cal s:addtomrufs(a:fn)
                            	en
                            endf
                            
    1              0.000002 fu! ctrlp#mrufiles#list(...)
                            	retu a:0 ? a:1 == 'raw' ? s:reformat(s:mergelists(), a:1) : 0
                            		\ : s:reformat(s:mergelists())
                            endf
                            
    1              0.000001 fu! ctrlp#mrufiles#bufs()
                            	retu s:mrbs
                            endf
                            
    1              0.000001 fu! ctrlp#mrufiles#tgrel()
                            	let {s:re} = !{s:re}
                            endf
                            
    1              0.000002 fu! ctrlp#mrufiles#cachefile()
                            	if !exists('s:cadir') || !exists('s:cafile')
                            		let s:cadir = ctrlp#utils#cachedir().ctrlp#utils#lash().'mru'
                            		let s:cafile = s:cadir.ctrlp#utils#lash().'cache.txt'
                            	en
                            	retu s:cafile
                            endf
                            
    1              0.000001 fu! ctrlp#mrufiles#init()
                            	if !has('autocmd') | retu | en
                            	let s:locked = 0
                            	aug CtrlPMRUF
                            		au!
                            		au BufWinEnter,BufWinLeave,BufWritePost * cal s:record(expand('<abuf>', 1))
                            		au QuickFixCmdPre  *vimgrep* let s:locked = 1
                            		au QuickFixCmdPost *vimgrep* let s:locked = 0
                            		au VimLeavePre * cal s:savetofile(s:mergelists())
                            	aug END
                            endf
                            "}}}
                            
                            " vim:fen:fdm=marker:fmr={{{,}}}:fdl=0:fdc=1:ts=2:sw=2:sts=2

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/deoplete-swift.vim
Sourced 1 time
Total time:   0.000016
 Self time:   0.000016

count  total (s)   self (s)
                            if exists('g:loaded_deoplete_swift')
                              finish
                            endif
    1              0.000002 let g:loaded_deoplete_d = 1
                            
    1              0.000003 if !exists("g:deoplete#sources#swift#source_kitten_binary")
    1              0.000002   let g:deoplete#sources#swift#source_kitten_binary = ''
    1              0.000001 endif
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/deoplete.vim
Sourced 1 time
Total time:   0.000035
 Self time:   0.000035

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: deoplete.vim
                            " AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_deoplete')
                              finish
                            endif
    1              0.000002 let g:loaded_deoplete = 1
                            
    1              0.000004 command! -nargs=0 -bar DeopleteEnable
                                  \ call deoplete#init#enable()
                            
                            " Global options definition. "{{{
    1              0.000003 if get(g:, 'deoplete#enable_at_startup', 0)
    1              0.000001   augroup deoplete
    1              0.000006     autocmd CursorHold,InsertEnter * call deoplete#init#enable()
    1              0.000001   augroup END
    1              0.000001 endif
                            "}}}
                            
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/dirvish.vim
Sourced 1 time
Total time:   0.000071
 Self time:   0.000071

count  total (s)   self (s)
                            if exists('g:loaded_dirvish') || &cp || version < 700 || &cpo =~# 'C'
                              finish
                            endif
    1              0.000002 let g:loaded_dirvish = 1
                            
    1              0.000004 command! -bar -nargs=? -complete=dir Dirvish call dirvish#open(<q-args>)
                            
    1              0.000002 function! s:isdir(dir)
                              return !empty(a:dir) && (isdirectory(a:dir) ||
                                \ (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))
                            endfunction
                            
    1              0.000002 if get(g:, 'dirvish_hijack_netrw', 1)
    1              0.000001   augroup dirvish_netrw
    1              0.000031     autocmd!
                                " nuke netrw brain damage
    1              0.000004     autocmd VimEnter * silent! au! FileExplorer *
    1              0.000004     autocmd BufEnter * if !exists('b:dirvish') && <SID>isdir(expand('%'))
                                  \ | redraw | echo ''
                                  \ | exe 'Dirvish %' | endif
    1              0.000001   augroup END
    1              0.000001 endif
                            
    1              0.000004 highlight! link DirvishPathTail Directory

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/echodoc.vim
Sourced 1 time
Total time:   0.000135
 Self time:   0.000135

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: echodoc.vim
                            " AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_echodoc')
                              finish
                            endif
                            
                            " Saving 'cpoptions' {{{
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            " }}}
                            
                            " Global options definition. "{{{
    1              0.000003 if exists('g:echodoc_enable_at_startup') && g:echodoc_enable_at_startup
                              " Enable startup.
    1              0.000001   augroup echodoc
    1              0.000030     autocmd!
    1              0.000058     autocmd InsertEnter * call echodoc#enable()
    1              0.000001   augroup END
    1              0.000001 endif"}}}
                            "}}}
                            
    1              0.000003 command! EchoDocEnable call echodoc#enable()
    1              0.000002 command! EchoDocDisable call echodoc#disable()
                            
    1              0.000002 let g:loaded_echodoc = 1
                            
                            " Restore 'cpoptions' {{{
    1              0.000004 let &cpo = s:save_cpo
    1              0.000002 unlet s:save_cpo
                            " }}}
                            " __END__
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/fastfold.vim
Sourced 1 time
Total time:   0.000398
 Self time:   0.000398

count  total (s)   self (s)
                            " LICENCE PUBLIQUE RIEN À BRANLER
                            " Version 1, Mars 2009
                            "
                            " Copyright (C) 2009 Sam Hocevar
                            " 14 rue de Plaisance, 75014 Paris, France
                            "
                            " La copie et la distribution de copies exactes de cette licence sont
                            " autorisées, et toute modification est permise à condition de changer
                            " le nom de la licence.
                            "
                            " CONDITIONS DE COPIE, DISTRIBUTON ET MODIFICATION
                            " DE LA LICENCE PUBLIQUE RIEN À BRANLER
                            "
                            " 0. Faites ce que vous voulez, j’en ai RIEN À BRANLER.
                            
    1              0.000004 if exists("g:loaded_fastfold") || &cp
                              finish
                            endif
    1              0.000001 let g:loaded_fastfold = 1
                            
    1              0.000002 let s:keepcpo         = &cpo
    1              0.000003 set cpo&vim
                            " ------------------------------------------------------------------------------
                            
    1              0.000004 if !exists('g:fastfold_savehook')    | let g:fastfold_savehook   = 1 | endif
    1              0.000002 if !exists('g:fastfold_fold_command_suffixes')
    1              0.000006   let g:fastfold_fold_command_suffixes = ['x','X','a','A','o','O','c','C']
    1              0.000001 endif
    1              0.000002 if !exists('g:fastfold_fold_movement_commands')
    1              0.000002   let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
    1              0.000001 endif
    1              0.000003 if !exists('g:fastfold_force')       | let g:fastfold_force     = 0  | endif
    1              0.000003 if !exists("g:fastfold_skipfiles")   | let g:fastfold_skipfiles = [] | endif
                            
    1              0.000002 function! s:EnterWin()
                              if s:Skip()
                                if exists('w:lastfdm') | unlet w:lastfdm | endif
                                return
                              endif
                            
                              let w:lastfdm = &l:foldmethod
                              setlocal foldmethod=manual
                            endfunction
                            
    1              0.000001 function! s:LeaveWin()
                              if exists('w:lastfdm') && &l:foldmethod ==# 'manual'
                                let &l:foldmethod= w:lastfdm
                              endif
                            endfunction
                            
                            " Like windo but restore the current buffer.
                            " See http://vim.wikia.com/wiki/Run_a_command_in_multiple_buffers#Restoring_position
    1              0.000001 function! s:WinDo( command )
                              " Work around Vim bug.
                              " See https://groups.google.com/forum/#!topic/vim_dev/LLTw8JV6wKg
                              let curaltwin = winnr('#') ? winnr('#') : 1
                              let currwin=winnr()
                              " avoid errors in CmdWin
                              if exists('*getcmdwintype') && getcmdwintype() != ''
                                return
                              endif
                              silent! execute 'keepjumps noautocmd windo ' . a:command
                              silent! execute curaltwin . 'wincmd w'
                              silent! execute currwin . 'wincmd w'
                            endfunction
                            
                            " WinEnter then TabEnter then BufEnter then BufWinEnter
    1              0.000001 function! s:UpdateWin(check)
                              " skip if another session still loading
                              if a:check && exists('g:SessionLoad') | return | endif
                            
                              let s:curwin = winnr()
                              call s:WinDo("if winnr() == s:curwin | call s:LeaveWin() | endif")
                              call s:WinDo("if winnr() == s:curwin | call s:EnterWin() | endif")
                            endfunction
                            
    1              0.000001 function! s:UpdateBuf(feedback)
                              let s:curbuf = bufnr('%')
                              call s:WinDo("if bufnr('%') == s:curbuf | call s:LeaveWin() | endif")
                              call s:WinDo("if bufnr('%') == s:curbuf | call s:EnterWin() | endif")
                            
                              if !a:feedback | return | endif
                            
                              if !exists('w:lastfdm')
                                echomsg "'" . &l:foldmethod . "' folds already continuously updated"
                              else
                                echomsg "updated '" . w:lastfdm . "' folds"
                              endif
                            endfunction
                            
    1              0.000001 function! s:UpdateTab()
                              " skip if another session still loading
                              if exists('g:SessionLoad') | return | endif
                            
                              call s:WinDo("call s:LeaveWin()")
                              call s:WinDo("call s:EnterWin()")
                            endfunction
                            
    1              0.000001 function! s:Skip()
                              if !s:isReasonable() | return 1 | endif
                              if !&l:modifiable    | return 1 | endif
                              if s:inSkipList()    | return 1 | endif
                            
                              return 0
                            endfunction
                            
    1              0.000001 function! s:isReasonable()
                              if &l:foldmethod ==# 'manual' | return 0 | endif
                            
                              if g:fastfold_force | return 1 | endif
                              if &l:foldmethod ==# 'syntax' || &l:foldmethod ==# 'expr'
                                return 1
                              endif
                            
                              return 0
                            endfunction
                            
    1              0.000001 function! s:inSkipList()
                              let file_name = expand('%:p')
                              for ifiles in g:fastfold_skipfiles
                                if file_name =~# ifiles
                                  return 1
                                endif
                              endfor
                              return 0
                            endfunction
                            
    1              0.000004 command! -bar -bang FastFoldUpdate call s:UpdateBuf(<bang>0)
                            
    1              0.000009 nnoremap <silent> <Plug>(FastFoldUpdate) :<c-u>FastFoldUpdate!<CR>
                            
    1              0.000013 if !hasmapto('<Plug>(FastFoldUpdate)', 'n') && mapcheck('zuz', 'n') ==# ''
    1              0.000005   nmap zuz <Plug>(FastFoldUpdate)
    1              0.000001 endif
                            
    9              0.000008 for suffix in g:fastfold_fold_command_suffixes
    8              0.000056   execute 'nnoremap <silent> z'.suffix.' :<c-u>call <SID>UpdateWin(0)<CR>z'.suffix
    8              0.000004 endfor
                            
    5              0.000007 for cmd in g:fastfold_fold_movement_commands
    4              0.000034   exe "nnoremap <silent><expr> " . cmd. " ':<c-u>call <SID>UpdateWin(0)<CR>'.v:count." . "'".cmd."'"
    4              0.000035   exe "xnoremap <silent><expr> " . cmd. " ':<c-u>call <SID>UpdateWin(0)<CR>gv'.v:count." . "'".cmd."'"
    4              0.000042   exe "onoremap <silent><expr> " . cmd. " '<esc>:<c-u>call <SID>UpdateWin(0)<CR>' . '\"' . v:register . v:operator . v:count1 . " . "'".cmd."'"
    4              0.000002 endfor
                            
    1              0.000001 augroup FastFold
    1              0.000031   autocmd!
    1              0.000004   autocmd VimEnter * call s:init()
    1              0.000001 augroup end
                            
    1              0.000002 function! s:init()
                              call s:UpdateTab()
                              augroup FastFold
                                autocmd!
                                " Make &l:foldmethod local to Buffer and NOT Window.
                                " UpdateWin(1) = Skip if another session still loading.
                                " BufWinEnter = to change &l:foldmethod by modelines.
                                autocmd BufWinEnter,BufEnter,WinEnter *
                                  \ if exists('b:lastfdm') | let w:lastfdm = b:lastfdm | call s:LeaveWin() | call s:EnterWin() | endif
                                autocmd BufLeave,WinLeave             *
                                  \ call s:LeaveWin() | call s:EnterWin() |
                                  \ if exists('w:lastfdm')     | let b:lastfdm = w:lastfdm |
                                  \ elseif exists('b:lastfdm') | unlet b:lastfdm | endif
                            
                                autocmd FileType                      * call s:UpdateWin(1)
                                " So that FastFold functions correctly after :loadview.
                                autocmd SessionLoadPost               * call s:UpdateWin(0)
                            
                                autocmd TabEnter                      * call s:UpdateTab()
                            
                                " Update folds on saving.
                                if g:fastfold_savehook
                                  autocmd BufWritePost                * call s:UpdateBuf(0)
                                endif
                              augroup end
                            endfunction
                            
                            " ------------------------------------------------------------------------------
    1              0.000004 let &cpo= s:keepcpo
    1              0.000003 unlet s:keepcpo

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/gitgutter.vim
Sourced 1 time
Total time:   0.000970
 Self time:   0.000459

count  total (s)   self (s)
                            scriptencoding utf-8
                            
    1              0.000055 if exists('g:loaded_gitgutter') || !executable('git') || !has('signs') || &cp
                              finish
                            endif
    1              0.000002 let g:loaded_gitgutter = 1
                            
                            " Initialisation {{{
                            
                            " Realtime sign updates require Vim 7.3.105+.
    1              0.000003 if v:version < 703 || (v:version == 703 && !has("patch105"))
                              let g:gitgutter_realtime = 0
                            endif
                            
                            " Eager updates require gettabvar()/settabvar().
    1              0.000002 if !exists("*gettabvar")
                              let g:gitgutter_eager = 0
                            endif
                            
    1              0.000002 function! s:set(var, default)
                              if !exists(a:var)
                                if type(a:default)
                                  execute 'let' a:var '=' string(a:default)
                                else
                                  execute 'let' a:var '=' a:default
                                endif
                              endif
                            endfunction
                            
    1   0.000015   0.000006 call s:set('g:gitgutter_enabled',                     1)
    1   0.000012   0.000005 call s:set('g:gitgutter_max_signs',                 500)
    1   0.000012   0.000002 call s:set('g:gitgutter_signs',                       1)
    1   0.000012   0.000002 call s:set('g:gitgutter_highlight_lines',             0)
    1   0.000009   0.000002 call s:set('g:gitgutter_sign_column_always',          0)
    1   0.000012   0.000002 call s:set('g:gitgutter_override_sign_column_highlight', 1)
    1   0.000008   0.000002 call s:set('g:gitgutter_realtime',                    1)
    1   0.000010   0.000002 call s:set('g:gitgutter_eager',                       1)
    1   0.000012   0.000002 call s:set('g:gitgutter_sign_added',                '+')
    1   0.000012   0.000002 call s:set('g:gitgutter_sign_modified',             '~')
    1   0.000011   0.000002 call s:set('g:gitgutter_sign_removed',              '_')
    1              0.000001 try
    1   0.000013   0.000003   call s:set('g:gitgutter_sign_removed_first_line', '‾')
    1              0.000001 catch /E239/
                              let g:gitgutter_sign_removed_first_line = '_^'
                            endtry
                            
    1   0.000012   0.000002 call s:set('g:gitgutter_sign_modified_removed',    '~_')
    1   0.000012   0.000002 call s:set('g:gitgutter_diff_args',                  '')
    1   0.000010   0.000004 call s:set('g:gitgutter_map_keys',                    1)
    1   0.000011   0.000002 call s:set('g:gitgutter_avoid_cmd_prompt_on_windows', 1)
                            
    1              0.000082 call gitgutter#highlight#define_sign_column_highlight()
    1   0.000205   0.000009 call gitgutter#highlight#define_highlights()
    1   0.000076   0.000007 call gitgutter#highlight#define_signs()
                            
                            " }}}
                            
                            " Primary functions {{{
                            
    1              0.000004 command -bar GitGutterAll call gitgutter#all()
    1              0.000003 command -bar GitGutter    call gitgutter#process_buffer(bufnr(''), 0)
                            
    1              0.000003 command -bar GitGutterDisable call gitgutter#disable()
    1              0.000003 command -bar GitGutterEnable  call gitgutter#enable()
    1              0.000003 command -bar GitGutterToggle  call gitgutter#toggle()
                            
                            " }}}
                            
                            " Line highlights {{{
                            
    1              0.000003 command -bar GitGutterLineHighlightsDisable call gitgutter#line_highlights_disable()
    1              0.000003 command -bar GitGutterLineHighlightsEnable  call gitgutter#line_highlights_enable()
    1              0.000003 command -bar GitGutterLineHighlightsToggle  call gitgutter#line_highlights_toggle()
                            
                            " }}}
                            
                            " Signs {{{
                            
    1              0.000003 command -bar GitGutterSignsEnable  call gitgutter#signs_enable()
    1              0.000003 command -bar GitGutterSignsDisable call gitgutter#signs_disable()
    1              0.000003 command -bar GitGutterSignsToggle  call gitgutter#signs_toggle()
                            
                            " }}}
                            
                            " Hunks {{{
                            
    1              0.000006 command -bar -count=1 GitGutterNextHunk call gitgutter#hunk#next_hunk(<count>)
    1              0.000004 command -bar -count=1 GitGutterPrevHunk call gitgutter#hunk#prev_hunk(<count>)
                            
    1              0.000003 command -bar GitGutterStageHunk   call gitgutter#stage_hunk()
    1              0.000003 command -bar GitGutterRevertHunk  call gitgutter#revert_hunk()
    1              0.000003 command -bar GitGutterPreviewHunk call gitgutter#preview_hunk()
                            
                            " Returns the git-diff hunks for the file or an empty list if there
                            " aren't any hunks.
                            "
                            " The return value is a list of lists.  There is one inner list per hunk.
                            "
                            "   [
                            "     [from_line, from_count, to_line, to_count],
                            "     [from_line, from_count, to_line, to_count],
                            "     ...
                            "   ]
                            "
                            " where:
                            "
                            " `from`  - refers to the staged file
                            " `to`    - refers to the working tree's file
                            " `line`  - refers to the line number where the change starts
                            " `count` - refers to the number of lines the change covers
    1              0.000001 function! GitGutterGetHunks()
                              return gitgutter#utility#is_active() ? gitgutter#hunk#hunks() : []
                            endfunction
                            
                            " Returns an array that contains a summary of the current hunk status.
                            " The format is [ added, modified, removed ], where each value represents
                            " the number of lines added/modified/removed respectively.
    1              0.000001 function! GitGutterGetHunkSummary()
                              return gitgutter#hunk#summary()
                            endfunction
                            
                            " }}}
                            
    1              0.000003 command -bar GitGutterDebug call gitgutter#debug#debug()
                            
                            " Maps {{{
                            
    1              0.000015 nnoremap <silent> <expr> <Plug>GitGutterNextHunk &diff ? ']c' : ":\<C-U>execute v:count1 . 'GitGutterNextHunk'\<CR>"
    1              0.000008 nnoremap <silent> <expr> <Plug>GitGutterPrevHunk &diff ? '[c' : ":\<C-U>execute v:count1 . 'GitGutterPrevHunk'\<CR>"
                            
    1              0.000001 if g:gitgutter_map_keys
                              if !hasmapto('<Plug>GitGutterPrevHunk') && maparg('[c', 'n') ==# ''
                                nmap [c <Plug>GitGutterPrevHunk
                              endif
                              if !hasmapto('<Plug>GitGutterNextHunk') && maparg(']c', 'n') ==# ''
                                nmap ]c <Plug>GitGutterNextHunk
                              endif
                            endif
                            
                            
    1              0.000006 nnoremap <silent> <Plug>GitGutterStageHunk   :GitGutterStageHunk<CR>
    1              0.000005 nnoremap <silent> <Plug>GitGutterRevertHunk  :GitGutterRevertHunk<CR>
    1              0.000005 nnoremap <silent> <Plug>GitGutterPreviewHunk :GitGutterPreviewHunk<CR>
                            
    1              0.000001 if g:gitgutter_map_keys
                              if !hasmapto('<Plug>GitGutterStageHunk') && maparg('<Leader>hs', 'n') ==# ''
                                nmap <Leader>hs <Plug>GitGutterStageHunk
                              endif
                              if !hasmapto('<Plug>GitGutterRevertHunk') && maparg('<Leader>hr', 'n') ==# ''
                                nmap <Leader>hr <Plug>GitGutterRevertHunk
                              endif
                              if !hasmapto('<Plug>GitGutterPreviewHunk') && maparg('<Leader>hp', 'n') ==# ''
                                nmap <Leader>hp <Plug>GitGutterPreviewHunk
                              endif
                            endif
                            
                            " }}}
                            
                            " Autocommands {{{
                            
    1              0.000001 augroup gitgutter
    1              0.000031   autocmd!
                            
    1              0.000001   if g:gitgutter_realtime
                                autocmd CursorHold,CursorHoldI * call gitgutter#process_buffer(bufnr(''), 1)
                              endif
                            
    1              0.000001   if g:gitgutter_eager
    1              0.000009     autocmd BufEnter,BufWritePost,FileChangedShellPost *
                                      \  if gettabvar(tabpagenr(), 'gitgutter_didtabenter') |
                                      \   call settabvar(tabpagenr(), 'gitgutter_didtabenter', 0) |
                                      \ else |
                                      \   call gitgutter#process_buffer(bufnr(''), 0) |
                                      \ endif
    1              0.000004     autocmd TabEnter *
                                      \  call settabvar(tabpagenr(), 'gitgutter_didtabenter', 1) |
                                      \ call gitgutter#all()
    1              0.000003     if !has('gui_win32')
    1              0.000003       autocmd FocusGained * call gitgutter#all()
    1              0.000001     endif
    1              0.000001   else
                                autocmd BufRead,BufWritePost,FileChangedShellPost * call gitgutter#process_buffer(bufnr(''), 0)
                              endif
                            
    1              0.000003   autocmd ColorScheme * call gitgutter#highlight#define_sign_column_highlight() | call gitgutter#highlight#define_highlights()
                            
                              " Disable during :vimgrep
    1              0.000004   autocmd QuickFixCmdPre  *vimgrep* let g:gitgutter_enabled = 0
    1              0.000005   autocmd QuickFixCmdPost *vimgrep* let g:gitgutter_enabled = 1
    1              0.000001 augroup END
                            
                            " }}}
                            
                            " vim:set et sw=2 fdm=marker:

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/gitgutter/highlight.vim
Sourced 1 time
Total time:   0.000093
 Self time:   0.000093

count  total (s)   self (s)
                            function! gitgutter#highlight#define_sign_column_highlight()
                              if g:gitgutter_override_sign_column_highlight
                                highlight! link SignColumn LineNr
                              else
                                highlight default link SignColumn LineNr
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#define_highlights()
                              let [guibg, ctermbg] = gitgutter#highlight#get_background_colors('SignColumn')
                            
                              " Highlights used by the signs.
                            
                              execute "highlight GitGutterAddDefault    guifg=#009900 guibg=" . guibg . " ctermfg=2 ctermbg=" . ctermbg
                              execute "highlight GitGutterChangeDefault guifg=#bbbb00 guibg=" . guibg . " ctermfg=3 ctermbg=" . ctermbg
                              execute "highlight GitGutterDeleteDefault guifg=#ff2222 guibg=" . guibg . " ctermfg=1 ctermbg=" . ctermbg
                              highlight default link GitGutterChangeDeleteDefault GitGutterChangeDefault
                            
                              execute "highlight GitGutterAddInvisible    guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
                              execute "highlight GitGutterChangeInvisible guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
                              execute "highlight GitGutterDeleteInvisible guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
                              highlight default link GitGutterChangeDeleteInvisible GitGutterChangeInvisble
                            
                              highlight default link GitGutterAdd          GitGutterAddDefault
                              highlight default link GitGutterChange       GitGutterChangeDefault
                              highlight default link GitGutterDelete       GitGutterDeleteDefault
                              highlight default link GitGutterChangeDelete GitGutterChangeDeleteDefault
                            
                              " Highlights used for the whole line.
                            
                              highlight default link GitGutterAddLine          DiffAdd
                              highlight default link GitGutterChangeLine       DiffChange
                              highlight default link GitGutterDeleteLine       DiffDelete
                              highlight default link GitGutterChangeDeleteLine GitGutterChangeLine
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#define_signs()
                              sign define GitGutterLineAdded
                              sign define GitGutterLineModified
                              sign define GitGutterLineRemoved
                              sign define GitGutterLineRemovedFirstLine
                              sign define GitGutterLineModifiedRemoved
                              sign define GitGutterDummy
                            
                              call gitgutter#highlight#define_sign_text()
                              call gitgutter#highlight#define_sign_text_highlights()
                              call gitgutter#highlight#define_sign_line_highlights()
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#define_sign_text()
                              execute "sign define GitGutterLineAdded            text=" . g:gitgutter_sign_added
                              execute "sign define GitGutterLineModified         text=" . g:gitgutter_sign_modified
                              execute "sign define GitGutterLineRemoved          text=" . g:gitgutter_sign_removed
                              execute "sign define GitGutterLineRemovedFirstLine text=" . g:gitgutter_sign_removed_first_line
                              execute "sign define GitGutterLineModifiedRemoved  text=" . g:gitgutter_sign_modified_removed
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#define_sign_text_highlights()
                              " Once a sign's text attribute has been defined, it cannot be undefined or
                              " set to an empty value.  So to make signs' text disappear (when toggling
                              " off or disabling) we make them invisible by setting their foreground colours
                              " to the background's.
                              if g:gitgutter_signs
                                sign define GitGutterLineAdded            texthl=GitGutterAdd
                                sign define GitGutterLineModified         texthl=GitGutterChange
                                sign define GitGutterLineRemoved          texthl=GitGutterDelete
                                sign define GitGutterLineRemovedFirstLine texthl=GitGutterDelete
                                sign define GitGutterLineModifiedRemoved  texthl=GitGutterChangeDelete
                              else
                                sign define GitGutterLineAdded            texthl=GitGutterAddInvisible
                                sign define GitGutterLineModified         texthl=GitGutterChangeInvisible
                                sign define GitGutterLineRemoved          texthl=GitGutterDeleteInvisible
                                sign define GitGutterLineRemovedFirstLine texthl=GitGutterDeleteInvisible
                                sign define GitGutterLineModifiedRemoved  texthl=GitGutterChangeDeleteInvisible
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#define_sign_line_highlights()
                              if g:gitgutter_highlight_lines
                                sign define GitGutterLineAdded            linehl=GitGutterAddLine
                                sign define GitGutterLineModified         linehl=GitGutterChangeLine
                                sign define GitGutterLineRemoved          linehl=GitGutterDeleteLine
                                sign define GitGutterLineRemovedFirstLine linehl=GitGutterDeleteLine
                                sign define GitGutterLineModifiedRemoved  linehl=GitGutterChangeDeleteLine
                              else
                                sign define GitGutterLineAdded            linehl=
                                sign define GitGutterLineModified         linehl=
                                sign define GitGutterLineRemoved          linehl=
                                sign define GitGutterLineRemovedFirstLine linehl=
                                sign define GitGutterLineModifiedRemoved  linehl=
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#get_background_colors(group)
                              redir => highlight
                              silent execute 'silent highlight ' . a:group
                              redir END
                            
                              let link_matches = matchlist(highlight, 'links to \(\S\+\)')
                              if len(link_matches) > 0 " follow the link
                                return gitgutter#highlight#get_background_colors(link_matches[1])
                              endif
                            
                              let ctermbg = gitgutter#highlight#match_highlight(highlight, 'ctermbg=\([0-9A-Za-z]\+\)')
                              let guibg   = gitgutter#highlight#match_highlight(highlight, 'guibg=\([#0-9A-Za-z]\+\)')
                              return [guibg, ctermbg]
                            endfunction
                            
    1              0.000002 function! gitgutter#highlight#match_highlight(highlight, pattern)
                              let matches = matchlist(a:highlight, a:pattern)
                              if len(matches) == 0
                                return 'NONE'
                              endif
                              return matches[1]
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/lldb.vim
Sourced 1 time
Total time:   0.000519
 Self time:   0.000155

count  total (s)   self (s)
                            " ---------------------------------------------------------------------
                            "  File:        lldb.vim
                            "  Maintainer:  John C F <john.ch.fr@gmail.com>
                            "  --------------------------------------------------------------------
                            
    1              0.000089 if exists('g:loaded_lldb') || !has('nvim') || !has('python')
                              finish
                            endif
    1              0.000002 let g:loaded_lldb = 1
                            
    1              0.000002 if !exists('g:lldb#session#file')
    1              0.000002   let g:lldb#session#file = 'lldb-nvim.json'
    1              0.000001 endif
    1              0.000002 if !exists('g:lldb#session#mode_setup')
    1              0.000002   let g:lldb#session#mode_setup = 'lldb#layout#setup'
    1              0.000001 endif
    1              0.000002 if !exists('g:lldb#session#mode_teardown')
    1              0.000002   let g:lldb#session#mode_teardown = 'lldb#layout#teardown'
    1              0.000001 endif
                            
    1              0.000003 let s:bp_symbol = get(g:, 'lldb#sign#bp_symbol', 'B>')
    1              0.000002 let s:pc_symbol = get(g:, 'lldb#sign#pc_symbol', '->')
                            
    1              0.000004 highlight default link LLBreakpointSign Type
    1              0.000004 highlight default link LLUnselectedPCSign NonText
    1              0.000002 highlight default link LLUnselectedPCLine DiffChange
    1              0.000002 highlight default link LLSelectedPCSign Debug
    1              0.000002 highlight default link LLSelectedPCLine DiffText
                            
    1              0.000007 execute 'sign define llsign_bpres text=' . s:bp_symbol .
                                \ ' texthl=LLBreakpointSign linehl=LLBreakpointLine'
    1              0.000005 execute 'sign define llsign_pcsel text=' . s:pc_symbol .
                                \ ' texthl=LLSelectedPCSign linehl=LLSelectedPCLine'
    1              0.000006 execute 'sign define llsign_pcunsel text=' . s:pc_symbol .

SCRIPT  /usr/local/share/nvim/runtime/autoload/provider/python.vim
Sourced 1 time
Total time:   0.000358
 Self time:   0.000158

count  total (s)   self (s)
                            " The Python provider uses a Python host to emulate an environment for running
                            " python-vim plugins. See ":help nvim-provider" for more information.
                            "
                            " Associating the plugin with the Python host is the first step because plugins
                            " will be passed as command-line arguments
                            
    1              0.000003 if exists('g:loaded_python_provider')
                              finish
                            endif
    1              0.000002 let g:loaded_python_provider = 1
                            
    1              0.000079 let [s:prog, s:err] = provider#pythonx#Detect(2)
                            
    1              0.000002 function! provider#python#Prog()
                              return s:prog
                            endfunction
                            
    1              0.000003 function! provider#python#Error()
                              return s:err
                            endfunction
                            
    1              0.000001 if s:prog == ''
                              " Detection failed
                              finish
                            endif
                            
    1              0.000007 let s:plugin_path = expand('<sfile>:p:h').'/script_host.py'
                            
                            " The Python provider plugin will run in a separate instance of the Python
                            " host.
    1   0.000021   0.000008 call remote#host#RegisterClone('legacy-python-provider', 'python')
    1   0.000069   0.000007 call remote#host#RegisterPlugin('legacy-python-provider', s:plugin_path, [])
                            
    1              0.000002 function! provider#python#Call(method, args)
                              if s:err != ''
                                return
                              endif
                              if !exists('s:host')
                                let s:rpcrequest = function('rpcrequest')
                            
                                " Ensure that we can load the Python host before bootstrapping
                                try
                                  let s:host = remote#host#Require('legacy-python-provider')
                                catch
                                  let s:err = v:exception
                                  echohl WarningMsg
                                  echomsg v:exception
                                  echohl None
                                  return
                                endtry
                              endif
                              return call(s:rpcrequest, insert(insert(a:args, 'python_'.a:method), s:host))
                            endfunction

SCRIPT  /usr/local/share/nvim/runtime/autoload/provider/pythonx.vim
Sourced 1 time
Total time:   0.000064
 Self time:   0.000064

count  total (s)   self (s)
                            " The Python provider helper
    1              0.000005 if exists('s:loaded_pythonx_provider')
                              finish
                            endif
                            
    1              0.000002 let s:loaded_pythonx_provider = 1
                            
    1              0.000003 function! provider#pythonx#Detect(major_ver) abort
                              let host_var = (a:major_ver == 2) ?
                                    \ 'g:python_host_prog' : 'g:python3_host_prog'
                              let skip_var = (a:major_ver == 2) ?
                                    \ 'g:python_host_skip_check' : 'g:python3_host_skip_check'
                              let skip = exists(skip_var) ? {skip_var} : 0
                              if exists(host_var)
                                " Disable auto detection.
                                let [result, err] = s:check_interpreter({host_var}, a:major_ver, skip)
                                if result
                                  return [{host_var}, err]
                                endif
                                return ['', 'provider/pythonx: Could not load Python ' . a:major_ver
                                      \ . ' from ' . host_var . ': ' . err]
                              endif
                            
                              let prog_suffixes = (a:major_ver == 2) ?
                                    \   ['2', '2.7', '2.6', '']
                                    \ : ['3', '3.5', '3.4', '3.3', '']
                            
                              let errors = []
                              for prog in map(prog_suffixes, "'python' . v:val")
                                let [result, err] = s:check_interpreter(prog, a:major_ver, skip)
                                if result
                                  return [prog, err]
                                endif
                            
                                " Accumulate errors in case we don't find
                                " any suitable Python interpreter.
                                call add(errors, err)
                              endfor
                            
                              " No suitable Python interpreter found.
                              return ['', 'provider/pythonx: Could not load Python ' . a:major_ver
                                    \ . ":\n" .  join(errors, "\n")]
                            endfunction
                            
    1              0.000003 function! s:check_interpreter(prog, major_ver, skip) abort
                              let prog_path = exepath(a:prog)
                              if prog_path == ''
                                return [0, a:prog . ' not found in search path or not executable.']
                              endif
                            
                              if a:skip
                                return [1, '']
                              endif
                            
                              let min_version = (a:major_ver == 2) ? '2.6' : '3.3'
                            
                              " Try to load neovim module, and output Python version.
                              " Return codes:
                              "   0  Neovim module can be loaded.
                              "   1  Something else went wrong.
                              "   2  Neovim module cannot be loaded.
                              let prog_ver = system([ a:prog , '-c' ,
                                    \ 'import sys; ' .
                                    \ 'sys.path.remove(""); ' .
                                    \ 'sys.stdout.write(str(sys.version_info[0]) + "." + str(sys.version_info[1])); ' .
                                    \ 'import pkgutil; ' .
                                    \ 'exit(2*int(pkgutil.get_loader("neovim") is None))'
                                    \ ])
                            
                              if prog_ver
                                if prog_ver !~ '^' . a:major_ver
                                  return [0, prog_path . ' is Python ' . prog_ver . ' and cannot provide Python '
                                        \ . a:major_ver . '.']
                                elseif prog_ver =~ '^' . a:major_ver && prog_ver < min_version
                                  return [0, prog_path . ' is Python ' . prog_ver . ' and cannot provide Python >= '
                                        \ . min_version . '.']
                                endif
                              endif
                            
                              if v:shell_error == 1
                                return [0, 'Checking ' . prog_path . ' caused an unknown error. '
                                      \ . 'Please report this at github.com/neovim/neovim.']
                              elseif v:shell_error == 2
                                return [0, prog_path . ' does have not have the neovim module installed. '
                                      \ . 'See ":help nvim-python".']
                              endif
                            
                              return [1, '']
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/miniyank.vim
Sourced 1 time
Total time:   0.000075
 Self time:   0.000075

count  total (s)   self (s)
                            if !has_key(g:,"miniyank_filename")
                                if exists('$XDG_RUNTIME_DIR')
                                    let g:miniyank_filename = $XDG_RUNTIME_DIR."/miniyank.mpack"
                                else
                                    let g:miniyank_filename = "/tmp/".$USER."_miniyank.mpack"
                                endif
                            endif
    1              0.000002 if !has_key(g:,"miniyank_maxitems")
    1              0.000002     let g:miniyank_maxitems = 10
    1              0.000001 endif
                            
    1              0.000001 augroup MiniYank
    1              0.000005     au! TextYankPost * call miniyank#on_yank(v:event)
    1              0.000001 augroup END
                            
    1              0.000008 noremap <silent> <expr> <Plug>(miniyank-startput) miniyank#startput("p",0)
    1              0.000006 noremap <silent> <expr> <Plug>(miniyank-startPut) miniyank#startput("P",0)
    1              0.000006 noremap <silent> <expr> <Plug>(miniyank-autoput) miniyank#startput("p",1)
    1              0.000005 noremap <silent> <expr> <Plug>(miniyank-autoPut) miniyank#startput("P",1)
    1              0.000006 noremap <silent> <Plug>(miniyank-cycle) :<c-u>call miniyank#cycle()<cr>
                            
    1              0.000006 noremap <silent> <Plug>(miniyank-tochar) :<c-u>call miniyank#force_motion('v')<cr>
    1              0.000006 noremap <silent> <Plug>(miniyank-toline) :<c-u>call miniyank#force_motion('V')<cr>
    1              0.000007 noremap <silent> <Plug>(miniyank-toblock) :<c-u>call miniyank#force_motion('b')<cr>

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/neoinclude.vim
Sourced 1 time
Total time:   0.000031
 Self time:   0.000031

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: neoinclude.vim
                            " AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_neoinclude')
                              finish
                            endif
                            
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
                            " Add commands. "{{{
    1              0.000006 command! -complete=buffer -nargs=? NeoIncludeMakeCache
                                  \ call neoinclude#include#make_cache(<q-args>)
                            "}}}
                            
    1              0.000003 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            
    1              0.000001 let g:loaded_neoinclude = 1
                            
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/neomake.vim
Sourced 1 time
Total time:   0.000073
 Self time:   0.000073

count  total (s)   self (s)
                            " vim: ts=4 sw=4 et
                            
    1              0.000006 command! -nargs=* -bang -bar -complete=customlist,neomake#CompleteMakers Neomake call neomake#Make(<bang>1, [<f-args>])
                            " These commands are available for clarity
    1              0.000003 command! -nargs=* -bar -complete=customlist,neomake#CompleteMakers NeomakeProject Neomake! <args>
    1              0.000004 command! -nargs=* -bar -complete=customlist,neomake#CompleteMakers NeomakeFile Neomake <args>
                            
    1              0.000003 command! -nargs=+ -complete=shellcmd NeomakeSh call neomake#Sh(<q-args>)
                            
    1              0.000003 command! NeomakeListJobs call neomake#ListJobs()
                            
    1              0.000003 command! -nargs=1 NeomakeCancelJob call neomake#CancelJob(<args>)
                            
    1              0.000001 augroup neomake
    1              0.000031     autocmd!
    1              0.000008     autocmd BufWinEnter,CursorHold * call neomake#ProcessCurrentBuffer()
    1              0.000003     autocmd CursorMoved * call neomake#CursorMoved()
    1              0.000002 augroup END

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/neopairs.vim
Sourced 1 time
Total time:   0.000055
 Self time:   0.000055

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: neopairs.vim
                            " AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_neopairs')
                              finish
                            endif
    1              0.000002 let g:loaded_neopairs = 1
                            
    1              0.000001 augroup neopairs
    1              0.000030   autocmd!
    1              0.000003   autocmd CompleteDone * call neopairs#_complete_done()
    1              0.000002 augroup END
                            
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/neosnippet.vim
Sourced 1 time
Total time:   0.000153
 Self time:   0.000153

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: neosnippet.vim
                            " AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_neosnippet')
                              finish
                            elseif v:version < 702
                              echoerr 'neosnippet does not work this version of Vim "' . v:version . '".'
                              finish
                            endif
                            
    1              0.000003 let s:save_cpo = &cpo
    1              0.000004 set cpo&vim
                            
                            " Plugin key-mappings. "{{{
    1              0.000010 inoremap <silent><expr> <Plug>(neosnippet_expand_or_jump)
                                  \ neosnippet#mappings#expand_or_jump_impl()
    1              0.000007 inoremap <silent><expr> <Plug>(neosnippet_jump_or_expand)
                                  \ neosnippet#mappings#jump_or_expand_impl()
    1              0.000006 inoremap <silent><expr> <Plug>(neosnippet_expand)
                                  \ neosnippet#mappings#expand_impl()
    1              0.000006 inoremap <silent><expr> <Plug>(neosnippet_jump)
                                  \ neosnippet#mappings#jump_impl()
    1              0.000007 snoremap <silent><expr> <Plug>(neosnippet_expand_or_jump)
                                  \ neosnippet#mappings#expand_or_jump_impl()
    1              0.000007 snoremap <silent><expr> <Plug>(neosnippet_jump_or_expand)
                                  \ neosnippet#mappings#jump_or_expand_impl()
    1              0.000008 snoremap <silent><expr> <Plug>(neosnippet_expand)
                                  \ neosnippet#mappings#expand_impl()
    1              0.000006 snoremap <silent><expr> <Plug>(neosnippet_jump)
                                  \ neosnippet#mappings#jump_impl()
                            
    1              0.000008 xnoremap <silent> <Plug>(neosnippet_get_selected_text)
                                  \ :call neosnippet#helpers#get_selected_text(visualmode(), 1)<CR>
                            
    1              0.000007 xnoremap <silent> <Plug>(neosnippet_expand_target)
                                  \ :<C-u>call neosnippet#mappings#_expand_target()<CR>
    1              0.000008 xnoremap <silent> <Plug>(neosnippet_register_oneshot_snippet)
                                  \ :<C-u>call neosnippet#mappings#_register_oneshot_snippet()<CR>
                            
    1              0.000007 inoremap <expr><silent> <Plug>(neosnippet_start_unite_snippet)
                                  \ unite#sources#neosnippet#start_complete()
                            "}}}
                            
    1              0.000002 augroup neosnippet "{{{
    1              0.000004   autocmd InsertEnter * call neosnippet#init#_initialize()
    1              0.000001 augroup END"}}}
                            
                            " Commands. "{{{
    1              0.000006 command! -nargs=? -bar
                                  \ -complete=customlist,neosnippet#commands#_edit_complete
                                  \ NeoSnippetEdit
                                  \ call neosnippet#commands#_edit(<q-args>)
                            
    1              0.000005 command! -nargs=? -bar
                                  \ -complete=customlist,neosnippet#commands#_filetype_complete
                                  \ NeoSnippetMakeCache
                                  \ call neosnippet#commands#_make_cache(<q-args>)
                            
    1              0.000004 command! -nargs=1 -bar -complete=file
                                  \ NeoSnippetSource
                                  \ call neosnippet#commands#_source(<q-args>)
                            
    1              0.000004 command! -bar NeoSnippetClearMarkers
                                  \ call neosnippet#commands#_clear_markers()
                            "}}}
                            
    1              0.000002 let g:loaded_neosnippet = 1
                            
    1              0.000004 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            
                            " __END__
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/operator/surround.vim
Sourced 1 time
Total time:   0.000435
 Self time:   0.000117

count  total (s)   self (s)
                            if exists('g:loaded_operator_surround')
                                finish
                            endif
                            
    1              0.000075 call operator#user#define('surround-append', 'operator#surround#append', "call operator#surround#certify_as_keymapping()")
    1   0.000058   0.000005 call operator#user#define('surround-delete', 'operator#surround#delete')
    1   0.000068   0.000006 call operator#user#define('surround-replace', 'operator#surround#replace', "call operator#surround#certify_as_keymapping()")
                            
    1              0.000005 nnoremap <Plug>(operator-surround-repeat) .
                            
    1              0.000003 let g:loaded_operator_surround = 1

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/operator/user.vim
Sourced 1 time
Total time:   0.000121
 Self time:   0.000121

count  total (s)   self (s)
                            " operator-user - Define your own operator easily
                            " Version: 0.1.0
                            " Copyright (C) 2009-2015 Kana Natsuno <http://whileimautomaton.net/>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            " Interface  "{{{1
    1              0.000003 function! operator#user#define(name, function_name, ...)  "{{{2
                              return call('operator#user#_define',
                              \           ['<Plug>(operator-' . a:name . ')', a:function_name] + a:000)
                            endfunction
                            
                            
                            
                            
    1              0.000002 function! operator#user#define_ex_command(name, ex_command)  "{{{2
                              return operator#user#define(
                              \        a:name,
                              \        'operator#user#_do_ex_command',
                              \        'call operator#user#_set_ex_command(' . string(a:ex_command) . ')'
                              \      )
                            endfunction
                            
                            
                            
                            
    1              0.000002 function! operator#user#register()  "{{{2
                              return s:register
                            endfunction
                            
                            
                            
                            
    1              0.000002 function! operator#user#visual_command_from_wise_name(wise_name)  "{{{2
                              if a:wise_name ==# 'char'
                                return 'v'
                              elseif a:wise_name ==# 'line'
                                return 'V'
                              elseif a:wise_name ==# 'block'
                                return "\<C-v>"
                              else
                                echoerr 'operator-user:E1: Invalid wise name:' string(a:wise_name)
                                return 'v'  " fallback
                              endif
                            endfunction
                            
                            
                            
                            
                            
                            
                            
                            
                            " Misc.  "{{{1
                            " Support functions for operator#user#define()  "{{{2
    1              0.000002 function! operator#user#_define(operator_keyseq, function_name, ...)
                              if 0 < a:0
                                let additional_settings = '\|' . join(a:000)
                              else
                                let additional_settings = ''
                              endif
                            
                              execute printf(('nnoremap <script> <silent> %s ' .
                              \               ':<C-u>call operator#user#_set_up(%s)%s<Return>' .
                              \               '<SID>(count)' .
                              \               '<SID>(register)' .
                              \               'g@'),
                              \              a:operator_keyseq,
                              \              string(a:function_name),
                              \              additional_settings)
                              execute printf(('vnoremap <script> <silent> %s ' .
                              \               ':<C-u>call operator#user#_set_up(%s)%s<Return>' .
                              \               'gv' .
                              \               '<SID>(register)' .
                              \               'g@'),
                              \              a:operator_keyseq,
                              \              string(a:function_name),
                              \              additional_settings)
                              execute printf('onoremap %s  g@', a:operator_keyseq)
                            endfunction
                            
                            
    1              0.000002 function! operator#user#_set_up(operator_function_name)
                              let &operatorfunc = a:operator_function_name
                              let s:count = v:count
                              let s:register = v:register
                            endfunction
                            
                            
                            
                            
                            " Support functions for operator#user#define_ex_command()  "{{{2
    1              0.000002 function! operator#user#_do_ex_command(motion_wiseness)
                              execute "'[,']" s:ex_command
                            endfunction
                            
                            
    1              0.000002 function! operator#user#_set_ex_command(ex_command)
                              let s:ex_command = a:ex_command
                            endfunction
                            
                            
                            
                            
                            " Variables  "{{{2
                            
                            " See operator#user#_do_ex_command() and operator#user#_set_ex_command().
                            " let s:ex_command = ''
                            
                            " See operator#user#_set_up() and s:count()
                            " let s:count = ''
                            
                            " See operator#user#_set_up() and s:register()
                            " let s:register = ''
                            
                            
                            
                            
                            " count  "{{{2
    1              0.000002 function! s:count()
                              return s:count ? s:count : ''
                            endfunction
                            
    1              0.000007 nnoremap <expr> <SID>(count)  <SID>count()
                            
                            " FIXME: It's hard for user-defined operator to handle count in Visual mode.
                            " nnoremap <expr> <SID>(count)  <SID>count()
                            
                            
                            
                            
                            " register designation  "{{{2
    1              0.000001 function! s:register()
                              return s:register == '' ? '' : '"' . s:register
                            endfunction
                            
    1              0.000005 nnoremap <expr> <SID>(register)  <SID>register()
    1              0.000005 vnoremap <expr> <SID>(register)  <SID>register()
                            
                            
                            
                            
                            " <SID>  "{{{2
    1              0.000002 function! operator#user#_sid_prefix()
                              return s:SID_PREFIX()
                            endfunction
                            
                            
    1              0.000001 function! s:SID_PREFIX()
                              return matchstr(expand('<sfile>'), '\%(^\|\.\.\)\zs<SNR>\d\+_\zeSID_PREFIX$')
                            endfunction
                            
                            
                            
                            
                            
                            
                            
                            
                            " __END__  "{{{1
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/quickrun.vim
Sourced 1 time
Total time:   0.000082
 Self time:   0.000082

count  total (s)   self (s)
                            " Run commands quickly.
                            " Version: 0.6.0
                            " Author : thinca <thinca+vim@gmail.com>
                            " License: zlib License
                            
    1              0.000003 if exists('g:loaded_quickrun')
                              finish
                            endif
    1              0.000001 let g:loaded_quickrun = 1
                            
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
                            
    1              0.000010 command! -nargs=* -range=0 -complete=customlist,quickrun#complete QuickRun
                            \ call quickrun#command(<q-args>, <count>, <line1>, <line2>)
                            
                            
    1              0.000008 nnoremap <silent> <Plug>(quickrun-op)
                            \        :<C-u>set operatorfunc=quickrun#operator<CR>g@
                            
    1              0.000005 nnoremap <silent> <Plug>(quickrun) :<C-u>QuickRun -mode n<CR>
    1              0.000005 vnoremap <silent> <Plug>(quickrun) :<C-u>QuickRun -mode v<CR>
                            
                            " Default key mappings.
    1              0.000014 if !hasmapto('<Plug>(quickrun)')
                            \  && (!exists('g:quickrun_no_default_key_mappings')
                            \      || !g:quickrun_no_default_key_mappings)
    1              0.000013   silent! map <unique> <Leader>r <Plug>(quickrun)
    1              0.000001 endif
                            
    1              0.000004 let &cpo = s:save_cpo
    1              0.000003 unlet s:save_cpo

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/ref.vim
Sourced 1 time
Total time:   0.000046
 Self time:   0.000046

count  total (s)   self (s)
                            " Integrated reference viewer.
                            " Version: 0.4.3
                            " Author : thinca <thinca+vim@gmail.com>
                            " License: Creative Commons Attribution 2.1 Japan License
                            "          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>
                            
    1              0.000003 if exists('g:loaded_ref')
                              finish
                            endif
    1              0.000002 let g:loaded_ref = 1
                            
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
                            
    1              0.000004 command! -nargs=+ -complete=customlist,ref#complete Ref call ref#ref(<q-args>)
                            
    1              0.000007 nnoremap <silent> <Plug>(ref-keyword) :<C-u>call ref#K('normal')<CR>
    1              0.000006 vnoremap <silent> <Plug>(ref-keyword) :<C-u>call ref#K('visual')<CR>
                            
    1              0.000003 if !exists('g:ref_no_default_key_mappings') || !g:ref_no_default_key_mappings
                              silent! nmap <silent> <unique> K <Plug>(ref-keyword)
                              silent! vmap <silent> <unique> K <Plug>(ref-keyword)
                            endif
                            
                            
                            
    1              0.000003 let &cpo = s:save_cpo
    1              0.000002 unlet s:save_cpo

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/sonictemplate.vim
Sourced 1 time
Total time:   0.000111
 Self time:   0.000111

count  total (s)   self (s)
                            "=============================================================================
                            " File: sonictemplate.vim
                            " Author: Yasuhiro Matsumoto <mattn.jp@gmail.com>
                            " Last Change: 01-May-2013.
                            " Version: 0.10
                            " WebPage: http://github.com/mattn/sonictemplate-vim
                            " Description: Easy and high speed coding method
                            " Usage:
                            "
                            "   :Template {name}
                            "       Load template named as {name} in the current buffer.
                            "
                            "   Or type <c-y> + t
                            
    1              0.000005 if &cp || (exists('g:loaded_sonictemplate_vim') && g:loaded_sonictemplate_vim)
                              finish
                            endif
    1              0.000002 let g:loaded_sonictemplate_vim = 1
                            
    1              0.000002 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
    1              0.000011 exe "command!" "-nargs=1" "-complete=customlist,sonictemplate#complete" get(g:, 'sonictemplate_commandname', 'Template') "call sonictemplate#apply(<f-args>, 'n')"
                            
    1              0.000002 if get(g:, 'sonictemplate_key', '') == ''
    1              0.000007   nnoremap <plug>(sonictemplate) :call sonictemplate#select('n')<cr>
    1              0.000006   inoremap <plug>(sonictemplate) <c-r>=sonictemplate#select('i')<cr>
    1              0.000005   nmap <unique> <c-y>t <plug>(sonictemplate)
    1              0.000005   imap <unique> <c-y>t <plug>(sonictemplate)
    1              0.000005   nmap <unique> <c-y><c-t> <plug>(sonictemplate)
    1              0.000004   imap <unique> <c-y><c-t> <plug>(sonictemplate)
    1              0.000001 else
                              exe "nnoremap" g:sonictemplate_key ":call sonictemplate#select('n')<cr>"
                              exe "inoremap" g:sonictemplate_key "<c-r>=sonictemplate#select('i')<cr>"
                            endif
    1              0.000003 if get(g:, 'sonictemplate_intelligent_key', '') == ''
    1              0.000007   nnoremap <plug>(sonictemplate-intelligent) :call sonictemplate#select_intelligent('n')<cr>
    1              0.000007   inoremap <plug>(sonictemplate-intelligent) <c-r>=sonictemplate#select_intelligent('i')<cr>
    1              0.000005   nmap <unique> <c-y>T <plug>(sonictemplate-intelligent)
    1              0.000005   imap <unique> <c-y>T <plug>(sonictemplate-intelligent)
    1              0.000001 else
                              exe "nnoremap" g:sonictemplate_intelligent_key ":call sonictemplate#select_intelligent('n')<cr>"
                              exe "inoremap" g:sonictemplate_intelligent_key "<c-r>=sonictemplate#select_intelligent('i')<cr>"
                            endif
                            
    1              0.000003 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            
                            " vim:set et:

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/tcomment.vim
Sourced 1 time
Total time:   0.001580
 Self time:   0.000875

count  total (s)   self (s)
                            " tComment.vim -- An easily extensible & universal comment plugin 
                            " @Author:      Tom Link (micathom AT gmail com)
                            " @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
                            " @Created:     27-Dez-2004.
                            " @Last Change: 2015-10-02.
                            " @Revision:    965
                            " GetLatestVimScripts: 1173 1 tcomment.vim
                            
    1              0.000004 if &cp || exists('loaded_tcomment')
                                finish
                            endif
    1              0.000002 let loaded_tcomment = 308
                            
    1              0.000002 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
                            
    1              0.000002 if !exists('g:tcommentMaps')
                                " If true, set maps.
                                let g:tcommentMaps = 1   "{{{2
                            endif
                            
    1              0.000002 if !exists("g:tcommentMapLeader1")
                                " g:tcommentMapLeader1 should be a shortcut that can be used with 
                                " map, imap, vmap.
                                let g:tcommentMapLeader1 = '<c-_>' "{{{2
                            endif
                            
    1              0.000002 if !exists("g:tcommentMapLeader2")
                                " g:tcommentMapLeader2 should be a shortcut that can be used with 
                                " map, xmap.
    1              0.000002     let g:tcommentMapLeader2 = '<Leader>_' "{{{2
    1              0.000001 endif
                            
    1              0.000002 if !exists("g:tcommentMapLeaderOp1")
                                " See |tcomment-operator|.
    1              0.000001     let g:tcommentMapLeaderOp1 = 'gc' "{{{2
    1              0.000001 endif
                            
    1              0.000002 if !exists("g:tcommentMapLeaderUncommentAnyway")
                                " See |tcomment-operator|.
    1              0.000002     let g:tcommentMapLeaderUncommentAnyway = 'g<' "{{{2
    1              0.000001 endif
                            
    1              0.000002 if !exists("g:tcommentMapLeaderCommentAnyway")
                                " See |tcomment-operator|.
    1              0.000001     let g:tcommentMapLeaderCommentAnyway = 'g>' "{{{2
    1              0.000001 endif
                            
    1              0.000002 if !exists('g:tcommentTextObjectInlineComment')
    1              0.000001     let g:tcommentTextObjectInlineComment = 'ic'   "{{{2
    1              0.000001 endif
                            
                            
                            " :display: :[range]TComment[!] ?ARGS...
                            " If there is a visual selection that begins and ends in the same line, 
                            " then |:TCommentInline| is used instead.
                            " The optional range defaults to the current line. With a bang '!', 
                            " always comment the line.
                            "
                            " ARGS... are either (see also |tcomment#Comment()|):
                            "   1. a list of key=value pairs
                            "   2. 1-2 values for: ?commentBegin, ?commentEnd
    1              0.000012 command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TComment
                                        \ keepjumps call tcomment#Comment(<line1>, <line2>, 'G', "<bang>", <f-args>)
                            
                            " :display: :[range]TCommentAs[!] commenttype ?ARGS...
                            " TCommentAs requires g:tcomment_{filetype} to be defined.
                            " With a bang '!', always comment the line.
                            "
                            " ARGS... are either (see also |tcomment#Comment()|):
                            "   1. a list of key=value pairs
                            "   2. 1-2 values for: ?commentBegin, ?commentEnd
    1              0.000007 command! -bar -bang -complete=customlist,tcomment#Complete -range -nargs=+ TCommentAs 
                                        \ call tcomment#CommentAs(<line1>, <line2>, "<bang>", <f-args>)
                            
                            " :display: :[range]TCommentRight[!] ?ARGS...
                            " Comment the text to the right of the cursor. If a visual selection was 
                            " made (be it block-wise or not), all lines are commented out at from 
                            " the current cursor position downwards.
                            " With a bang '!', always comment the line.
                            "
                            " ARGS... are either (see also |tcomment#Comment()|):
                            "   1. a list of key=value pairs
                            "   2. 1-2 values for: ?commentBegin, ?commentEnd
    1              0.000008 command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentRight
                                        \ keepjumps call tcomment#Comment(<line1>, <line2>, 'R', "<bang>", <f-args>)
                            
                            " :display: :[range]TCommentBlock[!] ?ARGS...
                            " Comment as "block", e.g. use the {&ft}_block comment style. The 
                            " commented text isn't indented or reformated.
                            " With a bang '!', always comment the line.
                            "
                            " ARGS... are either (see also |tcomment#Comment()|):
                            "   1. a list of key=value pairs
                            "   2. 1-2 values for: ?commentBegin, ?commentEnd
    1              0.000008 command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentBlock
                                        \ keepjumps call tcomment#Comment(<line1>, <line2>, 'B', "<bang>", <f-args>)
                            
                            " :display: :[range]TCommentInline[!] ?ARGS...
                            " Use the {&ft}_inline comment style.
                            " With a bang '!', always comment the line.
                            "
                            " ARGS... are either (see also |tcomment#Comment()|):
                            "   1. a list of key=value pairs
                            "   2. 1-2 values for: ?commentBegin, ?commentEnd
    1              0.000007 command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentInline
                                        \ keepjumps call tcomment#Comment(<line1>, <line2>, 'I', "<bang>", <f-args>)
                            
                            " :display: :[range]TCommentMaybeInline[!] ?ARGS...
                            " With a bang '!', always comment the line.
                            "
                            " ARGS... are either (see also |tcomment#Comment()|):
                            "   1. a list of key=value pairs
                            "   2. 1-2 values for: ?commentBegin, ?commentEnd
    1              0.000007 command! -bar -bang -range -nargs=* -complete=customlist,tcomment#CompleteArgs TCommentMaybeInline
                                        \ keepjumps call tcomment#Comment(<line1>, <line2>, 'i', "<bang>", <f-args>)
                            
                            
                            " command! -range TCommentMap call tcomment#ResetOption() | <args>
                            
    1              0.000007 noremap <Plug>TComment_<c-_><c-_> :TComment<cr>
    1              0.000006 vnoremap <Plug>TComment_<c-_><c-_> :TCommentMaybeInline<cr>
    1              0.000005 inoremap <Plug>TComment_<c-_><c-_> <c-o>:TComment<cr>
    1              0.000006 noremap <Plug>TComment_<c-_>p m`vip:TComment<cr>``
    1              0.000006 inoremap <Plug>TComment_<c-_>p <c-o>:norm! m`vip<cr>:TComment<cr><c-o>``
    1              0.000005 noremap <Plug>TComment_<c-_><space> :TComment 
    1              0.000005 inoremap <Plug>TComment_<c-_><space> <c-o>:TComment 
    1              0.000005 inoremap <Plug>TComment_<c-_>r <c-o>:TCommentRight<cr>
    1              0.000007 noremap <Plug>TComment_<c-_>r :TCommentRight<cr>
    1              0.000005 vnoremap <Plug>TComment_<c-_>i :TCommentInline<cr>
    1              0.000006 noremap <Plug>TComment_<c-_>i v:TCommentInline mode=I#<cr>
    1              0.000005 inoremap <Plug>TComment_<c-_>i <c-\><c-o>v:TCommentInline mode=#<cr>
    1              0.000005 noremap <Plug>TComment_<c-_>b :TCommentBlock<cr>
    1              0.000005 inoremap <Plug>TComment_<c-_>b <c-\><c-o>:TCommentBlock mode=#<cr>
    1              0.000005 noremap <Plug>TComment_<c-_>a :TCommentAs 
    1              0.000005 inoremap <Plug>TComment_<c-_>a <c-o>:TCommentAs 
    1              0.000006 noremap <Plug>TComment_<c-_>n :TCommentAs <c-r>=&ft<cr> 
    1              0.000005 inoremap <Plug>TComment_<c-_>n <c-o>:TCommentAs <c-r>=&ft<cr> 
    1              0.000005 noremap <Plug>TComment_<c-_>s :TCommentAs <c-r>=&ft<cr>_
    1              0.000005 inoremap <Plug>TComment_<c-_>s <c-o>:TCommentAs <c-r>=&ft<cr>_
    1              0.000007 noremap <Plug>TComment_<c-_>cc :<c-u>call tcomment#SetOption("count", v:count1)<cr>
    1              0.000011 noremap <Plug>TComment_<c-_>ca :<c-u>call tcomment#SetOption("as", input("Comment as: ", &filetype, "customlist,tcomment#Complete"))<cr>
                            
    1              0.000006 noremap <Plug>TComment_<Leader>__ :TComment<cr>
    1              0.000006 xnoremap <Plug>TComment_<Leader>__ :TCommentMaybeInline<cr>
    1              0.000006 noremap <Plug>TComment_<Leader>_p vip:TComment<cr>
    1              0.000006 noremap <Plug>TComment_<Leader>_<space> :TComment 
    1              0.000006 xnoremap <Plug>TComment_<Leader>_i :TCommentInline<cr>
    1              0.000006 noremap <Plug>TComment_<Leader>_r :TCommentRight<cr>
    1              0.000006 noremap <Plug>TComment_<Leader>_b :TCommentBlock<cr>
    1              0.000006 noremap <Plug>TComment_<Leader>_a :TCommentAs 
    1              0.000006 noremap <Plug>TComment_<Leader>_n :TCommentAs <c-r>=&ft<cr> 
    1              0.000006 noremap <Plug>TComment_<Leader>_s :TCommentAs <c-r>=&ft<cr>_
                            
                            
                            " function! TCommentOp(type) "{{{3
                            "     " TLogVAR a:type, v:count
                            "     " echom "DBG TCommentOp" g:tcomment_ex
                            "     " echom "DBG TCommentOp" g:tcomment_op
                            "     exec g:tcomment_ex
                            "     call call(g:tcomment_op, [a:type])
                            " endf
                            
    1              0.000003 function! s:MapOp(name, extra, op, invoke) "{{{3
                                let opfunc = 'TCommentOpFunc_'. substitute(a:name, '[^a-zA-Z0-9_]', '_', 'G')
                                let fn = [
                                            \ 'function! '. opfunc .'(...)',
                                            \ 'call tcomment#MaybeReuseOptions('. string(opfunc) .')',
                                            \ a:extra,
                                            \ 'return call('. string(a:op) .', a:000)',
                                            \ 'endf'
                                            \ ]
                                exec join(fn, "\n")
                                exec printf('nnoremap <silent> <Plug>TComment_%s '.
                                            \ ':<c-u>call tcomment#ResetOption() \| if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| let w:tcommentPos = getpos(".") \|'.
                                            \ 'set opfunc=%s<cr>%s',
                                            \ a:name, opfunc, a:invoke)
                            endf
                            
                            
    1   0.000060   0.000009 call s:MapOp('Uncomment',  'call tcomment#SetOption("mode_extra", "U")', 'tcomment#Operator', 'g@')
    1   0.000069   0.000017 call s:MapOp('Uncommentc', 'call tcomment#SetOption("mode_extra", "U")', 'tcomment#OperatorLine', 'g@$')
    1   0.000043   0.000006 call s:MapOp('Uncommentb', 'call tcomment#SetOption("mode_extra", "UB")', 'tcomment#OperatorLine', 'g@')
    1              0.000012 xnoremap <silent> <Plug>TComment_Uncomment :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| call tcomment#SetOption("mode_extra", "U") \| '<,'>TCommentMaybeInline<cr>
                            
    1   0.000045   0.000005 call s:MapOp('Comment',  '', 'tcomment#OperatorAnyway', 'g@')
    1   0.000044   0.000005 call s:MapOp('Commentc', '', 'tcomment#OperatorLineAnyway', 'g@$')
    1   0.000048   0.000010 call s:MapOp('Commentb', 'call tcomment#SetOption("mode_extra", "B")', 'tcomment#OperatorLine', 'g@')
    1              0.000010 xnoremap <silent> <Plug>TComment_Comment :<c-u>if v:count > 0 \| call tcomment#SetOption("count", v:count) \| endif \| '<,'>TCommentMaybeInline!<cr>
                            
    1              0.000007 vnoremap <Plug>TComment_ic :<c-U>call tcomment#TextObjectInlineComment()<cr>
    1              0.000007 noremap <Plug>TComment_ic :<c-U>call tcomment#TextObjectInlineComment()<cr>
                            
    1   0.000044   0.000005 call s:MapOp('gcc', '', 'tcomment#OperatorLine', 'g@$')
    1   0.000040   0.000005 call s:MapOp('gcb', 'call tcomment#SetOption("mode_extra", "B")', 'tcomment#OperatorLine', 'g@')
    1              0.000006 xnoremap <Plug>TComment_gc :TCommentMaybeInline<cr>
                            
    1   0.000044   0.000005 call s:MapOp('gc', '', 'tcomment#Operator', 'g@')
                            
   10              0.000010 for s:i in range(1, 9)
    9              0.000086     exec 'noremap <Plug>TComment_<c-_>' . s:i . ' :call tcomment#SetOption("count", '. s:i .')<cr>'
    9              0.000087     exec 'inoremap <Plug>TComment_<c-_>' . s:i . ' <c-\><c-o>:call tcomment#SetOption("count", '. s:i .')<cr>'
    9              0.000082     exec 'vnoremap <Plug>TComment_<c-_>' . s:i . ' :call tcomment#SetOption("count", '. s:i .')<cr>'
    9              0.000005 endfor
   10              0.000009 for s:i in range(1, 9)
    9   0.000385   0.000051     call s:MapOp('gc' . s:i .'c', 'call tcomment#SetOption("count", '. s:i .')', 'tcomment#Operator', 'g@')
    9              0.000005 endfor
    1              0.000001 unlet s:i
                            
    1              0.000003 delfun s:MapOp
                            
                            
    1              0.000001 if g:tcommentMaps
                                if g:tcommentMapLeader1 != ''
                                    exec 'map '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment_<c-_><c-_>'
                                    exec 'vmap '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment_<c-_><c-_>'
                                    exec 'imap '. g:tcommentMapLeader1 . g:tcommentMapLeader1 .' <Plug>TComment_<c-_><c-_>'
                                    exec 'map '. g:tcommentMapLeader1 .'p <Plug>TComment_<c-_>p'
                                    exec 'imap '. g:tcommentMapLeader1 .'p <Plug>TComment_<c-_>p'
                                    exec 'map '. g:tcommentMapLeader1 .'<space> <Plug>TComment_<c-_><space>'
                                    exec 'imap '. g:tcommentMapLeader1 .'<space> <Plug>TComment_<c-_><space>'
                                    exec 'imap '. g:tcommentMapLeader1 .'r <Plug>TComment_<c-_>r'
                                    exec 'map '. g:tcommentMapLeader1 .'r <Plug>TComment_<c-_>r'
                                    exec 'vmap '. g:tcommentMapLeader1 .'i <Plug>TComment_<c-_>i'
                                    exec 'map '. g:tcommentMapLeader1 .'i <Plug>TComment_<c-_>i'
                                    exec 'imap '. g:tcommentMapLeader1 .'i <Plug>TComment_<c-_>i'
                                    exec 'map '. g:tcommentMapLeader1 .'b <Plug>TComment_<c-_>b'
                                    exec 'imap '. g:tcommentMapLeader1 .'b <Plug>TComment_<c-_>b'
                                    exec 'map '. g:tcommentMapLeader1 .'a <Plug>TComment_<c-_>a'
                                    exec 'imap '. g:tcommentMapLeader1 .'a <Plug>TComment_<c-_>a'
                                    exec 'map '. g:tcommentMapLeader1 .'n <Plug>TComment_<c-_>n'
                                    exec 'imap '. g:tcommentMapLeader1 .'n <Plug>TComment_<c-_>n'
                                    exec 'map '. g:tcommentMapLeader1 .'s <Plug>TComment_<c-_>s'
                                    exec 'imap '. g:tcommentMapLeader1 .'s <Plug>TComment_<c-_>s'
                                    exec 'map '. g:tcommentMapLeader1 .'cc <Plug>TComment_<c-_>cc'
                                    exec 'map '. g:tcommentMapLeader1 .'ca <Plug>TComment_<c-_>ca'
                                    for s:i in range(1, 9)
                                        exec 'map '. g:tcommentMapLeader1 . s:i .' <Plug>TComment_<c-_>'.s:i
                                        exec 'imap '. g:tcommentMapLeader1 . s:i .' <Plug>TComment_<c-_>'.s:i
                                        exec 'vmap '. g:tcommentMapLeader1 . s:i .' <Plug>TComment_<c-_>'.s:i
                                    endfor
                                    unlet s:i
                                endif
                                if g:tcommentMapLeader2 != ''
                                    exec 'map '. g:tcommentMapLeader2 .'_ <Plug>TComment_<Leader>__'
                                    exec 'xmap '. g:tcommentMapLeader2 .'_ <Plug>TComment_<Leader>__'
                                    exec 'map '. g:tcommentMapLeader2 .'p <Plug>TComment_<Leader>_p'
                                    exec 'map '. g:tcommentMapLeader2 .'<space> <Plug>TComment_<Leader>_<space>'
                                    exec 'xmap '. g:tcommentMapLeader2 .'i <Plug>TComment_<Leader>_i'
                                    exec 'map '. g:tcommentMapLeader2 .'r <Plug>TComment_<Leader>_r'
                                    exec 'map '. g:tcommentMapLeader2 .'b <Plug>TComment_<Leader>_b'
                                    exec 'map '. g:tcommentMapLeader2 .'a <Plug>TComment_<Leader>_a'
                                    exec 'map '. g:tcommentMapLeader2 .'n <Plug>TComment_<Leader>_n'
                                    exec 'map '. g:tcommentMapLeader2 .'s <Plug>TComment_<Leader>_s'
                                endif
                                if g:tcommentMapLeaderOp1 != ''
                                    exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .' <Plug>TComment_gc'
                                    for s:i in range(1, 9)
                                        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 . s:i .' <Plug>TComment_gc'.s:i
                                        exec 'nmap <silent> '. g:tcommentMapLeaderOp1 . s:i .'c <Plug>TComment_gc'.s:i.'c'
                                    endfor
                                    unlet s:i
                                    exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .'c <Plug>TComment_gcc'
                                    exec 'nmap <silent> '. g:tcommentMapLeaderOp1 .'b <Plug>TComment_gcb'
                                    exec 'xmap '. g:tcommentMapLeaderOp1 .' <Plug>TComment_gc'
                                endif
                               if g:tcommentMapLeaderUncommentAnyway != ''
                                    exec 'nmap <silent> '. g:tcommentMapLeaderUncommentAnyway .' <Plug>TComment_Uncomment'
                                    exec 'nmap <silent> '. g:tcommentMapLeaderUncommentAnyway .'c <Plug>TComment_Uncommentc'
                                    exec 'nmap <silent> '. g:tcommentMapLeaderUncommentAnyway .'b <Plug>TComment_Uncommentb'
                                    exec 'xmap '. g:tcommentMapLeaderUncommentAnyway .' <Plug>TComment_Uncomment'
                                endif
                               if g:tcommentMapLeaderCommentAnyway != ''
                                    exec 'nmap <silent> '. g:tcommentMapLeaderCommentAnyway .' <Plug>TComment_Comment'
                                    exec 'nmap <silent> '. g:tcommentMapLeaderCommentAnyway .'c <Plug>TComment_Commentc'
                                    exec 'nmap <silent> '. g:tcommentMapLeaderCommentAnyway .'b <Plug>TComment_Commentb'
                                    exec 'xmap '. g:tcommentMapLeaderCommentAnyway .' <Plug>TComment_Comment'
                                endif
                                if g:tcommentTextObjectInlineComment != ''
                                    exec 'vmap' g:tcommentTextObjectInlineComment ' <Plug>TComment_ic'
                                    exec 'omap' g:tcommentTextObjectInlineComment ' <Plug>TComment_ic'
                                endif
                            endif
                            
                            
    1              0.000004 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            " vi: ft=vim:tw=72:ts=4:fo=w2croql

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/vimproc.vim
Sourced 1 time
Total time:   0.000053
 Self time:   0.000053

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: vimproc.vim
                            " AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_vimproc')
                              finish
                            elseif v:version < 702
                              echoerr 'vimproc does not work this version of Vim "' . v:version . '".'
                              finish
                            endif
                            
    1              0.000002 let g:loaded_vimproc = 1
                            
                            " Saving 'cpoptions' {{{
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            " }}}
                            
    1              0.000006 command! -nargs=* VimProcInstall
                                  \ call vimproc#commands#_install(<q-args>)
    1              0.000005 command! -nargs=+ -complete=shellcmd VimProcBang
                                  \ call vimproc#commands#_bang(<q-args>)
    1              0.000004 command! -nargs=+ -complete=shellcmd VimProcRead
                                  \ call vimproc#commands#_read(<q-args>)
                            
                            " Restore 'cpoptions' {{{
    1              0.000003 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            " }}}
                            " vim: foldmethod=marker

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/vimsnippets.vim
Sourced 1 time
Total time:   0.000026
 Self time:   0.000026

count  total (s)   self (s)
                            if exists("b:done_vimsnippets")
                               finish
                            endif
    1              0.000002 let b:done_vimsnippets = 1
                            
                            " Some variables need default value
    1              0.000002 if !exists("g:snips_author")
    1              0.000001     let g:snips_author = "yourname"
    1              0.000001 endif
                            
    1              0.000002 if !exists("g:snips_email")
    1              0.000001     let g:snips_email = "yourname@email.com"
    1              0.000001 endif
                            
    1              0.000002 if !exists("g:snips_github")
    1              0.000001     let g:snips_github = "https://github.com/yourname"
    1              0.000001 endif
                            
                            " Expanding the path is not needed on Vim 7.4
    1              0.000003 if &cp || version >= 704
    1              0.000001     finish

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/plugin/yankring.vim
Sourced 1 time
Total time:   0.000041
 Self time:   0.000041

count  total (s)   self (s)
                            "=============================================================================
                            " FILE: plugin/yankring.vim
                            " AUTHOR: sgur <sgurrr@gmail.com>
                            " License: MIT license  {{{
                            "     Permission is hereby granted, free of charge, to any person obtaining
                            "     a copy of this software and associated documentation files (the
                            "     "Software"), to deal in the Software without restriction, including
                            "     without limitation the rights to use, copy, modify, merge, publish,
                            "     distribute, sublicense, and/or sell copies of the Software, and to
                            "     permit persons to whom the Software is furnished to do so, subject to
                            "     the following conditions:
                            "
                            "     The above copyright notice and this permission notice shall be included
                            "     in all copies or substantial portions of the Software.
                            "
                            "     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
                            "     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
                            "     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
                            "     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
                            "     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
                            "     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
                            "     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                            " }}}
                            "=============================================================================
                            
    1              0.000003 if exists('g:loaded_ctrlp_ext_yankring')
                              finish
                            endif
    1              0.000002 let g:loaded_ctrlp_ext_yankring = 1
                            
                            
    1              0.000003 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
                            
    1              0.000003 if !get(g:, 'ctrlp_yankring_disable', 0)
                              augroup ctrlp_ext_yankring
                                autocmd!
                                if get(g:, 'ctrlp_yankring_use_textchanged', 1) && exists('##TextChanged')
                                  autocmd TextChanged * call yankring#collect()
                                else
                                  autocmd CursorMoved * call yankring#collect()
                                endif
                                autocmd VimLeavePre * call yankring#store()
                              augroup END
                            endif
                            
                            
    1              0.000003 let &cpo = s:save_cpo
    1              0.000002 unlet s:save_cpo

SCRIPT  /usr/local/share/nvim/runtime/plugin/gzip.vim
Sourced 1 time
Total time:   0.000010
 Self time:   0.000010

count  total (s)   self (s)
                            " Vim plugin for editing compressed files.
                            " Maintainer: Bram Moolenaar <Bram@vim.org>
                            " Last Change: 2010 Mar 10
                            
                            " Exit quickly when:
                            " - this plugin was already loaded
                            " - when 'compatible' is set
                            " - some autocommands are already taking care of compressed files
    1              0.000004 if exists("loaded_gzip") || &cp || exists("#BufReadPre#*.gz")
    1              0.000001   finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/man.vim
Sourced 1 time
Total time:   0.000006
 Self time:   0.000006

count  total (s)   self (s)
                            if get(g:, 'loaded_man', 0)
    1              0.000002   finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/matchit.vim
Sourced 1 time
Total time:   0.000590
 Self time:   0.000590

count  total (s)   self (s)
                            "  matchit.vim: (global plugin) Extended "%" matching
                            "  Last Change: Fri Jan 25 10:00 AM 2008 EST
                            "  Maintainer:  Benji Fisher PhD   <benji@member.AMS.org>
                            "  Version:     1.13.2, for Vim 6.3+
                            "  URL:		http://www.vim.org/script.php?script_id=39
                            
                            " Documentation:
                            "  The documentation is in a separate file, matchit.txt .
                            
                            " Credits:
                            "  Vim editor by Bram Moolenaar (Thanks, Bram!)
                            "  Original script and design by Raul Segura Acevedo
                            "  Support for comments by Douglas Potts
                            "  Support for back references and other improvements by Benji Fisher
                            "  Support for many languages by Johannes Zellner
                            "  Suggestions for improvement, bug reports, and support for additional
                            "  languages by Jordi-Albert Batalla, Neil Bird, Servatius Brandt, Mark
                            "  Collett, Stephen Wall, Dany St-Amant, Yuheng Xie, and Johannes Zellner.
                            
                            " Debugging:
                            "  If you'd like to try the built-in debugging commands...
                            "   :MatchDebug      to activate debugging for the current buffer
                            "  This saves the values of several key script variables as buffer-local
                            "  variables.  See the MatchDebug() function, below, for details.
                            
                            " TODO:  I should think about multi-line patterns for b:match_words.
                            "   This would require an option:  how many lines to scan (default 1).
                            "   This would be useful for Python, maybe also for *ML.
                            " TODO:  Maybe I should add a menu so that people will actually use some of
                            "   the features that I have implemented.
                            " TODO:  Eliminate the MultiMatch function.  Add yet another argument to
                            "   Match_wrapper() instead.
                            " TODO:  Allow :let b:match_words = '\(\(foo\)\(bar\)\):\3\2:end\1'
                            " TODO:  Make backrefs safer by using '\V' (very no-magic).
                            " TODO:  Add a level of indirection, so that custom % scripts can use my
                            "   work but extend it.
                            
                            " allow user to prevent loading
                            " and prevent duplicate loading
    1              0.000005 if exists("loaded_matchit") || &cp
                              finish
                            endif
    1              0.000002 let loaded_matchit = 1
    1              0.000001 let s:last_mps = ""
    1              0.000001 let s:last_words = ":"
                            
    1              0.000002 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
    1              0.000010 nnoremap <silent> %  :<C-U>call <SID>Match_wrapper('',1,'n') <CR>
    1              0.000007 nnoremap <silent> g% :<C-U>call <SID>Match_wrapper('',0,'n') <CR>
    1              0.000007 vnoremap <silent> %  :<C-U>call <SID>Match_wrapper('',1,'v') <CR>m'gv``
    1              0.000006 vnoremap <silent> g% :<C-U>call <SID>Match_wrapper('',0,'v') <CR>m'gv``
    1              0.000006 onoremap <silent> %  v:<C-U>call <SID>Match_wrapper('',1,'o') <CR>
    1              0.000005 onoremap <silent> g% v:<C-U>call <SID>Match_wrapper('',0,'o') <CR>
                            
                            " Analogues of [{ and ]} using matching patterns:
    1              0.000006 nnoremap <silent> [% :<C-U>call <SID>MultiMatch("bW", "n") <CR>
    1              0.000005 nnoremap <silent> ]% :<C-U>call <SID>MultiMatch("W",  "n") <CR>
    1              0.000005 vmap [% <Esc>[%m'gv``
    1              0.000004 vmap ]% <Esc>]%m'gv``
                            " vnoremap <silent> [% :<C-U>call <SID>MultiMatch("bW", "v") <CR>m'gv``
                            " vnoremap <silent> ]% :<C-U>call <SID>MultiMatch("W",  "v") <CR>m'gv``
    1              0.000005 onoremap <silent> [% v:<C-U>call <SID>MultiMatch("bW", "o") <CR>
    1              0.000005 onoremap <silent> ]% v:<C-U>call <SID>MultiMatch("W",  "o") <CR>
                            
                            " text object:
    1              0.000004 vmap a% <Esc>[%v]%
                            
                            " Auto-complete mappings:  (not yet "ready for prime time")
                            " TODO Read :help write-plugin for the "right" way to let the user
                            " specify a key binding.
                            "   let g:match_auto = '<C-]>'
                            "   let g:match_autoCR = '<C-CR>'
                            " if exists("g:match_auto")
                            "   execute "inoremap " . g:match_auto . ' x<Esc>"=<SID>Autocomplete()<CR>Pls'
                            " endif
                            " if exists("g:match_autoCR")
                            "   execute "inoremap " . g:match_autoCR . ' <CR><C-R>=<SID>Autocomplete()<CR>'
                            " endif
                            " if exists("g:match_gthhoh")
                            "   execute "inoremap " . g:match_gthhoh . ' <C-O>:call <SID>Gthhoh()<CR>'
                            " endif " gthhoh = "Get the heck out of here!"
                            
    1              0.000002 let s:notslash = '\\\@<!\%(\\\\\)*'
                            
    1              0.000003 function! s:Match_wrapper(word, forward, mode) range
                              " In s:CleanUp(), :execute "set" restore_options .
                              let restore_options = (&ic ? " " : " no") . "ignorecase"
                              if exists("b:match_ignorecase")
                                let &ignorecase = b:match_ignorecase
                              endif
                              let restore_options = " ve=" . &ve . restore_options
                              set ve=
                              " If this function was called from Visual mode, make sure that the cursor
                              " is at the correct end of the Visual range:
                              if a:mode == "v"
                                execute "normal! gv\<Esc>"
                              endif
                              " In s:CleanUp(), we may need to check whether the cursor moved forward.
                              let startline = line(".")
                              let startcol = col(".")
                              " Use default behavior if called with a count.
                              if v:count
                                exe "normal! " . v:count . "%"
                                return s:CleanUp(restore_options, a:mode, startline, startcol)
                              end
                            
                              " First step:  if not already done, set the script variables
                              "   s:do_BR	flag for whether there are backrefs
                              "   s:pat	parsed version of b:match_words
                              "   s:all	regexp based on s:pat and the default groups
                              "
                              if !exists("b:match_words") || b:match_words == ""
                                let match_words = ""
                                " Allow b:match_words = "GetVimMatchWords()" .
                              elseif b:match_words =~ ":"
                                let match_words = b:match_words
                              else
                                execute "let match_words =" b:match_words
                              endif
                            " Thanks to Preben "Peppe" Guldberg and Bram Moolenaar for this suggestion!
                              if (match_words != s:last_words) || (&mps != s:last_mps) ||
                                \ exists("b:match_debug")
                                let s:last_words = match_words
                                let s:last_mps = &mps
                                " The next several lines were here before
                                " BF started messing with this script.
                                " quote the special chars in 'matchpairs', replace [,:] with \| and then
                                " append the builtin pairs (/*, */, #if, #ifdef, #else, #elif, #endif)
                                " let default = substitute(escape(&mps, '[$^.*~\\/?]'), '[,:]\+',
                                "  \ '\\|', 'g').'\|\/\*\|\*\/\|#if\>\|#ifdef\>\|#else\>\|#elif\>\|#endif\>'
                                let default = escape(&mps, '[$^.*~\\/?]') . (strlen(&mps) ? "," : "") .
                                  \ '\/\*:\*\/,#\s*if\%(def\)\=:#\s*else\>:#\s*elif\>:#\s*endif\>'
                                " s:all = pattern with all the keywords
                                let match_words = match_words . (strlen(match_words) ? "," : "") . default
                                if match_words !~ s:notslash . '\\\d'
                                  let s:do_BR = 0
                                  let s:pat = match_words
                                else
                                  let s:do_BR = 1
                                  let s:pat = s:ParseWords(match_words)
                                endif
                                let s:all = substitute(s:pat, s:notslash . '\zs[,:]\+', '\\|', 'g')
                                let s:all = '\%(' . s:all . '\)'
                                " let s:all = '\%(' . substitute(s:all, '\\\ze[,:]', '', 'g') . '\)'
                                if exists("b:match_debug")
                                  let b:match_pat = s:pat
                                endif
                              endif
                            
                              " Second step:  set the following local variables:
                              "     matchline = line on which the cursor started
                              "     curcol    = number of characters before match
                              "     prefix    = regexp for start of line to start of match
                              "     suffix    = regexp for end of match to end of line
                              " Require match to end on or after the cursor and prefer it to
                              " start on or before the cursor.
                              let matchline = getline(startline)
                              if a:word != ''
                                " word given
                                if a:word !~ s:all
                                  echohl WarningMsg|echo 'Missing rule for word:"'.a:word.'"'|echohl NONE
                                  return s:CleanUp(restore_options, a:mode, startline, startcol)
                                endif
                                let matchline = a:word
                                let curcol = 0
                                let prefix = '^\%('
                                let suffix = '\)$'
                              " Now the case when "word" is not given
                              else	" Find the match that ends on or after the cursor and set curcol.
                                let regexp = s:Wholematch(matchline, s:all, startcol-1)
                                let curcol = match(matchline, regexp)
                                " If there is no match, give up.
                                if curcol == -1
                                  return s:CleanUp(restore_options, a:mode, startline, startcol)
                                endif
                                let endcol = matchend(matchline, regexp)
                                let suf = strlen(matchline) - endcol
                                let prefix = (curcol ? '^.*\%'  . (curcol + 1) . 'c\%(' : '^\%(')
                                let suffix = (suf ? '\)\%' . (endcol + 1) . 'c.*$'  : '\)$')
                              endif
                              if exists("b:match_debug")
                                let b:match_match = matchstr(matchline, regexp)
                                let b:match_col = curcol+1
                              endif
                            
                              " Third step:  Find the group and single word that match, and the original
                              " (backref) versions of these.  Then, resolve the backrefs.
                              " Set the following local variable:
                              " group = colon-separated list of patterns, one of which matches
                              "       = ini:mid:fin or ini:fin
                              "
                              " Reconstruct the version with unresolved backrefs.
                              let patBR = substitute(match_words.',',
                                \ s:notslash.'\zs[,:]*,[,:]*', ',', 'g')
                              let patBR = substitute(patBR, s:notslash.'\zs:\{2,}', ':', 'g')
                              " Now, set group and groupBR to the matching group: 'if:endif' or
                              " 'while:endwhile' or whatever.  A bit of a kluge:  s:Choose() returns
                              " group . "," . groupBR, and we pick it apart.
                              let group = s:Choose(s:pat, matchline, ",", ":", prefix, suffix, patBR)
                              let i = matchend(group, s:notslash . ",")
                              let groupBR = strpart(group, i)
                              let group = strpart(group, 0, i-1)
                              " Now, matchline =~ prefix . substitute(group,':','\|','g') . suffix
                              if s:do_BR " Do the hard part:  resolve those backrefs!
                                let group = s:InsertRefs(groupBR, prefix, group, suffix, matchline)
                              endif
                              if exists("b:match_debug")
                                let b:match_wholeBR = groupBR
                                let i = matchend(groupBR, s:notslash . ":")
                                let b:match_iniBR = strpart(groupBR, 0, i-1)
                              endif
                            
                              " Fourth step:  Set the arguments for searchpair().
                              let i = matchend(group, s:notslash . ":")
                              let j = matchend(group, '.*' . s:notslash . ":")
                              let ini = strpart(group, 0, i-1)
                              let mid = substitute(strpart(group, i,j-i-1), s:notslash.'\zs:', '\\|', 'g')
                              let fin = strpart(group, j)
                              "Un-escape the remaining , and : characters.
                              let ini = substitute(ini, s:notslash . '\zs\\\(:\|,\)', '\1', 'g')
                              let mid = substitute(mid, s:notslash . '\zs\\\(:\|,\)', '\1', 'g')
                              let fin = substitute(fin, s:notslash . '\zs\\\(:\|,\)', '\1', 'g')
                              " searchpair() requires that these patterns avoid \(\) groups.
                              let ini = substitute(ini, s:notslash . '\zs\\(', '\\%(', 'g')
                              let mid = substitute(mid, s:notslash . '\zs\\(', '\\%(', 'g')
                              let fin = substitute(fin, s:notslash . '\zs\\(', '\\%(', 'g')
                              " Set mid.  This is optimized for readability, not micro-efficiency!
                              if a:forward && matchline =~ prefix . fin . suffix
                                \ || !a:forward && matchline =~ prefix . ini . suffix
                                let mid = ""
                              endif
                              " Set flag.  This is optimized for readability, not micro-efficiency!
                              if a:forward && matchline =~ prefix . fin . suffix
                                \ || !a:forward && matchline !~ prefix . ini . suffix
                                let flag = "bW"
                              else
                                let flag = "W"
                              endif
                              " Set skip.
                              if exists("b:match_skip")
                                let skip = b:match_skip
                              elseif exists("b:match_comment") " backwards compatibility and testing!
                                let skip = "r:" . b:match_comment
                              else
                                let skip = 's:comment\|string'
                              endif
                              let skip = s:ParseSkip(skip)
                              if exists("b:match_debug")
                                let b:match_ini = ini
                                let b:match_tail = (strlen(mid) ? mid.'\|' : '') . fin
                              endif
                            
                              " Fifth step:  actually start moving the cursor and call searchpair().
                              " Later, :execute restore_cursor to get to the original screen.
                              let restore_cursor = virtcol(".") . "|"
                              normal! g0
                              let restore_cursor = line(".") . "G" .  virtcol(".") . "|zs" . restore_cursor
                              normal! H
                              let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
                              execute restore_cursor
                              call cursor(0, curcol + 1)
                              " normal! 0
                              " if curcol
                              "   execute "normal!" . curcol . "l"
                              " endif
                              if skip =~ 'synID' && !(has("syntax") && exists("g:syntax_on"))
                                let skip = "0"
                              else
                                execute "if " . skip . "| let skip = '0' | endif"
                              endif
                              let sp_return = searchpair(ini, mid, fin, flag, skip)
                              let final_position = "call cursor(" . line(".") . "," . col(".") . ")"
                              " Restore cursor position and original screen.
                              execute restore_cursor
                              normal! m'
                              if sp_return > 0
                                execute final_position
                              endif
                              return s:CleanUp(restore_options, a:mode, startline, startcol, mid.'\|'.fin)
                            endfun
                            
                            " Restore options and do some special handling for Operator-pending mode.
                            " The optional argument is the tail of the matching group.
    1              0.000003 fun! s:CleanUp(options, mode, startline, startcol, ...)
                              execute "set" a:options
                              " Open folds, if appropriate.
                              if a:mode != "o"
                                if &foldopen =~ "percent"
                                  normal! zv
                                endif
                                " In Operator-pending mode, we want to include the whole match
                                " (for example, d%).
                                " This is only a problem if we end up moving in the forward direction.
                              elseif (a:startline < line(".")) ||
                            	\ (a:startline == line(".") && a:startcol < col("."))
                                if a:0
                                  " Check whether the match is a single character.  If not, move to the
                                  " end of the match.
                                  let matchline = getline(".")
                                  let currcol = col(".")
                                  let regexp = s:Wholematch(matchline, a:1, currcol-1)
                                  let endcol = matchend(matchline, regexp)
                                  if endcol > currcol  " This is NOT off by one!
                            	execute "normal!" . (endcol - currcol) . "l"
                                  endif
                                endif " a:0
                              endif " a:mode != "o" && etc.
                              return 0
                            endfun
                            
                            " Example (simplified HTML patterns):  if
                            "   a:groupBR	= '<\(\k\+\)>:</\1>'
                            "   a:prefix	= '^.\{3}\('
                            "   a:group	= '<\(\k\+\)>:</\(\k\+\)>'
                            "   a:suffix	= '\).\{2}$'
                            "   a:matchline	=  "123<tag>12" or "123</tag>12"
                            " then extract "tag" from a:matchline and return "<tag>:</tag>" .
    1              0.000002 fun! s:InsertRefs(groupBR, prefix, group, suffix, matchline)
                              if a:matchline !~ a:prefix .
                                \ substitute(a:group, s:notslash . '\zs:', '\\|', 'g') . a:suffix
                                return a:group
                              endif
                              let i = matchend(a:groupBR, s:notslash . ':')
                              let ini = strpart(a:groupBR, 0, i-1)
                              let tailBR = strpart(a:groupBR, i)
                              let word = s:Choose(a:group, a:matchline, ":", "", a:prefix, a:suffix,
                                \ a:groupBR)
                              let i = matchend(word, s:notslash . ":")
                              let wordBR = strpart(word, i)
                              let word = strpart(word, 0, i-1)
                              " Now, a:matchline =~ a:prefix . word . a:suffix
                              if wordBR != ini
                                let table = s:Resolve(ini, wordBR, "table")
                              else
                                " let table = "----------"
                                let table = ""
                                let d = 0
                                while d < 10
                                  if tailBR =~ s:notslash . '\\' . d
                            	" let table[d] = d
                            	let table = table . d
                                  else
                            	let table = table . "-"
                                  endif
                                  let d = d + 1
                                endwhile
                              endif
                              let d = 9
                              while d
                                if table[d] != "-"
                                  let backref = substitute(a:matchline, a:prefix.word.a:suffix,
                            	\ '\'.table[d], "")
                            	" Are there any other characters that should be escaped?
                                  let backref = escape(backref, '*,:')
                                  execute s:Ref(ini, d, "start", "len")
                                  let ini = strpart(ini, 0, start) . backref . strpart(ini, start+len)
                                  let tailBR = substitute(tailBR, s:notslash . '\zs\\' . d,
                            	\ escape(backref, '\\&'), 'g')
                                endif
                                let d = d-1
                              endwhile
                              if exists("b:match_debug")
                                if s:do_BR
                                  let b:match_table = table
                                  let b:match_word = word
                                else
                                  let b:match_table = ""
                                  let b:match_word = ""
                                endif
                              endif
                              return ini . ":" . tailBR
                            endfun
                            
                            " Input a comma-separated list of groups with backrefs, such as
                            "   a:groups = '\(foo\):end\1,\(bar\):end\1'
                            " and return a comma-separated list of groups with backrefs replaced:
                            "   return '\(foo\):end\(foo\),\(bar\):end\(bar\)'
    1              0.000001 fun! s:ParseWords(groups)
                              let groups = substitute(a:groups.",", s:notslash.'\zs[,:]*,[,:]*', ',', 'g')
                              let groups = substitute(groups, s:notslash . '\zs:\{2,}', ':', 'g')
                              let parsed = ""
                              while groups =~ '[^,:]'
                                let i = matchend(groups, s:notslash . ':')
                                let j = matchend(groups, s:notslash . ',')
                                let ini = strpart(groups, 0, i-1)
                                let tail = strpart(groups, i, j-i-1) . ":"
                                let groups = strpart(groups, j)
                                let parsed = parsed . ini
                                let i = matchend(tail, s:notslash . ':')
                                while i != -1
                                  " In 'if:else:endif', ini='if' and word='else' and then word='endif'.
                                  let word = strpart(tail, 0, i-1)
                                  let tail = strpart(tail, i)
                                  let i = matchend(tail, s:notslash . ':')
                                  let parsed = parsed . ":" . s:Resolve(ini, word, "word")
                                endwhile " Now, tail has been used up.
                                let parsed = parsed . ","
                              endwhile " groups =~ '[^,:]'
                              let parsed = substitute(parsed, ',$', '', '')
                              return parsed
                            endfun
                            
                            " TODO I think this can be simplified and/or made more efficient.
                            " TODO What should I do if a:start is out of range?
                            " Return a regexp that matches all of a:string, such that
                            " matchstr(a:string, regexp) represents the match for a:pat that starts
                            " as close to a:start as possible, before being preferred to after, and
                            " ends after a:start .
                            " Usage:
                            " let regexp = s:Wholematch(getline("."), 'foo\|bar', col(".")-1)
                            " let i      = match(getline("."), regexp)
                            " let j      = matchend(getline("."), regexp)
                            " let match  = matchstr(getline("."), regexp)
    1              0.000002 fun! s:Wholematch(string, pat, start)
                              let group = '\%(' . a:pat . '\)'
                              let prefix = (a:start ? '\(^.*\%<' . (a:start + 2) . 'c\)\zs' : '^')
                              let len = strlen(a:string)
                              let suffix = (a:start+1 < len ? '\(\%>'.(a:start+1).'c.*$\)\@=' : '$')
                              if a:string !~ prefix . group . suffix
                                let prefix = ''
                              endif
                              return prefix . group . suffix
                            endfun
                            
                            " No extra arguments:  s:Ref(string, d) will
                            " find the d'th occurrence of '\(' and return it, along with everything up
                            " to and including the matching '\)'.
                            " One argument:  s:Ref(string, d, "start") returns the index of the start
                            " of the d'th '\(' and any other argument returns the length of the group.
                            " Two arguments:  s:Ref(string, d, "foo", "bar") returns a string to be
                            " executed, having the effect of
                            "   :let foo = s:Ref(string, d, "start")
                            "   :let bar = s:Ref(string, d, "len")
    1              0.000002 fun! s:Ref(string, d, ...)
                              let len = strlen(a:string)
                              if a:d == 0
                                let start = 0
                              else
                                let cnt = a:d
                                let match = a:string
                                while cnt
                                  let cnt = cnt - 1
                                  let index = matchend(match, s:notslash . '\\(')
                                  if index == -1
                            	return ""
                                  endif
                                  let match = strpart(match, index)
                                endwhile
                                let start = len - strlen(match)
                                if a:0 == 1 && a:1 == "start"
                                  return start - 2
                                endif
                                let cnt = 1
                                while cnt
                                  let index = matchend(match, s:notslash . '\\(\|\\)') - 1
                                  if index == -2
                            	return ""
                                  endif
                                  " Increment if an open, decrement if a ')':
                                  let cnt = cnt + (match[index]=="(" ? 1 : -1)  " ')'
                                  " let cnt = stridx('0(', match[index]) + cnt
                                  let match = strpart(match, index+1)
                                endwhile
                                let start = start - 2
                                let len = len - start - strlen(match)
                              endif
                              if a:0 == 1
                                return len
                              elseif a:0 == 2
                                return "let " . a:1 . "=" . start . "| let " . a:2 . "=" . len
                              else
                                return strpart(a:string, start, len)
                              endif
                            endfun
                            
                            " Count the number of disjoint copies of pattern in string.
                            " If the pattern is a literal string and contains no '0' or '1' characters
                            " then s:Count(string, pattern, '0', '1') should be faster than
                            " s:Count(string, pattern).
    1              0.000002 fun! s:Count(string, pattern, ...)
                              let pat = escape(a:pattern, '\\')
                              if a:0 > 1
                                let foo = substitute(a:string, '[^'.a:pattern.']', "a:1", "g")
                                let foo = substitute(a:string, pat, a:2, "g")
                                let foo = substitute(foo, '[^' . a:2 . ']', "", "g")
                                return strlen(foo)
                              endif
                              let result = 0
                              let foo = a:string
                              let index = matchend(foo, pat)
                              while index != -1
                                let result = result + 1
                                let foo = strpart(foo, index)
                                let index = matchend(foo, pat)
                              endwhile
                              return result
                            endfun
                            
                            " s:Resolve('\(a\)\(b\)', '\(c\)\2\1\1\2') should return table.word, where
                            " word = '\(c\)\(b\)\(a\)\3\2' and table = '-32-------'.  That is, the first
                            " '\1' in target is replaced by '\(a\)' in word, table[1] = 3, and this
                            " indicates that all other instances of '\1' in target are to be replaced
                            " by '\3'.  The hard part is dealing with nesting...
                            " Note that ":" is an illegal character for source and target,
                            " unless it is preceded by "\".
    1              0.000002 fun! s:Resolve(source, target, output)
                              let word = a:target
                              let i = matchend(word, s:notslash . '\\\d') - 1
                              let table = "----------"
                              while i != -2 " There are back references to be replaced.
                                let d = word[i]
                                let backref = s:Ref(a:source, d)
                                " The idea is to replace '\d' with backref.  Before we do this,
                                " replace any \(\) groups in backref with :1, :2, ... if they
                                " correspond to the first, second, ... group already inserted
                                " into backref.  Later, replace :1 with \1 and so on.  The group
                                " number w+b within backref corresponds to the group number
                                " s within a:source.
                                " w = number of '\(' in word before the current one
                                let w = s:Count(
                                \ substitute(strpart(word, 0, i-1), '\\\\', '', 'g'), '\(', '1')
                                let b = 1 " number of the current '\(' in backref
                                let s = d " number of the current '\(' in a:source
                                while b <= s:Count(substitute(backref, '\\\\', '', 'g'), '\(', '1')
                                \ && s < 10
                                  if table[s] == "-"
                            	if w + b < 10
                            	  " let table[s] = w + b
                            	  let table = strpart(table, 0, s) . (w+b) . strpart(table, s+1)
                            	endif
                            	let b = b + 1
                            	let s = s + 1
                                  else
                            	execute s:Ref(backref, b, "start", "len")
                            	let ref = strpart(backref, start, len)
                            	let backref = strpart(backref, 0, start) . ":". table[s]
                            	\ . strpart(backref, start+len)
                            	let s = s + s:Count(substitute(ref, '\\\\', '', 'g'), '\(', '1')
                                  endif
                                endwhile
                                let word = strpart(word, 0, i-1) . backref . strpart(word, i+1)
                                let i = matchend(word, s:notslash . '\\\d') - 1
                              endwhile
                              let word = substitute(word, s:notslash . '\zs:', '\\', 'g')
                              if a:output == "table"
                                return table
                              elseif a:output == "word"
                                return word
                              else
                                return table . word
                              endif
                            endfun
                            
                            " Assume a:comma = ",".  Then the format for a:patterns and a:1 is
                            "   a:patterns = "<pat1>,<pat2>,..."
                            "   a:1 = "<alt1>,<alt2>,..."
                            " If <patn> is the first pattern that matches a:string then return <patn>
                            " if no optional arguments are given; return <patn>,<altn> if a:1 is given.
    1              0.000002 fun! s:Choose(patterns, string, comma, branch, prefix, suffix, ...)
                              let tail = (a:patterns =~ a:comma."$" ? a:patterns : a:patterns . a:comma)
                              let i = matchend(tail, s:notslash . a:comma)
                              if a:0
                                let alttail = (a:1 =~ a:comma."$" ? a:1 : a:1 . a:comma)
                                let j = matchend(alttail, s:notslash . a:comma)
                              endif
                              let current = strpart(tail, 0, i-1)
                              if a:branch == ""
                                let currpat = current
                              else
                                let currpat = substitute(current, s:notslash . a:branch, '\\|', 'g')
                              endif
                              while a:string !~ a:prefix . currpat . a:suffix
                                let tail = strpart(tail, i)
                                let i = matchend(tail, s:notslash . a:comma)
                                if i == -1
                                  return -1
                                endif
                                let current = strpart(tail, 0, i-1)
                                if a:branch == ""
                                  let currpat = current
                                else
                                  let currpat = substitute(current, s:notslash . a:branch, '\\|', 'g')
                                endif
                                if a:0
                                  let alttail = strpart(alttail, j)
                                  let j = matchend(alttail, s:notslash . a:comma)
                                endif
                              endwhile
                              if a:0
                                let current = current . a:comma . strpart(alttail, 0, j-1)
                              endif
                              return current
                            endfun
                            
                            " Call this function to turn on debugging information.  Every time the main
                            " script is run, buffer variables will be saved.  These can be used directly
                            " or viewed using the menu items below.
    1              0.000003 if !exists(":MatchDebug")
    1              0.000006   command! -nargs=0 MatchDebug call s:Match_debug()
    1              0.000001 endif
                            
    1              0.000001 fun! s:Match_debug()
                              let b:match_debug = 1	" Save debugging information.
                              " pat = all of b:match_words with backrefs parsed
                              amenu &Matchit.&pat	:echo b:match_pat<CR>
                              " match = bit of text that is recognized as a match
                              amenu &Matchit.&match	:echo b:match_match<CR>
                              " curcol = cursor column of the start of the matching text
                              amenu &Matchit.&curcol	:echo b:match_col<CR>
                              " wholeBR = matching group, original version
                              amenu &Matchit.wh&oleBR	:echo b:match_wholeBR<CR>
                              " iniBR = 'if' piece, original version
                              amenu &Matchit.ini&BR	:echo b:match_iniBR<CR>
                              " ini = 'if' piece, with all backrefs resolved from match
                              amenu &Matchit.&ini	:echo b:match_ini<CR>
                              " tail = 'else\|endif' piece, with all backrefs resolved from match
                              amenu &Matchit.&tail	:echo b:match_tail<CR>
                              " fin = 'endif' piece, with all backrefs resolved from match
                              amenu &Matchit.&word	:echo b:match_word<CR>
                              " '\'.d in ini refers to the same thing as '\'.table[d] in word.
                              amenu &Matchit.t&able	:echo '0:' . b:match_table . ':9'<CR>
                            endfun
                            
                            " Jump to the nearest unmatched "(" or "if" or "<tag>" if a:spflag == "bW"
                            " or the nearest unmatched "</tag>" or "endif" or ")" if a:spflag == "W".
                            " Return a "mark" for the original position, so that
                            "   let m = MultiMatch("bW", "n") ... execute m
                            " will return to the original position.  If there is a problem, do not
                            " move the cursor and return "", unless a count is given, in which case
                            " go up or down as many levels as possible and again return "".
                            " TODO This relies on the same patterns as % matching.  It might be a good
                            " idea to give it its own matching patterns.
    1              0.000012 fun! s:MultiMatch(spflag, mode)
                              if !exists("b:match_words") || b:match_words == ""
                                return ""
                              end
                              let restore_options = (&ic ? "" : "no") . "ignorecase"
                              if exists("b:match_ignorecase")
                                let &ignorecase = b:match_ignorecase
                              endif
                              let startline = line(".")
                              let startcol = col(".")
                            
                              " First step:  if not already done, set the script variables
                              "   s:do_BR	flag for whether there are backrefs
                              "   s:pat	parsed version of b:match_words
                              "   s:all	regexp based on s:pat and the default groups
                              " This part is copied and slightly modified from s:Match_wrapper().
                              let default = escape(&mps, '[$^.*~\\/?]') . (strlen(&mps) ? "," : "") .
                                \ '\/\*:\*\/,#\s*if\%(def\)\=:#\s*else\>:#\s*elif\>:#\s*endif\>'
                              " Allow b:match_words = "GetVimMatchWords()" .
                              if b:match_words =~ ":"
                                let match_words = b:match_words
                              else
                                execute "let match_words =" b:match_words
                              endif
                              if (match_words != s:last_words) || (&mps != s:last_mps) ||
                                \ exists("b:match_debug")
                                let s:last_words = match_words
                                let s:last_mps = &mps
                                if match_words !~ s:notslash . '\\\d'
                                  let s:do_BR = 0
                                  let s:pat = match_words
                                else
                                  let s:do_BR = 1
                                  let s:pat = s:ParseWords(match_words)
                                endif
                                let s:all = '\%(' . substitute(s:pat . (strlen(s:pat)?",":"") . default,
                                  \	'[,:]\+','\\|','g') . '\)'
                                if exists("b:match_debug")
                                  let b:match_pat = s:pat
                                endif
                              endif
                            
                              " Second step:  figure out the patterns for searchpair()
                              " and save the screen, cursor position, and 'ignorecase'.
                              " - TODO:  A lot of this is copied from s:Match_wrapper().
                              " - maybe even more functionality should be split off
                              " - into separate functions!
                              let cdefault = (s:pat =~ '[^,]$' ? "," : "") . default
                              let open =  substitute(s:pat . cdefault,
                            	\ s:notslash . '\zs:.\{-}' . s:notslash . ',', '\\),\\(', 'g')
                              let open =  '\(' . substitute(open, s:notslash . '\zs:.*$', '\\)', '')
                              let close = substitute(s:pat . cdefault,
                            	\ s:notslash . '\zs,.\{-}' . s:notslash . ':', '\\),\\(', 'g')
                              let close = substitute(close, '^.\{-}' . s:notslash . ':', '\\(', '') . '\)'
                              if exists("b:match_skip")
                                let skip = b:match_skip
                              elseif exists("b:match_comment") " backwards compatibility and testing!
                                let skip = "r:" . b:match_comment
                              else
                                let skip = 's:comment\|string'
                              endif
                              let skip = s:ParseSkip(skip)
                              " let restore_cursor = line(".") . "G" . virtcol(".") . "|"
                              " normal! H
                              " let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
                              let restore_cursor = virtcol(".") . "|"
                              normal! g0
                              let restore_cursor = line(".") . "G" .  virtcol(".") . "|zs" . restore_cursor
                              normal! H
                              let restore_cursor = "normal!" . line(".") . "Gzt" . restore_cursor
                              execute restore_cursor
                            
                              " Third step: call searchpair().
                              " Replace '\('--but not '\\('--with '\%(' and ',' with '\|'.
                              let openpat =  substitute(open, '\(\\\@<!\(\\\\\)*\)\@<=\\(', '\\%(', 'g')
                              let openpat = substitute(openpat, ',', '\\|', 'g')
                              let closepat = substitute(close, '\(\\\@<!\(\\\\\)*\)\@<=\\(', '\\%(', 'g')
                              let closepat = substitute(closepat, ',', '\\|', 'g')
                              if skip =~ 'synID' && !(has("syntax") && exists("g:syntax_on"))
                                let skip = '0'
                              else
                                execute "if " . skip . "| let skip = '0' | endif"
                              endif
                              mark '
                              let level = v:count1
                              while level
                                if searchpair(openpat, '', closepat, a:spflag, skip) < 1
                                  call s:CleanUp(restore_options, a:mode, startline, startcol)
                                  return ""
                                endif
                                let level = level - 1
                              endwhile
                            
                              " Restore options and return a string to restore the original position.
                              call s:CleanUp(restore_options, a:mode, startline, startcol)
                              return restore_cursor
                            endfun
                            
                            " Search backwards for "if" or "while" or "<tag>" or ...
                            " and return "endif" or "endwhile" or "</tag>" or ... .
                            " For now, this uses b:match_words and the same script variables
                            " as s:Match_wrapper() .  Later, it may get its own patterns,
                            " either from a buffer variable or passed as arguments.
                            " fun! s:Autocomplete()
                            "   echo "autocomplete not yet implemented :-("
                            "   if !exists("b:match_words") || b:match_words == ""
                            "     return ""
                            "   end
                            "   let startpos = s:MultiMatch("bW")
                            "
                            "   if startpos == ""
                            "     return ""
                            "   endif
                            "   " - TODO:  figure out whether 'if' or '<tag>' matched, and construct
                            "   " - the appropriate closing.
                            "   let matchline = getline(".")
                            "   let curcol = col(".") - 1
                            "   " - TODO:  Change the s:all argument if there is a new set of match pats.
                            "   let regexp = s:Wholematch(matchline, s:all, curcol)
                            "   let suf = strlen(matchline) - matchend(matchline, regexp)
                            "   let prefix = (curcol ? '^.\{'  . curcol . '}\%(' : '^\%(')
                            "   let suffix = (suf ? '\).\{' . suf . '}$'  : '\)$')
                            "   " Reconstruct the version with unresolved backrefs.
                            "   let patBR = substitute(b:match_words.',', '[,:]*,[,:]*', ',', 'g')
                            "   let patBR = substitute(patBR, ':\{2,}', ':', "g")
                            "   " Now, set group and groupBR to the matching group: 'if:endif' or
                            "   " 'while:endwhile' or whatever.
                            "   let group = s:Choose(s:pat, matchline, ",", ":", prefix, suffix, patBR)
                            "   let i = matchend(group, s:notslash . ",")
                            "   let groupBR = strpart(group, i)
                            "   let group = strpart(group, 0, i-1)
                            "   " Now, matchline =~ prefix . substitute(group,':','\|','g') . suffix
                            "   if s:do_BR
                            "     let group = s:InsertRefs(groupBR, prefix, group, suffix, matchline)
                            "   endif
                            " " let g:group = group
                            "
                            "   " - TODO:  Construct the closing from group.
                            "   let fake = "end" . expand("<cword>")
                            "   execute startpos
                            "   return fake
                            " endfun
                            
                            " Close all open structures.  "Get the heck out of here!"
                            " fun! s:Gthhoh()
                            "   let close = s:Autocomplete()
                            "   while strlen(close)
                            "     put=close
                            "     let close = s:Autocomplete()
                            "   endwhile
                            " endfun
                            
                            " Parse special strings as typical skip arguments for searchpair():
                            "   s:foo becomes (current syntax item) =~ foo
                            "   S:foo becomes (current syntax item) !~ foo
                            "   r:foo becomes (line before cursor) =~ foo
                            "   R:foo becomes (line before cursor) !~ foo
    1              0.000002 fun! s:ParseSkip(str)
                              let skip = a:str
                              if skip[1] == ":"
                                if skip[0] == "s"
                                  let skip = "synIDattr(synID(line('.'),col('.'),1),'name') =~? '" .
                            	\ strpart(skip,2) . "'"
                                elseif skip[0] == "S"
                                  let skip = "synIDattr(synID(line('.'),col('.'),1),'name') !~? '" .
                            	\ strpart(skip,2) . "'"
                                elseif skip[0] == "r"
                                  let skip = "strpart(getline('.'),0,col('.'))=~'" . strpart(skip,2). "'"
                                elseif skip[0] == "R"
                                  let skip = "strpart(getline('.'),0,col('.'))!~'" . strpart(skip,2). "'"
                                endif
                              endif
                              return skip
                            endfun
                            
    1              0.000004 let &cpo = s:save_cpo
    1              0.000001 unlet s:save_cpo
                            
                            " vim:sts=2:sw=2:

SCRIPT  /usr/local/share/nvim/runtime/plugin/matchparen.vim
Sourced 1 time
Total time:   0.000174
 Self time:   0.000174

count  total (s)   self (s)
                            " Vim plugin for showing matching parens
                            " Maintainer:  Bram Moolenaar <Bram@vim.org>
                            " Last Change: 2014 Jul 19
                            
                            " Exit quickly when:
                            " - this plugin was already loaded (or disabled)
                            " - when 'compatible' is set
                            " - the "CursorMoved" autocmd event is not available.
    1              0.000007 if exists("g:loaded_matchparen") || &cp || !exists("##CursorMoved")
                              finish
                            endif
    1              0.000002 let g:loaded_matchparen = 1
                            
    1              0.000002 if !exists("g:matchparen_timeout")
    1              0.000001   let g:matchparen_timeout = 300
    1              0.000001 endif
    1              0.000002 if !exists("g:matchparen_insert_timeout")
    1              0.000001   let g:matchparen_insert_timeout = 60
    1              0.000001 endif
                            
    1              0.000002 augroup matchparen
                              " Replace all matchparen autocommands
    1              0.000008   autocmd! CursorMoved,CursorMovedI,WinEnter * call s:Highlight_Matching_Pair()
    1              0.000002   if exists('##TextChanged')
    1              0.000005     autocmd! TextChanged,TextChangedI * call s:Highlight_Matching_Pair()
    1              0.000001   endif
    1              0.000001 augroup END
                            
                            " Skip the rest if it was already done.
    1              0.000003 if exists("*s:Highlight_Matching_Pair")
                              finish
                            endif
                            
    1              0.000004 let s:cpo_save = &cpo
    1              0.000004 set cpo-=C
                            
                            " The function that is invoked (very often) to define a ":match" highlighting
                            " for any matching paren.
    1              0.000002 function! s:Highlight_Matching_Pair()
                              " Remove any previous match.
                              if exists('w:paren_hl_on') && w:paren_hl_on
                                silent! call matchdelete(3)
                                let w:paren_hl_on = 0
                              endif
                            
                              " Avoid that we remove the popup menu.
                              " Return when there are no colors (looks like the cursor jumps).
                              if pumvisible() || (&t_Co < 8 && !has("gui_running"))
                                return
                              endif
                            
                              " Get the character under the cursor and check if it's in 'matchpairs'.
                              let c_lnum = line('.')
                              let c_col = col('.')
                              let before = 0
                            
                              let text = getline(c_lnum)
                              let c = text[c_col - 1]
                              let plist = split(&matchpairs, '.\zs[:,]')
                              let i = index(plist, c)
                              if i < 0
                                " not found, in Insert mode try character before the cursor
                                if c_col > 1 && (mode() == 'i' || mode() == 'R')
                                  let before = 1
                                  let c = text[c_col - 2]
                                  let i = index(plist, c)
                                endif
                                if i < 0
                                  " not found, nothing to do
                                  return
                                endif
                              endif
                            
                              " Figure out the arguments for searchpairpos().
                              if i % 2 == 0
                                let s_flags = 'nW'
                                let c2 = plist[i + 1]
                              else
                                let s_flags = 'nbW'
                                let c2 = c
                                let c = plist[i - 1]
                              endif
                              if c == '['
                                let c = '\['
                                let c2 = '\]'
                              endif
                            
                              " Find the match.  When it was just before the cursor move it there for a
                              " moment.
                              if before > 0
                                let has_getcurpos = exists("*getcurpos")
                                if has_getcurpos
                                  " getcurpos() is more efficient but doesn't exist before 7.4.313.
                                  let save_cursor = getcurpos()
                                else
                                  let save_cursor = winsaveview()
                                endif
                                call cursor(c_lnum, c_col - before)
                              endif
                            
                              " Build an expression that detects whether the current cursor position is in
                              " certain syntax types (string, comment, etc.), for use as searchpairpos()'s
                              " skip argument.
                              " We match "escape" for special items, such as lispEscapeSpecial.
                              let s_skip = '!empty(filter(map(synstack(line("."), col(".")), ''synIDattr(v:val, "name")''), ' .
                            	\ '''v:val =~? "string\\|character\\|singlequote\\|escape\\|comment"''))'
                              " If executing the expression determines that the cursor is currently in
                              " one of the syntax types, then we want searchpairpos() to find the pair
                              " within those syntax types (i.e., not skip).  Otherwise, the cursor is
                              " outside of the syntax types and s_skip should keep its value so we skip any
                              " matching pair inside the syntax types.
                              execute 'if' s_skip '| let s_skip = 0 | endif'
                            
                              " Limit the search to lines visible in the window.
                              let stoplinebottom = line('w$')
                              let stoplinetop = line('w0')
                              if i % 2 == 0
                                let stopline = stoplinebottom
                              else
                                let stopline = stoplinetop
                              endif
                            
                              " Limit the search time to 300 msec to avoid a hang on very long lines.
                              " This fails when a timeout is not supported.
                              if mode() == 'i' || mode() == 'R'
                                let timeout = exists("b:matchparen_insert_timeout") ? b:matchparen_insert_timeout : g:matchparen_insert_timeout
                              else
                                let timeout = exists("b:matchparen_timeout") ? b:matchparen_timeout : g:matchparen_timeout
                              endif
                              try
                                let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip, stopline, timeout)
                              catch /E118/
                                " Can't use the timeout, restrict the stopline a bit more to avoid taking
                                " a long time on closed folds and long lines.
                                " The "viewable" variables give a range in which we can scroll while
                                " keeping the cursor at the same position.
                                " adjustedScrolloff accounts for very large numbers of scrolloff.
                                let adjustedScrolloff = min([&scrolloff, (line('w$') - line('w0')) / 2])
                                let bottom_viewable = min([line('$'), c_lnum + &lines - adjustedScrolloff - 2])
                                let top_viewable = max([1, c_lnum-&lines+adjustedScrolloff + 2])
                                " one of these stoplines will be adjusted below, but the current values are
                                " minimal boundaries within the current window
                                if i % 2 == 0
                                  if has("byte_offset") && has("syntax_items") && &smc > 0
                            	let stopbyte = min([line2byte("$"), line2byte(".") + col(".") + &smc * 2])
                            	let stopline = min([bottom_viewable, byte2line(stopbyte)])
                                  else
                            	let stopline = min([bottom_viewable, c_lnum + 100])
                                  endif
                                  let stoplinebottom = stopline
                                else
                                  if has("byte_offset") && has("syntax_items") && &smc > 0
                            	let stopbyte = max([1, line2byte(".") + col(".") - &smc * 2])
                            	let stopline = max([top_viewable, byte2line(stopbyte)])
                                  else
                            	let stopline = max([top_viewable, c_lnum - 100])
                                  endif
                                  let stoplinetop = stopline
                                endif
                                let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip, stopline)
                              endtry
                            
                              if before > 0
                                if has_getcurpos
                                  call setpos('.', save_cursor)
                                else
                                  call winrestview(save_cursor)
                                endif
                              endif
                            
                              " If a match is found setup match highlighting.
                              if m_lnum > 0 && m_lnum >= stoplinetop && m_lnum <= stoplinebottom 
                                if exists('*matchaddpos')
                                  call matchaddpos('MatchParen', [[c_lnum, c_col - before], [m_lnum, m_col]], 10, 3)
                                else
                                  exe '3match MatchParen /\(\%' . c_lnum . 'l\%' . (c_col - before) .
                            	    \ 'c\)\|\(\%' . m_lnum . 'l\%' . m_col . 'c\)/'
                                endif
                                let w:paren_hl_on = 1
                              endif
                            endfunction
                            
                            " Define commands that will disable and enable the plugin.
    1              0.000007 command! NoMatchParen windo silent! call matchdelete(3) | unlet! g:loaded_matchparen |
                            	  \ au! matchparen
    1              0.000004 command! DoMatchParen runtime plugin/matchparen.vim | windo doau CursorMoved
                            
    1              0.000004 let &cpo = s:cpo_save
    1              0.000002 unlet s:cpo_save

SCRIPT  /usr/local/share/nvim/runtime/plugin/netrwPlugin.vim
Sourced 1 time
Total time:   0.000015
 Self time:   0.000015

count  total (s)   self (s)
                            " netrwPlugin.vim: Handles file transfer and remote directory listing across a network
                            "            PLUGIN SECTION
                            " Date:		Nov 07, 2014
                            " Maintainer:	Charles E Campbell <NdrOchip@ScampbellPfamily.AbizM-NOSPAM>
                            " GetLatestVimScripts: 1075 1 :AutoInstall: netrw.vim
                            " Copyright:    Copyright (C) 1999-2013 Charles E. Campbell {{{1
                            "               Permission is hereby granted to use and distribute this code,
                            "               with or without modifications, provided that this copyright
                            "               notice is copied with it. Like anything else that's free,
                            "               netrw.vim, netrwPlugin.vim, and netrwSettings.vim are provided
                            "               *as is* and comes with no warranty of any kind, either
                            "               expressed or implied. By using this plugin, you agree that
                            "               in no event will the copyright holder be liable for any damages
                            "               resulting from the use of this software.
                            "
                            "  But be doers of the Word, and not only hearers, deluding your own selves {{{1
                            "  (James 1:22 RSV)
                            " =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                            " Load Once: {{{1
    1              0.000005 if &cp || exists("g:loaded_netrwPlugin")
    1              0.000001  finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/rplugin.vim
Sourced 1 time
Total time:   0.003530
 Self time:   0.000019

count  total (s)   self (s)
                            if exists('g:loaded_remote_plugins') || &cp
                              finish
                            endif
    1              0.000002 let g:loaded_remote_plugins = 1
    1   0.003520   0.000008 call remote#host#LoadRemotePlugins()

SCRIPT  /Users/zchee/src/github.com/zchee/dotfiles/.config/nvim/.init.vim-rplugin~
Sourced 1 time
Total time:   0.003453
 Self time:   0.000153

count  total (s)   self (s)
                            " go/vigor plugins
    1   0.000969   0.000035 call remote#host#RegisterPlugin('go/vigor', '/Users/zchee/src/github.com/garyburd/vigor/rplugin/go/vigor/vigor', [
                                  \ {'sync': 1, 'name': 'Godoc', 'type': 'command', 'opts': {'complete': 'customlist,QQQDocComplete', 'nargs': '*', 'eval': '[getcwd(), 0]'}},
                                  \ {'sync': 1, 'name': 'Pgodoc', 'type': 'command', 'opts': {'complete': 'customlist,QQQDocComplete', 'nargs': '*', 'eval': '[getcwd(), 1]'}},
                                  \ {'sync': 1, 'name': 'Godef', 'type': 'command', 'opts': {'complete': 'customlist,QQQDocComplete', 'nargs': '*', 'eval': 'getcwd()'}},
                                  \ {'sync': 1, 'name': 'QQQDocComplete', 'type': 'function', 'opts': {'eval': 'getcwd()'}},
                                  \ {'sync': 1, 'name': 'BufReadCmd', 'type': 'autocmd', 'opts': {'pattern': 'godoc://**', 'eval': '[expand(''%''), getcwd()]'}},
                                  \ {'sync': 1, 'name': 'Fmt', 'type': 'command', 'opts': {'range': '%', 'eval': 'expand(''%:p'')'}},
                                 \ ])
                            
                            
                            " python3 plugins
    1   0.000306   0.000016 call remote#host#RegisterPlugin('python3', '/Users/zchee/src/github.com/zchee/treachery.nvim/rplugin/python3/treachery.py', [
                                  \ {'sync': 0, 'name': 'FocusGained', 'type': 'autocmd', 'opts': {'pattern': '*'}},
                                  \ {'sync': 0, 'name': 'BufWinEnter', 'type': 'autocmd', 'opts': {'pattern': '*'}},
                                 \ ])
    1   0.000544   0.000029 call remote#host#RegisterPlugin('python3', '/Users/zchee/src/github.com/bfredl/nvim-ipy/rplugin/python3/nvim_ipy.py', [
                                  \ {'sync': 0, 'name': 'IPyComplete', 'type': 'function', 'opts': {}},
                                  \ {'sync': 1, 'name': 'IPyConnect', 'type': 'function', 'opts': {}},
                                  \ {'sync': 0, 'name': 'IPyInterrupt', 'type': 'function', 'opts': {}},
                                  \ {'sync': 0, 'name': 'IPyObjInfo', 'type': 'function', 'opts': {}},
                                  \ {'sync': 1, 'name': 'IPyOmniFunc', 'type': 'function', 'opts': {}},
                                  \ {'sync': 0, 'name': 'IPyRun', 'type': 'function', 'opts': {}},
                                  \ {'sync': 0, 'name': 'IPyTerminate', 'type': 'function', 'opts': {}},
                                 \ ])
    1   0.000064   0.000006 call remote#host#RegisterPlugin('python3', '/Users/zchee/src/github.com/zchee/nvim-pep8/rplugin/python3/nvim-pep8.py', [
                                 \ ])
    1   0.000125   0.000009 call remote#host#RegisterPlugin('python3', '/Users/zchee/.cache/nvim/dein/.dein/rplugin/python3/deoplete.py', [
                                  \ {'sync': 1, 'name': '_deoplete', 'type': 'function', 'opts': {}},
                                 \ ])
                            
                            
                            " go/nvim-go plugins
    1   0.001203   0.000036 call remote#host#RegisterPlugin('go/nvim-go', '/Users/zchee/src/github.com/zchee/nvim-go/rplugin/go/nvim-go/nvim-go', [
                                  \ {'sync': 1, 'name': 'Gobuild', 'type': 'command', 'opts': {'nargs': '?', 'eval': 'expand(''%:p:h'')'}},
                                  \ {'sync': 1, 'name': 'GoByteOffset', 'type': 'command', 'opts': {'range': '%', 'eval': 'expand(''%:p'')'}},
                                  \ {'sync': 0, 'name': 'Godef', 'type': 'command', 'opts': {'nargs': '?', 'eval': 'expand(''%:p'')'}},
                                  \ {'sync': 1, 'name': 'Gofmt', 'type': 'command', 'opts': {'range': '%', 'eval': 'expand(''%:p:h'')'}},
                                  \ {'sync': 1, 'name': 'BufWritePre', 'type': 'autocmd', 'opts': {'pattern': '*.go', 'eval': 'expand(''%:p:h'')'}},
                                  \ {'sync': 0, 'name': 'GoGuru', 'type': 'command', 'opts': {'complete': 'customlist,GuruCompletelist', 'nargs': '+', 'eval': '[expand(''%:p:h''), expand(''%:p'')]'}},
                                  \ {'sync': 1, 'name': 'GuruCompletelist', 'type': 'function', 'opts': {}},
                                  \ {'sync': 1, 'name': 'Gorename', 'type': 'command', 'opts': {'nargs': '?', 'eval': '[expand(''%:p:h''), expand(''%:p''), line2byte(line(''.''))+(col(''.'')-2)]'}},
                                 \ ])
                            
                            
                            " python plugins
    1   0.000233   0.000012 call remote#host#RegisterPlugin('python', '/Users/zchee/.cache/nvim/dein/.dein/rplugin/python/lldb_nvim.py', [
                                  \ {'sync': 0, 'name': 'LLsession', 'type': 'command', 'opts': {'complete': 'customlist,lldb#session#complete', 'nargs': '+'}},
                                 \ ])
                            
                            

SCRIPT  /usr/local/share/nvim/runtime/plugin/rrhelper.vim
Sourced 1 time
Total time:   0.000011
 Self time:   0.000011

count  total (s)   self (s)
                            " Vim plugin with helper function(s) for --remote-wait
                            " Maintainer: Flemming Madsen <fma@cci.dk>
                            " Last Change: 2008 May 29
                            
                            " Has this already been loaded?
    1              0.000004 if exists("loaded_rrhelper") || !has("clientserver")
    1              0.000001   finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/shada.vim
Sourced 1 time
Total time:   0.000120
 Self time:   0.000120

count  total (s)   self (s)
                            if exists('g:loaded_shada_plugin')
                              finish
                            endif
    1              0.000002 let g:loaded_shada_plugin = 1
                            
    1              0.000001 augroup ShaDaCommands
    1              0.000055   autocmd!
    1              0.000013   autocmd BufReadCmd *.shada,*.shada.tmp.[a-z]
                                    \ :if !empty(v:cmdarg)|throw '++opt not supported'|endif
                                    \ |call setline('.', shada#get_strings(readfile(expand('<afile>'),'b')))
                                    \ |setlocal filetype=shada
    1              0.000007   autocmd FileReadCmd *.shada,*.shada.tmp.[a-z]
                                    \ :if !empty(v:cmdarg)|throw '++opt not supported'|endif
                                    \ |call append("'[", shada#get_strings(readfile(expand('<afile>'), 'b')))
    1              0.000010   autocmd BufWriteCmd *.shada,*.shada.tmp.[a-z]
                                    \ :if !empty(v:cmdarg)|throw '++opt not supported'|endif
                                    \ |if writefile(shada#get_binstrings(getline(1, '$')),
                                                   \expand('<afile>'), 'b') == 0
                                    \ |  let &l:modified = (expand('<afile>') is# bufname(+expand('<abuf>'))
                                                           \? 0
                                                           \: stridx(&cpoptions, '+') != -1)
                                    \ |endif
    1              0.000009   autocmd FileWriteCmd *.shada,*.shada.tmp.[a-z]
                                    \ :if !empty(v:cmdarg)|throw '++opt not supported'|endif
                                    \ |call writefile(
                                          \shada#get_binstrings(getline(min([line("'["), line("']")]),
                                                                       \max([line("'["), line("']")]))),
                                          \expand('<afile>'),
                                          \'b')
    1              0.000008   autocmd FileAppendCmd *.shada,*.shada.tmp.[a-z]
                                    \ :if !empty(v:cmdarg)|throw '++opt not supported'|endif
                                    \ |call writefile(
                                          \shada#get_binstrings(getline(min([line("'["), line("']")]),
                                                                       \max([line("'["), line("']")]))),
                                          \expand('<afile>'),
                                          \'ab')
    1              0.000006   autocmd SourceCmd *.shada,*.shada.tmp.[a-z]
                                    \ :execute 'rshada' fnameescape(expand('<afile>'))
    1              0.000002 augroup END

SCRIPT  /usr/local/share/nvim/runtime/plugin/spellfile.vim
Sourced 1 time
Total time:   0.000011
 Self time:   0.000011

count  total (s)   self (s)
                            " Vim plugin for downloading spell files
                            " Maintainer:  Bram Moolenaar <Bram@vim.org>
                            " Last Change: 2006 Feb 01
                            
                            " Exit quickly when:
                            " - this plugin was already loaded
                            " - when 'compatible' is set
                            " - some autocommands are already taking care of spell files
    1              0.000005 if exists("loaded_spellfile_plugin") || &cp || exists("#SpellFileMissing")
    1              0.000001   finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/tarPlugin.vim
Sourced 1 time
Total time:   0.000013
 Self time:   0.000013

count  total (s)   self (s)
                            " tarPlugin.vim -- a Vim plugin for browsing tarfiles
                            " Original was copyright (c) 2002, Michael C. Toren <mct@toren.net>
                            " Modified by Charles E. Campbell
                            " Distributed under the GNU General Public License.
                            "
                            " Updates are available from <http://michael.toren.net/code/>.  If you
                            " find this script useful, or have suggestions for improvements, please
                            " let me know.
                            " Also look there for further comments and documentation.
                            "
                            " This part only sets the autocommands.  The functions are in autoload/tar.vim.
                            " ---------------------------------------------------------------------
                            "  Load Once: {{{1
    1              0.000005 if &cp || exists("g:loaded_tarPlugin")
    1              0.000001  finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/tohtml.vim
Sourced 1 time
Total time:   0.000041
 Self time:   0.000041

count  total (s)   self (s)
                            " Vim plugin for converting a syntax highlighted file to HTML.
                            " Maintainer: Ben Fritz <fritzophrenic@gmail.com>
                            " Last Change: 2013 Jul 08
                            "
                            " The core of the code is in $VIMRUNTIME/autoload/tohtml.vim and
                            " $VIMRUNTIME/syntax/2html.vim
                            "
                            " TODO: {{{
                            "   * Options for generating the CSS in external style sheets. New :TOcss
                            "     command to convert the current color scheme into a (mostly) generic CSS
                            "     stylesheet which can be re-used. Alternate stylesheet support? Good start
                            "     by Erik Falor
                            "     ( https://groups.google.com/d/topic/vim_use/7XTmC4D22dU/discussion ).
                            "   * Add optional argument to :TOhtml command to specify mode (gui, cterm,
                            "     term) to use for the styling. Suggestion by "nacitar".
                            "   * Add way to override or specify which RGB colors map to the color numbers
                            "     in cterm. Get better defaults than just guessing? Suggestion by "nacitar".
                            "   * Disable filetype detection until after all processing is done.
                            "   * Add option for not generating the hyperlink on stuff that looks like a
                            "     URL? Or just color the link to fit with the colorscheme (and only special
                            "     when hovering)?
                            "   * Bug: Opera does not allow printing more than one page if uncopyable
                            "     regions is turned on. Possible solution: Add normal text line numbers with
                            "     display:none, set to display:inline for print style sheets, and hide
                            "     <input> elements for print, to allow Opera printing multiple pages (and
                            "     other uncopyable areas?). May need to make the new text invisible to IE
                            "     with conditional comments to prevent copying it, IE for some reason likes
                            "     to copy hidden text. Other browsers too?
                            "   * Bug: still a 1px gap throughout the fold column when html_prevent_copy is
                            "     "fn" in some browsers. Specifically, in Chromium on Ubuntu (but not Chrome
                            "     on Windows). Perhaps it is font related?
                            "   * Bug: still some gaps in the fold column when html_prevent_copy contains
                            "     'd' and showing the whole diff (observed in multiple browsers). Only gaps
                            "     on diff lines though.
                            "   * Undercurl support via CSS3, with fallback to dotted or something:
                            "	https://groups.google.com/d/topic/vim_use/BzXA6He1pHg/discussion
                            "   * Redo updates for modified default foldtext (v11) when/if the patch is
                            "     accepted to modify it.
                            "   * Test case +diff_one_file-dynamic_folds+expand_tabs-hover_unfold
                            "		+ignore_conceal-ignore_folding+no_foldcolumn+no_pre+no_progress
                            "		+number_lines-pre_wrap-use_css+use_xhtml+whole_filler.xhtml
                            "     does not show the whole diff filler as it is supposed to?
                            "   * Bug: when 'isprint' is wrong for the current encoding, will generate
                            "     invalid content. Can/should anything be done about this? Maybe a separate
                            "     plugin to correct 'isprint' based on encoding?
                            "   * Check to see if the windows-125\d encodings actually work in Unix without
                            "     the 8bit- prefix. Add prefix to autoload dictionaries for Unix if not.
                            "   * Font auto-detection similar to
                            "     http://www.vim.org/scripts/script.php?script_id=2384 but for a variety of
                            "     platforms.
                            "   * Error thrown when sourcing 2html.vim directly when plugins are not loaded.
                            "   * Pull in code from http://www.vim.org/scripts/script.php?script_id=3113 :
                            "	- listchars support
                            "	- full-line background highlight
                            "	- other?
                            "   * Make it so deleted lines in a diff don't create side-scrolling (get it
                            "     free with full-line background highlight above).
                            "   * Restore open/closed folds and cursor position after processing each file
                            "     with option not to restore for speed increase.
                            "   * Add extra meta info (generation time, etc.)?
                            "   * Tidy up so we can use strict doctype in even more situations
                            "   * Implementation detail: add threshold for writing the lines to the html
                            "     buffer before we're done (5000 or so lines should do it)
                            "   * TODO comments for code cleanup scattered throughout
                            "}}}
                            
    1              0.000003 if exists('g:loaded_2html_plugin')
    1              0.000001   finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/tutor.vim
Sourced 1 time
Total time:   0.000006
 Self time:   0.000006

count  total (s)   self (s)
                            if exists('g:loaded_tutor_mode_plugin') || &compatible
    1              0.000002     finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/vimballPlugin.vim
Sourced 1 time
Total time:   0.000012
 Self time:   0.000012

count  total (s)   self (s)
                            " vimballPlugin : construct a file containing both paths and files
                            " Author: Charles E. Campbell, Jr.
                            " Copyright: (c) 2004-2010 by Charles E. Campbell, Jr.
                            "            The VIM LICENSE applies to Vimball.vim, and Vimball.txt
                            "            (see |copyright|) except use "Vimball" instead of "Vim".
                            "            No warranty, express or implied.
                            "  *** ***   Use At-Your-Own-Risk!   *** ***
                            "
                            " (Rom 2:1 WEB) Therefore you are without excuse, O man, whoever you are who
                            "      judge. For in that which you judge another, you condemn yourself. For
                            "      you who judge practice the same things.
                            " GetLatestVimScripts: 1502 1 :AutoInstall: vimball.vim
                            
                            " ---------------------------------------------------------------------
                            "  Load Once: {{{1
    1              0.000004 if &cp || exists("g:loaded_vimballPlugin")
    1              0.000001  finish

SCRIPT  /usr/local/share/nvim/runtime/plugin/zipPlugin.vim
Sourced 1 time
Total time:   0.000013
 Self time:   0.000013

count  total (s)   self (s)
                            " zipPlugin.vim: Handles browsing zipfiles
                            "            PLUGIN PORTION
                            " Date:			Jun 07, 2013
                            " Maintainer:	Charles E Campbell <NdrOchip@ScampbellPfamily.AbizM-NOSPAM>
                            " License:		Vim License  (see vim's :help license)
                            " Copyright:    Copyright (C) 2005-2013 Charles E. Campbell {{{1
                            "               Permission is hereby granted to use and distribute this code,
                            "               with or without modifications, provided that this copyright
                            "               notice is copied with it. Like anything else that's free,
                            "               zipPlugin.vim is provided *as is* and comes with no warranty
                            "               of any kind, either expressed or implied. By using this
                            "               plugin, you agree that in no event will the copyright
                            "               holder be liable for any damages resulting from the use
                            "               of this software.
                            "
                            " (James 4:8 WEB) Draw near to God, and he will draw near to you.
                            " Cleanse your hands, you sinners; and purify your hearts, you double-minded.
                            " ---------------------------------------------------------------------
                            " Load Once: {{{1
    1              0.000004 if &cp || exists("g:loaded_zipPlugin")
    1              0.000001  finish

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/after/plugin/ctrlp.vim
Sourced 1 time
Total time:   0.000035
 Self time:   0.000035

count  total (s)   self (s)
                            if !exists('g:loaded_ctrlp') || g:loaded_ctrlp == 0
                              finish
                            endif
                            
    1              0.000004 let s:save_cpo = &cpo
    1              0.000003 set cpo&vim
                            
    1              0.000004 command! CtrlPCmdline call ctrlp#init(ctrlp#cmdline#id())
    1              0.000003 command! CtrlPMenu call ctrlp#init(ctrlp#menu#id())
                            
    1              0.000003 if !get(g:, 'ctrlp_yankring_disable', 0)
                              command! CtrlPYankring call ctrlp#init(ctrlp#yankring#id())
                            endif
                            
    1              0.000004 let &cpo = s:save_cpo
    1              0.000003 unlet s:save_cpo

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions.vim
Sourced 1 time
Total time:   0.000219
 Self time:   0.000219

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000003 let s:ext = {}
    1              0.000003 let s:ext._theme_funcrefs = []
                            
    1              0.000003 function! s:ext.add_statusline_func(name) dict
                              call airline#add_statusline_func(a:name)
                            endfunction
    1              0.000001 function! s:ext.add_statusline_funcref(function) dict
                              call airline#add_statusline_funcref(a:function)
                            endfunction
    1              0.000001 function! s:ext.add_inactive_statusline_func(name) dict
                              call airline#add_inactive_statusline_func(a:name)
                            endfunction
    1              0.000001 function! s:ext.add_theme_func(name) dict
                              call add(self._theme_funcrefs, function(a:name))
                            endfunction
                            
    1              0.000019 let s:script_path = tolower(resolve(expand('<sfile>:p:h')))
                            
    1              0.000012 let s:filetype_overrides = {
                                  \ 'nerdtree': [ 'NERD', '' ],
                                  \ 'gundo': [ 'Gundo', '' ],
                                  \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
                                  \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
                                  \ 'startify': [ 'startify', '' ],
                                  \ 'vim-plug': [ 'Plugins', '' ],
                                  \ }
                            
    1              0.000002 let s:filetype_regex_overrides = {}
                            
    1              0.000002 function! s:check_defined_section(name)
                              if !exists('w:airline_section_{a:name}')
                                let w:airline_section_{a:name} = g:airline_section_{a:name}
                              endif
                            endfunction
                            
    1              0.000003 function! airline#extensions#append_to_section(name, value)
                              call <sid>check_defined_section(a:name)
                              let w:airline_section_{a:name} .= a:value
                            endfunction
                            
    1              0.000002 function! airline#extensions#prepend_to_section(name, value)
                              call <sid>check_defined_section(a:name)
                              let w:airline_section_{a:name} = a:value . w:airline_section_{a:name}
                            endfunction
                            
    1              0.000002 function! airline#extensions#apply_left_override(section1, section2)
                              let w:airline_section_a = a:section1
                              let w:airline_section_b = a:section2
                              let w:airline_section_c = airline#section#create(['readonly'])
                              let w:airline_render_left = 1
                              let w:airline_render_right = 0
                            endfunction
                            
    1              0.000002 let s:active_winnr = -1
    1              0.000002 function! airline#extensions#apply(...)
                              let s:active_winnr = winnr()
                            
                              if s:is_excluded_window()
                                return -1
                              endif
                            
                              if &buftype == 'help'
                                call airline#extensions#apply_left_override('Help', '%f')
                                let w:airline_section_x = ''
                                let w:airline_section_y = ''
                                let w:airline_render_right = 1
                              endif
                            
                              if &previewwindow
                                let w:airline_section_a = 'Preview'
                                let w:airline_section_b = ''
                                let w:airline_section_c = bufname(winbufnr(winnr()))
                              endif
                            
                              if has_key(s:filetype_overrides, &ft)
                                let args = s:filetype_overrides[&ft]
                                call airline#extensions#apply_left_override(args[0], args[1])
                              endif
                            
                              for item in items(s:filetype_regex_overrides)
                                if match(&ft, item[0]) >= 0
                                  call airline#extensions#apply_left_override(item[1][0], item[1][1])
                                endif
                              endfor
                            endfunction
                            
    1              0.000002 function! s:is_excluded_window()
                              for matchft in g:airline_exclude_filetypes
                                if matchft ==# &ft
                                  return 1
                                endif
                              endfor
                            
                              for matchw in g:airline_exclude_filenames
                                if matchstr(expand('%'), matchw) ==# matchw
                                  return 1
                                endif
                              endfor
                            
                              if g:airline_exclude_preview && &previewwindow
                                return 1
                              endif
                            
                              return 0
                            endfunction
                            
    1              0.000002 function! airline#extensions#load_theme()
                              call airline#util#exec_funcrefs(s:ext._theme_funcrefs, g:airline#themes#{g:airline_theme}#palette)
                            endfunction
                            
    1              0.000001 function! s:sync_active_winnr()
                              if exists('#airline') && winnr() != s:active_winnr
                                call airline#update_statusline()
                              endif
                            endfunction
                            
    1              0.000002 function! airline#extensions#load()
                              " non-trivial number of external plugins use eventignore=all, so we need to account for that
                              autocmd CursorMoved * call <sid>sync_active_winnr()
                            
                              if exists('g:airline_extensions')
                                for ext in g:airline_extensions
                                  call airline#extensions#{ext}#init(s:ext)
                                endfor
                                return
                              endif
                            
                              call airline#extensions#quickfix#init(s:ext)
                            
                              if get(g:, 'loaded_unite', 0)
                                call airline#extensions#unite#init(s:ext)
                              endif
                            
                              if exists(':NetrwSettings')
                                call airline#extensions#netrw#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#ycm#enabled', 0)
                                call airline#extensions#ycm#init(s:ext)
                              endif
                            
                              if get(g:, 'loaded_vimfiler', 0)
                                let g:vimfiler_force_overwrite_statusline = 0
                              endif
                            
                              if get(g:, 'loaded_ctrlp', 0)
                                call airline#extensions#ctrlp#init(s:ext)
                              endif
                            
                              if get(g:, 'CtrlSpaceLoaded', 0)
                                call airline#extensions#ctrlspace#init(s:ext)
                              endif
                            
                              if get(g:, 'command_t_loaded', 0)
                                call airline#extensions#commandt#init(s:ext)
                              endif
                            
                              if exists(':UndotreeToggle')
                                call airline#extensions#undotree#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#hunks#enabled', 1)
                                    \ && (exists('g:loaded_signify') || exists('g:loaded_gitgutter') || exists('g:loaded_changes') || exists('g:loaded_quickfixsigns'))
                                call airline#extensions#hunks#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#tagbar#enabled', 1)
                                    \ && exists(':TagbarToggle')
                                call airline#extensions#tagbar#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#csv#enabled', 1)
                                    \ && (get(g:, 'loaded_csv', 0) || exists(':Table'))
                                call airline#extensions#csv#init(s:ext)
                              endif
                            
                              if exists(':VimShell')
                                let s:filetype_overrides['vimshell'] = ['vimshell','%{vimshell#get_status_string()}']
                                let s:filetype_regex_overrides['^int-'] = ['vimshell','%{substitute(&ft, "int-", "", "")}']
                              endif
                            
                              if get(g:, 'airline#extensions#branch#enabled', 1)
                                    \ && (exists('*fugitive#head') || exists('*lawrencium#statusline') ||
                                    \     (get(g:, 'airline#extensions#branch#use_vcscommand', 0) && exists('*VCSCommandGetStatusLine')))
                                call airline#extensions#branch#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#bufferline#enabled', 1)
                                    \ && exists('*bufferline#get_status_string')
                                call airline#extensions#bufferline#init(s:ext)
                              endif
                            
                              if (get(g:, 'airline#extensions#virtualenv#enabled', 1) && (exists(':VirtualEnvList') || isdirectory($VIRTUAL_ENV)))
                                call airline#extensions#virtualenv#init(s:ext)
                              endif
                            
                              if (get(g:, 'airline#extensions#eclim#enabled', 1) && exists(':ProjectCreate'))
                                call airline#extensions#eclim#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#syntastic#enabled', 1)
                                    \ && exists(':SyntasticCheck')
                                call airline#extensions#syntastic#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#whitespace#enabled', 1)
                                call airline#extensions#whitespace#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#po#enabled', 1) && executable('msgfmt')
                                call airline#extensions#po#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#wordcount#enabled', 1)
                                call airline#extensions#wordcount#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#tabline#enabled', 0)
                                call airline#extensions#tabline#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#tmuxline#enabled', 1) && exists(':Tmuxline')
                                call airline#extensions#tmuxline#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#promptline#enabled', 1) && exists(':PromptlineSnapshot') && len(get(g:, 'airline#extensions#promptline#snapshot_file', ''))
                                call airline#extensions#promptline#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#nrrwrgn#enabled', 1) && exists(':NR') == 2
                                  call airline#extensions#nrrwrgn#init(s:ext)
                              endif
                            
                              if get(g:, 'airline#extensions#unicode#enabled', 1) && exists(':UnicodeTable') == 2
                                  call airline#extensions#unicode#init(s:ext)
                              endif
                            
                              if (get(g:, 'airline#extensions#capslock#enabled', 1) && exists('*CapsLockStatusline'))
                                call airline#extensions#capslock#init(s:ext)
                              endif
                            
                              if (get(g:, 'airline#extensions#windowswap#enabled', 1) && get(g:, 'loaded_windowswap', 0))
                                call airline#extensions#windowswap#init(s:ext)
                              endif
                            
                              if !get(g:, 'airline#extensions#disable_rtp_load', 0)
                                " load all other extensions, which are not part of the default distribution.
                                " (autoload/airline/extensions/*.vim outside of our s:script_path).
                                for file in split(globpath(&rtp, "autoload/airline/extensions/*.vim"), "\n")
                                  " we have to check both resolved and unresolved paths, since it's possible
                                  " that they might not get resolved properly (see #187)
                                  if stridx(tolower(resolve(fnamemodify(file, ':p'))), s:script_path) < 0
                                        \ && stridx(tolower(fnamemodify(file, ':p')), s:script_path) < 0
                                    let name = fnamemodify(file, ':t:r')
                                    if !get(g:, 'airline#extensions#'.name.'#enabled', 1)
                                      continue
                                    endif
                                    try
                                      call airline#extensions#{name}#init(s:ext)
                                    catch
                                    endtry
                                  endif
                                endfor
                              endif
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/quickfix.vim
Sourced 1 time
Total time:   0.000036
 Self time:   0.000036

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000003 let g:airline#extensions#quickfix#quickfix_text = 'Quickfix'
    1              0.000002 let g:airline#extensions#quickfix#location_text = 'Location'
                            
    1              0.000003 function! airline#extensions#quickfix#apply(...)
                              if &buftype == 'quickfix'
                                let w:airline_section_a = s:get_text()
                                let w:airline_section_b = '%{get(w:, "quickfix_title", "")}'
                                let w:airline_section_c = ''
                                let w:airline_section_x = ''
                              endif
                            endfunction
                            
    1              0.000002 function! airline#extensions#quickfix#init(ext)
                              call a:ext.add_statusline_func('airline#extensions#quickfix#apply')
                            endfunction
                            
    1              0.000002 function! s:get_text()
                              redir => buffers
                              silent ls
                              redir END
                            
                              let nr = bufnr('%')
                              for buf in split(buffers, '\n')
                                if match(buf, '\v^\s*'.nr) > -1
                                  if match(buf, '\cQuickfix') > -1
                                    return g:airline#extensions#quickfix#quickfix_text
                                  else
                                    return g:airline#extensions#quickfix#location_text
                                  endif
                                endif
                              endfor
                              return ''
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/ctrlp.vim
Sourced 1 time
Total time:   0.000071
 Self time:   0.000071

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000003 if !get(g:, 'loaded_ctrlp', 0)
                              finish
                            endif
                            
    1              0.000003 let s:color_template = get(g:, 'airline#extensions#ctrlp#color_template', 'insert')
                            
    1              0.000004 function! airline#extensions#ctrlp#generate_color_map(dark, light, white)
                              return {
                                    \ 'CtrlPdark'   : a:dark,
                                    \ 'CtrlPlight'  : a:light,
                                    \ 'CtrlPwhite'  : a:white,
                                    \ 'CtrlParrow1' : [ a:light[1] , a:white[1] , a:light[3] , a:white[3] , ''     ] ,
                                    \ 'CtrlParrow2' : [ a:white[1] , a:light[1] , a:white[3] , a:light[3] , ''     ] ,
                                    \ 'CtrlParrow3' : [ a:light[1] , a:dark[1]  , a:light[3] , a:dark[3]  , ''     ] ,
                                    \ }
                            endfunction
                            
    1              0.000002 function! airline#extensions#ctrlp#load_theme(palette)
                              if exists('a:palette.ctrlp')
                                let theme = a:palette.ctrlp
                              else
                                let s:color_template = has_key(a:palette, s:color_template) ? s:color_template : 'insert'
                                let theme = airline#extensions#ctrlp#generate_color_map(
                                      \ a:palette[s:color_template]['airline_c'],
                                      \ a:palette[s:color_template]['airline_b'],
                                      \ a:palette[s:color_template]['airline_a'])
                              endif
                              for key in keys(theme)
                                call airline#highlighter#exec(key, theme[key])
                              endfor
                            endfunction
                            
                            " Arguments: focus, byfname, regexp, prv, item, nxt, marked
    1              0.000002 function! airline#extensions#ctrlp#ctrlp_airline(...)
                              let b = airline#builder#new({'active': 1})
                              if a:2 == 'file'
                                call b.add_section_spaced('CtrlPlight', 'by fname')
                              endif
                              if a:3
                                call b.add_section_spaced('CtrlPlight', 'regex')
                              endif
                              if get(g:, 'airline#extensions#ctrlp#show_adjacent_modes', 1)
                                call b.add_section_spaced('CtrlPlight', a:4)
                                call b.add_section_spaced('CtrlPwhite', a:5)
                                call b.add_section_spaced('CtrlPlight', a:6)
                              else
                                call b.add_section_spaced('CtrlPwhite', a:5)
                              endif
                              call b.add_section_spaced('CtrlPdark', a:7)
                              call b.split()
                              call b.add_section_spaced('CtrlPdark', a:1)
                              call b.add_section_spaced('CtrlPdark', a:2)
                              call b.add_section_spaced('CtrlPlight', '%{getcwd()}')
                              return b.build()
                            endfunction
                            
                            " Argument: len
    1              0.000002 function! airline#extensions#ctrlp#ctrlp_airline_status(...)
                              let len = '%#CtrlPdark# '.a:1
                              let dir = '%=%<%#CtrlParrow3#'.g:airline_right_sep.'%#CtrlPlight# '.getcwd().' %*'
                              return len.dir
                            endfunction
                            
    1              0.000002 function! airline#extensions#ctrlp#apply(...)
                              " disable statusline overwrite if ctrlp already did it
                              return match(&statusline, 'CtrlPwhite') >= 0 ? -1 : 0
                            endfunction
                            
    1              0.000002 function! airline#extensions#ctrlp#init(ext)
                              let g:ctrlp_status_func = {
                                    \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
                                    \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
                                    \ }
                              call a:ext.add_statusline_func('airline#extensions#ctrlp#apply')
                              call a:ext.add_theme_func('airline#extensions#ctrlp#load_theme')
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/hunks.vim
Sourced 1 time
Total time:   0.000074
 Self time:   0.000074

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000006 if !get(g:, 'loaded_signify', 0) && !get(g:, 'loaded_gitgutter', 0) && !get(g:, 'loaded_changes', 0) && !get(g:, 'loaded_quickfixsigns', 0)
                              finish
                            endif
                            
    1              0.000003 let s:non_zero_only = get(g:, 'airline#extensions#hunks#non_zero_only', 0)
    1              0.000003 let s:hunk_symbols = get(g:, 'airline#extensions#hunks#hunk_symbols', ['+', '~', '-'])
                            
    1              0.000002 function! s:get_hunks_signify()
                              let hunks = sy#repo#get_stats()
                              if hunks[0] >= 0
                                return hunks
                              endif
                              return []
                            endfunction
                            
    1              0.000001 function! s:is_branch_empty()
                              return exists('*airline#extensions#branch#head') && empty(airline#extensions#branch#head())
                            endfunction
                            
    1              0.000001 function! s:get_hunks_gitgutter()
                              if !get(g:, 'gitgutter_enabled', 0) || s:is_branch_empty()
                                return ''
                              endif
                              return GitGutterGetHunkSummary()
                            endfunction
                            
    1              0.000001 function! s:get_hunks_changes()
                              if !get(b:, 'changes_view_enabled', 0) || s:is_branch_empty()
                                return []
                              endif
                              let hunks = changes#GetStats()
                              for i in hunks
                                if i > 0
                                  return hunks
                                endif
                              endfor
                              return []
                            endfunction
                            
    1              0.000001 function! s:get_hunks_empty()
                              return ''
                            endfunction
                            
    1              0.000001 function! s:get_hunks()
                              if !exists('b:source_func')
                                if get(g:, 'loaded_signify') && sy#buffer_is_active()
                                  let b:source_func = 's:get_hunks_signify'
                                elseif exists('*GitGutterGetHunkSummary')
                                  let b:source_func = 's:get_hunks_gitgutter'
                                elseif exists('*changes#GetStats')
                                  let b:source_func = 's:get_hunks_changes'
                                elseif exists('*quickfixsigns#vcsdiff#GetHunkSummary')
                                  let b:source_func = 'quickfixsigns#vcsdiff#GetHunkSummary'
                                else
                                  let b:source_func = 's:get_hunks_empty'
                                endif
                              endif
                              return {b:source_func}()
                            endfunction
                            
    1              0.000002 function! airline#extensions#hunks#get_hunks()
                              if !get(w:, 'airline_active', 0)
                                return ''
                              endif
                              let hunks = s:get_hunks()
                              let string = ''
                              if !empty(hunks)
                                for i in [0, 1, 2]
                                  if s:non_zero_only == 0 || hunks[i] > 0
                                    let string .= printf('%s%s ', s:hunk_symbols[i], hunks[i])
                                  endif
                                endfor
                              endif
                              return string
                            endfunction
                            
    1              0.000003 function! airline#extensions#hunks#init(ext)
                              call airline#parts#define_function('hunks', 'airline#extensions#hunks#get_hunks')
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/whitespace.vim
Sourced 1 time
Total time:   0.000145
 Self time:   0.000145

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
                            " http://got-ravings.blogspot.com/2008/10/vim-pr0n-statusline-whitespace-flags.html
                            
    1              0.000004 let s:show_message = get(g:, 'airline#extensions#whitespace#show_message', 1)
    1              0.000004 let s:symbol = get(g:, 'airline#extensions#whitespace#symbol', g:airline_symbols.whitespace)
    1              0.000002 let s:default_checks = ['indent', 'trailing', 'mixed-indent-file']
                            
    1              0.000003 let s:trailing_format = get(g:, 'airline#extensions#whitespace#trailing_format', 'trailing[%s]')
    1              0.000003 let s:mixed_indent_format = get(g:, 'airline#extensions#whitespace#mixed_indent_format', 'mixed-indent[%s]')
    1              0.000003 let s:long_format = get(g:, 'airline#extensions#whitespace#long_format', 'long[%s]')
    1              0.000003 let s:mixed_indent_file_format = get(g:, 'airline#extensions#whitespace#mixed_indent_file_format', 'mix-indent-file[%s]')
    1              0.000002 let s:indent_algo = get(g:, 'airline#extensions#whitespace#mixed_indent_algo', 0)
    1              0.000003 let s:skip_check_ft = {'make': ['indent', 'mixed-indent-file'] }
                            
    1              0.000003 let s:max_lines = get(g:, 'airline#extensions#whitespace#max_lines', 20000)
                            
    1              0.000002 let s:enabled = get(g:, 'airline#extensions#whitespace#enabled', 1)
                            
    1              0.000002 function! s:check_mixed_indent()
                              if s:indent_algo == 1
                                " [<tab>]<space><tab>
                                " spaces before or between tabs are not allowed
                                let t_s_t = '(^\t* +\t\s*\S)'
                                " <tab>(<space> x count)
                                " count of spaces at the end of tabs should be less than tabstop value
                                let t_l_s = '(^\t+ {' . &ts . ',}' . '\S)'
                                return search('\v' . t_s_t . '|' . t_l_s, 'nw')
                              elseif s:indent_algo == 2
                                return search('\v(^\t* +\t\s*\S)', 'nw')
                              else
                                return search('\v(^\t+ +)|(^ +\t+)', 'nw')
                              endif
                            endfunction
                            
    1              0.000002 function! s:check_mixed_indent_file()
                              if stridx(&ft, 'c') == 0 || stridx(&ft, 'cpp') == 0
                                " for C/CPP only allow /** */ comment style with one space before the '*'
                                let head_spc = '\v(^ +\*@!)'
                              else
                                let head_spc = '\v(^ +)'
                              endif
                              let indent_tabs = search('\v(^\t+)', 'nw')
                              let indent_spc  = search(head_spc, 'nw')
                              if indent_tabs > 0 && indent_spc > 0
                                return printf("%d:%d", indent_tabs, indent_spc)
                              else
                                return ''
                              endif
                            endfunction
                            
    1              0.000013 function! airline#extensions#whitespace#check()
                              if &readonly || !&modifiable || !s:enabled || line('$') > s:max_lines
                                return ''
                              endif
                            
                              if !exists('b:airline_whitespace_check')
                                let b:airline_whitespace_check = ''
                                let checks = get(g:, 'airline#extensions#whitespace#checks', s:default_checks)
                            
                                let trailing = 0
                                if index(checks, 'trailing') > -1
                                  try
                                    let regexp = get(g:, 'airline#extensions#whitespace#trailing_regexp', '\s$')
                                    let trailing = search(regexp, 'nw')
                                  catch
                                    echomsg 'airline#whitespace: error occured evaluating '. regexp
                                    echomsg v:exception
                                    return ''
                                  endtry
                                endif
                            
                                let mixed = 0
                                let check = 'indent'
                                if index(checks, check) > -1 && index(get(s:skip_check_ft, &ft, []), check) < 0
                                  let mixed = s:check_mixed_indent()
                                endif
                            
                                let mixed_file = ''
                                let check = 'mixed-indent-file'
                                if index(checks, check) > -1 && index(get(s:skip_check_ft, &ft, []), check) < 0
                                  let mixed_file = s:check_mixed_indent_file()
                                endif
                            
                                let long = 0
                                if index(checks, 'long') > -1 && &tw > 0
                                  let long = search('\%>'.&tw.'v.\+', 'nw')
                                endif
                            
                                if trailing != 0 || mixed != 0 || long != 0 || !empty(mixed_file)
                                  let b:airline_whitespace_check = s:symbol
                                  if s:show_message
                                    if trailing != 0
                                      let b:airline_whitespace_check .= (g:airline_symbols.space).printf(s:trailing_format, trailing)
                                    endif
                                    if mixed != 0
                                      let b:airline_whitespace_check .= (g:airline_symbols.space).printf(s:mixed_indent_format, mixed)
                                    endif
                                    if long != 0
                                      let b:airline_whitespace_check .= (g:airline_symbols.space).printf(s:long_format, long)
                                    endif
                                    if !empty(mixed_file)
                                      let b:airline_whitespace_check .= (g:airline_symbols.space).printf(s:mixed_indent_file_format, mixed_file)
                                    endif
                                  endif
                                endif
                              endif
                              return b:airline_whitespace_check
                            endfunction
                            
    1              0.000002 function! airline#extensions#whitespace#toggle()
                              if s:enabled
                                augroup airline_whitespace
                                  autocmd!
                                augroup END
                                augroup! airline_whitespace
                                let s:enabled = 0
                              else
                                call airline#extensions#whitespace#init()
                                let s:enabled = 1
                              endif
                            
                              if exists("g:airline#extensions#whitespace#enabled")
                                let g:airline#extensions#whitespace#enabled = s:enabled
                                if s:enabled && match(g:airline_section_warning, '#whitespace#check') < 0
                                  let g:airline_section_warning .= airline#section#create(['whitespace'])
                                  call airline#update_statusline()
                                endif
                              endif
                              echo 'Whitespace checking: '.(s:enabled ? 'Enabled' : 'Disabled')
                            endfunction
                            
    1              0.000002 function! airline#extensions#whitespace#init(...)
                              call airline#parts#define_function('whitespace', 'airline#extensions#whitespace#check')
                            
                              unlet! b:airline_whitespace_check
                              augroup airline_whitespace
                                autocmd!
                                autocmd CursorHold,BufWritePost * unlet! b:airline_whitespace_check
                              augroup END
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/po.vim
Sourced 1 time
Total time:   0.000033
 Self time:   0.000033

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000003 function! airline#extensions#po#apply(...)
                              if &ft ==# 'po'
                                call airline#extensions#prepend_to_section('z', '%{airline#extensions#po#stats()}')
                                autocmd airline BufWritePost * unlet! b:airline_po_stats
                              endif
                            endfunction
                            
    1              0.000002 function! airline#extensions#po#stats()
                              if exists('b:airline_po_stats') && !empty(b:airline_po_stats)
                                return b:airline_po_stats
                              endif
                            
                              let airline_po_stats = system('msgfmt --statistics -o /dev/null -- '. expand('%:p'))
                              if v:shell_error
                                return ''
                              endif
                              try
                                let b:airline_po_stats = '['. split(airline_po_stats, '\n')[0]. ']'
                              catch
                                let b:airline_po_stats = ''
                              endtry
                              if exists("g:airline#extensions#po#displayed_limit")
                                let w:displayed_po_limit = g:airline#extensions#po#displayed_limit
                                if len(b:airline_po_stats) > w:displayed_po_limit - 1
                                  let b:airline_po_stats = b:airline_po_stats[0:(w:displayed_po_limit - 1)].(&encoding==?'utf-8' ? '…' : '.')
                                endif
                              endif
                              return b:airline_po_stats
                            endfunction
                            
    1              0.000003 function! airline#extensions#po#init(ext)
                                call a:ext.add_statusline_func('airline#extensions#po#apply')
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/wordcount.vim
Sourced 1 time
Total time:   0.000041
 Self time:   0.000041

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000005 let s:filetypes = get(g:, 'airline#extensions#wordcount#filetypes', '\vhelp|markdown|rst|org|text')
    1              0.000003 let s:format = get(g:, 'airline#extensions#wordcount#format', '%d words')
    1              0.000003 let s:formatter = get(g:, 'airline#extensions#wordcount#formatter', 'default')
                            
    1              0.000002 function! s:update()
                              if match(&ft, s:filetypes) > -1
                                let l:mode = mode()
                                if l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# 's' || l:mode ==# 'S'
                                  let b:airline_wordcount = airline#extensions#wordcount#formatters#{s:formatter}#format()
                                  let b:airline_change_tick = b:changedtick
                                else
                                  if get(b:, 'airline_wordcount_cache', '') is# '' ||
                                        \ b:airline_wordcount_cache isnot# get(b:, 'airline_wordcount', '') ||
                                        \ get(b:, 'airline_change_tick', 0) != b:changedtick
                                    " cache data
                                    let b:airline_wordcount = airline#extensions#wordcount#formatters#{s:formatter}#format()
                                    let b:airline_wordcount_cache = b:airline_wordcount
                                    let b:airline_change_tick = b:changedtick
                                  endif
                                endif
                              endif
                            endfunction
                            
    1              0.000003 function! airline#extensions#wordcount#apply(...)
                              if &ft =~ s:filetypes
                                call airline#extensions#prepend_to_section('z', '%{get(b:, "airline_wordcount", "")}')
                              endif
                            endfunction
                            
    1              0.000002 function! airline#extensions#wordcount#init(ext)
                              call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
                              autocmd BufReadPost,CursorMoved,CursorMovedI * call s:update()
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/themes/hybridline.vim
Sourced 1 time
Total time:   0.000390
 Self time:   0.000166

count  total (s)   self (s)
                            " vim-airline theme based on vim-hybrid and powerline
                            " (https://github.com/w0ng/vim-hybrid)
                            " (https://github.com/Lokaltog/powerline)
                            
    1              0.000003 let g:airline#themes#hybridline#palette = {}
                            
    1              0.000003 let s:N1 = [ '#282a2e' , '#c5c8c6' , 'black' , 15      ]
    1              0.000002 let s:N2 = [ '#c5c8c6' , '#373b41' , 15      , 8       ]
    1              0.000002 let s:N3 = [ '#ffffff' , '#282a2e' , 255     , 'black' ]
    1              0.000080 let g:airline#themes#hybridline#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
    1              0.000006 let g:airline#themes#hybridline#palette.normal.airline_a = ['#005f00', '#b5bd68', 22, 10, '']
                            
    1              0.000002 let s:I1 = [ '#005f5f' , '#8abeb7' , 23  , 14 ]
    1              0.000002 let s:I2 = [ '#c5c8c6' , '#0087af' , 15  , 31 ]
    1              0.000002 let s:I3 = [ '#ffffff' , '#005f87' , 255 , 24 ]
    1   0.000038   0.000005 let g:airline#themes#hybridline#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
    1              0.000005 let g:airline#themes#hybridline#palette.insert_paste = {
                                        \ 'airline_a': ['#000000', '#ac4142', 16 , 1, ''] ,
                                        \ }
                            
    1   0.000035   0.000005 let g:airline#themes#hybridline#palette.replace = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
    1              0.000004 let g:airline#themes#hybridline#palette.replace.airline_a = ['#000000', '#CC6666', 16, 9]
                            
    1   0.000032   0.000004 let g:airline#themes#hybridline#palette.visual = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
    1              0.000003 let g:airline#themes#hybridline#palette.visual.airline_a = ['#000000', '#de935f', 16, 3]
                            
    1              0.000002 let s:IA1 = [ '#4e4e4e' , '#1c1c1c' , 239 , 234 , '' ]
    1              0.000002 let s:IA2 = [ '#4e4e4e' , '#262626' , 239 , 235 , '' ]
    1              0.000002 let s:IA3 = [ '#4e4e4e' , '#303030' , 239 , 236 , '' ]
    1   0.000034   0.000004 let g:airline#themes#hybridline#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
                            
    1              0.000005 let g:airline#themes#hybridline#palette.accents = {

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/themes.vim
Sourced 1 time
Total time:   0.000057
 Self time:   0.000057

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
                            " generates a dictionary which defines the colors for each highlight group
    1              0.000004 function! airline#themes#generate_color_map(sect1, sect2, sect3, ...)
                              let palette = {
                                    \ 'airline_a': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , get(a:sect1 , 4 , '') ] ,
                                    \ 'airline_b': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , get(a:sect2 , 4 , '') ] ,
                                    \ 'airline_c': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , get(a:sect3 , 4 , '') ] ,
                                    \ }
                            
                              if a:0 > 0
                                call extend(palette, {
                                      \ 'airline_x': [ a:1[0] , a:1[1] , a:1[2] , a:1[3] , get(a:1 , 4 , '' ) ] ,
                                      \ 'airline_y': [ a:2[0] , a:2[1] , a:2[2] , a:2[3] , get(a:2 , 4 , '' ) ] ,
                                      \ 'airline_z': [ a:3[0] , a:3[1] , a:3[2] , a:3[3] , get(a:3 , 4 , '' ) ] ,
                                      \ })
                              else
                                call extend(palette, {
                                      \ 'airline_x': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , '' ] ,
                                      \ 'airline_y': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , '' ] ,
                                      \ 'airline_z': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , '' ] ,
                                      \ })
                              endif
                            
                              return palette
                            endfunction
                            
    1              0.000002 function! airline#themes#get_highlight(group, ...)
                              return call('airline#highlighter#get_highlight', [a:group] + a:000)
                            endfunction
                            
    1              0.000002 function! airline#themes#get_highlight2(fg, bg, ...)
                              return call('airline#highlighter#get_highlight2', [a:fg, a:bg] + a:000)
                            endfunction
                            
    1              0.000002 function! airline#themes#patch(palette)
                              for mode in keys(a:palette)
                                if !has_key(a:palette[mode], 'airline_warning')
                                  let a:palette[mode]['airline_warning'] = [ '#000000', '#df5f00', 232, 166 ]
                                endif
                                if !has_key(a:palette[mode], 'airline_error')
                                  let a:palette[mode]['airline_error'] = [ '#000000', '#990000', 232, 160 ]
                                endif
                              endfor
                            
                              let a:palette.accents = get(a:palette, 'accents', {})
                              let a:palette.accents.bold = [ '', '', '', '', 'bold' ]
                              let a:palette.accents.italic = [ '', '', '', '', 'italic' ]
                            
                              if !has_key(a:palette.accents, 'red')
                                let a:palette.accents.red = [ '#ff0000' , '' , 160 , '' ]
                              endif
                              if !has_key(a:palette.accents, 'green')
                                let a:palette.accents.green = [ '#008700' , '' , 22  , '' ]
                              endif
                              if !has_key(a:palette.accents, 'blue')
                                let a:palette.accents.blue = [ '#005fff' , '' , 27  , '' ]
                              endif
                              if !has_key(a:palette.accents, 'yellow')
                                let a:palette.accents.yellow = [ '#dfff00' , '' , 190 , '' ]
                              endif
                              if !has_key(a:palette.accents, 'orange')
                                let a:palette.accents.orange = [ '#df5f00' , '' , 166 , '' ]
                              endif
                              if !has_key(a:palette.accents, 'purple')
                                let a:palette.accents.purple = [ '#af00df' , '' , 128 , '' ]
                              endif
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/util.vim
Sourced 1 time
Total time:   0.000068
 Self time:   0.000065

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1   0.000008   0.000005 call airline#init#bootstrap()
    1              0.000002 let s:spc = g:airline_symbols.space
                            
    1              0.000003 function! airline#util#wrap(text, minwidth)
                              if a:minwidth > 0 && winwidth(0) < a:minwidth
                                return ''
                              endif
                              return a:text
                            endfunction
                            
    1              0.000002 function! airline#util#append(text, minwidth)
                              if a:minwidth > 0 && winwidth(0) < a:minwidth
                                return ''
                              endif
                              let prefix = s:spc == "\ua0" ? s:spc : s:spc.s:spc
                              return empty(a:text) ? '' : prefix.g:airline_left_alt_sep.s:spc.a:text
                            endfunction
                            
    1              0.000002 function! airline#util#prepend(text, minwidth)
                              if a:minwidth > 0 && winwidth(0) < a:minwidth
                                return ''
                              endif
                              return empty(a:text) ? '' : a:text.s:spc.g:airline_right_alt_sep.s:spc
                            endfunction
                            
    1              0.000001 if v:version >= 704
    1              0.000002   function! airline#util#getwinvar(winnr, key, def)
                                return getwinvar(a:winnr, a:key, a:def)
                              endfunction
    1              0.000002 else
                              function! airline#util#getwinvar(winnr, key, def)
                                let winvals = getwinvar(a:winnr, '')
                                return get(winvals, a:key, a:def)
                              endfunction
                            endif
                            
    1              0.000001 if v:version >= 704
    1              0.000002   function! airline#util#exec_funcrefs(list, ...)
                                for Fn in a:list
                                  let code = call(Fn, a:000)
                                  if code != 0
                                    return code
                                  endif
                                endfor
                                return 0
                              endfunction
    1              0.000001 else
                              function! airline#util#exec_funcrefs(list, ...)
                                " for 7.2; we cannot iterate the list, hence why we use range()
                                " for 7.3-[97, 328]; we cannot reuse the variable, hence the {}
                                for i in range(0, len(a:list) - 1)
                                  let Fn{i} = a:list[i]
                                  let code = call(Fn{i}, a:000)
                                  if code != 0
                                    return code
                                  endif
                                endfor
                                return 0
                              endfunction
                            endif
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/builder.vim
Sourced 1 time
Total time:   0.000102
 Self time:   0.000102

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000003 let s:prototype = {}
                            
    1              0.000002 function! s:prototype.split(...)
                              call add(self._sections, ['|', a:0 ? a:1 : '%='])
                            endfunction
                            
    1              0.000002 function! s:prototype.add_section_spaced(group, contents)
                              call self.add_section(a:group, (g:airline_symbols.space).a:contents.(g:airline_symbols.space))
                            endfunction
                            
    1              0.000001 function! s:prototype.add_section(group, contents)
                              call add(self._sections, [a:group, a:contents])
                            endfunction
                            
    1              0.000001 function! s:prototype.add_raw(text)
                              call add(self._sections, ['', a:text])
                            endfunction
                            
    1              0.000002 function! s:get_prev_group(sections, i)
                              let x = a:i - 1
                              while x >= 0
                                let group = a:sections[x][0]
                                if group != '' && group != '|'
                                  return group
                                endif
                                let x = x - 1
                              endwhile
                              return ''
                            endfunction
                            
    1              0.000002 function! s:prototype.build()
                              let side = 1
                              let line = ''
                              let i = 0
                              let length = len(self._sections)
                              let split = 0
                            
                              while i < length
                                let section = self._sections[i]
                                let group = section[0]
                                let contents = section[1]
                                let prev_group = s:get_prev_group(self._sections, i)
                            
                                if group == ''
                                  let line .= contents
                                elseif group == '|'
                                  let side = 0
                                  let line .= contents
                                  let split = 1
                                else
                                  if prev_group == ''
                                    let line .= '%#'.group.'#'
                                  elseif split
                                    let line .= s:get_transitioned_seperator(self, prev_group, group, side)
                                    let split = 0
                                  else
                                    let line .= s:get_seperator(self, prev_group, group, side)
                                  endif
                                  let line .= s:get_accented_line(self, group, contents)
                                endif
                            
                                let i = i + 1
                              endwhile
                            
                              if !self._context.active
                                let line = substitute(line, '%#.\{-}\ze#', '\0_inactive', 'g')
                              endif
                              return line
                            endfunction
                            
    1              0.000002 function! s:should_change_group(group1, group2)
                              if a:group1 == a:group2
                                return 0
                              endif
                              let color1 = airline#highlighter#get_highlight(a:group1)
                              let color2 = airline#highlighter#get_highlight(a:group2)
                              if g:airline_gui_mode ==# 'gui'
                                return color1[1] != color2[1] || color1[0] != color2[0]
                              else
                                return color1[3] != color2[3] || color1[2] != color2[2]
                              endif
                            endfunction
                            
    1              0.000002 function! s:get_transitioned_seperator(self, prev_group, group, side)
                              let line = ''
                              call airline#highlighter#add_separator(a:prev_group, a:group, a:side)
                              let line .= '%#'.a:prev_group.'_to_'.a:group.'#'
                              let line .= a:side ? a:self._context.left_sep : a:self._context.right_sep
                              let line .= '%#'.a:group.'#'
                              return line
                            endfunction
                            
    1              0.000002 function! s:get_seperator(self, prev_group, group, side)
                              if s:should_change_group(a:prev_group, a:group)
                                return s:get_transitioned_seperator(a:self, a:prev_group, a:group, a:side)
                              else
                                return a:side ? a:self._context.left_alt_sep : a:self._context.right_alt_sep
                              endif
                            endfunction
                            
    1              0.000002 function! s:get_accented_line(self, group, contents)
                              if a:self._context.active
                                let contents = []
                                let content_parts = split(a:contents, '__accent')
                                for cpart in content_parts
                                  let accent = matchstr(cpart, '_\zs[^#]*\ze')
                                  call add(contents, cpart)
                                endfor
                                let line = join(contents, a:group)
                                let line = substitute(line, '__restore__', a:group, 'g')
                              else
                                let line = substitute(a:contents, '%#__accent[^#]*#', '', 'g')
                                let line = substitute(line, '%#__restore__#', '', 'g')
                              endif
                              return line
                            endfunction
                            
    1              0.000002 function! airline#builder#new(context)
                              let builder = copy(s:prototype)
                              let builder._context = a:context
                              let builder._sections = []
                            
                              call extend(builder._context, {
                                    \ 'left_sep': g:airline_left_sep,
                                    \ 'left_alt_sep': g:airline_left_alt_sep,
                                    \ 'right_sep': g:airline_right_sep,
                                    \ 'right_alt_sep': g:airline_right_alt_sep,
                                    \ }, 'keep')
                              return builder
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/airline/extensions/default.vim
Sourced 1 time
Total time:   0.000087
 Self time:   0.000087

count  total (s)   self (s)
                            " MIT License. Copyright (c) 2013-2016 Bailey Ling.
                            " vim: et ts=2 sts=2 sw=2
                            
    1              0.000005 let s:section_use_groups     = get(g:, 'airline#extensions#default#section_use_groupitems', 1)
    1              0.000010 let s:section_truncate_width = get(g:, 'airline#extensions#default#section_truncate_width', {
                                  \ 'b': 79,
                                  \ 'x': 60,
                                  \ 'y': 88,
                                  \ 'z': 45,
                                  \ 'warning': 80,
                                  \ 'error': 80,
                                  \ })
    1              0.000006 let s:layout = get(g:, 'airline#extensions#default#layout', [
                                  \ [ 'a', 'b', 'c' ],
                                  \ [ 'x', 'y', 'z', 'warning', 'error' ]
                                  \ ])
                            
    1              0.000003 function! s:get_section(winnr, key, ...)
                              if has_key(s:section_truncate_width, a:key)
                                if winwidth(a:winnr) < s:section_truncate_width[a:key]
                                  return ''
                                endif
                              endif
                              let spc = g:airline_symbols.space
                              let text = airline#util#getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
                              let [prefix, suffix] = [get(a:000, 0, '%('.spc), get(a:000, 1, spc.'%)')]
                              return empty(text) ? '' : prefix.text.suffix
                            endfunction
                            
    1              0.000002 function! s:build_sections(builder, context, keys)
                              for key in a:keys
                                if (key == 'warning' || key == 'error') && !a:context.active
                                  continue
                                endif
                                call s:add_section(a:builder, a:context, key)
                              endfor
                            endfunction
                            
                            " There still is a highlighting bug when using groups %(%) in the statusline,
                            " deactivate it, until this is properly fixed:
                            " https://groups.google.com/d/msg/vim_dev/sb1jmVirXPU/mPhvDnZ-CwAJ
    1              0.000003 if s:section_use_groups && (v:version >= 704 || (v:version >= 703 && has('patch81')))
    1              0.000002   function s:add_section(builder, context, key)
                                " i have no idea why the warning section needs special treatment, but it's
                                " needed to prevent separators from showing up
                                if ((a:key == 'error' || a:key == 'warning') && empty(s:get_section(a:context.winnr, a:key)))
                                  return
                                endif
                                if (a:key == 'warning' || a:key == 'error')
                                  call a:builder.add_raw('%(')
                                endif
                                call a:builder.add_section('airline_'.a:key, s:get_section(a:context.winnr, a:key))
                                if (a:key == 'warning' || a:key == 'error')
                                  call a:builder.add_raw('%)')
                                endif
                              endfunction
    1              0.000001 else
                              " older version don't like the use of %(%)
                              function s:add_section(builder, context, key)
                                if ((a:key == 'error' || a:key == 'warning') && empty(s:get_section(a:context.winnr, a:key)))
                                  return
                                endif
                                if a:key == 'warning'
                                  call a:builder.add_raw('%#airline_warning#'.s:get_section(a:context.winnr, a:key))
                                elseif a:key == 'error'
                                  call a:builder.add_raw('%#airline_error#'.s:get_section(a:context.winnr, a:key))
                                else
                                  call a:builder.add_section('airline_'.a:key, s:get_section(a:context.winnr, a:key))
                                endif
                              endfunction
                            endif
                            
    1              0.000003 function! airline#extensions#default#apply(builder, context)
                              let winnr = a:context.winnr
                              let active = a:context.active
                            
                              if airline#util#getwinvar(winnr, 'airline_render_left', active || (!active && !g:airline_inactive_collapse))
                                call s:build_sections(a:builder, a:context, s:layout[0])
                              else
                                let text = s:get_section(winnr, 'c')
                                if empty(text)
                                  let text = ' %f%m '
                                endif
                                call a:builder.add_section('airline_c'.(a:context.bufnr), text)
                              endif
                            
                              call a:builder.split(s:get_section(winnr, 'gutter', '', ''))
                            
                              if airline#util#getwinvar(winnr, 'airline_render_right', 1)
                                call s:build_sections(a:builder, a:context, s:layout[1])
                              endif
                            
                              return 1
                            endfunction
                            

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/neomake.vim
Sourced 1 time
Total time:   0.000460
 Self time:   0.000460

count  total (s)   self (s)
                            " vim: ts=4 sw=4 et
    1              0.000005 scriptencoding utf-8
                            
    1              0.000002 let s:make_id = 1
    1              0.000001 let s:jobs = {}
    1              0.000002 let s:jobs_by_maker = {}
    1              0.000002 let s:job_output_by_buffer = {}
    1              0.000004 let s:current_errors = {
                                \ 'project': {},
                                \ 'file': {}
                                \ }
    1              0.000004 let s:need_errors_cleaning = {
                                \ 'project': 1,
                                \ 'file': {}
                                \ }
                            
    1              0.000003 function! neomake#ListJobs() abort
                                call neomake#utils#DebugMessage('call neomake#ListJobs()')
                                for jobinfo in values(s:jobs)
                                    echom jobinfo.id.' '.jobinfo.name
                                endfor
                            endfunction
                            
    1              0.000002 function! neomake#CancelJob(job_id) abort
                                if !has_key(s:jobs, a:job_id)
                                    return
                                endif
                                call jobstop(a:job_id)
                            endfunction
                            
    1              0.000002 function! s:JobStart(make_id, exe, ...) abort
                                let argv = [a:exe]
                                let has_args = a:0 && type(a:1) == type([])
                                if has('nvim')
                                    if has_args
                                        let argv = argv + a:1
                                    endif
                                    call neomake#utils#LoudMessage('Starting: '.join(argv, ' '))
                                    let opts = {
                                        \ 'on_stdout': function('neomake#MakeHandler'),
                                        \ 'on_stderr': function('neomake#MakeHandler'),
                                        \ 'on_exit': function('neomake#MakeHandler')
                                        \ }
                                    return jobstart(argv, opts)
                                else
                                    if has_args
                                        if neomake#utils#IsRunningWindows()
                                            let program = a:exe.' '.join(map(a:1, 'v:val'))
                                        else
                                            let program = a:exe.' '.join(map(a:1, 'shellescape(v:val)'))
                                        endif
                                    else
                                        let program = a:exe
                                    endif
                                    call neomake#MakeHandler(a:make_id, split(system(program), '\r\?\n', 1), 'stdout')
                                    call neomake#MakeHandler(a:make_id, v:shell_error, 'exit')
                                    return 0
                                endif
                            endfunction
                            
    1              0.000002 function! s:GetMakerKey(maker) abort
                                return has_key(a:maker, 'name') ? a:maker.name.' ft='.a:maker.ft : 'makeprg'
                            endfunction
                            
    1              0.000002 function! neomake#MakeJob(maker) abort
                                let make_id = s:make_id
                                let s:make_id += 1
                                let jobinfo = {
                                    \ 'name': 'neomake_'.make_id,
                                    \ 'winnr': winnr(),
                                    \ 'bufnr': bufnr('%'),
                                    \ }
                                if !has('nvim')
                                    let jobinfo.id = make_id
                                    " Assign this before neomake#MakeHandler gets run synchronously
                                    let s:jobs[make_id] = jobinfo
                                endif
                                let jobinfo.maker = a:maker
                            
                                let args = a:maker.args
                                let append_file = a:maker.file_mode && index(args, '%:p') <= 0 && get(a:maker, 'append_file', 1)
                                if append_file
                                    call add(args, '%:p')
                                endif
                            
                                if neomake#utils#IsRunningWindows()
                                    " Don't expand &shellcmdflag argument of cmd.exe
                                    call map(args, 'v:val !=? &shellcmdflag ? expand(v:val) : v:val')
                                else
                                    call map(args, 'expand(v:val)')
                                endif
                            
                                if has_key(a:maker, 'cwd')
                                    let old_wd = getcwd()
                                    let cwd = expand(a:maker.cwd, 1)
                                    exe 'cd' fnameescape(cwd)
                                endif
                            
                                let job = s:JobStart(make_id, a:maker.exe, args)
                                let jobinfo.start = localtime()
                                let jobinfo.last_register = 0
                            
                                " Async setup that only affects neovim
                                if has('nvim')
                                    if job == 0
                                        throw 'Job table is full or invalid arguments given'
                                    elseif job == -1
                                        throw 'Non executable given'
                                    endif
                            
                                    let jobinfo.id = job
                                    let s:jobs[job] = jobinfo
                                    let maker_key = s:GetMakerKey(a:maker)
                                    let s:jobs_by_maker[maker_key] = jobinfo
                                endif
                            
                                if has_key(a:maker, 'cwd')
                                    exe 'cd' fnameescape(old_wd)
                                endif
                            
                                return jobinfo.id
                            endfunction
                            
    1              0.000002 function! neomake#GetMaker(name_or_maker, ...) abort
                                if a:0
                                    let real_ft = a:1
                                    let fts = neomake#utils#GetSortedFiletypes(real_ft)
                                else
                                    let fts = []
                                endif
                                if type(a:name_or_maker) == type({})
                                    let maker = a:name_or_maker
                                else
                                    if a:name_or_maker ==# 'makeprg'
                                        let maker = neomake#utils#MakerFromCommand(&shell, &makeprg)
                                    elseif len(fts)
                                        for ft in fts
                                            let maker = get(g:, 'neomake_'.ft.'_'.a:name_or_maker.'_maker')
                                            if type(maker) == type({})
                                                break
                                            endif
                                        endfor
                                    else
                                        let maker = get(g:, 'neomake_'.a:name_or_maker.'_maker')
                                    endif
                                    if type(maker) == type(0)
                                        unlet maker
                                        if len(fts)
                                            for ft in fts
                                                try
                                                    let maker = eval('neomake#makers#ft#'.ft.'#'.a:name_or_maker.'()')
                                                    break
                                                catch /^Vim\%((\a\+)\)\=:E117/
                                                endtry
                                            endfor
                                        else
                                            try
                                                let maker = eval('neomake#makers#'.a:name_or_maker.'#'.a:name_or_maker.'()')
                                            catch /^Vim\%((\a\+)\)\=:E117/
                                                let maker = {}
                                            endtry
                                        endif
                                    endif
                                endif
                                let maker = deepcopy(maker)
                                if !has_key(maker, 'name')
                                    let maker.name = a:name_or_maker
                                endif
                                let defaults = {
                                    \ 'exe': maker.name,
                                    \ 'args': [],
                                    \ 'errorformat': &errorformat,
                                    \ 'buffer_output': 0,
                                    \ 'remove_invalid_entries': 1
                                    \ }
                                for key in keys(defaults)
                                    if len(fts)
                                        for ft in fts
                                            let config_var = 'neomake_'.ft.'_'.maker.name.'_'.key
                                            if has_key(g:, config_var) || has_key(b:, config_var)
                                                break
                                            endif
                                        endfor
                                    else
                                        let config_var = 'neomake_'.maker.name.'_'.key
                                    endif
                                    if has_key(b:, config_var)
                                        let maker[key] = copy(get(b:, config_var))
                                    elseif has_key(g:, config_var)
                                        let maker[key] = copy(get(g:, config_var))
                                    elseif !has_key(maker, key)
                                        let maker[key] = defaults[key]
                                    endif
                                endfor
                                let maker.ft = real_ft
                                " Only relevant if file_mode is used
                                let maker.winnr = winnr()
                                return maker
                            endfunction
                            
    1              0.000002 function! neomake#GetEnabledMakers(...) abort
                                if !a:0 || type(a:1) !=# type('')
                                    " If we have no filetype, our job isn't complicated.
                                    return get(g:, 'neomake_enabled_makers', [])
                                endif
                            
                                " If a filetype was passed, get the makers that are enabled for each of
                                " the filetypes represented.
                                let union = {}
                                let fts = neomake#utils#GetSortedFiletypes(a:1)
                                for ft in fts
                                    let ft = substitute(ft, '\W', '_', 'g')
                                    let varname = 'g:neomake_'.ft.'_enabled_makers'
                                    let fnname = 'neomake#makers#ft#'.ft.'#EnabledMakers'
                                    if exists(varname)
                                        let enabled_makers = eval(varname)
                                    else
                                        try
                                            let default_makers = eval(fnname . '()')
                                        catch /^Vim\%((\a\+)\)\=:E117/
                                            let default_makers = []
                                        endtry
                                        let enabled_makers = neomake#utils#AvailableMakers(ft, default_makers)
                                    endif
                                    for maker_name in enabled_makers
                                        let union[maker_name] = get(union, maker_name, 0) + 1
                                    endfor
                                endfor
                            
                                let l = len(fts)
                                return filter(keys(union), 'union[v:val] ==# l')
                            endfunction
                            
    1              0.000002 function! s:Make(options) abort
                                call neomake#signs#DefineSigns()
                                call neomake#statusline#ResetCounts()
                            
                                let ft = get(a:options, 'ft', '')
                                let file_mode = get(a:options, 'file_mode')
                            
                                let enabled_makers = get(a:options, 'enabled_makers', [])
                                if !len(enabled_makers)
                                    if file_mode
                                        call neomake#utils#DebugMessage('Nothing to make: no enabled makers')
                                        return
                                    else
                                        let enabled_makers = ['makeprg']
                                    endif
                                endif
                            
                                if file_mode
                                    lgetexpr ''
                                else
                                    cgetexpr ''
                                endif
                            
                                if !get(a:options, 'continuation')
                                    " Only do this if we have one or more enabled makers
                                    if file_mode
                                        let buf = bufnr('%')
                                        let win = winnr()
                                        call neomake#signs#ResetFile(buf)
                                        let s:need_errors_cleaning['file'][buf] = 1
                                        let s:loclist_nr = get(s:, 'loclist_nr', {})
                                        let s:loclist_nr[win] = 0
                                    else
                                        call neomake#signs#ResetProject()
                                        let s:need_errors_cleaning['project'] = 1
                                        let s:qflist_nr = 0
                                    endif
                                endif
                            
                                let serialize = get(g:, 'neomake_serialize')
                                let job_ids = []
                                for name in enabled_makers
                                    let maker = neomake#GetMaker(name, ft)
                                    let maker.file_mode = file_mode
                                    let maker_key = s:GetMakerKey(maker)
                                    if has_key(s:jobs_by_maker, maker_key)
                                        let jobinfo = s:jobs_by_maker[maker_key]
                                        let jobinfo.maker.next = copy(a:options)
                                        try
                                            call jobstop(jobinfo.id)
                                        catch /^Vim\%((\a\+)\)\=:E900/
                                            " Ignore invalid job id errors. Happens when the job is done,
                                            " but on_exit hasn't been called yet.
                                        endtry
                                        break
                                    endif
                                    if serialize && len(enabled_makers) > 1
                                        let next_opts = copy(a:options)
                                        let next_opts.enabled_makers = enabled_makers[1:]
                                        let next_opts.continuation = 1
                                        let maker.next = next_opts
                                    endif
                                    if has_key(a:options, 'exit_callback')
                                        let maker.exit_callback = a:options.exit_callback
                                    endif
                                    let job_id = neomake#MakeJob(maker)
                                    call add(job_ids, job_id)
                                    " If we are serializing makers, stop after the first one. The
                                    " remaining makers will be processed in turn when this one is done.
                                    if serialize
                                        break
                                    endif
                                endfor
                                return job_ids
                            endfunction
                            
    1              0.000002 function! s:AddExprCallback(maker) abort
                                let file_mode = get(a:maker, 'file_mode')
                                let place_signs = get(g:, 'neomake_place_signs', 1)
                                let list = file_mode ? getloclist(a:maker.winnr) : getqflist()
                                let list_modified = 0
                                let index = file_mode ? s:loclist_nr[a:maker.winnr] : s:qflist_nr
                                let maker_type = file_mode ? 'file' : 'project'
                            
                                while index < len(list)
                                    let entry = list[index]
                                    let entry.maker_name = has_key(a:maker, 'name') ? a:maker.name : 'makeprg'
                                    let index += 1
                            
                                    if has_key(a:maker, 'postprocess')
                                        let Func = a:maker.postprocess
                                        call Func(entry)
                                    end
                            
                                    if !entry.valid
                                        if a:maker.remove_invalid_entries
                                            let index -= 1
                                            call remove(list, index)
                                            let list_modified = 1
                                        endif
                                        continue
                                    endif
                            
                                    if !file_mode
                                        call neomake#statusline#AddQflistCount(entry)
                                    endif
                            
                                    if !entry.bufnr
                                        continue
                                    endif
                            
                                    if file_mode
                                        call neomake#statusline#AddLoclistCount(
                                            \ a:maker.winnr, entry.bufnr, entry)
                                    endif
                            
                                    " On the first valid error identified by a maker,
                                    " clear the existing signs
                                    if file_mode
                                        call neomake#CleanOldFileSignsAndErrors(entry.bufnr)
                                    else
                                        call neomake#CleanOldProjectSignsAndErrors()
                                    endif
                            
                                    " Track all errors by buffer and line
                                    let s:current_errors[maker_type][entry.bufnr] = get(s:current_errors[maker_type], entry.bufnr, {})
                                    let s:current_errors[maker_type][entry.bufnr][entry.lnum] = get(
                                        \ s:current_errors[maker_type][entry.bufnr], entry.lnum, [])
                                    call add(s:current_errors[maker_type][entry.bufnr][entry.lnum], entry)
                            
                                    if place_signs
                                        call neomake#signs#RegisterSign(entry, maker_type)
                                    endif
                                endwhile
                            
                                if list_modified
                                    if file_mode
                                        call setloclist(a:maker.winnr, list, 'r')
                                    else
                                        call setqflist(list, 'r')
                                    endif
                                endif
                            
                                if file_mode
                                    let s:loclist_nr[a:maker.winnr] = index
                                else
                                    let s:qflist_nr = index
                                endif
                            endfunction
                            
    1              0.000002 function! s:CleanJobinfo(jobinfo) abort
                                let maker = a:jobinfo.maker
                                let maker_key = s:GetMakerKey(maker)
                                if has_key(s:jobs_by_maker, maker_key)
                                    unlet s:jobs_by_maker[maker_key]
                                endif
                                call remove(s:jobs, a:jobinfo.id)
                            endfunction
                            
    1              0.000002 function! s:ProcessJobOutput(maker, lines) abort
                                call neomake#utils#DebugMessage(get(a:maker, 'name', 'makeprg').' processing '.
                                                                \ len(a:lines).' lines of output')
                                if len(a:lines) > 0
                                    let olderrformat = &errorformat
                                    let &errorformat = a:maker.errorformat
                            
                                    if get(a:maker, 'file_mode')
                                        laddexpr a:lines
                                    else
                                        caddexpr a:lines
                                    endif
                                    call s:AddExprCallback(a:maker)
                            
                                    let &errorformat = olderrformat
                                endif
                            endfunction
                            
    1              0.000002 function! neomake#ProcessCurrentBuffer() abort
                                let buf = bufnr('%')
                                if has_key(s:job_output_by_buffer, buf)
                                    for output in s:job_output_by_buffer[buf]
                                        call s:ProcessJobOutput(output.maker, output.lines)
                                    endfor
                                    unlet s:job_output_by_buffer[buf]
                                endif
                                call neomake#signs#PlaceVisibleSigns()
                            endfunction
                            
    1              0.000002 function! s:RegisterJobOutput(jobinfo, maker, lines) abort
                                if get(a:maker, 'file_mode')
                                    let output = {
                                        \ 'maker': a:maker,
                                        \ 'lines': a:lines
                                        \ }
                                    if has_key(s:job_output_by_buffer, a:jobinfo.bufnr)
                                        call add(s:job_output_by_buffer[a:jobinfo.bufnr], output)
                                    else
                                        let s:job_output_by_buffer[a:jobinfo.bufnr] = [output]
                                    endif
                            
                                    " Process the buffer on demand if we can
                                    if bufnr('%') ==# a:jobinfo.bufnr
                                        call neomake#ProcessCurrentBuffer()
                                    endif
                                    if &ft ==# 'qf'
                                        " Process the previous window if we are in a qf window.
                                        wincmd p
                                        call neomake#ProcessCurrentBuffer()
                                        wincmd p
                                    endif
                                else
                                    call s:ProcessJobOutput(a:maker, a:lines)
                                endif
                            endfunction
                            
    1              0.000002 function! neomake#MakeHandler(job_id, data, event_type) abort
                                if !has_key(s:jobs, a:job_id)
                                    return
                                endif
                                let jobinfo = s:jobs[a:job_id]
                                let maker = jobinfo.maker
                                if index(['stdout', 'stderr'], a:event_type) >= 0
                                    let lines = a:data
                                    if has_key(maker, 'mapexpr')
                                        let lines = map(copy(lines), maker.mapexpr)
                                    endif
                            
                                    for line in lines
                                        call neomake#utils#DebugMessage(
                                            \ get(maker, 'name', 'makeprg').' '.a:event_type.': '.line)
                                    endfor
                                    call neomake#utils#DebugMessage(
                                        \ get(maker, 'name', 'makeprg').' '.a:event_type.' done.')
                            
                                    " Register job output. Buffer registering of output for long running
                                    " jobs.
                                    let last_event_type = get(jobinfo, 'event_type', a:event_type)
                                    let jobinfo.event_type = a:event_type
                                    if has_key(jobinfo, 'lines')
                                        " As per https://github.com/neovim/neovim/issues/3555
                                        let jobinfo.lines = jobinfo.lines[:-2]
                                                    \ + [jobinfo.lines[-1] . get(lines, 0, '')]
                                                    \ + lines[1:]
                                    else
                                        let jobinfo.lines = lines
                                    endif
                                    let now = localtime()
                                    if (!maker.buffer_output || last_event_type !=# a:event_type) ||
                                            \ (last_event_type !=# a:event_type ||
                                            \  now - jobinfo.start < 1 ||
                                            \  now - jobinfo.last_register > 3)
                                        call s:RegisterJobOutput(jobinfo, maker, jobinfo.lines)
                                        unlet jobinfo.lines
                                        let jobinfo.last_register = now
                                    endif
                                elseif a:event_type ==# 'exit'
                                    if has_key(jobinfo, 'lines')
                                        call s:RegisterJobOutput(jobinfo, maker, jobinfo.lines)
                                    endif
                                    " TODO This used to open up as the list was populated, but it caused
                                    " some issues with s:AddExprCallback.
                                    if get(g:, 'neomake_open_list')
                                        let height = get(g:, 'neomake_list_height', 10)
                                        let open_val = g:neomake_open_list
                                        let win_val = winnr()
                                        if get(maker, 'file_mode')
                                            exe "lwindow ".height
                                        else
                                            exe "cwindow ".height
                                        endif
                                        if open_val == 2 && win_val != winnr()
                                            wincmd p
                                        endif
                                    endif
                                    let status = a:data
                                    if has_key(maker, 'exit_callback')
                                        let callback_dict = { 'status': status,
                                                            \ 'name': maker.name,
                                                            \ 'has_next': has_key(maker, 'next') }
                                        if type(maker.exit_callback) == type('')
                                            let ExitCallback = function(maker.exit_callback)
                                        else
                                            let ExitCallback = maker.exit_callback
                                        endif
                                        try
                                            call ExitCallback(callback_dict)
                                        catch /^Vim\%((\a\+)\)\=:E117/
                                        endtry
                                    endif
                                    call s:CleanJobinfo(jobinfo)
                                    if has('nvim')
                                        " Only report completion for neovim, since it is asynchronous
                                        call neomake#utils#QuietMessage(get(maker, 'name', 'make').
                                                                      \ ' complete with exit code '.status)
                                    endif
                            
                                    " If signs were not cleared before this point, then the maker did not return
                                    " any errors, so all signs must be removed
                                    if maker.file_mode
                                        call neomake#CleanOldFileSignsAndErrors(jobinfo.bufnr)
                                    else
                                        call neomake#CleanOldProjectSignsAndErrors()
                                    endif
                            
                                    " Show the current line's error
                                    call neomake#CursorMoved()
                            
                                    if has_key(maker, 'next')
                                        let next_makers = '['.join(maker.next.enabled_makers, ', ').']'
                                        if get(g:, 'neomake_serialize_abort_on_error') && status !=# 0
                                            call neomake#utils#LoudMessage('Aborting next makers '.next_makers)
                                        else
                                            call neomake#utils#DebugMessage('next makers '.next_makers)
                                            call s:Make(maker.next)
                                        endif
                                    endif
                                endif
                            endfunction
                            
    1              0.000002 function! neomake#CleanOldProjectSignsAndErrors() abort
                                if s:need_errors_cleaning['project']
                                    for buf in keys(s:current_errors.project)
                                        unlet s:current_errors['project'][buf]
                                    endfor
                                    let s:need_errors_cleaning['project'] = 0
                                    call neomake#utils#DebugMessage("All project-level errors cleaned.")
                                endif
                                call neomake#signs#CleanAllOldSigns('project')
                            endfunction
                            
    1              0.000002 function! neomake#CleanOldFileSignsAndErrors(bufnr) abort
                                if get(s:need_errors_cleaning['file'], a:bufnr, 0)
                                    if has_key(s:current_errors['file'], a:bufnr)
                                        unlet s:current_errors['file'][a:bufnr]
                                    endif
                                    unlet s:need_errors_cleaning['file'][a:bufnr]
                                    call neomake#utils#DebugMessage("File-level errors cleaned in buffer ".a:bufnr)
                                endif
                                call neomake#signs#CleanOldSigns(a:bufnr, 'file')
                            endfunction
                            
    1              0.000002 function! neomake#CleanOldErrors(bufnr, type) abort
                            endfunction
                            
    1              0.000003 function! neomake#EchoCurrentError() abort
                                if !get(g:, 'neomake_echo_current_error', 1)
                                    return
                                endif
                            
                                if !empty(get(s:, 'neomake_last_echoed_error', {}))
                                    unlet s:neomake_last_echoed_error
                                    echon ''
                                endif
                            
                                let buf = bufnr('%')
                                let ln = line('.')
                                let ln_errors = []
                            
                                for maker_type in ['file', 'project']
                                    let buf_errors = get(s:current_errors[maker_type], buf, {})
                                    let ln_errors += get(buf_errors, ln, [])
                                endfor
                            
                                if empty(ln_errors)
                                    return
                                endif
                            
                                let s:neomake_last_echoed_error = ln_errors[0]
                                for error in ln_errors
                                    if error.type ==# 'E'
                                        let s:neomake_last_echoed_error = error
                                        break
                                    endif
                                endfor
                                let message = s:neomake_last_echoed_error.maker_name.': '.s:neomake_last_echoed_error.text
                                call neomake#utils#WideMessage(message)
                            endfunction
                            
    1              0.000002 function! neomake#CursorMoved() abort
                                call neomake#signs#PlaceVisibleSigns()
                                call neomake#EchoCurrentError()
                            endfunction
                            
    1              0.000002 function! neomake#CompleteMakers(ArgLead, CmdLine, CursorPos)
                                if a:ArgLead =~ '[^A-Za-z0-9]'
                                    return []
                                else
                                    return filter(neomake#GetEnabledMakers(&ft),
                                                \ "v:val =~? '^".a:ArgLead."'")
                                endif
                            endfunction
                            
    1              0.000002 function! neomake#Make(file_mode, enabled_makers, ...)
                                let options = a:0 ? { 'exit_callback': a:1 } : {}
                                if a:file_mode
                                    let options.enabled_makers = len(a:enabled_makers) ?
                                                \ a:enabled_makers :
                                                \ neomake#GetEnabledMakers(&ft)
                                    let options.ft = &ft
                                    let options.file_mode = 1
                                else
                                    let options.enabled_makers = len(a:enabled_makers) ?
                                                \ a:enabled_makers :
                                                \ neomake#GetEnabledMakers()
                                endif
                                return s:Make(options)
                            endfunction
                            
    1              0.000003 function! neomake#Sh(sh_command, ...)
                                let options = a:0 ? { 'exit_callback': a:1 } : {}
                                let custom_maker = neomake#utils#MakerFromCommand(&shell, a:sh_command)
                                let custom_maker.name = 'sh: '.a:sh_command
                                let custom_maker.remove_invalid_entries = 0
                                let options.enabled_makers =  [custom_maker]
                                return s:Make(options)[0]
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/neomake/signs.vim
Sourced 1 time
Total time:   0.000236
 Self time:   0.000214

count  total (s)   self (s)
                            " vim: ts=4 sw=4 et
                            
    1              0.000005 function! s:InitSigns() abort
                                let s:sign_queue = {
                                    \ 'project': {},
                                    \ 'file': {}
                                    \ }
                                let s:last_placed_signs = {
                                    \ 'project': {},
                                    \ 'file': {}
                                    \ }
                                let s:placed_signs = {
                                    \ 'project': {},
                                    \ 'file': {}
                                    \ }
                                let s:sign_queue = {
                                    \ 'project': {},
                                    \ 'file': {}
                                    \ }
                                let s:neomake_sign_id = {
                                    \ 'project': {},
                                    \ 'file': {}
                                    \ }
                            endfunction
    1   0.000029   0.000008 call s:InitSigns()
                            
                            " Reset signs placed by a :Neomake! call
                            " (resettting signs means the current signs will be deleted on the next call to ResetProject)
    1              0.000003 function! neomake#signs#ResetProject() abort
                                let s:sign_queue.project = {}
                                for buf in keys(s:placed_signs.project)
                                    call neomake#signs#CleanOldSigns(buf, 'project')
                                    call neomake#signs#Reset(buf, 'project')
                                endfor
                                let s:neomake_sign_id.project = {}
                            endfunction
                            
                            " Reset signs placed by a :Neomake call in a buffer
    1              0.000003 function! neomake#signs#ResetFile(bufnr) abort
                                let s:sign_queue.file[a:bufnr] = {}
                                call neomake#signs#CleanOldSigns(a:bufnr, 'file')
                                call neomake#signs#Reset(a:bufnr, 'file')
                                if has_key(s:neomake_sign_id.file, a:bufnr)
                                    unlet s:neomake_sign_id.file[a:bufnr]
                                endif
                            endfunction
                            
    1              0.000003 function! neomake#signs#Reset(bufnr, type) abort
                                if has_key(s:placed_signs[a:type], a:bufnr)
                                    let s:last_placed_signs[a:type][a:bufnr] = s:placed_signs[a:type][a:bufnr]
                                    unlet s:placed_signs[a:type][a:bufnr]
                                endif
                            endfunction
                            
                            " type may be either 'file' or 'project'
    1              0.000002 function! neomake#signs#RegisterSign(entry, type) abort
                                let s:sign_queue[a:type][a:entry.bufnr] = get(s:sign_queue[a:type], a:entry.bufnr, {})
                                let existing = get(s:sign_queue[a:type][a:entry.bufnr], a:entry.lnum, {})
                                if empty(existing) || a:entry.type ==# 'E' && existing.type !=# 'E'
                                    let s:sign_queue[a:type][a:entry.bufnr][a:entry.lnum] = a:entry
                                endif
                            endfunction
                            
                            " type may be either 'file' or 'project'
    1              0.000002 function! neomake#signs#PlaceSign(entry, type) abort
                                if a:entry.type ==? 'W'
                                    let sign_type = 'neomake_warn'
                                elseif a:entry.type ==? 'I'
                                    let sign_type = 'neomake_info'
                                elseif a:entry.type ==? 'M'
                                    let sign_type = 'neomake_msg'
                                else
                                    let sign_type = 'neomake_err'
                                endif
                            
                                let s:placed_signs[a:type][a:entry.bufnr] = get(s:placed_signs[a:type], a:entry.bufnr, {})
                                if !has_key(s:placed_signs[a:type][a:entry.bufnr], a:entry.lnum)
                                    let default = a:type ==# 'file' ? 5000 : 7000
                                    let sign_id = get(s:neomake_sign_id[a:type], a:entry.bufnr, default)
                                    let s:neomake_sign_id[a:type][a:entry.bufnr] = sign_id + 1
                                    let cmd = 'sign place '.sign_id.' line='.a:entry.lnum.
                                                                  \ ' name='.sign_type.
                                                                  \ ' buffer='.a:entry.bufnr
                                    let s:placed_signs[a:type][a:entry.bufnr][a:entry.lnum] = sign_id
                                elseif sign_type ==# 'neomake_err'
                                    " Upgrade this sign to an error
                                    let sign_id = s:placed_signs[a:type][a:entry.bufnr][a:entry.lnum]
                                    let cmd =  'sign place '.sign_id.' name='.sign_type.' buffer='.a:entry.bufnr
                                else
                                    let cmd = ''
                                endif
                            
                                if len(cmd)
                                    call neomake#utils#DebugMessage('Placing sign: '.cmd)
                                    exe cmd
                                endif
                            endfunction
                            
    1              0.000003 function! neomake#signs#CleanAllOldSigns(type) abort
                                call neomake#utils#DebugObject("Removing signs", s:last_placed_signs)
                                for buf in keys(s:last_placed_signs[a:type])
                                    call neomake#signs#CleanOldSigns(buf, a:type)
                                endfor
                            endfunction
                            
                            " type may be either 'file' or 'project'
    1              0.000002 function! neomake#signs#CleanOldSigns(bufnr, type) abort
                                if !has_key(s:last_placed_signs[a:type], a:bufnr)
                                    return
                                endif
                                call neomake#utils#DebugObject('Cleaning old signs in buffer '.a:bufnr.': ', s:last_placed_signs[a:type])
                                for ln in keys(s:last_placed_signs[a:type][a:bufnr])
                                    let cmd = 'sign unplace '.s:last_placed_signs[a:type][a:bufnr][ln].' buffer='.a:bufnr
                                    call neomake#utils#DebugMessage('Unplacing sign: '.cmd)
                                    exe cmd
                                endfor
                                unlet s:last_placed_signs[a:type][a:bufnr]
                            endfunction
                            
    1              0.000002 function! neomake#signs#PlaceVisibleSigns() abort
                                for type in ['file', 'project']
                                    let buf = bufnr('%')
                                    if !has_key(s:sign_queue[type], buf)
                                        continue
                                    endif
                                    let topline = line('w0')
                                    let botline = line('w$')
                                    for ln in range(topline, botline)
                                        if has_key(s:sign_queue[type][buf], ln)
                                            call neomake#signs#PlaceSign(s:sign_queue[type][buf][ln], type)
                                            unlet s:sign_queue[type][buf][ln]
                                        endif
                                    endfor
                                    if empty(s:sign_queue[type][buf])
                                        unlet s:sign_queue[type][buf]
                                    endif
                                endfor
                            endfunction
                            
    1              0.000005 exe 'sign define neomake_invisible'
                            
    1              0.000002 function! neomake#signs#RedefineSign(name, opts)
                                let sign_define = 'sign define '.a:name
                                for attr in keys(a:opts)
                                    let sign_define .= ' '.attr.'='.a:opts[attr]
                                endfor
                                exe sign_define
                            
                                for buf in keys(s:placed_signs)
                                    for ln in keys(s:placed_signs[buf])
                                        let sign_id = s:placed_signs[buf][ln]
                                        exe 'sign place '.sign_id.' name=neomake_invisible buffer='.buf
                                        exe 'sign place '.sign_id.' name='.a:name.' buffer='.buf
                                    endfor
                                endfor
                            endfunction
                            
    1              0.000002 function! neomake#signs#RedefineErrorSign(...)
                                let default_opts = {'text': '✖'}
                                let opts = {}
                                if a:0
                                    call extend(opts, a:1)
                                elseif exists('g:neomake_error_sign')
                                    call extend(opts, g:neomake_error_sign)
                                endif
                                call extend(opts, default_opts, 'keep')
                                call neomake#signs#RedefineSign('neomake_err', opts)
                            endfunction
                            
    1              0.000002 function! neomake#signs#RedefineWarningSign(...)
                                let default_opts = {'text': '⚠'}
                                let opts = {}
                                if a:0
                                    call extend(opts, a:1)
                                elseif exists('g:neomake_warning_sign')
                                    call extend(opts, g:neomake_warning_sign)
                                endif
                                call extend(opts, default_opts, 'keep')
                                call neomake#signs#RedefineSign('neomake_warn', opts)
                            endfunction
                            
    1              0.000002 function! neomake#signs#RedefineMessageSign(...)
                                let default_opts = {'text': '➤'}
                                let opts = {}
                                if a:0
                                    call extend(opts, a:1)
                                elseif exists('g:neomake_message_sign')
                                    call extend(opts, g:neomake_message_sign)
                                endif
                                call extend(opts, default_opts, 'keep')
                                call neomake#signs#RedefineSign('neomake_msg', opts)
                            endfunction
                            
    1              0.000002 function! neomake#signs#RedefineInformationalSign(...)
                                let default_opts = {'text': 'ℹ'}
                                let opts = {}
                                if a:0
                                    call extend(opts, a:1)
                                elseif exists('g:neomake_informational_sign')
                                    call extend(opts, g:neomake_informational_sign)
                                endif
                                call extend(opts, default_opts, 'keep')
                                call neomake#signs#RedefineSign('neomake_info', opts)
                            endfunction
                            
                            
    1              0.000002 let s:signs_defined = 0
    1              0.000002 function! neomake#signs#DefineSigns()
                                if !s:signs_defined
                                    let s:signs_defined = 1
                                    call neomake#signs#RedefineErrorSign()
                                    call neomake#signs#RedefineWarningSign()
                                    call neomake#signs#RedefineInformationalSign()
                                    call neomake#signs#RedefineMessageSign()
                                endif
                            endfunction

SCRIPT  /usr/local/share/nvim/runtime/autoload/provider/python3.vim
Sourced 1 time
Total time:   0.000237
 Self time:   0.000078

count  total (s)   self (s)
                            " The Python3 provider uses a Python3 host to emulate an environment for running
                            " python3 plugins. See ":help nvim-provider" for more information.
                            "
                            " Associating the plugin with the Python3 host is the first step because
                            " plugins will be passed as command-line arguments
                            
    1              0.000004 if exists('g:loaded_python3_provider')
                              finish
                            endif
    1              0.000002 let g:loaded_python3_provider = 1
                            
    1   0.000081   0.000007 let [s:prog, s:err] = provider#pythonx#Detect(3)
                            
    1              0.000003 function! provider#python3#Prog()
                              return s:prog
                            endfunction
                            
    1              0.000002 function! provider#python3#Error()
                              return s:err
                            endfunction
                            
    1              0.000002 if s:prog == ''
                              " Detection failed
                              finish
                            endif
                            
    1              0.000008 let s:plugin_path = expand('<sfile>:p:h').'/script_host.py'
                            
                            " The Python3 provider plugin will run in a separate instance of the Python3
                            " host.
    1   0.000023   0.000008 call remote#host#RegisterClone('legacy-python3-provider', 'python3')
    1   0.000077   0.000006 call remote#host#RegisterPlugin('legacy-python3-provider', s:plugin_path, [])
                            
    1              0.000003 function! provider#python3#Call(method, args)
                              if s:err != ''
                                return
                              endif
                              if !exists('s:host')
                                let s:rpcrequest = function('rpcrequest')
                            
                                " Ensure that we can load the Python3 host before bootstrapping
                                try
                                  let s:host = remote#host#Require('legacy-python3-provider')
                                catch
                                  let s:err = v:exception
                                  echohl WarningMsg
                                  echomsg v:exception
                                  echohl None
                                  return
                                endtry
                              endif
                              return call(s:rpcrequest, insert(insert(a:args, 'python_'.a:method), s:host))
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/gitgutter.vim
Sourced 1 time
Total time:   0.000176
 Self time:   0.000176

count  total (s)   self (s)
                            " Primary functions {{{
                            
    1              0.000004 function! gitgutter#all()
                              for buffer_id in tabpagebuflist()
                                let file = expand('#' . buffer_id . ':p')
                                if !empty(file)
                                  call gitgutter#process_buffer(buffer_id, 0)
                                endif
                              endfor
                            endfunction
                            
                            " bufnr: (integer) the buffer to process.
                            " realtime: (boolean) when truthy, do a realtime diff; otherwise do a disk-based diff.
    1              0.000003 function! gitgutter#process_buffer(bufnr, realtime)
                              call gitgutter#utility#set_buffer(a:bufnr)
                              if gitgutter#utility#is_active()
                                if g:gitgutter_sign_column_always
                                  call gitgutter#sign#add_dummy_sign()
                                endif
                                try
                                  if !a:realtime || gitgutter#utility#has_fresh_changes()
                                    let diff = gitgutter#diff#run_diff(a:realtime || gitgutter#utility#has_unsaved_changes(), 0)
                                    if diff != 'async'
                                      call gitgutter#handle_diff(diff)
                                    endif
                                  endif
                                catch /diff failed/
                                  call gitgutter#hunk#reset()
                                endtry
                              else
                                call gitgutter#hunk#reset()
                              endif
                            endfunction
                            
                            
    1              0.000002 function! gitgutter#handle_diff_job(job_id, data, event)
                              if a:event == 'stdout'
                                " a:data is a list
                                call gitgutter#utility#job_output_received(a:job_id, 'stdout')
                                call gitgutter#handle_diff(join(a:data,"\n")."\n")
                            
                              elseif a:event == 'exit'
                                " If the exit event is triggered without a preceding stdout event,
                                " the diff was empty.
                                if gitgutter#utility#is_pending_job(a:job_id)
                                  call gitgutter#handle_diff("")
                                  call gitgutter#utility#job_output_received(a:job_id, 'exit')
                                endif
                            
                              else
                                call gitgutter#hunk#reset()
                                call gitgutter#utility#job_output_received(a:job_id, 'stderr')
                            
                              endif
                            endfunction
                            
                            
    1              0.000002 function! gitgutter#handle_diff(diff)
                              call gitgutter#hunk#set_hunks(gitgutter#diff#parse_diff(a:diff))
                              let modified_lines = gitgutter#diff#process_hunks(gitgutter#hunk#hunks())
                            
                              if len(modified_lines) > g:gitgutter_max_signs
                                call gitgutter#utility#warn_once('exceeded maximum number of signs (configured by g:gitgutter_max_signs).', 'max_signs')
                                call gitgutter#sign#clear_signs()
                                return
                              endif
                            
                              if g:gitgutter_signs || g:gitgutter_highlight_lines
                                call gitgutter#sign#update_signs(modified_lines)
                              endif
                            
                              call gitgutter#utility#save_last_seen_change()
                            endfunction
                            
    1              0.000002 function! gitgutter#disable()
                              " get list of all buffers (across all tabs)
                              let buflist = []
                              for i in range(tabpagenr('$'))
                                call extend(buflist, tabpagebuflist(i + 1))
                              endfor
                            
                              for buffer_id in buflist
                                let file = expand('#' . buffer_id . ':p')
                                if !empty(file)
                                  call gitgutter#utility#set_buffer(buffer_id)
                                  call gitgutter#sign#clear_signs()
                                  call gitgutter#sign#remove_dummy_sign(1)
                                  call gitgutter#hunk#reset()
                                endif
                              endfor
                            
                              let g:gitgutter_enabled = 0
                            endfunction
                            
    1              0.000002 function! gitgutter#enable()
                              let g:gitgutter_enabled = 1
                              call gitgutter#all()
                            endfunction
                            
    1              0.000001 function! gitgutter#toggle()
                              if g:gitgutter_enabled
                                call gitgutter#disable()
                              else
                                call gitgutter#enable()
                              endif
                            endfunction
                            
                            " }}}
                            
                            " Line highlights {{{
                            
    1              0.000002 function! gitgutter#line_highlights_disable()
                              let g:gitgutter_highlight_lines = 0
                              call gitgutter#highlight#define_sign_line_highlights()
                            
                              if !g:gitgutter_signs
                                call gitgutter#sign#clear_signs()
                                call gitgutter#sign#remove_dummy_sign(0)
                              endif
                            
                              redraw!
                            endfunction
                            
    1              0.000002 function! gitgutter#line_highlights_enable()
                              let old_highlight_lines = g:gitgutter_highlight_lines
                            
                              let g:gitgutter_highlight_lines = 1
                              call gitgutter#highlight#define_sign_line_highlights()
                            
                              if !old_highlight_lines && !g:gitgutter_signs
                                call gitgutter#all()
                              endif
                            
                              redraw!
                            endfunction
                            
    1              0.000002 function! gitgutter#line_highlights_toggle()
                              if g:gitgutter_highlight_lines
                                call gitgutter#line_highlights_disable()
                              else
                                call gitgutter#line_highlights_enable()
                              endif
                            endfunction
                            
                            " }}}
                            
                            " Signs {{{
                            
    1              0.000001 function! gitgutter#signs_enable()
                              let old_signs = g:gitgutter_signs
                            
                              let g:gitgutter_signs = 1
                              call gitgutter#highlight#define_sign_text_highlights()
                            
                              if !old_signs && !g:gitgutter_highlight_lines
                                call gitgutter#all()
                              endif
                            endfunction
                            
    1              0.000004 function! gitgutter#signs_disable()
                              let g:gitgutter_signs = 0
                              call gitgutter#highlight#define_sign_text_highlights()
                            
                              if !g:gitgutter_highlight_lines
                                call gitgutter#sign#clear_signs()
                                call gitgutter#sign#remove_dummy_sign(0)
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#signs_toggle()
                              if g:gitgutter_signs
                                call gitgutter#signs_disable()
                              else
                                call gitgutter#signs_enable()
                              endif
                            endfunction
                            
                            " }}}
                            
                            " Hunks {{{
                            
    1              0.000002 function! gitgutter#stage_hunk()
                              if gitgutter#utility#is_active()
                                " Ensure the working copy of the file is up to date.
                                " It doesn't make sense to stage a hunk otherwise.
                                noautocmd silent write
                                let diff = gitgutter#diff#run_diff(0, 1)
                                call gitgutter#handle_diff(diff)
                            
                                if empty(gitgutter#hunk#current_hunk())
                                  call gitgutter#utility#warn('cursor is not in a hunk')
                                else
                                  let diff_for_hunk = gitgutter#diff#generate_diff_for_hunk(diff, 'stage')
                                  call gitgutter#utility#system(gitgutter#utility#command_in_directory_of_file('git apply --cached --unidiff-zero - '), diff_for_hunk)
                            
                                  " refresh gitgutter's view of buffer
                                  silent execute "GitGutter"
                                endif
                            
                                silent! call repeat#set("\<Plug>GitGutterStageHunk", -1)<CR>
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#revert_hunk()
                              if gitgutter#utility#is_active()
                                " Ensure the working copy of the file is up to date.
                                " It doesn't make sense to stage a hunk otherwise.
                                noautocmd silent write
                                let diff = gitgutter#diff#run_diff(0, 1)
                                call gitgutter#handle_diff(diff)
                            
                                if empty(gitgutter#hunk#current_hunk())
                                  call gitgutter#utility#warn('cursor is not in a hunk')
                                else
                                  let diff_for_hunk = gitgutter#diff#generate_diff_for_hunk(diff, 'revert')
                                  call gitgutter#utility#system(gitgutter#utility#command_in_directory_of_file('git apply --reverse --unidiff-zero - '), diff_for_hunk)
                            
                                  " reload file
                                  silent edit
                                endif
                            
                                silent! call repeat#set("\<Plug>GitGutterRevertHunk", -1)<CR>
                              endif
                            endfunction
                            
    1              0.000003 function! gitgutter#preview_hunk()
                              if gitgutter#utility#is_active()
                                " Ensure the working copy of the file is up to date.
                                " It doesn't make sense to stage a hunk otherwise.
                                noautocmd silent write
                                let diff = gitgutter#diff#run_diff(0, 1)
                                call gitgutter#handle_diff(diff)
                            
                                if empty(gitgutter#hunk#current_hunk())
                                  call gitgutter#utility#warn('cursor is not in a hunk')
                                else
                                  let diff_for_hunk = gitgutter#diff#generate_diff_for_hunk(diff, 'preview')
                            
                                  silent! wincmd P
                                  if !&previewwindow
                                    execute 'bo ' . &previewheight . ' new'
                                    set previewwindow
                                  endif
                            
                                  setlocal noro modifiable filetype=diff buftype=nofile bufhidden=delete noswapfile
                                  execute "%delete_"
                                  call append(0, split(diff_for_hunk, "\n"))
                            
                                  wincmd p
                                endif
                              endif
                            endfunction
                            
                            " }}}

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/gitgutter/utility.vim
Sourced 1 time
Total time:   0.000175
 Self time:   0.000175

count  total (s)   self (s)
                            let s:file = ''
    1              0.000004 let s:using_xolox_shell = -1
    1              0.000001 let s:exit_code = 0
    1              0.000005 let s:fish = &shell =~# 'fish'
    1              0.000001 let s:jobs = {}
                            
    1              0.000003 function! gitgutter#utility#warn(message)
                              echohl WarningMsg
                              echo 'vim-gitgutter: ' . a:message
                              echohl None
                              let v:warningmsg = a:message
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#warn_once(message, key)
                              if empty(getbufvar(s:bufnr, a:key))
                                call setbufvar(s:bufnr, a:key, '1')
                                echohl WarningMsg
                                redraw | echo 'vim-gitgutter: ' . a:message
                                echohl None
                                let v:warningmsg = a:message
                              endif
                            endfunction
                            
                            " Returns truthy when the buffer's file should be processed; and falsey when it shouldn't.
                            " This function does not and should not make any system calls.
    1              0.000002 function! gitgutter#utility#is_active()
                              return g:gitgutter_enabled && gitgutter#utility#exists_file() && gitgutter#utility#not_git_dir() && !gitgutter#utility#help_file()
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#not_git_dir()
                              return gitgutter#utility#full_path_to_directory_of_file() !~ '[/\\]\.git\($\|[/\\]\)'
                            endfunction
                            
    1              0.000003 function! gitgutter#utility#help_file()
                              return getbufvar(s:bufnr, '&filetype') ==# 'help' && getbufvar(s:bufnr, '&buftype') ==# 'help'
                            endfunction
                            
                            " A replacement for the built-in `shellescape(arg)`.
                            "
                            " Recent versions of Vim handle shell escaping pretty well.  However older
                            " versions aren't as good.  This attempts to do the right thing.
                            "
                            " See:
                            " https://github.com/tpope/vim-fugitive/blob/8f0b8edfbd246c0026b7a2388e1d883d579ac7f6/plugin/fugitive.vim#L29-L37
    1              0.000002 function! gitgutter#utility#shellescape(arg)
                              if a:arg =~ '^[A-Za-z0-9_/.-]\+$'
                                return a:arg
                              elseif &shell =~# 'cmd' || gitgutter#utility#using_xolox_shell()
                                return '"' . substitute(substitute(a:arg, '"', '""', 'g'), '%', '"%"', 'g') . '"'
                              else
                                return shellescape(a:arg)
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#set_buffer(bufnr)
                              let s:bufnr = a:bufnr
                              let s:file = resolve(bufname(a:bufnr))
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#bufnr()
                              return s:bufnr
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#file()
                              return s:file
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#filename()
                              return fnamemodify(s:file, ':t')
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#extension()
                              return fnamemodify(s:file, ':e')
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#full_path_to_directory_of_file()
                              return fnamemodify(s:file, ':p:h')
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#directory_of_file()
                              return fnamemodify(s:file, ':h')
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#exists_file()
                              return filereadable(s:file)
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#has_unsaved_changes()
                              return getbufvar(s:bufnr, "&mod")
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#has_fresh_changes()
                              return getbufvar(s:bufnr, 'changedtick') != getbufvar(s:bufnr, 'gitgutter_last_tick')
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#save_last_seen_change()
                              call setbufvar(s:bufnr, 'gitgutter_last_tick', getbufvar(s:bufnr, 'changedtick'))
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#shell_error()
                              return gitgutter#utility#using_xolox_shell() ? s:exit_code : v:shell_error
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#using_xolox_shell()
                              if s:using_xolox_shell == -1
                                if !g:gitgutter_avoid_cmd_prompt_on_windows
                                  let s:using_xolox_shell = 0
                                " Although xolox/vim-shell works on both windows and unix we only want to use
                                " it on windows.
                                elseif has('win32') || has('win64') || has('win32unix')
                                  let s:using_xolox_shell = exists('g:xolox#misc#version') && exists('g:xolox#shell#version')
                                else
                                  let s:using_xolox_shell = 0
                                endif
                              endif
                              return s:using_xolox_shell
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#system(cmd, ...)
                              if gitgutter#utility#using_xolox_shell()
                                let options = {'command': a:cmd, 'check': 0}
                                if a:0 > 0
                                  let options['stdin'] = a:1
                                endif
                                let ret = xolox#misc#os#exec(options)
                                let output = join(ret.stdout, "\n")
                                let s:exit_code = ret.exit_code
                              else
                                silent let output = (a:0 == 0) ? system(a:cmd) : system(a:cmd, a:1)
                              endif
                              return output
                            endfunction
                            
    1              0.000004 function! gitgutter#utility#file_relative_to_repo_root()
                              let file_path_relative_to_repo_root = getbufvar(s:bufnr, 'gitgutter_repo_relative_path')
                              if empty(file_path_relative_to_repo_root)
                                let dir_path_relative_to_repo_root = gitgutter#utility#system(gitgutter#utility#command_in_directory_of_file('git rev-parse --show-prefix'))
                                let dir_path_relative_to_repo_root = gitgutter#utility#strip_trailing_new_line(dir_path_relative_to_repo_root)
                                let file_path_relative_to_repo_root = dir_path_relative_to_repo_root . gitgutter#utility#filename()
                                call setbufvar(s:bufnr, 'gitgutter_repo_relative_path', file_path_relative_to_repo_root)
                              endif
                              return file_path_relative_to_repo_root
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#command_in_directory_of_file(cmd)
                              return 'cd '.gitgutter#utility#shellescape(gitgutter#utility#directory_of_file()) . (s:fish ? '; and ' : ' && ') . a:cmd
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#highlight_name_for_change(text)
                              if a:text ==# 'added'
                                return 'GitGutterLineAdded'
                              elseif a:text ==# 'removed'
                                return 'GitGutterLineRemoved'
                              elseif a:text ==# 'removed_first_line'
                                return 'GitGutterLineRemovedFirstLine'
                              elseif a:text ==# 'modified'
                                return 'GitGutterLineModified'
                              elseif a:text ==# 'modified_removed'
                                return 'GitGutterLineModifiedRemoved'
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#strip_trailing_new_line(line)
                              return substitute(a:line, '\n$', '', '')
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#pending_job(job_id)
                              let s:jobs[a:job_id] = 1
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#is_pending_job(job_id)
                              return has_key(s:jobs, a:job_id)
                            endfunction
                            
    1              0.000002 function! gitgutter#utility#job_output_received(job_id, event)
                              if has_key(s:jobs, a:job_id)
                                unlet s:jobs[a:job_id]
                              endif
                            endfunction

SCRIPT  /Users/zchee/.cache/nvim/dein/.dein/autoload/gitgutter/hunk.vim
Sourced 1 time
Total time:   0.000093
 Self time:   0.000093

count  total (s)   self (s)
                            " number of lines [added, modified, removed]
    1              0.000005 let s:summary = [0, 0, 0]
    1              0.000001 let s:hunks = []
                            
    1              0.000003 function! gitgutter#hunk#set_hunks(hunks)
                              let s:hunks = a:hunks
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#hunks()
                              return s:hunks
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#summary()
                              return s:summary
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#reset()
                              let s:summary = [0, 0, 0]
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#increment_lines_added(count)
                              let s:summary[0] += a:count
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#increment_lines_modified(count)
                              let s:summary[1] += a:count
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#increment_lines_removed(count)
                              let s:summary[2] += a:count
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#next_hunk(count)
                              if gitgutter#utility#is_active()
                                let current_line = line('.')
                                let hunk_count = 0
                                for hunk in s:hunks
                                  if hunk[2] > current_line
                                    let hunk_count += 1
                                    if hunk_count == a:count
                                      execute 'normal!' hunk[2] . 'G'
                                      return
                                    endif
                                  endif
                                endfor
                                call gitgutter#utility#warn('No more hunks')
                              endif
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#prev_hunk(count)
                              if gitgutter#utility#is_active()
                                let current_line = line('.')
                                let hunk_count = 0
                                for hunk in reverse(copy(s:hunks))
                                  if hunk[2] < current_line
                                    let hunk_count += 1
                                    if hunk_count == a:count
                                      let target = hunk[2] == 0 ? 1 : hunk[2]
                                      execute 'normal!' target . 'G'
                                      return
                                    endif
                                  endif
                                endfor
                                call gitgutter#utility#warn('No previous hunks')
                              endif
                            endfunction
                            
                            " Returns the hunk the cursor is currently in or an empty list if the cursor
                            " isn't in a hunk.
    1              0.000002 function! gitgutter#hunk#current_hunk()
                              let current_hunk = []
                            
                              for hunk in s:hunks
                                if gitgutter#hunk#cursor_in_hunk(hunk)
                                  let current_hunk = hunk
                                  break
                                endif
                              endfor
                            
                              return current_hunk
                            endfunction
                            
    1              0.000002 function! gitgutter#hunk#cursor_in_hunk(hunk)
                              let current_line = line('.')
                            
                              if current_line == 1 && a:hunk[2] == 0
                                return 1
                              endif
                            
                              if current_line >= a:hunk[2] && current_line < a:hunk[2] + (a:hunk[3] == 0 ? 1 : a:hunk[3])
                                return 1
                              endif
                            
                              return 0
                            endfunction
                            
                            " Returns the number of lines the current hunk is offset from where it would
                            " be if any changes above it in the file didn't exist.
    1              0.000002 function! gitgutter#hunk#line_adjustment_for_current_hunk()
                              let adj = 0
                              for hunk in s:hunks
                                if gitgutter#hunk#cursor_in_hunk(hunk)
                                  break
                                else
                                  let adj += hunk[1] - hunk[3]
                                endif
                              endfor
                              return adj
                            endfunction

FUNCTION  airline#themes#generate_color_map()
Called 5 times
Total time:   0.000158
 Self time:   0.000158

count  total (s)   self (s)
    5              0.000062   let palette = { 'airline_a': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , get(a:sect1 , 4 , '') ] , 'airline_b': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , get(a:sect2 , 4 , '') ] , 'airline_c': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , get(a:sect3 , 4 , '') ] , }
                            
    5              0.000004   if a:0 > 0
                                call extend(palette, { 'airline_x': [ a:1[0] , a:1[1] , a:1[2] , a:1[3] , get(a:1 , 4 , '' ) ] , 'airline_y': [ a:2[0] , a:2[1] , a:2[2] , a:2[3] , get(a:2 , 4 , '' ) ] , 'airline_z': [ a:3[0] , a:3[1] , a:3[2] , a:3[3] , get(a:3 , 4 , '' ) ] , })
                              else
    5              0.000051     call extend(palette, { 'airline_x': [ a:sect3[0] , a:sect3[1] , a:sect3[2] , a:sect3[3] , '' ] , 'airline_y': [ a:sect2[0] , a:sect2[1] , a:sect2[2] , a:sect2[3] , '' ] , 'airline_z': [ a:sect1[0] , a:sect1[1] , a:sect1[2] , a:sect1[3] , '' ] , })
    5              0.000003   endif
                            
    5              0.000004   return palette

FUNCTION  operator#user#_define()
Called 3 times
Total time:   0.000156
 Self time:   0.000156

count  total (s)   self (s)
    3              0.000003   if 0 < a:0
    2              0.000009     let additional_settings = '\|' . join(a:000)
    2              0.000001   else
    1              0.000001     let additional_settings = ''
    1              0.000001   endif
                            
    3              0.000060   execute printf(('nnoremap <script> <silent> %s ' .               ':<C-u>call operator#user#_set_up(%s)%s<Return>' .               '<SID>(count)' .               '<SID>(register)' .               'g@'),              a:operator_keyseq,              string(a:function_name),              additional_settings)
    3              0.000050   execute printf(('vnoremap <script> <silent> %s ' .               ':<C-u>call operator#user#_set_up(%s)%s<Return>' .               'gv' .               '<SID>(register)' .               'g@'),              a:operator_keyseq,              string(a:function_name),              additional_settings)
    3              0.000022   execute printf('onoremap %s  g@', a:operator_keyseq)

FUNCTION  <SNR>25_AddEval()
Called 1 time
Total time:   0.000012
 Self time:   0.000012

count  total (s)   self (s)
    1              0.000003   if has_key(a:opts, 'eval')
                                if type(a:opts.eval) != type('') || a:opts.eval == ''
                                  throw "Eval option must be a non-empty string"
                                endif
                                " evaluate an expression and pass as argument
                                call add(a:rpcargs, 'eval("'.escape(a:opts.eval, '"').'")')
                              endif

FUNCTION  <SNR>28_invoke_funcrefs()
Called 3 times
Total time:   0.013108
 Self time:   0.000212

count  total (s)   self (s)
    3   0.000356   0.000118   let builder = airline#builder#new(a:context)
    3   0.002583   0.000027   let err = airline#util#exec_funcrefs(a:funcrefs + s:core_funcrefs, builder, a:context)
    3              0.000003   if err == 1
    3   0.010120   0.000018     let a:context.line = builder.build()
    3              0.000012     let s:contexts[a:context.winnr] = a:context
    3              0.000028     call setwinvar(a:context.winnr, '&statusline', '%!airline#statusline('.a:context.winnr.')')
    3              0.000002   endif

FUNCTION  remote#host#RegisterClone()
Called 2 times
Total time:   0.000029
 Self time:   0.000029

count  total (s)   self (s)
    2              0.000005   if !has_key(s:hosts, a:orig_name)
                                throw 'No host named "'.a:orig_name.'" is registered'
                              endif
    2              0.000006   let Factory = s:hosts[a:orig_name].factory
    2              0.000011   let s:hosts[a:name] = { 'factory': Factory, 'channel': 0, 'initialized': 0, 'orig_name': a:orig_name }

FUNCTION  <SNR>12_wrap_accent()
Called 24 times
Total time:   0.000453
 Self time:   0.000245

count  total (s)   self (s)
   24              0.000038   if exists('a:part.accent')
    3   0.000312   0.000105     call airline#highlighter#add_accent(a:part.accent)
    3              0.000011     return '%#__accent_'.(a:part.accent).'#'.a:value.'%#__restore__#'
                              endif
   21              0.000016   return a:value

FUNCTION  <SNR>33_record()
Called 2 times
Total time:   0.000028
 Self time:   0.000028

count  total (s)   self (s)
    2              0.000005 	if s:locked | retu | en
    2              0.000004 	let bufnr = a:bufnr + 0
    2              0.000004 	let bufname = bufname(bufnr)
    2              0.000004 	if bufnr > 0 && !empty(bufname)
                            		cal filter(s:mrbs, 'v:val != bufnr')
                            		cal insert(s:mrbs, bufnr)
                            		cal s:addtomrufs(bufname)
                            	en

FUNCTION  deoplete#custom#set()
Called 2 times
Total time:   0.000070
 Self time:   0.000045

count  total (s)   self (s)
    4              0.000016   for key in split(a:source_name, '\s*,\s*')
    2   0.000039   0.000013     let custom_source = deoplete#custom#get_source_var(key)
    2              0.000004     let custom_source[a:option_name] = a:value
    2              0.000003   endfor

FUNCTION  <SNR>74_is_excluded_window()
Called 3 times
Total time:   0.000134
 Self time:   0.000134

count  total (s)   self (s)
    3              0.000006   for matchft in g:airline_exclude_filetypes
                                if matchft ==# &ft
                                  return 1
                                endif
                              endfor
                            
   12              0.000013   for matchw in g:airline_exclude_filenames
    9              0.000059     if matchstr(expand('%'), matchw) ==# matchw
                                  return 1
                                endif
    9              0.000007   endfor
                            
    3              0.000004   if g:airline_exclude_preview && &previewwindow
                                return 1
                              endif
                            
    3              0.000002   return 0

FUNCTION  airline#extensions#load_theme()
Called 1 time
Total time:   0.001155
 Self time:   0.000100

count  total (s)   self (s)
    1   0.001154   0.000099   call airline#util#exec_funcrefs(s:ext._theme_funcrefs, g:airline#themes#{g:airline_theme}#palette)

FUNCTION  2()
Called 4 times
Total time:   0.000083
 Self time:   0.000017

count  total (s)   self (s)
    4   0.000082   0.000016   call airline#add_statusline_func(a:name)

FUNCTION  gitgutter#highlight#define_signs()
Called 1 time
Total time:   0.000069
 Self time:   0.000032

count  total (s)   self (s)
    1              0.000006   sign define GitGutterLineAdded
    1              0.000001   sign define GitGutterLineModified
    1              0.000001   sign define GitGutterLineRemoved
    1              0.000001   sign define GitGutterLineRemovedFirstLine
    1              0.000001   sign define GitGutterLineModifiedRemoved
    1              0.000001   sign define GitGutterDummy
                            
    1   0.000024   0.000007   call gitgutter#highlight#define_sign_text()
    1   0.000018   0.000007   call gitgutter#highlight#define_sign_text_highlights()
    1   0.000016   0.000007   call gitgutter#highlight#define_sign_line_highlights()

FUNCTION  5()
Called 1 time
Total time:   0.000004
 Self time:   0.000004

count  total (s)   self (s)
    1              0.000003   call add(self._theme_funcrefs, function(a:name))

FUNCTION  airline#extensions#load()
Called 1 time
Total time:   0.004075
 Self time:   0.002947

count  total (s)   self (s)
                              " non-trivial number of external plugins use eventignore=all, so we need to account for that
    1              0.000007   autocmd CursorMoved * call <sid>sync_active_winnr()
                            
    1              0.000003   if exists('g:airline_extensions')
                                for ext in g:airline_extensions
                                  call airline#extensions#{ext}#init(s:ext)
                                endfor
                                return
                              endif
                            
    1   0.000235   0.000103   call airline#extensions#quickfix#init(s:ext)
                            
    1              0.000002   if get(g:, 'loaded_unite', 0)
                                call airline#extensions#unite#init(s:ext)
                              endif
                            
    1              0.000004   if exists(':NetrwSettings')
                                call airline#extensions#netrw#init(s:ext)
                              endif
                            
    1              0.000002   if get(g:, 'airline#extensions#ycm#enabled', 0)
                                call airline#extensions#ycm#init(s:ext)
                              endif
                            
    1              0.000001   if get(g:, 'loaded_vimfiler', 0)
                                let g:vimfiler_force_overwrite_statusline = 0
                              endif
                            
    1              0.000002   if get(g:, 'loaded_ctrlp', 0)
    1   0.000260   0.000097     call airline#extensions#ctrlp#init(s:ext)
    1              0.000001   endif
                            
    1              0.000002   if get(g:, 'CtrlSpaceLoaded', 0)
                                call airline#extensions#ctrlspace#init(s:ext)
                              endif
                            
    1              0.000001   if get(g:, 'command_t_loaded', 0)
                                call airline#extensions#commandt#init(s:ext)
                              endif
                            
    1              0.000002   if exists(':UndotreeToggle')
                                call airline#extensions#undotree#init(s:ext)
                              endif
                            
    1              0.000005   if get(g:, 'airline#extensions#hunks#enabled', 1) && (exists('g:loaded_signify') || exists('g:loaded_gitgutter') || exists('g:loaded_changes') || exists('g:loaded_quickfixsigns'))
    1   0.000261   0.000100     call airline#extensions#hunks#init(s:ext)
    1              0.000001   endif
                            
    1              0.000003   if get(g:, 'airline#extensions#tagbar#enabled', 1) && exists(':TagbarToggle')
                                call airline#extensions#tagbar#init(s:ext)
                              endif
                            
    1              0.000004   if get(g:, 'airline#extensions#csv#enabled', 1) && (get(g:, 'loaded_csv', 0) || exists(':Table'))
                                call airline#extensions#csv#init(s:ext)
                              endif
                            
    1              0.000002   if exists(':VimShell')
                                let s:filetype_overrides['vimshell'] = ['vimshell','%{vimshell#get_status_string()}']
                                let s:filetype_regex_overrides['^int-'] = ['vimshell','%{substitute(&ft, "int-", "", "")}']
                              endif
                            
    1              0.000007   if get(g:, 'airline#extensions#branch#enabled', 1) && (exists('*fugitive#head') || exists('*lawrencium#statusline') ||     (get(g:, 'airline#extensions#branch#use_vcscommand', 0) && exists('*VCSCommandGetStatusLine')))
                                call airline#extensions#branch#init(s:ext)
                              endif
                            
    1              0.000003   if get(g:, 'airline#extensions#bufferline#enabled', 1) && exists('*bufferline#get_status_string')
                                call airline#extensions#bufferline#init(s:ext)
                              endif
                            
    1              0.000006   if (get(g:, 'airline#extensions#virtualenv#enabled', 1) && (exists(':VirtualEnvList') || isdirectory($VIRTUAL_ENV)))
                                call airline#extensions#virtualenv#init(s:ext)
                              endif
                            
    1              0.000003   if (get(g:, 'airline#extensions#eclim#enabled', 1) && exists(':ProjectCreate'))
                                call airline#extensions#eclim#init(s:ext)
                              endif
                            
    1              0.000003   if get(g:, 'airline#extensions#syntastic#enabled', 1) && exists(':SyntasticCheck')
                                call airline#extensions#syntastic#init(s:ext)
                              endif
                            
    1              0.000002   if get(g:, 'airline#extensions#whitespace#enabled', 1)
    1   0.000510   0.000100     call airline#extensions#whitespace#init(s:ext)
    1              0.000001   endif
                            
    1              0.000044   if get(g:, 'airline#extensions#po#enabled', 1) && executable('msgfmt')
    1   0.000217   0.000101     call airline#extensions#po#init(s:ext)
    1              0.000001   endif
                            
    1              0.000002   if get(g:, 'airline#extensions#wordcount#enabled', 1)
    1   0.000241   0.000097     call airline#extensions#wordcount#init(s:ext)
    1              0.000001   endif
                            
    1              0.000002   if get(g:, 'airline#extensions#tabline#enabled', 0)
                                call airline#extensions#tabline#init(s:ext)
                              endif
                            
    1              0.000003   if get(g:, 'airline#extensions#tmuxline#enabled', 1) && exists(':Tmuxline')
                                call airline#extensions#tmuxline#init(s:ext)
                              endif
                            
    1              0.000004   if get(g:, 'airline#extensions#promptline#enabled', 1) && exists(':PromptlineSnapshot') && len(get(g:, 'airline#extensions#promptline#snapshot_file', ''))
                                call airline#extensions#promptline#init(s:ext)
                              endif
                            
    1              0.000003   if get(g:, 'airline#extensions#nrrwrgn#enabled', 1) && exists(':NR') == 2
                                  call airline#extensions#nrrwrgn#init(s:ext)
                              endif
                            
    1              0.000003   if get(g:, 'airline#extensions#unicode#enabled', 1) && exists(':UnicodeTable') == 2
                                  call airline#extensions#unicode#init(s:ext)
                              endif
                            
    1              0.000003   if (get(g:, 'airline#extensions#capslock#enabled', 1) && exists('*CapsLockStatusline'))
                                call airline#extensions#capslock#init(s:ext)
                              endif
                            
    1              0.000003   if (get(g:, 'airline#extensions#windowswap#enabled', 1) && get(g:, 'loaded_windowswap', 0))
                                call airline#extensions#windowswap#init(s:ext)
                              endif
                            
    1              0.000002   if !get(g:, 'airline#extensions#disable_rtp_load', 0)
                                " load all other extensions, which are not part of the default distribution.
                                " (autoload/airline/extensions/*.vim outside of our s:script_path).
   30              0.001481     for file in split(globpath(&rtp, "autoload/airline/extensions/*.vim"), "\n")
                                  " we have to check both resolved and unresolved paths, since it's possible
                                  " that they might not get resolved properly (see #187)
   29              0.000455       if stridx(tolower(resolve(fnamemodify(file, ':p'))), s:script_path) < 0 && stridx(tolower(fnamemodify(file, ':p')), s:script_path) < 0
                                    let name = fnamemodify(file, ':t:r')
                                    if !get(g:, 'airline#extensions#'.name.'#enabled', 1)
                                      continue
                                    endif
                                    try
                                      call airline#extensions#{name}#init(s:ext)
                                    catch
                                    endtry
                                  endif
   29              0.000014     endfor
    1              0.000001   endif

FUNCTION  8()
Called 21 times
Total time:   0.000075
 Self time:   0.000075

count  total (s)   self (s)
   21              0.000069   call add(self._sections, [a:group, a:contents])

FUNCTION  9()
Called 6 times
Total time:   0.000018
 Self time:   0.000018

count  total (s)   self (s)
    6              0.000016   call add(self._sections, ['', a:text])

FUNCTION  gitgutter#utility#exists_file()
Called 1 time
Total time:   0.000003
 Self time:   0.000003

count  total (s)   self (s)
    1              0.000002   return filereadable(s:file)

FUNCTION  remote#define#AutocmdOnHost()
Called 5 times
Total time:   0.000389
 Self time:   0.000200

count  total (s)   self (s)
    5   0.000087   0.000025   let group = s:GetNextAutocmdGroup()
    5              0.000019   let forward = '"doau '.group.' '.a:name.' ".'.'expand("<amatch>")'
    5              0.000009   let a:opts.group = group
    5   0.000228   0.000101   let bootstrap_def = s:GetAutocmdPrefix(a:name, a:opts) .' call remote#define#AutocmdBootstrap("'.a:host.'"' .                                ', "'.a:method.'"' .                                ', "'.a:sync.'"' .                                ', "'.a:name.'"' .                                ', '.string(a:opts).'' .                                ', "'.escape(forward, '"').'"' .                                ')'
    5              0.000040   exe bootstrap_def

FUNCTION  <SNR>85_add_section()
Called 24 times
Total time:   0.001283
 Self time:   0.000494

count  total (s)   self (s)
                                " i have no idea why the warning section needs special treatment, but it's
                                " needed to prevent separators from showing up
   24   0.000259   0.000097     if ((a:key == 'error' || a:key == 'warning') && empty(s:get_section(a:context.winnr, a:key)))
    3              0.000002       return
                                endif
   21              0.000034     if (a:key == 'warning' || a:key == 'error')
    3   0.000030   0.000020       call a:builder.add_raw('%(')
    3              0.000002     endif
   21   0.000762   0.000154     call a:builder.add_section('airline_'.a:key, s:get_section(a:context.winnr, a:key))
   21              0.000039     if (a:key == 'warning' || a:key == 'error')
    3   0.000027   0.000019       call a:builder.add_raw('%)')
    3              0.000002     endif

FUNCTION  airline#util#exec_funcrefs()
Called 4 times
Total time:   0.003469
 Self time:   0.000289

count  total (s)   self (s)
   20              0.000025     for Fn in a:list
   19   0.003382   0.000202       let code = call(Fn, a:000)
   19              0.000016       if code != 0
    3              0.000002         return code
                                  endif
   16              0.000012     endfor
    1              0.000001     return 0

FUNCTION  dein#_expand()
Called 2 times
Total time:   0.000026
 Self time:   0.000026

count  total (s)   self (s)
    2              0.000020   let path = (a:path =~ '^\~') ? fnamemodify(a:path, ':p') : (a:path =~ '^\$\h\w*') ? substitute(a:path,               '^\$\h\w*', '\=eval(submatch(0))', '') : a:path
    2              0.000005   return (s:is_windows && path =~ '\\') ? dein#_substitute_path(path) : path

FUNCTION  airline#highlighter#highlight()
Called 3 times
Total time:   0.015128
 Self time:   0.003608

count  total (s)   self (s)
    3              0.000009   let p = g:airline#themes#{g:airline_theme}#palette
                            
                              " draw the base mode, followed by any overrides
    3              0.000017   let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
    3              0.000007   let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
    6              0.000007   for mode in mapped
    3              0.000012     if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
    3              0.000008       let dict = g:airline#themes#{g:airline_theme}#palette[mode]
   27              0.000045       for kvp in items(dict)
   24              0.000039         let mode_colors = kvp[1]
   24   0.003439   0.000141         call airline#highlighter#exec(kvp[0].suffix, mode_colors)
                            
   72              0.000110         for accent in keys(s:accents)
   48              0.001169           if !has_key(p.accents, accent)
                                        continue
                                      endif
   48              0.000163           let colors = copy(mode_colors)
   48              0.000099           if p.accents[accent][0] != ''
   24              0.000053             let colors[0] = p.accents[accent][0]
   24              0.000013           endif
   48              0.000089           if p.accents[accent][2] != ''
   24              0.000045             let colors[2] = p.accents[accent][2]
   24              0.000012           endif
   48              0.000061           if len(colors) >= 5
   48              0.000132             let colors[4] = get(p.accents[accent], 4, '')
   48              0.000027           else
                                        call add(colors, get(p.accents[accent], 4, ''))
                                      endif
   48   0.006933   0.000334           call airline#highlighter#exec(kvp[0].suffix.'_'.accent, colors)
   48              0.000034         endfor
   24              0.000013       endfor
                            
                                  " TODO: optimize this
    9              0.000015       for sep in items(s:separators)
    6   0.001672   0.000050         call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
    6              0.000005       endfor
    3              0.000001     endif
    3              0.000001   endfor

FUNCTION  dein#_tsort()
Called 1 time
Total time:   0.000008
 Self time:   0.000008

count  total (s)   self (s)
    1              0.000001   let sorted = []
    1              0.000001   let mark = {}
    1              0.000001   for target in a:plugins
                                call s:tsort_impl(target, mark, sorted)
                              endfor
                            
    1              0.000001   return sorted

FUNCTION  remote#host#Register()
Called 4 times
Total time:   0.000045
 Self time:   0.000045

count  total (s)   self (s)
    4              0.000017   let s:hosts[a:name] = {'factory': a:factory, 'channel': 0, 'initialized': 0}
    4              0.000008   let s:plugin_patterns[a:name] = a:pattern
    4              0.000009   if type(a:factory) == type(1) && a:factory
                                " Passed a channel directly
                                let s:hosts[a:name].channel = a:factory
                              endif

FUNCTION  dein#_split_rtp()
Called 2 times
Total time:   0.000024
 Self time:   0.000024

count  total (s)   self (s)
    2              0.000006   if stridx(a:runtimepath, '\,') < 0
    2              0.000017     return split(a:runtimepath, ',')
                              endif
                            
                              let split = split(a:runtimepath, '\\\@<!\%(\\\\\)*\zs,')
                              return map(split,'substitute(v:val, ''\\\([\\,]\)'', "\\1", "g")')

FUNCTION  airline#section#create_right()
Called 2 times
Total time:   0.000229
 Self time:   0.000010

count  total (s)   self (s)
    2   0.000228   0.000009   return s:create(a:parts, -1)

FUNCTION  airline#parts#define_raw()
Called 11 times
Total time:   0.000138
 Self time:   0.000040

count  total (s)   self (s)
   11   0.000135   0.000037   call airline#parts#define(a:key, { 'raw': a:raw })

FUNCTION  <SNR>43_check_interpreter()
Called 2 times
Total time:   0.000068
 Self time:   0.000068

count  total (s)   self (s)
    2              0.000052   let prog_path = exepath(a:prog)
    2              0.000004   if prog_path == ''
                                return [0, a:prog . ' not found in search path or not executable.']
                              endif
                            
    2              0.000002   if a:skip
    2              0.000003     return [1, '']
                              endif
                            
                              let min_version = (a:major_ver == 2) ? '2.6' : '3.3'
                            
                              " Try to load neovim module, and output Python version.
                              " Return codes:
                              "   0  Neovim module can be loaded.
                              "   1  Something else went wrong.
                              "   2  Neovim module cannot be loaded.
                              let prog_ver = system([ a:prog , '-c' , 'import sys; ' . 'sys.path.remove(""); ' . 'sys.stdout.write(str(sys.version_info[0]) + "." + str(sys.version_info[1])); ' . 'import pkgutil; ' . 'exit(2*int(pkgutil.get_loader("neovim") is None))' ])
                            
                              if prog_ver
                                if prog_ver !~ '^' . a:major_ver
                                  return [0, prog_path . ' is Python ' . prog_ver . ' and cannot provide Python ' . a:major_ver . '.']
                                elseif prog_ver =~ '^' . a:major_ver && prog_ver < min_version
                                  return [0, prog_path . ' is Python ' . prog_ver . ' and cannot provide Python >= ' . min_version . '.']
                                endif
                              endif
                            
                              if v:shell_error == 1
                                return [0, 'Checking ' . prog_path . ' caused an unknown error. ' . 'Please report this at github.com/neovim/neovim.']
                              elseif v:shell_error == 2
                                return [0, prog_path . ' does have not have the neovim module installed. ' . 'See ":help nvim-python".']
                              endif
                            
                              return [1, '']

FUNCTION  dein#_get_cache_file()
Called 1 time
Total time:   0.000009
 Self time:   0.000006

count  total (s)   self (s)
    1   0.000009   0.000006   return dein#_get_base_path() . '/cache_' . v:progname

FUNCTION  AutoPairsMap()
Called 9 times
Total time:   0.000149
 Self time:   0.000149

count  total (s)   self (s)
                              " | is special key which separate map command from text
    9              0.000010   let key = a:key
    9              0.000010   if key == '|'
                                let key = '<BAR>'
                              end
    9              0.000033   let escaped_key = substitute(key, "'", "''", 'g')
                              " use expr will cause search() doesn't work
    9              0.000074   execute 'inoremap <buffer> <silent> '.key." <C-R>=AutoPairsInsert('".escaped_key."')<CR>"

FUNCTION  remote#define#AutocmdOnChannel()
Called 1 time
Total time:   0.000083
 Self time:   0.000042

count  total (s)   self (s)
    1              0.000004   let rpcargs = [a:channel, '"'.a:method.'"']
    1   0.000022   0.000010   call s:AddEval(rpcargs, a:opts)
                            
    1   0.000046   0.000017   let autocmd_def = s:GetAutocmdPrefix(a:name, a:opts) . ' call '.s:GetRpcFunction(a:sync).'('.join(rpcargs, ', ').')'
    1              0.000010   exe autocmd_def

FUNCTION  remote#host#PluginsForHost()
Called 11 times
Total time:   0.000080
 Self time:   0.000080

count  total (s)   self (s)
   11              0.000026   if !has_key(s:plugins_for_host, a:host)
    7              0.000018     let s:plugins_for_host[a:host] = []
    7              0.000004   end
   11              0.000018   return s:plugins_for_host[a:host]

FUNCTION  <SNR>87_InitSigns()
Called 1 time
Total time:   0.000021
 Self time:   0.000021

count  total (s)   self (s)
    1              0.000005     let s:sign_queue = { 'project': {}, 'file': {} }
    1              0.000003     let s:last_placed_signs = { 'project': {}, 'file': {} }
    1              0.000005     let s:placed_signs = { 'project': {}, 'file': {} }
    1              0.000003     let s:sign_queue = { 'project': {}, 'file': {} }
    1              0.000003     let s:neomake_sign_id = { 'project': {}, 'file': {} }

FUNCTION  <SNR>15_Get()
Called 721 times
Total time:   0.003239
 Self time:   0.003239

count  total (s)   self (s)
  721              0.001555   if get(a:dict, a:key, a:default) isnot# a:default
  436              0.000804     return a:prefix. get(a:dict, a:key)
                              else
  285              0.000152     return ''
                              endif

FUNCTION  airline#extensions#wordcount#apply()
Called 3 times
Total time:   0.000046
 Self time:   0.000046

count  total (s)   self (s)
    3              0.000037   if &ft =~ s:filetypes
                                call airline#extensions#prepend_to_section('z', '%{get(b:, "airline_wordcount", "")}')
                              endif

FUNCTION  airline#parts#define()
Called 22 times
Total time:   0.000216
 Self time:   0.000216

count  total (s)   self (s)
   22              0.000064   let s:parts[a:key] = get(s:parts, a:key, {})
   22              0.000037   if exists('g:airline#init#bootstrapping')
   20              0.000046     call extend(s:parts[a:key], a:config, 'keep')
   20              0.000009   else
    2              0.000007     call extend(s:parts[a:key], a:config, 'force')
    2              0.000001   endif

FUNCTION  airline#extensions#hunks#init()
Called 1 time
Total time:   0.000027
 Self time:   0.000007

count  total (s)   self (s)
    1   0.000027   0.000006   call airline#parts#define_function('hunks', 'airline#extensions#hunks#get_hunks')

FUNCTION  dein#end()
Called 1 time
Total time:   0.000933
 Self time:   0.000761

count  total (s)   self (s)
    1              0.000001   if s:block_level != 1
                                call dein#_error('Invalid begin/end block usage.')
                                return 1
                              endif
                            
    1              0.000002   let s:block_level -= 1
                            
                              " Add runtimepath
    1   0.000016   0.000005   let rtps = dein#_split_rtp(&runtimepath)
    1              0.000003   let index = index(rtps, s:runtime_path)
    1              0.000001   if index < 0
                                call dein#_error('Invalid runtimepath.')
                                return 1
                              endif
                            
    1              0.000001   let sourced = []
   48              0.000105   for plugin in filter(values(g:dein#_plugins), "!v:val.lazy && !v:val.sourced && v:val.rtp != ''")
                                " Load dependencies
   47              0.000048     if !empty(plugin.depends)
                                  if s:load_depends(plugin, rtps, index)
                                    return 1
                                  endif
                                  continue
                                endif
                            
   47              0.000031     if !plugin.merged
    5              0.000010       call insert(rtps, plugin.rtp, index)
    5              0.000021       if isdirectory(plugin.rtp.'/after')
                                    call add(rtps, plugin.rtp.'/after')
                                  endif
    5              0.000002     endif
                            
   47              0.000041     let plugin.sourced = 1
   47              0.000064     call add(sourced, plugin)
   47              0.000025   endfor
    1   0.000020   0.000006   let &runtimepath = dein#_join_rtp(rtps, &runtimepath, '')
                            
    1   0.000152   0.000006   call dein#_call_hook('source', sourced)
                            
    1              0.000003   if !has('vim_starting')
                                let merged_plugins = keys(filter(copy(g:dein#_plugins), 'v:val.merged'))
                                if merged_plugins !=# s:prev_plugins
                                  call dein#install#_recache_runtimepath()
                                endif
                                call dein#_call_hook('post_source')
                                call dein#_reset_ftplugin()
                              endif

FUNCTION  <SNR>13_check_defined()
Called 16 times
Total time:   0.000074
 Self time:   0.000074

count  total (s)   self (s)
   16              0.000027   if !exists(a:variable)
   14              0.000031     let {a:variable} = a:default
   14              0.000006   endif

FUNCTION  airline#parts#get()
Called 24 times
Total time:   0.000052
 Self time:   0.000052

count  total (s)   self (s)
   24              0.000047   return get(s:parts, a:key, {})

FUNCTION  airline#load_theme()
Called 1 time
Total time:   0.014272
 Self time:   0.000042

count  total (s)   self (s)
    1              0.000004   if exists('*airline#themes#{g:airline_theme}#refresh')
                                call airline#themes#{g:airline_theme}#refresh()
                              endif
                            
    1              0.000002   let palette = g:airline#themes#{g:airline_theme}#palette
    1   0.000140   0.000005   call airline#themes#patch(palette)
                            
    1              0.000002   if exists('g:airline_theme_patch_func')
                                let Fn = function(g:airline_theme_patch_func)
                                call Fn(palette)
                              endif
                            
    1   0.007966   0.000006   call airline#highlighter#load_theme()
    1   0.001163   0.000008   call airline#extensions#load_theme()
    1   0.004986   0.000007   call airline#update_statusline()

FUNCTION  dein#get()
Called 1 time
Total time:   0.000017
 Self time:   0.000017

count  total (s)   self (s)
    1              0.000016   return empty(a:000) ? copy(g:dein#_plugins) : get(g:dein#_plugins, a:1, {})

FUNCTION  dein#_get_base_path()
Called 1 time
Total time:   0.000003
 Self time:   0.000003

count  total (s)   self (s)
    1              0.000003   return s:base_path

FUNCTION  airline#update_statusline()
Called 3 times
Total time:   0.013404
 Self time:   0.000287

count  total (s)   self (s)
    3   0.000027   0.000017   if airline#util#getwinvar(winnr(), 'airline_disabled', 0)
                                return
                              endif
    3              0.000019   for nr in filter(range(1, winnr('$')), 'v:val != winnr()')
                                if airline#util#getwinvar(nr, 'airline_disabled', 0)
                                  continue
                                endif
                                call setwinvar(nr, 'airline_active', 0)
                                let context = { 'winnr': nr, 'active': 0, 'bufnr': winbufnr(nr) }
                                call s:invoke_funcrefs(context, s:inactive_funcrefs)
                              endfor
                            
    3              0.000005   unlet! w:airline_render_left
    3              0.000003   unlet! w:airline_render_right
   30              0.000040   for section in s:sections
   27              0.000053     unlet! w:airline_section_{section}
   27              0.000019   endfor
                            
    3              0.000005   let w:airline_active = 1
    3              0.000016   let context = { 'winnr': winnr(), 'active': 1, 'bufnr': winbufnr(winnr()) }
    3   0.013164   0.000056   call s:invoke_funcrefs(context, g:airline_statusline_funcrefs)

FUNCTION  remote#host#RegisterPlugin()
Called 10 times
Total time:   0.004725
 Self time:   0.001460

count  total (s)   self (s)
   10   0.000119   0.000046   let plugins = remote#host#PluginsForHost(a:host)
                            
   16              0.000019   for plugin in plugins
    6              0.000009     if plugin.path == a:path
                                  throw 'Plugin "'.a:path.'" is already registered'
                                endif
    6              0.000004   endfor
                            
   10   0.000091   0.000043   if has_key(s:hosts, a:host) && remote#host#IsRunning(a:host)
                                " For now we won't allow registration of plugins when the host is already
                                " running.
                                throw 'Host "'.a:host.'" is already running'
                              endif
                            
   41              0.000038   for spec in a:specs
   31              0.000040     let type = spec.type
   31              0.000040     let name = spec.name
   31              0.000027     let sync = spec.sync
   31              0.000028     let opts = spec.opts
   31              0.000039     let rpc_method = a:path
   31              0.000040     if type == 'command'
   15              0.000035       let rpc_method .= ':command:'.name
   15   0.002167   0.000083       call remote#define#CommandOnHost(a:host, rpc_method, sync, name, opts)
   15              0.000013     elseif type == 'autocmd'
                                  " Since multiple handlers can be attached to the same autocmd event by a
                                  " single plugin, we need a way to uniquely identify the rpc method to
                                  " call.  The solution is to append the autocmd pattern to the method
                                  " name(This still has a limit: one handler per event/pattern combo, but
                                  " there's no need to allow plugins define multiple handlers in that case)
    5              0.000024       let rpc_method .= ':autocmd:'.name.':'.get(opts, 'pattern', '*')
    5   0.000799   0.000122       call remote#define#AutocmdOnHost(a:host, rpc_method, sync, name, opts)
    5              0.000005     elseif type == 'function'
   11              0.000025       let rpc_method .= ':function:'.name
   11   0.000439   0.000056       call remote#define#FunctionOnHost(a:host, rpc_method, sync, name, opts)
   11              0.000007     else
                                  echoerr 'Invalid declaration type: '.type
                                endif
   31              0.000025   endfor
                            
   10              0.000035   call add(plugins, {'path': a:path, 'specs': a:specs})

FUNCTION  provider#pythonx#Detect()
Called 2 times
Total time:   0.000125
 Self time:   0.000058

count  total (s)   self (s)
    2              0.000006   let host_var = (a:major_ver == 2) ? 'g:python_host_prog' : 'g:python3_host_prog'
    2              0.000004   let skip_var = (a:major_ver == 2) ? 'g:python_host_skip_check' : 'g:python3_host_skip_check'
    2              0.000010   let skip = exists(skip_var) ? {skip_var} : 0
    2              0.000005   if exists(host_var)
                                " Disable auto detection.
    2   0.000089   0.000022     let [result, err] = s:check_interpreter({host_var}, a:major_ver, skip)
    2              0.000002     if result
    2              0.000006       return [{host_var}, err]
                                endif
                                return ['', 'provider/pythonx: Could not load Python ' . a:major_ver . ' from ' . host_var . ': ' . err]
                              endif
                            
                              let prog_suffixes = (a:major_ver == 2) ?   ['2', '2.7', '2.6', ''] : ['3', '3.5', '3.4', '3.3', '']
                            
                              let errors = []
                              for prog in map(prog_suffixes, "'python' . v:val")
                                let [result, err] = s:check_interpreter(prog, a:major_ver, skip)
                                if result
                                  return [prog, err]
                                endif
                            
                                " Accumulate errors in case we don't find
                                " any suitable Python interpreter.
                                call add(errors, err)
                              endfor
                            
                              " No suitable Python interpreter found.
                              return ['', 'provider/pythonx: Could not load Python ' . a:major_ver . ":\n" .  join(errors, "\n")]

FUNCTION  6()
Called 3 times
Total time:   0.000010
 Self time:   0.000010

count  total (s)   self (s)
    3              0.000009   call add(self._sections, ['|', a:0 ? a:1 : '%='])

FUNCTION  operator#user#define()
Called 3 times
Total time:   0.000187
 Self time:   0.000031

count  total (s)   self (s)
    3   0.000186   0.000030   return call('operator#user#_define',           ['<Plug>(operator-' . a:name . ')', a:function_name] + a:000)

FUNCTION  airline#add_statusline_funcref()
Called 4 times
Total time:   0.000042
 Self time:   0.000042

count  total (s)   self (s)
    4              0.000012   if index(g:airline_statusline_funcrefs, a:function) >= 0
                                echohl WarningMsg
                                echo 'The airline statusline funcref '.string(a:function).' has already been added.'
                                echohl NONE
                                return
                              endif
    4              0.000010   call add(g:airline_statusline_funcrefs, a:function)

FUNCTION  <SNR>84_get_transitioned_seperator()
Called 18 times
Total time:   0.005606
 Self time:   0.000286

count  total (s)   self (s)
   18              0.000018   let line = ''
   18   0.005395   0.000076   call airline#highlighter#add_separator(a:prev_group, a:group, a:side)
   18              0.000067   let line .= '%#'.a:prev_group.'_to_'.a:group.'#'
   18              0.000054   let line .= a:side ? a:self._context.left_sep : a:self._context.right_sep
   18              0.000040   let line .= '%#'.a:group.'#'
   18              0.000015   return line

FUNCTION  airline#extensions#ctrlp#load_theme()
Called 1 time
Total time:   0.000889
 Self time:   0.000071

count  total (s)   self (s)
    1              0.000003   if exists('a:palette.ctrlp')
                                let theme = a:palette.ctrlp
                              else
    1              0.000004     let s:color_template = has_key(a:palette, s:color_template) ? s:color_template : 'insert'
    1   0.000024   0.000011     let theme = airline#extensions#ctrlp#generate_color_map( a:palette[s:color_template]['airline_c'], a:palette[s:color_template]['airline_b'], a:palette[s:color_template]['airline_a'])
    1              0.000001   endif
    7              0.000009   for key in keys(theme)
    6   0.000838   0.000032     call airline#highlighter#exec(key, theme[key])
    6              0.000005   endfor

FUNCTION  dein#_filetype_off()
Called 1 time
Total time:   0.000059
 Self time:   0.000020

count  total (s)   self (s)
    1   0.000045   0.000005   let filetype_out = dein#_redir('filetype')
                            
    1              0.000006   if filetype_out =~# 'plugin:ON' || filetype_out =~# 'indent:ON'
                                filetype plugin indent off
                              endif
                            
    1              0.000003   if filetype_out =~# 'detection:ON'
                                filetype off
                              endif
                            
    1              0.000001   return filetype_out

FUNCTION  airline#init#sections()
Called 1 time
Total time:   0.001309
 Self time:   0.000078

count  total (s)   self (s)
    1              0.000002   let spc = g:airline_symbols.space
    1              0.000002   if !exists('g:airline_section_a')
    1   0.000344   0.000010     let g:airline_section_a = airline#section#create_left(['mode', 'crypt', 'paste', 'capslock', 'iminsert'])
    1              0.000001   endif
    1              0.000002   if !exists('g:airline_section_b')
    1   0.000134   0.000004     let g:airline_section_b = airline#section#create(['hunks', 'branch'])
    1              0.000001   endif
    1              0.000002   if !exists('g:airline_section_c')
                                if exists("+autochdir") && &autochdir == 1
                                  let g:airline_section_c = airline#section#create(['%<', 'path', spc, 'readonly'])
                                else
                                  let g:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly'])
                                endif
                              endif
    1              0.000002   if !exists('g:airline_section_gutter')
    1   0.000083   0.000004     let g:airline_section_gutter = airline#section#create(['%='])
    1              0.000001   endif
    1              0.000002   if !exists('g:airline_section_x')
    1   0.000138   0.000007     let g:airline_section_x = airline#section#create_right(['tagbar', 'filetype'])
    1              0.000000   endif
    1              0.000002   if !exists('g:airline_section_y')
    1   0.000101   0.000004     let g:airline_section_y = airline#section#create_right(['ffenc'])
    1              0.000001   endif
    1              0.000002   if !exists('g:airline_section_z')
    1   0.000178   0.000005     let g:airline_section_z = airline#section#create(['windowswap', '%3p%%'.spc, 'linenr', ':%3v '])
    1              0.000001   endif
    1              0.000002   if !exists('g:airline_section_error')
    1   0.000135   0.000004     let g:airline_section_error = airline#section#create(['ycm_error_count', 'syntastic', 'eclim'])
    1              0.000001   endif
    1              0.000002   if !exists('g:airline_section_warning')
    1   0.000162   0.000004     let g:airline_section_warning = airline#section#create(['ycm_warning_count', 'whitespace'])
    1              0.000001   endif

FUNCTION  <SNR>85_get_section()
Called 30 times
Total time:   0.000767
 Self time:   0.000687

count  total (s)   self (s)
   30              0.000064   if has_key(s:section_truncate_width, a:key)
   21              0.000048     if winwidth(a:winnr) < s:section_truncate_width[a:key]
                                  return ''
                                endif
   21              0.000020   endif
   30              0.000040   let spc = g:airline_symbols.space
   30   0.000254   0.000174   let text = airline#util#getwinvar(a:winnr, 'airline_section_'.a:key, g:airline_section_{a:key})
   30              0.000164   let [prefix, suffix] = [get(a:000, 0, '%('.spc), get(a:000, 1, spc.'%)')]
   30              0.000094   return empty(text) ? '' : prefix.text.suffix

FUNCTION  gitgutter#hunk#reset()
Called 1 time
Total time:   0.000003
 Self time:   0.000003

count  total (s)   self (s)
    1              0.000003   let s:summary = [0, 0, 0]

FUNCTION  dein#_get_lazy_plugins()
Called 1 time
Total time:   0.000028
 Self time:   0.000028

count  total (s)   self (s)
    1              0.000028   return filter(values(g:dein#_plugins), '!v:val.sourced')

FUNCTION  dein#load_cache()
Called 1 time
Total time:   0.003027
 Self time:   0.002168

count  total (s)   self (s)
    1              0.000002   let s:vimrcs = a:0 ? a:1 : [$MYVIMRC]
    1              0.000003   let starting = a:0 > 1 ? a:2 : has('vim_starting')
                            
    1   0.000015   0.000006   let cache = dein#_get_cache_file()
    1              0.000013   if !starting || !filereadable(cache) | return 1 | endif
                            
    1   0.000041   0.000027   if !empty(filter(map(copy(s:vimrcs), 'getftime(dein#_expand(v:val))'), 'getftime(cache) < v:val'))
                                return 1
                              endif
                            
    1              0.000001   try
    1              0.000237     let list = readfile(cache)
    1   0.000020   0.000013     if len(list) != 3 || list[0] !=# s:get_cache_version() || string(s:vimrcs) !=# list[1]
                                  call dein#clear_cache()
                                  return 1
                                endif
                            
    1              0.001645     sandbox let plugins = eval(list[2])
                            
    1              0.000007     if type(plugins) != type({})
                                  call dein#clear_cache()
                                  return 1
                                endif
                            
    1              0.000002     let g:dein#_plugins = plugins
   12   0.000126   0.000098     for plugin in filter(dein#_get_lazy_plugins(), '!empty(v:val.on_cmd) || !empty(v:val.on_map)')
   11              0.000012       if !empty(plugin.on_cmd)
   11   0.000837   0.000034         call dein#_add_dummy_commands(plugin)
   11              0.000005       endif
   11              0.000012       if !empty(plugin.on_map)
                                    call dein#_add_dummy_mappings(plugin)
                                  endif
   11              0.000005     endfor
    1              0.000001   catch
                                call dein#_error('Error occurred while loading cache : ' . v:exception)
                                call dein#clear_cache()
                                return 1
                              endtry

FUNCTION  airline#section#create()
Called 6 times
Total time:   0.001214
 Self time:   0.000044

count  total (s)   self (s)
    6   0.001212   0.000043   return s:create(a:parts, 0)

FUNCTION  <SNR>12_create()
Called 9 times
Total time:   0.001717
 Self time:   0.001212

count  total (s)   self (s)
    9              0.000010   let _ = ''
   33              0.000044   for idx in range(len(a:parts))
   24   0.000132   0.000080     let part = airline#parts#get(a:parts[idx])
   24              0.000022     let val = ''
                            
   24              0.000038     if exists('part.function')
    9              0.000015       let func = (part.function).'()'
    9              0.000009     elseif exists('part.text')
    1              0.000002       let func = '"'.(part.text).'"'
    1              0.000001     else
   14              0.000014       if a:append > 0 && idx != 0
                                    let val .= s:spc.g:airline_left_alt_sep.s:spc
                                  endif
   14              0.000013       if a:append < 0 && idx != 0
                                    let val = s:spc.g:airline_right_alt_sep.s:spc.val
                                  endif
   14              0.000020       if exists('part.raw')
    9   0.000090   0.000034         let _ .= s:wrap_accent(part, val.(part.raw))
    9              0.000007         continue
                                  else
    5   0.000054   0.000024         let _ .= s:wrap_accent(part, val.a:parts[idx])
    5              0.000006         continue
                                  endif
                                endif
                            
   10              0.000020     let minwidth = get(part, 'minwidth', 0)
                            
   10              0.000010     if a:append > 0 && idx != 0
    4              0.000012       let partval = printf('%%{airline#util#append(%s,%s)}', func, minwidth)
    4              0.000005     elseif a:append < 0 && idx != len(a:parts) - 1
                                  let partval = printf('%%{airline#util#prepend(%s,%s)}', func, minwidth)
                                else
    6              0.000031       let partval = printf('%%{airline#util#wrap(%s,%s)}', func, minwidth)
    6              0.000003     endif
                            
   10              0.000015     if exists('part.condition')
                                  let partval = substitute(partval, '{', '\="{".(part.condition)." ? "', '')
                                  let partval = substitute(partval, '}', ' : ""}', '')
                                endif
                            
   10   0.000403   0.000037     let val .= s:wrap_accent(part, partval)
   10              0.000027     let _ .= val
   10              0.000007   endfor
    9              0.000007   return _

FUNCTION  <SNR>25_GetRpcFunction()
Called 1 time
Total time:   0.000004
 Self time:   0.000004

count  total (s)   self (s)
    1              0.000001   if a:sync
                                return 'rpcrequest'
                              endif
    1              0.000001   return 'rpcnotify'

FUNCTION  airline#parts#define_text()
Called 1 time
Total time:   0.000014
 Self time:   0.000005

count  total (s)   self (s)
    1   0.000014   0.000005   call airline#parts#define(a:key, { 'text': a:text })

FUNCTION  ctrlp#mrufiles#opts()
Called 1 time
Total time:   0.000119
 Self time:   0.000119

count  total (s)   self (s)
    1              0.000012 	let [pref, opts] = ['g:ctrlp_mruf_', { 'max': ['s:max', 250], 'include': ['s:in', ''], 'exclude': ['s:ex', ''], 'case_sensitive': ['s:cseno', 1], 'relative': ['s:re', 0], 'save_on_update': ['s:soup', 1], 'map_string': ['g:ctrlp_mruf_map_string', s:mruf_map_string], }]
    8              0.000023 	for [ke, va] in items(opts)
    7              0.000074 		let [{va[0]}, {pref.ke}] = [pref.ke, exists(pref.ke) ? {pref.ke} : va[1]]
    7              0.000005 	endfo

FUNCTION  airline#themes#patch()
Called 1 time
Total time:   0.000135
 Self time:   0.000135

count  total (s)   self (s)
    8              0.000010   for mode in keys(a:palette)
    7              0.000015     if !has_key(a:palette[mode], 'airline_warning')
    7              0.000022       let a:palette[mode]['airline_warning'] = [ '#000000', '#df5f00', 232, 166 ]
    7              0.000003     endif
    7              0.000013     if !has_key(a:palette[mode], 'airline_error')
    7              0.000018       let a:palette[mode]['airline_error'] = [ '#000000', '#990000', 232, 160 ]
    7              0.000003     endif
    7              0.000004   endfor
                            
    1              0.000003   let a:palette.accents = get(a:palette, 'accents', {})
    1              0.000003   let a:palette.accents.bold = [ '', '', '', '', 'bold' ]
    1              0.000002   let a:palette.accents.italic = [ '', '', '', '', 'italic' ]
                            
    1              0.000002   if !has_key(a:palette.accents, 'red')
                                let a:palette.accents.red = [ '#ff0000' , '' , 160 , '' ]
                              endif
    1              0.000001   if !has_key(a:palette.accents, 'green')
    1              0.000002     let a:palette.accents.green = [ '#008700' , '' , 22  , '' ]
    1              0.000000   endif
    1              0.000002   if !has_key(a:palette.accents, 'blue')
    1              0.000002     let a:palette.accents.blue = [ '#005fff' , '' , 27  , '' ]
    1              0.000000   endif
    1              0.000002   if !has_key(a:palette.accents, 'yellow')
    1              0.000002     let a:palette.accents.yellow = [ '#dfff00' , '' , 190 , '' ]
    1              0.000000   endif
    1              0.000001   if !has_key(a:palette.accents, 'orange')
    1              0.000002     let a:palette.accents.orange = [ '#df5f00' , '' , 166 , '' ]
    1              0.000000   endif
    1              0.000001   if !has_key(a:palette.accents, 'purple')
    1              0.000002     let a:palette.accents.purple = [ '#af00df' , '' , 128 , '' ]
    1              0.000000   endif

FUNCTION  airline#section#create_left()
Called 1 time
Total time:   0.000334
 Self time:   0.000006

count  total (s)   self (s)
    1   0.000334   0.000005   return s:create(a:parts, 1)

FUNCTION  gitgutter#highlight#define_sign_line_highlights()
Called 1 time
Total time:   0.000010
 Self time:   0.000010

count  total (s)   self (s)
    1              0.000001   if g:gitgutter_highlight_lines
                                sign define GitGutterLineAdded            linehl=GitGutterAddLine
                                sign define GitGutterLineModified         linehl=GitGutterChangeLine
                                sign define GitGutterLineRemoved          linehl=GitGutterDeleteLine
                                sign define GitGutterLineRemovedFirstLine linehl=GitGutterDeleteLine
                                sign define GitGutterLineModifiedRemoved  linehl=GitGutterChangeDeleteLine
                              else
    1              0.000001     sign define GitGutterLineAdded            linehl=
    1              0.000001     sign define GitGutterLineModified         linehl=
    1              0.000001     sign define GitGutterLineRemoved          linehl=
    1              0.000001     sign define GitGutterLineRemovedFirstLine linehl=
    1              0.000001     sign define GitGutterLineModifiedRemoved  linehl=
    1              0.000001   endif

FUNCTION  airline#extensions#default#apply()
Called 3 times
Total time:   0.001773
 Self time:   0.000122

count  total (s)   self (s)
    3              0.000006   let winnr = a:context.winnr
    3              0.000004   let active = a:context.active
                            
    3   0.000024   0.000015   if airline#util#getwinvar(winnr, 'airline_render_left', active || (!active && !g:airline_inactive_collapse))
    3   0.000595   0.000019     call s:build_sections(a:builder, a:context, s:layout[0])
    3              0.000002   else
                                let text = s:get_section(winnr, 'c')
                                if empty(text)
                                  let text = ' %f%m '
                                endif
                                call a:builder.add_section('airline_c'.(a:context.bufnr), text)
                              endif
                            
    3   0.000104   0.000022   call a:builder.split(s:get_section(winnr, 'gutter', '', ''))
                            
    3   0.000016   0.000010   if airline#util#getwinvar(winnr, 'airline_render_right', 1)
    3   0.000991   0.000013     call s:build_sections(a:builder, a:context, s:layout[1])
    3              0.000001   endif
                            
    3              0.000002   return 1

FUNCTION  airline#highlighter#exec()
Called 103 times
Total time:   0.013967
 Self time:   0.004482

count  total (s)   self (s)
  103              0.000109   if pumvisible()
                                return
                              endif
  103              0.000116   let colors = a:colors
  103              0.000101   if s:is_win32term
                                let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
                                let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
                              endif
  103   0.005175   0.001936   let cmd= printf('hi %s %s %s %s %s %s %s %s', a:group, s:Get(colors, 0, 'guifg=', ''), s:Get(colors, 1, 'guibg=', ''), s:Get(colors, 2, 'ctermfg=', ''), s:Get(colors, 3, 'ctermbg=', ''), s:Get(colors, 4, 'gui=', ''), s:Get(colors, 4, 'cterm=', ''), s:Get(colors, 4, 'term=', ''))
  103   0.006630   0.000384   let old_hi = airline#highlighter#get_highlight(a:group)
  103              0.000135   if len(colors) == 4
   28              0.000064     call add(colors, '')
   28              0.000013   endif
  103              0.000104   if old_hi != colors
   85              0.000510     exe cmd
   85              0.000039   endif

FUNCTION  airline#add_statusline_func()
Called 4 times
Total time:   0.000066
 Self time:   0.000024

count  total (s)   self (s)
    4   0.000065   0.000023   call airline#add_statusline_funcref(function(a:name))

FUNCTION  gitgutter#utility#is_active()
Called 1 time
Total time:   0.000010
 Self time:   0.000008

count  total (s)   self (s)
    1   0.000010   0.000007   return g:gitgutter_enabled && gitgutter#utility#exists_file() && gitgutter#utility#not_git_dir() && !gitgutter#utility#help_file()

FUNCTION  dein#_call_hook()
Called 1 time
Total time:   0.000146
 Self time:   0.000129

count  total (s)   self (s)
    1              0.000003   let prefix = '#User#dein#'.a:hook_name.'#'
    1   0.000124   0.000115   let plugins = filter(dein#_convert2list( (empty(a:000) ? dein#get() : a:1)), "get(v:val, 'sourced', 0) && exists(prefix . v:val.name)")
                            
    1   0.000013   0.000005   for plugin in dein#_tsort(plugins)
                                let autocmd = 'dein#' . a:hook_name . '#' . plugin.name
                                if exists('#User#'.autocmd)
                                  execute 'doautocmd User' autocmd
                                endif
                              endfor

FUNCTION  <SNR>2_on_path()
Called 2 times
Total time:   0.000009
 Self time:   0.000009

count  total (s)   self (s)
    2              0.000005   if a:path == ''
    2              0.000002     return
                              endif
                            
                              call dein#autoload#_on_path(a:path, a:event)

FUNCTION  <SNR>84_get_accented_line()
Called 21 times
Total time:   0.000875
 Self time:   0.000875

count  total (s)   self (s)
   21              0.000023   if a:self._context.active
   21              0.000023     let contents = []
   21              0.000112     let content_parts = split(a:contents, '__accent')
   54              0.000060     for cpart in content_parts
   33              0.000174       let accent = matchstr(cpart, '_\zs[^#]*\ze')
   33              0.000064       call add(contents, cpart)
   33              0.000028     endfor
   21              0.000062     let line = join(contents, a:group)
   21              0.000119     let line = substitute(line, '__restore__', a:group, 'g')
   21              0.000012   else
                                let line = substitute(a:contents, '%#__accent[^#]*#', '', 'g')
                                let line = substitute(line, '%#__restore__#', '', 'g')
                              endif
   21              0.000015   return line

FUNCTION  provider#python3#Prog()
Called 1 time
Total time:   0.000002
 Self time:   0.000002

count  total (s)   self (s)
    1              0.000001   return s:prog

FUNCTION  ctrlp#mrufiles#init()
Called 1 time
Total time:   0.000069
 Self time:   0.000069

count  total (s)   self (s)
    1              0.000004 	if !has('autocmd') | retu | en
    1              0.000002 	let s:locked = 0
    1              0.000001 	aug CtrlPMRUF
    1              0.000041 		au!
    1              0.000010 		au BufWinEnter,BufWinLeave,BufWritePost * cal s:record(expand('<abuf>', 1))
    1              0.000004 		au QuickFixCmdPre  *vimgrep* let s:locked = 1
    1              0.000003 		au QuickFixCmdPost *vimgrep* let s:locked = 0
    1              0.000003 		au VimLeavePre * cal s:savetofile(s:mergelists())
    1              0.000001 	aug END

FUNCTION  <SNR>15_get_array()
Called 181 times
Total time:   0.001265
 Self time:   0.001265

count  total (s)   self (s)
  181              0.000189   let fg = a:fg
  181              0.000163   let bg = a:bg
  181              0.000825   return g:airline_gui_mode ==# 'gui' ? [ fg, bg, '', '', join(a:opts, ',') ] : [ '', '', fg, bg, join(a:opts, ',') ]

FUNCTION  <SNR>25_GetNextAutocmdGroup()
Called 16 times
Total time:   0.000188
 Self time:   0.000188

count  total (s)   self (s)
   16              0.000021   let gid = s:next_gid
   16              0.000021   let s:next_gid += 1
                              
   16              0.000034   let group_name = 'RPC_DEFINE_AUTOCMD_GROUP_'.gid
                              " Ensure the group is defined
   16              0.000071   exe 'augroup '.group_name.' | augroup END'
   16              0.000016   return group_name

FUNCTION  dein#_init()
Called 1 time
Total time:   0.000100
 Self time:   0.000100

count  total (s)   self (s)
    1              0.000002   let s:runtime_path = ''
    1              0.000001   let s:base_path = ''
    1              0.000001   let s:block_level = 0
    1              0.000001   let s:prev_plugins = []
    1              0.000001   let g:dein#_plugins = {}
    1              0.000001   let g:dein#name = ''
                            
    1              0.000001   augroup dein
    1              0.000002     autocmd!
    1              0.000006     autocmd InsertEnter * call dein#autoload#_on_i()
    1              0.000003     autocmd FileType * nested call s:on_ft()
    1              0.000003     autocmd FuncUndefined * call s:on_func(expand('<afile>'))
    1              0.000004     autocmd VimEnter * call dein#_call_hook('post_source')
    1              0.000001   augroup END
                            
    1              0.000004   if exists('##CmdUndefined')
    1              0.000002     autocmd CmdUndefined * call dein#autoload#_on_pre_cmd(expand('<afile>'))
    1              0.000001   endif
                            
    7              0.000009   for event in [ 'BufRead', 'BufCreate', 'BufEnter', 'BufWinEnter', 'BufNew', 'VimEnter' ]
    6              0.000042     execute 'autocmd dein' event "* call s:on_path(expand('<afile>'), " .string(event) . ")"
    6              0.000008   endfor

FUNCTION  gitgutter#highlight#define_sign_column_highlight()
Called 1 time
Total time:   0.000007
 Self time:   0.000007

count  total (s)   self (s)
    1              0.000002   if g:gitgutter_override_sign_column_highlight
    1              0.000002     highlight! link SignColumn LineNr
    1              0.000001   else
                                highlight default link SignColumn LineNr
                              endif

FUNCTION  dein#_redir()
Called 1 time
Total time:   0.000039
 Self time:   0.000039

count  total (s)   self (s)
    1              0.000004   let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
    1              0.000008   set verbose=0 verbosefile=
    1              0.000002   redir => res
    1              0.000015   silent! execute a:cmd
    1              0.000004   redir END
    1              0.000004   let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
    1              0.000001   return res

FUNCTION  airline#extensions#ctrlp#init()
Called 1 time
Total time:   0.000036
 Self time:   0.000014

count  total (s)   self (s)
    1              0.000004   let g:ctrlp_status_func = { 'main': 'airline#extensions#ctrlp#ctrlp_airline', 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status', }
    1   0.000023   0.000005   call a:ext.add_statusline_func('airline#extensions#ctrlp#apply')
    1   0.000007   0.000004   call a:ext.add_theme_func('airline#extensions#ctrlp#load_theme')

FUNCTION  airline#extensions#po#init()
Called 1 time
Total time:   0.000025
 Self time:   0.000005

count  total (s)   self (s)
    1   0.000025   0.000005     call a:ext.add_statusline_func('airline#extensions#po#apply')

FUNCTION  <SNR>39_set()
Called 16 times
Total time:   0.000136
 Self time:   0.000136

count  total (s)   self (s)
   16              0.000025   if !exists(a:var)
   11              0.000012     if type(a:default)
    6              0.000024       execute 'let' a:var '=' string(a:default)
    6              0.000003     else
    5              0.000017       execute 'let' a:var '=' a:default
    5              0.000002     endif
   11              0.000004   endif

FUNCTION  remote#host#IsRunning()
Called 9 times
Total time:   0.000048
 Self time:   0.000048

count  total (s)   self (s)
    9              0.000015   if !has_key(s:hosts, a:name)
                                throw 'No host named "'.a:name.'" is registered'
                              endif
    9              0.000014   return s:hosts[a:name].channel != 0

FUNCTION  airline#themes#get_highlight()
Called 48 times
Total time:   0.002903
 Self time:   0.000265

count  total (s)   self (s)
   48   0.002891   0.000252   return call('airline#highlighter#get_highlight', [a:group] + a:000)

FUNCTION  airline#highlighter#get_highlight()
Called 181 times
Total time:   0.010600
 Self time:   0.003347

count  total (s)   self (s)
  181   0.003728   0.000621   let fg = s:get_syn(a:group, 'fg')
  181   0.003466   0.000586   let bg = s:get_syn(a:group, 'bg')
  181              0.001180   let reverse = g:airline_gui_mode ==# 'gui' ? synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'gui') : synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')|| synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'term')
  181   0.002105   0.000840   return reverse ? s:get_array(bg, fg, a:000) : s:get_array(fg, bg, a:000)

FUNCTION  gitgutter#highlight#get_background_colors()
Called 2 times
Total time:   0.000180
 Self time:   0.000060

count  total (s)   self (s)
    2              0.000005   redir => highlight
    2              0.000016   silent execute 'silent highlight ' . a:group
    2              0.000004   redir END
                            
    2              0.000030   let link_matches = matchlist(highlight, 'links to \(\S\+\)')
    2              0.000003   if len(link_matches) > 0 " follow the link
    1              0.000005     return gitgutter#highlight#get_background_colors(link_matches[1])
                              endif
                            
    1   0.000024   0.000009   let ctermbg = gitgutter#highlight#match_highlight(highlight, 'ctermbg=\([0-9A-Za-z]\+\)')
    1   0.000017   0.000005   let guibg   = gitgutter#highlight#match_highlight(highlight, 'guibg=\([#0-9A-Za-z]\+\)')
    1              0.000002   return [guibg, ctermbg]

FUNCTION  10()
Called 3 times
Total time:   0.010103
 Self time:   0.001215

count  total (s)   self (s)
    3              0.000013   let side = 1
    3              0.000003   let line = ''
    3              0.000003   let i = 0
    3              0.000005   let length = len(self._sections)
    3              0.000003   let split = 0
                            
   33              0.000033   while i < length
   30              0.000051     let section = self._sections[i]
   30              0.000045     let group = section[0]
   30              0.000053     let contents = section[1]
   30   0.000416   0.000132     let prev_group = s:get_prev_group(self._sections, i)
                            
   30              0.000030     if group == ''
    6              0.000021       let line .= contents
    6              0.000005     elseif group == '|'
    3              0.000002       let side = 0
    3              0.000005       let line .= contents
    3              0.000002       let split = 1
    3              0.000001     else
   21              0.000022       if prev_group == ''
    3              0.000008         let line .= '%#'.group.'#'
    3              0.000002       elseif split
    3   0.000950   0.000015         let line .= s:get_transitioned_seperator(self, prev_group, group, side)
    3              0.000003         let split = 0
    3              0.000002       else
   15   0.006870   0.000074         let line .= s:get_seperator(self, prev_group, group, side)
   15              0.000009       endif
   21   0.001050   0.000175       let line .= s:get_accented_line(self, group, contents)
   21              0.000011     endif
                            
   30              0.000039     let i = i + 1
   30              0.000018   endwhile
                            
    3              0.000003   if !self._context.active
                                let line = substitute(line, '%#.\{-}\ze#', '\0_inactive', 'g')
                              endif
    3              0.000003   return line

FUNCTION  <SNR>27_on_window_changed()
Called 2 times
Total time:   0.036610
 Self time:   0.000032

count  total (s)   self (s)
    2              0.000006   if pumvisible() && (!&previewwindow || g:airline_exclude_preview)
                                return
                              endif
    2   0.028165   0.000012   call s:init()
    2   0.008433   0.000009   call airline#update_statusline()

FUNCTION  remote#host#Require()
Called 1 time
Total time:   0.178720
 Self time:   0.000059

count  total (s)   self (s)
    1              0.000003   if !has_key(s:hosts, a:name)
                                throw 'No host named "'.a:name.'" is registered'
                              endif
    1              0.000002   let host = s:hosts[a:name]
    1              0.000002   if !host.channel && !host.initialized
    1              0.000005     let host_info = { 'name': a:name, 'orig_name': get(host, 'orig_name', a:name) }
    1   0.178696   0.000034     let host.channel = call(host.factory, [host_info])
    1              0.000003     let host.initialized = 1
    1              0.000001   endif
    1              0.000003   return host.channel

FUNCTION  <SNR>84_should_change_group()
Called 15 times
Total time:   0.001955
 Self time:   0.000241

count  total (s)   self (s)
   15              0.000024   if a:group1 == a:group2
                                return 0
                              endif
   15   0.000962   0.000062   let color1 = airline#highlighter#get_highlight(a:group1)
   15   0.000881   0.000066   let color2 = airline#highlighter#get_highlight(a:group2)
   15              0.000018   if g:airline_gui_mode ==# 'gui'
   15              0.000039     return color1[1] != color2[1] || color1[0] != color2[0]
                              else
                                return color1[3] != color2[3] || color1[2] != color2[2]
                              endif

FUNCTION  <SNR>2_on_func()
Called 18 times
Total time:   0.000373
 Self time:   0.000373

count  total (s)   self (s)
   18              0.000222   let function_prefix = substitute(a:name, '[^#]*$', '', '')
   18              0.000122   if function_prefix =~# '^dein#' || function_prefix ==# 'vital#' || has('vim_starting')
   18              0.000013     return
                              endif
                            
                              call dein#autoload#_on_func(a:name)

FUNCTION  gitgutter#utility#set_buffer()
Called 1 time
Total time:   0.000008
 Self time:   0.000008

count  total (s)   self (s)
    1              0.000002   let s:bufnr = a:bufnr
    1              0.000005   let s:file = resolve(bufname(a:bufnr))

FUNCTION  <SNR>25_StringifyOpts()
Called 15 times
Total time:   0.001084
 Self time:   0.001084

count  total (s)   self (s)
   15              0.000016   let rv = []
  120              0.000090   for key in a:keys
  105              0.000145     if has_key(a:opts, key)
   23              0.000051       call add(rv, ' -'.key)
   23              0.000036       let val = a:opts[key]
   23              0.000058       if type(val) != type('') || val != ''
   23              0.000048         call add(rv, '='.val)
   23              0.000012       endif
   23              0.000010     endif
  105              0.000054   endfor
   15              0.000040   return join(rv, '')

FUNCTION  dein#begin()
Called 1 time
Total time:   0.000180
 Self time:   0.000076

count  total (s)   self (s)
    1              0.000003   if a:path == '' || s:block_level != 0
                                call dein#_error('Invalid begin/end block usage.')
                                return 1
                              endif
                            
    1              0.000002   let s:block_level += 1
    1   0.000034   0.000017   let s:base_path = dein#_chomp(dein#_expand(a:path))
    1              0.000002   let s:runtime_path = s:base_path . '/.dein'
                            
    1   0.000066   0.000007   call dein#_filetype_off()
                            
    1              0.000003   if !has('vim_starting')
                                let s:prev_plugins = keys(filter(copy(g:dein#_plugins), 'v:val.merged'))
                                execute 'set rtp-='.fnameescape(s:runtime_path)
                                execute 'set rtp-='.fnameescape(s:runtime_path.'/after')
                              endif
                            
                              " Join to the tail in runtimepath.
    1   0.000020   0.000008   let rtps = dein#_split_rtp(&runtimepath)
    1              0.000006   let n = index(rtps, $VIMRUNTIME)
    1              0.000001   if n < 0
                                call dein#_error('Invalid runtimepath.')
                                return 1
                              endif
    1   0.000028   0.000012   let &runtimepath = dein#_join_rtp( add(insert(rtps, s:runtime_path, n-1), s:runtime_path.'/after'), &runtimepath, s:runtime_path)

FUNCTION  neomake#signs#PlaceVisibleSigns()
Called 1 time
Total time:   0.000045
 Self time:   0.000045

count  total (s)   self (s)
    3              0.000006     for type in ['file', 'project']
    2              0.000005         let buf = bufnr('%')
    2              0.000007         if !has_key(s:sign_queue[type], buf)
    2              0.000004             continue
                                    endif
                                    let topline = line('w0')
                                    let botline = line('w$')
                                    for ln in range(topline, botline)
                                        if has_key(s:sign_queue[type][buf], ln)
                                            call neomake#signs#PlaceSign(s:sign_queue[type][buf][ln], type)
                                            unlet s:sign_queue[type][buf][ln]
                                        endif
                                    endfor
                                    if empty(s:sign_queue[type][buf])
                                        unlet s:sign_queue[type][buf]
                                    endif
                                endfor

FUNCTION  neomake#ProcessCurrentBuffer()
Called 1 time
Total time:   0.000549
 Self time:   0.000191

count  total (s)   self (s)
    1              0.000004     let buf = bufnr('%')
    1              0.000003     if has_key(s:job_output_by_buffer, buf)
                                    for output in s:job_output_by_buffer[buf]
                                        call s:ProcessJobOutput(output.maker, output.lines)
                                    endfor
                                    unlet s:job_output_by_buffer[buf]
                                endif
    1   0.000531   0.000174     call neomake#signs#PlaceVisibleSigns()

FUNCTION  <SNR>27_init()
Called 2 times
Total time:   0.028154
 Self time:   0.000300

count  total (s)   self (s)
    2              0.000003   if s:airline_initialized
    1              0.000001     return
                              endif
    1              0.000003   let s:airline_initialized = 1
                            
    1   0.004505   0.000123   call airline#extensions#load()
    1   0.001317   0.000007   call airline#init#sections()
                            
    1              0.000003   let s:theme_in_vimrc = exists('g:airline_theme')
    1              0.000001   if s:theme_in_vimrc
    1              0.000001     try
    1   0.000508   0.000105       let palette = g:airline#themes#{g:airline_theme}#palette
    1              0.000001     catch
                                  echom 'Could not resolve airline theme "' . g:airline_theme . '". Themes have been migrated to github.com/vim-airline/vim-airline-themes.'
                                  let g:airline_theme = 'dark'
                                endtry
    1   0.021767   0.000008     silent call airline#switch_theme(g:airline_theme)
    1              0.000001   else
                                let g:airline_theme = 'dark'
                                silent call s:on_colorscheme_changed()
                              endif
                            
    1              0.000021   silent doautocmd User AirlineAfterInit

FUNCTION  <SNR>22_RequirePythonHost()
Called 1 time
Total time:   0.178661
 Self time:   0.178345

count  total (s)   self (s)
    1              0.000003   let ver = (a:host.orig_name ==# 'python') ? 2 : 3
                            
                              " Python host arguments
    1              0.000002   let args = ['-c', 'import sys; sys.path.remove(""); import neovim; neovim.start_host()']
                            
                              " Collect registered Python plugins into args
    1   0.000014   0.000007   let python_plugins = remote#host#PluginsForHost(a:host.name)
    5              0.000005   for plugin in python_plugins
    4              0.000012     call add(args, plugin.path)
    4              0.000002   endfor
                            
    1              0.000001   try
    1   0.001686   0.001377     let channel_id = rpcstart((ver == '2' ? provider#python#Prog() : provider#python3#Prog()), args)
    1              0.176908     if rpcrequest(channel_id, 'poll') == 'ok'
    1              0.000007       return channel_id
                                endif
                              catch
                                echomsg v:throwpoint
                                echomsg v:exception
                              endtry
                              throw 'Failed to load '. a:host.orig_name . ' host. '. 'You can try to see what happened '. 'by starting Neovim with the environment variable '. '$NVIM_PYTHON_LOG_FILE set to a file and opening '. 'the generated log file. Also, the host stderr will be available '. 'in Neovim log, so it may contain useful information. '. 'See also ~/.nvimlog.'

FUNCTION  airline#highlighter#highlight_modified_inactive()
Called 1 time
Total time:   0.000166
 Self time:   0.000027

count  total (s)   self (s)
    1              0.000004   if getbufvar(a:bufnr, '&modified')
                                let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c') ? g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c : []
                              else
    1              0.000008     let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive.airline_c') ? g:airline#themes#{g:airline_theme}#palette.inactive.airline_c : []
    1              0.000000   endif
                            
    1              0.000001   if !empty(colors)
    1   0.000147   0.000008     call airline#highlighter#exec('airline_c'.(a:bufnr).'_inactive', colors)
    1              0.000000   endif

FUNCTION  gitgutter#highlight#match_highlight()
Called 2 times
Total time:   0.000027
 Self time:   0.000027

count  total (s)   self (s)
    2              0.000021   let matches = matchlist(a:highlight, a:pattern)
    2              0.000003   if len(matches) == 0
    2              0.000001     return 'NONE'
                              endif
                              return matches[1]

FUNCTION  airline#init#gui_mode()
Called 1 time
Total time:   0.000007
 Self time:   0.000007

count  total (s)   self (s)
    1              0.000006   return ((has('nvim') && exists('$NVIM_TUI_ENABLE_TRUE_COLOR')) || has('gui_running') || (has("termtruecolor") && &guicolors == 1)) ? 'gui' : 'cterm'

FUNCTION  dein#_chomp()
Called 1 time
Total time:   0.000004
 Self time:   0.000004

count  total (s)   self (s)
    1              0.000004   return a:str != '' && a:str[-1:] == '/' ? a:str[: -2] : a:str

FUNCTION  dein#_join_rtp()
Called 2 times
Total time:   0.000029
 Self time:   0.000029

count  total (s)   self (s)
    2              0.000028   return (stridx(a:runtimepath, '\,') < 0 && stridx(a:rtp, ',') < 0) ? join(a:list, ',') : join(map(copy(a:list), 's:escape(v:val)'), ',')

FUNCTION  airline#check_mode()
Called 1 time
Total time:   0.007444
 Self time:   0.000079

count  total (s)   self (s)
    1              0.000002   let context = s:contexts[a:winnr]
                            
    1              0.000002   if get(w:, 'airline_active', 1)
    1              0.000002     let l:m = mode()
    1              0.000001     if l:m ==# "i"
                                  let l:mode = ['insert']
                                elseif l:m ==# "R"
                                  let l:mode = ['replace']
                                elseif l:m =~# '\v(v|V||s|S|)'
                                  let l:mode = ['visual']
                                elseif l:m ==# "t"
                                  let l:mode = ['terminal']
                                else
    1              0.000002       let l:mode = ['normal']
    1              0.000001     endif
    1              0.000003     let w:airline_current_mode = get(g:airline_mode_map, l:m, l:m)
    1              0.000001   else
                                let l:mode = ['inactive']
                                let w:airline_current_mode = get(g:airline_mode_map, '__')
                              endif
                            
    1              0.000003   if g:airline_detect_modified && &modified
                                call add(l:mode, 'modified')
                              endif
                            
    1              0.000001   if g:airline_detect_paste && &paste
                                call add(l:mode, 'paste')
                              endif
                            
    1              0.000006   if g:airline_detect_crypt && exists("+key") && !empty(&key)
                                call add(l:mode, 'crypt')
                              endif
                            
    1              0.000001   if &readonly || ! &modifiable
                                call add(l:mode, 'readonly')
                              endif
                            
    1              0.000005   let mode_string = join(l:mode)
    1              0.000002   if get(w:, 'airline_lastmode', '') != mode_string
    1   0.000174   0.000008     call airline#highlighter#highlight_modified_inactive(context.bufnr)
    1   0.007206   0.000007     call airline#highlighter#highlight(l:mode)
    1              0.000002     let w:airline_lastmode = mode_string
    1              0.000000   endif
                            
    1              0.000001   return ''

FUNCTION  airline#parts#define_function()
Called 7 times
Total time:   0.000107
 Self time:   0.000031

count  total (s)   self (s)
    7   0.000105   0.000029   call airline#parts#define(a:key, { 'function': a:name })

FUNCTION  airline#extensions#ctrlp#apply()
Called 3 times
Total time:   0.000026
 Self time:   0.000026

count  total (s)   self (s)
                              " disable statusline overwrite if ctrlp already did it
    3              0.000023   return match(&statusline, 'CtrlPwhite') >= 0 ? -1 : 0

FUNCTION  <SNR>25_GetCommandPrefix()
Called 15 times
Total time:   0.001224
 Self time:   0.000140

count  total (s)   self (s)
   15   0.001219   0.000135   return 'command!'.s:StringifyOpts(a:opts, ['nargs', 'complete', 'range', 'count', 'bang', 'bar', 'register']).' '.a:name

FUNCTION  gitgutter#highlight#define_highlights()
Called 1 time
Total time:   0.000197
 Self time:   0.000084

count  total (s)   self (s)
    1   0.000127   0.000014   let [guibg, ctermbg] = gitgutter#highlight#get_background_colors('SignColumn')
                            
                              " Highlights used by the signs.
                            
    1              0.000009   execute "highlight GitGutterAddDefault    guifg=#009900 guibg=" . guibg . " ctermfg=2 ctermbg=" . ctermbg
    1              0.000007   execute "highlight GitGutterChangeDefault guifg=#bbbb00 guibg=" . guibg . " ctermfg=3 ctermbg=" . ctermbg
    1              0.000006   execute "highlight GitGutterDeleteDefault guifg=#ff2222 guibg=" . guibg . " ctermfg=1 ctermbg=" . ctermbg
    1              0.000002   highlight default link GitGutterChangeDeleteDefault GitGutterChangeDefault
                            
    1              0.000009   execute "highlight GitGutterAddInvisible    guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
    1              0.000008   execute "highlight GitGutterChangeInvisible guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
    1              0.000008   execute "highlight GitGutterDeleteInvisible guifg=bg guibg=" . guibg . " ctermfg=" . ctermbg . " ctermbg=" . ctermbg
    1              0.000003   highlight default link GitGutterChangeDeleteInvisible GitGutterChangeInvisble
                            
    1              0.000002   highlight default link GitGutterAdd          GitGutterAddDefault
    1              0.000002   highlight default link GitGutterChange       GitGutterChangeDefault
    1              0.000002   highlight default link GitGutterDelete       GitGutterDeleteDefault
    1              0.000002   highlight default link GitGutterChangeDelete GitGutterChangeDeleteDefault
                            
                              " Highlights used for the whole line.
                            
    1              0.000002   highlight default link GitGutterAddLine          DiffAdd
    1              0.000002   highlight default link GitGutterChangeLine       DiffChange
    1              0.000002   highlight default link GitGutterDeleteLine       DiffDelete
    1              0.000002   highlight default link GitGutterChangeDeleteLine GitGutterChangeLine

FUNCTION  airline#switch_theme()
Called 1 time
Total time:   0.021759
 Self time:   0.000042

count  total (s)   self (s)
    1              0.000001   try
    1              0.000003     let palette = g:airline#themes#{a:name}#palette "also lazy loads the theme
    1              0.000001     let g:airline_theme = a:name
    1              0.000001   catch
                                echohl WarningMsg | echo 'The specified theme cannot be found.' | echohl NONE
                                if exists('g:airline_theme')
                                  return
                                else
                                  let g:airline_theme = 'dark'
                                endif
                              endtry
                            
    1              0.000001   let w:airline_lastmode = ''
    1   0.014280   0.000008   call airline#load_theme()
                            
                              " this is required to prevent clobbering the startup info message, i don't know why...
    1   0.007462   0.000018   call airline#check_mode(winnr())

FUNCTION  remote#define#FunctionOnHost()
Called 11 times
Total time:   0.000383
 Self time:   0.000257

count  total (s)   self (s)
   11   0.000167   0.000041   let group = s:GetNextAutocmdGroup()
   11              0.000209   exe 'autocmd! '.group.' FuncUndefined '.a:name .' call remote#define#FunctionBootstrap("'.a:host.'"' .                                 ', "'.a:method.'"' .                                 ', "'.a:sync.'"' .                                 ', "'.a:name.'"' .                                 ', '.string(a:opts) .                                 ', "'.group.'"' .                                 ')'

FUNCTION  airline#extensions#whitespace#init()
Called 1 time
Total time:   0.000203
 Self time:   0.000183

count  total (s)   self (s)
    1   0.000026   0.000006   call airline#parts#define_function('whitespace', 'airline#extensions#whitespace#check')
                            
    1              0.000002   unlet! b:airline_whitespace_check
    1              0.000001   augroup airline_whitespace
    1              0.000165     autocmd!
    1              0.000006     autocmd CursorHold,BufWritePost * unlet! b:airline_whitespace_check
    1              0.000001   augroup END

FUNCTION  airline#extensions#ctrlp#generate_color_map()
Called 1 time
Total time:   0.000013
 Self time:   0.000013

count  total (s)   self (s)
    1              0.000012   return { 'CtrlPdark'   : a:dark, 'CtrlPlight'  : a:light, 'CtrlPwhite'  : a:white, 'CtrlParrow1' : [ a:light[1] , a:white[1] , a:light[3] , a:white[3] , ''     ] , 'CtrlParrow2' : [ a:white[1] , a:light[1] , a:white[3] , a:light[3] , ''     ] , 'CtrlParrow3' : [ a:light[1] , a:dark[1]  , a:light[3] , a:dark[3]  , ''     ] , }

FUNCTION  airline#util#getwinvar()
Called 39 times
Total time:   0.000106
 Self time:   0.000106

count  total (s)   self (s)
   39              0.000095     return getwinvar(a:winnr, a:key, a:def)

FUNCTION  <SNR>2_get_cache_version()
Called 1 time
Total time:   0.000006
 Self time:   0.000006

count  total (s)   self (s)
    1              0.000006   return getftime(s:parser_vim_path)

FUNCTION  <SNR>30_ExpandMap()
Called 1 time
Total time:   0.000016
 Self time:   0.000016

count  total (s)   self (s)
    1              0.000001   let map = a:map
    1              0.000013   let map = substitute(map, '\(<Plug>\w\+\)', '\=maparg(submatch(1), "i")', 'g')
    1              0.000001   return map

FUNCTION  gitgutter#process_buffer()
Called 1 time
Total time:   0.000669
 Self time:   0.000247

count  total (s)   self (s)
    1   0.000386   0.000129   call gitgutter#utility#set_buffer(a:bufnr)
    1   0.000017   0.000006   if gitgutter#utility#is_active()
                                if g:gitgutter_sign_column_always
                                  call gitgutter#sign#add_dummy_sign()
                                endif
                                try
                                  if !a:realtime || gitgutter#utility#has_fresh_changes()
                                    let diff = gitgutter#diff#run_diff(a:realtime || gitgutter#utility#has_unsaved_changes(), 0)
                                    if diff != 'async'
                                      call gitgutter#handle_diff(diff)
                                    endif
                                  endif
                                catch /diff failed/
                                  call gitgutter#hunk#reset()
                                endtry
                              else
    1   0.000249   0.000095     call gitgutter#hunk#reset()
    1              0.000001   endif

FUNCTION  airline#highlighter#add_accent()
Called 3 times
Total time:   0.000009
 Self time:   0.000009

count  total (s)   self (s)
    3              0.000008   let s:accents[a:accent] = 1

FUNCTION  dein#check_install()
Called 1 time
Total time:   0.000284
 Self time:   0.000267

count  total (s)   self (s)
    1   0.000034   0.000017   let plugins = empty(a:000) ? values(dein#get()) : map(copy(a:1), 'dein#get(v:val)')
                            
    1              0.000246   call filter(plugins, '!empty(v:val) && !isdirectory(v:val.path)')
    1              0.000002   if empty(plugins)
    1              0.000001     return 0
                              endif
                            
                              echomsg 'Not installed plugins: ' string(map(copy(plugins), 'v:val.name'))
                              return 1

FUNCTION  <SNR>84_get_seperator()
Called 15 times
Total time:   0.006795
 Self time:   0.000168

count  total (s)   self (s)
   15   0.002048   0.000092   if s:should_change_group(a:prev_group, a:group)
   15   0.004741   0.000069     return s:get_transitioned_seperator(a:self, a:prev_group, a:group, a:side)
                              else
                                return a:side ? a:self._context.left_alt_sep : a:self._context.right_alt_sep
                              endif

FUNCTION  gitgutter#highlight#define_sign_text_highlights()
Called 1 time
Total time:   0.000011
 Self time:   0.000011

count  total (s)   self (s)
                              " Once a sign's text attribute has been defined, it cannot be undefined or
                              " set to an empty value.  So to make signs' text disappear (when toggling
                              " off or disabling) we make them invisible by setting their foreground colours
                              " to the background's.
    1              0.000001   if g:gitgutter_signs
    1              0.000001     sign define GitGutterLineAdded            texthl=GitGutterAdd
    1              0.000001     sign define GitGutterLineModified         texthl=GitGutterChange
    1              0.000001     sign define GitGutterLineRemoved          texthl=GitGutterDelete
    1              0.000001     sign define GitGutterLineRemovedFirstLine texthl=GitGutterDelete
    1              0.000001     sign define GitGutterLineModifiedRemoved  texthl=GitGutterChangeDelete
    1              0.000001   else
                                sign define GitGutterLineAdded            texthl=GitGutterAddInvisible
                                sign define GitGutterLineModified         texthl=GitGutterChangeInvisible
                                sign define GitGutterLineRemoved          texthl=GitGutterDeleteInvisible
                                sign define GitGutterLineRemovedFirstLine texthl=GitGutterDeleteInvisible
                                sign define GitGutterLineModifiedRemoved  texthl=GitGutterChangeDeleteInvisible
                              endif

FUNCTION  AutoPairsTryInit()
Called 1 time
Total time:   0.000474
 Self time:   0.000134

count  total (s)   self (s)
    1              0.000002   if exists('b:autopairs_loaded')
                                return
                              end
                            
                              " for auto-pairs starts with 'a', so the priority is higher than supertab and vim-endwise
                              "
                              " vim-endwise doesn't support <Plug>AutoPairsReturn
                              " when use <Plug>AutoPairsReturn will cause <Plug> isn't expanded
                              "
                              " supertab doesn't support <SID>AutoPairsReturn
                              " when use <SID>AutoPairsReturn  will cause Duplicated <CR>
                              "
                              " and when load after vim-endwise will cause unexpected endwise inserted. 
                              " so always load AutoPairs at last
                              
                              " Buffer level keys mapping
                              " comptible with other plugin
    1              0.000001   if g:AutoPairsMapCR
    1              0.000003     if v:version == 703 && has('patch32') || v:version > 703
                                  " VIM 7.3 supports advancer maparg which could get <expr> info
                                  " then auto-pairs could remap <CR> in any case.
    1              0.000024       let info = maparg('<CR>', 'i', 0, 1)
    1              0.000002       if empty(info)
                                    let old_cr = '<CR>'
                                    let is_expr = 0
                                  else
    1              0.000002         let old_cr = info['rhs']
    1   0.000033   0.000017         let old_cr = s:ExpandMap(old_cr)
    1              0.000006         let old_cr = substitute(old_cr, '<SID>', '<SNR>' . info['sid'] . '_', 'g')
    1              0.000002         let is_expr = info['expr']
    1              0.000001         let wrapper_name = '<SID>AutoPairsOldCRWrapper73'
    1              0.000001       endif
    1              0.000000     else
                                  " VIM version less than 7.3
                                  " the mapping's <expr> info is lost, so guess it is expr or not, it's
                                  " not accurate.
                                  let old_cr = maparg('<CR>', 'i')
                                  if old_cr == ''
                                    let old_cr = '<CR>'
                                    let is_expr = 0
                                  else
                                    let old_cr = s:ExpandMap(old_cr)
                                    " old_cr contain (, I guess the old cr is in expr mode
                                    let is_expr = old_cr =~ '\V(' && toupper(old_cr) !~ '\V<C-R>'
                            
                                    " The old_cr start with " it must be in expr mode
                                    let is_expr = is_expr || old_cr =~ '\v^"'
                                    let wrapper_name = '<SID>AutoPairsOldCRWrapper'
                                  end
                                end
                            
    1              0.000004     if old_cr !~ 'AutoPairsReturn'
    1              0.000001       if is_expr
                                    " remap <expr> to `name` to avoid mix expr and non-expr mode
    1              0.000016         execute 'inoremap <buffer> <expr> <script> '. wrapper_name . ' ' . old_cr
    1              0.000001         let old_cr = wrapper_name
    1              0.000001       end
                                  " Always silent mapping
    1              0.000009       execute 'inoremap <script> <buffer> <silent> <CR> '.old_cr.'<SID>AutoPairsReturn'
    1              0.000000     end
    1              0.000000   endif
    1   0.000339   0.000015   call AutoPairsInit()

FUNCTION  deoplete#custom#get_source_var()
Called 2 times
Total time:   0.000025
 Self time:   0.000025

count  total (s)   self (s)
    2              0.000004   if !exists('s:custom')
    1              0.000001     let s:custom = {}
    1              0.000002     let s:custom._ = {}
    1              0.000001   endif
                            
    2              0.000004   if !has_key(s:custom, a:source_name)
    2              0.000004     let s:custom[a:source_name] = {}
    2              0.000001   endif
                            
    2              0.000003   return s:custom[a:source_name]

FUNCTION  dein#_add_dummy_commands()
Called 11 times
Total time:   0.000803
 Self time:   0.000803

count  total (s)   self (s)
   11              0.000013   if empty(a:plugin.dummy_commands)
                                call s:generate_dummy_commands(a:plugin)
                              endif
   64              0.000047   for command in a:plugin.dummy_commands
   53              0.000660     silent! execute command[1]
   53              0.000030   endfor

FUNCTION  <SNR>15_get_syn()
Called 362 times
Total time:   0.005987
 Self time:   0.005987

count  total (s)   self (s)
  362              0.000702   if !exists("g:airline_gui_mode")
                                let g:airline_gui_mode = airline#init#gui_mode()
                              endif
  362              0.001430   let color = synIDattr(synIDtrans(hlID(a:group)), a:what, g:airline_gui_mode)
  362              0.000515   if empty(color) || color == -1
  122              0.000446     let color = synIDattr(synIDtrans(hlID('Normal')), a:what, g:airline_gui_mode)
  122              0.000071   endif
  362              0.000499   if empty(color) || color == -1
   61              0.000053     let color = 'NONE'
   61              0.000028   endif
  362              0.000242   return color

FUNCTION  <SNR>84_get_prev_group()
Called 30 times
Total time:   0.000283
 Self time:   0.000283

count  total (s)   self (s)
   30              0.000040   let x = a:i - 1
   36              0.000033   while x >= 0
   33              0.000059     let group = a:sections[x][0]
   33              0.000056     if group != '' && group != '|'
   27              0.000022       return group
                                endif
    6              0.000006     let x = x - 1
    6              0.000003   endwhile
    3              0.000002   return ''

FUNCTION  AutoPairsInit()
Called 1 time
Total time:   0.000324
 Self time:   0.000176

count  total (s)   self (s)
    1              0.000002   let b:autopairs_loaded  = 1
    1              0.000001   let b:autopairs_enabled = 1
    1              0.000002   let b:AutoPairsClosedPairs = {}
                            
    1              0.000002   if !exists('b:AutoPairs')
    1              0.000003     let b:AutoPairs = g:AutoPairs
    1              0.000001   end
                            
                              " buffer level map pairs keys
    7              0.000015   for [open, close] in items(b:AutoPairs)
    6   0.000126   0.000022     call AutoPairsMap(open)
    6              0.000007     if open != close
    3   0.000053   0.000008       call AutoPairsMap(close)
    3              0.000002     end
    6              0.000012     let b:AutoPairsClosedPairs[close] = open
    6              0.000003   endfor
                            
                              " Still use <buffer> level mapping for <BS> <SPACE>
    1              0.000001   if g:AutoPairsMapBS
                                " Use <C-R> instead of <expr> for issue #14 sometimes press BS output strange words
    1              0.000006     execute 'inoremap <buffer> <silent> <BS> <C-R>=AutoPairsDelete()<CR>'
    1              0.000006     execute 'inoremap <buffer> <silent> <C-H> <C-R>=AutoPairsDelete()<CR>'
    1              0.000001   end
                            
    1              0.000001   if g:AutoPairsMapSpace
                                " Try to respect abbreviations on a <SPACE>
    1              0.000001     let do_abbrev = ""
    1              0.000002     if v:version == 703 && has("patch489") || v:version > 703
    1              0.000001       let do_abbrev = "<C-]>"
    1              0.000001     endif
    1              0.000007     execute 'inoremap <buffer> <silent> <SPACE> '.do_abbrev.'<C-R>=AutoPairsSpace()<CR>'
    1              0.000001   end
                            
    1              0.000001   if g:AutoPairsShortcutFastWrap != ''
    1              0.000007     execute 'inoremap <buffer> <silent> '.g:AutoPairsShortcutFastWrap.' <C-R>=AutoPairsFastWrap()<CR>'
    1              0.000000   end
                            
    1              0.000001   if g:AutoPairsShortcutBackInsert != ''
    1              0.000007     execute 'inoremap <buffer> <silent> '.g:AutoPairsShortcutBackInsert.' <C-R>=AutoPairsBackInsert()<CR>'
    1              0.000000   end
                            
    1              0.000001   if g:AutoPairsShortcutToggle != ''
                                " use <expr> to ensure showing the status when toggle
    1              0.000006     execute 'inoremap <buffer> <silent> <expr> '.g:AutoPairsShortcutToggle.' AutoPairsToggle()'
    1              0.000007     execute 'noremap <buffer> <silent> '.g:AutoPairsShortcutToggle.' :call AutoPairsToggle()<CR>'
    1              0.000000   end
                            
    1              0.000001   if g:AutoPairsShortcutJump != ''
    1              0.000007     execute 'inoremap <buffer> <silent> ' . g:AutoPairsShortcutJump. ' <ESC>:call AutoPairsJump()<CR>a'
    1              0.000007     execute 'noremap <buffer> <silent> ' . g:AutoPairsShortcutJump. ' :call AutoPairsJump()<CR>'
    1              0.000000   end
                            

FUNCTION  <SNR>36_isdir()
Called 1 time
Total time:   0.000005
 Self time:   0.000005

count  total (s)   self (s)
    1              0.000005   return !empty(a:dir) && (isdirectory(a:dir) || (!empty($SYSTEMDRIVE) && isdirectory('/'.tolower($SYSTEMDRIVE[0]).a:dir)))

FUNCTION  airline#extensions#apply()
Called 3 times
Total time:   0.000243
 Self time:   0.000109

count  total (s)   self (s)
    3              0.000006   let s:active_winnr = winnr()
                            
    3   0.000147   0.000013   if s:is_excluded_window()
                                return -1
                              endif
                            
    3              0.000004   if &buftype == 'help'
                                call airline#extensions#apply_left_override('Help', '%f')
                                let w:airline_section_x = ''
                                let w:airline_section_y = ''
                                let w:airline_render_right = 1
                              endif
                            
    3              0.000003   if &previewwindow
                                let w:airline_section_a = 'Preview'
                                let w:airline_section_b = ''
                                let w:airline_section_c = bufname(winbufnr(winnr()))
                              endif
                            
    3              0.000009   if has_key(s:filetype_overrides, &ft)
                                let args = s:filetype_overrides[&ft]
                                call airline#extensions#apply_left_override(args[0], args[1])
                              endif
                            
    3              0.000008   for item in items(s:filetype_regex_overrides)
                                if match(&ft, item[0]) >= 0
                                  call airline#extensions#apply_left_override(item[1][0], item[1][1])
                                endif
                              endfor

FUNCTION  airline#extensions#quickfix#apply()
Called 3 times
Total time:   0.000027
 Self time:   0.000027

count  total (s)   self (s)
    3              0.000008   if &buftype == 'quickfix'
                                let w:airline_section_a = s:get_text()
                                let w:airline_section_b = '%{get(w:, "quickfix_title", "")}'
                                let w:airline_section_c = ''
                                let w:airline_section_x = ''
                              endif

FUNCTION  remote#host#LoadRemotePlugins()
Called 1 time
Total time:   0.003512
 Self time:   0.000045

count  total (s)   self (s)
    1              0.000008   if filereadable(s:remote_plugins_manifest)
    1   0.003502   0.000036     exe 'source '.s:remote_plugins_manifest
    1              0.000001   endif

FUNCTION  remote#define#CommandOnHost()
Called 15 times
Total time:   0.002084
 Self time:   0.000861

count  total (s)   self (s)
   15              0.000017   let prefix = ''
                            
   15              0.000023   if has_key(a:opts, 'range') 
    4              0.000008     if a:opts.range == '' || a:opts.range == '%'
                                  " -range or -range=%, pass the line range in a list
    4              0.000005       let prefix = '<line1>,<line2>'
    4              0.000005     elseif matchstr(a:opts.range, '\d') != ''
                                  " -range=N, pass the count
                                  let prefix = '<count>'
                                endif
    4              0.000004   elseif has_key(a:opts, 'count')
                                let prefix = '<count>'
                              endif
                            
   15              0.000034   let forward_args = [prefix.a:name]
                            
   15              0.000021   if has_key(a:opts, 'bang')
                                call add(forward_args, '<bang>')
                              endif
                            
   15              0.000020   if has_key(a:opts, 'register')
                                call add(forward_args, ' <register>')
                              endif
                            
   15              0.000019   if has_key(a:opts, 'nargs')
   11              0.000022     call add(forward_args, ' <args>')
   11              0.000006   endif
                            
   15   0.001690   0.000466   exe s:GetCommandPrefix(a:name, a:opts) .' call remote#define#CommandBootstrap("'.a:host.'"' .                                ', "'.a:method.'"' .                                ', "'.a:sync.'"' .                                ', "'.a:name.'"' .                                ', '.string(a:opts).'' .                                ', "'.join(forward_args, '').'"' .                                ')'

FUNCTION  airline#parts#define_empty()
Called 1 time
Total time:   0.000153
 Self time:   0.000041

count  total (s)   self (s)
   10              0.000008   for key in a:keys
    9   0.000137   0.000025     call airline#parts#define_raw(key, '')
    9              0.000005   endfor

FUNCTION  airline#extensions#quickfix#init()
Called 1 time
Total time:   0.000034
 Self time:   0.000007

count  total (s)   self (s)
    1   0.000033   0.000007   call a:ext.add_statusline_func('airline#extensions#quickfix#apply')

FUNCTION  <SNR>25_GetAutocmdPrefix()
Called 6 times
Total time:   0.000152
 Self time:   0.000152

count  total (s)   self (s)
    6              0.000011   if has_key(a:opts, 'group')
    6              0.000009     let group = a:opts.group
    6              0.000004   else
                                let group = s:GetNextAutocmdGroup()
                              endif
    6              0.000013   let rv = ['autocmd!', group, a:name]
                            
    6              0.000009   if has_key(a:opts, 'pattern')
    6              0.000015     call add(rv, a:opts.pattern)
    6              0.000003   else
                                call add(rv, '*')
                              endif
                            
    6              0.000011   if has_key(a:opts, 'nested') && a:opts.nested
                                call add(rv, 'nested')
                              endif
                            
    6              0.000029   return join(rv, ' ')

FUNCTION  airline#extensions#wordcount#init()
Called 1 time
Total time:   0.000045
 Self time:   0.000027

count  total (s)   self (s)
    1   0.000023   0.000005   call a:ext.add_statusline_func('airline#extensions#wordcount#apply')
    1              0.000022   autocmd BufReadPost,CursorMoved,CursorMovedI * call s:update()

FUNCTION  airline#highlighter#load_theme()
Called 1 time
Total time:   0.007960
 Self time:   0.000031

count  total (s)   self (s)
    1              0.000001   if pumvisible()
                                return
                              endif
    1              0.000009   for winnr in filter(range(1, winnr('$')), 'v:val != winnr()')
                                call airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
                              endfor
    1   0.004026   0.000010   call airline#highlighter#highlight(['inactive'])
    1   0.003919   0.000006   call airline#highlighter#highlight(['normal'])

FUNCTION  dein#_convert2list()
Called 1 time
Total time:   0.000009
 Self time:   0.000009

count  total (s)   self (s)
    1              0.000008   return type(a:expr) ==# type([]) ? copy(a:expr) : type(a:expr) ==# type('') ?   (a:expr == '' ? [] : split(a:expr, '\r\?\n', 1)) : [a:expr]

FUNCTION  airline#highlighter#add_separator()
Called 18 times
Total time:   0.005320
 Self time:   0.000238

count  total (s)   self (s)
   18              0.000085   let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
   18   0.005228   0.000146   call <sid>exec_separator({}, a:from, a:to, a:inverse, '')

FUNCTION  <SNR>27_airline_toggle()
Called 1 time
Total time:   0.000106
 Self time:   0.000106

count  total (s)   self (s)
    1              0.000003   if exists("#airline")
                                augroup airline
                                  au!
                                augroup END
                                augroup! airline
                            
                                if exists("s:stl")
                                  let &stl = s:stl
                                endif
                            
                                silent doautocmd User AirlineToggledOff
                              else
    1              0.000002     let s:stl = &statusline
    1              0.000001     augroup airline
    1              0.000034       autocmd!
                            
    1              0.000004       autocmd CmdwinEnter * call airline#add_statusline_func('airline#cmdwinenter') | call <sid>on_window_changed()
    1              0.000003       autocmd CmdwinLeave * call airline#remove_statusline_func('airline#cmdwinenter')
                            
    1              0.000004       autocmd GUIEnter,ColorScheme * call <sid>on_colorscheme_changed()
    1              0.000021       autocmd VimEnter,WinEnter,BufWinEnter,FileType,BufUnload,VimResized * call <sid>on_window_changed()
                            
    1              0.000002       autocmd TabEnter * :unlet! w:airline_lastmode
    1              0.000005       autocmd BufWritePost */autoload/airline/themes/*.vim exec 'source '.split(globpath(&rtp, 'autoload/airline/themes/'.g:airline_theme.'.vim', 1), "\n")[0] | call airline#load_theme()
    1              0.000001     augroup END
                            
    1              0.000001     if s:airline_initialized
                                  call s:on_window_changed()
                                endif
                            
    1              0.000011     silent doautocmd User AirlineToggledOn
    1              0.000001   endif

FUNCTION  <SNR>15_exec_separator()
Called 24 times
Total time:   0.006704
 Self time:   0.000676

count  total (s)   self (s)
   24              0.000027   if pumvisible()
                                return
                              endif
   24   0.001589   0.000099   let l:from = airline#themes#get_highlight(a:from.a:suffix)
   24   0.001511   0.000097   let l:to = airline#themes#get_highlight(a:to.a:suffix)
   24              0.000064   let group = a:from.'_to_'.a:to.a:suffix
   24              0.000018   if a:inverse
    8              0.000028     let colors = [ l:from[1], l:to[1], l:from[3], l:to[3] ]
    8              0.000004   else
   16              0.000056     let colors = [ l:to[1], l:from[1], l:to[3], l:from[3] ]
   16              0.000008   endif
   24              0.000049   let a:dict[group] = colors
   24   0.003239   0.000114   call airline#highlighter#exec(group, colors)

FUNCTION  <SNR>85_build_sections()
Called 6 times
Total time:   0.001554
 Self time:   0.000271

count  total (s)   self (s)
   30              0.000030   for key in a:keys
   24              0.000056     if (key == 'warning' || key == 'error') && !a:context.active
                                  continue
                                endif
   24   0.001384   0.000101     call s:add_section(a:builder, a:context, key)
   24              0.000014   endfor

FUNCTION  gitgutter#highlight#define_sign_text()
Called 1 time
Total time:   0.000017
 Self time:   0.000017

count  total (s)   self (s)
    1              0.000004   execute "sign define GitGutterLineAdded            text=" . g:gitgutter_sign_added
    1              0.000003   execute "sign define GitGutterLineModified         text=" . g:gitgutter_sign_modified
    1              0.000003   execute "sign define GitGutterLineRemoved          text=" . g:gitgutter_sign_removed
    1              0.000003   execute "sign define GitGutterLineRemovedFirstLine text=" . g:gitgutter_sign_removed_first_line
    1              0.000003   execute "sign define GitGutterLineModifiedRemoved  text=" . g:gitgutter_sign_modified_removed

FUNCTION  airline#extensions#po#apply()
Called 3 times
Total time:   0.000024
 Self time:   0.000024

count  total (s)   self (s)
    3              0.000011   if &ft ==# 'po'
                                call airline#extensions#prepend_to_section('z', '%{airline#extensions#po#stats()}')
                                autocmd airline BufWritePost * unlet! b:airline_po_stats
                              endif

FUNCTION  airline#init#bootstrap()
Called 3 times
Total time:   0.000779
 Self time:   0.000267

count  total (s)   self (s)
    3              0.000004   if s:loaded
    2              0.000001     return
                              endif
    1              0.000001   let s:loaded = 1
                            
    1              0.000001   let g:airline#init#bootstrapping = 1
    1   0.000022   0.000012   call s:check_defined('g:airline_left_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b0":">")
    1   0.000012   0.000007   call s:check_defined('g:airline_left_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b1":">")
    1   0.000009   0.000004   call s:check_defined('g:airline_right_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b2":"<")
    1   0.000008   0.000004   call s:check_defined('g:airline_right_alt_sep', get(g:, 'airline_powerline_fonts', 0)?"\ue0b3":"<")
    1   0.000007   0.000003   call s:check_defined('g:airline_detect_modified', 1)
    1   0.000007   0.000003   call s:check_defined('g:airline_detect_paste', 1)
    1   0.000007   0.000002   call s:check_defined('g:airline_detect_crypt', 1)
    1   0.000007   0.000002   call s:check_defined('g:airline_detect_iminsert', 0)
    1   0.000006   0.000002   call s:check_defined('g:airline_inactive_collapse', 1)
    1   0.000008   0.000004   call s:check_defined('g:airline_exclude_filenames', ['DebuggerWatch','DebuggerStack','DebuggerStatus'])
    1   0.000007   0.000003   call s:check_defined('g:airline_exclude_filetypes', [])
    1   0.000007   0.000003   call s:check_defined('g:airline_exclude_preview', 0)
    1   0.000019   0.000008   call s:check_defined('g:airline_gui_mode', airline#init#gui_mode())
                            
    1   0.000007   0.000003   call s:check_defined('g:airline_mode_map', {})
    1              0.000014   call extend(g:airline_mode_map, { '__' : '------', 'n'  : 'NORMAL', 'i'  : 'INSERT', 'R'  : 'REPLACE', 'v'  : 'VISUAL', 'V'  : 'V-LINE', 'c'  : 'COMMAND', '' : 'V-BLOCK', 's'  : 'SELECT', 'S'  : 'S-LINE', '' : 'S-BLOCK', 't'  : 'TERMINAL', }, 'keep')
                            
    1   0.000007   0.000003   call s:check_defined('g:airline_theme_map', {})
    1              0.000008   call extend(g:airline_theme_map, { '\CTomorrow': 'tomorrow', 'base16': 'base16', 'mo[l|n]okai': 'molokai', 'wombat': 'wombat', 'zenburn': 'zenburn', 'solarized': 'solarized', }, 'keep')
                            
    1   0.000006   0.000003   call s:check_defined('g:airline_symbols', {})
    1              0.000019   call extend(g:airline_symbols, { 'paste': 'PASTE', 'readonly': get(g:, 'airline_powerline_fonts', 0) ? "\ue0a2" : 'RO', 'whitespace': get(g:, 'airline_powerline_fonts', 0) ? "\u2739" : '!', 'linenr': get(g:, 'airline_powerline_fonts', 0) ? "\ue0a1" : ':', 'branch': get(g:, 'airline_powerline_fonts', 0) ? "\ue0a0" : '', 'notexists': "\u2204", 'modified': '+', 'space': ' ', 'crypt': get(g:, 'airline_crypt_symbol', nr2char(0x1F512)), }, 'keep')
                            
    1   0.000247   0.000092   call airline#parts#define('mode', { 'function': 'airline#parts#mode', 'accent': 'bold', })
    1   0.000023   0.000007   call airline#parts#define_function('iminsert', 'airline#parts#iminsert')
    1   0.000017   0.000004   call airline#parts#define_function('paste', 'airline#parts#paste')
    1   0.000015   0.000003   call airline#parts#define_function('crypt', 'airline#parts#crypt')
    1   0.000015   0.000003   call airline#parts#define_function('filetype', 'airline#parts#filetype')
    1   0.000013   0.000004   call airline#parts#define('readonly', { 'function': 'airline#parts#readonly', 'accent': 'red', })
    1   0.000019   0.000005   call airline#parts#define_raw('file', '%f%m')
    1   0.000014   0.000002   call airline#parts#define_raw('path', '%F%m')
    1   0.000016   0.000007   call airline#parts#define('linenr', { 'raw': '%{g:airline_symbols.linenr}%#__accent_bold#%4l%#__restore__#', 'accent': 'bold'})
    1   0.000015   0.000003   call airline#parts#define_function('ffenc', 'airline#parts#ffenc')
    1   0.000162   0.000009   call airline#parts#define_empty(['hunks', 'branch', 'tagbar', 'syntastic', 'eclim', 'whitespace','windowswap', 'ycm_error_count', 'ycm_warning_count'])
    1   0.000019   0.000005   call airline#parts#define_text('capslock', '')
                            
    1              0.000001   unlet g:airline#init#bootstrapping

FUNCTION  remote#define#AutocmdBootstrap()
Called 1 time
Total time:   0.179091
 Self time:   0.000270

count  total (s)   self (s)
    1   0.178741   0.000021   let channel = remote#host#Require(a:host)
                            
    1              0.000186   exe 'autocmd! '.a:opts.group
    1              0.000001   if channel
    1   0.000110   0.000028     call remote#define#AutocmdOnChannel(channel, a:method, a:sync, a:name, a:opts)
    1   0.000046   0.000028     exe eval(a:forward)
    1              0.000001   else
                                exe 'augroup! '.a:opts.group
                                echoerr 'Host "'a:host.'" for "'.a:name.'" autocmd is not available'
                              endif

FUNCTION  airline#builder#new()
Called 3 times
Total time:   0.000069
 Self time:   0.000069

count  total (s)   self (s)
    3              0.000018   let builder = copy(s:prototype)
    3              0.000006   let builder._context = a:context
    3              0.000004   let builder._sections = []
                            
    3              0.000030   call extend(builder._context, { 'left_sep': g:airline_left_sep, 'left_alt_sep': g:airline_left_alt_sep, 'right_sep': g:airline_right_sep, 'right_alt_sep': g:airline_right_alt_sep, }, 'keep')
    3              0.000003   return builder

FUNCTIONS SORTED ON TOTAL TIME
count  total (s)   self (s)  function
    1   0.179091   0.000270  remote#define#AutocmdBootstrap()
    1   0.178720   0.000059  remote#host#Require()
    1   0.178661   0.178345  <SNR>22_RequirePythonHost()
    2   0.036610   0.000032  <SNR>27_on_window_changed()
    2   0.028154   0.000300  <SNR>27_init()
    1   0.021759   0.000042  airline#switch_theme()
    3   0.015128   0.003608  airline#highlighter#highlight()
    1   0.014272   0.000042  airline#load_theme()
  103   0.013967   0.004482  airline#highlighter#exec()
    3   0.013404   0.000287  airline#update_statusline()
    3   0.013108   0.000212  <SNR>28_invoke_funcrefs()
  181   0.010600   0.003347  airline#highlighter#get_highlight()
    3   0.010103   0.001215  10()
    1   0.007960   0.000031  airline#highlighter#load_theme()
    1   0.007444   0.000079  airline#check_mode()
   15   0.006795   0.000168  <SNR>84_get_seperator()
   24   0.006704   0.000676  <SNR>15_exec_separator()
  362   0.005987             <SNR>15_get_syn()
   18   0.005606   0.000286  <SNR>84_get_transitioned_seperator()
   18   0.005320   0.000238  airline#highlighter#add_separator()

FUNCTIONS SORTED ON SELF TIME
count  total (s)   self (s)  function
    1   0.178661   0.178345  <SNR>22_RequirePythonHost()
  362              0.005987  <SNR>15_get_syn()
  103   0.013967   0.004482  airline#highlighter#exec()
    3   0.015128   0.003608  airline#highlighter#highlight()
  181   0.010600   0.003347  airline#highlighter#get_highlight()
  721              0.003239  <SNR>15_Get()
    1   0.004075   0.002947  airline#extensions#load()
    1   0.003027   0.002168  dein#load_cache()
   10   0.004725   0.001460  remote#host#RegisterPlugin()
  181              0.001265  <SNR>15_get_array()
    3   0.010103   0.001215  10()
    9   0.001717   0.001212  <SNR>12_create()
   15              0.001084  <SNR>25_StringifyOpts()
   21              0.000875  <SNR>84_get_accented_line()
   15   0.002084   0.000861  remote#define#CommandOnHost()
   11              0.000803  dein#_add_dummy_commands()
    1   0.000933   0.000761  dein#end()
   30   0.000767   0.000687  <SNR>85_get_section()
   24   0.006704   0.000676  <SNR>15_exec_separator()
   24   0.001283   0.000494  <SNR>85_add_section()

