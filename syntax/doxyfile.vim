if exists('b:current_syntax')
  finish
endif


" syntax match DoxyfileVariableStart "/\v\=/" nextgroup=DoxyfileVariableContext
syntax region DoxyfileVariableContext start="/\= "rs=e+2 end="\s*$" oneline
" syntax region DoxyfileVariable start=/\v"\s*/ skip=/\v\\./ end=/\v"/
" syntax match DoxyfileVariableContext "[^ \t].*" contained
" syntax match DoxyfileVariable   /\v^(\\w+)[ \\t]*\\+?=/
syntax match DoxyfileComment   "\v^\s*#.*$"

hi def link DoxyfileVariable String
hi def link DoxyfileVariableContext String
hi def link DoxyfileComment Comment


let b:current_syntax = 'doxyfile'
