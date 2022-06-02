"                                                                                                 "
"                 __                                                                              "
"  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                 "
"                                                                                                 "
" -------------------------------------------------------------------------------------------------

lua require("impatient")
lua require('zchee.nvim')
lua require('init')

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
" paths

if has('mac')
  set wildignore+=.DS_Store  " macOS only

  function! s:path_add_macos_headers()
    let s:developer_dir = '/Applications/Xcode.app/Contents/Developer'
    if isdirectory('/Applications/Xcode-beta.app')
      let s:developer_dir = '/Applications/Xcode-beta.app/Contents/Developer'
    endif
    let s:sdk_dir        = s:developer_dir . '/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk'
    let s:toolchain_dir  = s:developer_dir . '/Toolchains/XcodeDefault.xctoolchain'

    let s:macos_paths =
          \ expand($HOME) . '/.local/include'
          \ . ',/usr/local/include'
          \ . ',' . s:sdk_dir . '/usr/include'
          \ . ',' . s:toolchain_dir . '/usr/include/c++/v1'
          \ . ',' . s:toolchain_dir . '/usr/include/swift'
          \ . ',' . '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include'
          \ . ',' . s:toolchain_dir . '/usr/lib/clang/**/include'
          \ . ',' . '/Users/zchee/src/github.com/apple-oss-distributions/xnu'

    execute 'set path+=' . s:macos_paths

    " macOS frameworks
    if isdirectory(expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks')
      execute 'set path+=' . expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks'
    endif
  endfunction

  Gautocmdft c,cpp,objc,objcpp,go call s:path_add_macos_headers()  " only Go and C family filetypes
endif

function! s:go_include()
  if isdirectory('/usr/local/go/pkg/include')
    set path+=/usr/local/go/pkg/include
  endif
endfunction
Gautocmdft go,goasm call s:go_include()  " only Go filetype

function! s:path_add_python_headers()
  if isdirectory('/usr/local/Frameworks/Python.framework/Headers')
    set path+=/usr/local/Frameworks/Python.framework/Headers
  endif
endfunction
Gautocmdft c,cpp,objc,objcpp call s:path_add_python_headers()  " only Go and C family filetypes

" -------------------------------------------------------------------------------------------------
"" Neovim:

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

"" Gitcommit:
Gautocmd BufEnter COMMIT_EDITMSG  startinsert

"" Misc:
Gautocmdft jsp,asp,php,xml,perl syntax sync minlines=500 maxlines=1000

" -------------------------------------------------------------------------------------------------
" Plugin Setting:

"" LSP:
" LLVM Library Path
if isdirectory('/opt/llvm/devel')
  let s:llvm_base_path = '/opt/llvm/devel'
  let s:llvm_clang_version = '14.0.0'
elseif isdirectory('/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr')
  let s:llvm_base_path = '/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr'
  let s:llvm_clang_version = '13.0.0'
elseif isdirectory('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr')
  let s:llvm_base_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr'
  let s:llvm_clang_version = '13.0.0'
elseif isdirectory('/Library/Developer/CommandLineTools/usr')
  let s:llvm_base_path = '/Library/Developer/CommandLineTools/usr'
  let s:llvm_clang_version = '13.0.0'
else
  echoerr 'not found s:llvm_base_path and s:llvm_clang_version'
endif

if isdirectory('/Applications/Xcode-beta.app')
  let s:developer_dir = '/Applications/Xcode-beta.app'
elseif isdirectory('/Applications/Xcode.app')
  let s:developer_dir = '/Applications/Xcode.app'
endif

let s:clang_flags = [
      \ '-I'.s:llvm_base_path.'/include/c++/v1',
      \ '-I'.s:llvm_base_path.'/lib/clang'.s:llvm_clang_version.'/include',
      \ '-I/usr/local/include',
      \ '-I'.$SDKROOT.'/usr/include',
      \ '-F'.s:developer_dir.'/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks',
      \ '-F'.s:developer_dir.'/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/PrivateFrameworks',
      \
      \ '-isystem '.s:llvm_base_path.'/lib/clang/14.0.0',
      \ '-isysroot'.$SDKROOT,
      \
      \ '-mmacosx-version-min=12.0',
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
      \ '--clang-tidy',
      \ '--compile_args_from=filesystem',
      \ '--completion-parse=auto',
      \ '--completion-style=detailed',
      \ '--folding-ranges',
      \ '--ranking-model=decision_forest',
      \ '--function-arg-placeholders',
      \ '--header-insertion-decorators',
      \ '--header-insertion=iwyu',
      \ '--include-ineligible-results',
      \ '--j=20',
      \ '--offset-encoding=utf-16',
      \ '--pch-storage=memory',
      \ '--static-func-full-module-prefix',
      \ '--resource-dir=/opt/llvm/devel/lib/clang/14.0.0',
      \ ]  " --resource-dir: $ /opt/llvm/devel/bin/clang -print-resource-dir
      "\ '--resource-dir='.s:llvm_base_path.'/lib/clang/'.s:llvm_clang_version,
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
  if filereadable(getcwd() . 'clangd.dex')
    let g:clangd_commands_cfamily += ['--index-file=' . getcwd() . '/clangd.idx']
  elseif filereadable(g:c_cpp_root_path . '/clangd.idx')
    let g:clangd_commands_cfamily += ['--index-file=' . g:c_cpp_root_path . '/clangd.idx']
  elseif filereadable(g:c_cpp_root_path . '/build/clangd.idx')
    let g:clangd_commands_cfamily += ['--index-file=' . g:c_cpp_root_path . '/build/clangd.idx']
  elseif filereadable(getcwd() . '/../build/clangd.idx')
    let g:clangd_commands_cfamily += ['--index-file=' . getcwd() . '/../build/clangd.dex']

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
let s:lsp_root_markers_go = ['go.mod', 'vendor']
let s:lsp_root_markers_js = ['package.json', 'yarn.lock']
let s:lsp_root_markers_python = ['setup.py', 'pyproject.toml', 'tox.ini', '.flake8']
let s:lsp_root_markers_rust = ['Cargo.toml', 'build.rs', 'rustfmt.toml']
let s:lsp_root_markers = {
      \ 'c': s:lsp_root_markers_cfamily,
      \ 'cpp': s:lsp_root_markers_cfamily,
      \ 'go': s:lsp_root_markers_go,
      \ 'javascript': s:lsp_root_markers_js,
      \ 'lua': ['.git/'],
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
      \ 'go': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ 'gomod': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ 'gowork': [s:gopath . '/bin/gopls', '-remote=unix;/tmp/gopls.sock'],
      \ }
      " \ 'go': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-logfile=/tmp/gopls.log', '-remote=unix;/tmp/gopls.sock'],
      " \ 'gomod': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-logfile=/tmp/gopls.log', '-remote=unix;/tmp/gopls.sock'],
      " \ 'gowork': [s:gopath . '/bin/gopls', '-vv', '-rpc.trace', '-logfile=/tmp/gopls.log', '-remote=unix;/tmp/gopls.sock'],
let g:nvim_lsp#server_options = {
     \ 'go': {
     \   'env': [
     \     'GOPRIVATE="github.com/kouzoh"',
     \   ]}
     \ }
