" for deoplete

" NeoBundle
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/vim-go
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/bundle/deoplete-go

" vim-plug
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/vim-go
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete.nvim
set runtimepath+=$XDG_CONFIG_HOME/nvim/plugged/deoplete-go
set completeopt+=noinsert,noselect
set completeopt-=preview

hi Pmenu    gui=NONE    guifg=#c5c8c6 guibg=#373b41
hi PmenuSel gui=reverse guifg=#c5c8c6 guibg=#373b41

let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 0
let g:deoplete#sources#go = 'vim-go'

filetype plugin indent on
