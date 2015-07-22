" =============================================================================
" Filename: lightline/colorscheme/ux.vim
" Author:   zchee
" License:  MIT License
" =============================================================================

let s:fg       = [ '#ECFBFF',  15 ]
let s:bg       = [ '#151718',   0 ]

let s:color232 = [ '#080808', 232 ]
let s:color233 = [ '#121212', 233 ]
let s:color234 = [ '#1C1C1C', 234 ]
let s:color235 = [ '#262626', 235 ]
let s:color236 = [ '#303030', 236 ]
let s:color237 = [ '#3A3A3A', 237 ]
let s:color238 = [ '#444444', 238 ]
let s:color239 = [ '#4E4E4E', 239 ]
let s:color240 = [ '#585858', 240 ]
let s:color241 = [ '#606060', 241 ]
let s:color242 = [ '#666666', 242 ]
let s:color243 = [ '#767676', 243 ]
let s:color244 = [ '#808080', 244 ]
let s:color245 = [ '#8A8A8A', 245 ]
let s:color246 = [ '#949494', 246 ]
let s:color247 = [ '#9E9E9E', 247 ]
let s:color248 = [ '#A8A8A8', 248 ]
let s:color249 = [ '#B2B2B2', 249 ]
let s:color250 = [ '#BCBCBC', 250 ]
let s:color251 = [ '#C6C6C6', 251 ]
let s:color252 = [ '#D0D0D0', 252 ]
let s:color253 = [ '#DADADA', 253 ]
let s:color254 = [ '#E4E4E4', 254 ]
let s:color255 = [ '#EEEEEE', 255 ]

let s:white    = [ '#ECFBFF',  15 ]
let s:black    = [ '#151718',   0 ]
let s:gray     = [ '#2C2F30', 235 ]
let s:yellow   = [ '#FFD200',  11 ]
let s:orange   = [ '#FF6F5B',   9 ]
let s:red      = [ '#CD3F45',   1 ]
let s:magenta  = [ '#A074C4',  13 ]
let s:blue     = [ '#02AEFF',   4 ]
let s:cyan     = [ '#80FCFF',   6 ]
let s:green    = [ '#1CFF7B',  10 ]

let s:tabline_tabsel_bg = [ '#151718', 238 ]
let s:tabline_tabsel_fg = [ '#d5d5d5', 252 ]
let s:tabline_left      = [ '#445366', 235 ]
let s:tabline_right     = [ '#445366', 235 ]
let s:tabline_middle    = [ '#252d37', 235 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left     = [ [ s:color236, s:blue ],     [ s:color248, s:color240 ], [ s:color250, s:color236 ] ]
let s:p.normal.right    = [ [ s:color248, s:color240 ], [ s:color250, s:color236 ] ]
let s:p.normal.middle   = [ [ s:color255, s:color234 ] ]
let s:p.normal.error    = [ [ s:color252, s:red ] ]
let s:p.normal.warning  = [ [ s:color236, s:yellow ] ]

let s:p.inactive.right  = [ [ s:color238, s:color240 ], [ s:color242, s:color238 ] ]
let s:p.inactive.left   = [ [ s:color248, s:color244 ], [ s:color242, s:color237 ] ]
let s:p.inactive.middle = [ [ s:color248, s:color236 ] ]

let s:p.insert.left     = [ [ s:color236, s:cyan ], [ s:color252, s:color240 ] ]

let s:p.visual.left     = [ [ s:color236, s:magenta ], [ s:color252, s:color240 ] ]

let s:p.replace.left    = [ [ s:color236, s:red ], [ s:color252, s:color240 ] ]

let s:p.tabline.tabsel  = [ [ s:tabline_tabsel_fg, s:tabline_tabsel_bg ] ]
let s:p.tabline.left    = [ [ s:color248, s:tabline_left   ] ]
let s:p.tabline.right   = [ [ s:color248, s:tabline_right  ] ]
let s:p.tabline.middle  = [ [ s:color238, s:tabline_middle ] ]

let g:lightline#colorscheme#ux#palette = lightline#colorscheme#flatten(s:p)
