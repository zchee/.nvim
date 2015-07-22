let s:assert = {}

function! s:_config() abort
  return extend({
  \   '__debug__': 0,
  \   '__pseudo_throw__': 1,
  \   '__abort__': 1
  \ }, get(g:, '__vital_exe_assert_config', {}))
endfunction

function! s:make(...) abort
  let assert = extend(extend(deepcopy(s:assert), s:_config()), get(a:, 1, {}))
  for funcname in filter(keys(s:assert), 'v:val !~# "^_"')
    execute join([
    \   ' function! assert.' . funcname . '(...) abort',
    \   '   if self.__debug__',
    \   '     try',
    \   '       call call(s:assert.' . funcname . ', a:000, self)',
    \   '       return ""',
    \   '     catch /AssertionError:/',
    \   '       return self._throw_cmd(v:exception)',
    \   '     endtry',
    \   '   else',
    \   '     return ""',
    \   '   endif',
    \   ' endfunction',
    \ ], "\n")
  endfor
  return assert
endfunction

function! s:assert._throw_cmd(msg) abort
  if self.__pseudo_throw__
    return self._pseudo_throw_cmd(a:msg)
  else
    return printf(":throw '%s'", a:msg)
  endif
endfunction

" Vim cannot output multiple lines with `:echom` nor `:throw`, so execute
" `:echom` each line and execute `:throw` additionally just for aborting
function! s:assert._pseudo_throw_cmd(msg) abort
  return join([
  \   'try',
  \   '  throw ' . string(a:msg),
  \   'catch',
  \   '  echohl ErrorMsg',
  \   '  echom v:throwpoint',
  \   '  for s:__vital_assert_line in split(v:exception, "\n")',
  \   '    echom s:__vital_assert_line',
  \   '  endfor',
  \   '  unlet s:__vital_assert_line',
  \   '  echohl None',
  \   'endtry'
  \ ] + (self.__abort__ ? ['throw "vital: ExeAssert: abort"'] : []), '|')
endfunction

" @override themis's one
function! s:_failure(mes, additional) abort
  let m = a:mes + (empty(a:additional) ? [] : [''] + a:additional)
  return 'AssertionError: ' . s:_build_message(m)
endfunction

function! s:_build_message(expr) abort
  let t = type(a:expr)
  return
  \  t == type('') ? a:expr :
  \  t == type([]) ? join(map(copy(a:expr), 's:_build_message(v:val)'), "\n") :
  \                  string(a:expr)
endfunction

" --- copied from themis with little modification
" Author: thinca <thinca+vim@gmail.com>
" License: zlib License
" URL: https://github.com/thinca/vim-themis/blob/master/doc/themis.txt#L5
" :%s/function! s:assert\zs_/./
" :%s/\vcall\('s:assert_([^']{-})'/self.\1/g
" :%s/\vcall\(self\.[^)]{-}%(self)@<!\zs\ze\)/, self/g
" :%s/\vs:\zs(equals|match|type|check_type|failure)\ze\(/_\0/g
" :%s/\vcall \zss:assert_(\w+)/self.\1/g