Gautocmd BufRead $HOME/go/src/gvisor.dev/gvisor/* let g:nvim_lsp#server_options = { 'go': { 'env': [ 'GOOS=linux'] }}
" Gautocmd BufRead $HOME/go/src/go-darwin.dev/tools/**/* let g:nvim_lsp#server_options = { 'go': { 'env': [ 'CGO_CFLAGS=-march=native -isysroot/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -I/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/13.0.0/include -Wno-deprecated-declarations', 'GOFLAGS=-tags=', 'CGO_LDFLAGS=-lc++ ' . system("find /opt/llvm/devel/lib -type f -name '*.a' | tr '\n' ' '") . ' -L/usr/lib -lz -lncurses.5.4' ] }}
let g:nvim_lsp_server_auto_start = v:true
let g:nvim_lsp_server_restart_on_crash = v:true
let g:nvim_lsp_server_stderr = v:false
let g:nvim_lsp_change_throttle = 0.5
let g:nvim_lsp_diagnostics_list = 'location-list'
let g:nvim_lsp_enable_diagnostics = v:true
let g:nvim_lsp_hover_highlight = 'Normal:NormalFloat'
let g:nvim_lsp_logLevel = 'debug'
let g:nvim_lsp_root_markers = s:lsp_root_markers
let g:nvim_lsp_selection_ui_auto_open = v:true
let g:nvim_lsp_selection_ui_type = 'quickfix'
let g:nvim_lsp_settings_paths = [ '.nvim/settings.json', $XDG_CONFIG_HOME.'/nvim/lsp/settings.json' ]
let g:nvim_lsp_trace = 'verbose'
let g:nvim_lsp_use_virtual_text = v:true
" debug
let g:nvim_lsp_debug = v:false
let g:nvim_lsp_enable_otel = v:true
let g:nvim_lsp_enable_datadog_profile = v:true
let g:nvim_lsp_enable_gops = v:false

