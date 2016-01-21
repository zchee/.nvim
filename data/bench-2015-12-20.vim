           00001: "                                                                                                  "
           00002: "                                                                                                  "
           00003: "                /\ \                                             __                               "
           00004: "  ____      ___ \ \ \___       __      __         ___    __  __ /\_\     ___ ___    _ __   ___    "
           00005: " /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\     /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
           00006: " \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/     /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
           00007: "   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\    \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
           00008: "                                                                                                  "
           00009: " Prefix
           00010: " autocmd             is Gautocmd
           00011: " autocmd FileType    is Gautocmdft
           00012: " //deplicated Other custom prefix is e(dit)
           00013: " //deplicated e.g. g:lightline.!e!.git_branch()
           00014: "
           00015: " Warning - prefix is It might changes.
           00016: " It varies with my mood.
           00017: 
           00018: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00019: 
           00020: " init user augroup "{{{
           00021: 
           00022: " syntax highlight's is ~/.nvim/after/syntax/vim.vim
  0.000020 00023: augroup GlobalAutoCmd
  0.000378 00024:   autocmd!
  0.000007 00025: augroup END
  0.000017 00026: command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
  0.000017 00027: command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>
           00028: 
           00029: " }}}
           00030: 
           00031: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00032: 
           00033: " Plug settings "{{{
           00034: 
           00035: " Init
  0.000359 00036: call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')
           00037: 
           00038: " Code Completion Shougo ware
  0.000157 00039: Plug 'Shougo/deoplete.nvim'
  0.000126 00040: Plug 'Shougo/context_filetype.vim'
  0.000121 00041: Plug 'Shougo/echodoc.vim'
  0.000111 00042: Plug 'Shougo/neco-syntax'
  0.000109 00043: Plug 'Shougo/neco-vim'
  0.000115 00044: Plug 'Shougo/neoinclude.vim'
  0.000111 00045: Plug 'Shougo/neopairs.vim'
  0.000109 00046: Plug 'zchee/deoplete-go'
           00047: 
           00048: " Code completion
  0.000139 00049: Plug 'Valloric/YouCompleteMe', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
  0.000138 00050: Plug 'rdnetto/YCM-Generator', { 'branch' : 'develop' }
           00051: " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
           00052: 
           00053: " Plug 'davidhalter/jedi-vim'
           00054: " Plug 'Shougo/neosnippet.vim'
           00055: " Plug 'Shougo/neosnippet-snippets'
           00056: 
           00057: " Build
  0.000134 00058: Plug 'benekastah/neomake', { 'on' : 'Neomake' }
  0.000119 00059: Plug 'thinca/vim-quickrun'
           00060: " Plug 'pgdouyon/vim-accio', { 'on' : 'Accio' }
           00061: 
           00062: " Async
  0.000135 00063: Plug 'Shougo/vimproc.vim', { 'do' : 'make -f make_mac.mak' }
  0.000116 00064: Plug 'zchee/asynchronous.nvim'
           00065: " Plug 'fmoralesc/nvimfs'
           00066: 
           00067: " Terminal
  0.000107 00068: Plug 'kassio/neoterm'
           00069: 
           00070: " Fuzzy
  0.000108 00071: Plug 'ctrlpvim/ctrlp.vim'
  0.000109 00072: Plug 'sgur/ctrlp-extensions.vim'
  0.000105 00073: Plug 'nixprime/cpsm'
           00074: 
           00075: " Interface
  0.000105 00076: Plug 'bling/vim-airline'
  0.000108 00077: Plug 'justinmk/vim-dirvish'
  0.000134 00078: Plug 'majutsushi/tagbar', { 'on' : ['Tagbar', 'TagbarToggle'] }
           00079: 
           00080: " Color
  0.000111 00081: Plug 'zchee/vim-hybrid-material'
           00082: 
           00083: " Git
  0.000112 00084: Plug 'airblade/vim-gitgutter'
           00085: " Plug 'zchee/gitgutter.nvim'
  0.000108 00086: Plug 'lambdalisue/vim-gista'
  0.000111 00087: Plug 'lambdalisue/vim-gita'
  0.000115 00088: Plug 'rhysd/committia.vim'
           00089: 
           00090: " Formatter
           00091: " Plug 'Chiel92/vim-autoformat'
  0.000110 00092: Plug 'rhysd/vim-clang-format'
           00093: 
           00094: " References
  0.000110 00095: Plug 'lambdalisue/vim-manpager'
  0.000106 00096: Plug 'rizzatti/dash.vim'
  0.000107 00097: Plug 'berdandy/AnsiEsc.vim'
  0.000107 00098: Plug 'vim-utils/vim-man'
           00099: " Plug 'thinca/vim-ref'
           00100: " Plug 'powerman/vim-plugin-viewdoc'
           00101: 
           00102: " Template
  0.000109 00103: Plug 'mattn/sonictemplate-vim'
           00104: 
           00105: " vim-operator-user
  0.000108 00106: Plug 'kana/vim-operator-user'
  0.000112 00107: Plug 'rhysd/vim-operator-surround'
           00108: " Plug 'kana/vim-operator-replace'
           00109: " Plug 'emonkak/vim-operator-comment'
           00110: " Plug 'emonkak/vim-operator-sort'
           00111: 
           00112: " Utility
  0.000107 00113: Plug 'LeafCage/yankround.vim'
  0.000108 00114: Plug 'tomtom/tcomment_vim'
           00115: " Plug 'tyru/open-browser.vim'
           00116: " Plug 'haya14busa/incsearch.vim'
           00117: " Plug 'cazador481/fakeclip.neovim'
           00118: 
           00119: " Debugging
  0.000108 00120: Plug 'critiqjo/lldb.nvim'
           00121: 
           00122: " Misc
           00123: " Plug 'mattn/benchvimrc-vim', { 'on' : 'BenchVimrc' }
  0.000121 00124: Plug 'Raimondi/delimitMate'
  0.000110 00125: Plug 'yasuharu519/vim-codic'
           00126: " Plug 'jiangmiao/auto-pairs'
           00127: " Plug 'junegunn/vim-easy-align', { 'on' : ['EasyAlign', 'LiveEasyAlign'] }
           00128: 
           00129: " }}}
           00130: 
           00131: """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00132: 
           00133: " Language syntax plugins "{{{
           00134: 
           00135: " Go
  0.000106 00136: Plug 'fatih/vim-go'
  0.000110 00137: Plug 'garyburd/go-explorer'
  0.000107 00138: Plug 'godoctor/godoctor.vim'
  0.000107 00139: Plug 'zchee/vim-go-stdlib'
           00140: 
           00141: " C family
  0.000310 00142: Plug 'vim-jp/vim-cpp', { 'for' : ['c', 'cpp', 'objc', 'objcpp'] }
           00143: 
           00144: " Swift
  0.000152 00145: Plug 'zchee/vim-swift-syntax', { 'for' : 'swift' }
           00146: 
           00147: " Python
  0.000130 00148: Plug 'nvie/vim-flake8', { 'for' : 'python' }
           00149: 
           00150: " Ruby
  0.000130 00151: Plug 'osyo-manga/vim-monster', { 'for' : 'ruby' }
           00152: 
           00153: " Dockerfile
  0.000127 00154: Plug 'ekalinin/Dockerfile.vim', { 'for' : 'Dockerfile' }
           00155: 
           00156: " Markdown
  0.000124 00157: Plug 'godlygeek/tabular', { 'for' : 'markdown' }
  0.000140 00158: Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }
           00159: 
           00160: " tmux
  0.000132 00161: Plug 'tmux-plugins/vim-tmux', { 'for' : 'tmux' }
           00162: 
           00163: " Vim Help
  0.000102 00164: Plug 'vim-jp/vimdoc-ja'
           00165: 
           00166: " ninja
  0.000122 00167: Plug 'martine/ninja', { 'rtp': '/misc', 'for' : [ 'ninja' ] }
           00168: 
           00169: " CMake
  0.000132 00170: Plug 'Kitware/CMake', { 'rtp' : '/Auxiliary', 'for' : 'cmake' }
           00171: 
  0.043874 00172: call plug#end()
  0.000733 00173: filetype plugin indent on
  0.010906 00174: syntax on
           00175: 
           00176: " }}}
           00177: 
           00178: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00179: 
           00180: " Environment variable
  0.000008 00181: let $LANG = 'ja_JP.UTF-8'
  0.000008 00182: let $MANPATH = '/usr/local/share/man:/usr/share/man:/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/share/man'
           00183: 
           00184: " Global settings "{{{
           00185: " set encoding=utf-8
  0.000011 00186: set fileencoding=utf-8
           00187: 
  0.000005 00188: let g:hybrid_use_iTerm_colors = 1
  0.000009 00189: let g:enable_bold_font = 1
  0.011289 00190: colorscheme hybrid_reverse
           00191: 
           00192: " set
  0.000009 00193: set autoindent
  0.011141 00194: set background=dark
  0.000009 00195: set cindent
  0.000008 00196: set clipboard=unnamedplus
  0.000009 00197: set cmdheight=2
           00198: " set colorcolumn=120
  0.000007 00199: set completeopt+=noinsert
  0.000007 00200: set completeopt+=noselect
  0.000007 00201: set completeopt-=preview
  0.000006 00202: set expandtab
  0.000006 00203: set helplang=ja,en
  0.000006 00204: set hidden
  0.000007 00205: set history=1000
  0.000006 00206: set ignorecase
  0.000011 00207: set laststatus=2
  0.000006 00208: set list
  0.000009 00209: set listchars=tab:»-,extends:»,precedes:«,nbsp:%,eol:↲
  0.000006 00210: set path=.
  0.000007 00211: set path+=/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include
  0.000007 00212: set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
  0.000007 00213: set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
  0.000008 00214: set path+=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/7.0.0/include
  0.000007 00215: set path+=/usr/include
  0.000006 00216: set path+=/usr/local/include
  0.000006 00217: set path+=,
  0.000006 00218: set pumheight=0 " 0 is Enable maximum displayed completion words in omnifunc list
  0.000005 00219: set ruler
  0.000005 00220: set scrolljump=1
  0.000011 00221: set scrolloff=10
  0.000006 00222: set shiftwidth=2
  0.000005 00223: set showmode
  0.000009 00224: set showtabline=2
  0.000005 00225: set smartcase
  0.000005 00226: set smartindent
  0.000005 00227: set softtabstop=2
  0.000005 00228: set tabstop=2
  0.000005 00229: set tags=tags;
  0.000006 00230: set textwidth=0
  0.000005 00231: set timeout " Mappnig timeout
  0.000005 00232: set timeoutlen=500
  0.000005 00233: set ttimeout " Keycode timeout
  0.000005 00234: set ttimeoutlen=10
  0.000006 00235: set undodir=~/.nvim/undo
  0.000014 00236: set undofile
  0.000005 00237: set updatetime=500
  0.000005 00238: set wildignore+=*.DS_Store
  0.000005 00239: set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png
  0.000006 00240: set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.so,*.out,*.class
  0.000005 00241: set wildignore+=*.swp,*.swo,*.swn
  0.000005 00242: set wildignore+=.git,.hg,.svn
  0.000005 00243: set wildmenu
  0.000006 00244: set wrap
           00245: " set iskeyword+=-
           00246: 
  0.000006 00247: set nobackup
  0.000005 00248: set noerrorbells
  0.000005 00249: set nofoldenable
  0.000005 00250: set nolazyredraw
  0.000005 00251: set nonumber
  0.000005 00252: set noswapfile
  0.000007 00253: set notitle
  0.000005 00254: set novisualbell
  0.000005 00255: set nowrapscan
  0.000010 00256: set nowritebackup
           00257: 
           00258: "}}}
           00259: 
           00260: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00261: 
           00262: " Color "{{{
  0.000010 00263: hi! SpecialKey                          gui=NONE    guifg='#25262c'    guibg=NONE
           00264: 
           00265: " Go
  0.000015 00266: Gautocmdft go highlight goErr           gui=bold guifg='#ff005f'
  0.000009 00267: Gautocmdft go match goErr /\<err\>/
  0.000009 00268: Gautocmdft go highlight goStdlib        gui=bold guifg='#81a2be'
           00269: 
           00270: " C
           00271: " Gautocmdft c,cpp,objc,objcpp highlight link cCustomFunc Function
  0.000015 00272: Gautocmdft c,cpp,objc,objcpp highlight cCustomFunc gui=NONE guifg='#f0c674'
           00273: 
           00274: "}}}
           00275: 
           00276: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00277: 
           00278: " Neovim configuration "{{{
           00279: 
           00280: " Most required absolude python path.
           00281: " Not works '~' of relative python path.
           00282: " And, installed neovim python client by `pip2or3 install git+https://github.com/neovim/python-client`
  0.000006 00283: let g:python_host_prog  = '/usr/local/bin/python2'
  0.000006 00284: let g:python3_host_prog  = '/usr/local/bin/python3'
  0.000005 00285: let g:python_host_skip_check = 1
  0.000010 00286: let g:python3_host_skip_check = 1
           00287: 
           00288: " TERM config
           00289: if exists(':terminal')
           00290:   " let g:terminal_color    = 'xterm-256color'
           00291:   " let g:terminal_color_16777216 = 1
           00292:   " Allow terminal buffer size to be very large
  0.000006 00293:   let g:terminal_scrollback_buffer_size = 100000
           00294:   " tmap: <ESC><ESC> to exit to terminal mode (switch the normal mode)
  0.000026 00295:   tnoremap <Esc><Esc> <C-\><C-n>
           00296: endif
           00297: 
           00298: " }}}
           00299: 
           00300: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00301: 
           00302: " Fix DECLRMM & DECSLRM
           00303: " DECLRMM - Left Right Margin Mode - http://www.vt100.net/docs/vt510-rm/DECLRMM
           00304: " DECSLRM - Set Left and Right Margins - http://www.vt100.net/docs/vt510-rm/DECSLRM
  0.000006 00305: let &t_ti .= "\e[?6;69h"
  0.000006 00306: let &t_te .= "\e7\e[?6;69l\e8"
  0.000005 00307: let &t_CV = "\e[%i%p1%d;%p2%ds"
  0.000007 00308: let &t_CS = "y"
           00309: 
           00310: " }}}
           00311: 
           00312: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00313: 
           00314: " Plugin settings "{{{
           00315: 
           00316: " deoplete
  0.000006 00317: let g:deoplete#auto_completion_start_length = 1
  0.000006 00318: let g:deoplete#enable_at_startup = 1
  0.000005 00319: let g:deoplete#enable_auto_pairs = 1
  0.000006 00320: let g:deoplete#omni_patterns = {}
  0.000009 00321: let g:deoplete#omni_patterns.go = ''
           00322: " let g:deoplete#omni_patterns.python = ''
  0.000006 00323: let g:deoplete#sources#go = 'vim-go'
           00324: 
           00325: " jedi for deoplete
  0.000007 00326: let g:jedi#auto_vim_configuration = 0
           00327: " let g:jedi#completions_enabled = 0
           00328: " let g:jedi#force_py_version = 3
           00329: " let g:jedi#show_call_signatures = 0
           00330: " let g:jedi#smart_auto_mappings = 0
           00331: " Gautocmdft python setlocal omnifunc=jedi#completions
           00332: 
           00333: " echodoc
  0.000006 00334: let g:echodoc_enable_at_startup = 1
           00335: 
           00336: " YouCompleteMe
  0.000005 00337: let g:ycm_auto_trigger = 1
  0.000005 00338: let g:ycm_min_num_of_chars_for_completion = 1
  0.000012 00339: let g:ycm_filetype_blacklist = {
           00340:     \ 'tagbar' : 1,
           00341:     \ 'qf' : 1,
           00342:     \ 'notes' : 1,
           00343:     \ 'vimwiki' : 1,
           00344:     \ 'pandoc' : 1,
           00345:     \ 'infolog' : 1,
           00346:     \ 'quickrun' : 1,
           00347:     \ 'markdown' : 1,
           00348:     \}
  0.000006 00349: let g:ycm_always_populate_location_list = 1
  0.000006 00350: let g:ycm_autoclose_preview_window_after_completion = 1
  0.000006 00351: let g:ycm_autoclose_preview_window_after_insertion = 1
  0.000006 00352: let g:ycm_collect_identifiers_from_comments_and_strings = 1
  0.000006 00353: let g:ycm_collect_identifiers_from_tags_files = 1
  0.000005 00354: let g:ycm_complete_in_comments = 1
  0.000005 00355: let g:ycm_confirm_extra_conf = 1
  0.000006 00356: let g:ycm_extra_conf_globlist = ['./*','../*','~/.nvim/*']
  0.000006 00357: let g:ycm_filepath_completion_use_working_dir = 1
  0.000007 00358: let g:ycm_global_ycm_extra_conf = $HOME . '/.nvim/.ycm_extra_conf.py'
  0.000006 00359: let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
  0.000009 00360: let g:ycm_key_list_select_completion = ['<Down>']
  0.000010 00361: let g:ycm_path_to_python_interpreter = '/usr/local/bin/python2'
  0.000006 00362: let g:ycm_seed_identifiers_with_syntax = 1
           00363: 
           00364: " UltiSnips
  0.000014 00365: let g:UltiSnipsUsePythonVersion = 3
  0.000009 00366: let g:UltiSnipsExpandTrigger = "<C-s>"
  0.000010 00367: let g:UltiSnipsJumpForwardTrigger = "<S-j>"
  0.000007 00368: let g:UltiSnipsJumpBackwardTrigger = "<S-k>"
           00369: 
           00370: " CtrlP
  0.000007 00371: let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
  0.000007 00372: let g:ctrlp_clear_cache_on_exit = 0
           00373: " dir, file, link, func
  0.000010 00374: let g:ctrlp_custom_ignore = {
           00375:   \ 'dir':  '\v[\/]\.(git|hg|svn)$',
           00376:   \ 'file': '\v\.(DS_Store|o|exe|so|dll)$',
           00377:   \ 'func': 'expand("%:t")',
           00378:   \ }
  0.000006 00379: let g:ctrlp_follow_symlinks = 1
  0.000008 00380: let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
  0.000006 00381: let g:ctrlp_match_window = 'bottom,order:btt'
  0.000006 00382: let g:ctrlp_mruf_default_order = 1
  0.000006 00383: let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
  0.000006 00384: let g:ctrlp_path_nolim = 1
  0.000006 00385: let g:ctrlp_show_hidden = 1
  0.000006 00386: let g:ctrlp_use_caching = 1
  0.000006 00387: let g:ctrlp_user_command = 'files -A %s'
           00388: " CtrlP : extensions
  0.000006 00389: let g:ctrlp_yankring_disable = 1
           00390: " CtrlP : cpsm
  0.000006 00391: let g:cpsm_max_threads = 8
  0.000008 00392: let g:cpsm_unicode = 1
           00393: 
           00394: " clang-format
           00395: " Ref: http://algo13.net/clang/clang-format-style-oputions.html
           00396: " FIXME: Optios not works?
           00397: " let g:clang_format#code_style = 'google'
           00398: " let g:clang_format#detect_style_file = 1
           00399: " let g:clang_format#auto_format = 1
           00400: 
           00401: " Neomake
  0.000007 00402: let g:neomake_serialize = 1
  0.000008 00403: let g:neomake_error_sign = {
           00404:         \ 'text': 'E>',
           00405:         \ 'texthl': 'ErrorMsg',
           00406:         \ }
  0.000006 00407: let g:neomake_airline = 1
           00408: 
           00409: " airline
  0.000013 00410: let g:airline_theme = 'hybridline'
           00411: if !exists('g:airline_symbols')
           00412:   let g:airline_symbols = {}
           00413: endif
  0.000006 00414: let g:airline_left_sep = ''
  0.000006 00415: let g:airline_left_alt_sep = ''
  0.000006 00416: let g:airline_right_sep = ''
  0.000006 00417: let g:airline_right_alt_sep = ''
  0.000009 00418: let g:airline_symbols.branch = ''
  0.000006 00419: let g:airline_symbols.readonly = ''
  0.000006 00420: let g:airline_symbols.linenr = ''
  0.000008 00421: let g:airline#extensions#tagbar#enabled = 0
           00422: 
           00423: " gitgutter
  0.000006 00424: let g:gitgutter_enabled = 1
  0.000006 00425: let g:gitgutter_realtime = 0
  0.000006 00426: let g:gitgutter_sign_column_always = 1
  0.000005 00427: let g:gitgutter_max_signs = 1000
  0.000005 00428: let g:gitgutter_map_keys = 0
           00429: 
           00430: " vim-dirvish
  0.000005 00431: let g:dirvish_hijack_netrw = 1
           00432: 
           00433: " vim-markdown
  0.000005 00434: let g:vim_markdown_folding_disabled = 1
           00435: 
           00436: " QuickRun
  0.000010 00437: Gautocmd BufEnter quickrun quit
  0.000006 00438: let g:quickrun_config = get(g:, 'quickrun_config', {})
  0.000011 00439: let g:quickrun_config._ = {
           00440:     \ 'runner' : 'vimproc',
           00441:     \ 'runner/vimproc/updatetime' : 50,
           00442:     \ 'outputter' : 'quickfix',
           00443:     \ 'outputter/quickfix/open_cmd' : 'copen 15',
           00444:     \ 'outputter/buffer/running_mark' : ''
           00445:     \ }
           00446: " Go
  0.000011 00447: let g:quickrun_config.go = {
           00448:     \ 'command': 'go',
           00449:     \ 'cmdopt' : 'run',
           00450:     \ 'exec': ['%c %o %s -o -'],
           00451:     \ 'outputter' : 'buffer',
           00452:     \ 'outputter/buffer/split' : 'vertical botright 80',
           00453:     \ 'outputter/buffer/close_on_empty' : 1,
           00454:     \ }
           00455: 
           00456: " C++
  0.000009 00457: let g:quickrun_config.c = {
           00458:     \ 'command' : 'clang',
           00459:     \ 'cmdopt' : '-O0',
           00460:     \ 'outputter' : 'buffer',
           00461:     \ 'outputter/buffer/split'   : ':vertical botright',
           00462:     \ 'outputter/buffer/close_on_empty' : 1,
           00463:     \ }
  0.000008 00464: let g:quickrun_config['c/llvm/error'] = {
           00465:     \ 'type' : 'c/llvm/error',
           00466:     \ 'command' : 'clang',
           00467:     \ 'cmdopt' : '-Wall -Wextra -O2',
           00468:     \ }
  0.000009 00469: let g:quickrun_config['c/llvm/run'] = {
           00470:     \ 'type' : 'c/llvm/run',
           00471:     \ 'command' : 'clang',
           00472:     \ 'cmdopt' : '-Wall -Wextra -O2',
           00473:     \ 'exec' : '%c %o -emit-llvm -S %s -o -',
           00474:     \ }
  0.000007 00475: let g:quickrun_config['c/llvm'] = {
           00476:     \ 'type' : 'c/clang',
           00477:     \ 'command' : 'clang',
           00478:     \ 'exec' : '%c %o -emit-llvm -S %s -o -',
           00479:     \ }
  0.000009 00480: let g:quickrun_config.cpp = {
           00481:     \ 'command' : 'clang++',
           00482:     \ 'cmdopt' : '-stdlib=libc++ -std=c++1y -Wall -Wextra -O2',
           00483:     \ }
  0.000013 00484: let g:quickrun_config['cpp/llvm'] = {
           00485:     \ 'type' : 'cpp/clang++',
           00486:     \ 'exec' : '%c %o -emit-llvm -S %s -o -',
           00487:     \ }
  0.000007 00488: let g:quickrun_config['cpp/gcc'] = {
           00489:     \ 'command' : 'g++',
           00490:     \ 'cmdopt' : '-std=c++11 -Wall -Wextra',
           00491:     \ }
           00492: " only preprocess
  0.000006 00493: let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
  0.000006 00494: let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
  0.000007 00495: let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }
           00496: " outputter
           00497: " Problem runner vimproc polling interval
  0.000010 00498: let g:quickrun_config['_']['runner/vimproc/updatetime'] = 50
           00499: " FIXME: Automatically quit Vim if quickfix window is the last
           00500: " Gautocmdft quickrun :quit<CR>
           00501: 
           00502: " committia.vim
  0.000009 00503: let g:committia_hooks = {}
  0.000018 00504: function! g:committia_hooks.edit_open(info)
           00505:   " Additional settings
           00506:   setlocal spell
           00507:   " If no commit message, start with insert mode
           00508:   if a:info.vcs ==# 'git' && getline(1) ==# ''
           00509:       startinsert
           00510:   end
           00511:   " Scroll the diff window from insert mode
           00512:   " Map <C-n> and <C-p>
           00513:   imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
           00514:   imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
           00515: endfunction
           00516: 
           00517: " vim-autoformat
           00518: " C
  0.000007 00519: let g:formatdef_astyle_c = '"astyle --mode=c --style=google -pcH".(&expandtab ? "s".shiftwidth() : "t")'
           00520: " let g:formatdef_astyle = '"astyle --mode=cs --style=ansi -pcHs4"'
  0.000008 00521: let g:formatters_c = ['astyle_c']
           00522: 
           00523: " tcomment_vim
           00524: " let g:tcommentMapLeader1 = 0
           00525: 
           00526: " dirvish
           00527: " http://stackoverflow.com/questions/6009698/autocmd-check-filename-in-vim
           00528: " Gautocmd BufRead * if &filetype != 'dirvish' | set autochdir | else | set noautochdir | endif
           00529: " Gautocmd BufRead * if &filetype == 'dirvish' | setlocal "ma|g/.DS_Store/d<cr>" | endif
           00530: 
           00531: " sonictemplate-vim
  0.000010 00532: let g:sonictemplate_vim_vars = {
           00533:   \ '_': {
           00534:   \   'author': 'zchee',
           00535:   \   'email': 'zchee.io@gmail.com',
           00536:   \ },
           00537:   \}
           00538: 
           00539: " }}}
           00540: 
           00541: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00542: 
           00543: " Filetype settings "{{{
           00544: 
           00545: " Go
  0.000004 00546: let g:go#use_vimproc = 1
  0.000004 00547: let g:go_auto_type_info = 0
  0.000006 00548: let g:go_def_mapping_enabled = 0
  0.000005 00549: let g:go_doc_command = 'go'
  0.000005 00550: let g:go_doc_options = 'doc'
  0.000007 00551: let g:go_fmt_autosave = 1
  0.000005 00552: let g:go_fmt_command = 'goimports'
  0.000004 00553: let g:go_fmt_experimental = 1
  0.000005 00554: let g:go_highlight_array_whitespace_error = 1
  0.000005 00555: let g:go_highlight_build_constraints = 1
  0.000005 00556: let g:go_highlight_chan_whitespace_error = 1
  0.000004 00557: let g:go_highlight_extra_types = 1
  0.000004 00558: let g:go_highlight_functions = 1
  0.000004 00559: let g:go_highlight_methods = 1
  0.000005 00560: let g:go_highlight_operators = 1
  0.000005 00561: let g:go_highlight_space_tab_error = 1
  0.000005 00562: let g:go_highlight_string_spellcheck = 1
  0.000004 00563: let g:go_highlight_structs = 1
  0.000006 00564: let g:go_highlight_trailing_whitespace_error = 1
  0.000005 00565: let g:go_snippet_engine = 'neosnippet'
  0.000004 00566: let g:go_loclist_height = 10
  0.000010 00567: Gautocmdft go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
  0.000009 00568: Gautocmd BufWritePost *.go call vimproc#system("gotags -fields +l -sort -f tags -R ./ &")
           00569: " Gautocmdft go setlocal tags+=/usr/local/go/tags
  0.000007 00570: Gautocmdft go setlocal tags+=c.tags
           00571: " Gautocmdft go syn include @CSource syntax/c.vim
           00572: 
           00573: " C family
  0.000010 00574: Gautocmdft c,cpp setlocal tags+=/usr/local/tags/c.tags
  0.000011 00575: Gautocmdft c,cpp,objc,objcpp setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
  0.000011 00576: Gautocmdft c,cpp,objc,objcpp let g:deoplete#enable_at_startup = 0
  0.000011 00577: Gautocmdft c,cpp,objc,objcpp let g:deoplete#disable_auto_complete = 1
  0.000007 00578: Gautocmd BufReadPre if &filetype=c,cpp,objc,objcpp call PlugUnload('deoplete.nvim')
  0.000021 00579: Gautocmdft c,cpp,objc,objcpp call CtagsGitRoot()
           00580: " Gautocmdft cpp setlocal matchpairs+=<:>
           00581: " let c_no_curly_error = 1 " https://github.com/vim-jp/vim-cpp/issues/16
           00582: " let c_no_bracket_error = 1
           00583: " let cpp_no_cpp11 = 1
           00584: 
           00585: " http://qiita.com/termoshtt/items/00552cbd776348f75750
           00586: " function! s:clang_format()
           00587: "   let now_line = line(".")
           00588: "   exec ":%! clang-format"
           00589: "   exec ":" . now_line
           00590: " endfunction
           00591: "
           00592: " if executable('clang-format')
           00593: "   Gautocmd BufWritePre *.c silent call s:clang_format()
           00594: " endif
           00595: 
  0.000025 00596: function! s:open_online_cpp_doc()
           00597:     let l = getline('.')
           00598: 
           00599:     if l =~# '^\s*#\s*include\s\+<.\+>'
           00600:         let header = matchstr(l, '^\s*#\s*include\s\+<\zs.\+\ze>')
           00601:         if header =~# '^boost'
           00602:             execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.matchstr(header, 'boost/\zs[^/>]\+\ze')
           00603:         else
           00604:             execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.matchstr(header, '\zs[^/>]\+\ze')
           00605:         endif
           00606:     else
           00607:         let cword = expand('<cword>')
           00608:         if cword ==# ''
           00609:             return
           00610:         endif
           00611:         let line_head = getline('.')[:col('.')-1]
           00612:         if line_head =~# 'boost::[[:alnum:]:]*$'
           00613:             execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.cword
           00614:         elseif line_head =~# 'std::[[:alnum:]:]*$'
           00615:             execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.cword
           00616:         else
           00617:             normal! K
           00618:         endif
           00619:     endif
           00620: endfunction
  0.000014 00621: Gautocmdft cpp nnoremap <silent><buffer>X :<C-u>call <SID>open_online_cpp_doc()<CR>
           00622: 
           00623: 
           00624: " Python
  0.000009 00625: Gautocmdft python setlocal tabstop=8 softtabstop=8 shiftwidth=4
           00626: 
           00627: 
           00628: " Ruby
  0.000010 00629: Gautocmdft ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
           00630: " Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
           00631: " Gautocmdft ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>
           00632: 
           00633: 
           00634: " zsh
  0.000071 00635: Gautocmd BufRead,BufNewFile .zpreztorc set filetype=zsh
           00636: " Gautocmdft zsh setlocal softtabstop=4 shiftwidth=4
           00637: 
           00638: 
           00639: " tmux
  0.000012 00640: Gautocmdft tmux nnoremap <silent><buffer> K :call tmux#man()<CR>
           00641: 
           00642: 
           00643: " markdown
  0.000021 00644: Gautocmd BufRead,BufNewFile *.md set filetype=markdown
  0.000024 00645: Gautocmd BufRead,BufNewFile *.md let g:deoplete#disable_auto_complete = 0
           00646: " Gautocmdft godoc set filetype=gedoc
           00647: 
           00648: " |inputsource|
           00649: " Japanese input auto change
           00650: " Use https://github.com/hnakamur/inputsource
           00651: " Ref http://superuser.com/questions/224161/switch-to-specific-input-source
  0.000010 00652: Gautocmd InsertLeave *.md call vimproc#system("inputsource 'com.apple.keylayout.US' &")
           00653: 
           00654: 
           00655: " Dockerfile
  0.000037 00656: Gautocmd BufRead,BufNewFile *.dockerfile,Dockerfile.* set filetype=dockerfile
  0.000013 00657: Gautocmdft Dockerfile setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 nocindent
           00658: 
           00659: 
           00660: " vim
           00661: " develop nvimrc helper
  0.000017 00662: Gautocmd BufWritePost $MYVIMRC,*.vim nested silent! source $MYVIMRC
           00663: " Gautocmd BufRead,BufNewFile $MYVIMRC, init.vim setlocal tags=$MYVIMRC . '/tags'
           00664: " Gautocmdft vim set tags=~/.nvim/tags
           00665: " Gautocmd BufWritePost $MYVIMRC cd ~/.nvim; call vimproc#system("ctags -R --fields=+l --sort=yes &")
           00666: " Gautocmd BufWritePost $MYVIMRC silent! call vimproc#system("ctags --fields=+l -f ~/.nvim/tags ~/.nvim/ &")
           00667: 
           00668: 
           00669: " Bash
           00670: " Enable bash syntax on /bin/sh shevang
           00671: " http://tyru.hatenablog.com/entry/20101007/
  0.000006 00672: let g:is_bash = 1
           00673: 
           00674: 
           00675: " Xcode
  0.000021 00676: Gautocmd BufRead,BufNewFile *.xcconfig setlocal filetype=sh " TODO Dedicated syntax
           00677: 
           00678: 
           00679: " gitconfig
  0.000009 00680: Gautocmdft gitconfig setlocal softtabstop=4 shiftwidth=4 noexpandtab
           00681: 
           00682: 
           00683: " Config files
  0.000021 00684: Gautocmd BufRead,BufNewFile .eslintrc set filetype=json " eslint
           00685: 
           00686: 
           00687: " Vagrant
  0.000021 00688: Gautocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
           00689: 
           00690: 
           00691: " Go slide
  0.000019 00692: Gautocmd BufRead,BufNewFile *.slide set filetype=goslide
  0.000017 00693: Gautocmd BufRead,BufNewFile *.slide setlocal noexpandtab tabstop=2 softtabstop=2 shiftwidth=2
  0.000019 00694: Gautocmd BufRead,BufNewFile *.slide let g:deoplete#disable_auto_complete = 1
           00695: 
           00696: " *inputsource*
           00697: " com.apple.keylayout.US:                 Apple English
           00698: " com.apple.inputmethod.Kotoeri.Roman:    Kotoeri ASCII
           00699: " com.apple.inputmethod.Kotoeri.Japanese: Kotoeri Hiragana
           00700: " com.google.inputmethod.Japanese.Roman:  Google Japanese Input ASCII
           00701: " com.google.inputmethod.Japanese.base:   Google Japanese Input Hiragana
           00702: " |inputsource|
  0.000009 00703: Gautocmd InsertEnter *.slide call vimproc#system("inputsource 'com.apple.inputmethod.Kotoeri.Japanese' &")
  0.000008 00704: Gautocmd InsertLeave *.slide call vimproc#system("inputsource 'com.apple.keylayout.US' &")
           00705: 
           00706: " vim-codic
  0.000010 00707: let g:vim_codic_access_token = "jjSSDATDsXde1Nru6yEvzl1kPSCfVVJK9v"
           00708: 
           00709: " }}}
           00710: 
           00711: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00712: 
           00713: " Temporary plugin "{{{
           00714: 
           00715: " https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
           00716: " When editing a file, always jump to the last known cursor position.  Don't
           00717: " do it when the position is invalid or when inside an event handler
           00718: " Also don't do it when the mark is in the first line, that is the default
           00719: " Posission when opening a file.
  0.000021 00720: Gautocmd BufReadPost *
           00721:     \ if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' |
           00722:     \   execute "normal! g`\"" |
           00723:     \   execute "call feedkeys('zz')" |
           00724:     \ endif
           00725: 
           00726: " Smart help window
           00727: " https://github.com/rhysd/dotfiles/blob/master/nvimrc#L380-L405
  0.000011 00728: command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)
  0.000023 00729: function! s:smart_help(args)
           00730:     try
           00731:         if winwidth(0) > winheight(0) * 2
           00732:             execute 'vertical rightbelow help ' . a:args
           00733:         else
           00734:             execute 'rightbelow help ' . a:args
           00735:         endif
           00736:     catch /^Vim\%((\a\+)\)\=:E149/
           00737:         echohl ErrorMsg
           00738:         echomsg "E149: Sorry, no help for " . a:args
           00739:         echohl None
           00740:     endtry
           00741: endfunction
           00742: 
           00743: " VimShowHlGroup: Show highlight group name under a cursor
  0.000010 00744: command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
           00745: 
           00746: " SyntaxInfo: Display syntax infomation on under the current cursor
  0.000010 00747: function! s:get_syn_id(transparent)
           00748:   let synid = synID(line("."), col("."), 1)
           00749:   if a:transparent
           00750:     return synIDtrans(synid)
           00751:   else
           00752:     return synid
           00753:   endif
           00754: endfunction
  0.000012 00755: function! s:get_syn_attr(synid)
           00756:     let name = synIDattr(a:synid, "name")
           00757:     let ctermfg = synIDattr(a:synid, "fg", "cterm")
           00758:     let ctermbg = synIDattr(a:synid, "bg", "cterm")
           00759:     let guifg = synIDattr(a:synid, "fg", "gui")
           00760:     let guibg = synIDattr(a:synid, "bg", "gui")
           00761:         return {
           00762:           \ "name": name,
           00763:           \ "ctermfg": ctermfg,
           00764:           \ "ctermbg": ctermbg,
           00765:           \ "guifg": guifg,
           00766:           \ "guibg": guibg}
           00767: endfunction
  0.000015 00768: function! s:get_syn_info()
           00769:     let baseSyn = s:get_syn_attr(s:get_syn_id(0))
           00770:     echo "name: " . baseSyn.name .
           00771:           \ " ctermfg: " . baseSyn.ctermfg .
           00772:           \ " ctermbg: " . baseSyn.ctermbg .
           00773:           \ " guifg: " . baseSyn.guifg .
           00774:           \ " guibg: " . baseSyn.guibg
           00775:     let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
           00776:     echo "link to"
           00777:     echo "name: " . linkedSyn.name .
           00778:           \ " ctermfg: " . linkedSyn.ctermfg .
           00779:           \ " ctermbg: " . linkedSyn.ctermbg .
           00780:           \ " guifg: " . linkedSyn.guifg .
           00781:           \ " guibg: " . linkedSyn.guibg
           00782: endfunction
  0.000007 00783: command! SyntaxInfo call s:get_syn_info()
           00784: 
           00785: " Set parent git directory to current path
           00786: " http://michaelheap.com/set-parent-git-directory-to-current-path-in-vim/
  0.000009 00787: function! CtagsGitRoot()
           00788:   let b:gitdir = system("git rev-parse --show-toplevel")
           00789:   if b:gitdir !~? "^fatal"
           00790:     cd `=b:gitdir`
           00791:     call vimproc#system("ctags -R --fields=+l --sort=yes &")
           00792:   endif
           00793: endfunction
           00794: 
           00795: " Json Format
  0.000008 00796: command! -nargs=0 -bang -complete=command FormatJSON %!python -m json.tool
           00797: 
           00798: " Unload plugin in runtimepath
  0.000011 00799: function! PlugUnload(name)
           00800:   execute 'set rtp-='."~/.nvim/plugged/".a:name."/"
           00801: endfunction
           00802: 
           00803: " }}}
           00804: 
           00805: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00806: 
           00807: " Keymap "{{{
           00808: " Swap semicolon and colon is move to Karabiner
           00809: 
           00810: 
           00811: " Leader Prefix
           00812: " <Space> q . (k) s
           00813: "    .    Global prefix
           00814: "    s    Window manage prefix
           00815: "    q    FileTypes specific prefix
           00816: " <Space> Leader
           00817: 
           00818: " Dvorak Center
  0.000015 00819: nnoremap <Space> <Nop>
           00820: " Dvorak Leftside
  0.000009 00821: nnoremap .       <Nop>
           00822: " Dvorak Rightside
  0.000010 00823: nnoremap f       <Nop>
           00824: 
           00825: " nnoremap .c   :let start_time = reltime()<CR> :CtrlPCmdline<CR> :echo reltimestr(reltime(start_time))<CR>
           00826: " nnoremap .u   :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
           00827: 
           00828: " Dirvish
           00829: " nnoremap <silent> .d   :set noautochdir<CR>:Dirvish<CR>
           00830: 
           00831: " CtrlP
           00832: " nnoremap .b   :CtrlPBuffer<CR>
  0.000009 00833: nnoremap .b   :CtrlPMixed<CR>
  0.000008 00834: nnoremap .c   :CtrlPCmdline<CR>
  0.000008 00835: nnoremap .d   :Dirvish<CR>
  0.000008 00836: nnoremap .y   :CtrlPYankRound<CR>
  0.000007 00837: nnoremap .n   gt
  0.000010 00838: nnoremap .p   gT
           00839: " Split and focus new buffer
  0.000008 00840: nnoremap .h   :<C-u>split<CR><C-w>w
  0.000008 00841: nnoremap .v   :<C-w>vsplit<CR><C-w>w
           00842: " Create new tab
  0.000008 00843: nnoremap .t   :<C-u>tabnew<CR>
           00844: " Focus next buffer
  0.000008 00845: nnoremap .w   <C-w>w
           00846: " Switch next or previous tab
  0.000010 00847: nnoremap .z   :bNext<CR>
           00848: 
           00849: " }}}
           00850: 
           00851: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00852: 
           00853: " Map Leader "{{{
           00854: 
  0.000005 00855: let mapleader = "\<Space>"
           00856: 
  0.000010 00857: nnoremap  <silent> <Leader>c  :call CtagsGitRoot()<CR>
  0.000010 00858: nnoremap  <silent> <Leader>h  :<C-u>SmartHelp<Space><C-l>
  0.000009 00859: nnoremap  <silent> <Leader>i  :<C-u>nohlsearch<CR>
  0.000009 00860: nnoremap  <silent> <Leader>n  :TagbarToggle<CR>
  0.000009 00861: nnoremap  <silent> <Leader>r  :<C-u>QuickRun<CR>
  0.000010 00862: nnoremap  <silent> <Leader>s  :%s///g<Left><Left><Left>
  0.000009 00863: nnoremap  <silent> <Leader>w  :<C-u>w<CR>
           00864: 
           00865: " Go
  0.000015 00866: Gautocmdft go nmap <Leader>]  :tag <c-r>=expand("<cword>")<CR><CR>
  0.000010 00867: Gautocmdft go nmap <silent> <Leader>b  <Plug>(go-build)
  0.000007 00868: Gautocmdft go nmap <silent> <Leader>d  <Plug>(go-doc)
  0.000006 00869: Gautocmdft go nmap <silent> <Leader>f  <Plug>(go-def-split)
  0.000006 00870: Gautocmdft go nmap <silent> <Leader>gi <Plug>(go-info)
  0.000013 00871: Gautocmdft go nmap <silent> <Leader>gl <Plug>(go-metalinter)
  0.000007 00872: Gautocmdft go nmap <silent> <Leader>gr <Plug>(go-rename)
  0.000006 00873: Gautocmdft go nmap <silent> <Leader>gs <Plug>(go-install)
  0.000009 00874: Gautocmdft go nmap <silent> <Leader>t  <Plug>(go-test)
           00875: 
           00876: " }}}
           00877: 
           00878: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00879: 
           00880: " Normal "{{{
           00881: 
           00882: " Disable suspend nvim
           00883: " nnoremap Z     <Nop>
           00884: " nnoremap ZZ    <Nop>
  0.000009 00885: nnoremap q     <Nop>
  0.000007 00886: nnoremap ZQ    <Nop>
  0.000011 00887: nnoremap <C-z> <Nop>
           00888: " Disable hlsearch double hit <ESC>
           00889: " Don't use Ex mode, use Q for formatting
  0.000008 00890: nnoremap Q gq
           00891: " Go to home and end using capitalized directions
  0.000007 00892: nnoremap H ^
  0.000007 00893: nnoremap <C-h> ^
  0.000008 00894: nnoremap L $
  0.000007 00895: nnoremap x "_x
  0.000008 00896: nnoremap <S-Left>  ^
  0.000008 00897: nnoremap <S-Right> $
           00898: " Jump to match pair brackets
  0.000008 00899: nnoremap <Tab> %
           00900: " http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
  0.000009 00901: nnoremap <M-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
  0.000009 00902: nnoremap <A-h> :<C-u>SmartHelp<Space><C-r><C-w><CR>
           00903: " fast scroll
  0.000007 00904: nnoremap <C-e> 2<C-e>
  0.000008 00905: nnoremap <C-y> 2<C-y>
           00906: " Jump marked header
  0.000008 00907: nnoremap zj    zjzt
  0.000007 00908: nnoremap zk    2zkzjzt
  0.000008 00909: nnoremap ZZ    :q!<CR>
           00910: 
  0.000007 00911: nnoremap <C-j> <C-m>
  0.000009 00912: nnoremap <C-k> -
           00913: 
           00914: " Enable increment | decrement when then state Visual mode
           00915: " http://vim-jp.org/blog/2015/06/30/visual-ctrl-a-ctrl-x.html
  0.000009 00916: noremap <C-a> <C-a>gv
  0.000008 00917: noremap <C-x> <C-x>gv
           00918: 
           00919: " Back to before jump list and centering buffer
  0.000008 00920: nnoremap <silent><C-o> <C-o>zz
           00921: 
           00922: " tmux like switch the next to each other of the buffer
  0.000016 00923: function! SwitchBuffer()
           00924:   if &switchbuf != "useopen"
           00925:     let saveSwitchbuf = &switchbuf
           00926:     set switchbuf=useopen
           00927:   endif
           00928:   let b:currentBuffer = expand('%:p')
           00929:   echo expand('%:p')
           00930:   " call feedkeys("\<C-w>w") | let b:sideBuffer = expand('%:p')
           00931:   exec feedkeys("\<C-w>w") echo.expand('%:p')
           00932:   " :edit b:currentBuffer<CR>
           00933:   " call feedkeys("\<C-w>w")
           00934:   " set switchbuf=expand(`=b:saveSwitchbuf`)
           00935:   " :edit b:sideBuffer<CR>
           00936: endfunction
  0.000013 00937: nnoremap zo :call SwitchBuffer()<CR>
           00938: 
           00939: " http://qiita.com/nyarla/items/8ad44a30d529443a765a
           00940: " nmap <ESC>OA <Up>
           00941: " nmap <ESC>OB <Down>
           00942: " nmap <ESC>OC <Right>
           00943: " nmap <ESC>OD <Left>
           00944: "
           00945: " }}}
           00946: 
           00947: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00948: 
           00949: " Insert "{{{
           00950: 
  0.000009 00951: inoremap <silent> qq <ESC>
  0.000020 00952: inoremap <silent> qv <ESC>
           00953: 
           00954: " YouCompleteMe complete decide words to <Enter>
           00955: " inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<CR>"
           00956: 
           00957: " Move cursor with Ctrl
           00958: " http://qiita.com/y_uuki/items/14389dbaaa43d25f3254
           00959: " inoremap <C-k> <Up>
           00960: " inoremap <C-j> <Down>
           00961: " inoremap <C-l> <Right>
           00962: " inoremap <C-h> <Left>
           00963: 
           00964: " Move to first of line
           00965: " //TODO escape sequence
  0.000010 00966: inoremap <silent> <M-h> <C-o><S-i>
           00967: " //TODO escape sequence
  0.000007 00968: inoremap <silent> <C-l> <C-o><S-a>
  0.000028 00969: inoremap <silent> <M-l> <C-o><S-a>
           00970: 
           00971: " Delete before current cursor
  0.000021 00972: inoremap <silent> <C-d>H <Esc>lc^
           00973: " Delete after current cursor
  0.000010 00974: inoremap <silent> <C-d>L <Esc>lc$
           00975: 
           00976: " Yank before current cursor
  0.000010 00977: inoremap <silent> <C-y>H <Esc>ly0<Insert>
           00978: " Yank after current cursor
  0.000014 00979: inoremap <silent> <C-y>L <Esc>ly$<Insert>
           00980: 
           00981: " http://qiita.com/nyarla/items/8ad44a30d529443a765a
           00982: " imap <ESC>OA <Up>
           00983: " imap <ESC>OB <Down>
           00984: " imap <ESC>OC <Right>
           00985: " imap <ESC>OD <Left>
           00986: 
           00987: " }}}
           00988: 
           00989: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           00990: 
           00991: " Visual "{{{
           00992: " When type 'x' key(delete), do not add yank register
  0.000010 00993: vnoremap x  "_x
  0.000010 00994: vnoremap P  "_dP
           00995: " If enable, can not multi-line replace
  0.000008 00996: vnoremap p  "_dp
  0.000010 00997: vnoremap gp p
           00998: 
           00999: " nnoremap y  "+y
           01000: " nnoremap Y  "+Y
           01001: " nnoremap dd "+Y dd
           01002: " vnoremap y  "+y
           01003: " vnoremap Y  "+Y
           01004: " vnoremap d  "+y d
           01005: " nnoremap p  "+p
           01006: " nnoremap P  "+P
           01007: 
           01008: " Search current cursor words '*' key
  0.000011 01009: vnoremap * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>
           01010: " Move to end of line to type double small 'v'
           01011: " $ is end of line, h is forward char
  0.000008 01012: vnoremap v $h
           01013: " Move to start of line
  0.000008 01014: vnoremap V ^
           01015: " Jump to match pair brackets
  0.000014 01016: vnoremap <Tab> %
           01017: 
           01018: " }}}
           01019: 
           01020: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           01021: 
           01022: " Command line "{{{
           01023: 
           01024: " Save on superuser
  0.000011 01025: cmap w!! w !sudo tee > /dev/null %
           01026: 
           01027: " }}}
           01028: 
           01029: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           01030: 
           01031: " Language mappnigs "{{{
           01032: 
  0.000005 01033: let s:hidden_all = 0
  0.000017 01034: function! ToggleHiddenAll()
           01035:     if s:hidden_all  == 0
           01036:         let s:hidden_all = 1
           01037:         set noshowmode
           01038:         set noruler
           01039:         set laststatus=0
           01040:         set noshowcmd
           01041:     else
           01042:         let s:hidden_all = 0
           01043:         set showmode
           01044:         set ruler
           01045:         set laststatus=2
           01046:         set showcmd
           01047:     endif
           01048: endfunction
           01049: 
           01050: " Go
  0.000011 01051: Gautocmdft go nmap <C-]>     <Plug>(go-def)
  0.000012 01052: Gautocmdft godoc nmap <C-]>  :<C-u>tag <c-r>=expand("<cword>")<CR><CR>
           01053: " Disable display line info when jumpback. Too hacky...
           01054: " Gautocmdft go nmap <C-o>     <C-o>:<Delete>
           01055: 
           01056: " C family
  0.000013 01057: Gautocmdft c,cpp,objc,objcpp nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>
  0.000015 01058: Gautocmdft c,cpp,objc,objcpp nnoremap <Leader>a <Plug>(altr-forward)
  0.000016 01059: Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><C-f> :pyfile /usr/local/src/llvm/tools/clang/tools/clang-format/clang-format.py<CR>
           01060: " Gautocmdft c,cpp,objc,objcpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
           01061: " Gautocmdft c,cpp,objc,objcpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
           01062: " Gautocmdft c,cpp,objc,objcpp map <buffer><Leader>x <Plug>(operator-clang-format)
           01063: 
           01064: " Python
           01065: " Gautocmdft python nnoremap <buffer> <silent> <C-]> :YcmCompleter GoTo<CR>
  0.000009 01066: Gautocmdft python nnoremap <buffer> <silent> <C-]> :call jedi#goto()<CR>
           01067: 
           01068: " Vim
           01069: " <C-u>: http://d.hatena.ne.jp/e_v_e/20150101/1420067539
  0.000012 01070: Gautocmdft vim nnoremap <silent> K :<C-u>SmartHelp<Space><C-r><C-w><CR>
           01071: 
           01072: " JavaScript
  0.000014 01073: Gautocmdft json nnoremap <silent> <leader>es :Esformatter<CR>
           01074: 
           01075: " }}}
           01076: 
           01077: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           01078: 
           01079: " Plugins mappings "{{{
           01080: 
           01081: " deoplete
           01082: " deoplete#mappings#close_popup():       Insert word on completion popup, and close popup
           01083: " deoplete#mappings#smart_close_popup(): Insert candidate and re-generate popup menu for deoplete
           01084: " deoplete#mappings#cancel_popup():      Not insert and close popup
           01085: " function! s:deoplete_smart_close()
           01086: "   return deoplete#mappings#smart_close_popup() . "\<CR>"
           01087: " endfunction
  0.000015 01088: inoremap <silent><expr><Left>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Left>"  : "\<Left>"
  0.000012 01089: inoremap <silent><expr><Right>  pumvisible() ? deoplete#mappings#cancel_popup()."\<Right>" : "\<Right>"
  0.000012 01090: inoremap <silent><expr><C-Up>   pumvisible() ? deoplete#mappings#cancel_popup()."\<Up>" : "\<C-Up>"
  0.000013 01091: inoremap <silent><expr><C-Down> pumvisible() ? deoplete#mappings#cancel_popup()."\<Down>" : "\<C-Down>"
  0.000011 01092: inoremap <silent><expr><BS>     pumvisible() ? deoplete#mappings#smart_close_popup()."\<BS>" : "\<BS>"
           01093: " inoremap <silent><expr><CR>     pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
  0.000011 01094: inoremap <silent><expr><C-t>    pumvisible() ? "\<C-r>=\<SID>deoplete_smart_close()\<CR>" : "\<C-s>"
  0.000012 01095: inoremap <silent><expr><S-Tab>  pumvisible() ? "\<S-Tab>" : deoplete#mappings#manual_complete()
           01096: 
           01097: " YouCompleteMe
           01098: " inoremap <silent><expr><CR>     pumvisible() ? "\<C-y>" : "\<CR>"
           01099: 
           01100: " neosnippet
  0.000010 01101: imap <C-s> <Plug>(neosnippet_expand_or_jump)
  0.000012 01102: smap <C-s> <Plug>(neosnippet_expand_or_jump)
           01103: 
           01104: " vim-operator-user
           01105: " operator-surround
  0.000010 01106: map <silent>sa <Plug>(operator-surround-append)
  0.000012 01107: map <silent>sd <Plug>(operator-surround-delete)
  0.000018 01108: map <silent>sr <Plug>(operator-surround-replace)
           01109: 
           01110: " vim-altr
  0.000014 01111: nmap <Leader>a  <Plug>(altr-forward)
           01112: 
           01113: " Dash.vim
  0.000013 01114: nmap <silent> <Leader>gd <Plug>DashSearch
           01115: 
           01116: " kana/Arpeggio
           01117: " call arpeggio#load()
           01118: " Arpeggiomap oc <Plug>(operator-comment)
           01119: " Arpeggiomap od <Plug>(operator-uncomment)
           01120: " Arpeggiomap sh :<C-u>tabnew<CR>:<C-u>terminal<CR>
           01121: 
           01122: " vim-Gita
  0.000012 01123: Gautocmdft 'gita-blame-navi' nnoremap <buffer>q :<C-u>q<CR>:q<CR>
           01124: 
           01125: " Tagbar
           01126: 
           01127: " for languages documents
  0.000020 01128: Gautocmdft help,ref,man,qf,godoc,gedoc,quickrun,gita-blame-navi call On_FileType_doc_define_mappings()
  0.000017 01129: function! On_FileType_doc_define_mappings()
           01130:   " Select the linked word
           01131:   nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
           01132:   " less likes keymap
           01133:   nnoremap <buffer>u <C-u>
           01134:   nnoremap <buffer>d <C-d>
           01135:   nnoremap <buffer>q :<C-u>q<CR>
           01136: endfunction
           01137: 
           01138: " incsearch
           01139: " map /  <Plug>(incsearch-forward)
           01140: " map ?  <Plug>(incsearch-backward)
           01141: " map g/ <Plug>(incsearch-stay)
           01142: 
           01143: 
           01144: " }}}
           01145: 
           01146: """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
           01147: " vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