function! s:assert.true(value, ...) abort
  if a:value isnot 1
    throw s:_failure([
    \   'The true value was expected, but it was not the case.',
    \   '',
    \   '    expected: true',
    \   '         got: ' . string(a:value),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.false(value, ...) abort
  if a:value isnot 0
    throw s:_failure([
    \   'The false value was expected, but it was not the case.',
    \   '',
    \   '    expected: false',
    \   '         got: ' . string(a:value),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.truthy(value, ...) abort
  let t = type(a:value)
  if !(t == type(0) || t == type('')) || !a:value
    throw s:_failure([
    \   'The truthy value was expected, but it was not the case.',
    \   '',
    \   '    expected: truthy',
    \   '         got: ' . string(a:value),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.falsy(value, ...) abort
  let t = type(a:value)
  if (t != type(0) && t != type('')) || a:value
    throw s:_failure([
    \   'The falsy value was expected, but it was not the case.',
    \   '',
    \   '    expected: falsy',
    \   '         got: ' . string(a:value),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.compare(left, expr, right, ...) abort
  let expr_str = join([string(a:left), a:expr, string(a:right)])
  try
    let result = eval(join(['a:left', a:expr, 'a:right']))
  catch /^Vim(let):E691:/
    let result = 0
  catch
    throw s:_failure([
    \   'Unexpected error occurred while evaluating the comparing:',
    \   '',
    \   '    expression: ' . expr_str,
    \   '    error: ' . v:exception,
    \ ], a:000)
  endtry
  if !result
    throw s:_failure([
    \   'The right expression was expected, but it was not the case.',
    \   '',
    \   '    expression: ' . expr_str,
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.equals(actual, expect, ...) abort
  if !s:_equals(a:expect, a:actual)
    throw s:_failure([
    \   'The equivalent values were expected, but it was not the case.',
    \   '',
    \   '    expected: ' . string(a:expect),
    \   '         got: ' . string(a:actual),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.not_equals(actual, expect, ...) abort
  if s:_equals(a:expect, a:actual)
    throw s:_failure([
    \   'Not the equivalent values were expected, but it was not the case.',
    \   '',
    \   '    expected: ' . string(a:expect),
    \   '         got: ' . string(a:actual),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.same(actual, expect, ...) abort
  if a:expect isnot# a:actual
    throw s:_failure([
    \   'The same values were expected, but it was not the case.',
    \   '',
    \   '    expected: ' . string(a:expect),
    \   '         got: ' . string(a:actual),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.not_same(actual, expect, ...) abort
  if a:expect is# a:actual
    throw s:_failure([
    \   'Not the same values were expected, but it was not the case.',
    \   '',
    \   '    expected: ' . string(a:expect),
    \   '         got: ' . string(a:actual),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.match(actual, pattern, ...) abort
  if !s:_match(a:actual, a:pattern)
    throw s:_failure([
    \   'Match was expected, but did not match.',
    \   '',
    \   '    target: ' . string(a:actual),
    \   '    pattern: ' . string(a:pattern),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.not_match(actual, pattern, ...) abort
  if s:_match(a:actual, a:pattern)
    throw s:_failure([
    \   'Not match was expected, but matched.',
    \   '',
    \   '    target: ' . string(a:actual),
    \   '    pattern: ' . string(a:pattern),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.is_number(value, ...) abort
  return s:_check_type(a:value, 'Number', 0, a:000)
endfunction

function! s:assert.is_not_number(value, ...) abort
  return s:_check_type(a:value, 'Number', 1, a:000)
endfunction

function! s:assert.is_string(value, ...) abort
  return s:_check_type(a:value, 'String', 0, a:000)
endfunction

function! s:assert.is_not_string(value, ...) abort
  return s:_check_type(a:value, 'String', 1, a:000)
endfunction

function! s:assert.is_func(value, ...) abort
  return s:_check_type(a:value, 'Funcref', 0, a:000)
endfunction

function! s:assert.is_not_func(value, ...) abort
  return s:_check_type(a:value, 'Funcref', 1, a:000)
endfunction

function! s:assert.is_list(value, ...) abort
  return s:_check_type(a:value, 'List', 0, a:000)
endfunction

function! s:assert.is_not_list(value, ...) abort
  return s:_check_type(a:value, 'List', 1, a:000)
endfunction

function! s:assert.is_dict(value, ...) abort
  return s:_check_type(a:value, 'Dictionary', 0, a:000)
endfunction

function! s:assert.is_not_dict(value, ...) abort
  return s:_check_type(a:value, 'Dictionary', 1, a:000)
endfunction

function! s:assert.is_float(value, ...) abort
  return s:_check_type(a:value, 'Float', 0, a:000)
endfunction

function! s:assert.is_not_float(value, ...) abort
  return s:_check_type(a:value, 'Float', 1, a:000)
endfunction

function! s:assert.type_of(value, names, ...) abort
  return s:_check_type(a:value, a:names, 0, a:000)
endfunction

function! s:assert.length_of(value, length, ...) abort
  call self.type_of(a:value, ['String', 'List', 'Dictionary'])
  let got_length = len(a:value)
  if got_length != a:length
    throw s:_failure([
    \   'The length of value was expected to the specified length, but it was not the case.',
    \   '',
    \   '    expected length: ' . a:length,
    \   '         got length: ' . got_length,
    \   '          got value: ' . string(a:value),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.has_key(value, key, ...) abort
  let t = type(a:value)
  if t == type({})
    if !has_key(a:value, a:key)
      throw s:_failure([
      \   'The dictionary was expected to have a key, but it did not have.',
      \   '',
      \   '      dictionary: ' . string(a:value),
      \   '    expected key: ' . string(a:key),
      \ ], a:000)
    endif
  elseif t == type([])
    if (a:key < 0 || len(a:value) <= a:key)
      throw s:_failure([
      \   'The array was expected to have a index, but it did not have.',
      \   '',
      \   '             array: ' . string(a:value),
      \   '      array length: ' . len(a:value),
      \   '    expected index: ' . string(a:key),
      \ ], a:000)
    endif
  else
    throw s:_failure([
    \   'The first argument was expected to an array or a dict, but it did not have.',
    \   '',
    \   '    value: ' . string(a:value),
    \   '     type: ' . s:_type(a:value),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.key_exists(value, key, ...) abort
  call call(self.is_dict, [a:value] + a:000, self)
  if !has_key(a:value, a:key)
    throw s:_failure([
    \   'It was expected that a key exists in the dictionary, but it did not exist.',
    \   '',
    \   '      dictionary: ' . string(a:value),
    \   '    expected key: ' . string(a:key),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.key_not_exists(value, key, ...) abort
  call call(self.is_dict, [a:value] + a:000, self)
  if has_key(a:value, a:key)
    throw s:_failure([
    \   'It was expected that a key does not exist in the dictionary, but it did exist.',
    \   '',
    \   '      dictionary: ' . string(a:value),
    \   '    expected key: ' . string(a:key),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:assert.exists(expr, ...) abort
  if !exists(a:expr)
    throw s:_failure([
    \   'The target was expected to exist, but it did not exist.',
    \   '',
    \   '    target: ' . string(a:expr),
    \ ], a:000)
  endif
  return 1
endfunction

function! s:_equals(x, y) abort
  return a:x ==# a:y
endfunction

function! s:_match(str, pattern) abort
  return type(a:str) == type('') &&
  \      type(a:pattern) == type('') &&
  \      a:str =~# a:pattern
endfunction

let s:type_names = {
\   type(0): 'number',
\   type(''): 'string',
\   type(function('type')): 'funcref',
\   type([]): 'list',
\   type({}): 'dictionary',
\   type(0.0): 'float',
\ }
function! s:_type(value) abort
  return s:type_names[type(a:value)]
endfunction

function! s:_check_type(value, expected_types, not, additional_message) abort
  let got_type = s:_type(a:value)
  let expected_types = s:_type(a:expected_types) ==# 'list' ?
  \                    copy(a:expected_types) : [a:expected_types]
  call map(expected_types, 'tolower(v:val)')
  call map(expected_types, 'v:val ==# "dict" ? "dictionary" : v:val')
  let success = 0 <= index(expected_types, got_type)

  let [expect, but] = ['', ' not']
  if a:not
    let success = !success
    let [expect, but] = [' not', '']
  endif

  if !success
    if 2 <= len(expected_types)
      let msg = 'The type of value was%s expected to be one of %s'
      let type_names =
      \     join(expected_types[: -2], ', ') . ' or ' . expected_types[-1]
    else
      let msg = 'The type of value was%s expected to be %s'
      let type_names = expected_types[0]
    endif
    throw s:_failure([
    \   printf(msg . ', but it was%s the case.', expect, type_names, but),
    \   '',
    \   '    expected type: ' . type_names,
    \   '         got type: ' . got_type,
    \   '        got value: ' . string(a:value),
    \ ], a:additional_message)
  endif
  return 1
endfunction
