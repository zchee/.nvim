" let s:paren_hl_on = 0
" function! s:Highlight_Matching_Paren()
"   if s:paren_hl_on
"     match none
"     let s:paren_hl_on = 0
"   endif
"
"   let c_lnum = line('.')
"   let c_col = col('.')
"
"   let c = getline(c_lnum)[c_col - 1]
"   let plist = split(&matchpairs, ':\|,')
"   let i = index(plist, c)
"   if i < 0
"     return
"   endif
"   if i % 2 == 0
"     let s_flags = 'nW'
"     let c2 = plist[i + 1]
"   else
"     let s_flags = 'nbW'
"     let c2 = c
"     let c = plist[i - 1]
"   endif
"   if c == '['
"     let c = '\['
"     let c2 = '\]'
"   endif
"   let s_skip ='synIDattr(synID(line("."), col("."), 0), "name") ' .
"   \ '=~?	"string\\|comment"'
"   execute 'if' s_skip '| let s_skip = 0 | endif'
"
"   let [m_lnum, m_col] = searchpairpos(c, '', c2, s_flags, s_skip)
"
"   if m_lnum > 0 && m_lnum >= line('w0') && m_lnum <= line('w$')
"     exe 'match Search /\(\%' . c_lnum . 'l\%' . c_col .
"     \ 'c\)\|\(\%' . m_lnum . 'l\%' . m_col . 'c\)/'
"     let s:paren_hl_on = 1
"   endif
" endfunction
"
" autocmd! CursorMoved,CursorMovedI * call s:Highlight_Matching_Paren()
" autocmd! InsertEnter * match none
