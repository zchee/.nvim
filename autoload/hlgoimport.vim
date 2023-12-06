let s:single_import = '^import\>\_.\{-}\_$\%(\nimport\>\)\@!'
let s:multi_import = '^import\>\s\+(\_[^)]\+)'


function! s:uniqadd(obj, item) abort
  if index(a:obj, a:item) == -1
    call add(a:obj, a:item)
  endif
endfunction


function! hlgoimport#update(forced) abort
  let start = 0
  let end = 0
  let view = winsaveview()

  call cursor(1, 1)
  let start = search(s:multi_import, 'cW')
  if start
    let end = search(s:multi_import, 'ceW')
  else
    let start = search(s:single_import, 'cW')
    if start
      let end = search(s:single_import, 'ceW')
    endif
  endif

  let imports = []
  if start && end
    for l in range(start, end)
      let text = getline(l)
      let import = matchstr(text, '"\zs[^"]\+\ze"')
      if empty(import)
        continue
      endif

      let alias = matchstr(substitute(text, '^\s*import\>', '', ''), '^\s*\zs\k\+')
      if !empty(alias)
        call s:uniqadd(imports, alias)
      else
        call s:uniqadd(imports, split(import, '/')[-1])
      endif
    endfor

    call sort(imports)
  endif

  if a:forced || !exists('b:goimports') || b:goimports != imports
    silent! syntax clear goImportedPkg
    let b:goimports = imports
    silent! execute 'syntax keyword goImportedPkg '.join(imports, ' ')
  endif

  call winrestview(view)
endfunction
