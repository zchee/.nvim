" Unite.vim
" let g:unite_data_directory = $HOME . '/.cache/unite/'
" let g:unite_split_rule = 'botright'
" if executable('pt')
"   let g:unite_source_grep_command = 'pt'
"   let g:unite_source_grep_default_opts = '--nogroup --nocolor --parallel'
"   let g:unite_source_grep_recursive_opt = ''
"   let g:unite_source_grep_encoding = 'utf-8'
" endif


" VimFiler
" close vimfiler automatically when there are only vimfiler open
" Gautocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
" let s:hooks = neobundle#get_hooks("vimfiler")
" function! s:hooks.on_source(bundle)
  " let g:vimfiler_as_default_explorer = 0
  " let g:vimfiler_enable_auto_cd = 1
  " First of . filename (dotfiles) and end of .file are ignore patterns.
  " let g:vimfiler_ignore_pattern = "\%(^\..*\|\.pyc$\)"
  " vimfiler specific key mappings
  " Gautocmdft vimfiler call s:vimfiler_settings()
  " function! s:vimfiler_settings()
  "   " ^^ to go up
  "   nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
  "   " use R to refresh
  "   nmap <buffer> R <Plug>(vimfiler_redraw_screen)
  "   " overwrite C-l
  "   nmap <buffer> <C-l> <C-w>l
  " endfunction
" endfunction

" Neomake
let g:neomake_open_list = 'quickfix'

" QuickRun
" Will rewrite port Neomake?
" https://github.com/rhysd/dotfiles/blob/master/nvimrc#L833-L888
" Init quickrun_config
let g:quickrun_config = get(g:, 'quickrun_config', {})
" Check file syntax
" https://github.com/rhysd/dotfiles/blob/master/vimrc#L2280-L2287
let g:quickrun_config._ = {
  \ 'outputter' : 'error:buffer:quickfix',
  \ 'split' : 'rightbelow 12sp',
  \ 'runner' : 'vimproc',
  \ 'runner/vimproc/updatetime' : '500'
  \ }
let g:quickrun_unite_quickfix_outputter_unite_context = { 'no_empty' : 1 }
Gautocmd BufReadPost,BufNewFile [Rr]akefile{,.rb} let b:quickrun_config = {'exec': 'rake -f %s'}
function! s:check_syntax(ft) abort
    let type = 'syntax/' . a:ft
    if has_key(g:quickrun_config[type], 'command') && !executable(g:quickrun_config[type].command)
        return
    endif
    execute 'QuickRun' '-type' type
endfunction

" Go
let g:quickrun_config['syntax/go'] = {
  \ 'command' : 'go',
  \ 'exec' : '%c vet %o %s:p',
  \ 'outputter' : 'quickfix',
  \ 'errorformat' : '%Evet: %.%\+: %f:%l:%c: %m,%W%f:%l: %m,%-G%.%#',
  \ }
let g:quickrun_config['lint/go'] = {
  \ 'command' : 'golint',
  \ 'exec' : '%c %o %s:p',
  \ 'outputter' : 'quickfix',
  \ }
" Gautocmd BufWritePost *.go call <SID>check_syntax('go')

" Dockerfile
let g:quickrun_config['syntax/Dockerfile'] = {
  \ 'command' : 'docker',
  \ 'cmdopt' : 'build -t',
  \ 'exec' : '%c %o %s %s:p',
  \ 'outputter' : 'quickfix',
  \ 'runner' : 'vimproc',
  \ 'errorformat' : '%E%r',
  \ }

" thinca/vim-ref
" let g:ref_open = 'call On_FileType_doc_define_mappings() botright 10split'
" let g:ref_cache_dir = $HOME . '/.cache/vim-ref'
" let g:red_use_vimproc = 1
" let g:ref_noenter = 1


" yankround
" let g:yankround_dir = $HOME . '/.cache/yankround'
" let g:yankround_max_history = 100


" tyru/open-browser.vim
let g:netrw_nogx = 1 
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
map  gz <Plug>(operator-open-plugpath)

