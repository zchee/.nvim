" based by https://github.com/yunlingz/equinusocio-material.vim

if exists('g:colors_name')
  finish
endif

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'equinusocio_material'
set background=dark

" ------------------------------------------------------------------------------
" Palettes:

"" :help attr-list
"" :help highlight-gui

"" guisp is used for undercurl and underline.

" NONE		no color (transparent)
" bg		use normal background color
" background	use normal background color
" fg		use normal foreground color
" foreground	use normal foreground color

let s:p = {}

let s:p.none                    = 'None'          " no attributes used (used to reset it)
let s:p.bold                    = 'bold'
let s:p.underline               = 'underline'
let s:p.undercurl               = 'undercurl'     " curly underline
let s:p.strikethrough           = 'strikethrough'
let s:p.reverse                 = 'reverse'
let s:p.inverse                 = 'inverse'       " same as reverse
let s:p.italic                  = 'italic'
let s:p.standout                = 'standout'
let s:p.nocombine               = 'nocombine'     " override attributes instead of combining them

let s:p.material                = {}
let s:p.material.cursor         = '#111111'
let s:p.material.cursor_bg      = '#cccccc'
let s:p.material.hover_float    = '#c7c8c8'
let s:p.material.hover_float_bg = '#202122'
let s:p.material.man_bold       = '#f0c674'
let s:p.material.man_underline  = '#81a2be'

let s:p.material.foreground     = '#f2f3f3'  " '#e8eae9', '#c7c8c8'  " '#eeffff'
let s:p.material.background     = '#010101'  " '#0a0a0a', '#212121', '#040404'
let s:p.material.comment        = '#A5ABB0'  " '#8f979d'  " '#838c93'  " '#a2a9ae', '#79828a', '#6c7a80', '#838c93', '#878f96'
let s:p.material.nontext        = '#202122'
let s:p.material.longlinewarn   = '#371f1c'
let s:p.material.black          = '#000000'
let s:p.material.red            = '#ff5370'
let s:p.material.green          = '#bae57d'
let s:p.material.yellow         = '#ffcb6b'
let s:p.material.orange         = '#f78c6c'
let s:p.material.aqua           = '#8abeb7'  " #a1cbc5
let s:p.material.blue           = '#769AE7'  " #82aaff
let s:p.material.darkblue       = '#81a2be'
let s:p.material.magenta        = '#c792ea'
let s:p.material.cyan           = '#75d7ff'  " '#89ddff'
let s:p.material.white          = '#eeffff'
let s:p.material.caret          = '#ffcc00'
let s:p.material.pure_black     = '#000000'
let s:p.material.cursor_guide   = '#343941'  " '#425059'
let s:p.material.selection      = '#343941'  " '#371f1c'
let s:p.material.indent_line    = '#282a2e'  " '#2d3c46'
let s:p.material.darkcolumn     = '#1c1c1c'
let s:p.material.darkpmenu      = '#292d34'
let s:p.material.gray           = '#545454'
let s:p.material.linenr         = '#757575'  " '#8b9ead'

function! s:hl(group, fg, bg, attrs, blend)
  let l:hi_group = 'highlight! ' . a:group . ' ctermfg=None ctermbg=None cterm=None'
  
  let l:fg = ' guifg=None'
  if !empty(a:fg)
    let l:fg = ' guifg=' . a:fg
  endif

  let l:bg = ' guibg=None'
  if !empty(a:bg)
    let l:bg = ' guibg=' . a:bg
  endif

  let l:gui = ' gui=None'
  if !empty(a:attrs)
    let l:gui = ' gui='

    if type(a:attrs) == v:t_list
      let l:i = 1
      let l:len_attrs = len(a:attrs)
      while l:i < l:len_attrs
        let l:gui = l:gui . a:attr[l:i]
        if l:i < l:len_attrs
          let l:gui = l:gui . ','
        endif

        let l:i = l:i + 1
      endwhile
    else
      let l:gui = ' gui=' . a:attrs
    endif
  endif

  let l:blend = ' blend=0'
  if !empty(a:blend)
    let l:blend = ' blend=' . a:blend
  endif

  execute l:hi_group . l:fg . l:bg . l:gui . l:blend
endfunction

