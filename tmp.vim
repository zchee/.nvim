" vim-textobj-user
NeoBundleLazy 'kana/vim-textobj-lastpat', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \          'mappings' : [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
       \        }
       \      }
NeoBundleLazy 'kana/vim-textobj-indent', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
       \        }
       \      }
NeoBundleLazy 'kana/vim-textobj-line', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'al'], ['xo', 'il']]
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-textobj-wiw', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'am'], ['xo', 'im']]
       \        }
       \      }
NeoBundleLazy 'sgur/vim-textobj-parameter', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'a,'], ['xo', 'i,']]
       \        }
       \      }
NeoBundleLazy 'thinca/vim-textobj-between', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'af'], ['xo', 'if'], ['xo', '<Plug>(textobj-between-']]
       \        }
       \      }
NeoBundleLazy 'thinca/vim-textobj-comment', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'ac'], ['xo', 'ic']]
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-textobj-word-column', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'av'], ['xo', 'aV'], ['xo', 'iv'], ['xo', 'iV']]
       \        }
       \      }
NeoBundleLazy 'kana/vim-textobj-entire', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'ae'], ['xo', 'ie']]
       \        }
       \      }
NeoBundleLazy 'kana/vim-textobj-fold', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'az'], ['xo', 'iz']]
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-textobj-anyblock', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'ab'], ['xo', 'ib']]
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-textobj-clang', {
       \        'depends' : 'kana/vim-textobj-user',
       \        'autoload' : {
       \              'mappings' : [['xo', 'a;'], ['xo', 'i;']]
       \        }
       \      }

" vim-operator
NeoBundleLazy 'rhysd/vim-operator-trailingspace-killer', {
       \        'autoload' : {
       \            'mappings' : '<Plug>(operator-trailingspace-killer)'
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-operator-filled-with-blank', {
       \        'autoload' : {
       \            'mappings' : '<Plug>(operator-filled-with-blank)'
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-operator-evalruby', {
       \        'autoload' : {
       \            'mappings' : '<Plug>(operator-evalruby)'
       \        }
       \      }
NeoBundleLazy 'rhysd/vim-operator-surround', {
       \        'depends' : 'tpope/vim-repeat',
       \        'autoload' : {
       \              'mappings' : '<Plug>(operator-surround-'
       \        }
       \      }
NeoBundleLazy 'deris/vim-operator-insert', {
       \        'autoload' : {
       \          'mappings' : [
       \              '<Plug>(operator-insert-i)',
       \              '<Plug>(operator-insert-a)',
       \   ],
       \        }
       \      }

" textobj-anyblock {{{
let g:textobj#anyblock#blocks = [ '(', '{', '[', '"', "'", '<', 'f`']
Gautocmdft help,markdown let b:textobj_anyblock_local_blocks = ['f*', 'f|']
"}}}

" vim-operator {{{
" operator-replace
map <Leader>r <Plug>(operator-replace)
" v_p を置き換える
vmap p <Plug>(operator-replace)
" operator-blank-killer
map <silent><Leader>k <Plug>(operator-trailingspace-killer)
" operator-filled-with-blank
map <silent><Leader>b <Plug>(operator-filled-with-blank)
" vim-operator-evalruby
if executable($HOME.'/.rbenv/shims/ruby')
    let g:operator_evalruby_command = $HOME . '/.rbenv/shims/ruby'
endif
map <silent><Leader>x <Plug>(operator-evalruby)
" vim-clang-format
let g:clang_format#style_options = {
            \ 'AllowShortIfStatementsOnASingleLine' : 'true',
            \ }
let g:clang_format#filetype_style_options = {
            \ 'javascript' : {},
            \ 'cpp' : {
            \     'AccessModifierOffset' : -4,
            \     'AlwaysBreakTemplateDeclarations' : 'true',
            \     'Standard' : 'C++11',
            \     'BreakBeforeBraces' : 'Stroustrup',
            \   }
            \ }
