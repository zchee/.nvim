" nvimrc augroup syntax
highlight def link gVimAutoCmd   vimAutoCmd
highlight def link gVimAutoGroup vimAutoGroup

syntax keyword gVimAutoCmd   Gautocmd   skipwhite nextgroup=vimAutoEventList
syntax keyword gVimAutoCmd   Gautocmdft skipwhite nextgroup=vimAutoCmdSfxList

syntax match   vimAutoGroup  contained  "\S\+" nextgroup=vimAutoEventList skipwhite
syntax keyword vimAutoCmd    au[tocmd]  do[autocmd] doautoa[ll] skipwhite nextgroup=vimAutoEventList,vimAutoGroup