"" FloatTerm:
" let g:floaterm_keymap_toggle = '<F10>'
" let g:floaterm_width = 0.9
" let g:floaterm_height = 0.9


" Caw:
" let g:caw_hatpos_skip_blank_line = 0
" let g:caw_no_default_keymappings = 1
" let g:caw_operator_keymappings = 0


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
let g:lightline.colorscheme = g:colors_name

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
  " if dein#tap('gina.vim')
  "   let l:branch_mark = ' ' . gina#component#repo#branch()
  " endif
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
      \ 'left':  [[ ]],
      \ 'right': [[ 'close' ]]
      \ }
      "\ 'left':  [[ 'tabs' ]],
      "\ 'right': [[ 'close' ]]
let g:lightline.tab = {
      \ 'active':   [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }  " , 'tabline': 1
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '  ' }
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#enable_devicons = 1


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


" Wakatime:
let g:wakatime_PythonBinary = g:python3_host_prog
let g:wakatime_OverrideCommandPrefix = 'wakatime'
let s:redraw_setting = 'auto'


" Editorconfig:
let g:EditorConfig_core_mode = 'python_external'


" Trans:
let g:trans_lang_credentials_file = $XDG_CONFIG_HOME.'/gcloud/credentials/kouzoh-p-zchee/trans-nvim.json'
let g:trans_lang_locale = 'ja'
let g:trans_lang_output = 'float'  " 'preview'
let g:trans_lang_cutset = ['//', '#']


" OpenBrowser:
let g:openbrowser_search_engines = {
      \ 'google': 'http://google.com/search?q={query}',
      \ }
let g:openbrowser_message_verbosity = 1


" EasyAlign:
let g:easy_align_ignore_groups = []


" Switchvim:
let g:switch_mapping = ""
let g:switch_custom_definitions = [ [1, 0], ['v:true', 'v:false'], ['yes', 'no'], ['on', 'off'], ['ON', 'OFF'], ['static', 'dynamic'] ]


" Operator Camelize:
" call operator#camelize#load()

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
let g:go#rename#prefill = v:false
let g:go#loaded#gosnippets = v:false
let g:go#terminal#height = 120
let g:go#terminal#start_insert = v:false
let g:go#terminal#width = 150
let g:go#test#all_package = v:false
let g:go#test#autosave = v:false
let g:go#test#flags = ['-v']
let g:go#debug = v:false
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


" Asm:
let g:nasm_loose_syntax = 1
let g:nasm_ctx_outside_macro = 1


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
      \ 'console=sh',
      \ 'cpp',
      \ 'dockerfile',
      \ 'go',
      \ 'graphql',
      \ 'help',
      \ 'mermaid',
      \ 'mysql',
      \ 'objective-c',
      \ 'proto',
      \ 'python',
      \ 'sh',
      \ 'sql',
      \ 'typescript',
      \ 'vim'
      \]
"" VimMarkdownfmt:
let g:markdownfmt_command = 'markdownfmt'
let g:markdownfmt_options = ''
let g:markdownfmt_autosave = 0
let g:markdownfmt_fail_silently = 0

" -------------------------------------------------------------------------------------------------
" testing plugins

" -------------------------------------------------------------------------------------------------
" Functions:

"" Filetye:
" TODO(zchee): unused
function! s:is_filetype(args)
  let l:ft = &filetype
  if (index(a:args, l:ft) >= 0)
    return v:true
  endif
  return v:false
endfunction


"" Help:
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

"" HelpGrep:
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


"" SyntaxInfo:
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


"" Binary Edit Mode:
" need open nvim with `-b` flag
function! BinaryMode() abort
  if !has('binary')
    echoerr "BinaryMode must be 'binary' option"
    return
  endif

  execute '%!xxd'
endfunction


"" Open the C/C++ Online Document:
" https://github.com/rhysd/dogfiles/blob/926f2b9c1856bbf3a8090f430831f2c94d7cc410/vimrc#L1399-L1423
function! s:open_online_cfamily_doc()
  " call dein#source('open-browser.vim')
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


"" Trim Whitespace:
function! s:trimSpace()
  if !&binary && &filetype !=# 'diff' && &filetype !=# 'markdown'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction
command! TrimSpace call s:trimSpace()


