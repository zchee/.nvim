" based by https://github.com/zchee/vim-equinusocio-material

highlight clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'equinusocio_material'
set background=dark

" ------------------------------------------------------------------------------
" Palettes:

let s:p = {}

let s:p.none                  = 'NONE'
let s:p.bold                  = 'bold'
let s:p.underline             = 'underline'
let s:p.undercurl             = 'undercurl'
let s:p.strikethrough         = 'strikethrough'
let s:p.inverse               = 'inverse'
let s:p.italic                = 'italic'
let s:p.standout              = 'standout'
let s:p.nocombine             = 'nocombine'

let s:p.material = {}

let s:p.material.foreground   = '#c7c8c8'  " '#eeffff'
let s:p.material.background   = '#0a0a0a'  " '#212121'
let s:p.material.comment      = '#838c93'  " '#79828a', '#6c7a80', '#838c93', '#878f96'
let s:p.material.nontext      = '#202122'
let s:p.material.longlinewarn = '#371f1c'
let s:p.material.black        = '#000000'
let s:p.material.red          = '#ff5370'
let s:p.material.green        = '#bae57d'
let s:p.material.yellow       = '#ffcb6b'
let s:p.material.orange       = '#f78c6c'
let s:p.material.aqua         = '#8abeb7'  " #a1cbc5
let s:p.material.blue         = '#82aaff'
let s:p.material.darkblue     = '#81a2be'
let s:p.material.magenta      = '#c792ea'
let s:p.material.cyan         = '#75d7ff'  " '#89ddff'
let s:p.material.white        = '#eeffff'
let s:p.material.caret        = '#ffcc00'
let s:p.material.pure_black   = '#000000'
let s:p.material.cursor_guide = '#343941'  " '#425059'
let s:p.material.selection    = '#343941'  " '#371f1c'
let s:p.material.indent_line  = '#282a2e'  " '#2d3c46'
let s:p.material.darkcolumn   = '#1c1c1c'
let s:p.material.darkpmenu    = '#292d34'
let s:p.material.gray         = '#545454'
let s:p.material.linenr       = '#8b9ead'  " '#757575'

function! s:hl(group, fg, bg, attr, blend)
  let l:hi_group = 'highlight! ' . a:group
  let l:hi_group = l:hi_group . ' ctermfg=NONE ctermbg=NONE cterm=NONE'
  
  let l:fg = ' guifg=NONE'
  if !empty(a:fg)
    let l:fg = ' guifg=' . a:fg
  endif

  let l:bg = ' guibg=NONE'
  if !empty(a:bg)
    let l:bg = ' guibg=' . a:bg
  endif

  let l:gui   = ' gui=NONE'
  if !empty(a:attr)
    let l:gui = l:gui . ',' . a:attr
  endif

  let l:blend = ' blend=0'
  if !empty(a:blend)
    let l:blend = ' blend=' . a:blend
  endif

  execute l:hi_group.l:fg.l:bg.l:gui.l:blend
endfunction

" ------------------------------------------------------------------------------
" :help group-name

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
call s:hl('NonText',            s:p.material.indent_line,  s:p.none, s:p.none, 0)
call s:hl('Normal',             s:p.material.foreground,   s:p.material.background, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Pmenu',              s:p.material.foreground,   s:p.material.nontext, s:p.bold, 0)
call s:hl('PmenuSel',           s:p.material.cyan,         s:p.material.black, s:p.none, 0)
call s:hl('PmenuSbar',          s:p.material.foreground,   s:p.material.gray, s:p.none, 0)
call s:hl('PmenuThumb',         s:p.material.foreground,   s:p.material.foreground, s:p.none, 0)

" ------------------------------------------------------------------------------

call s:hl('Question',           s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('QuickFixLine',       s:p.material.foreground,   s:p.material.background, s:p.none, 0)
call s:hl('Search',             s:p.none,                  s:p.material.selection, s:p.none, 0)
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
" ale

call s:hl('ALEError',           s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('ALEWarning',         s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('ALEInfo',            s:p.none,                  s:p.none, s:p.underline, 0)
call s:hl('ALEErrorSign',       s:p.material.red,          s:p.none, s:p.none, 0)
call s:hl('ALEWarningSign',     s:p.material.yellow,       s:p.none, s:p.none, 0)
call s:hl('ALEInfoSign',        s:p.material.cyan,         s:p.none, s:p.none, 0)

" ------------------------------------------------------------------------------
" echodoc

call s:hl('EchoDocFloat',       s:p.material.foreground,   s:p.material.black, s:p.none, 0)
call s:hl('EchoDocPopup',       s:p.material.foreground,   s:p.material.black, s:p.none, 0)

" ------------------------------------------------------------------------------
" vim-lsp

call s:hl('LspErrorText',            s:p.material.red,     s:p.none, s:p.none,      0)
call s:hl('LspWarningText',          s:p.material.yellow,  s:p.none, s:p.none,      0)
call s:hl('LspInformationText',      s:p.material.orange,  s:p.none, s:p.none,      0)
call s:hl('LspHintText',             s:p.material.cyan,    s:p.none, s:p.none,      0)
call s:hl('LspErrorHighlight',       s:p.none,             s:p.none, s:p.underline, 0)
call s:hl('LspWarningHighlight',     s:p.none,             s:p.none, s:p.underline, 0)
call s:hl('LspInformationHighlight', s:p.none,             s:p.none, s:p.underline, 0)
call s:hl('LspHintHighlight',        s:p.none,             s:p.none, s:p.underline, 0)
