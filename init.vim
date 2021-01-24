"                                                                                                 "
"                 __                                                                              "
"  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                 "
"                                                                                                 "
" -------------------------------------------------------------------------------------------------
" Environment Variables:

" filetype off
filetype plugin indent off

let s:gopath         = expand('$HOME/go')
let s:gopath_src     = s:gopath . '/src/'
let s:srcpath        = expand('$HOME/src')
let s:srcpath_github = s:srcpath . '/github.com/'

" -------------------------------------------------------------------------------------------------
" GlobalAutoCmd:

augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

" -------------------------------------------------------------------------------------------------
" Global Settings:

language message C
language time C

set autoindent
set autoread
set backup
set backupdir=$XDG_DATA_HOME/nvim/backup
set belloff=all
set cindent
set cinkeys-=0#             " comments don't fiddle with indenting
set cinoptions+=:0,g0,N-1,m1
set cinoptions=''                 " See :h cinoptions-values
set clipboard+=unnamedplus
set cmdheight=2
set cmdwinheight=50
set complete=.  " .,w,b,u,t  " default: .,w,b,u,t, .
set completeopt=noinsert,noselect,menuone  " noinsert,noselect,longest,menu,menuone,preview
set concealcursor=niv
set conceallevel=0
set copyindent
set cpoptions-=_
set cscopetag
set diffopt+=hiddenoff
set directory=$XDG_DATA_HOME/nvim/swap
set emoji
set encoding=utf-8
set expandtab
set fileformats=unix,mac,dos
" set fillchars="diff:⣿,fold: ,vert:│"  " ,msgsep:‾
" set fillchars=vert:│,fold:·
set fillchars=vert:\|
set foldcolumn=0
set foldlevel=0
set foldlevelstart=99  "open all folds by default
set foldmethod=manual
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=1     " maximum fold depth
set formatoptions+=c  " Autowrap comments using textwidth - :help fo-table
set formatoptions+=j  " Delete comment character when joining commented lines
set formatoptions+=l  " do not wrap lines that have been longer when starting insert mode already
set formatoptions+=n  " Recognize numbered lists
set formatoptions+=q  " Allow formatting of comments with "gq"
set formatoptions+=r  " Insert comment leader after hitting <Enter>
set formatoptions+=t  " Auto-wrap text using textwidth
set formatoptions-=o  " Automatically insert the current comment leader after hitting 'o' or'O' in Normal mode
set grepformat=%f:%l:%c:%m
" set grepprg=rg\ -H\ --no-heading\ --smart-case\ --vimgrep
set helplang=en,ja
set hidden
set history=10000
set iminsert=0
set imsearch=0
set inccommand=nosplit
set isfname-==
set keywordprg=:Help
set langmenu=none
set laststatus=2
set linebreak
set lazyredraw
set listchars=tab:»-,trail:-,nbsp:%,extends:›,precedes:‹
" set listchars=nbsp:%,extends:›,precedes:‹ " tab:»-,trail:_,nbsp:+
set makeprg=make
set matchtime=0  " disable nvim matchparen
set maxmempattern=2000000  " default: 1000, max: 2000000
set modelines=1
set mouse=a
set number
set packpath=
set path+=$PWD/**,**
set previewheight=5
set pumblend=25
set pumheight=30
set pyxversion=3
set redrawtime=2000
set regexpengine=2
set ruler
set runtimepath-=~/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/local/share/nvim/runtime,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,~/.local/share/nvim/site/after,/etc/xdg/nvim/after
set scrollback=100000
set scrolljump=5
set scrolloff=8  " default: 0
set secure
set shiftround
set shiftwidth=2
set shortmess+=cI  " atOIc " default: filnxtToOF
set showfulltag
set showtabline=2
set sidescroll=1  " 0
set sidescrolloff=15  " 0
set signcolumn=yes:2
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set suffixes+=.pyc
set switchbuf=uselast  " useopen
set synmaxcol=3000  " default: 3000, 0: unlimited, 400, 1500, 5000
set tabstop=2
set tagcase=smart
set tags=./tags;  " http://d.hatena.ne.jp/thinca/20090723/1248286959
set termguicolors
set textwidth=0
" set title
" set titlestring=%{getpid().':'.getcwd()}
set timeout         " mappnig timeout
set timeoutlen=300  " default: 1000
set ttimeout        " keycode timeout
set ttimeoutlen=20  " default: 50
set undodir=~/.local/share/nvim/undo
set undofile
set undolevels=100000
set updatetime=100  " default: 4000
set pumblend=15
set pumheight=30
set virtualedit=block
set wildignore+=*.jpg,*.jpeg,*.bmp,*.gif,*.png            " image
set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.out,*.class  " compiler
set wildignore+=*.swp,*.swo,*.swn                         " vim
set wildignore+=*/.git,*/.hg,*/.svn                       " vcs
set wildignore+=tags,*.tags                               " tags
set wildmenu
set wildmode=longest,full
set wildoptions=pum
set winblend=20
set wrap
set writebackup

set noautochdir
set nocursorcolumn
set nocursorline
set noerrorbells
set nofoldenable
set noignorecase
set noimdisable
set nojoinspaces
set nolist
set noshiftround
set noshowcmd
set noshowmatch
set noshowmode
set nospell
set noswapfile
set novisualbell
set nowrapscan

if !isdirectory(&backupdir)
  call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
  call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
  call mkdir(&undodir, "p")
endif

