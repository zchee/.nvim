syn match    cCustomParen    "(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
hi def link  cCustomFunc     Function

" Fix highlighting errors with Apple's blocks extensions to C
" syn clear cErrInParen
" syn clear cErrInBracket
" syn match    cErrInParen     display contained "[\]]\|<%\|%>"
" syn match    cErrInBracket   display contained "[)]\|<%\|%>"

syn keyword   cErr       ret
hi def link   cErr       Error
