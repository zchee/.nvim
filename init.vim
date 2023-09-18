"                                                                                                 "
"                 __                                                                              "
"  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                 "
"                                                                                                 "
" -------------------------------------------------------------------------------------------------

if exists('g:vscode')
  source 'vscode.vim'
  finish
endif

lua require("zchee.nvim")
lua require("init")

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
" Gautocmd:

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
" Vim:
"" nested autoload
Gautocmdft qf hi Search  gui=None  guifg=None  guibg=#373b41

" -------------------------------------------------------------------------------------------------
" Plugin Setting:

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


" Wakatime:
let g:wakatime_CLIPath = '/usr/local/bin/wakatime'


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
" let g:go#build#appengine = v:false
let g:go#build#autosave = v:false
" let g:go#build#is_not_gb = v:false
" " let g:go#build#flags = ['-tags', 'gojay']
let g:go#build#force = v:false
let g:go#fmt#autosave  = v:false
let g:go#fmt#mode = 'goimports'
" let g:go#guru#keep_cursor = {
"       \ 'callees'    : v:false,
"       \ 'callers'    : v:false,
"       \ 'callstack'  : v:false,
"       \ 'definition' : v:true,
"       \ 'describe'   : v:false,
"       \ 'freevars'   : v:false,
"       \ 'implements' : v:false,
"       \ 'peers'      : v:false,
"       \ 'pointsto'   : v:false,
"       \ 'referrers'  : v:false,
"       \ 'whicherrs'  : v:false
"       \ }
" let g:go#generate#test#subtest = v:true
" let g:go#generate#test#parallel = v:true
" let g:go#generate#test#template_dir = $XDG_CONFIG_HOME . '/go/template/gotests'
" let g:go#generate#test#template_params_path = ''
" let g:go#guru#reflection = v:false
" let g:go#highlight#cgo = v:true
" let g:go#iferr#autosave = v:false
" let g:go#lint#golint#autosave = v:false
" let g:go#lint#golint#ignore = ['internal', 'vendor', 'pb', 'fbs']
" let g:go#lint#golint#mode = 'root'
" let g:go#lint#govet#autosave = v:false
" let g:go#lint#govet#flags = ['-v', '-all']
" let g:go#lint#govet#ignore = ['vendor', 'testdata', '_tmp']
" let g:go#lint#metalinter#autosave = v:false
" let g:go#lint#metalinter#autosave#tools = ['vet', 'golint']
" let g:go#lint#metalinter#deadline = '20s'
" let g:go#lint#metalinter#skip_dir = ['internal', 'vendor', 'testdata', '__*.go', '*_test.go']
" let g:go#lint#metalinter#tools = ['vet', 'golint']
" let g:go#rename#prefill = v:false
" let g:go#loaded#gosnippets = v:false
" let g:go#terminal#height = 120
" let g:go#terminal#start_insert = v:false
" let g:go#terminal#width = 150
" let g:go#test#all_package = v:false
" let g:go#test#autosave = v:false
" let g:go#test#flags = ['-v']
" let g:go#debug = v:false
" let g:go#debug#pprof = v:false
" let g:go#loaded#gosnippets = 1
" """ highlight
" let g:go#highlight#terminal#test               = 1  " default : 0
" let g:go_highlight_fold_enable_comment         = 1  " default : 0
" let g:go_highlight_generate_tags               = 1  " default : 0
" let g:go_highlight_string_spellcheck           = 0  " default : 1
" let g:go_highlight_format_strings              = 1  " default : 1
" let g:go_highlight_fold_enable_package_comment = 1  " default : 0
" let g:go_highlight_fold_enable_block           = 1  " default : 0
" let g:go_highlight_import                      = 1  " default : 0
" let g:go_highlight_fold_enable_varconst        = 1  " default : 0
" let g:go_highlight_array_whitespace_error      = 0  " default : 1
" let g:go_highlight_trailing_whitespace_error   = 0  " default : 1
" let g:go_highlight_chan_whitespace_error       = 0  " default : 1
" let g:go_highlight_extra_types                 = 0  " default : 1
" let g:go_highlight_space_tab_error             = 0  " default : 1
" let g:go_highlight_operators                   = 1  " default : 0
" let g:go_highlight_functions                   = 1  " default : 0
" let g:go_highlight_function_parameters         = 0  " default : 0
" let g:go_highlight_function_calls              = 1  " default : 0
" let g:go_highlight_fields                      = 1  " default : 0
" let g:go_highlight_types                       = 0  " default : 0
" let g:go_highlight_variable_assignments        = 0  " default : 0
" let g:go_highlight_variable_declarations       = 0  " default : 0
" let g:go_highlight_build_constraints           = 1  " default : 0

" C CXX:
" let c_no_curly_error = 1


" Asm:
" let g:nasm_loose_syntax = 1
" let g:nasm_ctx_outside_macro = 1


"" TypeScript:
" let g:yats_host_keyword = 1


"" Binary:
" let g:vinarise_enable_auto_detect = 1
" if isdirectory('/usr/local/opt/binutils')
"   let g:vinarise_objdump_command = '/usr/local/opt/binutils/bin/gobjdump'
" endif


"" Markdown:
" let g:markdown_fenced_languages = [
"       \ 'c',
"       \ 'console=sh',
"       \ 'cpp',
"       \ 'dockerfile',
"       \ 'go',
"       \ 'graphql',
"       \ 'help',
"       \ 'mermaid',
"       \ 'mysql',
"       \ 'objective-c',
"       \ 'proto',
"       \ 'python',
"       \ 'sh',
"       \ 'sql',
"       \ 'typescript',
"       \ 'vim'
"       \]
"" VimMarkdownfmt:
" let g:markdownfmt_command = 'markdownfmt'
" let g:markdownfmt_options = ''
" let g:markdownfmt_autosave = 0
" let g:markdownfmt_fail_silently = 0

