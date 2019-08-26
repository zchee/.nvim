" =============================================================================
" Filename: autoload/lightline/colorscheme/hybrid.vim
" Author: zchee
" License: MIT License
" =============================================================================

let s:p = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {} }
let s:p.normal.left     = [ [ '#005f00', '#b5bd68', 'bold' ], [ '#c5c8c6', '#373b41' ] ]
let s:p.normal.middle   = [ [ '#c5c8c6', '#282a2e' ] ]
let s:p.normal.right    = [ [ '#282a2e', '#ffffff', 'bold' ] ]
let s:p.normal.error    = [ [ '#ff5370', '#005f00' ] ]
let s:p.normal.warning  = [ [ '#ffcb6b', '#005f00' ] ]
let s:p.insert.left     = [ [ '#005f5f', '#8abeb7', 'bold' ], [ '#ffffff', '#0087af', 'bold' ] ]
let s:p.insert.middle   = [ [ '#ffffff', '#005f87' ],         [ '#c5c8c6', '#0087af', 'bold' ] ]
let s:p.insert.right    = [ [ '#005f5f', '#8abeb7', 'bold' ], [ '#ffffff', '#0087af', 'bold' ] ]
let s:p.inactive.left   = [ [ '#4e4e4e', '#1c1c1c', 'bold' ] ]
let s:p.inactive.middle = [ [ '#4e4e4e', '#262626' ] ]
let s:p.inactive.right  = [ [ '#4e4e4e', '#303030', 'bold' ] ]
let s:p.replace.left    = [ [ '#000000', '#cc6666', 'bold' ], [ '#c5c8c6', '#373b41' ] ]
let s:p.replace.middle  = [ [ '#c5c8c6', '#282a2e' ] ]
let s:p.replace.right   = [ [ '#282a2e', '#ffffff', 'bold' ] ]
let s:p.visual.left     = [ [ '#000000', '#de935f', 'bold' ], [ '#c5c8c6', '#373b41' ] ]
let s:p.visual.middle   = [ [ '#c5c8c6', '#282a2e' ] ]
let s:p.visual.right    = [ [ '#282a2e', '#ffffff', 'bold' ] ]
let s:p.tabline.left    = [ [ '#282a2e', '#b5bd68', 'bold' ] ]
let s:p.tabline.tabsel  = [ [ '#005f00', '#b5bd68', 'bold' ] ]
let s:p.tabline.middle  = [ [ '#c5c8c6', '#282a2e' ] ]
let s:p.tabline.right   = [ [ '#ffffff', '#282a2e', 'bold' ] ]

let g:lightline#colorscheme#hybrid#palette = lightline#colorscheme#fill(s:p)
