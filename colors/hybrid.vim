" ----------------------------------------------------------------------------
" hybrid.vim
"
" ----------------------------------------------------------------------------
" Description:
"
" The default RGB colour palette is taken from Tomorrow-Night.vim:
" https://github.com/chriskempson/vim-tomorrow-theme
"
" The reduced RGB colour palette is taken from Codecademy's online editor:
" https://www.codecademy.com/learn
"
" The syntax highlighting scheme is taken from jellybeans.vim:
" https://github.com/nanotech/jellybeans.vim
"
" The is code taken from solarized.vim:
" https://github.com/altercation/vim-colors-solarized"
"
" ----------------------------------------------------------------------------
" Requirements And Recommendations:
"
" Requirements
"   - gVim 7.3+ on Linux, Mac and Windows.
"   - Vim 7.3+ on Linux and Mac, using a terminal that supports 256 colours.
"
" Due to the limited 256 palette, colours in Vim and gVim will still be slightly
" different.
"
" In order to have Vim use the same colours as gVim (the way this colour scheme
" is intended), it is recommended that you define the basic 16 colours in your
" terminal.
"
" For Linux users (rxvt-unicode, xterm):
"
" 1.  Add the default palette to ~/.Xresources:
"
"         https://gist.github.com/3278077
"
"     or alternatively, add the reduced contrast palette to ~/.Xresources:
"
"         https://gist.github.com/w0ng/16e33902508b4a0350ae
"
" 2.  Add to ~/.vimrc:
"
"         let g:hybrid_custom_term_colors = 1
"         let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
"         colorscheme hybrid
"
" For OSX users (iTerm):
"
" 1.  Import the default colour preset into iTerm:
"
"         https://raw.githubusercontent.com/w0ng/dotfiles/master/iterm2/hybrid.itermcolors
"
"     or alternatively, import the reduced contrast color preset into iTerm:
"
"         https://raw.githubusercontent.com/w0ng/dotfiles/master/iterm2/hybrid-reduced-contrast.itermcolors
"
" 2.  Add to ~/.vimrc:
"
"         let g:hybrid_custom_term_colors = 1
"         let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
"         colorscheme hybrid"
"
" ----------------------------------------------------------------------------
" Init:

hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'hybrid'

" ----------------------------------------------------------------------------
" Palettes:
"
let s:palette = {}

let s:palette.background   = '#0a0a0a'  " #0d1210, #232c31
let s:palette.foreground   = '#c7c8c8'
let s:palette.selection    = '#343941'  " #425059
let s:palette.line         = '#282a2e'  " #2d3c46
let s:palette.comment      = '#838c93'  " #79828a, #6c7a80, #838c93, #878f96
let s:palette.nontext      = '#202122'
let s:palette.longlinewarn = '#371f1c'

let s:palette.boolean      = '#6690c3'  " #96CED7

let s:palette.black        = '#27282b'
let s:palette.white        = '#ffffff'
let s:palette.red          = '#cc6666'
let s:palette.orange       = '#de935f'
let s:palette.yellow       = '#f0c674'
let s:palette.green        = '#b5bd68'     " #a0a85c
let s:palette.aqua         = '#8abeb7'     " #a1cbc5
let s:palette.blue         = '#81a2be'
let s:palette.cyan         = '#92a7b9'     " #81a2be
let s:palette.purple       = '#b294bb'
let s:palette.window       = '#303030'
let s:palette.darkcolumn   = '#1c1c1c'
let s:palette.addbg        = '#5f875f'
let s:palette.addfg        = '#d7ffaf'
let s:palette.changebg     = '#5f5f87'
let s:palette.changefg     = '#d7d7ff'
let s:palette.delbg        = '#cc6666'
let s:palette.darkblue     = '#00005f'
let s:palette.darkcyan     = '#005f5f'
let s:palette.darkred      = '#5f0000'
let s:palette.darkpurple   = '#5f005f'
let s:palette.gray         = '#585858'
let s:palette.darkbar      = '#292d34'
let s:palette.darkgray     = '#282a2e'

" ----------------------------------------------------------------------------
" Formatting Options:

let s:none    = 'NONE'
let s:c       = ',undercurl'
let s:r       = ',reverse'
let s:s       = ',standout'
let s:b       = ',bold'
let s:u       = ',underline'
let s:i       = ',italic'
let s:indexed = ' guisp=fg_indexed,bg_indexed'

" ----------------------------------------------------------------------------
" Highlighting Primitives:

function! s:build_prim(hi_elem, field)
  " Given a:hi_elem = bg = comment
  let l:vname    = "s:"  . a:hi_elem . "_" . a:field             " s:bg_comment
  let l:assign   = "gui" . a:hi_elem . "=" . s:palette[a:field]  " guibg=...
  execute "let " . l:vname . " = ' " . l:assign . "'"
endfunction

"" Background:
let s:bg_none = ' guibg=NONE'
call s:build_prim('bg', 'foreground')
call s:build_prim('bg', 'background')
call s:build_prim('bg', 'selection')
call s:build_prim('bg', 'line')
call s:build_prim('bg', 'comment')
call s:build_prim('bg', 'nontext')
call s:build_prim('bg', 'longlinewarn')

call s:build_prim('bg', 'boolean')

call s:build_prim('bg', 'black')
call s:build_prim('bg', 'white')
call s:build_prim('bg', 'red')
call s:build_prim('bg', 'orange')
call s:build_prim('bg', 'yellow')
call s:build_prim('bg', 'green')
call s:build_prim('bg', 'aqua')
call s:build_prim('bg', 'blue')
call s:build_prim('bg', 'purple')
call s:build_prim('bg', 'window')
call s:build_prim('bg', 'darkcolumn')
call s:build_prim('bg', 'addbg')
call s:build_prim('bg', 'addfg')
call s:build_prim('bg', 'changebg')
call s:build_prim('bg', 'changefg')
call s:build_prim('bg', 'delbg')
call s:build_prim('bg', 'darkblue')
call s:build_prim('bg', 'darkcyan')
call s:build_prim('bg', 'darkred')
call s:build_prim('bg', 'darkpurple')
call s:build_prim('bg', 'gray')
call s:build_prim('bg', 'darkgray')
call s:build_prim('bg', 'darkbar')