if has('mac')
  set wildignore+=*.DS_Store  " macOS only

  function! s:add_macos_headers()
    let s:clt_dir        = '/Library/Developer/CommandLineTools'
    let s:sdk_dir        = s:clt_dir . '/SDKs/MacOSX.sdk'
    let s:macos_paths =
          \ expand($HOME) . '/.local/include'
          \ . ',/usr/local/include'
          \ . ',' . s:sdk_dir . '/usr/include'
          \ . ',' . s:clt_dir . '/usr/lib/clang/12.0.0/include'
          \ . ',' . s:clt_dir . '/usr/include/c++/v1'  " /Library/Developer/CommandLineTools/usr/include/c++/v1

    execute 'set path+=' . s:macos_paths
    for l:d in ['Xcode', 'MacOSX10.15.sdk', 'MacOSX11.1.sdk']
      if isdirectory(expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks/' . l:d)
        execute 'set path+=' . expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks/' . l:d
      endif
    endfor

  endfunction
  Gautocmdft c,cpp,objc,objcpp,go call s:add_macos_headers()  " only Go and C family filetypes
endif

if isdirectory('/usr/local/Frameworks/Python.framework/Headers')
  set path+=/usr/local/Frameworks/Python.framework/Headers
endif

" add $CPATH directories to &path
for s:cpath in split($CPATH, ":")
  exec 'set path+=' . s:cpath
endfor

" Automatically resize vertical splits.
"" https://github.com/knubie/dotfiles/blob/fe7967f87594/.vimrc#L136-L160
" Vertical split character
" Show line numbers and cursorline in current window
" Gautocmd WinEnter * :set winwidth=86 " 5 columns for gutter + linenum
" Gautocmd WinEnter * :wincmd =
" Gautocmd WinEnter * setlocal cursorline
" Gautocmd WinEnter * setlocal relativenumber
" Gautocmd WinEnter * setlocal number
" Gautocmd WinEnter * match
" Gautocmd CursorMoved * setlocal cursorline
" Gautocmd CursorMoved * setlocal relativenumber
" Gautocmd CursorMoved * setlocal number
" Gautocmd WinLeave * setlocal nocursorline
" Gautocmd WinLeave * setlocal norelativenumber
" Gautocmd WinLeave * setlocal nonumber
" Gautocmd WinLeave * match Comment '\%>0v.\+'

" -------------------------------------------------------------------------------------------------
" Dein:

let s:dein_cache_dir = $XDG_CACHE_HOME . '/nvim/dein'
if !isdirectory(s:dein_cache_dir)
  call mkdir(s:dein_cache_dir, 'p')
endif

" let g:dein#auto_recache = 1
let g:dein#cache_directory = s:dein_cache_dir
let g:dein#install_max_processes = 16
let g:dein#types#git#default_protocol = 'https'
let g:dein#types#git#clone_depth = 1
let g:dein#install_progress_type = 'echo'
let g:dein#install_github_api_token = $GITHUB_TOKEN

let s:dein_dir = finddir('dein.vim', '.;')
if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
  if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
    let s:dein_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . substitute(fnamemodify(s:dein_dir, ':p') , '/$', '', '')
endif

" packadd! termdebug

if dein#load_state(s:dein_cache_dir)
  call dein#begin(s:dein_cache_dir, [ expand('<sfile>') ])

  " Develop Plugins:
  call dein#local(s:gopath_src, { 'frozen': 1, 'merged': 0 }, ['github.com/zchee/nvim-go'])
  call dein#local(s:gopath_src, { 'frozen': 1, 'merged': 0 }, ['github.com/zchee/nvim-lsp'])
  call dein#local(s:srcpath_github, { 'on_ft': ['fbs'], 'frozen': 1, 'merged': 0 }, ['zchee/vim-flatbuffers'])
  call dein#local(s:srcpath_github, { 'on_ft': ['gn'], 'frozen': 1, 'merged': 0 }, ['zchee/vim-gn'])
  call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0 }, ['zchee/vim-goasm'])
  call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0 }, ['zchee/vim-go-testscript'])

  " Dein:
  call dein#add('Shougo/dein.vim')
  call dein#add('haya14busa/dein-command.vim', { 'on_cmd': ['Dein'] })

  " Deoplete:
  call dein#add('Shougo/deoplete.nvim')
  "" suorces
  call dein#local(s:srcpath_github, { 'on_ft': ['go'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-go'])
  call dein#local(s:srcpath_github, { 'on_ft': ['python', 'cython', 'pyrex'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-jedi'])
  call dein#local(s:srcpath_github, { 'on_ft': ['goasm', 'asm', 'gas', 'masm'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-asm'])
  call dein#local(s:srcpath_github, { 'on_ft': ['zsh'], 'frozen': 1, 'merged': 0 }, ['deoplete-plugins/deoplete-zsh'])
  call dein#add('Shougo/deoplete-lsp', { 'lazy': 1 })
  call dein#add('Shougo/neco-vim', { 'on_ft': ['vim'] })
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('Shougo/neosnippet.vim', { 'depends': ['neosnippet-snippets'] })
  "" support
  call dein#add('Shougo/neoinclude.vim', { 'on_ft': ['c', 'cpp', 'objc', 'objcpp', 'swift'] })  " , 'go'
  call dein#add('Shougo/echodoc.vim')
  call dein#add('Shougo/neopairs.vim')

  " Denite:
  call dein#add('Shougo/denite.nvim')
  "" dependency
  call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 1 }, ['nixprime/cpsm'])
  call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 1 }, ['raghur/fruzzy'])
  "" suorces

  " LanguageClient:
  call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0 }, ['autozimu/LanguageClient-neovim'])
  call dein#add('liuchengxu/vista.vim', { 'on_cmd': ['Vista'] })

  " Filer:
  call dein#add('Shougo/defx.nvim')
  call dein#add('kristijanhusak/defx-icons')

  " Git:
  call dein#add('airblade/vim-gitgutter')
  call dein#add('rhysd/git-messenger.vim', { 'on_cmd' : 'GitMessenger', 'on_map' : '<Plug>' })

  " Linter:
  call dein#add('dense-analysis/ale')

  " Formatter:
  call dein#add('rhysd/vim-clang-format', { 'on_cmd': ['ClangFormat', 'ClangFormatEchoFormattedCode', 'ClangFormatAutoToggle', 'ClangFormatAutoEnable', 'ClangFormatAutoDisable'], 'on_map': '<Plug>' })

  " Debugger:
  call dein#local(s:srcpath_github, { 'on_cmd': ['NvimAPI'] }, ['tweekmonster/nvim-api-viewer'])

  " Insert:

  " References:

  " TreeSitter:
  call dein#add('nvim-treesitter/nvim-treesitter', { 'merged': v:false })
  call dein#add('nvim-treesitter/nvim-treesitter-refactor', { 'depends': ['nvim-treesitter'] })
  call dein#add('nvim-treesitter/nvim-treesitter-textobjects', { 'depends': ['nvim-treesitter'] })
  call dein#add('nvim-treesitter/playground', { 'depends': ['nvim-treesitter'] })
  call dein#add('p00f/nvim-ts-rainbow', { 'depends': ['nvim-treesitter'] })

  " Interface:
  call dein#add('itchyny/lightline.vim')
  call dein#add('maximbaz/lightline-ale')
  call dein#add('mgee/lightline-bufferline')
  " call dein#add('hoob3rt/lualine.nvim')
  call dein#add('kyazdani42/nvim-web-devicons')
  call dein#add('ryanoasis/vim-devicons')
  call dein#add('voldikss/vim-floaterm', { 'on_cmd': ['FloatermNew', 'FloatermToggle', 'FloatermPrev', 'FloatermNext', 'FloatermHide'], 'on_map': ['<Plug>', '<F10>'] })
  call dein#add('easymotion/vim-easymotion', { 'on_map': '<Plug>' })
  " call dein#add('ivankovnatsky/lens.vim', { 'rev': 'patch-1' })  " camspiers/lens.vim: duplicate doc tag
  " call dein#add('camspiers/animate.vim', { 'on_source': ['lens.vim'] })

  " Operator:
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-operator-replace', { 'on_map': '<Plug>', 'depends': 'vim-operator-user' })
  call dein#add('rhysd/vim-operator-surround', { 'on_map': '<Plug>', 'depends': 'vim-operator-user' })
  call dein#add('tyru/operator-camelize.vim')

  " Utility:
  call dein#add('AndrewRadev/switch.vim', { 'on_cmd': ['Switch'], 'on_func': ['switch#Switch'] })
  call dein#add('haya14busa/vim-asterisk', { 'on_map': ['<Plug>'] })
  call dein#add('itchyny/vim-parenmatch')
  call dein#add('junegunn/vim-easy-align', { 'on_cmd': ['EasyAlign'] })
  call dein#add('rhysd/accelerated-jk')
  call dein#add('RRethy/vim-hexokinase', { 'on_cmd': ['HexokinaseToggle', 'HexokinaseRefresh'], 'build': 'make hexokinase' })
  call dein#add('RRethy/vim-illuminate', { 'on_event': ['BufEnter'] })  " automatically highlighting other uses of the current word under the cursor
  call dein#add('thinca/vim-quickrun', { 'on_cmd': ['Capture'] })
  call dein#add('tweekmonster/startuptime.vim', { 'on_cmd': ['StartupTime'] })
  call dein#add('tyru/caw.vim', { 'on_map': '<Plug>' })
  call dein#add('tyru/open-browser.vim')
  call dein#add('utahta/trans.nvim', { 'on_cmd': ['Trans'], 'build': 'make' })

  " Lifelog:
  call dein#add('wakatime/vim-wakatime')

  " -----------------------------------------------------------------------------
  " Language Plugin:

  "" Go:
  call dein#add('tweekmonster/hl-goimport.vim', { 'on_ft': ['go']})
  call dein#local(s:gopath_src,  { 'frozen': 1, 'merged': 0, 'lazy': 1, 'on_ft': ['go'] }, ['github.com/garyburd/vigor'])

  "" Cue:
  " call dein#add('jjo/vim-cue', { 'on_ft': ['cue'] })
  call dein#add('hofstadter-io/cue.vim')

  "" C Family:
  call dein#add('vim-jp/vim-cpp')
  call dein#add('bfrg/vim-cpp-modern')
  call dein#add('octol/vim-cpp-enhanced-highlight')
  "" Swift:
  call dein#add('keith/swift.vim', { 'on_ft': ['swift'] })
  "" CMake:
  call dein#add('pboettch/vim-cmake-syntax')
  call dein#add('neui/cmakecache-syntax.vim')

  "" Python:
  call dein#add('hynek/vim-python-pep8-indent')
  call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0, 'on_ft': ['cython'] }, ['lambdalisue/vim-cython-syntax'])  " call dein#add('lambdalisue/vim-cython-syntax')
  call dein#local('tweekmonster/impsort.vim', { 'frozen': 1, 'merged': 1, 'on_ft': ['python'] })

  "" Rust:
  call dein#add('rust-lang/rust.vim', { 'on_ft': ['rust'] })

  "" Docker:
  call dein#add('ekalinin/Dockerfile.vim')

  "" Kubernetes:

  "" Protobuf:
  call dein#add('uarun/vim-protobuf')

  "" OPA:
  call dein#add('tsandall/vim-rego')

  "" Bazel Starlark:
  call dein#add('cappyzawa/starlark.vim')

  "" Assembly:
  call dein#add('Shirk/vim-gas')

  "" TypeScript:
  call dein#add('HerringtonDarkholme/yats.vim')

  "" Lua:

  "" Binary:
  call dein#add('Shougo/vinarise.vim', { 'on_cmd': ['Vinarise', 'VinarisePluginDump'] })

  "" Markdown:
  call dein#add('moorereason/vim-markdownfmt', { 'on_ft': ['markdown'] })
  call dein#add('iamcco/markdown-preview.nvim', { 'on_ft': ['markdown', 'pandoc.markdown', 'rmd'], 'build': 'cd app & yarn install' })

  "" Git:
  call dein#add('gisphm/vim-gitignore')
  call dein#add('lambdalisue/gina.vim')
  call dein#add('rhysd/committia.vim', { 'on_ft': ['gitcommit'] })

  "" Vim:
  call dein#add('vim-jp/vimdoc-ja')
  call dein#add('vim-jp/syntax-vim-ex', { 'on_ft': ['vim'] })

  "" Shell:
  call dein#add('chrisbra/vim-sh-indent')

  "" Yaml:
  call dein#add('stephpy/vim-yaml')

  "" Toml:
  call dein#add('cespare/vim-toml')

  "" Json JsonC Json5:
  call dein#add('elzr/vim-json')
  call dein#add('gutenye/json5.vim')

  "" JsonSchema:

  "" GraphQL:
  call dein#add('jparise/vim-graphql')

  "" Kotlin:
  call dein#add('udalov/kotlin-vim')

  "" Tmux:
  call dein#add('tmux-plugins/vim-tmux')
  call dein#add('tmux-plugins/vim-tmux-focus-events')

  "" TerraFrom:
  call dein#add('hashivim/vim-terraform')

  "" Mustache Handlebars:
  call dein#add('mustache/vim-mustache-handlebars')

  "" Jinja2:
  call dein#add('glench/vim-jinja2-syntax')

  "" TinyScheme:  For macOS sandbox-exec profile *.sb tinyscheme filetype
  call dein#add('vim-scripts/vim-niji', { 'on_ft': ['scheme'] })

  " MacOS Modulemap:
  call dein#add('compnerd/modulemap-vim')

  "" PlantUML:
  call dein#add('aklt/plantuml-syntax')
  call dein#add('weirongxu/plantuml-previewer.vim', { 'on_ft': ['plantuml'], 'depends': ['vim-maktaba'] })

  "" Bats:
  call dein#add('aliou/bats.vim')

  " Testing Plugin:
  " call dein#add('andrewstuart/vim-kubernetes')
  " call dein#add('arakashic/chromatica.nvim')
  " call dein#add('bagrat/vim-buffet')
  " call dein#add('bufbuild/vim-buf')
  " call dein#add('cocopon/colorswatch.vim', { 'on_cmd': ['ColorSwatchGenerate'] })
  " call dein#add('cocopon/pgmnt.vim', { 'on_cmd': ['PgmntDevInspect'] })
  " call dein#add('cocopon/vaffle.vim')
  " call dein#add('davidhalter/jedi-vim', {'lazy': 1, 'on_ft': ['python', 'cython', 'pyrex'] })
  " call dein#add('dhruvasagar/vim-zoom', { 'on_func': ['zoom#toggle'] })
  " call dein#add('editorconfig/editorconfig-vim')
  " call dein#add('fatih/vim-go', { 'on_ft': ['go'], 'lazy': 1 })
  " call dein#add('godlygeek/tabular')
  " call dein#add('google/ijaas')
  " call dein#add('google/vim-searchindex')
  " call dein#add('juliosueiras/vim-terraform-completion', { 'lazy': 1 })
  " call dein#add('junegunn/fzf', { 'lazy': 1, 'on_sorce': ['autozimu/LanguageClient-neovim'], 'build': 'echo n | ./install --no-key-bindings --no-completion --no-update-rc --no-bash --no-zsh --no-fish && go build -v -o ./bin/fzf .' })
  " call dein#add('junegunn/fzf.vim', { 'lazy': 1, 'on_sorce': ['autozimu/LanguageClient-neovim']})
  " call dein#add('kana/vim-niceblock')
  " call dein#add('kristijanhusak/defx-git')
  " call dein#add('kristijanhusak/vim-carbon-now-sh')
  " call dein#add('lambdalisue/fern.vim', { 'on_cmd': 'Fern' })
  " call dein#add('liuchengxu/vim-clap')
  " call dein#add('liuchengxu/vim-which-key', { 'on_cmd': ['WhichKey'] })
  " call dein#add('luochen1990/rainbow')
  " call dein#add('mattn/benchvimrc-vim', { 'on_cmd': ['BenchVimrc'] })
  " call dein#add('mattn/sonictemplate-vim', { 'on_cmd': ['Template'] })
  " call dein#add('mbbill/undotree')
  " call dein#add('mfussenegger/nvim-dap')
  " call dein#add('mrk21/yaml-vim')
  " call dein#add('neovim/nvim-lspconfig')
  " call dein#add('norcalli/nvim-colorizer.lua')
  " call dein#add('numirias/semshi')
  " call dein#add('puremourning/vimspector')
  " call dein#add('Quramy/vison', { 'on_ft': ['json', 'jsonschema'] })
  " call dein#add('rhysd/vim-gfm-syntax', { 'on_ft': ['markdown'] })
  " call dein#add('rhysd/vim-github-support')
  " call dein#add('rhysd/vim-goyacc')
  " call dein#add('rhysd/vim-grammarous')
  " call dein#add('rhysd/wandbox-vim', { 'on_cmd': ['Wandbox', 'WandboxAsync', 'WandboxSync', 'WandboxOptionList', 'WandboxOptionListAsync', 'WandboxAbortAsyncWorks', 'WandboxOpenBrowser']})
  " call dein#add('rickhowe/diffchar.vim')
  " call dein#add('sakhnik/nvim-gdb')
  " call dein#add('scrooloose/nerdtree', { 'on_cmd': ['NERDTree', 'NERDTreeVCS', 'NERDTreeFromBookmark', 'NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeMirror', 'NERDTreeClose', 'NERDTreeFind', 'NERDTreeCWD', 'NERDTreeRefreshRoot'] })
  " call dein#add('scrooloose/vim-slumlord')
  " call dein#add('sheerun/vim-polyglot', { 'lazy' : 1 })
  " call dein#add('Shougo/context_filetype.vim')
  " call dein#add('Shougo/deoppet.nvim')
  " call dein#add('Shougo/neco-syntax')
  " call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  " call dein#add('simnalamburt/vim-mundo')
  " call dein#add('theHamsta/nvim-dap-virtual-text')
  " call dein#add('tmsvg/pear-tree', { 'on_event': 'InsertEnter' })
  " call dein#add('tpope/vim-fugitive')
  " call dein#add('tweekmonster/helpful.vim', { 'on_cmd': ['HelpfulVersion'] })
  " call dein#add('tweekmonster/wstrip.vim')
  " call dein#add('tyru/open-browser-github.vim', { 'on_cmd': ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq'], 'depends': ['open-browser.vim'] })
  " call dein#add('tyru/open-browser-unicode.vim', { 'on_cmd': ['OpenBrowserUnicode'], 'depends': ['open-browser.vim'] })
  " call dein#add('uber/prototool', { 'rtp':'vim/prototool' })
  " call dein#add('vim-airline/vim-airline')
  " call dein#add('vim-airline/vim-airline-themes', { 'depends': ['vim-airline/vim-airline'] })
  " call dein#add('wellle/targets.vim')
  " call dein#add('zchee/vim-go-slide')

  " call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0 }, ['neoclide/coc.nvim'])
  " call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0, 'lazy': 1 }, ['Valloric/YouCompleteMe'])
  " call dein#local(s:srcpath_github, { 'frozen': 1, 'merged': 0, 'on_ft': ['go', 'asm', 'gomod'] }, ['fatih/vim-go'])

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable
colorscheme equinusocio_material

" load lua plugin configs
lua require('plugins')

" -------------------------------------------------------------------------------------------------
"" Neovim:

let g:termdebugger = '/usr/local/bin/gdb'
let g:termdebug_useFloatingHover = 1

function! s:nvim_terminal_config()
  if exists('g:loaded_nvim_terminal_config')
    silent! finish
  endif
  let g:loaded_nvim_terminal_config = 1

  let g:terminal_scrollback_buffer_size = 100000
  let s:num = 0
  "        black      red        green      yellow     blue       magenta    cyan       white
  for s:color in [
        \ '#101112', '#b24e4e', '#9da45a', '#f0c674', '#5f819d', '#85678f', '#5e8d87', '#707880',
        \ '#373b41', '#cc6666', '#a0a85c', '#f0c674', '#81a2be', '#b294bb', '#8abeb7', '#c5c8c6',
        \ ]
    let g:terminal_color_{s:num} = s:color
    let s:num += 1
  endfor
endfunction
Gautocmd TermOpen * call s:nvim_terminal_config()
Gautocmd TermOpen * setlocal nonumber sidescrolloff=0 scrolloff=0 statusline=%{b:term_title} notimeout ttimeout timeoutlen=100
Gautocmd BufNewFile,BufRead,BufEnter term://* startinsert
Gautocmd BufLeave term://* stopinsert

" -------------------------------------------------------------------------------------------------
" Color:

"" Go:
let g:go_highlight_error = 1
let g:go_highlight_return = 0

"" C:
let g:c_ansi_constants = 1
let g:c_ansi_typedefs = 1
let g:c_comment_strings = 1
let g:c_gnu = 0
let g:c_no_curly_error = 1
let g:c_no_tab_space_error = 1
let g:c_no_trail_space_error = 1
let g:c_syntax_for_h = 0

" CPP:
let g:cpp_class_scope_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" Perl:
let perl_include_pod = 1
let perl_no_scope_in_variables = 0
let perl_no_extended_vars = 0
let perl_string_as_statement = 1
let perl_no_sync_on_sub = 0
let perl_no_sync_on_global_var = 0
let perl_sync_dist = 100

" -------------------------------------------------------------------------------------------------
" Gautocmd:

" Global:
Gautocmd InsertLeave * setlocal nopaste

" always jump to the last known cursor position
" - https://github.com/neovim/neovim/blob/master/runtime/vimrc_example.vim
function! s:autoJump()
  if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' && &filetype != 'gitrebase'
    execute "silent! keepjumps normal! g`\"zz"
  endif
endfunction
Gautocmd BufWinEnter * call s:autoJump()

" automatically close window
" - http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
function! s:autoClose()
  let s:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if winnr('$') == 1
    if s:ft == 'qf' || s:ft == 'git' ||  s:ft == 'vista_kind'
      quit!
    endif
  endif
endfunction
Gautocmd WinEnter * call s:autoClose()

