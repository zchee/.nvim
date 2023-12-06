if exists("b:current_syntax")
  finish
endif

runtime! "syntax/gotexttmpl.vim"
runtime! "syntax/yaml.vim"

let b:current_syntax = "gotexttmpl.yaml"

" vim: sw=2 ts=2 et