"" Foreground:
let s:fg_none = ' guifg=NONE'
call s:build_prim('fg', 'foreground')
call s:build_prim('fg', 'background')
call s:build_prim('fg', 'selection')
call s:build_prim('fg', 'line')
call s:build_prim('fg', 'comment')
call s:build_prim('fg', 'nontext')
call s:build_prim('fg', 'longlinewarn')

call s:build_prim('fg', 'boolean')

call s:build_prim('fg', 'black')
call s:build_prim('fg', 'white')
call s:build_prim('fg', 'red')
call s:build_prim('fg', 'orange')
call s:build_prim('fg', 'yellow')
call s:build_prim('fg', 'green')
call s:build_prim('fg', 'aqua')
call s:build_prim('fg', 'blue')
call s:build_prim('fg', 'purple')
call s:build_prim('fg', 'window')
call s:build_prim('fg', 'darkcolumn')
call s:build_prim('fg', 'addbg')
call s:build_prim('fg', 'addfg')
call s:build_prim('fg', 'changebg')
call s:build_prim('fg', 'changefg')
call s:build_prim('fg', 'darkblue')
call s:build_prim('fg', 'darkcyan')
call s:build_prim('fg', 'darkred')
call s:build_prim('fg', 'darkpurple')
call s:build_prim('fg', 'gray')
call s:build_prim('fg', 'darkgray')
call s:build_prim('fg', 'darkbar')

execute "let s:fmt_none             = ' gui=NONE".s:indexed         ."'"
execute "let s:fmt_bold             = ' gui=NONE".s:b.s:indexed     ."'"
execute "let s:fmt_bold_italic      = ' gui=NONE".s:b.s:i.s:indexed ."'"
execute "let s:fmt_underline        = ' gui=NONE".s:u.s:indexed     ."'"
execute "let s:fmt_underline_bold   = ' gui=NONE".s:u.s:b.s:indexed ."'"
execute "let s:fmt_underline_italic = ' gui=NONE".s:i.s:u ."'"
execute "let s:fmt_undercurl        = ' gui=NONE".s:c.s:indexed     ."'"
execute "let s:fmt_italic           = ' gui=NONE".s:i.s:indexed     ."'"
execute "let s:fmt_standout         = ' gui=NONE".s:s.s:indexed     ."'"
execute "let s:fmt_reverse          = ' gui=NONE".s:r.s:indexed     ."'"
execute "let s:fmt_reverse_bold     = ' gui=NONE".s:r.s:b.s:indexed ."'"

" execute "let s:sp_none              = ' guisp=". s:none               ."'"
" execute "let s:sp_foreground        = ' guisp=". s:palette.foreground ."'"
" execute "let s:sp_background        = ' guisp=". s:palette.background ."'"
" execute "let s:sp_selection         = ' guisp=". s:palette.selection  ."'"
" execute "let s:sp_line              = ' guisp=". s:palette.line       ."'"
" execute "let s:sp_comment           = ' guisp=". s:palette.comment    ."'"

" execute "let s:sp_black             = ' guisp=". s:palette.black . s:indexed      ."'"
" execute "let s:sp_white             = ' guisp=". s:palette.white . s:indexed      ."'"
" execute "let s:sp_red               = ' guisp=". s:palette.red . s:indexed        ."'"
" execute "let s:sp_orange            = ' guisp=". s:palette.orange . s:indexed     ."'"
" execute "let s:sp_yellow            = ' guisp=". s:palette.yellow . s:indexed     ."'"
" execute "let s:sp_green             = ' guisp=". s:palette.green . s:indexed      ."'"
" execute "let s:sp_aqua              = ' guisp=". s:palette.aqua . s:indexed       ."'"
" execute "let s:sp_blue              = ' guisp=". s:palette.blue . s:indexed       ."'"
" execute "let s:sp_purple            = ' guisp=". s:palette.purple . s:indexed     ."'"
" execute "let s:sp_window            = ' guisp=". s:palette.window . s:indexed     ."'"
" execute "let s:sp_addbg             = ' guisp=". s:palette.addbg . s:indexed      ."'"
" execute "let s:sp_addfg             = ' guisp=". s:palette.addfg . s:indexed      ."'"
" execute "let s:sp_changebg          = ' guisp=". s:palette.changebg . s:indexed   ."'"
" execute "let s:sp_changefg          = ' guisp=". s:palette.changefg . s:indexed   ."'"
" execute "let s:sp_darkblue          = ' guisp=". s:palette.darkblue . s:indexed   ."'"
" execute "let s:sp_darkcyan          = ' guisp=". s:palette.darkcyan . s:indexed   ."'"
" execute "let s:sp_darkred           = ' guisp=". s:palette.darkred . s:indexed    ."'"
" execute "let s:sp_darkpurple        = ' guisp=". s:palette.darkpurple . s:indexed ."'"
" execute "let s:sp_gray              = ' guisp=". s:palette.gray . s:indexed       ."'"
" execute "let s:sp_darkgray          = ' guisp=". s:palette.darkgray . s:indexed   ."'"
" execute "let s:sp_darkbar           = ' guisp=". s:palette.darkbar . s:indexed    ."'"

" ----------------------------------------------------------------------------
" Highlighting:

