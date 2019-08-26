"" C:
" syntax    match    cCustomParen    "(" contains=cParen contains=cCppParen
" syntax    match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
" highlight def link cCustomFunc     Function
"
" " Fix highlighting errors with Apple's blocks extensions to C
" syntax    clear    cErrInParen
" syntax    clear    cErrInBracket
" syntax    match    cErrInParen     display contained "[\]]\|<%\|%>"
" syntax    match    cErrInBracket   display contained "[)]\|<%\|%>"
"
" syntax    keyword  cErr            ret
" highlight def link cErr       Error
"
" highlight! cCustomFunc  gui=None    guifg=#f0c674    guibg=None
" highlight! cErr         gui=Bold    guifg=#ff005f    guibg=None
