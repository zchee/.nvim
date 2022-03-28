-- This file copied from https://github.com/fatih/vim-go/blob/4a429a0fc85c/syntax/gohtmltmpl.vim

vim.cmd([[
if exists("b:current_syntax")
  finish
endif

if !exists("g:main_syntax")
  let g:main_syntax = 'html'
endif

runtime! syntax/gotexttmpl.lua
runtime! syntax/html.vim
unlet b:current_syntax

syn cluster htmlPreproc add=gotplAction,goTplComment

let b:current_syntax = "gohtmltmpl"
]])

-- vim: sw=2 ts=2 et
