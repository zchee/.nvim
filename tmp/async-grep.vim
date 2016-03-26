" Asynchronous grep plugin based on neovim's job control.
" Last Change:	2015/06/17
" Maintainer:	Alexandre Rames <alexandre.rames@gmail.com>
" License:	This file is placed in the public domain.

if exists("g:loaded_async_grep") || !has('nvim')
  finish
endif
let g:loaded_async_grep = 1


let s:job_cid = 0
" A map from `job_id` to `job_cid`.
let s:jobs = {}


" Handler to load the grep results into the quickfix list.
" TODO: Clean the script to avoid the duplication with `_L` and `_Q` suffixes.
function s:GrepJobHandler_Q(job_id, data, event)
  let job_cid = s:jobs[a:job_id]
  if a:event == 'exit'
    let temp_file = TempFile(job_cid)
    " Load the results in the quickfix list.
    execute 'cgetfile ' .  temp_file
    " Delete the temporary file.
    execute 'silent !rm ' . temp_file
    copen
  endif
endfunction

" Same as above, but in the location list.
function s:GrepJobHandler_L(job_id, data, event)
  let job_cid = s:jobs[a:job_id]
  if a:event == 'exit'
    let temp_file = TempFile(job_cid)
    " Load the results in the location-list.
    execute 'lgetfile ' .  temp_file
    " Delete the temporary file.
    execute 'silent !rm ' . temp_file
    lopen
  endif
endfunction


let s:callbacks_Q = {
\   'on_stdout': function('s:GrepJobHandler_Q'),
\   'on_stderr': function('s:GrepJobHandler_Q'),
\   'on_exit': function('s:GrepJobHandler_Q')
\ }

let s:callbacks_L = {
\   'on_stdout': function('s:GrepJobHandler_L'),
\   'on_stderr': function('s:GrepJobHandler_L'),
\   'on_exit': function('s:GrepJobHandler_L')
\ }


function! TempFile(job_cid)
  return '/tmp/neovim_async_grep.tmp.' . getpid() . '.' . a:job_cid
endfunction


function! StartGrepJob(loclist, ...)
  let s:job_cid = s:job_cid + 1

  let base_command = &grepprg . ' ' . join(a:000, ' ')
  let redirection = ' &> ' . TempFile(s:job_cid)
  let command = base_command . redirection

  if a:loclist == 1
    let grep_job = jobstart(command, s:callbacks_L)
  else
    let grep_job = jobstart(command, s:callbacks_Q)
  endif

  let s:jobs[grep_job] = s:job_cid
  echo 'Started: ' . base_command
endfunction

command! -nargs=* -complete=dir Grep call StartGrepJob(0, <f-args>)
command! -nargs=* -complete=dir GrepL call StartGrepJob(1, <f-args>)

" You can map this to a shortcuts. Here is a list of suggested shortcuts:
"   " Grep in current directory.
"   set grepprg=grep\ -RHIn\ --exclude=\".tags\"\ --exclude-dir=\".svn\"\ --exclude-dir=\".git\"
"   " Grep for the word under the cursor.
"   nnoremap K :Grep "\\<<C-r><C-w>\\>" .<CR>
"   nmap <leader>grep K
"   " Versions suffixed with `l` for the location list cause vim to wait for keys
"   " after `grep`. Provide versions with extra characters to allow skipping the
"   " wait.
"   nmap <leader>grepc K
"   nmap <leader>grep<Space> K
"   nmap <leader>grep<CR> K
"   " Grep in the current file's path.
"   nmap <leader>grepd :Grep "\\<<C-r><C-w>\\>" %:p:h<CR>
"   " Grep for the text selected. Do not look for word boundaries.
"   vnoremap K "zy:<C-u>Grep "<C-r>z" .<CR>
"   vmap <leader>grep K
"   vmap <leader>grepd :Grep "\\<<C-r><C-w>\\>" %:p:h<CR>
"
"   " Same as above, but for the location list.
"   nnoremap <F9> :GrepL "\\<<C-r><C-w>\\>" .<CR>
"   nmap <leader>grepl <F9>
"   nmap <leader>grepl<Space> <F9>
"   nmap <leader>grepl<CR> <F9>
"   nmap <leader>grepld :GrepL "\\<<C-r><C-w>\\>" %:p:h<CR>
"   vnoremap <F9> "zy:<C-u>GrepL "<C-r>z" .<CR>
"   vmap <leader>grepl <F9>
"   vmap <leader>grepld :GrepL "\\<<C-r><C-w>\\>" %:p:h<CR>
