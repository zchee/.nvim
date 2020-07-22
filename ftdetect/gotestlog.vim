au BufRead,BufNewFile *.log call s:gotestlog()

fun! s:gotestlog()
  if getline(1) =~# '^=== .\+'
    setfiletype gotestlog
  endif
endfun

" vim: sw=2 ts=2 et
