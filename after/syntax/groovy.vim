syn match  groovyBraces         "[{}]"
syn match  groovyBraces         "[\|]"

syn match groovyOperator        "[][()+\-*.=<>&|^]"
syn match groovyOperator        "/\([/*]\)\@!"
syn keyword groovyJDKBuiltin    it
syn match groovyAssert          "\<assert\u\w\+\>"

syn match groovyAnnotation      "@[_$a-zA-Z][_$a-zA-Z0-9_]*\>"
hi def link groovyAnnotation PreProc

"syn match groovyClass "\(class \|import [a-z.]\+\)\@<!\<[A-Z][A-Za-z]\+\>"
syn match groovyClass "\<[A-Z][A-Za-z0-9]\+\>"
hi def link groovyClass Identifier

syn match groovyStaticFinal "\<[A-Z][A-Z0-9_]\+\>"
hi def link groovyStaticFinal PreProc

" Now included in fixed syntax/groovy.vim
"syn region groovyString         start=+"""+ end=+"""+ keepend fold contains=groovySpecialChar,groovySpecialError,@Spell,groovyELExpr
"syn region groovyString         start=+'''+ end=+'''+ keepend fold contains=groovySpecialChar,groovySpecialError,@Spell,groovyELExpr

" TODO: regexps
syn region  groovyRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gi]\{0,2\}\s*$+ end=+/[gi]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=groovySpecial oneline

" Highlight Links
hi link groovyRegexpString      String

" Folding {{{

" breaks e.g. multiline strings with braces
"syn region foldBraces start=/{\s*$/ end=/^\s*}\s*$/ transparent fold keepend extend
"syn region foldBraces start="{" end="}" transparent fold keepend extend

syn region foldJavadoc start=+/\*+ end=+\*/+ transparent fold extend

syn region foldImports start=/\(^\s*\n^import\)\@<= .\+$/ end=+^\s*$+ transparent fold keepend

syn sync fromstart

setlocal foldmethod=syntax
