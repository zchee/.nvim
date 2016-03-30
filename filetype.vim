" Vim support file to detect file types
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2015 Apr 06

" Listen very carefully, I will say this only once
if exists("did_load_self_filetypes")
  finish
endif
let did_load_self_filetypes = 1

" Line continuation is used here, remove 'C' from 'cpoptions'
let s:cpo_save = &cpo
set cpo&vim

augroup filetypedetect

" Function used for patterns that end in a star: don't set the filetype if the
" file name matches ft_ignore_pat.
func! s:StarSetf(ft)
  if expand("<amatch>") !~ g:ft_ignore_pat
    exe 'setf ' . a:ft
  endif
endfunc

" ASN.1
au BufNewFile,BufRead *.asn,*.asn1		setf asn

" Assembly (all kinds)
" *.lst is not pure assembly, it has two extra columns (address, byte codes)
au BufNewFile,BufRead *.asm,*.[sS],*.[aA],*.mac,*.lst	call s:FTasm()

" Automake
au BufNewFile,BufRead [mM]akefile.am,GNUmakefile.am	setf automake

" C or lpc
au BufNewFile,BufRead *.c			call s:FTlpc()

func! s:FTlpc()
  if exists("g:lpc_syntax_for_c")
    let lnum = 1
    while lnum <= 12
      if getline(lnum) =~# '^\(//\|inherit\|private\|protected\|nosave\|string\|object\|mapping\|mixed\)'
	setf lpc
	return
      endif
      let lnum = lnum + 1
    endwhile
  endif
  setf c
endfunc

" C++
au BufNewFile,BufRead *.cxx,*.c++,*.hh,*.hxx,*.hpp,*.ipp,*.moc,*.tcc,*.inl setf cpp
if has("fname_case")
  au BufNewFile,BufRead *.C,*.H setf cpp
endif

" .h files can be C, Ch C++, ObjC or ObjC++.
" Set c_syntax_for_h if you want C, ch_syntax_for_h if you want Ch. ObjC is
" detected automatically.
au BufNewFile,BufRead *.h			call s:FTheader()

func! s:FTheader()
  if match(getline(1, min([line("$"), 200])), '^@\(interface\|end\|class\)') > -1
    if exists("g:c_syntax_for_h")
      setf objc
    else
      setf objcpp
    endif
  elseif exists("g:c_syntax_for_h")
    setf c
  elseif exists("g:ch_syntax_for_h")
    setf ch
  else
    setf cpp
  endif
endfunc

" Cmake
au BufNewFile,BufRead CMakeLists.txt,*.cmake,*.cmake.in		setf cmake

" Configure scripts
au BufNewFile,BufRead configure.in,configure.ac setf config

" CUDA  Cumpute Unified Device Architecture
au BufNewFile,BufRead *.cu			setf cuda

" DOT
au BufNewFile,BufRead *.dot			setf dot

" Fortran
if has("fname_case")
  au BufNewFile,BufRead *.F,*.FOR,*.FPP,*.FTN,*.F77,*.F90,*.F95,*.F03,*.F08	 setf fortran
endif
au BufNewFile,BufRead   *.f,*.for,*.fortran,*.fpp,*.ftn,*.f77,*.f90,*.f95,*.f03,*.f08  setf fortran

" GDB command files
au BufNewFile,BufRead .gdbinit			setf gdb

" Git
au BufNewFile,BufRead COMMIT_EDITMSG		setf gitcommit
au BufNewFile,BufRead MERGE_MSG			setf gitcommit
au BufNewFile,BufRead *.git/config,.gitconfig,.gitmodules setf gitconfig
au BufNewFile,BufRead *.git/modules/*/config	setf gitconfig
au BufNewFile,BufRead */.config/git/config	setf gitconfig
if !empty($XDG_CONFIG_HOME)
  au BufNewFile,BufRead $XDG_CONFIG_HOME/git/config	setf gitconfig
endif
au BufNewFile,BufRead git-rebase-todo		setf gitrebase
au BufNewFile,BufRead .msg.[0-9]*
      \ if getline(1) =~ '^From.*# This line is ignored.$' |
      \   setf gitsendemail |
      \ endif
