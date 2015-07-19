set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = 'ux'

"
" Colors
" ref: Neovim default highlight color
" https://github.com/neovim/neovim/blob/master/src/nvim/syntax.c#L5753-L5846
"

highlight ColorColumn     guifg=NONE    guibg=#282A2B gui=NONE
highlight Conceal         guifg=NONE    guibg=NONE    gui=NONE
highlight Cursor          guifg=#151718 guibg=#151718 gui=NONE
highlight CursorColumn    guifg=NONE    guibg=#282A2B gui=NONE
highlight CursorLine      guifg=NONE    guibg=#282A2B gui=NONE
highlight Directory       guifg=#44545c guibg=NONE    gui=NONE
highlight DiffAdd         guifg=#D4D7D6 guibg=#43800A gui=bold
highlight DiffDelete      guifg=#870505 guibg=NONE    gui=NONE
highlight DiffChange      guifg=#D4D7D6 guibg=#1A3150 gui=NONE
highlight DiffText        guifg=#D4D7D6 guibg=#204A87 gui=bold
highlight ErrorMsg        guifg=#F8F8F8 guibg=NONE    gui=NONE
highlight VertSplit       guifg=#4C4F4F guibg=#4C4F4F gui=NONE
highlight Folded          guifg=#41535B guibg=#151718 gui=NONE
highlight FoldColumn      guifg=#41535B guibg=#151718 gui=NONE
highlight IncSearch       guifg=#151718 guibg=#55B5DB gui=NONE
highlight LineNr          guifg=#47555B guibg=#0D1011 gui=NONE
highlight CursorLineNr    guifg=#FED02E guibg=#0D1011 gui=NONE
highlight MatchParen      guifg=#9FCA56 guibg=NONE    gui=underline
highlight ModeMsg         guifg=#ECFBFF guibg=NONE    gui=NONE
highlight MoreMsg         guifg=#ECFBFF guibg=NONE    gui=NONE
highlight NonMsg          guifg=#ECFBFF guibg=NONE    gui=NONE
highlight Normal          guifg=#ECFBFF guibg=#151718 gui=NONE
highlight Pmenu           guifg=NONE    guibg=#282A2B gui=bold
highlight PmenuSel        guifg=#FEFEFE guibg=#4F99D3 gui=bold
highlight PmenuSbar       guifg=#FEFEFE guibg=#101213 gui=bold
highlight PmenuThumb      guifg=NONE    guibg=#383A3A gui=bold
highlight Question        guifg=NONE    guibg=#202123 gui=bold
highlight Search          guifg=#FED02E guibg=NONE    gui=underline
highlight SpecialKey      guifg=#2B2E28 guibg=NONE    gui=NONE
highlight SpellBad        guifg=#2B2E28 guibg=#282A2B gui=NONE
highlight SpellCap        guifg=#2B2E28 guibg=#282A2B gui=NONE
highlight SpellLocal      guifg=#2B2E28 guibg=#282A2B gui=NONE
highlight SpellRare       guifg=#2B2E28 guibg=#282A2B gui=NONE
highlight StatusLine      guifg=#D4D7D6 guibg=#4C4F4F gui=bold
highlight StatusLineNC    guifg=#D4D7D6 guibg=#4C4F4F gui=NONE
highlight TabLine         guifg=#151718 guibg=#4FA5C7 gui=NONE
highlight TabLineFill     guifg=#151718 guibg=#4FA5C7 gui=NONE
highlight TabLineSel      guifg=#151718 guibg=#4FA5C7 gui=NONE
highlight Title           guifg=#D4D7D6 guibg=NONE    gui=bold
highlight Visual          guifg=#151718 guibg=#4FA5C7 gui=NONE
highlight VisualNOS       guifg=#151718 guibg=#4FA5C7 gui=NONE
highlight WarningMsg      guifg=#F8F8F8 guibg=NONE    gui=NONE
highlight WildMenu        guifg=#F8F8F8 guibg=NONE    gui=NONE

highlight Boolean         guifg=#CD3F45 guibg=NONE    gui=NONE
highlight Character       guifg=#CD3F45 guibg=NONE    gui=NONE
highlight Comment         guifg=#7292A1 guibg=#1D2427 gui=NONE
highlight Conditional     guifg=#9FCA56 guibg=NONE    gui=NONE
highlight Constant        guifg=#CD3F45 guibg=NONE    gui=NONE
highlight Define          guifg=#9FCA56 guibg=NONE    gui=NONE
highlight Float           guifg=#CD3F45 guibg=NONE    gui=NONE
highlight Function        guifg=#55B5DB guibg=NONE    gui=NONE
highlight Identifier      guifg=#E6CD69 guibg=NONE    gui=NONE
highlight Keyword         guifg=#9FCA56 guibg=NONE    gui=NONE
highlight Label           guifg=#55B5DB guibg=NONE    gui=NONE
highlight NonText         guifg=#2B2E28 guibg=#1F2122 gui=NONE
highlight Number          guifg=#CD3F45 guibg=NONE    gui=NONE
highlight Operator        guifg=#9FCA56 guibg=NONE    gui=NONE
highlight PreProc         guifg=#FF026A guibg=NONE    gui=NONE
highlight Special         guifg=#D4D7D6 guibg=NONE    gui=NONE
highlight Statement       guifg=#9FCA56 guibg=NONE    gui=NONE
highlight StorageClass    guifg=#E6CD69 guibg=NONE    gui=NONE
highlight String          guifg=#55B5DB guibg=NONE    gui=NONE
highlight Tag             guifg=#55B5DB guibg=NONE    gui=NONE
highlight Todo            guifg=#41535B guibg=NONE    gui=inverse,bold
highlight Type            guifg=#55B5DB guibg=NONE    gui=NONE
highlight Underlined      guifg=NONE    guibg=NONE    gui=underline

" Neovim specific
highlight TermCursor      guifg=#FEFEFE guibg=#FF5BFF gui=reverse
highlight TermCursorNC    guifg=#FEFEFE guibg=#FF5BFF gui=reverse
highlight EndOfBuffer     guifg=NONE    guibg=#151718 gui=NONE
