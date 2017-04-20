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

if exists('did_load_filetypes_userafter')
  finish
endif
let g:did_load_filetypes_userafter = 1

augroup filetypedetect
  autocmd! BufNewFile,BufRead *.asm                      setlocal filetype=masm syntax=masm
  autocmd! BufNewFile,BufRead *.conf                     setlocal filetype=conf
  autocmd! BufNewFile,BufRead *.es6                      setlocal filetype=javascript
  autocmd! BufNewFile,BufRead *.hla                      setlocal filetype=hla  syntax=header_standard_Vim_script_file_header
  autocmd! BufNewFile,BufRead *.i                        setlocal filetype=swig
  autocmd! BufNewFile,BufRead *.inc                      setlocal filetype=masm syntax=masm
  autocmd! BufNewFile,BufRead *.mm                       setlocal filetype=objcpp
  autocmd! BufNewFile,BufRead *.pbtxt                    setlocal filetype=proto
  autocmd! BufNewFile,BufRead *.sb                       setlocal filetype=scheme
  autocmd! BufNewFile,BufRead *.py[xd]                   setlocal filetype=cython
  autocmd! BufNewFile,BufRead *.pythonrc                 setlocal filetype=python
  autocmd! BufNewFile,BufRead *.slide                    setlocal filetype=goslide
  autocmd! BufNewFile,BufRead *.[sS]                     setlocal filetype=gas  syntax=ia64
  autocmd! BufNewFile,BufRead *.swig                     setlocal filetype=swig
  autocmd! BufNewFile,BufRead *.swigcxx                  setlocal filetype=swig
  autocmd! BufNewFile,BufRead *[Dd]ockerfile\(.vim\)\@!* setlocal filetype=dockerfile
  autocmd! BufNewFile,BufRead *[Dd]oxyfile\(.vim\)\@!*   setlocal filetype=doxyfile
  autocmd! BufNewFile,BufRead **/c++/**/*                setlocal filetype=cpp
  autocmd! BufNewFile,BufRead **/zsh/**/*                setlocal filetype=zsh
  autocmd! BufNewFile,BufRead .clang-format              setlocal filetype=yaml
  autocmd! BufNewFile,BufRead .tern-config               setlocal filetype=json
augroup END
