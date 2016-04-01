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

syn include @CSource syntax/c.vim

syn region  cgoSourceLine           contained keepend matchgroup=cgoComment
  \ start=/\v\/\//rs=s+2
  \ end="$"
  \ contains=@CSource,goComment

syn match   cgoHash                 display contained "#cgo"
syn match   cgoSrcdir               display contained "${SRCDIR}"
syn match   cgoPkgConfig            display contained "pkg-config"
syn keyword cgoKeywords             CFLAGS CPPFLAGS CXXFLAGS LDFLAGS

syn region  cgoDirectiveLine        contained matchgroup=cgoComment
  \ start=/\v\/\/\s*#cgo/rs=s+2
  \ end="$"
  \ contains=cgoHash,cgoSrcdir,cgoPkgConfig,cgoKeywords

syn region  cgoLines                keepend
  \ start=/\v(\/\/.*\n)+\s*import\s"C"/
  \ end=/\v\n\s*import\s"C"/he=e-10,me=e-10,re=e-10
  \ contains=cgoSourceLine,cgoDirectiveLine

syn region  cgoDirective            contained
  \ start=/\v#cgo\s/
  \ end="$"
  \ contains=cgoHash,cgoSrcdir,cgoPkgConfig,cgoKeywords

syn keyword cgoStatement	          goto break return continue asm

syn region	cIncluded	              display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	  cIncluded	              display contained "<[^>]*>"
syn match  	cInclude                display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded

syn keyword cgoType                 static void
syn keyword	cgoType                 int long short char void
syn keyword	cgoType                 signed unsigned float double
if !exists("c_no_ansi") || exists("c_ansi_typedefs")
  syn keyword   cgoType             size_t ssize_t off_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   cgoType             clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   cgoType             mbstate_t wctrans_t wint_t wctype_t
endif
if !exists("c_no_c99") " ISO C99
  syn keyword	cgoType               _Bool bool _Complex complex _Imaginary imaginary
  syn keyword	cgoType               int8_t int16_t int32_t int64_t
  syn keyword	cgoType               uint8_t uint16_t uint32_t uint64_t
  syn keyword	cgoType               int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword	cgoType               uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword	cgoType               int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword	cgoType               uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword	cgoType               intptr_t uintptr_t
  syn keyword	cgoType               intmax_t uintmax_t
endif

syn keyword	cgoOperator             sizeof
syn keyword	cgoStructure            struct union enum typedef
syn keyword	cgoStorageClass         static register auto volatile extern const

if exists("c_gnu")
  syn keyword	cgoType               __label__ __complex__ __volatile__
endif
if exists("c_gnu")
  syn keyword	cgoStatement          __asm__
  syn keyword	cOperator             typeof __real__ __imag__
endif
if exists("c_gnu")
  syn keyword	cgoStorageClass       inline __attribute__
endif
if !exists("c_no_c99")
  syn keyword	cgoStorageClass       inline restrict
endif
if !exists("c_no_c11")
  syn keyword cgoType               char16_t char32_t
  syn keyword	cgoStorageClass       _Alignas alignas
  syn keyword	cgoStorageClass       _Atomic
  syn keyword	cgoStorageClass       _Noreturn noreturn
  syn keyword	cgoStorageClass       _Thread_local thread_local
  syn keyword	cgoOperator           _Alignof alignof
  syn keyword	cgoOperator           _Generic
  syn keyword	cgoOperator           _Static_assert static_assert
endif


syn region  cgoMultiline            keepend matchgroup=cgoComment
  \ start=/\v\/\*(.*\n)+\*\/\s*\n\s*import\s"C"/rs=s+2
  \ end=/\v\*\/\s*\n\s*import\s"C"/re=s-1,me=e-11,he=e-11
  \ contains=cgoStatement,cInclude,cgoType,cgoOperator,cgoStructure,cgoStorageClass,@CSource,goComment,cgoDirective

" syn keyword	cOperator	sizeof
" syn keyword	cType	static

" if exists("c_gnu")
"   syn keyword	cStatement	__asm__
"   syn keyword	cOperator	typeof __real__ __imag__
" endif
" syn keyword	cType		int long short char void
" syn keyword	cType		signed unsigned float double
" if !exists("c_no_ansi") || exists("c_ansi_typedefs")
"   syn keyword   cType		size_t ssize_t off_t wchar_t ptrdiff_t sig_atomic_t fpos_t
"   syn keyword   cType		clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
"   syn keyword   cType		mbstate_t wctrans_t wint_t wctype_t
" endif
" if !exists("c_no_c99") " ISO C99
"   syn keyword	cType		_Bool bool _Complex complex _Imaginary imaginary
"   syn keyword	cType		int8_t int16_t int32_t int64_t
"   syn keyword	cType		uint8_t uint16_t uint32_t uint64_t
"   syn keyword	cType		int_least8_t int_least16_t int_least32_t int_least64_t
"   syn keyword	cType		uint_least8_t uint_least16_t uint_least32_t uint_least64_t
"   syn keyword	cType		int_fast8_t int_fast16_t int_fast32_t int_fast64_t
"   syn keyword	cType		uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
"   syn keyword	cType		intptr_t uintptr_t
"   syn keyword	cType		intmax_t uintmax_t
" endif
" if exists("c_gnu")
"   syn keyword	cType		__label__ __complex__ __volatile__
" endif
"
" syn keyword	cStructure	struct union enum typedef
" syn keyword	cStorageClass	keepend matchgroup=cgoComment static register auto volatile extern const
" if exists("c_gnu")
"   syn keyword	cStorageClass	inline __attribute__
" endif
" if !exists("c_no_c99")
"   syn keyword	cStorageClass	inline restrict
" endif
" if !exists("c_no_c11")
"   syn keyword	cStorageClass	_Alignas alignas
"   syn keyword	cOperator	_Alignof alignof
"   syn keyword	cStorageClass	_Atomic
"   syn keyword	cOperator	_Generic
"   syn keyword	cStorageClass	_Noreturn noreturn
"   syn keyword	cOperator	_Static_assert static_assert
"   syn keyword	cStorageClass	_Thread_local thread_local
"   syn keyword   cType		char16_t char32_t
" endif

hi def link cgoStatement            Statement
hi def link cgoComment              Comment
hi def link cgoType                 Type
hi def link cgoStorageClass         Type
hi def link cInclude                PreProc
hi def link cIncluded               String
hi def link cgoHash                 PreProc
hi def link cgoSrcdir               PreProc
hi def link cgoKeywords             PreProc
hi def link cgoPkgConfig            PreProc
