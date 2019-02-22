" Copyright The vim-vgo Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'jsonc'
endif

runtime! syntax/json.vim
" TODO(zchee): `syntax include @JSON syntax/json.vim` with ` contains=@JSON`

" Comment
syn region  jsoncLineComment    start=+\/\/+ end=+$+ keepend
syn region  jsoncLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend fold
syn region  jsoncComment        start="/\*"  end="\*/" fold

hi def link jsoncLineComment        Comment
hi def link jsoncComment            Comment

let b:current_syntax = "jsonc"
if main_syntax == 'jsonc'
  unlet main_syntax
endif

" vim: sts=2:sw=2:ts=2:et
