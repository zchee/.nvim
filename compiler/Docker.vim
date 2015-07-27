if exists('current_compiler')
  finish
endif
let current_compiler = "Docker"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=docker\ build\ -t\ %\ %
CompilerSet errorformat=
  \%E%f(%l\\,%c):\ error\ %m,
  \%W%f(%l\\,%c):\ warning\ %m,
  \%-G%.%#
" CompilerSet errorformat=%E%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%#