execute 'hi! ColorColumn'                  .s:fg_none            .s:bg_black          .s:fmt_none
execute 'hi! Conceal'                      .s:fg_none            .s:bg_line           .s:fmt_none
execute 'hi! Cursor'                       .s:fg_white           .s:bg_red            .s:fmt_none
execute 'hi! lCursor'                      .s:fg_white           .s:bg_red            .s:fmt_none
execute 'hi! CursorIM'                     .s:fg_white           .s:bg_line           .s:fmt_none
execute 'hi! CursorColumn'                 .s:fg_white           .s:bg_line           .s:fmt_none
execute 'hi! CursorLine'                   .s:fg_none            .s:bg_nontext        .s:fmt_none
execute 'hi! Directory'                    .s:fg_blue            .s:bg_none           .s:fmt_none
execute 'hi! DiffAdd'                      .s:fg_addfg           .s:bg_addbg          .s:fmt_none
execute 'hi! DiffChange'                   .s:fg_changefg        .s:bg_changebg       .s:fmt_none
execute 'hi! DiffDelete'                   .s:fg_background      .s:bg_red            .s:fmt_none
execute 'hi! DiffText'                     .s:fg_background      .s:bg_blue           .s:fmt_none
execute 'hi! ErrorMsg'                     .s:fg_red             .s:bg_background     .s:fmt_standout
execute 'hi! VertSplit'                    .s:fg_window          .s:bg_window         .s:fmt_none
execute 'hi! Folded'                       .s:fg_comment         .s:bg_darkcolumn     .s:fmt_none
execute 'hi! FoldColumn'                   .s:fg_none            .s:bg_background     .s:fmt_none
execute 'hi! SignColumn'                   .s:fg_none            .s:bg_darkcolumn     .s:fmt_none
execute 'hi! Incsearch'                    .s:fg_none            .s:bg_selection      .s:fmt_none
execute 'hi! LineNr'                       .s:fg_gray            .s:bg_none           .s:fmt_none
execute 'hi! CursorLineNr'                 .s:fg_yellow          .s:bg_none           .s:fmt_bold
execute 'hi! MatchParen'                   .s:fg_background      .s:bg_changebg       .s:fmt_none
execute 'hi! ModeMsg'                      .s:fg_green           .s:bg_none           .s:fmt_none
execute 'hi! MoreMsg'                      .s:fg_green           .s:bg_none           .s:fmt_none
execute 'hi! Pmenu'                        .s:fg_foreground      .s:bg_darkbar        .s:fmt_none
execute 'hi! PmenuSel'                     .s:fg_foreground      .s:bg_selection      .s:fmt_reverse
execute 'hi! PmenuSbar'                    .s:fg_background      .s:bg_gray           .s:fmt_none
execute 'hi! PmenuThumb'                   .s:fg_background      .s:bg_foreground     .s:fmt_none
execute 'hi! Question'                     .s:fg_green           .s:bg_none           .s:fmt_none
execute 'hi! Search'                       .s:fg_none            .s:bg_selection      .s:fmt_none
execute 'hi! SpecialKey'                   .s:fg_selection       .s:bg_none           .s:fmt_none
execute 'hi! SpellBad'                     .s:fg_red             .s:bg_darkred        .s:fmt_underline
execute 'hi! SpellCap'                     .s:fg_blue            .s:bg_darkblue       .s:fmt_underline
execute 'hi! SpellLocal'                   .s:fg_aqua            .s:bg_darkcyan       .s:fmt_underline
execute 'hi! SpellRare'                    .s:fg_purple          .s:bg_darkpurple     .s:fmt_underline
execute 'hi! StatusLine'                   .s:fg_darkgray        .s:bg_foreground     .s:fmt_reverse
execute 'hi! StatusLineNC'                 .s:fg_window          .s:bg_comment        .s:fmt_reverse
execute 'hi! TabLine'                      .s:fg_foreground      .s:bg_line           .s:fmt_none
execute 'hi! TabLineFill'                  .s:fg_line            .s:bg_window         .s:fmt_none
execute 'hi! TabLineSel'                   .s:fg_foreground      .s:bg_gray           .s:fmt_none
execute 'hi! Title'                        .s:fg_yellow          .s:bg_none           .s:fmt_none
execute 'hi! Visual'                       .s:fg_none            .s:bg_selection      .s:fmt_none
execute 'hi! VisualNos'                    .s:fg_none            .s:bg_selection      .s:fmt_none
execute 'hi! WarningMsg'                   .s:fg_red             .s:bg_none           .s:fmt_none
execute 'hi! LongLineWarning'              .s:fg_none            .s:bg_longlinewarn   .s:fmt_underline
execute 'hi! WildMenu'                     .s:fg_yellow          .s:bg_selection      .s:fmt_none
" {Nvim}
execute 'hi! EndOfBuffer'                  .s:fg_nontext         .s:bg_none           .s:fmt_none
execute 'hi! TermCursor'                   .s:fg_orange          .s:bg_blue           .s:fmt_none
execute 'hi! TermCursorNC'                 .s:fg_yellow          .s:bg_black          .s:fmt_none

" ----------------------------------------------------------------------------
" Generic Syntax Highlight:
" see :help group-name

execute 'hi! Normal'                       .s:fg_foreground      .s:bg_none           .s:fmt_none
execute 'hi! NonText'                      .s:fg_nontext         .s:bg_none           .s:fmt_none

execute 'hi! Comment'                      .s:fg_comment         .s:bg_none           .s:fmt_none

execute 'hi! Constant'                     .s:fg_purple          .s:bg_none           .s:fmt_none
execute 'hi! String'                       .s:fg_green           .s:bg_none           .s:fmt_none
"		Character"
" execute 'hi! Boolean'                    .s:fg_boolean         .s:bg_none           .s:fmt_none
execute 'hi! Number'                       .s:fg_purple          .s:bg_none           .s:fmt_none
execute 'hi! Float'                        .s:fg_purple          .s:bg_none           .s:fmt_none

execute 'hi! Identifier'                   .s:fg_red             .s:bg_none           .s:fmt_none
execute 'hi! Function'                     .s:fg_yellow          .s:bg_none           .s:fmt_bold

execute 'hi! Statement'                    .s:fg_blue            .s:bg_none           .s:fmt_bold
"		Conditional"
"		Repeat"
"		Label"
execute 'hi! Operator'                     .s:fg_aqua            .s:bg_none           .s:fmt_none
" execute 'hi! Keyword'                    .s:fg_cyan            .s:bg_none           .s:fmt_bold
"		Exception"

execute 'hi! PreProc'                      .s:fg_aqua            .s:bg_none           .s:fmt_bold
"		Include"
"		Define"
"		Macro"
"		PreCondit"

execute 'hi! Type'                         .s:fg_orange          .s:bg_none           .s:fmt_bold
"		StorageClass"
execute 'hi! Structure'                    .s:fg_aqua            .s:bg_none           .s:fmt_none
"		Typedef"

