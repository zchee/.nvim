" the regions that contain=@CSource all use the goComment region as well,
" because the Vim C comment syntax rule is defined with "extend", which breaks
" badly when you have:
" /*
" // c source lines here
" /*
" // more c source
" */
" import "C"
"
" When you defer to Vim's C syntax rules, everything
" after the */ is treated like C source, because the */ is matched
" by the C comment rule even though the cgo region as a whole matched.
" The "extend" keyword causes the cgo region to continue.
" The goComment region does not use extend, and so the cgo region ends when
" it should.
"
" TODO(chrisnc): currently, in line-commented import "C" blocks, C
" preprocessor directives (#include, #define) etc., are not highlighted.
" This is because the C syntax defines them with a ^ match rule, which will
" not match inside of a line comment as the line starts with // even though
" these characters are not in the region due to rs=s+2.
" To fix this one could use modified versions of the C preprocessor matching
" rules and include them in the cgoSourceLine region's contains attribute.
" Other solutions may be possible...
" C preprocessor directives are highlighted correctly within
" /* */
" import "C" blocks
syn region  cgoSourceLine           contained keepend matchgroup=cgoComment
  \ start=/\v\/\//rs=s+2
  \ end="$" contains=@CSource,goComment

syn match   cgoHash                 display contained "#cgo"
syn match   cgoSrcdir               display contained "${SRCDIR}"
syn match   cgoPkgConfig            display contained "pkg-config"
syn keyword cgoKeywords             CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
syn region  cgoDirectiveLine        contained matchgroup=cgoComment
  \ start=/\v\/\/\s*#cgo/rs=s+2 end="$"
  \ contains=cgoHash,cgoSrcdir,cgoPkgConfig,cgoKeywords

syn region  cgoLines                keepend
  \ start=/\v(\/\/.*\n)+\s*import\s"C"/
  \ end=/\v\n\s*import\s"C"/he=e-10,me=e-10,re=e-10
  \ contains=cgoSourceLine,cgoDirectiveLine

syn region  cgoDirective            contained
  \ start=/\v#cgo\s/ end="$"
  \ contains=cgoHash,cgoSrcdir,cgoPkgConfig,cgoKeywords

syn region  cgoMultiline            keepend matchgroup=cgoComment
  \ start=/\v\/\*(.*\n)+\*\/\s*\n\s*import\s"C"/rs=s+2
  \ end=/\v\*\/\s*\n\s*import\s"C"/re=s-1,me=e-11,he=e-11
  \ contains=@CSource,goComment,cgoDirective

hi def link cgoComment              Comment
hi def link cgoHash                 PreProc
hi def link cgoSrcdir               PreProc
hi def link cgoKeywords             PreProc
hi def link cgoPkgConfig            PreProc

