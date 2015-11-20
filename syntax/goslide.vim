" Go slide(talk) syntax file
" Language:	  Go slide Language
" Maintainer:	zchee aka Koichi Shiraishi <zchee.io@gmail.com>
" URL:		    https://github.com/zchee/vim-goslide
" TODO: 	    Support all go slide syntax

syn region  goslideSection        start="^\s*[*]\s\+" end="\($\|#\+\)" contains=@Spell
syn region  goslideSubSection     start="^\s*[*]\s\+" end="\($\|#\+\)" contains=@Spell
syn region  goslideChildSection   start="^\s*[*]\s\+" end="\($\|#\+\)" contains=@Spell
syn match   goslideListItem       "^\s*[-]\s\+"

syn match   goslideCode          /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn region  goslideInlineURL     start=".link"  end="\($\|#\+\)"
syn region  goslideLink          start="\[\[" end="\]\]"

hi def link     goslideListItem        Identifier 
hi def link     goslideSection         Title
hi def link     goslideSubSection      Title
hi def link     goslideChildSection    Title
hi def link     goslideslideCode       String
hi def link     goslideslideLink       Underlined
hi def link     goslideslideInlineURL  Underlined
