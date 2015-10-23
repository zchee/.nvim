" lightline
let g:lightline = { 'colorscheme': 'ux' }
let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }
let g:lightline.component = {
        \ 'readonly': '%{&readonly?"":""}',
        \ }
let g:lightline.active = {
        \ 'left':  [ [ 'mode', 'paste' ],
        \            [ 'filetype' ],
        \            [ 'readonly', 'absolutepath' ] ],
        \ 'right': [ [ 'lineinfo', 'percent' ],
        \            [ 'fileencoding' ] ]
        \ }
let g:lightline.inactive = {
        \ 'left':  [ [ 'filename' ] ],
        \ 'right': [ [ 'lineinfo', 'percent' ],
        \            [ 'fileencoding' ] ]
        \ }
let g:lightline.tabline = {
        \  'left':  [ [ 'tabs' ] ],
        \  'right': [ [ 'git_branch', 'git_traffic', 'git_status', 'cmd'] ]
        \ }
let g:lightline.tab = {
        \ 'active':   [ 'tabnum', 'filename', 'modified' ],
        \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
        \ }
let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.component_function = {
  \ 'git_branch':  'g:lightline.my.git_branch',
  \ 'git_traffic': 'g:lightline.my.git_traffic',
  \ 'git_status':  'g:lightline.my.git_status'
  \ }
let g:lightline.my = {}
function g:lightline.my.git_branch()
  return gita#statusline#preset('branch')
endfunction
function g:lightline.my.git_traffic()
  return gita#statusline#preset('traffic')
endfunction
function g:lightline.my.git_status()
  return gita#statusline#preset('status')
endfunction

