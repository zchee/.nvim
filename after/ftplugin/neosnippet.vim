setlocal foldmethod=marker
setlocal noexpandtab
let &l:commentstring = ' ' . &commentstring

call dein#source('neosnippet.vim')
