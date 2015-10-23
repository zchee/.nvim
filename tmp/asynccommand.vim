" AsyncMake
let s:job_cid = 0
" A map from `job_id` to `job_cid`.
let s:jobs = {}
function s:MakeJobHandler(job_id, data, event)
  let job_cid = s:jobs[a:job_id]
  if a:event == 'exit'
    let temp_file = TempFile(job_cid)
    " Load the results in the location-list
    execute 'silent caddfile ' .  temp_file
    " Delete the temporary file.
    execute 'silent !rm ' . temp_file
    cwindow
    " lopen
    execute 'call feedkeys("\<C-w>p")'
  endif
endfunction
let s:callbacks = {
\   'on_stderr': function('s:MakeJobHandler'),
\   'on_exit': function('s:MakeJobHandler')
\ }
"   'on_stdout': function('s:MakeJobHandler'),
function! TempFile(job_cid)
  return '/tmp/neovim_async_make.tmp.' . getpid() . '.' . a:job_cid
endfunction
if !exists("g:make_jump_to_error")
    let g:go_jump_to_error = 0
endif
function! StartMakeJob(...)
  let s:job_cid = s:job_cid + 1

  let base_command = 'make'
  let redirection = ' &> ' . TempFile(s:job_cid)
  let command = base_command . redirection

  let make_job = jobstart(command, s:callbacks)

  let s:jobs[make_job] = s:job_cid
  echo 'Started: ' . base_command
endfunction

" You can map this to a shortcut. For example to grep for the word under the cursor:
" nnoremap <F8> :Grep "<C-r><C-w> .<CR>
command! -nargs=* -bang -complete=command AsyncMake call StartMakeJob(<f-args>)
