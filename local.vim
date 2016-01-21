if exists("b:load_init_local")
    finish
endif

function IsRtp(name)
  substitute(&runtimepath,'^s:',a:name)
endfunction

let b:load_init_local = 1
" vim: set ft=vim fdm=marker ff=unix
