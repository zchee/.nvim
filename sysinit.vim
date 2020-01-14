" sysinit.vim
"
" Usage:
"   $ ln -s /path/to/sysinit.vim /usr/local/share/nvim/sysinit.vim
" -------------------------------------------------------------------------------------------------

" silent! filetype off

" Environment Variables:

let $XDG_RUNTIME_DIR = expand('/run/user/502')
let $XDG_CACHE_HOME  = expand($HOME.'/.cache')
let $XDG_CONFIG_DIRS = expand('/etc/xdg')
let $XDG_CONFIG_HOME = expand($HOME.'/.config')
let $XDG_DATA_DIRS   = expand('/usr/local/share:/usr/share')
let $XDG_DATA_HOME   = expand($HOME.'/.local/share')
let $NVIM_LOG_FILE   = expand($HOME.'/.local/share/nvim/log')

let $MANPATH        = '/usr/local/share/man:/usr/share/man:/usr/local/opt/bison/share/man:/usr/local/opt/coreutils/share/man:/usr/local/opt/curl-head/share/man:/usr/local/opt/file-formula/share/man:/usr/local/opt/findutils/share/man:/usr/local/opt/gettext/share/man:/usr/local/opt/git-head/share/man:/usr/local/opt/gnu-sed/share/man:/usr/local/opt/gnu-tar/share/man:/usr/local/opt/gnu-which/libexec/gnuman:/usr/local/opt/grep/share/man:/usr/local/opt/libressl/share/man:/usr/local/opt/libxml2/share/man:/usr/local/opt/make/share/man:/usr/local/opt/ncurses-head/share/man:/usr/local/opt/openssl/share/man:/usr/local/opt/sqlite3/share/man:/opt/llvm/devel/share/man:/opt/llvm/stable/share/man:/usr/local/opt/binutils/share/man:/Applications/Xcode-beta.app/Contents/Developer/usr/share/man:/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man:/usr/local/MacGPG2/share/man'

"" Terminal:
let $LANG              = "en_US.UTF-8"
" let $TERM            = 'vte-direct'

" -------------------------------------------------------------------------------------------------
" Neovim Configs:

"" Remote Plugins:
" let g:python_host_prog          = '/usr/local/opt/python@2/bin/python2'
let g:loaded_python_provider    = 0                              " $VIMRUNTIME/autoload/provider/python.vim
let g:python3_host_prog         = '/usr/local/opt/python/bin/python3'
let g:loaded_node_provider      = 0                              " $VIMRUNTIME/autoload/provider/node.vim
let g:loaded_ruby_provider      = 0                              " $VIMRUNTIME/autoload/provider/ruby.vim

let g:no_man_maps = 0
let g:ft_man_folding_enable = 0
" let g:man_hardwrap = v:false

" -------------------------------------------------------------------------------------------------
" Ignore Plugins:

"" $VIMRUNTIME
let g:did_install_default_menus            = 1                   " $VIMRUNTIME/menu.vim
let did_install_syntax_menu                = 1                   " $VIMRUNTIME/menu.vim
let did_menu_trans                         = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_help_dialog                = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_path_dialog                = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_tags_dialog                = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_textwidth_dialog           = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_fileformat_dialog          = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_fileformat_choices         = 1                   " $VIMRUNTIME/menu.vim
let g:ctags_command                        = 1                   " $VIMRUNTIME/menu.vim
let g:menutrans_set_lang_to                = 1                   " $VIMRUNTIME/menu.vim
let g:xxdprogram                           = 1                   " $VIMRUNTIME/menu.vim
" let do_no_lazyload_menus                   = 1                   " $VIMRUNTIME/menu.vim
" let no_buffers_menu                        = 1                   " $VIMRUNTIME/menu.vim
" let bmenu_priority                         = 1                   " $VIMRUNTIME/menu.vim
" let g:bmenu_max_pathlen                    = 1                   " $VIMRUNTIME/menu.vim
" let g:menutrans_no_file                    = 1                   " $VIMRUNTIME/menu.vim
" let g:menutrans_spell_change_ARG_to        = 1                   " $VIMRUNTIME/menu.vim
" let g:menutrans_spell_add_ARG_to_word_list = 1                   " $VIMRUNTIME/menu.vim
" let g:menutrans_spell_ignore_ARG           = 1                   " $VIMRUNTIME/menu.vim
let g:skip_loading_mswin                   = 1                   " $VIMRUNTIME/mswin.vim
" let myscriptsfile                          = 1                   " $VIMRUNTIME/scripts.vim

"" $VIMRUNTIME/pack/dist/opt
let loaded_cfilter                         = 1                   " $VIMRUNTIME/pack/dist/opt/cfilter/plugin/cfilter.vim
let g:loaded_matchit                       = 1                   " $VIMRUNTIME/pack/dist/opt/matchit/plugin/matchit.vim
" let g:loaded_vimball                       = "v37"               " $VIMRUNTIME/pack/dist/opt/vimball/autoload/vimball.vim
" let g:loaded_vimballPlugin                 = "v37"               " $VIMRUNTIME/pack/dist/opt/vimball/plugin/vimballPlugin.vim

