" http://vim.wikia.com/wiki/Filetype.vim#File_structure
" available '_userafter' and '_systemafter'
"
" filetype.vim load order
" -----------------------
"
" User Specific Primary Definitions:
"  $XDG_CONFIG_HOME/nvim/filetype.vim
" System Primary Definitions:
"  $VIM/vimfiles/filetype.vim
" NeoVim Default Ruleset:
"  $VIMRUNTIME/filetype.vim
" System Fallback Definitions:
"  $VIM/vimfiles/after/filetype.vim
" User Specific Fallback Definitions:
"  $XDG_CONFIG_HOME/nvim/after/filetype.vim
"

if exists('did_load_filetypes_userafter')
  finish
endif
let g:did_load_filetypes_userafter = 1

augroup filetypedetect
  autocmd! BufNewFile,BufRead,BufWinEnter *.asm           setlocal filetype=masm syntax=masm
  autocmd! BufNewFile,BufRead,BufWinEnter *.es6           setlocal filetype=javascript
  autocmd! BufNewFile,BufRead,BufWinEnter *.[sS]          setlocal filetype=gas  syntax=ia64
  autocmd! BufNewFile,BufRead,BufWinEnter *.hla           setlocal filetype=hla  syntax=header_standard_Vim_script_file_header
  autocmd! BufNewFile,BufRead,BufWinEnter *.i             setlocal filetype=swig
  autocmd! BufNewFile,BufRead,BufWinEnter *.inc           setlocal filetype=masm syntax=masm
  autocmd! BufNewFile,BufRead,BufWinEnter *.mm            setlocal filetype=objcpp
  autocmd! BufNewFile,BufRead,BufWinEnter *.pryrc         setlocal filetype=ruby
  autocmd! BufNewFile,BufRead,BufWinEnter *.py[xd         setlocal filetype=cython
  autocmd! BufNewFile,BufRead,BufWinEnter *.pythonrc      setlocal filetype=python
  autocmd! BufNewFile,BufRead,BufWinEnter *.slide         setlocal filetype=slide
  autocmd! BufNewFile,BufRead,BufWinEnter *.swig          setlocal filetype=swig

  autocmd! BufNewFile,BufRead,BufWinEnter *[Dd]ockerfile* setlocal filetype=dockerfile
  autocmd! BufNewFile,BufRead,BufWinEnter *[Dd]oxyfile*   setlocal filetype=doxyfile

  autocmd! BufNewFile,BufRead,BufWinEnter $HOME/src/github.com/zchee/dotfiles/.zsh/**/*.zsh setlocal filetype=zsh
augroup END