"" Lr:
" <lr-args> to browse lr(1) results in a new window, press return to open file in new window.
command! -nargs=* -complete=file Lr
      \ new | setl bt=nofile noswf | silent exe '0r!lr -Q ' <q-args> |
      \ 0 | res | map <buffer><C-M> $<C-W>F<C-W>_


"" LSPYamlSetSchema:
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

"" LuaVimInspect:
command! -complete=lua -nargs=* LuaVimInspect lua print(vim.inspect(<args>))

"" ManV:
"" Man with vertical split
command! -bang -bar -range=-1 -complete=customlist,man#complete -nargs=* ManV vertical Man <args>

"" CheckColor:
function s:check_colorscheme() abort
  call nvim_command("edit ~/.nvim/colors/".g:colors_name.".vim | source $VIMRUNTIME/tools/check_colors.vim")
  wincmd x
  setlocal filetype=vim
endfunction
command! CheckColorScheme call s:check_colorscheme()

"" TerminalV:
command! -nargs=* TerminalV vsplit | terminal <args>

" TODO(zchee): unused
function! TextEntered(text)
  if a:text == 'exit' || a:text == 'quit'
    stopinsert
    close
  else
    call append(line('$') - 1, 'Entered: "' . a:text . '"')
    " Reset 'modified' to allow the buffer to be closed.
    set nomodified
  endif
endfunc
" call prompt_setcallback(bufnr(''), function('TextEntered'))

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
" nnoremap              <Leader>ga        :<C-u>Gina add %<CR>
" nnoremap              <Leader>gc        :<C-u>Gina commit<CR>
" nnoremap              <Leader>gp        :<C-u>Gina push<CR>
" nnoremap              <Leader>gs        :<C-u>Gina status<CR>
     map           <Leader><Leader>     <Plug>(easymotion-prefix)

"" <LocalLeader>
" nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep -buffer-name='grep/rg'<CR>
nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
" nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer'<CR>
" nnoremap <silent><LocalLeader>g         :<C-u>Denite line -buffer-name='line'<CR>
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
" nnoremap         <silent>-        :<C-u>CHADopen<CR>

nnoremap         <nowait>@        ^
nnoremap         <nowait>^        @

nmap                     ga       <Plug>(LiveEasyAlign)
" nmap             <silent>gc       <Plug>(caw:hatpos:toggle)
nnoremap         <silent>gs       :<C-u>Switch<CR>
nmap             <silent>gx       <Plug>(openbrowser-smart-search)
" nmap     <silent><nowait>j        <Plug>(accelerated_jk_j)
" nmap     <silent><nowait>k        <Plug>(accelerated_jk_k)
" accelerated <Left>
" nmap     <silent><nowait><Left>   :<C-u>call accelerated#time_driven#command('h')<CR>
" accelerated <Right>
" nmap     <silent><nowait><Right>  :<C-u>call accelerated#time_driven#command('l')<CR>

nnoremap                 Q        gq
nnoremap         <nowait>s        A
nnoremap         <nowait>x        "_x
nnoremap                 zj       zjzt
nnoremap                 zk       2zkzjzt
nnoremap                 ZQ       <Nop>
nnoremap         <nowait><Up>     <Up>
nnoremap         <nowait><Down>   <Down>

nnoremap         <silent><C-e>    <C-e><C-e><C-e><C-e>
" nnoremap         <silent><C-g>    :<C-u>DeniteProjectDir grep/rg -buffer-name='grep' -path=`expand('%:p:h')` -winheight=40 -preview-height=200 -sorters=sorter/path -empty<CR>
nnoremap         <silent><C-g>    :<C-u>Telescope live_grep<CR>
nnoremap         <silent><C-p>    <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap         <silent><C-q>    :<C-u>nohlsearch<CR>
nmap             <silent><C-w>z   <Plug>(zoom-toggle)
nnoremap         <silent><C-y>    <C-y><C-y><C-y><C-y>

nnoremap              <S-Down>    <Nop>
nnoremap               <S-Tab>    %
" nnoremap         <nowait><S-Tab>  %
nnoremap                 <S-Up>   <Nop>


" Language:

"" Go:
Gautocmdft go nnoremap <LocalLeader>go  :<C-u>DeniteProjectDir grep -buffer-name='grep' -path=/usr/local/go/src<CR>
Gautocmd BufNewFile,BufRead,BufEnter godoc://** nmap <C-]> <CR>