"" $VIMRUNTIME/autoload
let g:loaded_netrw                         = 1                   " $VIMRUNTIME/autoload/netrw.vim
let g:loaded_netrwFileHandlers             = 1                   " $VIMRUNTIME/autoload/netrwFileHandlers.vim
let g:loaded_netrwSettings                 = 1                   " $VIMRUNTIME/autoload/netrwSettings.vim
let g:loaded_sql_completion                = 160                 " $VIMRUNTIME/autoload/sqlcomplete.vim
" disable?
let g:loaded_syntax_completion             = 130                 " $VIMRUNTIME/autoload/syntaxcomplete.vim
let g:loaded_tar                           = 1                   " $VIMRUNTIME/autoload/tar.vim
let g:loaded_xmlformat                     = 1                   " $VIMRUNTIME/autoload/xmlformat.vim
let g:loaded_zip                           = 1                   " $VIMRUNTIME/autoload/zip.vim

let loaded_less                            = 1                   " $VIMRUNTIME/macros/less.vim

let loaded_gzip                            = 1                   " $VIMRUNTIME/plugin/gzip.vim
let g:loaded_matchparen                    = 1                   " $VIMRUNTIME/plugin/matchparen.vim
let g:loaded_netrwPlugin                   = "v165"              " $VIMRUNTIME/plugin/netrwPlugin.vim
let loaded_spellfile_plugin                = 1                   " $VIMRUNTIME/plugin/spellfile.vim
let g:loaded_tarPlugin                     = "v29"               " $VIMRUNTIME/plugin/tarPlugin.vim
let g:loaded_2html_plugin                  = 'vim7.4_v2'         " $VIMRUNTIME/plugin/tohtml.vim
let g:loaded_tutor_mode_plugin             = 1                   " $VIMRUNTIME/plugin/tutor.vim
let g:loaded_zipPlugin                     = "v28"               " $VIMRUNTIME/plugin/zipPlugin.vim

"" DO NOT SET: !!
" let g:loaded_clipboard_provider            = 1                   " $VIMRUNTIME/autoload/provider/clipboard.vim
let s:loaded_pythonx_provider              = 1                   " $VIMRUNTIME/autoload/provider/pythonx.vim
" let g:loaded_man                           = 1                   " $VIMRUNTIME/autoload/man.vim
" let g:loaded_msgpack_autoload              = 1                   " $VIMRUNTIME/autoload/msgpack.vim
" let g:loaded_shada_autoload                = 1                   " $VIMRUNTIME/autoload/shada.vim
" let g:loaded_syntax_completion             = 130                 " $VIMRUNTIME/autoload/syntaxcomplete.vim
" let g:loaded_remote_plugins                = '/path/to/manifest' " $VIMRUNTIME/plugin/rplugin.vim
" let g:loaded_shada_plugin                  = 1                   " $VIMRUNTIME/plugin/shada.vim

"" WHAT: ?
" let g:netrw_nogx                         = v:true      " :help g:netrw_nogx

"" OLD:
" let g:did_menu_trans            = 1 " $VIMRUNTIME/menu.vim
" let g:netrw_nogx                = 1 " :help g:netrw_nogx
" let g:loaded_less               = 1 " $VIMRUNTIME/macros/less.vim
" let g:loaded_gzip               = 1 " $VIMRUNTIME/plugin/gzip.vim
" let g:loaded_matchit            = 1 " $VIMRUNTIME/plugin/matchit.vim
" let g:loaded_matchparen         = 1 " $VIMRUNTIME/plugin/matchparen.vim
" let g:loaded_netrwPlugin        = 1 " $VIMRUNTIME/plugin/netrwPlugin.vim
" let g:loaded_rrhelper           = 1 " $VIMRUNTIME/plugin/rrhelper.vim
" let g:loaded_spellfile_plugin   = 1 " $VIMRUNTIME/plugin/spellfile.vim
" let g:loaded_tarPlugin          = 1 " $VIMRUNTIME/plugin/tarPlugin.vim
" let g:loaded_2html_plugin       = 1 " $VIMRUNTIME/plugin/tohtml.vim
" let g:loaded_tutor_mode_plugin  = 1 " $VIMRUNTIME/plugin/tutor.vim
" let g:loaded_vimballPlugin      = 1 " $VIMRUNTIME/plugin/vimballPlugin
" let g:loaded_zipPlugin          = 1 " $VIMRUNTIME/plugin/zipPlugin.vim
" let g:myscriptsfile             = 1 " $VIMRUNTIME/scripts.vim
" let g:load_doxygen_syntax       = 1 " $VIMRUNTIME/syntax/doxygen.vim
" let g:suppress_doxygen          = 1 " $VIMRUNTIME/syntax/doxygen.vim
