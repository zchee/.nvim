syn match pythonOperator "\(+\|=\|-\|\^\|\*\)"
syn match pythonDelimiter "\(,\|\.\|:\)"
syn keyword pythonSelf self

hi pythonSelf gui=None guifg=#8abeb7 guibg=None
hi link pythonDelimiter      Special