execute 'hi! Special'                      .s:fg_green           .s:bg_none           .s:fmt_none
execute 'hi! SpecialKey'                   .s:fg_nontext         .s:bg_none           .s:fmt_none
execute 'hi! SpecialChar'                  .s:fg_green           .s:bg_none           .s:fmt_none
"		Tag"
"		Delimiter"
"		SpecialComment"
"		Debug"

execute 'hi! Underlined'                   .s:fg_blue            .s:bg_none           .s:fmt_none
execute 'hi! Ignore'                       .s:fg_none            .s:bg_none           .s:fmt_none
execute 'hi! Error'                        .s:fg_purple          .s:bg_darkred        .s:fmt_underline_italic
execute 'hi! Todo'                         .s:fg_addfg           .s:bg_none           .s:fmt_bold
execute 'hi! qfLineNr'                     .s:fg_yellow          .s:bg_none           .s:fmt_none
"   qfFileName"
"   qfLineNr"
"   qfError"

execute 'hi! ExtraTab'                     .s:fg_none            .s:bg_none           .s:fmt_none

" Diff Syntax Highlighting:
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
hi! link diffRemoved Constant
"		diffChanged
hi! link diffAdded Special
"		diffLine
"		diffSubname
"		diffComment

" Vim Highlighting: (see :help highlight-groups)
" ----------------------------------------------------------------------------
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

