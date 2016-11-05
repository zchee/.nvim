" Line continuation is used here, remove 'C' from 'cpoptions'
let s:cpo_save = &cpo
set cpo&vim

augroup filetypedetect

" Pyrex
au BufNewFile,BufRead *.pyx,*.pxd setfiletype cython