au BufNewFile,BufRead *.git/*
      \ if getline(1) =~ '^\x\{40\}\>\|^ref: ' |
      \   setf git |
      \ endif

" GPG
au BufNewFile,BufRead */.gnupg/options		setf gpg
au BufNewFile,BufRead */.gnupg/gpg.conf		setf gpg
au BufNewFile,BufRead */usr/*/gnupg/options.skel setf gpg

" Go (Google)
au BufNewFile,BufRead *.go			setf go

" HEX (Intel)
au BufNewFile,BufRead *.hex,*.h32		setf hex

" HTML (.shtml and .stm for server side)
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call s:FThtml()

" Distinguish between HTML, XHTML and Django
func! s:FThtml()
  let n = 1
  while n < 10 && n < line("$")
    if getline(n) =~ '\<DTD\s\+XHTML\s'
      setf xhtml
      return
    endif
    if getline(n) =~ '{%\s*\(extends\|block\|load\)\>\|{#\s\+'
      setf htmldjango
      return
    endif
    let n = n + 1
  endwhile
  setf html
endfunc

" HTML with Ruby - eRuby
au BufNewFile,BufRead *.erb,*.rhtml		setf eruby

" Java
au BufNewFile,BufRead *.java,*.jav		setf java

" JavaCC
au BufNewFile,BufRead *.jj,*.jjt		setf javacc

" JavaScript, ECMAScript
au BufNewFile,BufRead *.js,*.javascript,*.es,*.jsx   setf javascript

" Java Server Pages
au BufNewFile,BufRead *.jsp			setf jsp

" Java Properties resource file (note: doesn't catch font.properties.pl)
au BufNewFile,BufRead *.properties,*.properties_??,*.properties_??_??	setf jproperties
au BufNewFile,BufRead *.properties_??_??_*	call s:StarSetf('jproperties')

" Less
au BufNewFile,BufRead *.less			setf less

" Lifelines (or Lex for C++!)
au BufNewFile,BufRead *.ll			setf lifelines

" Lilo: Linux loader
au BufNewFile,BufRead lilo.conf			setf lilo

" Lua
au BufNewFile,BufRead *.lua			setf lua

" Luarocks
au BufNewFile,BufRead *.rockspec		setf lua

" M4
au BufNewFile,BufRead *.m4
	\ if expand("<afile>") !~? 'html.m4$\|fvwm2rc' | setf m4 | endif

" Man config
au BufNewFile,BufRead */etc/man.conf,man.config	setf manconf

" Markdown
au BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md  setf markdown

" Matlab or Objective C
" au BufNewFile,BufRead *.m			call s:FTm()
au BufNewFile,BufRead *.m			setf objc

func! s:FTm()
  let n = 1
  while n < 10
    let line = getline(n)
    if line =~ '^\s*\(#\s*\(include\|import\)\>\|/\*\|//\)'
      setf objc
      return
    endif
    if line =~ '^\s*%'
      setf matlab
      return
    endif
    if line =~ '^\s*(\*'
      setf mma
      return
    endif
    let n = n + 1
  endwhile
  if exists("g:filetype_m")
    exe "setf " . g:filetype_m
  else
    setf matlab
  endif
endfunc

" Ninja file
au BufNewFile,BufRead *.ninja			setf ninja

" Nroff/Troff (*.ms and *.t are checked below)
au BufNewFile,BufRead *.me
	\ if expand("<afile>") != "read.me" && expand("<afile>") != "click.me" |
	\   setf nroff |
	\ endif
au BufNewFile,BufRead *.tr,*.nr,*.roff,*.tmac,*.mom	setf nroff
au BufNewFile,BufRead *.[1-9]			call s:FTnroff()

" This function checks if one of the first five lines start with a dot.  In
" that case it is probably an nroff file: 'filetype' is set and 1 is returned.
func! s:FTnroff()
  if getline(1)[0] . getline(2)[0] . getline(3)[0] . getline(4)[0] . getline(5)[0] =~ '\.'
    setf nroff
    return 1
  endif
  return 0
endfunc

" Nroff or Objective C++
au BufNewFile,BufRead *.mm			setf objcpp

func! s:FTmm()
  let n = 1
  while n < 10
    let line = getline(n)
    if line =~ '^\s*\(#\s*\(include\|import\)\>\|/\*\)'
      setf objcpp
      return
    endif
    let n = n + 1
  endwhile
  setf nroff
endfunc

