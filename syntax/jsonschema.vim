if exists('b:did_jsonschema_syntax')
  finish
endif
let b:did_jsonschema_syntax = 1

runtime! syntax/json.vim
