syn match    cCustomParen    "(" contains=cParen contains=cCppParen
syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
hi def link cCustomFunc  Function