"" C CXX ObjC:
Gautocmdft c,cpp  nnoremap <silent><buffer><C-k>       :<C-u>call <SID>open_online_cfamily_doc()<CR>
" if dein#tap('vim-clang-format')
"   Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>x        <Plug>(operator-clang-format)
"   Gautocmdft c,cpp,objc,objcpp,proto nmap     <buffer><Leader>C        :<C-u>ClangFormatAutoToggle<CR>
"   Gautocmdft c,cpp,objc,objcpp,proto nnoremap <buffer><LocalLeader>f   :<C-u>ClangFormat<CR>
" endif

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
inoremap <silent><C-y>  <C-r>*
inoremap <silent><C-j>  <C-r>*

" Language:

"" Go Yaml Json:
" Gautocmdft go,yaml,json,jsonschema inoremap <buffer><expr>'    <cmd>lua require('nvim-autopairs').autopairs_map(1,'"')<CR>
" Gautocmdft go,yaml,json,jsonschema inoremap <buffer><expr>"    <cmd>lua require('nvim-autopairs').autopairs_map(1,"'")<CR>
" inoremap <buffer><expr>'    <cmd>lua require('nvim-autopairs').autopairs_map(1,'"')<CR>
" inoremap <buffer><expr>"    <cmd>lua require('nvim-autopairs').autopairs_map(1,"'")<CR>

"" Swift:
" Gautocmdft swift imap <buffer><C-k>  <Plug>(autocomplete_swift_jump_to_placeholder)

" Plugins:
"" Neosnippet:
imap     <silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"


"" GitHub Copilot
" imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
" let g:copilot_no_tab_map = v:true
" Gautocmd BufNewFile,BufRead,BufEnter Copilot disable

highlight CopilotSuggestion guifg=#555555 ctermfg=8

" -------------------------------------------------------------------------------------------------
" Visual Select: (v)

" Do not add register to current cursor word
" move to start of line
"        c : do not add register to current cursor word
"        x : do not add register to current cursor word
"        P : do not add register to current cursor word
"        p : do not add register to current cursor word
"        @ : swap @ and ^ for dvorak
"        ^ : swap @ and ^ for dvorak
"       ga :
"       gc :
"       gs : sort by ignorecase alphabetically
"       tu :
"        v : move to the  last non-blank character of the line
"        V : move to the first non-blank character of the line

vnoremap                  <S-Tab>    %
vnoremap                <nowait>c    "_c
vnoremap                <nowait>P    "_dP
vnoremap                <nowait>p    "_dp
vnoremap                <nowait>x    "_x
vnoremap                <nowait>@    ^
vnoremap                <nowait>^    @
vmap                    <silent>ga   <Plug>(LiveEasyAlign)
" vmap                    <silent>gc   <Plug>(caw:hatpos:toggle)
vnoremap                <silent>gs   :<C-u>'<,'>sort i<CR>
vmap                    <silent>gx   <Plug>(openbrowser-smart-search)
vmap                    <silent>tu   <Plug>(operator-convert-case-upper-camel)
vnoremap                <nowait>v    g_
vnoremap                <nowait>V    ^


" Language:

"" Protobuf:
Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

"" C CXX ObjC:
Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

" -------------------------------------------------------------------------------------------------
" Visual: (x)

" xmap                <LocalLeader>    <Plug>(operator-replace)
xnoremap            <silent><C-t>    :<C-u>Trans<CR>

xnoremap               <silent>nu :lua require"treesitter-unit".select()<CR>
xnoremap               <silent>tu :lua require"treesitter-unit".select(true)<CR>

" Language:

" -------------------------------------------------------------------------------------------------
" Operator Pending: (o)

onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>

" -------------------------------------------------------------------------------------------------
" Select: (s)

" neosnippet
smap  <nowait><silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

" Language:

"" Go Yaml Json:
Gautocmdft go,yaml,json,jsonschema snoremap <buffer> "    '
Gautocmdft go,yaml,json,jsonschema snoremap <buffer> '    "

" -------------------------------------------------------------------------------------------------
" Command Line: (c)

" Move beginning of the command line
" http://superuser.com/a/988874/483994
cnoremap       <C-a>    <Home>
cnoremap       <C-d>    <Del>
cnoremap       <C-k>    <C-\>e(strpart(getcmdline(), 0, getcmdpos()-1))<CR>
cnoremap <expr><Up>     pumvisible() ? "\<C-p>"  : "\<Up>"
cnoremap <expr><Down>   pumvisible() ? "\<C-n>"  : "\<Down>"
cnoremap       <S-Tab>  <C-p>

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

" Highlight:

