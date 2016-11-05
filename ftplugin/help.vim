" Adjusts the click position of the mouse on lines with concealed characters
function! s:cursor_adjust() abort
  if !&conceallevel
    return
  endif

  let cmax = col('$')
  let cpos = col('.')
  let level = &conceallevel
  let lnum = line('.')
  let lastid = 0
  let i = 0

  while i < cpos && cpos < cmax
    let i += 1
    let conceal = synconcealed(lnum, i)

    if conceal[0]
      let consecutive = conceal[2] == lastid
      if level == 1
        let cpos += !consecutive ? 0 : 1
      elseif level == 2
        let cpos += conceal[1] == '' ? 1 :
              \ !consecutive ? 0 : 1
      elseif level == 3
        let cpos += 1
      endif
    endif

    let lastid = conceal[2]
  endwhile

  if cpos != col('.')
    call cursor(lnum, cpos)
  endif
endfunction
nnoremap <silent> <LeftMouse> <LeftMouse>:<c-u>call <sid>cursor_adjust()<cr> 

function! s:adjust_cursor(...) abort
  let pos = getpos('.')[1:2]
  if mode() ==? 'v' || !exists('b:prev_pos')
    let b:prev_pos = pos
    return
  endif

  let line = getline(pos[0])
  let b1 = line2byte(pos[0]) + pos[1]
  let b2 = line2byte(b:prev_pos[0]) + b:prev_pos[1]
  let b:prev_pos = getpos('.')[1:2]
  let delta = b1 - b2
  if b1 == b2
    return
  endif
  let conceal = synconcealed(pos[0], pos[1])

  if &conceallevel && conceal[0]
    if !a:0 && abs(delta) == 1
      if delta < 0
        normal! h
      elseif delta > 0
        normal! l
      endif
    else
      if b1 < b2
        let c = match(line, '\S\zs\s*\%'.pos[1].'c')
        if c != -1
          call cursor(pos[0], c)
        else
          normal! ge
        endif
      elseif b1 > b2
        let c = matchend(line, '\%>'.pos[1].'c\s*\S')
        if c != -1
          call cursor(pos[0], c)
        else
          normal! w
        endif
      endif
      call s:adjust_cursor(1)
    endif
  endif
endfunction


augroup vimrc_help
  autocmd! * <buffer>
  autocmd BufEnter,CursorMoved <buffer> call s:adjust_cursor()
augroup END
