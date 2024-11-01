autocmd BufNewFile,BufRead * if search('{{\.\+}}', 'nw') | setlocal filetype=go.gotmpl | endif