" Perl
if has("fname_case")
  au BufNewFile,BufRead *.pl,*.PL		call s:FTpl()
else
  au BufNewFile,BufRead *.pl			call s:FTpl()
endif
au BufNewFile,BufRead *.plx,*.al		setf perl
au BufNewFile,BufRead *.p6,*.pm6,*.pl6	setf perl6

func! s:FTpl()
  if exists("g:filetype_pl")
    exe "setf " . g:filetype_pl
  else
    " recognize Prolog by specific text in the first non-empty line
    " require a blank after the '%' because Perl uses "%list" and "%translate"
    let l = getline(nextnonblank(1))
    if l =~ '\<prolog\>' || l =~ '^\s*\(%\+\(\s\|$\)\|/\*\)' || l =~ ':-'
      setf prolog
    else
      setf perl
    endif
  endif
endfunc

" Perl, XPM or XPM2
au BufNewFile,BufRead *.pm
	\ if getline(1) =~ "XPM2" |
	\   setf xpm2 |
	\ elseif getline(1) =~ "XPM" |
	\   setf xpm |
	\ else |
	\   setf perl |
	\ endif

" Perl POD
au BufNewFile,BufRead *.pod			setf pod
au BufNewFile,BufRead *.pod6		setf pod6

" PO and PO template (GNU gettext)
au BufNewFile,BufRead *.po,*.pot		setf po

" Progress or assembly
au BufNewFile,BufRead *.i			call s:FTprogress_asm()

func! s:FTprogress_asm()
  if exists("g:filetype_i")
    exe "setf " . g:filetype_i
    return
  endif
  " This function checks for an assembly comment the first ten lines.
  " If not found, assume Progress.
  let lnum = 1
  while lnum <= 10 && lnum < line('$')
    let line = getline(lnum)
    if line =~ '^\s*;' || line =~ '^\*'
      call s:FTasm()
      return
    elseif line !~ '^\s*$' || line =~ '^/\*'
      " Not an empty line: Doesn't look like valid assembly code.
      " Or it looks like a Progress /* comment
      break
    endif
    let lnum = lnum + 1
  endw
  setf progress
endfunc

" Google protocol buffers
au BufNewFile,BufRead *.proto			setf proto

" Pyrex
au BufNewFile,BufRead *.pyx,*.pxd		setf pyrex

" Python
au BufNewFile,BufRead *.py,*.pyw		setf python

" Readline
au BufNewFile,BufRead .inputrc,inputrc		setf readline

" Resolv.conf
au BufNewFile,BufRead resolv.conf		setf resolv

" Interactive Ruby shell
au BufNewFile,BufRead .irbrc,irbrc		setf ruby

" Ruby
au BufNewFile,BufRead *.rb,*.rbw		setf ruby

" RubyGems
au BufNewFile,BufRead *.gemspec			setf ruby

" Rackup
au BufNewFile,BufRead *.ru			setf ruby

" Bundler
au BufNewFile,BufRead Gemfile			setf ruby

" Ruby on Rails
au BufNewFile,BufRead *.builder,*.rxml,*.rjs	setf ruby

" Rantfile and Rakefile is like Ruby
au BufNewFile,BufRead [rR]antfile,*.rant,[rR]akefile,*.rake	setf ruby

" Sass
au BufNewFile,BufRead *.sass			setf sass

" sed
au BufNewFile,BufRead *.sed			setf sed

" Shell scripts (sh, ksh, bash, bash2, csh); Allow .profile_foo etc.
" Gentoo ebuilds and Arch Linux PKGBUILDs are actually bash scripts
au BufNewFile,BufRead .bashrc*,bashrc,bash.bashrc,.bash_profile*,.bash_logout*,.bash_aliases*,*.bash,*.ebuild,PKGBUILD* call SetFileTypeSH("bash")
au BufNewFile,BufRead .kshrc*,*.ksh call SetFileTypeSH("ksh")
au BufNewFile,BufRead */etc/profile,.profile*,*.sh,*.env call SetFileTypeSH(getline(1))

" Shell script (Arch Linux) or PHP file (Drupal)
au BufNewFile,BufRead *.install
	\ if getline(1) =~ '<?php' |
	\   setf php |
	\ else |
	\   call SetFileTypeSH("bash") |
	\ endif

