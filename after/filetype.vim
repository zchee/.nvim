" ----------------------------------------------------------------------------
" after/filetype.vim
"  - http://vim.wikia.com/wiki/Filetype.vim#File_structure
"
" filetype.vim load order
" User Specific Primary Definitions:
"   $XDG_CONFIG_HOME/nvim/filetype.vim
" System Primary Definitions:
"   $VIM/vimfiles/filetype.vim
" NeoVim Default Ruleset:
"   $VIMRUNTIME/filetype.vim
" System Fallback Definitions:
"   $VIM/vimfiles/after/filetype.vim
" User Specific Fallback Definitions:
"   $XDG_CONFIG_HOME/nvim/after/filetype.vim
" ----------------------------------------------------------------------------

if exists('did_load_filetypes_userafter')
  finish
endif
let g:did_load_filetypes_userafter = 1

augroup filetypedetect
  " extension
  " autocmd! BufNewFile,BufRead *.S                                                  setlocal filetype=gas  syntax=gas
  autocmd! BufRead,BufNewFile *.\(swig\|swigcxx\)                                  setlocal filetype=swig  " TODO(zchee): 'cxx' prefix only
  autocmd! BufRead,BufNewFile *.actiongraph                                        setlocal filetype=json  " Go -debug-actiongraph
  autocmd! BufRead,BufNewFile *.apinotes                                           setlocal filetype=yaml
  autocmd! BufRead,BufNewFile *.asm                                                setlocal filetype=nasm syntax=nasm
  autocmd! BufRead,BufNewFile *.bzl,*.bazel,WORKSPACE,*.BUILD,BUILD	               setlocal filetype=starlark
  autocmd! BufRead,BufNewFile *.conf                                               setlocal filetype=conf
  autocmd! BufRead,BufNewFile *.defs                                               setlocal filetype=c
  autocmd! BufRead,BufNewFile *.dockerignore                                       setlocal filetype=gitignore
  autocmd! BufRead,BufNewFile *.editorconfig                                       setlocal filetype=dosini
  autocmd! BufRead,BufNewFile *.es6                                                setlocal filetype=javascript
  autocmd! BufRead,BufNewFile *.gcloudignore                                       setlocal filetype=gitignore
  autocmd! BufRead,BufNewFile *.go.tpl                                             setlocal filetype=gotexttmpl  " github.com/cloudspannerecosystem/yo
  autocmd! BufRead,BufNewFile *.go.y                                               setlocal filetype=goyacc
  autocmd! BufRead,BufNewFile *.hla                                                setlocal filetype=hla  syntax=header_standard_Vim_script_file_header
  autocmd! BufRead,BufNewFile *.i                                                  setlocal filetype=swig
  autocmd! BufRead,BufNewFile *.inc                                                setlocal filetype=masm syntax=masm
  autocmd! BufRead,BufNewFile *.jsonc                                              setlocal filetype=jsonc
  autocmd! BufRead,BufNewFile *.jsonschema                                         setlocal filetype=json
  autocmd! BufRead,BufNewFile *.mm                                                 setlocal filetype=objcpp
  autocmd! BufRead,BufNewFile *.pbtxt                                              setlocal filetype=proto
  autocmd! BufRead,BufNewFile *.py[xd]                                             setlocal filetype=python
  autocmd! BufRead,BufNewFile *.replay                                             setlocal filetype=json
  autocmd! BufRead,BufNewFile *.sb                                                 setlocal filetype=scheme
  autocmd! BufRead,BufNewFile *.schema.json                                        setlocal filetype=jsonschema
  autocmd! BufRead,BufNewFile *.slide                                              setlocal filetype=goslide
  autocmd! BufRead,BufNewFile *.tfstate                                            setlocal filetype=teraterm
  autocmd! BufRead,BufNewFile *.tmpl                                               setlocal filetype=gotexttmpl
  autocmd! BufRead,BufNewFile *.ts                                                 setlocal filetype=typescript
  autocmd! BufRead,BufNewFile *.vfj                                                setlocal filetype=jsonc
  autocmd! BufRead,BufNewFile *.vmoptions                                          setlocal filetype=conf
  autocmd! BufRead,BufNewFile /usr/local/lib/python[23]\.\d\+/site-packages/*.pth  setlocal filetype=python
  autocmd! BufRead,BufNewFile testdata/**/*.go.golden	                             setlocal filetype=go

  " directory
  autocmd! BufRead,BufNewFile $XDG_CACHE_HOME/go/go-build/**/*                     setlocal filetype=go
  autocmd! BufRead,BufNewFile $XDG_CONFIG_HOME/gcloud/configurations/*             setlocal filetype=cfg  " not dosini
  autocmd! BufRead,BufNewFile $XDG_CONFIG_HOME/jira.d/templates/*                  setlocal filetype=gotexttmpl
  autocmd! BufRead,BufNewFile $XDG_CONFIG_HOME/zsh/**/*                            setlocal filetype=zsh
  autocmd! BufRead,BufNewFile **/c++/**/*                                          setlocal filetype=cpp  " cpp stdlib
  autocmd! BufRead,BufNewFile **/makedefs/**                                       setlocal filetype=make  " for XNU
  autocmd! BufRead,BufNewFile /private/etc/sudoers.d/*                             setlocal filetype=sudoers

  " filename
  autocmd! BufRead,BufNewFile $XDG_CONFIG_HOME/direnv/direnvrc                     setlocal filetype=sh
  autocmd! BufRead,BufNewFile $XDG_CONFIG_HOME/go/env                              setlocal filetype=sh
  autocmd! BufRead,BufNewFile **/*hal/config                                       setlocal filetype=yaml
  autocmd! BufRead,BufNewFile **/*kube/config                                      setlocal filetype=yaml
  autocmd! BufRead,BufNewFile **/google-cloud-sdk/properties                       setlocal filetype=cfg
  autocmd! BufRead,BufNewFile *.gunk                                               setlocal filetype=gunk.go
  autocmd! BufRead,BufNewFile *[Dd]ockerfile\(\.|-\).*\(.vim\)\@!*                 setlocal filetype=dockerfile
  autocmd! BufRead,BufNewFile .bash_profile,bash_profile                           setlocal filetype=sh
  autocmd! BufRead,BufNewFile .bazelrc                                             setlocal filetype=bazel
  autocmd! BufRead,BufNewFile .clang-format                                        setlocal filetype=yaml
  autocmd! BufRead,BufNewFile .envrc                                               setlocal filetype=sh
  autocmd! BufRead,BufNewFile .firebaserc                                          setlocal filetype=json
  autocmd! BufRead,BufNewFile .gunkconfig                                          setlocal filetype=cfg
  autocmd! BufRead,BufNewFile .markdownlintrc                                      setlocal filetype=json
  autocmd! BufRead,BufNewFile .pythonrc                                            setlocal filetype=python
  autocmd! BufRead,BufNewFile .renovaterc.json,renovate.json[5],.renovaterc        setlocal filetype=json5
  autocmd! BufRead,BufNewFile .tern-config                                         setlocal filetype=json
  autocmd! BufRead,BufNewFile .yamllint                                            setlocal filetype=yaml
  autocmd! BufRead,BufNewFile [Dd]ockerfile                                        setlocal filetype=dockerfile
  autocmd! BufRead,BufNewFile boto,.boto                                           setlocal filetype=cfg
  autocmd! BufRead,BufNewFile gdbinit                                              setlocal filetype=gdb
  autocmd! BufRead,BufNewFile glide.lock                                           setlocal filetype=yaml
  autocmd! BufRead,BufNewFile Gopkg.lock                                           setlocal filetype=toml
  autocmd! BufRead,BufNewFile lsif.json                                            setlocal filetype=json5
  autocmd! BufRead,BufNewFile manifest                                             setlocal filetype=json
  autocmd! BufRead,BufNewFile osquery.conf                                         setlocal filetype=json
  autocmd! BufRead,BufNewFile poetry.lock                                          setlocal filetype=toml
  autocmd! BufRead,BufNewFile proto.lock                                           setlocal filetype=json
  autocmd! BufRead,BufNewFile tmux.conf                                            setlocal filetype=tmux
augroup END

  " autocmd! BufRead,BufNewFile s:srcpath.'/github.com/envoyproxy/envoy/**/*.h'   setlocal filetype=cpp
  " autocmd! BufRead,BufNewFile **/startup-log.txt                                setlocal foldlevel=1
  " autocmd! BufRead,BufNewFile *[Dd]oxyfile\(.vim\)\@!*                          setlocal filetype=doxyfile
  " autocmd! BufRead,BufNewFile *[Dd]ockerfile\(\.|-\).*                          setlocal filetype=dockerfile
  " autocmd! BufRead,BufNewFile *[Dd]oxyfile\(\.|-\).*\(.vim\)\@!*                setlocal filetype=doxyfile
  " autocmd! BufRead,BufNewFile *[Dd]ockerfile setlocal filetype=dockerfile
  " autocmd! BufRead,BufNewFile [Dd]ockerfile,.*\=[Dd]ockerfile\(\.|-\).*\(.vim\)\@!* setlocal filetype=dockerfile
  " autocmd! BufRead,BufNewFile *[Dd]ockerfile\(.vim\|*.yaml\)\@!.*,[Dd]ockerfile,*.[Dd]ockerfile setlocal filetype=dockerfile