" -------------------------------------------------------------------------------------------------
" Functions:

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

" -------------------------------------------------------------------------------------------------
" Command:

"" LuaVimInspect:
command! -complete=lua -nargs=* LuaVimInspect lua print(vim.inspect(<args>))

"" ManV:
"" Man with vertical split
command! -bang -bar -range=-1 -complete=customlist,man#complete -nargs=* ManV vertical Man <args>

"" CheckColor:
" function s:check_colorscheme() abort
"   call nvim_command("edit ~/.nvim/colors/".g:colors_name.".vim | source $VIMRUNTIME/tools/check_colors.vim")
"   wincmd x
"   setlocal filetype=vim
" endfunction
" command! CheckColorScheme call s:check_colorscheme()

"" TerminalV:
command! -nargs=* TerminalV vsplit | terminal <args>

" TODO(zchee): unused
" function! TextEntered(text)
"   if a:text == 'exit' || a:text == 'quit'
"     stopinsert
"     close
"   else
"     call append(line('$') - 1, 'Entered: "' . a:text . '"')
"     " Reset 'modified' to allow the buffer to be closed.
"     set nomodified
"   endif
" endfunc
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
     " map           <Leader><Leader>     <Plug>(easymotion-prefix)

"" <LocalLeader>
" nnoremap <silent><LocalLeader>*         :<C-u>DeniteCursorWord grep -buffer-name='grep/rg'<CR>
" nnoremap <silent><LocalLeader>-         :<C-u>split<CR>
" nnoremap <silent><LocalLeader>\         :<C-u>vsplit<CR>
" nnoremap <silent><LocalLeader>b         :<C-u>Denite buffer -buffer-name='buffer'<CR>
" nnoremap <silent><LocalLeader>g         :<C-u>Denite line -buffer-name='line'<CR>
" nnoremap <silent><LocalLeader>gs        :<C-u>call switch#Switch()<CR>
" nnoremap <silent><LocalLeader>q         :<C-u>q<CR>
" nnoremap <silent><LocalLeader>w         :<C-u>w<CR>

"" ,
" nnoremap              <silent>,m        <C-w>W
" nnoremap              <silent>,n        <C-w>w
" nnoremap              <silent>,p        <C-w>W
" nnoremap              <silent>,r        <C-w>x
" nnoremap              <silent>,s        :<C-u>bNext<CR>
" nnoremap              <silent>,t        :<C-u>tabnew<CR>
" nnoremap              <silent>,w        <C-w>w

" -------------------------------------------------------------------------------------------------
" Map: (m)

"" Operator:
" map <silent>ti  <Plug>(operator-surround-append)
" map <silent>td  <Plug>(operator-surround-delete)
" map <silent>tr  <Plug>(operator-surround-replace)

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

" nmap     <silent><nowait>*        <Plug>(asterisk-gz*)
" " nnoremap         <silent>-        :<C-u>Defx -auto-cd -direction=topleft -split=vertical -search=`expand('%:p')` `expand('%:p:h')`<CR>
" " nnoremap         <silent>-        :<C-u>CHADopen<CR>
"
" nnoremap         <nowait>@        ^
" nnoremap         <nowait>^        @
"
" nmap                     ga       <Plug>(LiveEasyAlign)
" " nmap             <silent>gc       <Plug>(caw:hatpos:toggle)
" nnoremap         <silent>gs       :<C-u>Switch<CR>
" nmap             <silent>gx       <Plug>(openbrowser-smart-search)
" " nmap     <silent><nowait>j        <Plug>(accelerated_jk_j)
" " nmap     <silent><nowait>k        <Plug>(accelerated_jk_k)
" " accelerated <Left>
" " nmap     <silent><nowait><Left>   :<C-u>call accelerated#time_driven#command('h')<CR>
" " accelerated <Right>
" " nmap     <silent><nowait><Right>  :<C-u>call accelerated#time_driven#command('l')<CR>
"
" nnoremap                 Q        gq
" nnoremap         <nowait>s        A
" nnoremap         <nowait>x        "_x
" nnoremap                 zj       zjzt
" nnoremap                 zk       2zkzjzt
" nnoremap                 ZQ       <Nop>
" nnoremap         <nowait><Up>     <Up>
" nnoremap         <nowait><Down>   <Down>
"
" nnoremap         <silent><C-e>    <C-e><C-e><C-e><C-e>
" " nnoremap         <silent><C-g>    :<C-u>DeniteProjectDir grep/rg -buffer-name='grep' -path=`expand('%:p:h')` -winheight=40 -preview-height=200 -sorters=sorter/path -empty<CR>
" nnoremap         <silent><C-g>    <cmd>lua require('telescope.builtin').live_grep({cwd = require('telescope.utils').buffer_dir()})<CR>
" nnoremap         <silent><C-p>    <cmd>lua require('telescope.builtin').find_files()<CR>
" nnoremap         <silent><C-q>    :<C-u>nohlsearch<CR>
" nmap             <silent><C-w>z   <Plug>(zoom-toggle)
" nnoremap         <silent><C-y>    <C-y><C-y><C-y><C-y>
"
" nnoremap              <S-Down>    <Nop>
" nnoremap               <S-Tab>    %
" " nnoremap         <nowait><S-Tab>  %
" nnoremap                 <S-Up>   <Nop>


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
" imap     <silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"


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
" xnoremap            <silent><C-t>    <Plug>Translate

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
" smap  <nowait><silent><expr><C-k>    neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"

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