Gautocmdft c,cpp,javascript map <buffer><Leader>x <Plug>(operator-clang-format)
" vim-operator-surround {{{
let g:operator#surround#blocks =
            \ {
            \   '-' : [
            \       { 'block' : ['(', ')'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['p'] },
            \       { 'block' : ['[', ']'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['c'] },
            \       { 'block' : ['{', '}'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['b'] },
            \       { 'block' : ['<', '>'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['a'] },
            \       { 'block' : ['"', '"'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['q'] },
            \       { 'block' : ["'", "'"], 'motionwise' : ['char', 'line', 'block'], 'keys' : ["s"] },
            \   ]
            \ }
map <silent>gy <Plug>(operator-surround-append)
map <silent>gd <Plug>(operator-surround-delete)
map <silent>gc <Plug>(operator-surround-replace)
nmap <silent>gdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>gcc <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
nmap <silent>gdb <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
nmap <silent>gcb <Plug>(operator-surround-replace)<Plug>(textobj-between-a)
"}}}
" vim-operator-insert
map <silent><Leader>i <Plug>(operator-insert-i)
map <silent><Leader>a <Plug>(operator-insert-a)
"}}}
"

" haya14busa/incsearch
" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)


" mattn/ctrlp-ghq
" let g:ctrlp_ghq_actions = [
" \ {"label": "open", "action": "e", "path": 1},
" \ {"label": "look", "action": "!ghq look", "path": 0},
" \]
" let ctrlp_ghq_default_action = 'e'
" let g:ctrlp_ghq_cache_enabled = 1


" " tinca/quickrun
" " Will rewrite port Neomake?
" " https://github.com/rhysd/dotfiles/blob/master/nvimrc#L833-L888
" "
" " Init quickrun_config
" let g:quickrun_config = get(g:, 'quickrun_config', {})
" " Check file syntax
" " https://github.com/rhysd/dotfiles/blob/master/vimrc#L2280-L2287
"
" " Global config
" let g:quickrun_config._ = {
"   \ 'outputter' : 'error:buffer:quickfix',
"   \ 'split' : 'rightbelow 12sp',
"   \ }
" " outputter
" let g:quickrun_unite_quickfix_outputter_unite_context = { 'no_empty' : 1 }
" " Polling interval use runner vimproc
" let g:quickrun_config['_']['runner/vimproc/updatetime'] = 500
" Gautocmd BufReadPost,BufNewFile [Rr]akefile{,.rb} let b:quickrun_config = {'exec': 'rake -f %s'}
"
" " FileType config
" function! s:check_syntax(ft) abort
"     let type = 'syntax/' . a:ft
"     if has_key(g:quickrun_config[type], 'command') && !executable(g:quickrun_config[type].command)
"         return
"     endif
"     execute 'QuickRun' '-type' type
" endfunction
"
" " Go
" let g:quickrun_config['syntax/go'] = {
"   \ 'command' : 'go',
"   \ 'exec' : '%c vet %o %s:p',
"   \ 'outputter' : 'quickfix',
"   \ 'runner' : 'vimproc',
"   \ 'errorformat' : '%Evet: %.%\+: %f:%l:%c: %m,%W%f:%l: %m,%-G%.%#',
"   \ }
" let g:quickrun_config['lint/go'] = {
"   \ 'command' : 'golint',
"   \ 'exec' : '%c %o %s:p',
"   \ 'outputter' : 'quickfix',
"   \ 'runner' : 'vimproc',
"   \ }
" Gautocmd BufWritePost *.go call <SID>check_syntax('go')
"
" " Dockerfile
" " let g:quickrun_config['syntax/Dockerfile'] = {
" "   \ 'command' : 'docker',
" "   \ 'cmdopt' : 'build -t',
" "   \ 'exec' : '%c %o %s %s:p',
" "   \ 'outputter' : 'quickfix',
" "   \ 'runner' : 'vimproc',
" "   \ 'errorformat' : '%E%r',
" "   \ }
"
" " JavaScript
" function! s:check_js_syntax() abort
"   if &ft ==# 'javascript'
"       \ && has_key(g:quickrun_config['syntax/javascript'], 'command')
"       \ && executable(g:quickrun_config['syntax/javascript'].command)
"       \ && getline(1) !~? '^//\s\+jsx'
"       QuickRun -type syntax/javascript
"   endif
" endfunction
" let g:quickrun_config['syntax/javascript'] = {
"   \ 'command' : 'jshint',
"   \ 'outputter' : 'quickfix',
"   \ 'exec'    : '%c %o %s:p',
"   \ 'runner' : 'vimproc',
"   \ 'errorformat' : '%f: line %l\, col %c\, %m',
"   \ }
" Gautocmd BufWritePost *.js call <SID>check_js_syntax()
"
" " Ruby
" let g:quickrun_config['syntax/ruby'] = {
"   \ 'runner' : 'vimproc',
"   \ 'outputter' : 'quickfix',
"   \ 'command' : 'ruby',
"   \ 'exec' : '%c -c %s:p %o',
"   \ }
" Gautocmd BufWritePost *.rb call <SID>check_syntax('ruby')
"
" " Crystal
" let g:quickrun_config['syntax/crystal'] = {
"   \   'command' : 'crystal',
"   \   'cmdopt' : 'run --no-build --no-color',
"   \   'exec' : '%c %o %s:p',
"   \   'outputter' : 'quickfix',
"   \   'runner' : 'vimproc',
"   \ }
" Gautocmd BufWritePost *.cr call <SID>check_syntax('crystal')
"
" " Python
" let g:quickrun_config['syntax/python'] = {
"   \ 'command' : 'pyflakes',
"   \ 'exec' : '%c %o %s:p',
"   \ 'outputter' : 'quickfix',
"   \ 'runner' : 'vimproc',
"   \ 'errorformat' : '%f:%l:%m',
"   \ }
" Gautocmd BufWritePost *.py call <SID>check_syntax('python')
"
" " Rust
" let g:quickrun_config['syntax/rust'] = {
"   \   'command' : 'rustc',
"   \   'cmdopt' : '-Zparse-only',
"   \   'exec' : '%c %o %s:p',
"   \   'outputter' : 'quickfix',
"   \ }
" Gautocmd BufWritePost *.rs call <SID>check_syntax('rust')
"
" " tmux
" let g:quickrun_config['tmux'] = {
"   \ 'command' : 'tmux',
"   \ 'cmdopt' : 'source-file',
"   \ 'exec' : ['%c %o %s:p', 'echo "sourced %s"'],
"   \ }
"
" " Haml
" let g:quickrun_config['syntax/haml'] = {
"   \ 'runner' : 'vimproc',
"   \ 'command' : 'haml',
"   \ 'outputter' : 'quickfix',
"   \ 'exec'    : '%c -c %o %s:p',
"   \ 'errorformat' : 'Haml error on line %l: %m,Syntax error on line %l: %m,%-G%.%#',
"   \ }
" Gautocmd BufWritePost *.haml call <SID>check_syntax('haml')
"
" " C++
" let g:quickrun_config.cpp = {
"   \ 'command' : 'clang++',
"   \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
"   \ }
" let g:quickrun_config['cpp/llvm'] = {
"   \ 'type' : 'cpp/clang++',
"   \ 'exec' : '%c %o -emit-llvm -S %s -o -',
"   \ }
" let g:quickrun_config['c/llvm'] = {
"   \ 'type' : 'c/clang',
"   \ 'exec' : '%c %o -emit-llvm -S %s -o -',
"   \ }
" let g:quickrun_config['dachs'] = {
"   \ 'command' : './bin/dachs',
"   \ }
" let g:quickrun_config['dachs/llvm'] = {
"   \ 'type' : 'dachs',
"   \ 'cmdopt' : '--emit-llvm',
"   \ }
" let g:quickrun_config['llvm'] = {
"   \ 'exec' : 'llvm-as-3.4 %s:p -o=- | lli-3.4 - %a',
"   \ }
" " Only pre-process
" let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
" let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
" let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }
" let g:quickrun_config['cpp/clang'] = { 'command' : 'clang++', 'cmdopt' : '-stdlib=libc++ -std=c++11 -Wall -Wextra -O2' }
" Gautocmd FileType cpp nnoremap <silent><buffer><Leader>qc :<C-u>QuickRun -type cpp/clang<CR>
"
" " cpp/g++
" let g:quickrun_config['syntax/cpp/g++'] = {
"   \ 'runner' : 'vimproc',
"   \ 'outputter' : 'quickfix',
"   \ 'command' : 'g++',
"   \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
"   \ 'exec' : '%c %o -fsyntax-only %s:p'
"   \ }
"
" " llc
" if executable('llc-3.5')
"   let g:vimrc_llc_command = 'llc-3.5'
" elseif executable('llc')
"   let g:vimrc_llc_command = 'llc'
" endif
" if exists('g:vimrc_llc_command')
"   let g:quickrun_config['syntax/llvm'] = {
"     \ 'command' : g:vimrc_llc_command,
"     \ 'cmdopt' : '-filetype=null -o=/dev/null',
"     \ 'exec' : '%c %o %s:p',
"     \ 'outputter' : 'quickfix',
"     \ 'runner' : 'vimproc',
"     \ }
"   Gautocmd BufWritePost *.ll QuickRun -type syntax/llvm
" endif

" vital-exe-assert
" let g:__vital_exe_assert_config = { '__debug__': 1, '__abort__': 0 }
" let s:V = vital#of('vital')
" let g:assert = s:V.import('ExeAssert').make()

