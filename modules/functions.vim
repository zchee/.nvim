"
" Temporary functions
"

" C Cpp Objc ObjCpp:
" Open cppreference.com
function! s:open_online_cpp_doc()
  let l = getline('.')
  if l =~# '^\s*#\s*include\s\+<.\+>'
    let header = matchstr(l, '^\s*#\s*include\s\+<\zs.\+\ze>')
    if header =~# '^boost'
      execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.matchstr(header, 'boost/\zs[^/>]\+\ze')
    else
      execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.matchstr(header, '\zs[^/>]\+\ze')
    endif
  else
    let cword = expand('<cword>')
    if cword ==# ''
      return
    endif
    let line_head = getline('.')[:col('.')-1]
    if line_head =~# 'boost::[[:alnum:]:]*$'
      execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.cword
    elseif line_head =~# 'std::[[:alnum:]:]*$'
      execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.cword
    else
      normal! K
    endif
  endif
endfunction


function! ProfilingSyntax() abort
  " Initial and cleanup syntime
  redraw!
  syntime clear

  " Profiling syntax regexp
  syntime on
  redraw!
  syntime report
endfunction