" XTerm 256 colorname list
"  https://jonasjacek.github.io/colors/
" | Number | Name              | cterm       | guifg         | RGB             |
" |--------|-------------------|-------------|---------------|-----------------|
" | 0      | Black             | ctermfg=0   | guifg=#000000 | rgb=0,0,0       |
" | 1      | Maroon            | ctermfg=1   | guifg=#800000 | rgb=128,0,0     |
" | 2      | Green             | ctermfg=2   | guifg=#008000 | rgb=0,128,0     |
" | 3      | Olive             | ctermfg=3   | guifg=#808000 | rgb=128,128,0   |
" | 4      | Navy              | ctermfg=4   | guifg=#000080 | rgb=0,0,128     |
" | 5      | Purple            | ctermfg=5   | guifg=#800080 | rgb=128,0,128   |
" | 6      | Teal              | ctermfg=6   | guifg=#008080 | rgb=0,128,128   |
" | 7      | Silver            | ctermfg=7   | guifg=#c0c0c0 | rgb=192,192,192 |
" | 8      | Grey              | ctermfg=8   | guifg=#808080 | rgb=128,128,128 |
" | 9      | Red               | ctermfg=9   | guifg=#ff0000 | rgb=255,0,0     |
" | 10     | Lime              | ctermfg=10  | guifg=#00ff00 | rgb=0,255,0     |
" | 11     | Yellow            | ctermfg=11  | guifg=#ffff00 | rgb=255,255,0   |
" | 12     | Blue              | ctermfg=12  | guifg=#0000ff | rgb=0,0,255     |
" | 13     | Fuchsia           | ctermfg=13  | guifg=#ff00ff | rgb=255,0,255   |
" | 14     | Aqua              | ctermfg=14  | guifg=#00ffff | rgb=0,255,255   |
" | 15     | White             | ctermfg=15  | guifg=#ffffff | rgb=255,255,255 |
" | 16     | Grey0             | ctermfg=16  | guifg=#000000 | rgb=0,0,0       |
" | 17     | NavyBlue          | ctermfg=17  | guifg=#00005f | rgb=0,0,95      |
" | 18     | DarkBlue          | ctermfg=18  | guifg=#000087 | rgb=0,0,135     |
" | 19     | Blue3             | ctermfg=19  | guifg=#0000af | rgb=0,0,175     |
" | 20     | Blue3             | ctermfg=20  | guifg=#0000d7 | rgb=0,0,215     |
" | 21     | Blue1             | ctermfg=21  | guifg=#0000ff | rgb=0,0,255     |
" | 22     | DarkGreen         | ctermfg=22  | guifg=#005f00 | rgb=0,95,0      |
" | 23     | DeepSkyBlue4      | ctermfg=23  | guifg=#005f5f | rgb=0,95,95     |
" | 24     | DeepSkyBlue4      | ctermfg=24  | guifg=#005f87 | rgb=0,95,135    |
" | 25     | DeepSkyBlue4      | ctermfg=25  | guifg=#005faf | rgb=0,95,175    |
" | 26     | DodgerBlue3       | ctermfg=26  | guifg=#005fd7 | rgb=0,95,215    |
" | 27     | DodgerBlue2       | ctermfg=27  | guifg=#005fff | rgb=0,95,255    |
" | 28     | Green4            | ctermfg=28  | guifg=#008700 | rgb=0,135,0     |
" | 29     | SpringGreen4      | ctermfg=29  | guifg=#00875f | rgb=0,135,95    |
" | 30     | Turquoise4        | ctermfg=30  | guifg=#008787 | rgb=0,135,135   |
" | 31     | DeepSkyBlue3      | ctermfg=31  | guifg=#0087af | rgb=0,135,175   |
" | 32     | DeepSkyBlue3      | ctermfg=32  | guifg=#0087d7 | rgb=0,135,215   |
" | 33     | DodgerBlue1       | ctermfg=33  | guifg=#0087ff | rgb=0,135,255   |
" | 34     | Green3            | ctermfg=34  | guifg=#00af00 | rgb=0,175,0     |
" | 35     | SpringGreen3      | ctermfg=35  | guifg=#00af5f | rgb=0,175,95    |
" | 36     | DarkCyan          | ctermfg=36  | guifg=#00af87 | rgb=0,175,135   |
" | 37     | LightSeaGreen     | ctermfg=37  | guifg=#00afaf | rgb=0,175,175   |
" | 38     | DeepSkyBlue2      | ctermfg=38  | guifg=#00afd7 | rgb=0,175,215   |
" | 39     | DeepSkyBlue1      | ctermfg=39  | guifg=#00afff | rgb=0,175,255   |
" | 40     | Green3            | ctermfg=40  | guifg=#00d700 | rgb=0,215,0     |
" | 41     | SpringGreen3      | ctermfg=41  | guifg=#00d75f | rgb=0,215,95    |
" | 42     | SpringGreen2      | ctermfg=42  | guifg=#00d787 | rgb=0,215,135   |
" | 43     | Cyan3             | ctermfg=43  | guifg=#00d7af | rgb=0,215,175   |
" | 44     | DarkTurquoise     | ctermfg=44  | guifg=#00d7d7 | rgb=0,215,215   |
" | 45     | Turquoise2        | ctermfg=45  | guifg=#00d7ff | rgb=0,215,255   |
" | 46     | Green1            | ctermfg=46  | guifg=#00ff00 | rgb=0,255,0     |
" | 47     | SpringGreen2      | ctermfg=47  | guifg=#00ff5f | rgb=0,255,95    |
" | 48     | SpringGreen1      | ctermfg=48  | guifg=#00ff87 | rgb=0,255,135   |
" | 49     | MediumSpringGreen | ctermfg=49  | guifg=#00ffaf | rgb=0,255,175   |
" | 50     | Cyan2             | ctermfg=50  | guifg=#00ffd7 | rgb=0,255,215   |
" | 51     | Cyan1             | ctermfg=51  | guifg=#00ffff | rgb=0,255,255   |
" | 52     | DarkRed           | ctermfg=52  | guifg=#5f0000 | rgb=95,0,0      |
" | 53     | DeepPink4         | ctermfg=53  | guifg=#5f005f | rgb=95,0,95     |
" | 54     | Purple4           | ctermfg=54  | guifg=#5f0087 | rgb=95,0,135    |
" | 55     | Purple4           | ctermfg=55  | guifg=#5f00af | rgb=95,0,175    |
" | 56     | Purple3           | ctermfg=56  | guifg=#5f00d7 | rgb=95,0,215    |
" | 57     | BlueViolet        | ctermfg=57  | guifg=#5f00ff | rgb=95,0,255    |
" | 58     | Orange4           | ctermfg=58  | guifg=#5f5f00 | rgb=95,95,0     |
" | 59     | Grey37            | ctermfg=59  | guifg=#5f5f5f | rgb=95,95,95    |
" | 60     | MediumPurple4     | ctermfg=60  | guifg=#5f5f87 | rgb=95,95,135   |
" | 61     | SlateBlue3        | ctermfg=61  | guifg=#5f5faf | rgb=95,95,175   |
" | 62     | SlateBlue3        | ctermfg=62  | guifg=#5f5fd7 | rgb=95,95,215   |
" | 63     | RoyalBlue1        | ctermfg=63  | guifg=#5f5fff | rgb=95,95,255   |
" | 64     | Chartreuse4       | ctermfg=64  | guifg=#5f8700 | rgb=95,135,0    |
" | 65     | DarkSeaGreen4     | ctermfg=65  | guifg=#5f875f | rgb=95,135,95   |
" | 66     | PaleTurquoise4    | ctermfg=66  | guifg=#5f8787 | rgb=95,135,135  |
" | 67     | SteelBlue         | ctermfg=67  | guifg=#5f87af | rgb=95,135,175  |
" | 68     | SteelBlue3        | ctermfg=68  | guifg=#5f87d7 | rgb=95,135,215  |
" | 69     | CornflowerBlue    | ctermfg=69  | guifg=#5f87ff | rgb=95,135,255  |
" | 70     | Chartreuse3       | ctermfg=70  | guifg=#5faf00 | rgb=95,175,0    |
" | 71     | DarkSeaGreen4     | ctermfg=71  | guifg=#5faf5f | rgb=95,175,95   |
" | 72     | CadetBlue         | ctermfg=72  | guifg=#5faf87 | rgb=95,175,135  |
" | 73     | CadetBlue         | ctermfg=73  | guifg=#5fafaf | rgb=95,175,175  |
" | 74     | SkyBlue3          | ctermfg=74  | guifg=#5fafd7 | rgb=95,175,215  |
" | 75     | SteelBlue1        | ctermfg=75  | guifg=#5fafff | rgb=95,175,255  |
" | 76     | Chartreuse3       | ctermfg=76  | guifg=#5fd700 | rgb=95,215,0    |
" | 77     | PaleGreen3        | ctermfg=77  | guifg=#5fd75f | rgb=95,215,95   |
" | 78     | SeaGreen3         | ctermfg=78  | guifg=#5fd787 | rgb=95,215,135  |
" | 79     | Aquamarine3       | ctermfg=79  | guifg=#5fd7af | rgb=95,215,175  |
" | 80     | MediumTurquoise   | ctermfg=80  | guifg=#5fd7d7 | rgb=95,215,215  |
" | 81     | SteelBlue1        | ctermfg=81  | guifg=#5fd7ff | rgb=95,215,255  |
" | 82     | Chartreuse2       | ctermfg=82  | guifg=#5fff00 | rgb=95,255,0    |
" | 83     | SeaGreen2         | ctermfg=83  | guifg=#5fff5f | rgb=95,255,95   |
" | 84     | SeaGreen1         | ctermfg=84  | guifg=#5fff87 | rgb=95,255,135  |
" | 85     | SeaGreen1         | ctermfg=85  | guifg=#5fffaf | rgb=95,255,175  |
" | 86     | Aquamarine1       | ctermfg=86  | guifg=#5fffd7 | rgb=95,255,215  |
" | 87     | DarkSlateGray2    | ctermfg=87  | guifg=#5fffff | rgb=95,255,255  |
" | 88     | DarkRed           | ctermfg=88  | guifg=#870000 | rgb=135,0,0     |
" | 89     | DeepPink4         | ctermfg=89  | guifg=#87005f | rgb=135,0,95    |
" | 90     | DarkMagenta       | ctermfg=90  | guifg=#870087 | rgb=135,0,135   |
" | 91     | DarkMagenta       | ctermfg=91  | guifg=#8700af | rgb=135,0,175   |
" | 92     | DarkViolet        | ctermfg=92  | guifg=#8700d7 | rgb=135,0,215   |
" | 93     | Purple            | ctermfg=93  | guifg=#8700ff | rgb=135,0,255   |
" | 94     | Orange4           | ctermfg=94  | guifg=#875f00 | rgb=135,95,0    |
" | 95     | LightPink4        | ctermfg=95  | guifg=#875f5f | rgb=135,95,95   |
" | 96     | Plum4             | ctermfg=96  | guifg=#875f87 | rgb=135,95,135  |
" | 97     | MediumPurple3     | ctermfg=97  | guifg=#875faf | rgb=135,95,175  |
" | 98     | MediumPurple3     | ctermfg=98  | guifg=#875fd7 | rgb=135,95,215  |
" | 99     | SlateBlue1        | ctermfg=99  | guifg=#875fff | rgb=135,95,255  |
" | 100    | Yellow4           | ctermfg=100 | guifg=#878700 | rgb=135,135,0   |
" | 101    | Wheat4            | ctermfg=101 | guifg=#87875f | rgb=135,135,95  |
" | 102    | Grey53            | ctermfg=102 | guifg=#878787 | rgb=135,135,135 |
" | 103    | LightSlateGrey    | ctermfg=103 | guifg=#8787af | rgb=135,135,175 |
" | 104    | MediumPurple      | ctermfg=104 | guifg=#8787d7 | rgb=135,135,215 |
" | 105    | LightSlateBlue    | ctermfg=105 | guifg=#8787ff | rgb=135,135,255 |
" | 106    | Yellow4           | ctermfg=106 | guifg=#87af00 | rgb=135,175,0   |
" | 107    | DarkOliveGreen3   | ctermfg=107 | guifg=#87af5f | rgb=135,175,95  |
" | 108    | DarkSeaGreen      | ctermfg=108 | guifg=#87af87 | rgb=135,175,135 |
" | 109    | LightSkyBlue3     | ctermfg=109 | guifg=#87afaf | rgb=135,175,175 |
" | 110    | LightSkyBlue3     | ctermfg=110 | guifg=#87afd7 | rgb=135,175,215 |
" | 111    | SkyBlue2          | ctermfg=111 | guifg=#87afff | rgb=135,175,255 |
" | 112    | Chartreuse2       | ctermfg=112 | guifg=#87d700 | rgb=135,215,0   |
" | 113    | DarkOliveGreen3   | ctermfg=113 | guifg=#87d75f | rgb=135,215,95  |
" | 114    | PaleGreen3        | ctermfg=114 | guifg=#87d787 | rgb=135,215,135 |
" | 115    | DarkSeaGreen3     | ctermfg=115 | guifg=#87d7af | rgb=135,215,175 |
" | 116    | DarkSlateGray3    | ctermfg=116 | guifg=#87d7d7 | rgb=135,215,215 |
" | 117    | SkyBlue1          | ctermfg=117 | guifg=#87d7ff | rgb=135,215,255 |
" | 118    | Chartreuse1       | ctermfg=118 | guifg=#87ff00 | rgb=135,255,0   |
" | 119    | LightGreen        | ctermfg=119 | guifg=#87ff5f | rgb=135,255,95  |
" | 120    | LightGreen        | ctermfg=120 | guifg=#87ff87 | rgb=135,255,135 |
" | 121    | PaleGreen1        | ctermfg=121 | guifg=#87ffaf | rgb=135,255,175 |
" | 122    | Aquamarine1       | ctermfg=122 | guifg=#87ffd7 | rgb=135,255,215 |
" | 123    | DarkSlateGray1    | ctermfg=123 | guifg=#87ffff | rgb=135,255,255 |
" | 124    | Red3              | ctermfg=124 | guifg=#af0000 | rgb=175,0,0     |
" | 125    | DeepPink4         | ctermfg=125 | guifg=#af005f | rgb=175,0,95    |
" | 126    | MediumVioletRed   | ctermfg=126 | guifg=#af0087 | rgb=175,0,135   |
" | 127    | Magenta3          | ctermfg=127 | guifg=#af00af | rgb=175,0,175   |
" | 128    | DarkViolet        | ctermfg=128 | guifg=#af00d7 | rgb=175,0,215   |
" | 129    | Purple            | ctermfg=129 | guifg=#af00ff | rgb=175,0,255   |
" | 130    | DarkOrange3       | ctermfg=130 | guifg=#af5f00 | rgb=175,95,0    |
" | 131    | IndianRed         | ctermfg=131 | guifg=#af5f5f | rgb=175,95,95   |
" | 132    | HotPink3          | ctermfg=132 | guifg=#af5f87 | rgb=175,95,135  |
" | 133    | MediumOrchid3     | ctermfg=133 | guifg=#af5faf | rgb=175,95,175  |
" | 134    | MediumOrchid      | ctermfg=134 | guifg=#af5fd7 | rgb=175,95,215  |
" | 135    | MediumPurple2     | ctermfg=135 | guifg=#af5fff | rgb=175,95,255  |
" | 136    | DarkGoldenrod     | ctermfg=136 | guifg=#af8700 | rgb=175,135,0   |
" | 137    | LightSalmon3      | ctermfg=137 | guifg=#af875f | rgb=175,135,95  |
" | 138    | RosyBrown         | ctermfg=138 | guifg=#af8787 | rgb=175,135,135 |
" | 139    | Grey63            | ctermfg=139 | guifg=#af87af | rgb=175,135,175 |
" | 140    | MediumPurple2     | ctermfg=140 | guifg=#af87d7 | rgb=175,135,215 |
" | 141    | MediumPurple1     | ctermfg=141 | guifg=#af87ff | rgb=175,135,255 |
" | 142    | Gold3             | ctermfg=142 | guifg=#afaf00 | rgb=175,175,0   |
" | 143    | DarkKhaki         | ctermfg=143 | guifg=#afaf5f | rgb=175,175,95  |
" | 144    | NavajoWhite3      | ctermfg=144 | guifg=#afaf87 | rgb=175,175,135 |
" | 145    | Grey69            | ctermfg=145 | guifg=#afafaf | rgb=175,175,175 |
" | 146    | LightSteelBlue3   | ctermfg=146 | guifg=#afafd7 | rgb=175,175,215 |
" | 147    | LightSteelBlue    | ctermfg=147 | guifg=#afafff | rgb=175,175,255 |
" | 148    | Yellow3           | ctermfg=148 | guifg=#afd700 | rgb=175,215,0   |
" | 149    | DarkOliveGreen3   | ctermfg=149 | guifg=#afd75f | rgb=175,215,95  |
" | 150    | DarkSeaGreen3     | ctermfg=150 | guifg=#afd787 | rgb=175,215,135 |
" | 151    | DarkSeaGreen2     | ctermfg=151 | guifg=#afd7af | rgb=175,215,175 |
" | 152    | LightCyan3        | ctermfg=152 | guifg=#afd7d7 | rgb=175,215,215 |
" | 153    | LightSkyBlue1     | ctermfg=153 | guifg=#afd7ff | rgb=175,215,255 |
" | 154    | GreenYellow       | ctermfg=154 | guifg=#afff00 | rgb=175,255,0   |
" | 155    | DarkOliveGreen2   | ctermfg=155 | guifg=#afff5f | rgb=175,255,95  |
" | 156    | PaleGreen1        | ctermfg=156 | guifg=#afff87 | rgb=175,255,135 |
" | 157    | DarkSeaGreen2     | ctermfg=157 | guifg=#afffaf | rgb=175,255,175 |
" | 158    | DarkSeaGreen1     | ctermfg=158 | guifg=#afffd7 | rgb=175,255,215 |
" | 159    | PaleTurquoise1    | ctermfg=159 | guifg=#afffff | rgb=175,255,255 |
" | 160    | Red3              | ctermfg=160 | guifg=#d70000 | rgb=215,0,0     |
" | 161    | DeepPink3         | ctermfg=161 | guifg=#d7005f | rgb=215,0,95    |
" | 162    | DeepPink3         | ctermfg=162 | guifg=#d70087 | rgb=215,0,135   |
" | 163    | Magenta3          | ctermfg=163 | guifg=#d700af | rgb=215,0,175   |
" | 164    | Magenta3          | ctermfg=164 | guifg=#d700d7 | rgb=215,0,215   |
" | 165    | Magenta2          | ctermfg=165 | guifg=#d700ff | rgb=215,0,255   |
" | 166    | DarkOrange3       | ctermfg=166 | guifg=#d75f00 | rgb=215,95,0    |
" | 167    | IndianRed         | ctermfg=167 | guifg=#d75f5f | rgb=215,95,95   |
" | 168    | HotPink3          | ctermfg=168 | guifg=#d75f87 | rgb=215,95,135  |
" | 169    | HotPink2          | ctermfg=169 | guifg=#d75faf | rgb=215,95,175  |
" | 170    | Orchid            | ctermfg=170 | guifg=#d75fd7 | rgb=215,95,215  |
" | 171    | MediumOrchid1     | ctermfg=171 | guifg=#d75fff | rgb=215,95,255  |
" | 172    | Orange3           | ctermfg=172 | guifg=#d78700 | rgb=215,135,0   |
" | 173    | LightSalmon3      | ctermfg=173 | guifg=#d7875f | rgb=215,135,95  |
" | 174    | LightPink3        | ctermfg=174 | guifg=#d78787 | rgb=215,135,135 |
" | 175    | Pink3             | ctermfg=175 | guifg=#d787af | rgb=215,135,175 |
" | 176    | Plum3             | ctermfg=176 | guifg=#d787d7 | rgb=215,135,215 |
" | 177    | Violet            | ctermfg=177 | guifg=#d787ff | rgb=215,135,255 |
" | 178    | Gold3             | ctermfg=178 | guifg=#d7af00 | rgb=215,175,0   |
" | 179    | LightGoldenrod3   | ctermfg=179 | guifg=#d7af5f | rgb=215,175,95  |
" | 180    | Tan               | ctermfg=180 | guifg=#d7af87 | rgb=215,175,135 |
" | 181    | MistyRose3        | ctermfg=181 | guifg=#d7afaf | rgb=215,175,175 |
" | 182    | Thistle3          | ctermfg=182 | guifg=#d7afd7 | rgb=215,175,215 |
" | 183    | Plum2             | ctermfg=183 | guifg=#d7afff | rgb=215,175,255 |
" | 184    | Yellow3           | ctermfg=184 | guifg=#d7d700 | rgb=215,215,0   |
" | 185    | Khaki3            | ctermfg=185 | guifg=#d7d75f | rgb=215,215,95  |
" | 186    | LightGoldenrod2   | ctermfg=186 | guifg=#d7d787 | rgb=215,215,135 |
" | 187    | LightYellow3      | ctermfg=187 | guifg=#d7d7af | rgb=215,215,175 |
" | 188    | Grey84            | ctermfg=188 | guifg=#d7d7d7 | rgb=215,215,215 |
" | 189    | LightSteelBlue1   | ctermfg=189 | guifg=#d7d7ff | rgb=215,215,255 |
" | 190    | Yellow2           | ctermfg=190 | guifg=#d7ff00 | rgb=215,255,0   |
" | 191    | DarkOliveGreen1   | ctermfg=191 | guifg=#d7ff5f | rgb=215,255,95  |
" | 192    | DarkOliveGreen1   | ctermfg=192 | guifg=#d7ff87 | rgb=215,255,135 |
" | 193    | DarkSeaGreen1     | ctermfg=193 | guifg=#d7ffaf | rgb=215,255,175 |
" | 194    | Honeydew2         | ctermfg=194 | guifg=#d7ffd7 | rgb=215,255,215 |
" | 195    | LightCyan1        | ctermfg=195 | guifg=#d7ffff | rgb=215,255,255 |
" | 196    | Red1              | ctermfg=196 | guifg=#ff0000 | rgb=255,0,0     |
" | 197    | DeepPink2         | ctermfg=197 | guifg=#ff005f | rgb=255,0,95    |
" | 198    | DeepPink1         | ctermfg=198 | guifg=#ff0087 | rgb=255,0,135   |
" | 199    | DeepPink1         | ctermfg=199 | guifg=#ff00af | rgb=255,0,175   |
" | 200    | Magenta2          | ctermfg=200 | guifg=#ff00d7 | rgb=255,0,215   |
" | 201    | Magenta1          | ctermfg=201 | guifg=#ff00ff | rgb=255,0,255   |
" | 202    | OrangeRed1        | ctermfg=202 | guifg=#ff5f00 | rgb=255,95,0    |
" | 203    | IndianRed1        | ctermfg=203 | guifg=#ff5f5f | rgb=255,95,95   |
" | 204    | IndianRed1        | ctermfg=204 | guifg=#ff5f87 | rgb=255,95,135  |
" | 205    | HotPink           | ctermfg=205 | guifg=#ff5faf | rgb=255,95,175  |
" | 206    | HotPink           | ctermfg=206 | guifg=#ff5fd7 | rgb=255,95,215  |
" | 207    | MediumOrchid1     | ctermfg=207 | guifg=#ff5fff | rgb=255,95,255  |
" | 208    | DarkOrange        | ctermfg=208 | guifg=#ff8700 | rgb=255,135,0   |
" | 209    | Salmon1           | ctermfg=209 | guifg=#ff875f | rgb=255,135,95  |
" | 210    | LightCoral        | ctermfg=210 | guifg=#ff8787 | rgb=255,135,135 |
" | 211    | PaleVioletRed1    | ctermfg=211 | guifg=#ff87af | rgb=255,135,175 |
" | 212    | Orchid2           | ctermfg=212 | guifg=#ff87d7 | rgb=255,135,215 |
" | 213    | Orchid1           | ctermfg=213 | guifg=#ff87ff | rgb=255,135,255 |
" | 214    | Orange1           | ctermfg=214 | guifg=#ffaf00 | rgb=255,175,0   |
" | 215    | SandyBrown        | ctermfg=215 | guifg=#ffaf5f | rgb=255,175,95  |
" | 216    | LightSalmon1      | ctermfg=216 | guifg=#ffaf87 | rgb=255,175,135 |
" | 217    | LightPink1        | ctermfg=217 | guifg=#ffafaf | rgb=255,175,175 |
" | 218    | Pink1             | ctermfg=218 | guifg=#ffafd7 | rgb=255,175,215 |
" | 219    | Plum1             | ctermfg=219 | guifg=#ffafff | rgb=255,175,255 |
" | 220    | Gold1             | ctermfg=220 | guifg=#ffd700 | rgb=255,215,0   |
" | 221    | LightGoldenrod2   | ctermfg=221 | guifg=#ffd75f | rgb=255,215,95  |
" | 222    | LightGoldenrod2   | ctermfg=222 | guifg=#ffd787 | rgb=255,215,135 |
" | 223    | NavajoWhite1      | ctermfg=223 | guifg=#ffd7af | rgb=255,215,175 |
" | 224    | MistyRose1        | ctermfg=224 | guifg=#ffd7d7 | rgb=255,215,215 |
" | 225    | Thistle1          | ctermfg=225 | guifg=#ffd7ff | rgb=255,215,255 |
" | 226    | Yellow1           | ctermfg=226 | guifg=#ffff00 | rgb=255,255,0   |
" | 227    | LightGoldenrod1   | ctermfg=227 | guifg=#ffff5f | rgb=255,255,95  |
" | 228    | Khaki1            | ctermfg=228 | guifg=#ffff87 | rgb=255,255,135 |
" | 229    | Wheat1            | ctermfg=229 | guifg=#ffffaf | rgb=255,255,175 |
" | 230    | Cornsilk1         | ctermfg=230 | guifg=#ffffd7 | rgb=255,255,215 |
" | 231    | Grey100           | ctermfg=231 | guifg=#ffffff | rgb=255,255,255 |
" | 232    | Grey3             | ctermfg=232 | guifg=#080808 | rgb=8,8,8       |
" | 233    | Grey7             | ctermfg=233 | guifg=#121212 | rgb=18,18,18    |
" | 234    | Grey11            | ctermfg=234 | guifg=#1c1c1c | rgb=28,28,28    |
" | 235    | Grey15            | ctermfg=235 | guifg=#262626 | rgb=38,38,38    |
" | 236    | Grey19            | ctermfg=236 | guifg=#303030 | rgb=48,48,48    |
" | 237    | Grey23            | ctermfg=237 | guifg=#3a3a3a | rgb=58,58,58    |
" | 238    | Grey27            | ctermfg=238 | guifg=#444444 | rgb=68,68,68    |
" | 239    | Grey30            | ctermfg=239 | guifg=#4e4e4e | rgb=78,78,78    |
" | 240    | Grey35            | ctermfg=240 | guifg=#585858 | rgb=88,88,88    |
" | 241    | Grey39            | ctermfg=241 | guifg=#626262 | rgb=98,98,98    |
" | 242    | Grey42            | ctermfg=242 | guifg=#6c6c6c | rgb=108,108,108 |
" | 243    | Grey46            | ctermfg=243 | guifg=#767676 | rgb=118,118,118 |
" | 244    | Grey50            | ctermfg=244 | guifg=#808080 | rgb=128,128,128 |
" | 245    | Grey54            | ctermfg=245 | guifg=#8a8a8a | rgb=138,138,138 |
" | 246    | Grey58            | ctermfg=246 | guifg=#949494 | rgb=148,148,148 |
" | 247    | Grey62            | ctermfg=247 | guifg=#9e9e9e | rgb=158,158,158 |
" | 248    | Grey66            | ctermfg=248 | guifg=#a8a8a8 | rgb=168,168,168 |
" | 249    | Grey70            | ctermfg=249 | guifg=#b2b2b2 | rgb=178,178,178 |
" | 250    | Grey74            | ctermfg=250 | guifg=#bcbcbc | rgb=188,188,188 |
" | 251    | Grey78            | ctermfg=251 | guifg=#c6c6c6 | rgb=198,198,198 |
" | 252    | Grey82            | ctermfg=252 | guifg=#d0d0d0 | rgb=208,208,208 |
" | 253    | Grey85            | ctermfg=253 | guifg=#dadada | rgb=218,218,218 |
" | 254    | Grey89            | ctermfg=254 | guifg=#e4e4e4 | rgb=228,228,228 |
" | 255    | Grey93            | ctermfg=255 | guifg=#eeeeee | rgb=238,238,238 |
