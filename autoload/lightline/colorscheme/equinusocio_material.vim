if exists('g:lightline')
  let s:foreground         = '#eeffff'
  let s:background         = '#0a0a0a'  " '#212121'
  let s:cursor_guide       = '#171717'
  let s:gray               = '#545454'
  let s:black_dim          = '#2f2f2f'

  let s:black              = '#000000'
  let s:red                = '#ff5370'
  let s:green              = '#c3e88d'
  let s:yellow             = '#ffcb6b'
  let s:orange             = '#f78c6c'
  let s:blue               = '#82aaff'
  let s:magenta            = '#c792ea'
  let s:cyan               = '#89ddff'
  let s:white              = '#eeffff'

  let s:p = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {} }

  let s:p.normal.left     = [[ s:black, s:green ], [ s:foreground, s:gray ]]
  let s:p.normal.right    = [[ s:foreground, s:gray ], [ s:foreground, s:gray ]]
  let s:p.normal.middle   = [[ s:foreground, s:black_dim ]]
  let s:p.normal.error    = [[ s:foreground, s:red ]]
  let s:p.normal.warning  = [[ s:foreground, s:orange ]]

  let s:p.insert.left     = [[ s:black_dim, s:cyan, 'bold' ], [ s:foreground, s:gray ]]
  let s:p.insert.right    = [[ s:black_dim, s:cyan, 'bold' ], [ s:foreground, s:gray ]]

  let s:p.replace.left    = [[ s:black, s:red, 'bold' ], [ s:foreground, s:gray ]]
  let s:p.replace.right   = [[ s:black, s:red ], [ s:foreground, s:gray ]]

  let s:p.visual.left     = [[ s:black, s:yellow, 'bold' ], [ s:foreground, s:gray ]]
  let s:p.visual.right    = [[ s:black, s:yellow ], [ s:foreground, s:gray ]]

  let s:p.inactive.left   = [[ s:foreground, s:gray, 'bold' ], [ s:foreground, s:gray ]]
  let s:p.inactive.middle = [[ s:foreground, s:black_dim, 'bold' ]]
  let s:p.inactive.right  = [[ s:foreground, s:gray ], [ s:foreground, s:gray ]]

  let s:p.tabline.left    = [[ s:black_dim, s:green, 'bold' ]]
  let s:p.tabline.middle  = [[ s:gray, s:black_dim, 'bold' ]]
  let s:p.tabline.right   = [[ s:foreground, s:gray ]]
  let s:p.tabline.tabsel  = [[ s:black_dim, s:green, 'bold' ]]

  " ---

  " let s:p.normal.left     = [[ s:black, s:green ], [ s:foreground, s:gray ]]
  " let s:p.normal.right    = [[ s:foreground, s:gray ], [ s:foreground, s:gray ]]
  " let s:p.normal.middle   = [[ s:foreground, s:black_dim ]]
  " let s:p.normal.error    = [[ s:foreground, s:red ]]
  " let s:p.normal.warning  = [[ s:foreground, s:orange ]]
  "
  " let s:p.insert.left     = [[ s:black_dim, s:cyan, 'bold' ], [ s:foreground, s:gray ]]
  " let s:p.insert.right    = [[ s:black_dim, s:cyan, 'bold' ], [ s:foreground, s:gray ]]
  "
  " let s:p.replace.left    = [[ s:black, s:red, 'bold' ], [ s:foreground, s:gray ]]
  " let s:p.replace.right   = [[ s:black, s:red ], [ s:foreground, s:gray ]]
  "
  " let s:p.visual.left     = [[ s:black, s:yellow, 'bold' ], [ s:foreground, s:gray ]]
  " let s:p.visual.right    = [[ s:black, s:yellow ], [ s:foreground, s:gray ]]
  "
  " let s:p.inactive.left   = [[ s:foreground, s:gray, 'bold' ], [ s:foreground, s:gray ]]
  " let s:p.inactive.middle = [[ s:foreground, s:black_dim, 'bold' ]]
  " let s:p.inactive.right  = [[ s:foreground, s:gray ], [ s:foreground, s:gray ]]
  "
  " let s:p.tabline.left    = [[ s:black_dim, s:green, 'bold' ]]
  " let s:p.tabline.middle  = [[ s:gray, s:black_dim, 'bold' ]]
  " let s:p.tabline.right   = [[ s:foreground, s:gray ]]
  " let s:p.tabline.tabsel  = [[ s:black_dim, s:green, 'bold' ]]

  " ---

  " let s:p.normal.left     = [[ '#005f00', '#b5bd68', 'bold' ], [ '#c5c8c6', '#373b41' ]]
  " let s:p.normal.middle   = [[ '#c5c8c6', '#282a2e', 'bold' ]]
  " let s:p.normal.right    = [[ '#c5c8c6', '#282a2e' ]]
  " let s:p.normal.error    = [[ '#ff5370', '#005f00' ]]
  " let s:p.normal.warning  = [[ '#ffcb6b', '#005f00' ]]
  "
  " let s:p.insert.left     = [[ '#005f5f', '#8abeb7', 'bold' ], [ '#ffffff', '#0087af', 'bold' ]]
  " let s:p.insert.middle   = [[ '#ffffff', '#005f87', 'bold' ], [ '#c5c8c6', '#0087af', 'bold' ]]
  " let s:p.insert.right    = [[ '#005f5f', '#8abeb7' ],         [ '#ffffff', '#0087af', 'bold' ]]
  "
  " let s:p.replace.left    = [[ '#000000', '#cc6666', 'bold' ], [ '#c5c8c6', '#373b41' ]]
  " let s:p.replace.middle  = [[ '#c5c8c6', '#282a2e', 'bold' ]]
  " let s:p.replace.right   = [[ '#c5c8c6', '#282a2e' ]]
  "
  " let s:p.visual.left     = [[ '#000000', '#de935f', 'bold' ], [ '#c5c8c6', '#373b41' ]]
  " let s:p.visual.middle   = [[ '#c5c8c6', '#282a2e', 'bold' ]]
  " let s:p.visual.right    = [[ '#c5c8c6', '#282a2e' ]]
  "
  " let s:p.inactive.left   = [[ '#4e4e4e', '#1c1c1c', 'bold' ]]
  " let s:p.inactive.middle = [[ '#4e4e4e', '#262626', 'bold' ]]
  " let s:p.inactive.right  = [[ '#4e4e4e', '#303030' ]]
  "
  " let s:p.tabline.left    = [[ '#282a2e', '#b5bd68', 'bold' ]]
  " let s:p.tabline.middle  = [[ '#c5c8c6', '#282a2e', 'bold' ]]
  " let s:p.tabline.right   = [[ '#ffffff', '#282a2e' ]]
  " let s:p.tabline.tabsel  = [[ '#005f00', '#b5bd68', 'bold' ]]

  let g:lightline#colorscheme#equinusocio_material#palette = lightline#colorscheme#fill(s:p)
endif
