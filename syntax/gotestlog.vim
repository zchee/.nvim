if exists('b:current_syntax')
  finish
endif

syntax match  GoTestLogRun       "\v^\=\=\=\sRUN"
syntax match  GoTestLogPass      "\v^(\s+)?[-=]+\sPASS"
syntax match  GoTestLogFail      "\v^(\s+)?[-\|=]+\sFAIL:\s.*$"
syntax match  GoTestLogInfo      "\v^(\s+)?INFO"
" syntax match  GoTestLogTestName  "\v[\w]*Test_.*$"

" syntax match DoxyfileVariableStart "/\v\=/" nextgroup=DoxyfileVariableContext
" syntax region GoTestLogRun start="/\=\=\=\sRUN" rs=e+2 end="\s*$" oneline
" syntax region DoxyfileVariable start=/\v"\s*/ skip=/\v\\./ end=/\v"/
" syntax match DoxyfileVariableContext "[^ \t].*" contained
" syntax match DoxyfileVariable   /\v^(\\w+)[ \\t]*\\+?=/
" syntax match DoxyfileComment   "\v^\s*#.*$"

hi def link GoTestLogRun      Statement
hi def link GoTestLogPass     Delimiter
hi def link GoTestLogFail     Error
hi def link GoTestLogInfo     Delimiter
" hi def link GoTestLogTestName Float


let b:current_syntax = 'gotestlog'