" Also called from scripts.vim.
func! SetFileTypeSH(name)
  if expand("<amatch>") =~ g:ft_ignore_pat
    return
  endif
  if a:name =~ '\<csh\>'
    " Some .sh scripts contain #!/bin/csh.
    call SetFileTypeShell("csh")
    return
  elseif a:name =~ '\<tcsh\>'
    " Some .sh scripts contain #!/bin/tcsh.
    call SetFileTypeShell("tcsh")
    return
  elseif a:name =~ '\<zsh\>'
    " Some .sh scripts contain #!/bin/zsh.
    call SetFileTypeShell("zsh")
    return
  elseif a:name =~ '\<ksh\>'
    let b:is_kornshell = 1
    if exists("b:is_bash")
      unlet b:is_bash
    endif
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif exists("g:bash_is_sh") || a:name =~ '\<bash\>' || a:name =~ '\<bash2\>'
    let b:is_bash = 1
    if exists("b:is_kornshell")
      unlet b:is_kornshell
    endif
    if exists("b:is_sh")
      unlet b:is_sh
    endif
  elseif a:name =~ '\<sh\>'
    let b:is_sh = 1
    if exists("b:is_kornshell")
      unlet b:is_kornshell
    endif
    if exists("b:is_bash")
      unlet b:is_bash
    endif
  endif
  call SetFileTypeShell("sh")
endfunc

" For shell-like file types, check for an "exec" command hidden in a comment,
" as used for Tcl.
" Also called from scripts.vim, thus can't be local to this script.
func! SetFileTypeShell(name)
  if expand("<amatch>") =~ g:ft_ignore_pat
    return
  endif
  let l = 2
  while l < 20 && l < line("$") && getline(l) =~ '^\s*\(#\|$\)'
    " Skip empty and comment lines.
    let l = l + 1
  endwhile
  if l < line("$") && getline(l) =~ '\s*exec\s' && getline(l - 1) =~ '^\s*#.*\\$'
    " Found an "exec" line after a comment with continuation
    let n = substitute(getline(l),'\s*exec\s\+\([^ ]*/\)\=', '', '')
    if n =~ '\<tclsh\|\<wish'
      setf tcl
      return
    endif
  endif
  exe "setf " . a:name
endfunc

" Z-Shell script
au BufNewFile,BufRead .zprofile,*/etc/zprofile,.zfbfmarks  setf zsh
au BufNewFile,BufRead .zsh*,.zlog*,.zcompdump*  call s:StarSetf('zsh')
au BufNewFile,BufRead *.zsh			setf zsh

" OpenSSH configuration
au BufNewFile,BufRead ssh_config,*/.ssh/config	setf sshconfig

" OpenSSH server configuration
au BufNewFile,BufRead sshd_config		setf sshdconfig

" Sysctl
au BufNewFile,BufRead */etc/sysctl.conf,*/etc/sysctl.d/*.conf	setf sysctl

" Terminfo
au BufNewFile,BufRead *.ti			setf terminfo

" Vim script
au BufNewFile,BufRead *.vim,*.vba,.exrc,_exrc	setf vim

" Viminfo file
au BufNewFile,BufRead .viminfo,_viminfo		setf viminfo

" Wget config
au BufNewFile,BufRead .wgetrc,wgetrc		setf wget

" XHTML
au BufNewFile,BufRead *.xhtml,*.xht		setf xhtml

" Xorg config
au BufNewFile,BufRead xorg.conf,xorg.conf-4	let b:xf86conf_xfree86_version = 4 | setf xf86conf

" Xinetd conf
au BufNewFile,BufRead */etc/xinetd.conf		setf xinetd

" XS Perl extension interface language
au BufNewFile,BufRead *.xs			setf xs

" X resources file
au BufNewFile,BufRead .Xdefaults,.Xpdefaults,.Xresources,xdm-config,*.ad setf xdefaults

" XML  specific variants: docbk and xbl
au BufNewFile,BufRead *.xml			call s:FTxml()

func! s:FTxml()
  let n = 1
  while n < 100 && n < line("$")
    let line = getline(n)
    " DocBook 4 or DocBook 5.
    let is_docbook4 = line =~ '<!DOCTYPE.*DocBook'
    let is_docbook5 = line =~ ' xmlns="http://docbook.org/ns/docbook"'
    if is_docbook4 || is_docbook5
      let b:docbk_type = "xml"
      if is_docbook5
	let b:docbk_ver = 5
      else
	let b:docbk_ver = 4
      endif
      setf docbk
      return
    endif
    if line =~ 'xmlns:xbl="http://www.mozilla.org/xbl"'
      setf xbl
      return
    endif
    let n += 1
  endwhile
  setf xml
