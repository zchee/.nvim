if exists('b.did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Adjusts the click position of the mouse on lines with concealed characters
function! s:cursor_adjust() abort
  if !&conceallevel
    return
  endif

  let l:cmax = col('$')
  let l:cpos = col('.')
  let l:level = &conceallevel
  let l:lnum = line('.')
  let l:lastid = 0
  let l:i = 0

  while l:i < l:cpos && l:cpos < l:cmax
    let l:i += 1
    let l:conceal = synconcealed(l:lnum, l:i)

    if l:conceal[0]
      let l:consecutive = l:conceal[2] == l:lastid
      if l:level == 1
        let l:cpos += !l:consecutive ? 0 : 1
      elseif l:level ==# 2
        let l:cpos += l:conceal[1] ==# '' ? 1 :
              \ !l:consecutive ? 0 : 1
      elseif l:level == 3
        let l:cpos += 1
      endif
    endif

    let l:lastid = l:conceal[2]
  endwhile

  if l:cpos != col('.')
    call cursor(l:lnum, l:cpos)
  endif
endfunction
nnoremap <silent> <LeftMouse> <LeftMouse>:<c-u>call <sid>cursor_adjust()<cr>

function! s:adjust_cursor(...) abort
  let l:pos = getpos('.')[1:2]
  if mode() ==? 'v' || !exists('b:prev_pos')
    let b:prev_pos = l:pos
    return
  endif

  let l:line = getline(l:pos[0])
  let l:b1 = line2byte(l:pos[0]) + l:pos[1]
  let l:b2 = line2byte(b:prev_pos[0]) + b:prev_pos[1]
  let b:prev_pos = getpos('.')[1:2]
  let l:delta = l:b1 - l:b2
  if l:b1 == l:b2
    return
  endif
  let l:conceal = synconcealed(l:pos[0], l:pos[1])

  if &conceallevel && l:conceal[0]
    if !a:0 && abs(l:delta) == 1
      if l:delta < 0
        normal! h
      elseif l:delta > 0
        normal! l
      endif
    else
      if l:b1 < l:b2
        let l:c = match(l:line, '\S\zs\s*\%'.l:pos[1].'c')
        if l:c != -1
          call cursor(l:pos[0], l:c)
        else
          normal! ge
        endif
      elseif l:b1 > l:b2
        let l:c = matchend(l:line, '\%>'.l:pos[1].'c\s*\S')
        if l:c != -1
          call cursor(l:pos[0], l:c)
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
  autocmd! BufEnter,CursorMoved <buffer> call s:adjust_cursor()
augroup END
