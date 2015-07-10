" Vim color file

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
highlight TermCursor   guibg=#FF5BFF guifg=#FEFEFE gui=reverse " Not works
highlight TermCursorNC guibg=#FF5BFF guifg=#FEFEFE gui=reverse " Not works
highlight EndOfBuffer  guibg=#151718 guifg=NONE    gui=NONE
highlight Comment      guibg=#1D2427 guifg=#58707A
" highlight Question     guibg=#202123 gui=bold

highlight Normal                        guifg=#d4d7d6 guibg=#151718 gui=NONE
highlight Cursor                        guifg=#151718 guibg=#ffe792 gui=NONE
highlight Visual                        guifg=NONE    guibg=#4fa5c7 gui=NONE
highlight CursorLine                    guifg=NONE    guibg=#282a2b gui=NONE
highlight CursorColumn                  guifg=NONE    guibg=#282a2b gui=NONE
highlight ColorColumn                   guifg=NONE    guibg=#282a2b gui=NONE
highlight LineNr                        guifg=#757777 guibg=#282a2b gui=NONE
highlight VertSplit                     guifg=#4c4f4f guibg=#4c4f4f gui=NONE
highlight MatchParen                    guifg=#9fca56 guibg=NONE    gui=underline
highlight StatusLine                    guifg=#d4d7d6 guibg=#4c4f4f gui=bold
highlight StatusLineNC                  guifg=#d4d7d6 guibg=#4c4f4f gui=NONE
highlight Pmenu                         guifg=NONE    guibg=#282a2b gui=bold
highlight PmenuSel                      guifg=#FEFEFE guibg=#4f99d3 gui=bold
highlight PmenuSbar                     guifg=#FEFEFE guibg=#101213 gui=bold
highlight PmenuThumb                    guifg=NONE    guibg=#383a3a gui=bold
highlight IncSearch                     guifg=#151718 guibg=#55b5db gui=NONE
highlight Search                        guifg=NONE    guibg=NONE    gui=underline
highlight Directory                     guifg=#cd3f45 guibg=NONE    gui=NONE
highlight Folded                        guifg=#41535b guibg=#151718 gui=NONE

highlight Boolean                       guifg=#cd3f45 guibg=NONE    gui=NONE
highlight Character                     guifg=#cd3f45 guibg=NONE    gui=NONE
highlight Comment                       guifg=#41535b guibg=NONE    gui=NONE
highlight Conditional                   guifg=#9fca56 guibg=NONE    gui=NONE
highlight Constant                      guifg=#cd3f45 guibg=NONE    gui=NONE
highlight Define                        guifg=#9fca56 guibg=NONE    gui=NONE
highlight DiffAdd                       guifg=#d4d7d6 guibg=#43800a gui=bold
highlight DiffDelete                    guifg=#870505 guibg=NONE    gui=NONE
highlight DiffChange                    guifg=#d4d7d6 guibg=#1a3150 gui=NONE
highlight DiffText                      guifg=#d4d7d6 guibg=#204a87 gui=bold
highlight ErrorMsg                      guifg=#f8f8f8 guibg=NONE    gui=NONE
highlight WarningMsg                    guifg=#f8f8f8 guibg=NONE    gui=NONE
highlight Float                         guifg=#cd3f45 guibg=NONE    gui=NONE
highlight Function                      guifg=#55b5db guibg=NONE    gui=NONE
highlight Identifier                    guifg=#e6cd69 guibg=NONE    gui=NONE
highlight Keyword                       guifg=#9fca56 guibg=NONE    gui=NONE
highlight Label                         guifg=#55b5db guibg=NONE    gui=NONE
highlight NonText                       guifg=#2b2e28 guibg=#1f2122 gui=NONE
highlight Number                        guifg=#cd3f45 guibg=NONE    gui=NONE
highlight Operator                      guifg=#9fca56 guibg=NONE    gui=NONE
highlight PreProc                       guifg=#ff026a guibg=NONE    gui=NONE
highlight Special                       guifg=#d4d7d6 guibg=NONE    gui=NONE
highlight SpecialKey                    guifg=#2b2e28 guibg=#282a2b gui=NONE
highlight Statement                     guifg=#9fca56 guibg=NONE    gui=NONE
highlight StorageClass                  guifg=#e6cd69 guibg=NONE    gui=NONE
highlight String                        guifg=#55b5db guibg=NONE    gui=NONE
highlight Tag                           guifg=#55b5db guibg=NONE    gui=NONE
highlight Title                         guifg=#d4d7d6 guibg=NONE    gui=bold
highlight Todo                          guifg=#41535b guibg=NONE    gui=inverse,bold
highlight Type                          guifg=#55b5db guibg=NONE    gui=NONE
highlight Underlined                    guifg=NONE    guibg=NONE    gui=underline