" :help group-name
" ------------------------------------------------------------------------------

call s:hl('ColorColumn',        s:p.none,                  s:p.material.cursor_guide, s:p.none, 0)
call s:hl('Conceal',            s:p.material.blue,         s:p.none, s:p.none, 0)
call s:hl('Cursor',             s:p.material.black,        s:p.material.caret, s:p.none, 0)
call s:hl('CursorIM',           s:p.material.black,        s:p.material.caret, s:p.none, 0)
call s:hl('CursorColumn',       s:p.none,                  s:p.material.cursor_guide, s:p.none, 0)
call s:hl('CursorLine',         s:p.none,                  s:p.material.cursor_guide, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Directory',          s:p.material.cyan,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('DiffAdd',            s:p.material.green,        s:p.none, s:p.none, 0)
call s:hl('DiffChange',         s:p.material.yellow,       s:p.none, s:p.none, 0)
call s:hl('DiffDelete',         s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('DiffText',           s:p.material.magenta,      s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('EndOfBuffer',        s:p.material.background,   s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('ErrorMsg',           s:p.material.red,          s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('VertSplit',          s:p.material.gray,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Folded',             s:p.material.foreground,   s:p.material.gray, s:p.none, 0)
call s:hl('FoldColumn',         s:p.material.foreground,   s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('SignColumn',         s:p.none,                  s:p.material.background, s:p.none, 0)
call s:hl('IncSearch',          s:p.material.black,        s:p.material.magenta, s:p.none, 0)
call s:hl('LineNr',             s:p.material.linenr,       s:p.none, s:p.bold, 0)
call s:hl('CursorLineNr',       s:p.material.foreground,   s:p.none, s:p.none, 0)
call s:hl('MatchParen',         s:p.material.black,        s:p.material.red, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('ModeMsg',            s:p.material.foreground,   s:p.none, s:p.none, 0)
call s:hl('MoreMsg',            s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('NonText',            s:p.none,                  s:p.none, s:p.none, 0)
call s:hl('Normal',             s:p.material.foreground,   s:p.none, s:p.none, 0)
call s:hl('TermCursor',         s:p.material.cursor,       s:p.material.cursor_bg, s:p.none, 0)
call s:hl('TermCursorNC',       s:p.material.cursor,       s:p.material.cursor_bg, s:p.reverse, 0)
call s:hl('HoverFloat',         s:p.material.hover_float,  s:p.material.hover_float_bg, s:p.none, 5)

" ------------------------------------------------------------------------------

call s:hl('manBold',            s:p.material.man_bold,     s:p.none, s:p.bold, 0)
call s:hl('manItalic',          s:p.none,                  s:p.none, s:p.italic, 0)
call s:hl('manUnderline',       s:p.material.man_underline,s:p.none, s:p.underline, 0)

" ------------------------------------------------------------------------------

call s:hl('Pmenu',              s:p.material.foreground,   s:p.material.nontext, s:p.bold, 0)
call s:hl('PmenuSel',           s:p.material.cyan,         s:p.material.black, s:p.none, 0)
call s:hl('PmenuSbar',          s:p.material.foreground,   s:p.material.gray, s:p.none, 0)
call s:hl('PmenuThumb',         s:p.material.foreground,   s:p.material.foreground, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Question',           s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('QuickFixLine',       s:p.material.foreground,   s:p.material.background, s:p.none, 0)
call s:hl('Search',             s:p.none,                  s:p.material.selection, s:p.none, 0)
call s:hl('CurSearch',          s:p.none,                  s:p.material.selection, s:p.none, 0)
call s:hl('SpecialKey',         s:p.material.gray,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('SpellBad',           s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('SpellCap',           s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('SpellLocal',         s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('SpellRare',          s:p.none,                  s:p.none, s:p.underline, 0)

" ------------------------------------------------------------------------------

call s:hl('StatusLine',         s:p.material.foreground,   s:p.none, s:p.none, 0)
call s:hl('StatusLineNC',       s:p.material.gray,         s:p.none, s:p.none, 0)
call s:hl('StatusLineTerm',     s:p.material.foreground,   s:p.none, s:p.none, 0)
call s:hl('StatusLineTermNC',   s:p.material.gray,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('TabLine',            s:p.material.foreground,   s:p.none, s:p.none, 0)
call s:hl('TabLineFill',        s:p.none,                  s:p.none, s:p.none, 0)
call s:hl('TabLineSel',         s:p.material.foreground,   s:p.material.gray, s:p.none, 0)
call s:hl('Terminal',           s:p.material.foreground,   s:p.material.background, s:p.none, 0)
call s:hl('Title',              s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('Visual',             s:p.material.foreground,   s:p.material.selection, s:p.none, 0)
call s:hl('VisualNOS',          s:p.material.foreground,   s:p.material.selection, s:p.none, 0)
call s:hl('WarningMsg',         s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('WildMenu',           s:p.material.black,        s:p.material.cyan, s:p.none, 0)

" ------------------------------------------------------------------------------
" standard syntax

call s:hl('Comment',            s:p.material.comment,      s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Constant',           s:p.material.green,        s:p.none, s:p.none, 0)
call s:hl('String',             s:p.material.green,        s:p.none, s:p.none, 0)
call s:hl('Number',             s:p.material.magenta,      s:p.none, s:p.none, 0)
call s:hl('Boolean',            s:p.material.magenta,      s:p.none, s:p.none, 0)
call s:hl('Float',              s:p.material.orange,       s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Identifier',         s:p.material.yellow,       s:p.none, s:p.none, 0)
call s:hl('Function',           s:p.material.blue,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Statement',          s:p.material.blue,         s:p.none, s:p.none, 0)
call s:hl('Conditional',        s:p.material.magenta,      s:p.none, s:p.none, 0)
call s:hl('Repeat',             s:p.material.blue,         s:p.none, s:p.none, 0)
call s:hl('Operator',           s:p.material.cyan,         s:p.none, s:p.none, 0)
call s:hl('Keyword',            s:p.material.magenta,      s:p.none, s:p.none, 0)
call s:hl('Exception',          s:p.material.blue,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('PreProc',            s:p.material.cyan,         s:p.none, s:p.none, 0)
call s:hl('Include',            s:p.material.cyan,         s:p.none, s:p.none, 0)
call s:hl('Define',             s:p.material.cyan,         s:p.none, s:p.none, 0)
call s:hl('Macro',              s:p.material.cyan,         s:p.none, s:p.none, 0)
call s:hl('PreCondit',          s:p.material.cyan,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Type',               s:p.material.yellow,       s:p.none, s:p.none, 0)
call s:hl('StorageClass',       s:p.material.yellow,       s:p.none, s:p.none, 0)
call s:hl('Structure',          s:p.material.magenta,      s:p.none, s:p.none, 0)
call s:hl('Typedef',            s:p.material.yellow,       s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Special',            s:p.material.magenta,      s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Underlined',         s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('Ignore',             s:p.none,                  s:p.none, s:p.strikethrough, 0)
call s:hl('Error',              s:p.material.red,          s:p.none, s:p.bold.','.s:p.underline, 0)
call s:hl('Todo',               s:p.material.caret,        s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------
" nvim-lspcnofig

call s:hl('LspErrorText',            s:p.material.red,     s:p.none, s:p.none,      0)
call s:hl('LspWarningText',          s:p.material.yellow,  s:p.none, s:p.none,      0)
call s:hl('LspInformationText',      s:p.material.orange,  s:p.none, s:p.none,      0)
call s:hl('LspHintText',             s:p.material.cyan,    s:p.none, s:p.none,      0)
call s:hl('LspErrorHighlight',       s:p.none,             s:p.none, s:p.underline, 0)
call s:hl('LspWarningHighlight',     s:p.none,             s:p.none, s:p.underline, 0)
call s:hl('LspInformationHighlight', s:p.none,             s:p.none, s:p.underline, 0)
call s:hl('LspHintHighlight',        s:p.none,             s:p.none, s:p.underline, 0)

call s:hl('DiagnosticError',         s:p.material.red,     s:p.none, s:p.none,      0)
call s:hl('DiagnosticWarn',          s:p.material.yellow,  s:p.none, s:p.none,      0)
call s:hl('DiagnosticInfo',          s:p.material.orange,  s:p.none, s:p.none,      0)