call operator#user#define('open-plugpath', 'OpenPlugPath')
function! OpenPlugPath(motion_wise)
  if line("'[") != line("']")
    return
  endif
  let start = col("'[") - 1
  let end = col("']")
  let sel = strpart(getline('.'), start, end - start)
  let sel = substitute(sel, '^\%(github\|gh\|git@github\.com\):\(.\+\)', 'https://github.com/\1', '')
  let sel = substitute(sel, '^\%(bitbucket\|bb\):\(.\+\)', 'https://bitbucket.org/\1', '')
  let sel = substitute(sel, '^gist:\(.\+\)', 'https://gist.github.com/\1', '')
  let sel = substitute(sel, '^git://', 'https://', '')
  if sel =~ '^https\?://'
    call openbrowser#open(sel)
  elseif sel =~ '/'
    call openbrowser#open('https://github.com/'.sel)
  else
    call openbrowser#open('https://github.com/vim-scripts/'.sel)
  endif
endfunction

nmap <Leader>o <Plug>(openbrowser-smart-search)
xmap <Leader>o <Plug>(openbrowser-smart-search)
nnoremap <Leader>O :<C-u>OpenGithubFile<CR>
vnoremap <Leader>O :OpenGithubFile<CR>



" Unite history fuzzy search
" http://d.hatena.ne.jp/osyo-manga/20140721/1405937754
" let s:source = {
" \   "name" : "command/new",
" \}
"
" function! s:source.change_candidates(args, context)
"     let word = a:context.input
"     if word == ""
"         let word = "[new command]"
"     else
"         let word = ":" . word
"     endif
"     return [{
" \       "word" : word,
" \       "kind" : "command",
" \       "action__command" : word,
" \   }]
" endfunction
" call unite#define_source(s:source)
" unlet s:source
" command! UniteCommandLine :Unite command/new history/command -start-insert -hide-source-names
" Gautocmdft unite inoremap <C-c> <ESC>:UniteClose<CR>


" PyonPyon
let s:gravity = 2.4

function! s:start_pyonpyon()
  set guioptions-=m
  redraw!
  winpos 4000 4000 | winsize 80 24
  let [s:maxX, s:maxY] = [getwinposx(), getwinposy()]
  let [s:unit_h, s:unit_v] = [s:maxX / 133.0, sqrt(s:maxY * s:gravity * 2)]
  let [s:v, s:w] = [-s:unit_h, s:unit_v]
  let [s:x, s:y] = [s:maxX, 0]
  set updatetime=13
  augroup PyonPyon
    autocmd!
    autocmd CursorHold,CursorHoldI * call s:pyonpyon()
  augroup END
  command! PyonPyon call <SID>stop_pyonpyon()
endfunction

function! s:stop_pyonpyon()
  augroup PyonPyon
    autocmd!
  augroup END
  command! PyonPyon call <SID>start_pyonpyon()
endfunction

function! s:pyonpyon()
  let s:x += s:v
  if s:x < 0
    let [s:x, s:v] = [0, -s:v]
  elseif s:x > s:maxX
    let [s:x, s:v] = [s:maxX, -s:v]
  endif

  let s:y += s:w
  if s:y < 0
    let [s:y, s:w] = [0, s:unit_v]
  elseif s:y > s:maxY
    let s:y = s:maxY
  end

  let s:w -= s:gravity

  execute "winpos " . float2nr(s:x) . " " . float2nr(s:maxY - s:y)
  call feedkeys(mode() ==# "i" ? "\<C-g>\<ESC>" : "g\<ESC>", "n")
endfunction

command! PyonPyon call <SID>start_pyonpyon()

" ByonByon
let s:i = 0
let s:s = 10

function! s:byonbyon()
  let &columns = s:w + float2nr(cos(3.141592*(0.0 + s:i * s:s)/180.0) * 10)
  let &lines = s:h + float2nr(sin(3.141592*(0.0 + s:i * s:s)/180.0) * 5)
  let s:i += 1
  call feedkeys(mode() ==# "i" ? "\<C-g>\<ESC>" : "g\<ESC>", "n")
endfunction

function! s:stop_byonbyon()
  augroup ByonByon
    autocmd!
  augroup END
endfunction

function! s:start_byonbyon()
  let s:w = &columns
  let s:h = &lines
  set lazyredraw updatetime=10
  augroup ByonByon
    autocmd!
    autocmd CursorHold,CursorHoldI * call s:byonbyon()
  augroup END
  command! StopByonByon call <SID>stop_byonbyon()
endfunction

command! StartByonByon call <SID>start_byonbyon()

" vim: foldmethod=marker