" macOS Frameworks and system header protection
Gautocmd BufNewFile,BufReadPost /System/Library/*,/Applications/Xcode*,/usr/include*,/usr/lib* setlocal readonly nomodified

"" less like mapping:
function! LessMap()
  setlocal colorcolumn=""
  let b:gitgutter_enabled = 0
  nnoremap <silent><buffer>u <C-u>
  nnoremap <silent><buffer>d <C-d>
  nnoremap <silent><buffer>q :q<CR>
endfunction
Gautocmdft godoc://*,godoc,help,man,qf,quickrun,ref,fern call LessMap()  " less like keymappnig
Gautocmd BufEnter option-window,__LanguageClient__,__GO_TEST__ call LessMap()  " :option have not filetype


" Plugins:
"" Neosnippet:
Gautocmd InsertLeave * NeoSnippetClearMarkers

"" Gina:
Gautocmd BufEnter gina://*:commit startinsert
Gautocmd BufEnter gina://* nnoremap <silent><buffer>q :q<CR>

"" Man:
Gautocmdft man://* nmap  <buffer><nowait>j  <Plug>(accelerated_jk_gj_position)
Gautocmdft man://* nmap  <buffer><nowait>k  <Plug>(accelerated_jk_gk_position)


" Language:
"" Go:

"" C:

"" Protobuf:

"" Dockerfile:

" Python:

" Vim:
"" nested autoload
Gautocmdft vim setlocal tags+=$XDG_DATA_HOME/nvim/tags/runtime.tags
Gautocmdft qf hi Search  gui=None  guifg=None  guibg=#373b41
Gautocmd   BufEnter **/colors/*.vim,**/colorscheme/*.vim silent! HexokinaseTurnOn
Gautocmd   BufEnter $XDG_CONFIG_HOME/kitty/*.conf  silent! HexokinaseTurnOn
Gautocmd   BufEnter $XDG_CONFIG_HOME/alacritty/*.yml  silent! HexokinaseTurnOn

"" Gitcommit:
Gautocmd BufEnter COMMIT_EDITMSG  startinsert

"" Yaml:

"" Misc:
Gautocmdft jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000

" -------------------------------------------------------------------------------------------------
" Plugin Setting:

"" LSP:
" LLVM Library Path
if isdirectory('/opt/llvm/devel')
  let s:llvm_base_path = '/opt/llvm/devel'
  let s:llvm_clang_version = '12.0.0'
elseif isdirectory('/opt/llvm/stable')
  let s:llvm_base_path = '/opt/llvm/stable'
  let s:llvm_clang_version = '10.0.1'
elseif isdirectory('/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr')
  let s:llvm_base_path = '/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr'
  let s:llvm_clang_version = '12.0.0'
elseif isdirectory('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr')
  let s:llvm_base_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr'
  let s:llvm_clang_version = '12.0.0'
elseif isdirectory('/Library/Developer/CommandLineTools/usr')
  let s:llvm_base_path = '/Library/Developer/CommandLineTools/usr'
  let s:llvm_clang_version = '11.0.3'
else
  echoerr 'not found s:llvm_base_path and s:llvm_clang_version'
endif

if isdirectory('/Applications/Xcode-beta.app')
  let s:xcode_path = '/Applications/Xcode-beta.app'
elseif isdirectory('/Applications/Xcode.app')
  let s:xcode_path = '/Applications/Xcode.app'
endif

let s:clang_flags = [
      \ '-I'.s:llvm_base_path.'/include/c++/v1',
      \ '-I'.s:llvm_base_path.'/lib/clang'.s:llvm_clang_version.'/include',
      \ '-I/usr/local/include',
      \ '-I'.$SDKROOT.'/usr/include',
      \ '-F'.s:xcode_path.'/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks',
      \ '-F'.s:xcode_path.'/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks',
      \
      \ '-isystem '.s:llvm_base_path.'/lib/clang/12.0.0',
      \ '-isysroot'.$SDKROOT,
      \
      \ '-mmacosx-version-min=10.15',
      \ ]  " clang++ -v -E -x c++ - -v < /dev/null
      "\ '-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include',
      "\ '-I' . s:llvm_base_path . '/include/c++/v1',
      "\ '-I' . s:llvm_base_path . '/include/c++/v1',
      "\ '-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3',
      "\ '-isysroot/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk',
      "\ '-isystem ' . s:llvm_base_path . '/lib/clang/' . s:llvm_clang_version,

let g:clangd_commands_cfamily = [
      \ '/opt/llvm/devel/bin/clangd',
      \
      \ '--all-scopes-completion',
      \ '--async-preamble',
      \ '--clang-tidy',
      \ '--collect-main-file-refs',
      \ '--compile_args_from=filesystem',
      \ '--completion-parse=auto',
      \ '--completion-style=detailed',
      \ '--cross-file-rename',
      \ '--folding-ranges',
      \ '--function-arg-placeholders',
      \ '--header-insertion-decorators',
      \ '--header-insertion=iwyu',
      \ '--include-ineligible-results',
      \ '--j=16',
      \ '--offset-encoding=utf-16',
      \ '--pch-storage=memory',
      \ '--recovery-ast',
      \ '--recovery-ast-type',
      \ '--resource-dir='.s:llvm_base_path.'/lib/clang/'.s:llvm_clang_version,
      \ '--static-func-full-module-prefix',
      \ '--suggest-missing-includes',
      \ '--query-driver='.s:llvm_base_path.'/bin/clang-*,'.s:llvm_base_path.'/bin/clang++-*',
      \ ]  " --resource-dir: $ /opt/llvm/devel/bin/clang -print-resource-dir
      "\ '--info-output-file=/tmp/clangd.info.log', '--input-mirror-file=/tmp/clangd.lsp.log', '--log=verbose', '--pretty', '--input-style=standard', '--offset-encoding=utf-8',

let g:c_cpp_root_path = ''
Gautocmdft c,cpp,objc,objcpp ++once let g:c_cpp_root_path = fnamemodify(trim(finddir('.git', '.;'), '.git'), ':p:h')

let g:did_server_commands_cfamily_setup = v:false
function! s:clangd_commands_cfamily_setup() abort
  if g:did_server_commands_cfamily_setup
    return
  endif
  let g:did_server_commands_cfamily_setup = v:true

  " clangd.dex
  if filereadable(getcwd() . '/../build/clangd.dex')
    let g:clangd_commands_cfamily += ['--index-file=' . getcwd() . '/../build/clangd.dex']
  elseif filereadable(g:c_cpp_root_path . '/build/clangd.dex')
    let g:clangd_commands_cfamily += ['--index-file=' . g:c_cpp_root_path . '/build/clangd.dex']
  elseif filereadable(getcwd() . 'clangd.dex')
    let g:clangd_commands_cfamily += ['--index-file=' . getcwd() . '/clangd.dex']
  elseif filereadable(g:c_cpp_root_path . '/clangd.dex')
    let g:clangd_commands_cfamily += ['--index-file=' . g:c_cpp_root_path . '/clangd.dex']

  " compile_commands.json
  elseif filereadable(glob("`find " . getcwd() . " -maxdepth 1 -type d -iwholename '*build*' `").'/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . glob("`find " . getcwd() . " -maxdepth 1 -type d -iwholename '*build*' `")]
  elseif filereadable(getcwd() . '/../build/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . getcwd() . '/../build']
  elseif filereadable('compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . getcwd()]
  elseif filereadable(g:c_cpp_root_path . '/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . g:c_cpp_root_path]
  elseif filereadable(g:c_cpp_root_path . '/build/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . g:c_cpp_root_path . '/build']
  elseif filereadable(g:c_cpp_root_path . '/out/Release/compile_commands.json')
    let g:clangd_commands_cfamily += ['--compile-commands-dir=' . g:c_cpp_root_path . '/out/Release']
  else
    let g:clangd_commands_cfamily += ['--index']
  endif
endfunction
Gautocmdft c,cpp,objc,objcpp,cuda call s:clangd_commands_cfamily_setup()

let s:lsp_root_markers_cfamily = ['WORKSPACE', '.clang-format', 'autogen.sh', 'configure', 'compile_commands.json']
let s:lsp_root_markers_go = ['go.mod', 'Gopkg.toml']
let s:lsp_root_markers_js = ['package.json', 'yarn.lock']
let s:lsp_root_markers_python = ['setup.py', 'pyproject.toml', 'tox.ini', '.flake8']
let s:lsp_root_markers_rust = ['Cargo.toml', 'build.rs', 'rustfmt.toml']
let s:lsp_root_markers = {
      \ 'c': s:lsp_root_markers_cfamily,
      \ 'cpp': s:lsp_root_markers_cfamily,
      \ 'go': s:lsp_root_markers_go,
      \ 'javascript': s:lsp_root_markers_js,
      \ 'lua': ['.git'],
      \ 'objc': s:lsp_root_markers_cfamily,
      \ 'objcpp': s:lsp_root_markers_cfamily,
      \ 'python': s:lsp_root_markers_python,
      \ 'ruby': ['Gemfile', '.git'],
      \ 'rust': s:lsp_root_markers_rust,
      \ 'typescript': s:lsp_root_markers_js,
      \ 'yaml': ['.git'],
      \ }

"" GoNvimSP:
let g:nvim_lsp_server_commands = {
      \ 'go': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-remote=unix;/tmp/gopls.sock', '-logfile=/tmp/gopls.log'],
      \ }
      "\ 'go': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-remote=unix;/tmp/gopls.sock', '-logfile=/tmp/gopls.log', '-debug=localhost:75699'],
      "\ 'rust': ['rustup', 'run', 'nightly', 'rust-analyzer', '-vv', '--log-file=/tmp/rust-analyzer.log'],
      "\ 'yaml': [s:srcpath_github . 'redhat-developer/yaml-language-server/bin/yaml-language-server', '--stdio'],
let g:nvim_lsp#server_options = {}
"      \ 'go': {
"      \   'env': [
"      \   ]}
"      \ }
let g:nvim_lsp_server_auto_start = v:true
let g:nvim_lsp#change_throttle = 0.5
let g:nvim_lsp_debug = v:true
let g:nvim_lsp_enable_diagnostics = v:true
let g:nvim_lsp_settings_paths = [ '.nvim/settings.json', $XDG_CONFIG_HOME.'/nvim/lsp/settings.json' ]
let g:nvim_lsp_root_markers = s:lsp_root_markers
let g:nvim_lsp_hover_highlight = 'Normal:NormalFloat'
let g:nvim_lsp_use_virtual_text = v:true
let g:nvim_lsp_diagnostics_list = 'location-list'
let g:nvim_lsp_selection_ui_type = 'quickfix'
let g:nvim_lsp_selection_ui_auto_open = v:true
let g:nvim_lsp_logLevel = 'debug'
" let g:nvim_lsp#diagnostics_display = {
"     \ 1: {
"     \      'name': 'Error',
"     \      'texthl': 'ALEError',
"     \      'signText': '✖',
"     \      'signTexthl': 'ALEErrorSign',
"     \      'virtualTexthl': 'Error',
"     \    },
"     \ 2: {
"     \      'name': 'Warning',
"     \      'texthl': 'ALEWarning',
"     \      'signText': '⚠',
"     \      'signTexthl': 'ALEWarningSign',
"     \      'virtualTexthl': 'Todo',
"     \    },
"     \ 3: {
"     \      'name': 'Information',
"     \      'texthl': 'ALEInfo',
"     \      'signText': 'ℹ',
"     \      'signTexthl': 'ALEInfoSign',
"     \      'virtualTexthl': 'Todo',
"     \    },
"     \ 4: {
"     \      'name': 'Hint',
"     \      'texthl': 'ALEInfo',
"     \      'signText': '➤',
"     \      'signTexthl': 'ALEInfoSign',
"     \      'virtualTexthl': 'Todo',
"     \    },
"     \ }
" let g:nvim_lsp_debug_profile_cpu = '/tmp/go/nvim-lsp-cpu.pprof'
" let g:nvim_lsp_debug_profile_memory = '/tmp/go/memory.pprof'
" let g:nvim_lsp_debug_profile_trace = '/tmp/go/trace.pprof'

function! s:nvim_lsp_setup()
  setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
  nmap     <silent><buffer><C-]>              <Plug>(nvim-lsp-textdocument-definition)
  nnoremap <silent><buffer><C-]>v             :<C-u>call LSPTextDocumentDefinition('vsplit')<CR>
  nmap     <nowait><silent><buffer>K          <Plug>(nvim-lsp-textdocument-hover)
  nnoremap <silent><buffer><LocalLeader>gh    :<C-u>call LanguageClient#textDocument_signatureHelp()<CR>
  nmap     <silent><buffer><LocalLeader>gdh   <Plug>(lcn-highlight)
  nmap     <silent><buffer><LocalLeader>gi    <Plug>(nvim-lsp-textdocument-implementation)
  nmap     <silent><buffer><LocalLeader>gr    <Plug>(nvim-lsp-textdocument-references)
  nmap     <silent><buffer><LocalLeader>gs    <Plug>(nvim-lsp-textdocument-symbol)
  nmap     <silent><buffer><LocalLeader>gt    <Plug>(nvim-lsp-textdocument-typedefinition)

  nmap     <nowait><silent><buffer><Leader>e  <Plug>(lcn-rename)
  nmap     <nowait><silent><buffer><Leader>K  <Plug>(lcn-hover)
  nmap     <silent><buffer><LocalLeader>]     <Plug>(lcn-definition)
endfunction
Gautocmdft go call s:nvim_lsp_setup()


"" LanguageClient:

let g:LanguageClient_serverCommands = {
      \ 'c': g:clangd_commands_cfamily,
      \ 'cmake': ['cmake-language-server'],
      \ 'cpp': g:clangd_commands_cfamily,
      \ 'dockerfile': ['docker-langserver', '--stdio'],
      \ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ 'java': ['jdtls', '-data', getcwd()],
      \ 'javascript': ['javascript-typescript-stdio'],
      \ 'json': ['vscode-json-languageserver', '--stdio'],
      \ 'json5': ['vscode-json-languageserver', '--stdio'],
      \ 'jsonc': ['vscode-json-languageserver', '--stdio'],
      \ 'jsonschema': ['vscode-json-languageserver', '--stdio'],
      \ 'lua': [s:srcpath_github . 'sumneko/lua-language-server/bin/macOS/lua-language-server', '-E', '-e', 'LANG=en', s:srcpath_github . 'sumneko/lua-language-server/main.lua'],
      \ 'objc': g:clangd_commands_cfamily,
      \ 'objcpp': g:clangd_commands_cfamily,
      \ 'python': ['/usr/local/share/pipx/pyls'],
      \ 'ruby': ['solargraph', 'stdio'],
      \ 'rust': ['rustup', 'run', 'nightly', 'rust-analyzer', '-vv', '--log-file=/tmp/rust-analyzer.log'],
      \ 'sh': ['bash-language-server', 'start'],
      \ 'swift': ['sourcekit-lsp', '--build-path', $XDG_CACHE_HOME.'/sourcekit-lsp', '-c', 'release', '--log-level', 'debug'],
      \ 'typescript': ['typescript-language-server', '--stdio', '--tsserver-path=/usr/local/var/nodebrew/current/bin/tsserver'],
      \ 'vim': ['vim-language-server', '--stdio'],
      \ 'yaml': ['yaml-language-server', '--stdio'],
      \ 'yaml.docker-compose': ['yaml-language-server', '--stdio'],
      \ }
      "\ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock', '-logfile=/tmp/gopls-lcn.log'],
      "\ 'go': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-remote=unix;/tmp/gopls.sock', '-logfile=/tmp/gopls-lcn.log'],
      "\ 'go': [s:gopath . '/bin/gopls'],
      "\ 'lua': ['java', '-cp', '/usr/local/share/java/EmmyLua/EmmyLua-LS-all.jar', 'com.tang.vscode.MainKt'],
      "\ 'lua': ['lua-lsp'],
      "\ 'lua': [s:srcpath_github . 'sumneko/lua-language-server/bin/macOS/lua-language-server', '-E', '-e', 'LANG=en', s:srcpath_github . 'sumneko/lua-language-server/main.lua'],
      "\ 'proto': [s:gopath . '/bin/protocol-buffers-language-server'],
      "\ 'python': ['/usr/local/share/pipx/pyls', '--log-file=/tmp/pyls.log', '--verbose'],
      "\ 'python': ['/usr/local/share/pipx/pyls'],
      "\ 'python': ['pyright-langserver', '--stdio'],
      "\ 'rust': ['/usr/local/rust/cargo/bin/rustup', 'run', 'nightly', 'rls'],
      "\ 'rust': ['rustup', 'run', 'nightly', 'rust-analyzer', '-vv', '--log-file=/tmp/rust-analyzer.log'],
      "\ 'swift': ['/usr/local/bin/sourcekit-lsp'],

let g:LanguageClient_diagnosticsSignsMax                = v:null
let g:LanguageClient_changeThrottle                     = 0.5  " default: v:null, 0.5
let g:LanguageClient_autoStart                          = 1
let g:LanguageClient_autoStop                           = 0
let g:LanguageClient_selectionUI                        = 'location-list'  " fzf, quickfix, location-list
let g:LanguageClient_selectionUI_autoOpen               = 1
let g:LanguageClient_trace                              = 'off'  " 'verbose'
let g:LanguageClient_diagnosticsList                    = 'Disabled'  " default: Quickfix, Location, Disabled
let g:LanguageClient_diagnosticsEnable                  = 0
let g:LanguageClient_windowLogMessageLevel              = 'Error'  " default: Warning, available: 'Error' 'Warning' 'Info' 'Log'
let g:LanguageClient_settingsPath                       = [$XDG_CONFIG_HOME . '/nvim/lsp/lcn.json']
let g:LanguageClient_loadSettings                       = 1
let g:LanguageClient_rootMarkers                        = s:lsp_root_markers
let g:LanguageClient_fzfOptions                         = v:null
let g:LanguageClient_hasSnippetSupport                  = 0
let g:LanguageClient_waitOutputTimeout                  = 0  " default: 10
let g:LanguageClient_hoverPreview                       = 'Always'  " Always, Auto, Never
let g:LanguageClient_fzfContextMenu                     = 0
let g:LanguageClient_completionPreferTextEdit           = 0
let g:LanguageClient_useVirtualText                     = "All"
let g:LanguageClient_useFloatingHover                   = 1
let g:LanguageClient_floatingHoverHighlight             = 'Normal:HoverFloat'
let g:LanguageClient_virtualTextPrefix                  = ''
let g:LanguageClient_diagnosticsMaxSeverity             = 'Hint'  " Default: 'Hint', 'Error' 'Warning' 'Information' 'Hint'
let g:LanguageClient_echoProjectRoot                    = 1
let g:LanguageClient_semanticHighlightMaps              = {}
let g:LanguageClient_applyCompletionAdditionalTextEdits = 1
let g:LanguageClient_preferredMarkupKind                = ['plaintext', 'markdown']  " 'plaintext'
Gautocmdft go,python,yaml,zsh let g:LanguageClient_diagnosticsEnable = 0
" debug
" let g:LanguageClient_serverStderr = '/tmp/lcn.server.log'
" let g:LanguageClient_loggingFile  = '/tmp/lcn.client.log'
" let g:LanguageClient_loggingLevel = 'DEBUG'  " default: WARN

function! LanguageClientCallback(output, ...) abort
  normal! zz
endfunction

function! s:languageclient_mapping_setup()
  " setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
  nnoremap <silent><buffer><C-]>              :<C-u>call LanguageClient#textDocument_definition({'handle': v:true}, function('LanguageClientCallback'))<CR>
  nnoremap <silent><buffer><C-]>v             :<C-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit', 'handle': v:true}, function('LanguageClientCallback'))<CR>
  nmap     <nowait><silent><buffer>K          <Plug>(lcn-hover)
  nnoremap <silent><buffer><LocalLeader>gh    :<C-u>call LanguageClient#textDocument_signatureHelp()<CR>
  nmap     <silent><buffer><LocalLeader>gdh   <Plug>(lcn-highlight)
  nmap     <silent><buffer><LocalLeader>gi    <Plug>(lcn-implementation)
  nmap     <silent><buffer><LocalLeader>gr    <Plug>(lcn-references)
  nmap     <silent><buffer><LocalLeader>gs    <Plug>(lcn-symbols)
  nnoremap <silent><buffer><LocalLeader>gt    :<C-u>call LanguageClient#textDocument_typeDefinition({'handle': v:true}, function('LanguageClientCallback'))<CR>
  nmap     <nowait><silent><buffer><Leader>e  <Plug>(lcn-rename)
endfunction
Gautocmdft c,cmake,cpp,dockerfile,java,javascript,json,jsonc,jsonschema,lua,objc,objcpp,proto,python,ruby,rust,sh,swift,typescript,vim,yaml,yaml.docker-compose call s:languageclient_mapping_setup()

function! s:languageclient_settings_setup()
  " let g:lcn_default_settings = json_decode(readfile($XDG_CONFIG_HOME . '/nvim/lsp/lcn.json'))
  " Gautocmd User LanguageClientStarted call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': g:lcn_default_settings })

  let g:lcn_settings_filepath = '/.nvim/lcn.json'
  let g:lcn_settings = ''
  if filereadable(getcwd() . g:lcn_settings_filepath)
    let g:lcn_settings = json_decode(readfile(getcwd() . g:lcn_settings_filepath))
  endif

  if !empty(g:lcn_settings)
    Gautocmd User LanguageClientTextDocumentDidOpenPost call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': g:lcn_settings })  " workspace/configuration, workspace/didChangeConfiguration, LanguageClientStarted, LanguageClientTextDocumentDidOpenPost
  endif
endfunction
Gautocmdft go,c,cmake,cpp,dockerfile,java,javascript,json,jsonc,jsonschema,lua,objc,objcpp,proto,python,ruby,rust,sh,swift,typescript,vim,yaml,yaml.docker-compose call s:languageclient_settings_setup()

"" Deoplete:
let g:deoplete#enable_at_startup = 1
let s:default_ignore_sources = ['ale', 'around', 'dictionary', 'floaterm', 'lsp', 'member', 'omni', 'tag', 'LanguageClient']
let s:deoplete_custom_option = {
      \ 'auto_complete': v:true,
      \ 'auto_complete_delay': 0,
      \ 'auto_complete_popup': 'auto',
      \ 'auto_refresh_delay': 20,
      \ 'camel_case': v:true,
      \ 'check_stderr': v:true,
      \ 'complete_suffix': v:true,
      \ 'ignore_case': &ignorecase,
      \ 'ignore_sources': {
      \   '_': s:default_ignore_sources,
      \   'c': s:default_ignore_sources,
      \   'cpp': s:default_ignore_sources,
      \   'dockerfile': s:default_ignore_sources,
      \   'go': s:default_ignore_sources+['buffer'],
      \   'javascript': s:default_ignore_sources,
      \   'lua': s:default_ignore_sources,
      \   'objc': s:default_ignore_sources+['buffer'],
      \   'proto': s:default_ignore_sources,
      \   'python': s:default_ignore_sources,
      \   'rust': s:default_ignore_sources,
      \   'sh': s:default_ignore_sources,
      \   'swift': s:default_ignore_sources,
      \   'typescript': s:default_ignore_sources,
      \   'yaml': s:default_ignore_sources,
      \   'yaml.docker-compose': s:default_ignore_sources+['buffer'],
      \   'zsh': s:default_ignore_sources,
      \ },
      \ 'max_list': 10000,
      \ 'min_pattern_length': 1,
      \ 'num_processes': 4,
      \ 'on_insert_enter': v:true,
      \ 'on_text_changed_i': v:true,
      \ 'prev_completion_mode': '',
      \ 'profile': v:false,
      \ 'refresh_always': v:true,
      \ 'refresh_backspace': v:true,
      \ 'skip_multibyte': v:false,
      \ 'smart_case': &smartcase,
      \ 'trigger_key': v:char,
      \ }
call deoplete#custom#option(s:deoplete_custom_option)
Gautocmdft python call deoplete#custom#option('ignore_sources', { 'python': ['ale', 'around', 'dictionary', 'floaterm', 'lsp', 'member', 'omni', 'tag', 'LanguageClient'] })
call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])  " matcher_fuzzy, matcher_full_fuzzy, matcher_cpsm, matcher_head, matcher_length
call deoplete#custom#source('_', 'sorters', ['sorter_rand', 'sorter_word'])  " 'sorter_word', 'sorter_rand'
call deoplete#custom#source('_', 'converters', ['converter_auto_paren', 'converter_remove_overlap'])

call deoplete#custom#source('buffer', 'rank', 100)
call deoplete#custom#source('file', 'rank', 150)
call deoplete#custom#source('file', 'enable_buffer_path', v:true)
call deoplete#custom#source('file', 'force_completion_length', -1)

" call deoplete#custom#source('go', 'auto_refresh_delay', 1000)
" call deoplete#custom#source('go', 'matchers', ['matcher_fuzzy', 'matcher_length'])
" call deoplete#custom#source('go', 'sorters', ['sorter_word'])
" call deoplete#custom#source('go', 'is_debug_enabled', v:true)

call deoplete#custom#source('LanguageClientInternal', 'sorters', [])
call deoplete#custom#source('LanguageClientInternal', 'max_menu_width', 50)
call deoplete#custom#source('LanguageClientInternal', 'max_candidates', 1000)
call deoplete#custom#source('LanguageClientInternal', 'converters', ['converter_auto_paren_lsp', 'converter_auto_paren', 'converter_remove_overlap'])
" Gautocmdft json,jsonschema,yaml call deoplete#custom#source('LanguageClientInternal', 'min_pattern_length', 0)

call deoplete#custom#source('asm', 'rank', 1000)
call deoplete#custom#source('neosnippet', 'rank', 500)
call deoplete#custom#source('neosnippet', 'converters', ['converter_remove_overlap'])
call deoplete#custom#source('zsh', 'filetypes', ['zsh', 'sh'])
" call deoplete#custom#source('zsh', 'refresh_always', v:true)

" source
"" go
let g:deoplete#sources#go#gocode_binary = s:gopath.'/bin/gocode'
let g:deoplete#sources#go#auto_goos = 0
let g:deoplete#sources#go#pointer = 0
let g:deoplete#sources#go#cgo = 1
let g:deoplete#sources#go#cgo_only = 1
let g:deoplete#sources#go#cgo#flags = s:clang_flags
let g:deoplete#sources#go#cgo#libclang_path = s:llvm_base_path.'/lib/libclang.dylib'
let g:deoplete#sources#go#cgo#sort_algo = 'priority'  " 'priority', 'alphabetical'
"" clang
let g:deoplete#sources#clang#clang_header = s:llvm_base_path.'/lib/clang'  " s:llvm_base_path . '/lib/clang'
let g:deoplete#sources#clang#libclang_path = s:llvm_base_path.'/lib/libclang.dylib' " s:llvm_base_path . '/lib/libclang.dylib'
let g:deoplete#sources#clang#flags = s:clang_flags
"" jedi
let g:deoplete#sources#jedi#statement_length = 0
let g:deoplete#sources#jedi#short_types = 0
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#enable_typeinfo = 1
let g:deoplete#sources#jedi#ignore_errors = 1
let g:deoplete#sources#jedi#extra_path = []
let g:deoplete#sources#jedi#python_path = g:python3_host_prog
" asm
let g:deoplete#sources#asm#go_mode = 1
" debug
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', '/tmp/deoplete.log')
" call deoplete#custom#source('LanguageClientInternal', 'is_debug_enabled', v:true)

" neosnippet
let g:neosnippet#data_directory = $XDG_CACHE_HOME . '/nvim/neosnippet'
" let g:neosnippet#disable_runtime_snippets = {}
let g:neosnippet#disable_select_mode_mappings = 0
let g:neosnippet#enable_auto_clear_markers = 1
let g:neosnippet#enable_complete_done = 0
let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#expand_word_boundary = 0
let g:neosnippet#snippets_directory = $XDG_CONFIG_HOME . '/nvim/neosnippets'
let g:neosnippet_username = 'zchee'
let g:neosnippet_author = 'Koichi Shiraishi'
" echodoc
Gautocmd BufWinEnter * call echodoc#enable()
let g:echodoc#events = ['CompleteDone']  " default
let g:echodoc#type = 'signature'  " echo, signature, virtual, floating
let g:echodoc#highlight_identifier = 'Identifier'  " default
let g:echodoc#highlight_arguments = 'Special'  " default
let g:echodoc#highlight_trailing = 'Type'  " default
let g:echodoc_max_blank_lines = 3  " hidden params
highlight link EchoDocFloat HoverFloat
" neopairs
let g:neopairs#enable = 1
let g:neopairs#pairs = { '[': ']', '<': '>', '(': ')', '{': '}', '"': '"' }


"" Denite:
call denite#custom#option('_', {
      \ 'auto_action': "",
      \ 'auto_resize': v:false,
      \ 'buffer_name': 'default',
      \ 'cursor_pos': '',
      \ 'cursorline': v:true,
      \ 'default_action': 'default',
      \ 'direction': 'botright',
      \ 'do': '',
      \ 'empty': v:false,
      \ 'highlight_filter_background': 'NormalFloat',
      \ 'highlight_matched_char': 'Search',
      \ 'highlight_matched_range': 'Underlined',
      \ 'highlight_preview_line': 'Search',
      \ 'highlight_prompt': 'Special',
      \ 'highlight_window_background': 'NormalFloat',
      \ 'ignorecase': v:false,
      \ 'immediately': v:false,
      \ 'immediately_1': v:false,
      \ 'matchers': 'matcher/fruzzy',
      \ 'prompt': '>',
      \ 'sorter': 'sorter/word',
      \ 'split': 'floating',
      \ 'filter_split_direction': 'floating',
      \ 'vertical_preview': v:true,
      \ 'floating_preview': v:true,
      \ 'smartcase': v:false,
      \ 'statusline': v:true,
      \ 'unique': v:true,
      \ 'winheight': 20,
      \ })
let s:denite_file_rec_command = ['fd', '.', '--threads=16', '--follow', '--hidden', '--no-ignore', '--full-path', '--color=never', '--type=f',
      \ '-E', '.git/',
      \ '-E', 'node_modules/',
      \ '-E', '*.bak',
      \ '-E', '*.o',
      \ '-E', '*.obj',
      \ '-E', '*.pdb',
      \ '-E', '*.exe',
      \ '-E', '*.bin',
      \ '-E', '*.dll',
      \ '-E', '*.a',
      \ '-E', '*.lib',
      \ '-E', '.gitignore',
      \ '-E', '.*.*',
      \ ]
call denite#custom#var('file/rec', 'command', s:denite_file_rec_command)
call denite#custom#var('file/rec', 'cache_threshold', 100000)
call denite#custom#option('file/rec', 'expand', v:true)

call denite#custom#var('grep', {
  \ 'command': ['rg'],
  \ 'default_opts': ['-i', '--no-config', '--no-ignore-vcs', '--threads=16', '--mmap', '--hidden', '--no-heading', '--vimgrep', '--glob=!.git', '--glob=!node_modules'],
  \ 'recursive_opts': [],
  \ 'pattern_opt': ['--regexp'],
  \ 'separator': ['--'],
  \ 'final_opts': [],
  \ })

"" map
function! DeniteActionZZ() abort
  normal! zz
endfunction
function! s:denite_mapping() abort
  nnoremap <silent><buffer>      <C-c>  :<C-u>quit<CR>
  nnoremap <silent><buffer><expr><C-v>  denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr><CR>   denite#do_map('do_action', 'open', function('DeniteActionZZ'))
  nnoremap <silent><buffer>      q      :<C-u>quit<CR>
  nnoremap <silent><buffer><expr>i      denite#do_map('open_filter_buffer')

  inoremap <silent><buffer><expr><C-c>  denite#do_map('quit')
endfunction
Gautocmdft denite call s:denite_mapping()
Gautocmd InsertLeave denite-filter wincmd p | stopinsert
Gautocmdft denite-filter inoremap <silent><buffer><expr><C-c>  denite#do_map('quit')

"" filter
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ ['*~', '*.o', '*.exe', '*.bak', '.DS_Store', '*.pyc', '*.sw[po]', '*.class', '.hg/', '.git/', '.bzr/', '.svn/', 'tags', 'tags-*', '.ropeproject/', '__pycache__/', 'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

"" fruzzy
let g:fruzzy#usenative = 1


"" Defx:
call defx#custom#option('_', {
      \ 'columns': 'icons:indent:git:indent:filename:type',
      \ 'ignored_files': '.git,.DS_Store,*.pyc,__pycache__',
      \ })
let g:defx_git#indicators = {
      \ 'Modified'  : '✹',
      \ 'Staged'    : '✚',
      \ 'Untracked' : '✭',
      \ 'Renamed'   : '➜',
      \ 'Unmerged'  : '═',
      \ 'Ignored'   : '☒',
      \ 'Deleted'   : '✖',
      \ 'Unknown'   : '?'
      \ }

function! s:defx_settings() abort
  nnoremap <silent><buffer><expr>*       defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr>-       defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr>.       defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr>c       defx#do_action('copy')
  nnoremap <silent><buffer><expr>C       defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr>cd      defx#do_action('change_vim_cwd')
  nnoremap <silent><buffer><expr>d       defx#do_action('remove')
  nnoremap <silent><buffer><expr>j       'j'
  nnoremap <silent><buffer><expr>K       defx#do_action('new_directory')
  nnoremap <silent><buffer><expr>k       'k'
  nnoremap <silent><buffer><expr>o       defx#do_action('open')
  nnoremap <silent><buffer><expr>m       defx#do_action('move')
  nnoremap <silent><buffer><expr>n       defx#do_action('new_file')
  nnoremap <silent><buffer><expr>N       defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr>p       defx#do_action('paste')
  nnoremap <silent><buffer><expr>P       defx#do_action('preview')
  nnoremap <silent><buffer><expr>q       defx#do_action('quit')
  nnoremap <silent><buffer><expr>r       defx#do_action('rename')
	nnoremap <silent><buffer><expr>s       defx#do_action('multi', [['drop', 'split'], 'quit'])
  nnoremap <silent><buffer><expr>S       defx#do_action('toggle_sort', 'time')
	nnoremap <silent><buffer><expr>v       defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
  nnoremap <silent><buffer><expr>x       defx#do_action('execute_system')
  nnoremap <silent><buffer><expr>yy      defx#do_action('yank_path')

  nnoremap <silent><buffer><expr><CR>    defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><buffer><expr><Space> defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr><Down>  'j'
  nnoremap <silent><buffer><expr><Up>    'k'
  nnoremap <silent><buffer><expr><Left>  defx#do_action('close_tree')
  nnoremap <silent><buffer><expr><Right> defx#do_action('open_tree')

  nnoremap <silent><buffer><expr><C-g>   defx#do_action('print')
  nnoremap <silent><buffer><expr><C-l>   defx#do_action('redraw')
endfunction
Gautocmdft defx call s:defx_settings()


"" VimSpector:
let g:vimspector_base_dir = expand('$XDG_CONFIG_HOME/nvim/vimspector')


"" FloatTerm:
let g:floaterm_keymap_toggle = '<F10>'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9


"" Vista:
let g:vista#renderer#enable_icon = 1
let g:vista_blink = [0, 0]
let g:vista_cursor_delay = 400  " default
let g:vista_default_executive = 'lcn'
let g:vista_disable_statusline = 0
let g:vista_echo_cursor_strategy = 'floating_win'  " echo, scroll, floating_win, both
let g:vista_executive_for = {
      \ 'go': 'lcn',
      \ 'markdown': 'toc',
      \ }
let g:vista_sidebar_width = '150'
function! s:open_vista(mode)
  if len(a:mode)
    let l:save_vista_default_executive = g:vista_default_executive
    let g:vista_default_executive = a:mode
  endif

  Vista!!
  call timer_start(500, {-> execute('wincmd W')}, {'repeat': 1})

  if get(l:, 'save_vista_default_executive', 0)
    let g:vista_default_executive = l:save_vista_default_executive
  endif
endfunction
command! -nargs=* VistaOpen call s:open_vista(<q-args>)


" Ale:
"" ale-lint-file-linters
let g:ale_set_highlights = 0
let g:ale_set_balloons = 0

" ale-options
let g:airline#extensions#ale#enabled = 0
let g:ale_cache_executable_check_failures = 1
let g:ale_change_sign_column_color = 0
let g:ale_close_preview_on_inlet = 0
let g:ale_completion_enabled = 0
let g:ale_cursor_detail = 0
let g:ale_disable_lsp = 1
let g:ale_echo_cursor = 1
let g:ale_echo_delay = 10
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_enabled = 1
let g:ale_fix_on_save = 0
let g:ale_hover_to_preview = 0
let g:ale_keep_list_window_open = 0
let g:ale_list_window_size = 10
let g:ale_lint_delay = 200
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_linters_explicit = 1
let g:ale_max_signs = -1
let g:ale_open_list = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_shell = 'bash'
let g:ale_sign_column_always = 1
let g:ale_sign_highlight_linenrs = 1
let g:ale_update_tagstack = 0
let g:ale_use_global_executables = 1
let g:ale_virtualtext_cursor = 1
let g:ale_virtualtext_delay = 10
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_linter_aliases = {
      \ 'zsh': 'sh',
      \ }
let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'markdown': [],
      \ }
let g:ale_linters = {}  " initialize
let g:ale_pattern_options = {}

" :help ale-other-integration-options
"" Go:
let g:ale_linters.go = []  " ['gobuild', 'gopls', 'govet', 'staticcheck']  let g:ale_linters.go = ['gobuild', 'gofmt, 'golangci-lint'', 'golint', 'gopls', 'govet', 'staticcheck']
let g:ale_go_go111module = 'on'
let g:ale_go_golangci_lint_executable = s:gopath . 'bin/golangci-lint'
let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 0
let g:ale_go_golint_executable = s:gopath . 'bin/golint'
let g:ale_go_golint_options = ''
let g:ale_go_gopls_executable = s:gopath . '/bin/gopls'
let g:ale_go_gopls_options = ''
let g:ale_go_govet_options = ''
let g:ale_go_staticcheck_options = ''
let g:ale_go_staticcheck_lint_package = 0

"" CFamily:
let g:ale_c_build_dir_names = ['build']
let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 1

" function! s:ale_c_cpp_setup() abort
  let s:llvm_bin_directory = '/opt/llvm/devel/bin'

  let s:ale_linters_c_cpp = ['clangd', 'clang-format']  " 'clangd', 'clangtidy', 'cppcheck', 'uncrustify'
  let s:ale_c_cpp_clangd_executable = s:llvm_bin_directory . '/clang'
  let s:ale_c_cpp_clangd_options = g:clangd_commands_cfamily[1:len(g:clangd_commands_cfamily)]
  let s:ale_c_cpp_clangformat_executable = s:llvm_bin_directory . '/clang-format'
  let s:ale_c_cpp_clangtidy_executable = s:llvm_bin_directory . '/clang-tidy'

  """ C:
  let g:ale_linters.c = s:ale_linters_c_cpp
  let g:ale_c_cc_executable = s:llvm_bin_directory . '/clang'
  let g:ale_c_cc_options = '-march=native -std=c17 -Wall'
  let g:ale_c_clangd_executable = s:ale_c_cpp_clangd_executable
  let g:ale_c_clangd_options = s:ale_c_cpp_clangd_options
  let g:ale_c_clangformat_executable = s:ale_c_cpp_clangformat_executable
  let g:ale_c_clangformat_options = ''
  let g:ale_c_clangtidy_checks = []
  let g:ale_c_clangtidy_executable = s:ale_c_cpp_clangtidy_executable
  let g:ale_c_clangtidy_options = ''
  let g:ale_c_clangtidy_extra_options = ''
  let g:ale_c_uncrustify_executable = 'uncrustify'
  let g:ale_c_uncrustify_options = ''

  """ CPP:
  let g:ale_linters.cpp = s:ale_linters_c_cpp
  let g:ale_cpp_clang_executable = s:llvm_bin_directory . '/clang++'
  let g:ale_cpp_clang_options = '-march=native -std=c++17 -Wall'
  let g:ale_cpp_clangd_executable = s:ale_c_cpp_clangd_executable
  let g:ale_cpp_clangd_options = s:ale_c_cpp_clangd_options
  let g:ale_cpp_clangformat_executable = s:ale_c_cpp_clangformat_executable
  let g:ale_cpp_clangtidy_executable = s:ale_c_cpp_clangtidy_executable
" endfunction
" Gautocmdft c,cpp,objc,objcpp call s:ale_c_cpp_setup()
" let g:ale_linters.c = []
" let g:ale_linters.cpp = []

"" Python:
let g:ale_linters.python = ['black', 'pyright']  " ['flake8', 'pylint', 'pyls', 'mypy']
let g:ale_python_black_executable = 'black'
let g:ale_python_pyright_executable = '/usr/local/var/nodebrew/current/bin/pyright-langserver'
let g:ale_python_pyright_config = {
      \ 'python': {
      \   'pythonPath': g:python3_host_prog,
      \ },
      \}
let g:ale_python_pyright_config = {
      \ 'pyright': {
      \   'disableLanguageServices': v:false,
      \ },
      \}

"" Dockerfile:
let g:ale_linters.dockerfile = ['hadolint']
let g:ale_dockerfile_hadolint_use_docker = 'never'

"" Markdown:
let g:ale_linters.markdown = ['textlint']

"" Protobuf:
let g:ale_linters.proto = ['api-linter']  " ['buf-check-lint', 'prototool-all']  'api_linter', 'protoc-gen-lint', 'prototool', 'prototool-compile', 'prototool-lint'
let g:ale_proto_api_linter_options = []
let g:ale_proto_api_linter_config_path = '.api-linter.yaml'
let g:ale_proto_api_linter_include_paths = ['.', 'third_party/googleapis']

"" Rust:
let g:ale_linters.rust = ['cargo']

"" Sh:
let g:ale_linters.sh = ['shellcheck', 'shfmt', 'sh-language-server']  " 'shell', 'bashate'
""" Bashate:
let g:ale_sh_bashate_executable = 'bashate'
let g:ale_sh_bashate_options = '-i E006'
""" ShLanguageServer:
let g:ale_sh_language_server_executable = 'bash-language-server'
let g:ale_sh_language_server_use_global = 1
""" Shell:
let g:ale_sh_shell_default_shell = 'bash'
""" Shellcheck:
let g:ale_sh_shellcheck_executable = 'shellcheck'
let g:ale_sh_shellcheck_options = '-x --color=never --severity=style --wiki-link-count=10'
let g:ale_sh_shellcheck_exclusions = 'SC1072,SC1090,SC1091'
let g:ale_sh_shellcheck_change_directory = 1  " default
""" ShFmt:
let g:ale_sh_shfmt_options = ''

"" Terraform:
let g:ale_linters.terraform = ['fmt', 'tflint']
let g:ale_terraform_fmt_executable = 'terraform'
let g:ale_terraform_fmt_options = ''
let g:ale_terraform_tflint_executable = s:gopath . '/bin/tflint'
let g:ale_terraform_tflint_options = '-f json'

"" Yaml:
let g:ale_linters.yaml = ['yamllint']
let s:yamllint_config_file = ''
if exists("$YAMLLINT_CONFIG_FILE")
  let s:yamllint_config_file = '--config-file=' . expand('$YAMLLINT_CONFIG_FILE')
else
  let s:yamllint_root = fnamemodify(findfile('.yamllint', '.;'), ':p') . '.yamllint.yaml'
  if filereadable(s:yamllint_root)
    let s:yamllint_config_file = '--config-file=' . s:yamllint_root
  endif
endif
let g:ale_yaml_yamllint_options = '--strict ' . s:yamllint_config_file

"" Zsh:
Gautocmdft zsh let b:ale_sh_shellcheck_exclusions = 'SC1071'

let g:ale_linters.css = ['stylelint']


" Caw:
let g:caw_hatpos_skip_blank_line = 0
let g:caw_no_default_keymappings = 1
let g:caw_operator_keymappings = 0


" VimDevIcons:
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 0
let g:webdevicons_enable_denite = 1
let g:webdevicons_enable_unite = 0
let g:webdevicons_enable_vimfiler = 0
let g:webdevicons_enable_ctrlp = 0
let g:webdevicons_enable_airline_statusline = 0
let g:webdevicons_enable_airline_statusline_fileformat_symbols = 0
let g:webdevicons_enable_airline_tabline = 0
let g:webdevicons_enable_flagship_statusline = 0
let g:webdevicons_enable_flagship_statusline_fileformat_symbols = 0
let g:webdevicons_enable_startify = 0
let g:webdevicons_conceal_nerdtree_brackets = 0
let g:DevIconsAppendArtifactFix = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderPatternMatching = 0
let g:DevIconsEnableFolderExtensionPatternMatching = 1
let g:WebDevIconsUnicodeDecorateFolderNodesExactMatches = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1


" LightLine:
" https://donniewest.com/a-guide-to-basic-neovim-plugins
let g:lightline = {}
let g:lightline.colorscheme = 'equinusocio_material'

function! s:quickfix_get_type()
  if exists("*win_getid") && exists("*getwininfo")
    let dict = getwininfo(win_getid())
    if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
      return 'QuickFix'
    elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
      return 'LocationList'
    endif
  endif
  redir => buffers
  silent ls
  redir END
  let nr = bufnr('%')
  for buf in split(buffers, '\n')
    if match(buf, '\v^\s*'.nr) > -1
      if match(buf, '\cQuickfix') > -1
        return 'QuickFix'
      else
        return 'LocationList'
      endif
    endif
  endfor
  return ''
endfunction
function! LightlineMode()
  return &buftype ==# 'quickfix' ? s:quickfix_get_type() : lightline#mode()
endfunction
function! LightlineFilename()
  if &buftype ==# 'quickfix'
    return get(w:, "quickfix_title", "")
  endif
  let filename = expand('%:p') !=# '' ? expand('%:p') : '[No Name]'
  " let modified = &modified ? ' +' : ''
  let modified = &modified ? ' +' : &modifiable ? '' : ' -'
  " return filename
  return filename . modified
endfunction
function! LightlineModified()
  hi ModifiedColor guifg=#cf6a4c guibg=#373b41 gui=Bold
  return &modified ? ' +' : &modifiable ? '' : ' -'
endfunction
function! DeviconsGetFileTypeSymbol()
  return strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft'
endfunction
function! DeviconsGetFileFormatSymbol()
  return &fileformat . ' ' . WebDevIconsGetFileFormatSymbol()
endfunction
function! LightlineGitBranch()
  let l:branch_mark = ' '
  if dein#tap('gina.vim')
    let l:branch_mark = ' ' . gina#component#repo#branch()
  endif
  return l:branch_mark
endfunction
function! LightlineNearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
function! LanguageClientStatusLine() abort
  let l:diagnosticsDict = LanguageClient#statusLineDiagnosticsCounts()
  let l:errors          = get(l:diagnosticsDict, 'E', 0)
  let l:warnings        = get(l:diagnosticsDict, 'W', 0)
  let l:informations    = get(l:diagnosticsDict, 'I', 0)
  let l:hints           = get(l:diagnosticsDict, 'H', 0)
  return l:errors + l:warnings + l:informations + l:hints == 0 ? "✔ " : "E:" . l:errors . " " . "W :" . l:warnings . "I:" . l:informations . " " . "H:" . l:hints
endfunction

let g:lightline.component = {
      \ 'absolutepath': '%F',
      \ 'bufnum': '%n',
      \ 'charvalue': '%b',
      \ 'charvaluehex': '%B',
      \ 'close': '%999X X ',
      \ 'column': '%c',
      \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
      \ 'filename': '%{LightlineFilename()}',
      \ 'modified': '%{LightlineModified()}',
      \ 'line': '%l',
      \ 'lineinfo': '%3l  %-2v',
      \ 'mode': '%{lightline#mode()}',
      \ 'method': '%{LightlineNearestMethodOrFunction()}',
      \ 'paste': '%{&paste?"PASTE":""}',
      \ 'percent': '%3p%%',
      \ 'percentwin': '%P',
      \ 'readonly': '%R',
      \ 'relativepath': '%f',
      \ 'spell': '%{&spell?&spelllang:""}',
      \ 'winnr': '%{winnr()}',
      \ }
let g:lightline.component_expand = {
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_errors': 'lightline#ale#errors',
      \ 'linter_ok': 'lightline#ale#ok',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'language_client_statusline': 'LanguageClientStatusLine',
      \ }
let g:lightline.component_type = {
      \ 'modified': 'raw',
      \ 'linter_checking': 'left',
      \ 'linter_errors': 'error',
      \ 'linter_ok': 'left',
      \ 'linter_warnings': 'warning',
      \ }
let g:lightline.component_function = {
      \ 'mode': 'LightlineMode',
      \ 'fileformat': 'DeviconsGetFileFormatSymbol',
      \ 'filetype': 'DeviconsGetFileTypeSymbol',
      \ 'gitbranch': 'LightlineGitBranch',
      \ }
" , [ 'method' ]
let g:lightline.active = {
      \ 'left':  [[ 'mode', 'paste'], ['filename', 'gitbranch' ]],
      \ 'right': [[ '', 'lineinfo', 'percent' ], [ '', 'filetype', 'fileformat', 'fileencoding' ], [ 'language_client_statusline' ], [ 'linter_checking', 'linter_errors', 'linter_warnings' ], [ 'linter_ok' ]]
      \ }
let g:lightline.inactive = {
      \ 'left':  [[ 'filename' ]],
      \ 'right': [[ 'lineinfo' ], [ 'percent' ]]
      \ }
let g:lightline.tabline = {
      \ 'left':  [[ 'tabs' ]],
      \ 'right': [[ 'close' ]]
      \ }
let g:lightline.tab = {
      \ 'active':   [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }
let g:lightline.enable = { 'statusline': 1 }  " , 'tabline': 1
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '  ' }
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#enable_devicons = 1


"" Gina:
if dein#source('gina.vim')
  call gina#custom#command#option('diff', '--opener', 'vsplit')
  call gina#custom#command#option('commit', '-S')
  call gina#custom#execute(
      \ '/\%(commit\)',
      \ 'setlocal colorcolumn=69 expandtab shiftwidth=2 softtabstop=2 tabstop=2 winheight=40',
      \)
  call gina#custom#mapping#nmap(
      \ '/\%(blame\)',
      \ 'o', '<Plug>(gina-show-commit)', {'noremap': 0, 'silent': 1},
      \)
  call gina#custom#execute(
      \ '/\%(status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'setlocal winfixheight',
      \)
  call gina#custom#mapping#nmap(
      \ '/\%(commit\|status\|branch\|ls\|grep\|changes\|tag\)',
      \ 'q', ':<C-u> q<CR>', {'noremap': 1, 'silent': 1},
      \)
endif


" GitGutter:
let g:gitgutter_async = 1
let g:gitgutter_diff_args = ' '
let g:gitgutter_enabled = 1
let g:gItgutter_highlight_lines = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 100000
let g:gitgutter_override_sign_column_highlight = 1
let g:gitgutter_terminal_reports_focus = 1
let g:gitgutter_sign_added              = '+'
let g:gitgutter_sign_modified           = '~'
let g:gitgutter_sign_removed            = '_'
let g:gitgutter_sign_removed_first_line = '‾'
let g:gitgutter_sign_modified_removed   = '~_'


" Accelerated JK:
let g:accelerated_jk_enable_deceleration = 0
let g:accelerated_jk_acceleration_limit = 500  " 150, 250, 350
let g:accelerated_jk_acceleration_table = [15, 18, 21, 25, 31, 37, 44, 53, 64, 72]  "(1.5*1.2): [12,17,21,24,26,28,30,35], [7,12,17,21,24,26,28,30], [15, 19, 25, 32, 42, 55, 72]


" EasyMotion:
let g:EasyMotion_keys = "aoeidtn:,.pyfgcrl'qjkxbmuhs"
let g:EasyMotion_do_shade = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_grouping = 1
let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
let g:EasyMotion_use_migemo = 0
let g:EasyMotion_use_upper = 0
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_prompt = 'Search for {n} character(s): '  " '{n}>>> '
let g:EasyMotion_inc_highlight = 1
let g:EasyMotion_move_highlight = 1
let g:EasyMotion_landing_highlight = 0
let g:EasyMotion_add_search_history = 1
let g:EasyMotion_off_screen_search = 1
let g:EasyMotion_disable_two_key_combo = 0
let g:EasyMotion_verbose = 0

nmap <LocalLeader>f  <Plug>(easymotion-f)
nmap <LocalLeader>F  <Plug>(easymotion-F)
nmap <LocalLeader>t  <Plug>(easymotion-t)
nmap <LocalLeader>T  <Plug>(easymotion-T)
nmap <LocalLeader>w  <Plug>(easymotion-w)
nmap <LocalLeader>W  <Plug>(easymotion-W)
nmap <LocalLeader>b  <Plug>(easymotion-b)
nmap <LocalLeader>B  <Plug>(easymotion-B)
nmap <LocalLeader>e  <Plug>(easymotion-e)
nmap <LocalLeader>E  <Plug>(easymotion-E)
nmap <LocalLeader>ge <Plug>(easymotion-ge)
nmap <LocalLeader>gE <Plug>(easymotion-gE)
nmap <LocalLeader>j  <Plug>(easymotion-j)
nmap <LocalLeader>k  <Plug>(easymotion-k)
nmap <LocalLeader>n  <Plug>(easymotion-n)
nmap <LocalLeader>N  <Plug>(easymotion-N)
nmap <LocalLeader>s  <Plug>(easymotion-s)

" VimIlluminate:
let g:Illuminate_delay = 250
let g:Illuminate_ftblacklist = ['defx', 'man']


" VimHexokinase:
let g:Hexokinase_highlighters = ['backgroundfull']  " 'virtual', 'sign_column', 'background', 'backgroundfull', 'foreground', 'foregroundfull'
let g:Hexokinase_optInPatterns = [
      \ 'full_hex',
      \ 'triple_hex',
      \ 'rgb',
      \ 'rgba',
      \ 'hsl',
      \ 'hsla',
      \ ]


" ParenMatch:
let g:cursorword = 0


" Wakatime:
let g:wakatime_PythonBinary = g:python3_host_prog
let g:wakatime_OverrideCommandPrefix = 'wakatime'
let s:redraw_setting = 'auto'


" SonicTemplate:
let g:sonictemplate_vim_template_dir = [expand($XDG_CONFIG_HOME.'/nvim/template')]


" Editorconfig:
let g:EditorConfig_core_mode = 'python_external'


" Trans:
let g:trans_lang_credentials_file = $XDG_CONFIG_HOME.'/gcloud/credentials/kouzoh-p-zchee/trans-nvim.json'
let g:trans_lang_locale = 'ja'
let g:trans_lang_output = 'float'  " 'preview'
let g:trans_lang_cutset = ['//', '#']


" OpenBrowser:
let g:openbrowser_search_engines = {
      \ 'google': 'http://google.com/search?q={query}&tbs=qdr:y',
      \ }
let g:openbrowser_message_verbosity = 0


" EasyAlign:
let g:easy_align_ignore_groups = []


" Switchvim:
let g:switch_mapping = ""
let g:switch_custom_definitions = [ [1, 0], ['v:true', 'v:false'], ['yes', 'no'], ['on', 'off'], ['ON', 'OFF'], ['static', 'dynamic'] ]


" ISSW:
"" https://github.com/vovkasm/input-source-switcher
" Gautocmd InsertLeave * call jobstart('issw com.apple.inputmethod.Kotoeri.Roman', { 'detach': v:true })

" Rainbow:
" let g:rainbow_active = 0
" let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
" let g:rainbow_load_separately = [
"      \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"      \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
"      \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
"      \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
"      \ ]

" Operator Camelize:
" call operator#camelize#load()

highlight rainbowcol1                 gui=None      guifg=None     guibg=None

" -------------------------------------------------------------------------------------------------
" Language:

" Go:
"" NvimGo:
let g:go#build#appengine = v:false
let g:go#build#autosave = v:false
let g:go#build#is_not_gb = v:false
" let g:go#build#flags = ['-tags', 'gojay']
let g:go#build#force = v:false
let g:go#fmt#autosave  = v:true
let g:go#fmt#mode = 'goimports'
" let g:go#fmt#goimports_local = ['github.com/zchee/nvim-lsp']
let g:go#guru#keep_cursor = {
      \ 'callees'    : v:false,
      \ 'callers'    : v:false,
      \ 'callstack'  : v:false,
      \ 'definition' : v:true,
      \ 'describe'   : v:false,
      \ 'freevars'   : v:false,
      \ 'implements' : v:false,
      \ 'peers'      : v:false,
      \ 'pointsto'   : v:false,
      \ 'referrers'  : v:false,
      \ 'whicherrs'  : v:false
      \ }
let g:go#generate#test#subtest = v:true
let g:go#generate#test#parallel = v:true
let g:go#generate#test#template_dir = $XDG_CONFIG_HOME . '/go/template/gotests'
let g:go#generate#test#template_params_path = ''
let g:go#guru#reflection = v:false
let g:go#highlight#cgo = v:true
let g:go#iferr#autosave = v:false
let g:go#lint#golint#autosave = v:false
let g:go#lint#golint#ignore = ['internal', 'vendor', 'pb', 'fbs']
let g:go#lint#golint#mode = 'root'
let g:go#lint#govet#autosave = v:false
let g:go#lint#govet#flags = ['-v', '-all']
let g:go#lint#govet#ignore = ['vendor', 'testdata', '_tmp']
let g:go#lint#metalinter#autosave = v:false
let g:go#lint#metalinter#autosave#tools = ['vet', 'golint']
let g:go#lint#metalinter#deadline = '20s'
let g:go#lint#metalinter#skip_dir = ['internal', 'vendor', 'testdata', '__*.go', '*_test.go']
let g:go#lint#metalinter#tools = ['vet', 'golint']
let g:go#rename#prefill = v:true
let g:go#loaded#gosnippets = v:true
let g:go#terminal#height = 120
let g:go#terminal#start_insert = v:true
let g:go#terminal#width = 150
let g:go#test#all_package = v:false
let g:go#test#autosave = v:false
let g:go#test#flags = ['-v']
let g:go#debug = v:true
let g:go#debug#pprof = v:false
let g:go#loaded#gosnippets = 1
""" highlight
let g:go#highlight#terminal#test               = 1  " default : 0
let g:go_highlight_fold_enable_comment         = 1  " default : 0
let g:go_highlight_generate_tags               = 1  " default : 0
let g:go_highlight_string_spellcheck           = 0  " default : 1
let g:go_highlight_format_strings              = 1  " default : 1
let g:go_highlight_fold_enable_package_comment = 1  " default : 0
let g:go_highlight_fold_enable_block           = 1  " default : 0
let g:go_highlight_import                      = 1  " default : 0
let g:go_highlight_fold_enable_varconst        = 1  " default : 0
let g:go_highlight_array_whitespace_error      = 0  " default : 1
let g:go_highlight_trailing_whitespace_error   = 0  " default : 1
let g:go_highlight_chan_whitespace_error       = 0  " default : 1
let g:go_highlight_extra_types                 = 0  " default : 1
let g:go_highlight_space_tab_error             = 0  " default : 1
let g:go_highlight_operators                   = 1  " default : 0
let g:go_highlight_functions                   = 1  " default : 0
let g:go_highlight_function_parameters         = 0  " default : 0
let g:go_highlight_function_calls              = 1  " default : 0
let g:go_highlight_fields                      = 1  " default : 0
let g:go_highlight_types                       = 0  " default : 0
let g:go_highlight_variable_assignments        = 0  " default : 0
let g:go_highlight_variable_declarations       = 0  " default : 0
let g:go_highlight_build_constraints           = 1  " default : 0

" C CXX:
let c_no_curly_error = 1
"" VimCPPModern:
let g:cpp_simple_highlight = 1  " Put all standard C and C++ keywords under Vim's highlight group `Statement` (affects both C and C++ files)
let g:cpp_named_requirements_highlight = 1  " Enable highlighting of named requirements (C++20 library concepts)


" Protobuf:
let g:clang_format#code_style = 'google'
let g:clang_format#extra_args = '--sort-includes'  " '--fno-color-diagnostics'
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0
let g:clang_format#auto_format_on_insert_leave = 0
let g:clang_format#auto_formatexpr = 0


" Python:
"" Kite:
let g:kite_auto_complete = 1
let g:kite_snippets = 0
let g:kite_tab_complete = 0
let g:kite_deconflict_cr = 1

"" Semshi:
" let g:semshi#mark_selected_nodes = 0


" Asm:
let g:nasm_loose_syntax = 1
let g:nasm_ctx_outside_macro = 1


" Rust:
let g:rust_bang_comment_leader = 1
let g:rust_clip_command = 'pbcopy'
let g:rust_conceal = 0
let g:rust_conceal_mod_path = 0
let g:rust_conceal_pub = 0
let g:rust_fold = 1
let g:rust_playpen_url = 'https://play.rust-lang.org/'
let g:rust_recommended_style = 0
let g:rust_shortener_url = 'https://is.gd/'
let g:rustc_makeprg_no_percent = 1
let g:rustc_path = '/usr/local/rust/cargo/bin/rustc'
let g:rustfmt_autosave = 0
let g:rustfmt_autosave = 1
let g:rustfmt_command = '/usr/local/rust/cargo/bin/rustfmt'
let g:rustfmt_command = 'rustfmt'
let g:rustfmt_fail_silently = 1


"" Lua:
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0


"" Terraform:
let g:terraform_commentstring = '//%s'
let g:terraform_fmt_on_save = 1


"" Yaml:


"" TypeScript:
let g:yats_host_keyword = 1


"" Binary:
let g:vinarise_enable_auto_detect = 1
if isdirectory('/usr/local/opt/binutils')
  let g:vinarise_objdump_command = '/usr/local/opt/binutils/bin/gobjdump'
endif


"" Markdown:
let g:markdown_fenced_languages = [
      \ 'c',
      \ 'cpp',
      \ 'dockerfile',
      \ 'go',
      \ 'help',
      \ 'python',
      \ 'sh',
      \ 'typescript',
      \ 'vim'
      \]
"" VimMarkdownfmt:
let g:markdownfmt_command = 'markdownfmt'
let g:markdownfmt_options = ''
let g:markdownfmt_autosave = 0
let g:markdownfmt_fail_silently = 0

"" MarkdownPreview:
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_markdown_css = $XDG_CONFIG_HOME . '/nvim/plugin/markdown-preview.nvim/github.css'

function! s:markdown_preview_forcus_gain()
  call mkdp#util#open_preview_page()
  call timer_start(700, {-> system('kitty @ focus-window')}, {'repeat': 1})
endfunction
command! -nargs=* MarkdownPreviews call s:markdown_preview_forcus_gain()


"" PlantUML:
let g:plantuml_previewer#plantuml_jar_path = '/usr/local/opt/plantuml/libexec/plantuml.jar'
let g:plantuml_previewer#viewer_path = '/tmp/plantuml'

" -------------------------------------------------------------------------------------------------
" testing plugins

" -------------------------------------------------------------------------------------------------
" Functions:

" Filetye:
" `a:args` should be list
function! s:is_filetype(args)
  let l:ft = &filetype
  " let l:ft = getbufvar(winbufnr(winnr()), "&filetype")
  if (index(a:args, l:ft) >= 0)
    return v:true
  endif
  return v:false
endfunction


" Help:
" https://github.com/rhysd/dogfiles/blob/69529ec4a22c/vimrc#L318-L341
function! s:smart_help(args)
  if winwidth(0) > winheight(0) * 2
    let l:help_args = 'vertical rightbelow help ' . a:args
  else
    let l:help_args = 'rightbelow help ' . a:args
  endif

  try
    execute l:help_args
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry
endfunction
command! -nargs=* -complete=help Help call s:smart_help(<q-args>)

" HelpGrep:
function! s:smart_helpgrep(args)
  if winwidth(0) > winheight(0) * 2
    let l:help_args = 'vertical rightbelow helpgrep ' . a:args
  else
    let l:help_args = 'rightbelow helpgrep ' . a:args
  endif

  try
    execute l:help_args
  catch /^Vim\%((\a\+)\)\=:E149/
    echohl ErrorMsg
    echomsg "E149: Sorry, no help for " . a:args
    echohl None
  endtry

  silent! copen
endfunction
command! -nargs=* -complete=help HelpGrep call s:smart_helpgrep(<q-args>)


" SyntaxInfo:
" Display syntax infomation on under the current cursor for syntax ID
function! s:get_syn_id(transparent)
  let s:synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(s:synid)
  else
    return s:synid
  endif
endfunction
" for syntax attributes
function! s:get_syn_attr(synid)
  let s:name = synIDattr(a:synid, "name")
  let s:bold  = synIDattr(a:synid, "bold", "gui")
  let s:guifg = synIDattr(a:synid, "fg", "gui")
  let s:guibg = synIDattr(a:synid, "bg", "gui")
  let s:guisp = synIDattr(a:synid, "sp")
  let s:attr = {
        \ "name": s:name,
        \ "bold": s:bold,
        \ "guifg": s:guifg,
        \ "guibg": s:guibg,
        \ "guisp": s:guisp,
        \ }
  return s:attr
endfunction

function! s:get_syn_info(cword)
  let s:baseSyn = s:get_syn_attr(s:get_syn_id(0))
  let s:baseSynInfo = "name: " . s:baseSyn.name .
       \ " bold=" . (s:baseSyn.bold == 1 ? 'true' : 'false' ) .
       \ " guifg=" . ((s:baseSyn.guifg != '') ? s:baseSyn.guifg . "," : "NONE" ) .
       \ " guibg=" . ((s:baseSyn.guibg != '') ? s:baseSyn.guibg . "," : "NONE" ) .
       \ " guisp=" . ((s:baseSyn.guisp != '') ? s:baseSyn.guisp . "," : "NONE" )
  let s:linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  let s:linkedSynInfo =  "name: " . s:linkedSyn.name .
       \ " bold=" .  (s:linkedSyn.bold == 1 ? 'true' : 'false' ) .
       \ " guifg=" . ((s:linkedSyn.guifg != '') ? s:linkedSyn.guifg : "NONE" ) .
       \ " guibg=" . ((s:linkedSyn.guibg != '') ? s:linkedSyn.guibg : "NONE" ) .
       \ " guisp=" . ((s:linkedSyn.guisp != '') ? s:linkedSyn.guisp : "NONE" )
  echomsg a:cword . ':'
  echomsg s:baseSynInfo
  echomsg '  ' . "link to"
  echomsg s:linkedSynInfo
endfunction
command! SyntaxInfo call s:get_syn_info(expand('<cword>'))


" ClearMessage:
command! ClearMessage for n in range(200) | echom "" | endfor


" Binary Edit Mode:
" need open nvim with `-b` flag
function! BinaryMode() abort
  if !has('binary')
    echoerr "BinaryMode must be 'binary' option"
    return
  endif

  execute '%!xxd'
endfunction


" Open the C/C++ online document
" https://github.com/rhysd/dogfiles/blob/926f2b9c1856bbf3a8090f430831f2c94d7cc410/vimrc#L1399-L1423
function! s:open_online_cfamily_doc()
  call dein#source('open-browser.vim')
  let l:l = getline('.')

  if l:l =~# '^\s*#\s*include\s\+<.\+>'
    let l:header = matchstr(l, '^\s*#\s*include\s\+<\zs.\+\ze>')
    if header =~# '^boost'
      "https://www.google.co.jp/search?hl=en&as_q=int64_max&as_sitesearch=cpprefjp.github.io
      execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.matchstr(header, 'boost/\zs[^/>]\+\ze')
      return
    else
      execute 'OpenBrowser' 'http://ja.cppreference.com/mwiki/index.php?title=Special:Search&search='.matchstr(header, '\zs[^/>]\+\ze')
      return
    endif
  else
    let l:cword = expand('<cword>')
    if cword ==# ''
      return
    endif
    let l:line_head = getline('.')[:col('.')-1]
    if line_head =~# 'boost::[[:alnum:]:]*$'
      execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.l:cword
    elseif line_head =~# 'std::[[:alnum:]:]*$'
      execute 'OpenBrowser' 'https://www.google.co.jp/search?hl=en&as_sitesearch=cpprefjp.github.io&as_q='.l:cword
      execute 'OpenBrowser' 'http://ja.cppreference.com/mwiki/index.php?title=Special:Search&search='.l:cword
    else
      let l:name = synIDattr(synIDtrans(synID(line("."), col("."), 1)), 'name')
      if l:name == 'Statement'
        execute 'OpenBrowser' 'http://ja.cppreference.com/w/c/language/'.l:cword
      else
        execute 'OpenBrowser' 'http://ja.cppreference.com/mwiki/index.php?title=Special:Search&search='.l:cword
      endif
    endif
  endif
endfunction


" Trim Whitespace:
function! s:trimSpace()
  if !&binary && &filetype != 'diff' && &filetype != 'markdown'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction
command! TrimSpace call s:trimSpace()


" EditInit:
function! s:editTnit()
  vsplit $XDG_CONFIG_HOME/nvim/init.vim
endfunction
command! EditInit call s:editTnit()


" Lr:
" <lr-args> to browse lr(1) results in a new window, press return to open file in new window.
command! -nargs=* -complete=file Lr
      \ new | setl bt=nofile noswf | silent exe '0r!lr -Q ' <q-args> |
      \ 0 | res | map <buffer><C-M> $<C-W>F<C-W>_


" LSPYamlSetSchema:
function! s:lsp_set_schema(args)
  if &filetype !=? "yaml" || !len(a:args)
    return
  endif

  let l:filepath = expand('%:p')
  let l:filename = fnamemodify(l:filepath, ':t')

  let l:schema = a:args
  let l:config_file = expand($XDG_CONFIG_HOME . '/nvim/lsp/schema/' . l:schema . '.schema.json')
  let l:config = json_decode(readfile(l:config_file))

  echom 'yaml-language-server: schema: ' . l:schema . ', config_file: ' . l:config_file
  call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': l:config })
endfunction
command! -nargs=* LSPYamlSetSchema call <SID>lsp_set_schema(<q-args>)

" -------------------------------------------------------------------------------------------------
" Command:

" override Man command
command! -nargs=+ ManV vertical Man <args>

" CheckColor:
function s:check_colorscheme() abort
  Capture call nvim_command("edit ~/.nvim/colors/equinusocio_material.vim | source $VIMRUNTIME/tools/check_colors.vim")
  wincmd x
  setlocal filetype=vim
endfunction

command! CheckColorScheme call s:check_colorscheme()

" Terminal:
" command! -nargs=* Terminal vsplit | terminal <args>
command! -nargs=* TerminalV vsplit | terminal <args>

" Capture:
" http://qiita.com/sgur/items/9e243f13caa4ff294fa8
command! -nargs=+ -complete=command Capture QuickRun -type vim -src <q-args>

" Shfmt:
command! -nargs=0 -bang -complete=command Shfmt %!shfmt -i 2

" FormatJson:
if has("python3")
python3 << EOF
import vim
import json
def Format_Json(indent, sort):
    jsonStr = "\n".join(vim.current.buffer)
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=indent, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[0:] = prettyJson.split(b'\n')

def Format_Json_Select(start, end):
    start = start - 1
    jsonStr = "\n".join(vim.current.buffer[start:end])
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=False, indent=2, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[start:end] = prettyJson.split(b'\n')

def Format_JsonSchema(indent, sort):
    jsonStr = "\n".join(vim.current.buffer)
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=sort, indent=indent, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[0:] = prettyJson.split(b'\n')

def Format_JsonSchema_Select(start, end):
    start = start - 1
    jsonStr = "\n".join(vim.current.buffer[start:end])
    prettyJson = json.dumps(json.loads(jsonStr), sort_keys=False, indent=2, separators=(',', ': '), ensure_ascii=False)
    prettyJson = prettyJson.encode('utf8')
    vim.current.buffer[start:end] = prettyJson.split(b'\n')
EOF
  command! -bang -bar -complete=command -nargs=* -range=% FormatJson :python3 Format_Json(<args>)
  command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSelect :python3 Format_Json_Select(<line1>, <line2>)

  command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSchema :python3 Format_JsonSchema(<args>)
  command! -bang -bar -complete=command -nargs=* -range=% FormatJsonSchemaSelect :python3 Format_JsonSchema_Select(<line1>, <line2>)
else
  command! -nargs=0 -bang -complete=command FormatJson %!python3 -m json.tool
endif

" ProfileSyntax:
function! ProfileSyntax() abort
  " Initial and cleanup syntime
  redraw!
  syntime clear
  " Profiling syntax regexp
  syntime on
  redraw!
  QuickRun -type vim -src 'syntime report'
endfunction
command! -nargs=0 -bang -complete=command ProfileSyntax call ProfileSyntax()

" from https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
command! ConvertBlockComment keeppatterns .,/\*\//s/\v^((\s*\/\*)|(\s*\*\/)|(\s*\*))(.*)/\/\/\/\5/
command! StartuptimeNvim     execute "v:progpath . ' --startuptime ' . expand('~/vimprofile.txt') '-c \"e ~/vimprofile.txt\"'"
function! Cxn_py() abort
  vsplit
  terminal
  call chansend(&channel, "python3\nimport pynvim\n")
  call chansend(&channel, "n = pynvim.attach('socket', path='".g:cxn."')\n")
endfunction
function! Cxn(addr) abort
  silent! unlet g:cxn
  tabnew
  if !empty(a:addr)  " Only start the client.
    let g:cxn = a:addr
    call Cxn_py()
    return
  endif

  terminal
  let nvim_path = executable('build/bin/nvim') ? 'build/bin/nvim' : 'nvim'
  call chansend(&channel, "NVIM_LISTEN_ADDRESS= ".nvim_path." -u NORC\n")
  call chansend(&channel, ":let j=jobstart('nc -U ".v:servername."',{'rpc':v:true})\n")
  call chansend(&channel, ":call rpcrequest(j, 'nvim_set_var', 'cxn', v:servername)\n")
  call chansend(&channel, ":call rpcrequest(j, 'nvim_command', 'call Cxn_py()')\n")
endfunction
command! -nargs=* NvimCxn call Cxn(<q-args>)

command! Sha256Put -nargs=1 call nvim_paste(system("sha256sum-check " . expand(<line1>) . " | perl -pe 's/\n//g'"), v:false, -1)

" -------------------------------------------------------------------------------------------------
" Keymap:
"
" For Kinesis Advantage With Programmer Dvorak.
" Global & Local MapLeader are arranged in the center of the keyboard.
"
"   - Global MapLeader: <Space> " Righthand
"   - Local MapLeader : <BS>    " Lefthand
"   - Local prefix    : ,       " Lefthand
"
" TODO(zchee):
"   Swaps semicolon and colon to ideal at Kinesis hardware level. Now use direct edited macOS key dictionary
"   Use Kinesis Advantage2 instead of.
"
" Vim remappable keys
"   - <Space>
"   - ,       : Reverse repeat for f, t, F, T
"   - s       : replace to cl
"   - t       : Never use it in normal mode, f -> ... -> h instead of
"   - m       : For sets marker, never use it also
"
"   - http://deris.hatenablog.jp/entry/2013/05/02/192415
"
" -------------------------------------------------------------------------------------------------
" Map Leader:

" nmap <Nop> for g:mapleader and g:maplocalleader keys
nnoremap <nowait><Space> <Nop>
nnoremap <nowait><BS>    <Nop>
if !exists('g:mapleader')
  let g:mapleader = "\<Space>"
endif
if !exists('g:maplocalleader')
  let g:maplocalleader = "\<BS>"
endif

"" <Leader>
nnoremap              <Leader>ga        :<C-u>Gina add %<CR>
nnoremap              <Leader>gc        :<C-u>Gina commit<CR>
nnoremap              <Leader>gp        :<C-u>Gina push<CR>
nnoremap              <Leader>gs        :<C-u>Gina status<CR>
     map           <Leader><Leader>     <Plug>(easymotion-prefix)

"" <LocalLeader>
nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep -buffer-name='grep/rg'<CR>
nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer'<CR>
nnoremap <silent><LocalLeader>g         :<C-u>Denite line -buffer-name='line'<CR>
nnoremap <silent><LocalLeader>gs        :<C-u>call switch#Switch()<CR>
nnoremap <silent><LocalLeader>q         :<C-u>q<CR>
nnoremap <silent><LocalLeader>w         :<C-u>w<CR>

"" ,
nnoremap              <silent>,m        <C-w>W
nnoremap              <silent>,n        <C-w>w
nnoremap              <silent>,p        <C-w>W
nnoremap              <silent>,r        <C-w>x
nnoremap              <silent>,s        :<C-u>bNext<CR>
nnoremap              <silent>,t        :<C-u>tabnew<CR>
nnoremap              <silent>,w        <C-w>w

" -------------------------------------------------------------------------------------------------
" Map: (m)

"" Operator:
map <silent>ti  <Plug>(operator-surround-append)
map <silent>td  <Plug>(operator-surround-delete)
map <silent>tr  <Plug>(operator-surround-replace)

" -------------------------------------------------------------------------------------------------
" Normal: (n)

"        *) asterisk-gz*
"        -) 'Vaffle %:p:h' or 'VimFilerExplorer -find<CR>'
"      @,^) ^,@: switch '@' and '^' for Dvorak pinky
"       ga) EasyAlign
"       gx) openbrowser-smart-search
"        j) accelerated_jk_gj_position
"        k) accelerated_jk_gk_position
"        p) Paste
"        Q) gq: do not use Ex mode. Use 'gq' is the format the lines that {motion} moves over
"        s) A: Append text at the end of the line [count] times
"        x) "_x: do not add yank register
"       zj)       zjzt
"       zk)       2zkzjzt
"       ZQ) <Nop>: disable suspend
"    <C-g>) 'DeniteProjectDir grep'
"    <C-p>) 'DeniteProjectDir file_rec'
"    <C-q>) nohlsearch: Stop the highlighting for the 'hlsearch' option
" <S-Tab>>) %: Jump to match pair brackets. *<Tab>* and *<C-i>* are similar treatment.
"              Note that needs <C-i>(<Tab>) for jump to next taglist
" <S-Down>) <Nop>
"   <S-Up>) <Nop>

nmap     <silent><nowait>*        <Plug>(asterisk-gz*)
nnoremap         <silent>-        :<C-u>Defx -auto-cd -direction=topleft -split=vertical -search=`expand('%:p')` `expand('%:p:h')`<CR>

nnoremap         <nowait>@        ^
nnoremap         <nowait>^        @

nmap                     ga       <Plug>(LiveEasyAlign)
nnoremap         <silent>gs       :<C-u>Switch<CR>
nmap             <silent>gx       <Plug>(openbrowser-smart-search)
nmap     <silent><nowait>j        <Plug>(accelerated_jk_j)
nmap     <silent><nowait>k        <Plug>(accelerated_jk_k)

nnoremap                 Q        gq
nnoremap                 s        A
nnoremap         <nowait>x        "_x
nnoremap                 zj       zjzt
nnoremap                 zk       2zkzjzt
nnoremap                 ZQ       <Nop>
nnoremap         <nowait><Up>     <Up>
nnoremap         <nowait><Down>   <Down>

nnoremap         <silent><C-e>    <C-e><C-e><C-e><C-e>
nnoremap         <silent><C-g>    :<C-u>DeniteProjectDir grep -buffer-name='grep' -path=`expand('%:p:h')`<CR>
nnoremap         <silent><C-p>    :<C-u>DeniteProjectDir file/rec -buffer-name='file_rec/fd' -start-filter -path=`expand('%:p')`<CR>
nnoremap         <silent><C-q>    :<C-u>nohlsearch<CR>
nmap             <silent><C-w>z   <Plug>(zoom-toggle)
nnoremap         <silent><C-y>    <C-y><C-y><C-y><C-y>

nnoremap                 <S-Down> <Nop>
nnoremap         <nowait><S-Tab>  %
nnoremap                 <S-Up>   <Nop>


" Language:

"" Go:
Gautocmdft go nnoremap <LocalLeader>go  :<C-u>DeniteProjectDir grep -buffer-name='grep' -path=/usr/local/go/src<CR>
Gautocmd BufNewFile,BufRead,BufEnter godoc://** nmap <C-]> <CR>

"" C CXX ObjC:
Gautocmdft c,cpp  nnoremap <silent><buffer><C-k>       :<C-u>call <SID>open_online_cfamily_doc()<CR>
if dein#tap('vim-clang-format')
  Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>x        <Plug>(operator-clang-format)
  Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>C        :<C-u>ClangFormatAutoToggle<CR>
  Gautocmdft c,cpp,objc,objcpp,proto nnoremap <buffer><LocalLeader>f   :<C-u>ClangFormat<CR>
endif

"" Protobuf:

"" Yaml:

"" Markdown:
Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>

"" Vim:
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
Gautocmdft vim nnoremap <silent><buffer>K      :<C-u>Help<Space><C-r><C-w><CR>

"" Ouickfix:
Gautocmdft qf  nnoremap <buffer><CR>      <CR>zz

"" Help:
Gautocmdft help nnoremap <silent><buffer><C-n> :<C-u>cnext<CR>
Gautocmdft help nnoremap <silent><buffer><C-p> :<C-u>cprevious<CR>

" -------------------------------------------------------------------------------------------------
" Insert: (i)

" <C-c> doesn't trigger the InsertLeave autocmd
inoremap <C-c> <ESC>

" Move cursor to first or end of line
inoremap <silent><C-a>  <C-o><S-i>
inoremap <silent><C-e>  <C-o><S-a>

" Put +register word
inoremap <silent><C-p>  <C-r>*
inoremap <silent><C-j>  <C-r>*

" Language:

"" Go Yaml Json:
Gautocmdft c,go,yaml,json,jsonschema inoremap <buffer> "    '
Gautocmdft c,go,yaml,json,jsonschema inoremap <buffer> '    "

"" Swift:
Gautocmdft swift imap <buffer><C-k>  <Plug>(autocomplete_swift_jump_to_placeholder)

" Plugins:
"" Deoplete:
function! s:deoplete_check_back_space() abort
  let s:col = col('.') - 1
  return !s:col || getline('.')[s:col - 1]  =~ '\s'
endfunction
inoremap <silent><expr><TAB>    pumvisible() ? "\<C-n>" : <SID>deoplete_check_back_space() ? "\<TAB>" : deoplete#manual_complete()
inoremap       <expr><S-TAB>    pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr><CR>     pumvisible() ? deoplete#close_popup() : "\<CR>"
" inoremap <silent><expr><BS>     pumvisible() ? deoplete#close_popup()."\<C-h>" : "\<C-h>"
" inoremap <silent><expr><C-h>    pumvisible() ? deoplete#close_popup()."\<C-h>" : "\<C-h>"
inoremap <silent><expr><Up>     pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <silent><expr><Down>   pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <silent><expr><C-z>    pumvisible() ? "\<C-z>" : deoplete#mapping#_undo_completion()
"" Neosnippet:
imap     <silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

" -------------------------------------------------------------------------------------------------
" Visual Select: (v)

" Do not add register to current cursor word
vnoremap c       "_c
vnoremap x       "_x
vnoremap P       "_dP
vnoremap p       "_dp
vnoremap @       ^
vnoremap ^       @
" sort by ignorecase alphabetically.
vnoremap <silent>gs :<C-u>'<,'>sort i<CR>
vnoremap v       <End>h
" Move to start of line
vnoremap V ^
" Jump to match pair brackets
vnoremap <S-Tab> %

vmap <silent>gx              <Plug>(openbrowser-smart-search)
nmap <silent>gc              <Plug>(caw:hatpos:toggle)
vmap <silent>gc              <Plug>(caw:hatpos:toggle)
vmap <silent><LocalLeader>t  :<C-u>Trans<CR>
vmap <silent>ga              <Plug>(LiveEasyAlign)
vmap <silent>tu              <Plug>(operator-camelize-toggle)


" Language:

"" Protobuf:
Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

"" C CXX ObjC:
Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

" -------------------------------------------------------------------------------------------------
" Visual: (x)
xmap  <LocalLeader>        <Plug>(operator-replace)

xnoremap <silent><C-t>     :<C-u>Trans<CR>

" Language:

" -------------------------------------------------------------------------------------------------
" Select: (s)

" neosnippet
smap     <silent><expr><C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

" Language:

"" Go Yaml Json:
Gautocmdft go,yaml,json,jsonschema snoremap <buffer> "    '
Gautocmdft go,yaml,json,jsonschema snoremap <buffer> '    "

" -------------------------------------------------------------------------------------------------
" Command Line: (c)

" Move beginning of the command line
" http://superuser.com/a/988874/483994
cnoremap <C-a>          <Home>
cnoremap <C-d>          <Del>
cnoremap <C-k>          <C-\>e(strpart(getcmdline(), 0, getcmdpos()-1))<CR>
cnoremap <expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
cnoremap <expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"

" -------------------------------------------------------------------------------------------------
" Terminal: (t)

" Emacs like mapping
tnoremap <silent>qq                <C-\><C-n>
tnoremap <silent><buffer><expr>jj  <SID>find_proc_in_tree(b:terminal_job_pid, 'nvim', 0) ? '<ESC>' : '<C-\><C-N>'
tnoremap <buffer><S-Left>          <C-[>b
tnoremap <buffer><C-Left>          <C-[>b
tnoremap <buffer><S-Right>         <C-[>f
tnoremap <buffer><C-Right>         <C-[>f
tnoremap <nowait><buffer><BS>      <BS>

" -------------------------------------------------------------------------------------------------

" Global:
" highlight! NonText                     gui=None      guifg=None     guibg=None
" highlight! TermCursor                  gui=None      guifg=#222223  guibg=#ffffff
" highlight! TermCursorNC                gui=reverse   guifg=#222222  guibg=#ffffff
" highlight! HoverFloat                  gui=None      guifg=#c7c8c8  guibg=#202122  blend=5
" highlight! manUnderline                gui=underline guifg=#81a2be  guibg=None
" highlight! manBold                     gui=None      guifg=#f0c674  guibg=None
" highlight! manItalic                   gui=italic    guifg=None     guibg=None

" FileType:
"" Go:
highlight! goErrorType                 gui=bold      guifg=#ff5370  guibg=None     guisp=fg_indexed,bg_indexed
" highlight! goField                     gui=NONE      guifg=#d9d9f0  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goField                     gui=None      guifg=None  guibg=None     guisp=fg_indexed,bg_indexed
" highlight! goFunction                  gui=bold      guifg=#82aaff  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! goFunctionCall              gui=bold      guifg=#ffcb6b  guibg=None     guisp=fg_indexed,bg_indexed
highlight! goImportedPkg               gui=None      guifg=#62d2ff  guibg=None  " guifg=#89ddff
highlight! goPackageComment            gui=italic    guifg=#838c93  guibg=None     guisp=fg_indexed,bg_indexed
highlight! goString                    gui=None      guifg=#92999f  guibg=None     guisp=fg_indexed,bg_indexed
highlight! goReceiverType              gui=bold      guifg=#81a2be  guibg=None     guisp=fg_indexed,bg_indexed
highlight! link                        goBuiltins                   Keyword
highlight! link                        goFormatSpecifier            PreProc
highlight! link                        goImportedPkg                Statement
highlight! link                        goStdlib                     Statement
highlight! link                        goStdlibReturn               PreProc

"" Python:
highlight! pythonSpaceError            gui=None      guifg=#787f86  guibg=#787f86     guisp=fg_indexed,bg_indexed
highlight! link                        pythonDelimiter              Special
highlight! link                        pythonNone                   pythonFunction
highlight! link                        pythonSelf                   pythonOperator

function! s:semshi_highlight()
  highlight semshiLocal           gui=None       guifg=#ff875f     guisp=fg_indexed,bg_indexed
  highlight semshiGlobal          gui=None       guifg=#ffaf00     guisp=fg_indexed,bg_indexed
  " highlight semshiImported        gui=bold       guifg=#ffaf00
  highlight semshiImported        gui=bold       guifg=#81a2be     guisp=fg_indexed,bg_indexed
  highlight semshiParameter       gui=None       guifg=#5fafff     guisp=fg_indexed,bg_indexed
  highlight semshiParameterUnused gui=underline  guifg=#87d7ff     guisp=fg_indexed,bg_indexed
  highlight semshiFree            gui=None       guifg=#ffafd7     guisp=fg_indexed,bg_indexed
  highlight semshiBuiltin         gui=None       guifg=#ff5fff     guisp=fg_indexed,bg_indexed
  " highlight semshiBuiltin         gui=bold       guifg=#b294bb
  highlight semshiAttribute       gui=None       guifg=#00ffaf     guisp=fg_indexed,bg_indexed
  highlight semshiSelf            gui=None       guifg=#b2b2b2     guisp=fg_indexed,bg_indexed
  highlight semshiUnresolved      gui=underline  guifg=#ffff00     guisp=fg_indexed,bg_indexed
  " highlight semshiSelected        gui=None       guifg=#ffffff  guibg=#d7005f
  highlight semshiSelected        gui=underline,italic guifg=#add6ff  guibg=#222223     guisp=fg_indexed,bg_indexed
  highlight semshiErrorSign       gui=None       guifg=#ffffff  guibg=#d70000     guisp=fg_indexed,bg_indexed
  highlight semshiErrorChar       gui=None       guifg=#ffffff  guibg=#d70000     guisp=fg_indexed,bg_indexed
  sign define semshiError text=E> texthl=semshiErrorSign
endfunction
Gautocmdft python call s:semshi_highlight()

" CPP:
highlight! doxygenBrief                gui=None      guifg=#81a2be  guibg=None     guisp=fg_indexed,bg_indexed
highlight! doxygenSpecialMultilineDesc gui=None      guifg=#81a2be  guibg=None     guisp=fg_indexed,bg_indexed
highlight! doxygenSpecialOnelineDesc   gui=None      guifg=#81a2be  guibg=None     guisp=fg_indexed,bg_indexed

"" Vim:
Gautocmdft qf hi Search                gui=None      guifg=None     guibg=#373b41     guisp=fg_indexed,bg_indexed

"" Plugin:

""" Denite:
" guibg=#343941
highlight! DeniteMatchedChar           gui=None      guifg=#85678f  guibg=None     guisp=fg_indexed,bg_indexed
highlight! DeniteMatchedRange          gui=None      guifg=#f0c674  guibg=None     guisp=fg_indexed,bg_indexed
highlight! DenitePreviewLine           gui=None      guifg=#85678f  guibg=None     guisp=fg_indexed,bg_indexed
highlight! DeniteUnderlined            gui=None      guifg=#85678f  guibg=None     guisp=fg_indexed,bg_indexed

"" ParenMatch:
highlight! ParenMatch                  gui=underline guifg=None     guibg=#343941  guisp=fg_indexed,bg_indexed

"" VimIlluminate:
highlight! illuminatedWord             gui=underline guifg=None     guibg=None     guisp=fg_indexed,bg_indexed
