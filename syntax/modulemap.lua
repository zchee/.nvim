-- vim syntax file
-- Language: C++ module map
-- Maintainer: Saleem Abdulrasool <compnerd@compnerd.org>

if vim.b.current_syntax then
  return
end

vim.cmd([[
syntax keyword moduleKeyword
      \ config_macros
      \ conflict
      \ exclude
      \ explicit
      \ extern
      \ export
      \ framework
      \ header
      \ link
      \ private
      \ requires
      \ textual
      \ umbrella
      \ use

syntax match moduleIdentifier
      \ /\<[A-Za-z_][A-Za-z_0-9]*\>/

syntax keyword moduleKeyword nextgroup=moduleName
      \ module

" TODO(compnerd) make this match the proper thing of .-separated components and
" only apply to the content after the `module` keyword
syntax match moduleName
      \ /\<[A-Za-z_][A-Za-z_0-9]*\>/

syntax region moduleAttributes start=/\[/ skip=/,/ end=/\]/ contains=moduleIdentifier

syntax region moduleString start=/"/ skip=/\\"/ end=/"/

syntax region moduleComment start="/\*" end="\*/" contains=moduleComment,moduleLineComment,moduleTodo
syntax region moduleLineComment start="//" end="$" contains=moduleComment,moduleTodo

syntax keyword moduleTodo HACK FIXME TODO contained

highlight default link moduleComment Comment
highlight default link moduleLineComment Comment
highlight default link moduleIdentifier Identifier
highlight default link moduleIdentifierComponent Identifier
highlight default link moduleName Title
highlight default link moduleKeyword Statement
highlight default link moduleString String
highlight default link moduleTodo Todo
]])
