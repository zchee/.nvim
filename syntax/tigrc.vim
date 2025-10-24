" Copied and edit from: https://github.com/teatimeguest/vim-tigrc/blob/405444aaff4e/syntax/tigrc.vim

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

syntax keyword tigrcBoolean true false yes no

syntax match tigrcNumber display '\<\d\+\>' contained

syntax region tigrcString
  \ start=+"+
  \ skip=+\\\\\|\\"+
  \ end=+"+
  \ contained
  \ contains=tigrcStateVariable

syntax region tigrcString
  \ start=+'+
  \ skip=+\\\\\|\\'+
  \ end=+'+
  \ contained
  \ contains=tigrcStateVariable

syntax keyword tigrcDefault default

syntax match tigrcLineContinuation '\\$'

syntax region tigrcError
  \ start='\%(\%(\s*\\\n\)*\s*\)\@<=[^\\[:space:]]\S*\s'
  \ skip='\\\\\|\\$'
  \ end='$'
  \ keepend

syntax keyword tigrcTodo TODO FIXME XXX

syntax region tigrcComment
  \ start='#'
  \ end='$'
  \ contains=tigrcTodo,@Spell
  \ keepend

syntax region tigrcSet
  \ matchgroup=tigrcCommand
  \ start='^\s*set\>'
  \ skip='\\\\\|\\$'
  \ end='$'
  \ contains=
  \   tigrcAuto,
  \   tigrcBoolean,
  \   tigrcComment,
  \   tigrcDefault,
  \   tigrcLineContinuation,
  \   tigrcNumber,
  \   tigrcOperator,
  \   tigrcPercentage,
  \   tigrcString,
  \   tigrcVariable
  \ keepend

syntax match tigrcVariable
  \ display
  \ '\<\%(author\|blame-\%(options\|view\)\|blob-view\|commit-\%(order\|title\)\|date\|diff-\%(context\|highlight\|options\|view\)\|editor-line-number\|file-\%(args\|name\|size\)\|focus-child\|git-colors\|grep-view\|history-size\|horizontal-scroll\|id\|ignore-\%(case\|graphics\|space\)\|line-\%(graphics\|number\)\|log-\%(options\|view\)\|mailmap\|main-\%(options\|view\)\|mode\|mouse\%(-scroll\|-wheel-cursor\)\?\|pager-view\|pgrp\|ref\|reference-\%(format\|options\)\|refresh-\%(interval\|mode\)\|refs-view\|reflog-view\|rev-args\|send-child-enter\|show-\%(changes\|notes\|untracked\)\|split-view-\%(height\|width\)\|stage-view\|start-on-head\|stash-view\|status\%(-show-untracked-\%(dirs\|files\)\|-view\)\?\|tab-size\|text\|tree-view\|truncation-delimiter\|vertical-split\|wrap-\%(lines\|search\)\)\>'
  \ contained

syntax match tigrcOperator display '\%(=\|:\)' contained

syntax keyword tigrcAuto auto

syntax match tigrcPercentage display '\<\d\+%' contained

syntax region tigrcBind
  \ matchgroup=tigrcCommand
  \ start='^\s*bind\>'
  \ skip='\\\\\|\\$'
  \ end='$'
  \ contains=
  \   tigrcAction,
  \   tigrcBoolean,
  \   tigrcComment,
  \   tigrcCommandFlag,
  \   tigrcLineContinuation,
  \   tigrcNumber,
  \   tigrcPrompt,
  \   tigrcStateVariable,
  \   tigrcString,
  \   tigrcSymbolicKey,
  \   tigrcView
  \ keepend

syntax match tigrcView
  \ display
  \ '\%(^\|\s\)\zs\%(main\|diff\|log\|help\|pager\|status\|stage\|tree\|blob\|blame\|refs\|reflog\|stash\|grep\|generic\|search\)\ze\%(\\\|\_s\)'
  \ contained

syntax match tigrcCommandFlag display '[!@+?<>]' contained

syntax match tigrcSymbolicKey
  \ display
  \ '<\%(Enter\|Space\|Backspace\|Tab\|Esc\%(ape\)\?\|Left\|Right\|Up\|Down\|Ins\%(ert\)\?\|Del\%(ete\)\?\|Hash\|LessThan\|L[Tt]\|Home\|End\|\%(Page\|Pg\)\%(Up\|Down\|Dn\)\|S\%(croll\)\?\%(Back\|Fwd\)\|BackTab\|Shift\%(Tab\|Left\|Right\|Del\%(ete\)\|Home\|End\)\|F1\?\d\|C\%(trl\)\?-\%(<\%(Enter\|Space\|Backspace\|Tab\|Esc\%(ape\)\?\|Left\|Right\|Up\|Down\|Ins\%(ert\)\?\|Del\%(ete\)\?\|Hash\|LessThan\|L[Tt]\|Home\|End\|\%(Page\|Pg\)\%(Up\|Down\|Dn\)\|S\%(croll\)\?\%(Back\|Fwd\)\|BackTab\|Shift\%(Tab\|Left\|Right\|Del\%(ete\)\|Home\|End\)\|F1\?\d\)>\|[^<#]\)\)>'
  \ contained

