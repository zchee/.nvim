highlight default link goImportedPkg Include

augroup hl-goimport
  autocmd!
  autocmd BufReadPost,TextChanged *.go call hlgoimport#update(0)
  autocmd FileType,Syntax go call hlgoimport#update(1)
augroup END
