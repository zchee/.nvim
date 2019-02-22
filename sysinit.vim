" sysinit.vim
"
" Usage:
"   $ ln -s /path/to/sysinit.vim /usr/local/share/nvim/sysinit.vim
" -------------------------------------------------------------------------------------------------
" Environment Variables:

let $XDG_RUNTIME_DIR = expand('/run/user/503')
let $XDG_CACHE_HOME = expand($HOME.'/.cache')
let $XDG_CONFIG_DIRS = expand('/etc/xdg')
let $XDG_CONFIG_HOME = expand($HOME.'/.config')
let $XDG_DATA_DIRS = expand('/usr/local/share:/usr/share')
let $XDG_DATA_HOME = expand($HOME.'/.local/share')
let $NVIM_LOG_FILE = expand($HOME.'/.local/share/nvim/log')
let $LC_MESSAGES = "en_US.UTF-8"

" -------------------------------------------------------------------------------------------------
" Neovim Configs:

let g:python_host_prog = '/usr/local/opt/pypy/bin/pypy'
" let g:python3_host_prog = '/usr/local/opt/pypy3/bin/pypy3'
let g:python3_host_prog = '/usr/local/opt/pypy3-release/bin/pypy3'
" let g:python3_host_prog = '/usr/local/opt/python3/bin/python3'
let g:loaded_python_provider = 1
let g:loaded_ruby_provider = 1
let g:loaded_node_provider = 1
" let g:clipboard = {
"      \   'name': 'macOS-clipboard',
"      \   'copy': {
"      \      '+': 'pbcopy',
"      \      '*': 'pbcopy',
"      \    },
"      \   'paste': {
"      \      '+': 'pbpaste',
"      \      '*': 'pbpaste',
"      \   },
"      \   'cache_enabled': 1,
"      \ }

" -------------------------------------------------------------------------------------------------
" Ignore Plugins:

let g:did_install_default_menus = 1 " $VIMRUNTIME/menu.vim
let g:did_menu_trans            = 1 " $VIMRUNTIME/menu.vim
let g:load_doxygen_syntax       = 1 " $VIMRUNTIME/syntax/doxygen.vim
let g:loaded_2html_plugin       = 1 " $VIMRUNTIME/plugin/tohtml.vim
let g:loaded_gzip               = 1 " $VIMRUNTIME/plugin/gzip.vim
let g:loaded_less               = 1 " $VIMRUNTIME/macros/less.vim
let g:loaded_matchit            = 1 " $VIMRUNTIME/plugin/matchit.vim
let g:loaded_matchparen         = 1 " $VIMRUNTIME/plugin/matchparen.vim
let g:loaded_netrw              = 1 " $VIMRUNTIME/autoload/netrw.vim
let g:loaded_netrwFileHandlers  = 1 " $VIMRUNTIME/autoload/netrwFileHandlers.vim
let g:loaded_netrwPlugin        = 1 " $VIMRUNTIME/plugin/netrwPlugin.vim
let g:loaded_netrwSettings      = 1 " $VIMRUNTIME/autoload/netrwSettings.vim
let g:loaded_rrhelper           = 1 " $VIMRUNTIME/plugin/rrhelper.vim
let g:loaded_spellfile_plugin   = 1 " $VIMRUNTIME/plugin/spellfile.vim
let g:loaded_sql_completion     = 1 " $VIMRUNTIME/autoload/sqlcomplete.vim
let g:loaded_syntax_completion  = 1 " $VIMRUNTIME/autoload/syntaxcomplete.vim
let g:loaded_tar                = 1 " $VIMRUNTIME/autoload/tar.vim
let g:loaded_tarPlugin          = 1 " $VIMRUNTIME/plugin/tarPlugin.vim
let g:loaded_tutor_mode_plugin  = 1 " $VIMRUNTIME/plugin/tutor.vim
let g:loaded_vimball            = 1 " $VIMRUNTIME/autoload/vimball.vim
let g:loaded_vimballPlugin      = 1 " $VIMRUNTIME/plugin/vimballPlugin
let g:loaded_zip                = 1 " $VIMRUNTIME/autoload/zip.vim
let g:loaded_zipPlugin          = 1 " $VIMRUNTIME/plugin/zipPlugin.vim
let g:myscriptsfile             = 1 " $VIMRUNTIME/scripts.vim
let g:netrw_nogx                = 1
let g:suppress_doxygen          = 1 " $VIMRUNTIME/syntax/doxygen.vim
