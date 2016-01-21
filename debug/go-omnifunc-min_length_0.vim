" for deoplete
" NeoBundle
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/vim-go

" vim-plug
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/vim-go

set completeopt+=noinsert,noselect
set completeopt-=preview

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

" omnifunc
set omnifunc=go#complete#Complete

autocmd InsertEnter * call feedkeys("\<C-x>\<C-o>")
autocmd InsertCharPre * if v:char == '.' | call feedkeys("\<C-x>\<C-o>") | endif

filetype plugin indent on
