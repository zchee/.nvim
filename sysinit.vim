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

"" Terminal:
let $LC_MESSAGES     = "en_US.UTF-8"
" let $TERM            = 'vte-direct'

" -------------------------------------------------------------------------------------------------
" Neovim Configs:

"" Remote Plugins:
let g:python_host_prog          = '/usr/local/opt/python2/bin/python2'
let g:loaded_python_provider    = 0
let g:python3_host_prog         = '/usr/local/opt/python3/bin/python3'
" let g:loaded_python3_provider = 1

let g:loaded_ruby_provider      = 0
let g:loaded_node_provider      = 0

" -------------------------------------------------------------------------------------------------
" Ignore Plugins:

"" from https://github.com/justinmk/config/blob/master/.config/nvim/init.vim
let g:loaded_rrhelper = 1
let g:did_install_default_menus = 1  " avoid stupid menu.vim (saves ~100ms)

let g:loaded_netrw                         = v:true              " $VIMRUNTIME/autoload/netrw.vim
let g:loaded_netrwFileHandlers             = v:true              " $VIMRUNTIME/autoload/netrwFileHandlers.vim
let g:loaded_netrwSettings                 = v:true              " $VIMRUNTIME/autoload/netrwSettings.vim
let g:loaded_sql_completion                = 160                 " $VIMRUNTIME/autoload/sqlcomplete.vim
let g:loaded_tar                           = v:true              " $VIMRUNTIME/autoload/tar.vim
let g:loaded_vimball                       = v:true              " $VIMRUNTIME/autoload/vimball.vim
let g:loaded_xmlformat                     = v:true              " $VIMRUNTIME/autoload/xmlformat.vim
let g:loaded_zip                           = v:true              " $VIMRUNTIME/autoload/zip.vim
let loaded_less                            = v:true              " $VIMRUNTIME/macros/less.vim
let loaded_gzip                            = v:true              " $VIMRUNTIME/plugin/gzip.vim
let loaded_matchit                         = v:true              " $VIMRUNTIME/plugin/matchit.vim
let g:loaded_matchparen                    = v:true              " $VIMRUNTIME/plugin/matchparen.vim
let g:loaded_netrwPlugin                   = "156"               " $VIMRUNTIME/plugin/netrwPlugin.vim
let loaded_rrhelper                        = v:true              " $VIMRUNTIME/plugin/rrhelper.vim
let loaded_spellfile_plugin                = v:true              " $VIMRUNTIME/plugin/spellfile.vim
let g:loaded_tarPlugin                     = "v29"               " $VIMRUNTIME/plugin/tarPlugin.vim
let g:loaded_2html_plugin                  = 'vim7.4_v2'         " $VIMRUNTIME/plugin/tohtml.vim
let g:loaded_tutor_mode_plugin             = v:true              " $VIMRUNTIME/plugin/tutor.vim
let g:loaded_zipPlugin                     = "v28"               " $VIMRUNTIME/plugin/zipPlugin.vim
let myscriptsfile                          = v:true              " $VIMRUNTIME/scripts.vim
let did_install_default_menus              = v:true              " $VIMRUNTIME/menu.vim
let did_install_syntax_menu                = v:true              " $VIMRUNTIME/menu.vim
let did_menu_trans                         = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_help_dialog                = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_path_dialog                = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_tags_dialog                = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_textwidth_dialog           = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_fileformat_dialog          = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_fileformat_choices         = v:true              " $VIMRUNTIME/menu.vim
let g:ctags_command                        = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_set_lang_to                = v:true              " $VIMRUNTIME/menu.vim
let g:xxdprogram                           = v:true              " $VIMRUNTIME/menu.vim
let do_no_lazyload_menus                   = v:true              " $VIMRUNTIME/menu.vim
let no_buffers_menu                        = v:true              " $VIMRUNTIME/menu.vim
let bmenu_priority                         = v:true              " $VIMRUNTIME/menu.vim
let g:bmenu_max_pathlen                    = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_no_file                    = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_spell_change_ARG_to        = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_spell_add_ARG_to_word_list = v:true              " $VIMRUNTIME/menu.vim
let g:menutrans_spell_ignore_ARG           = v:true              " $VIMRUNTIME/menu.vim

"" DO NOT SET: !!
" let g:loaded_shada_autoload              = v:true              " $VIMRUNTIME/autoload/shada.vim
" let g:loaded_syntax_completion           = 130                 " $VIMRUNTIME/autoload/syntaxcomplete.vim
" let g:loaded_man                         = v:true              " $VIMRUNTIME/plugin/man.vim
" let g:loaded_remote_plugins              = '/path/to/manifest' " $VIMRUNTIME/plugin/rplugin.vim
" let g:loaded_shada_plugin                = v:true              " $VIMRUNTIME/plugin/shada.vim

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
