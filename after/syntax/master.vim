if exists('b:did_master_syntax')
  finish
endif

let b:did_master_syntax = 1
let b:did_master_syntax = get(b:, 'current_syntax', 'master')
unlet! b:current_syntax
runtime! syntax/c.vim
let b:current_syntax = b:did_master_syntax
unlet b:did_master_syntax
