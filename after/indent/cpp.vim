" Vim indent file
" https://gist.github.com/mattn/b6cc675eac4c67c923b1d952307947f7
"
" Language:	C++
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2008 Nov 29

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   "finish
endif
let b:did_indent = 1

" C++ indenting is built-in, thus this is very simple
setlocal cindent
setlocal indentexpr=GetCppIndent(v:lnum)

function! GetCppIndent(lnum)
  let cnum = prevnonblank(a:lnum - 1)
  let orig = cindent(a:lnum)
  let paren = indent(cnum)
  let cline = getline(cnum)
  if cline =~# '{$' && cline !~# '^\s*namespace.*'
  	if paren > 0
      return orig + shiftwidth()
    endif
  elseif cline =~# '}$'
    return orig - shiftwidth()
  elseif paren == 0
    return 0
  elseif getline(a:lnum) =~# '}$'
    return orig - shiftwidth()
  endif
  return orig
endfunction

let b:undo_indent = "setl cin<"
