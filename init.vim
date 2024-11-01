"                                                                                                 "
"                 __                                                                              "
"  ____      ___ \ \ \___       __      __        ___    __  __ /\_\     ___ ___    _ __   ___    "
" /\_ ,`\   /'___\\ \  _ `\   /'__`\  /'__`\    /' _ `\ /\ \/\ \\/\ \  /' __` __`\ /\`'__\/'___\  "
" \/_/  /_ /\ \__/ \ \ \ \ \ /\  __/ /\  __/    /\ \/\ \\ \ \_/ |\ \ \ /\ \/\ \/\ \\ \ \//\ \__/  "
"   /\____\\ \____\ \ \_\ \_\\ \____\\ \____\   \ \_\ \_\\ \___/  \ \_\\ \_\ \_\ \_\\ \_\\ \____\ "
"                                                                                                 "
"                                                                                                 "
" ----------------------------------------------------------------------------------------------- "

if exists('g:vscode')
  lua require("code")
  finish
endif

lua require("init")

" -------------------------------------------------------------------------------------------------
" GlobalAutoCmd:

augroup GlobalAutoCmd
  autocmd!
augroup END
command! -nargs=* Gautocmd   autocmd GlobalAutoCmd <args>
command! -nargs=* Gautocmdft autocmd GlobalAutoCmd FileType <args>

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
" Gautocmdft man://* nmap  <buffer><nowait>j  <Plug>(accelerated_jk_gj_position)
" Gautocmdft man://* nmap  <buffer><nowait>k  <Plug>(accelerated_jk_gk_position)


" Language:
" Vim:
"" nested autoload
Gautocmdft qf hi Search  gui=None  guifg=None  guibg=#373b41

" -------------------------------------------------------------------------------------------------
" Plugin Setting:

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

" "" ManV:
" "" Man with vertical split
" command! -bang -bar -range=-1 -complete=customlist,man#complete -nargs=* ManV vertical Man <args>
"
" "" CheckColor:
" function s:check_colorscheme() abort
"   call nvim_command("edit ~/.nvim/colors/".g:colors_name.".vim | source $VIMRUNTIME/tools/check_colors.vim")
"   wincmd x
"   setlocal filetype=vim
" endfunction
" command! CheckColorScheme call s:check_colorscheme()
"
" "" TerminalV:
" command! -nargs=* TerminalV vsplit | terminal <args>

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
" Language:

"" Go:
" Gautocmdft go nnoremap <LocalLeader>go  :<C-u>DeniteProjectDir grep -buffer-name='grep' -path=/usr/local/go/src<CR>
" Gautocmd BufNewFile,BufRead,BufEnter godoc://** nmap <C-]> <CR>

"" C CXX ObjC:
" Gautocmdft c,cpp  nnoremap <silent><buffer><C-k>       :<C-u>call <SID>open_online_cfamily_doc()<CR>

"" Markdown:
" Gautocmdft markdown nmap <silent><LocalLeader>f  :<C-u>call markdownfmt#Format()<CR>

"" Vim:
" http://ku.ido.nu/post/90355094974/how-to-grep-a-word-under-the-cursor-on-vim
" Gautocmdft vim nnoremap <silent><buffer>K      :<C-u>Help<Space><C-r><C-w><CR>

"" Ouickfix:
" Gautocmdft qf  nnoremap <buffer><CR>      <CR>zz

"" Help:
" Gautocmdft help nnoremap <silent><buffer><C-n> :<C-u>cnext<CR>
" Gautocmdft help nnoremap <silent><buffer><C-p> :<C-u>cprevious<CR>

" -------------------------------------------------------------------------------------------------
" Insert: (i)

" <C-c> doesn't trigger the InsertLeave autocmd
" inoremap <C-c> <ESC>

" Move cursor to first or end of line
" inoremap <silent><C-a>  <C-o><S-i>
" inoremap <silent><C-e>  <C-o><S-a>

" Put +register word
" inoremap <silent><C-y>  <C-r>*
" inoremap <silent><C-j>  <C-r>*

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

" vnoremap                  <S-Tab>    %
" vnoremap                <nowait>c    "_c
" vnoremap                <nowait>P    "_dP
" vnoremap                <nowait>p    "_dp
" vnoremap                <nowait>x    "_x
" vnoremap                <nowait>@    ^
" vnoremap                <nowait>^    @
" vmap                    <silent>ga   <Plug>(LiveEasyAlign)
vnoremap                <silent>gs   :<C-u>'<,'>sort i<CR>
" vmap                    <silent>gx   <Plug>(openbrowser-smart-search)
" vmap                    <silent>tu   <Plug>(operator-convert-case-upper-camel)
" vnoremap                <nowait>v    g_
" vnoremap                <nowait>V    ^


" Language:

"" Protobuf:
" Gautocmdft proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

"" C CXX ObjC:
" Gautocmdft c,cpp,objc,objcpp,proto vnoremap <buffer><Leader>cf  :<C-u>ClangFormat<CR>

" -------------------------------------------------------------------------------------------------
" Visual: (x)

" xnoremap               <silent>nu :lua require"treesitter-unit".select()<CR>
" xnoremap               <silent>tu :lua require"treesitter-unit".select(true)<CR>

" -------------------------------------------------------------------------------------------------
" Operator Pending: (o)

" onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
" onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>

" -------------------------------------------------------------------------------------------------
" Select: (s)

" Language:

"" Go Yaml Json:
" Gautocmdft go,yaml,json,jsonschema snoremap <buffer> "    '
" Gautocmdft go,yaml,json,jsonschema snoremap <buffer> '    "

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
" tnoremap <silent>qq                <C-\><C-n>
" tnoremap <silent><buffer><expr>jj  <SID>find_proc_in_tree(b:terminal_job_pid, 'nvim', 0) ? '<ESC>' : '<C-\><C-N>'
" tnoremap <buffer><S-Left>          <C-[>b
" tnoremap <buffer><C-Left>          <C-[>b
" tnoremap <buffer><S-Right>         <C-[>f
" tnoremap <buffer><C-Right>         <C-[>f
" tnoremap <nowait><buffer><BS>      <BS>

" -------------------------------------------------------------------------------------------------

" Highlight:

"" Python:
highlight! pythonSpaceError            gui=NONE      guifg=#787f86  guibg=#787f86
highlight! link                        pythonDelimiter              Special
highlight! link                        pythonNONE                   pythonFunction
highlight! link                        pythonSelf                   pythonOperator

" CPP:
highlight! doxygenBrief                gui=NONE      guifg=#81a2be  guibg=NONE
highlight! doxygenSpecialMultilineDesc gui=NONE      guifg=#81a2be  guibg=NONE
highlight! doxygenSpecialOnelineDesc   gui=NONE      guifg=#81a2be  guibg=NONE

"" Vim:
Gautocmdft qf hi Search                gui=NONE      guifg=NONE     guibg=#373b41

"" Plugin:

"" VimIlluminate:
highlight! illuminatedWord             gui=underline guifg=NONE     guibg=NONE

"" MatchUp:
highlight! MatchParen                  gui=NONE      guifg=NONE     guibg=#343941
highlight! MatchWord                   gui=NONE      guifg=NONE     guibg=#343941
