" function! s:head(str)
"   let col = col('.')
"   let head = matchstr(getline('.'), '\c^\s*\%(ONBUILD\s\+\)\?')
"   let col -= len(head)
"   if col - 2 < len(a:str)
"     return toupper(a:str)
"   endif
"   return a:str
" endfunction
" 
" for s:instruction in [
"      \   'FROM',
"      \   'MAINTAINER',
"      \   'RUN',
"      \   'CMD',
"      \   'LABEL',
"      \   'EXPOSE',
"      \   'ENV',
"      \   'ADD',
"      \   'COPY',
"      \   'ENTRYPOINT',
"      \   'VOLUME',
"      \   'USER',
"      \   'WORKDIR',
"      \   'ARG',
"      \   'ONBUILD',
"      \   'STOPSIGNAL',
"      \   'HEALTHCHECK',
"      \   'SHELL',
"      \ ]
"   execute 'inoreabbrev <buffer> <expr>'
"        \ s:instruction
"        \ printf('<SID>head(%s)', string(s:instruction))
" endfor
