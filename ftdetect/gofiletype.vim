function! GoMod()
  for l:i in range(1, line('$'))
    let l:l = getline(l:i)
    if l:l ==# '' || l:l[:1] ==# '//'
    endif

    if l:l =~# '^module .\+'
      setfiletype gomod
    endif

    break
  endfor
endfunction

" remove the autocommands for modsim3, and lprolog files so that their
" highlight groups, syntax, etc. will not be loaded. *.MOD is included, so
" that on case insensitive file systems the module2 autocmds will not be
" executed.
autocmd! BufRead,BufNewFile *.mod,*.MOD

" Set the filetype if the first non-comment and non-blank line starts with
" 'module <path>'.
autocmd BufRead,BufNewFile go.mod call GoMod()