syntax match tigrcStateVariable
  \ display
  \ '%(\%(head\|commit\|blob\|branch\|remote\|tag\|stash\|directory\|file\|lineno\|ref\|\%(rev\|file\|cmdline\|diff\|blame\|log\|main\)args\|prompt[^)]*\|text\|repo:\%(head\%(-id\)\?\|remote\|cdup\|prefix\|git-dir\|is-inside-work-tree\)\))'
  \ contained

syntax match tigrcPrompt
  \ display
  \ '\%(^\|\s\)\zs:[^\\[:space:]]\+\ze\%(\\\|\_s\)'
  \ contained

syntax match tigrcAction
  \ display
  \ '\c\%(^\|\s\)\zs\%(back\|edit\|enter\|find[-_.]\%(next\|prev\)\|maximize\|move[-_.]\%(down\|first[-_.]line\|\%(half[-_.]\)\?page[-_.]\%(down\|up\)\|last[-_.]line\|\%(next\|prev\)[-_.]merge\|up\)\|next\|none\|options\|parent\|previous\|prompt\|quit\|refresh\|screen[-_.]redraw\|scroll[-_.]\%(first[-_.]col\|left\|\%(line\|\%(half[-_.]\)\?page\)[-_.]\%(down\|up\)\|right\)\|search\%([-_.]back\)\?\|show[-_.]version\|stage[-_.]\%(split[-_.]chunk\|update[-_.]\%(line\|part\)\)\|status[-_.]\%(merge\|revert\|update\)\|stop[-_.]loading\|view[-_.]\%(blame\|blob\|close\%([-_.]no[-_.]quit\)\?\|diff\|grep\|help\|log\|main\|next\|pager\|refs\|reflog\|stage\|stash\|status\|tree\)\)\>\ze\%(\s*\\\n\)*\s*\%($\|#\)'
  \ contained

syntax region tigrcColor
  \ matchgroup=tigrcCommand
  \ start='^\s*color\>'
  \ skip='\\\\\|\\$'
  \ end='$'
  \ contains=
  \   tigrcArea,
  \   tigrcAttribute,
  \   tigrcBoolean,
  \   tigrcColorName,
  \   tigrcComment,
  \   tigrcDefault,
  \   tigrcLineContinuation,
  \   tigrcNumber,
  \   tigrcString
  \ keepend

syntax match tigrcArea
  \ display
  \ '\c\<\%(\%(main\|log\|diff\|tree\|blob\|blame\|refs\|status\|stage\|stash\|grep\|pager\|help\)\.\)\?\%(author\|commit\%(ter\)\?\|cursor\|date\|delimiter\|diff[-_]\%(\%(add\|del\)\%([-_]highlight\|2\)\?\|chunk\|copy[-_]\%(from\|to\)\|header\|index\|newmode\|oldmode\|similarity\|stat\)\|directory\|file\%([-_]size\)\?\|graph[-_]commit\|header\|help[-_]\%(action\|group\)\|id\|line[-_]number\|main[-_]\%(annotated\|commit\|head\|local[-_]tag\|ref\|remote\|replace\|tag\|tracked\)\|mode\|overflow\|palette[-_]\%(1[0-3]\|\d\)\|parent\|pp[-_]\%(merge\|reflog\%(msg\)\?\|refs\)\|search[-_]result\|section\|stat[-_]\%(none\|staged\|unstaged\|untracked\)\|status\|title[-_]\%(blur\|focus\)\|tree\%([-_]dir\|[-_]file\)\?\)\>'
  \ contained

syntax keyword tigrcColorName white black green magenta blue cyan yellow red
syntax match tigrcColorName
  \ display
  \ '\<color\%(\d\d\?\|2\%([0-4]\d\|5[0-5]\)\)\>'
  \ contained

syntax keyword tigrcAttribute normal blink bold dim reverse standout underline

syntax region tigrcSource
  \ matchgroup=tigrcCommand
  \ start='^\s*source\>'
  \ skip='\\\\\|\\$'
  \ end='$'
  \ contains=
  \   tigrcBoolean,
  \   tigrcComment,
  \   tigrcLineContinuation,
  \   tigrcNumber,
  \   tigrcString
  \ keepend

highlight def link tigrcBoolean Boolean
highlight def link tigrcNumber Number
highlight def link tigrcString String
highlight def link tigrcDefault Keyword
highlight def link tigrcLineContinuation Special
highlight def link tigrcError Error
highlight def link tigrcTodo Todo
highlight def link tigrcComment Comment
highlight def link tigrcCommand Statement
highlight def link tigrcVariable Type
highlight def link tigrcOperator Operator
highlight def link tigrcAuto Keyword
highlight def link tigrcPercentage Number
highlight def link tigrcView Type
highlight def link tigrcSymbolicKey PreProc
highlight def link tigrcStateVariable PreProc
highlight def link tigrcPrompt Function
highlight def link tigrcAction Function
highlight def link tigrcCommandFlag Special
highlight def link tigrcArea Type
highlight def link tigrcColorName Constant
highlight def link tigrcAttribute Function

syntax sync minlines=200
syntax sync maxlines=500

let b:current_syntax = 'tigrc'

let &cpoptions = s:cpo_save
unlet s:cpo_save