"" Go:
" " highlight! goErrorType                 gui=bold      guifg=#ff5370  guibg=NONE     guisp=fg_indexed,bg_indexed
" " " highlight! goField                     gui=NONE      guifg=#d9d9f0  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! goField                     gui=NONE      guifg=NONE  guibg=NONE     guisp=fg_indexed,bg_indexed
" " " highlight! goFunction                  gui=bold      guifg=#82aaff  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! goFunctionCall              gui=bold      guifg=#ffcb6b  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! goImportedPkg               gui=NONE      guifg=#62d2ff  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! goPackageComment            gui=italic    guifg=#838c93  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! goComment                   gui=italic    guifg=#92999f  guibg=None     guisp=fg_indexed,bg_indexed blend=0
" " highlight! goString                    gui=NONE      guifg=#9ba3a8  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! goReceiverType              gui=bold      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed
" " highlight! link                        goBuiltins                   Keyword
" " highlight! link                        goFormatSpecifier            PreProc
" " highlight! link                        goImportedPkg                Statement
" " highlight! link                        goStdlib                     Statement
" " highlight! link                        goStdlibReturn               PreProc
" highlight! goErrorType                 gui=bold      guifg=#ff5370  guibg=NONE       guisp=fg_indexed,bg_indexed
" highlight! goField                     gui=NONE      guifg=#d9d9f0  guibg=NONE
"                                                                                      
" " highlight! goField                     gui=NONE      guifg=NONE  guibg=NONE          guisp=fg_indexed,bg_indexed
" highlight! goFunction                  gui=bold      guifg=#82aaff  guibg=NONE       guisp=fg_indexed,bg_indexed
"                                                                                      
" highlight! goFunctionCall              gui=bold      guifg=#ffbf6b  guibg=NONE
" highlight! goImportedPkg               gui=NONE      guifg=#82aaff  guibg=NONE       guisp=fg_indexed,bg_indexed
" highlight! goPackageComment            gui=italic    guifg=#838c93  guibg=NONE       guisp=fg_indexed,bg_indexed
" highlight! goString                    gui=NONE      guifg=#92999f  guibg=NONE       guisp=fg_indexed,bg_indexed
" highlight! goReceiverType              gui=bold      guifg=#81a2be  guibg=NONE       guisp=fg_indexed,bg_indexed
" highlight! link                        goBuiltins                   Keyword
" highlight! link                        goFormatSpecifier            PreProc
" " highlight! link                        goImportedPkg                Statement
" highlight! link                        goStdlib                     Statement
" highlight! link                        goStdlibReturn               PreProc

"" Python:
highlight! pythonSpaceError            gui=NONE      guifg=#787f86  guibg=#787f86     guisp=fg_indexed,bg_indexed
highlight! link                        pythonDelimiter              Special
highlight! link                        pythonNONE                   pythonFunction
highlight! link                        pythonSelf                   pythonOperator

" CPP:
highlight! doxygenBrief                gui=NONE      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! doxygenSpecialMultilineDesc gui=NONE      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! doxygenSpecialOnelineDesc   gui=NONE      guifg=#81a2be  guibg=NONE     guisp=fg_indexed,bg_indexed

"" Yaml:
" highlight! yamlString                  gui=NONE      guifg=NONE     guibg=NONE     guisp=fg_indexed,bg_indexed

"" Vim:
Gautocmdft qf hi Search                gui=NONE      guifg=NONE     guibg=#373b41  guisp=fg_indexed,bg_indexed

"" Plugin:

""" Denite:
" guibg=#343941
highlight! DeniteMatchedChar           gui=NONE      guifg=#85678f  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! DeniteMatchedRange          gui=NONE      guifg=#f0c674  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! DenitePreviewLine           gui=NONE      guifg=#85678f  guibg=NONE     guisp=fg_indexed,bg_indexed
highlight! DeniteUnderlined            gui=NONE      guifg=#85678f  guibg=NONE     guisp=fg_indexed,bg_indexed

"" ParenMatch:
highlight! ParenMatch                  gui=underline guifg=NONE     guibg=#343941  guisp=fg_indexed,bg_indexed

"" VimIlluminate:
highlight! illuminatedWord             gui=underline guifg=NONE     guibg=NONE     guisp=fg_indexed,bg_indexed

"" MatchUp
highlight! MatchParen                  gui=NONE      guifg=NONE     guibg=#343941  guisp=fg_indexed,bg_indexed
highlight! MatchWord                   gui=NONE      guifg=NONE     guibg=#343941  guisp=fg_indexed,bg_indexed
