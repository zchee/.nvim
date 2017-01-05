let s:bufname = expand('%')

if s:bufname ==? 'circle.yml'
  let s:current_syntax = b:current_syntax
  unlet b:current_syntax
  syntax include @SH syntax/sh.vim
  let b:current_syntax = s:current_syntax

  syntax region shLine start=/\v^\s*(-|- >\n\s+)\s/ end=/\v$/ contains=@SH
endif