endfunc

" Qt Linguist translation source and Qt User Interface Files are XML
au BufNewFile,BufRead *.ts,*.ui			setf xml

" Yacc
au BufNewFile,BufRead *.yy,*.yxx,*.y++		setf yacc

" Yacc or racc
au BufNewFile,BufRead *.y			call s:FTy()

func! s:FTy()
  let n = 1
  while n < 100 && n < line("$")
    let line = getline(n)
    if line =~ '^\s*%'
      setf yacc
      return
    endif
    if getline(n) =~ '^\s*\(#\|class\>\)' && getline(n) !~ '^\s*#\s*include'
      setf racc
      return
    endif
    let n = n + 1
  endwhile
  setf yacc
endfunc

" Yaml
au BufNewFile,BufRead *.yaml,*.yml		setf yaml

" yum conf (close enough to dosini)
au BufNewFile,BufRead */etc/yum.conf		setf dosini

" Extra checks for when no filetype has been detected now.  Mostly used for
" patterns that end in "*".  E.g., "zsh*" matches "zsh.vim", but that's a Vim
" script file.
" Most of these should call s:StarSetf() to avoid names ending in .gz and the
" like are used.

" More Apache config files
au BufNewFile,BufRead access.conf*,apache.conf*,apache2.conf*,httpd.conf*,srm.conf*	call s:StarSetf('apache')
au BufNewFile,BufRead */etc/apache2/*.conf*,*/etc/apache2/conf.*/*,*/etc/apache2/mods-*/*,*/etc/apache2/sites-*/*,*/etc/httpd/conf.d/*.conf*		call s:StarSetf('apache')

" Asterisk config file
au BufNewFile,BufRead *asterisk/*.conf*		call s:StarSetf('asterisk')
au BufNewFile,BufRead *asterisk*/*voicemail.conf* call s:StarSetf('asteriskvm')

" Changelog
au BufNewFile,BufRead [cC]hange[lL]og*
	\ if getline(1) =~ '; urgency='
	\|  call s:StarSetf('debchangelog')
	\|else
	\|  call s:StarSetf('changelog')
	\|endif

" Lilo: Linux loader
au BufNewFile,BufRead lilo.conf*		call s:StarSetf('lilo')

" Logcheck
au BufNewFile,BufRead */etc/logcheck/*.d*/*	call s:StarSetf('logcheck')

" Makefile
au BufNewFile,BufRead [mM]akefile*		call s:StarSetf('make')

" Ruby Makefile
au BufNewFile,BufRead [rR]akefile*		call s:StarSetf('ruby')

" Nroff macros
au BufNewFile,BufRead tmac.*			call s:StarSetf('nroff')

" Vim script
au BufNewFile,BufRead *vimrc*			call s:StarSetf('vim')

" Subversion commit file
au BufNewFile,BufRead svn-commit*.tmp		setf svn

" X resources file
au BufNewFile,BufRead Xresources*,*/app-defaults/*,*/Xresources/* call s:StarSetf('xdefaults')

" X11 xmodmap
au BufNewFile,BufRead *xmodmap*			call s:StarSetf('xmodmap')

" Xinetd conf
au BufNewFile,BufRead */etc/xinetd.d/*		call s:StarSetf('xinetd')

" yum conf (close enough to dosini)
au BufNewFile,BufRead */etc/yum.repos.d/*	call s:StarSetf('dosini')

" Z-Shell script
au BufNewFile,BufRead zsh*,zlog*		call s:StarSetf('zsh')

" Plain text files, needs to be far down to not override others.  This avoids
" the "conf" type being used if there is a line starting with '#'.
au BufNewFile,BufRead *.txt,*.text,README	setf text

" Use the filetype detect plugins.  They may overrule any of the previously
" detected filetypes.
runtime! ftdetect/*.vim

" NOTE: The above command could have ended the filetypedetect autocmd group
" and started another one. Let's make sure it has ended to get to a consistent
" state.
augroup END

" Restore 'cpoptions'
let &cpo = s:cpo_save
unlet s:cpo_save
