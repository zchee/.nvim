" nvimrc augroup syntax
syntax keyword gVimAutoCmd   Gautocmd   skipwhite nextgroup=vimAutoEventList
syntax keyword gVimAutoCmd   Gautocmdft skipwhite nextgroup=vimAutoCmdSfxList
syntax keyword vimSh         sh

syntax match   vimAutoGroup  contained  "\S\+" nextgroup=vimAutoEventList skipwhite
syntax keyword vimAutoCmd    au[tocmd]  do[autocmd] doautoa[ll] skipwhite nextgroup=vimAutoEventList,vimAutoGroup

highlight def link gVimAutoCmd   vimAutoCmd
highlight def link gVimAutoGroup vimAutoGroup
highlight def link vimSh         Statement
