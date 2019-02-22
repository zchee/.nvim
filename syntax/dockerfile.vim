" Vim syntax file
" Language: Dockerfile
" Maintainer: Eugene Kalinin
" Latest Revision: 11 September 2013
" Source: http://docs.docker.io/en/latest/use/builder/

if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "dockerfile"

" case sensitivity (fix #17)
" syn case  ignore

" Keywords
syntax match   dockerfileKeyword  /\v^\s*(ONBUILD\s+)?(CMD|ENTRYPOINT|RUN)\s/
highlight link dockerfileKeyword   Keyword
syntax keyword dockerfileKeywords FROM AS MAINTAINER COPY
syntax keyword dockerfileKeywords EXPOSE ADD
" syntax keyword dockerfileKeywords FROM AS MAINTAINER RUN CMD COPY
" syntax keyword dockerfileKeywords EXPOSE ADD ENTRYPOINT
syntax keyword dockerfileKeywords VOLUME USER WORKDIR ONBUILD
syntax keyword dockerfileKeywords LABEL ARG HEALTHCHECK SHELL

" Bash statements
setlocal iskeyword+=-
syntax keyword bashStatement add-apt-repository adduser apk apt-get aptitude apt-key autoconf bundle
syntax keyword bashStatement cd chgrp chmod chown clear complete composer cp curl du echo egrep
syntax keyword bashStatement expr fgrep find gem gnufind gnugrep gpg grep groupadd head less ln
syntax keyword bashStatement ls make mkdir mv node npm pacman pip pip3 php python rails rm rmdir rpm ruby
syntax keyword bashStatement sed sleep sort strip tar tail tailf touch useradd virtualenv yum
syntax keyword bashStatement usermod bash cat a2ensite a2dissite a2enmod a2dismod apache2ctl
syntax keyword bashStatement wget gzip

" Strings
syntax region dockerfileString start=/"/ skip=/\\"|\\\\/ end=/"/
syntax region dockerfileString1 start=/'/ skip=/\\'|\\\\/ end=/'/

" Emails
syntax region dockerfileEmail start=/</ end=/>/ contains=@ oneline

" Urls
syntax match dockerfileUrl /\(http\|https\|ssh\|hg\|git\)\:\/\/[a-zA-Z0-9\/\-\.]\+/

" Task tags
syntax keyword dockerfileTodo contained TODO FIXME XXX

" Comments
syntax region dockerfileComment start="#" end="\n" contains=dockerfileTodo
syntax region dockerfileEnvWithComment start="^\s*ENV\>" end="\n" contains=dockerfileEnv
syntax match dockerfileEnv contained /\<ENV\>/

" Highlighting
highlight link dockerfileKeywords  Keyword
highlight link dockerfileEnv       Keyword
highlight link dockerfileString    String
highlight link dockerfileString1   String
highlight link dockerfileComment   Comment
highlight link dockerfileEmail     Identifier
highlight link dockerfileUrl       Identifier
highlight link dockerfileTodo      Todo
highlight link bashStatement       Function

set commentstring=#\ %s

" Enable automatic comment insertion
setlocal fo+=cro

let s:current_syntax = b:current_syntax
unlet b:current_syntax
syntax include @SH syntax/sh.vim
let b:current_syntax = s:current_syntax
syntax region shLine matchgroup=dockerfileKeyword start=/\v^\s*(RUN|CMD|ENTRYPOINT)\s/ end=/\v$/ contains=@SH

" if exists("b:current_syntax")
"   finish
" endif
" let b:current_syntax = "dockerfile"
"
" syntax case ignore
"
" syntax match dockerfileKeyword /\v^\s*(ONBUILD\s+)?(ADD|ARG|CMD|COPY|ENTRYPOINT|ENV|EXPOSE|FROM|HEALTHCHECK|LABEL|MAINTAINER|RUN|SHELL|STOPSIGNAL|USER|VOLUME|WORKDIR)\s/
" highlight link dockerfileKeyword Keyword
"
" syntax region dockerfileString start=/\v"/ skip=/\v\\./ end=/\v"/
" highlight link dockerfileString String
"
" syntax match dockerfileComment "\v^\s*#.*$"
" highlight link dockerfileComment Comment
"
" set commentstring=#\ %s
"
" " match "RUN", "CMD", and "ENTRYPOINT" lines, and parse them as shell
" let s:current_syntax = b:current_syntax
" unlet b:current_syntax
" syntax include @SH syntax/sh.vim
" let b:current_syntax = s:current_syntax
" syntax region shLine matchgroup=dockerfileKeyword start=/\v^\s*(RUN|CMD|ENTRYPOINT)\s/ end=/\v$/ contains=@SH
" " since @SH will handle "\" as part of the same line automatically, this "just works" for line continuation too, but with the caveat that it will highlight "RUN echo '" followed by a newline as if it were a block because the "'" is shell line continuation...  not sure how to fix that just yet (TODO)
