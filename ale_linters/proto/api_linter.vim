" Description: lint to protocol buffers files compliances with many of Google's API standards based by AIP (API Improvement Proposals).

call ale#Set('proto_api_linter_executable', 'api-linter')
call ale#Set('proto_api_linter_options', [])
call ale#Set('proto_api_linter_config_path', '')
call ale#Set('proto_api_linter_include_paths', '')

function! ale_linters#proto#api_linter#GetCommand(buffer) abort
  let l:dir = expand('#' . a:buffer . ':p:h')
  let l:filename = expand('#' . a:buffer . ':t')
  let l:api_linter_options = ale#Var(a:buffer, 'proto_api_linter_options')
  let l:api_linter_config_path = ale#Var(a:buffer, 'proto_api_linter_config_path')
  let l:api_linter_include_paths = ale#Var(a:buffer, 'proto_api_linter_include_paths')

  let l:options = ['--output-format=json']  " always json output format for parses results

  if !empty(l:api_linter_options)
    let l:options += l:api_linter_options
  endif

  if !empty(l:api_linter_config_path)
    let l:options += ['--config=' . ale#path#ResolveLocalPath(a:buffer, l:api_linter_config_path, l:api_linter_config_path)]
  endif

  if !empty(l:api_linter_include_paths)
    for l:include in l:api_linter_include_paths
      let l:options += ['-I ' . ale#path#ResolveLocalPath(a:buffer, l:include, l:include)]
    endfor
  endif

  let l:cmd = ale#Escape(ale#Var(a:buffer, 'proto_api_linter_executable'))
        \ . ' ' . join(l:options)
        \ . ' ' . ale#path#GetAbsPath(l:dir, l:filename)
  " echomsg l:cmd
  return l:cmd
endfunction

function! ale_linters#proto#api_linter#Handler(buffer, lines) abort
  let l:dir = expand('#' . a:buffer . ':p:h')
  let l:output = []

  let l:out = ale#util#FuzzyJSONDecode(a:lines, [])
  if !empty(l:out)
    let l:data = l:out[0]
    let l:file_path = get(l:data, 'file_path')
    let l:filename = ale#path#ResolveLocalPath(a:buffer, l:file_path, l:file_path)
    let l:problems = l:data['problems']
    
    if !empty(l:problems)
      for l:problem in l:problems
        let l:location = get(get(l:problem, "location"), "start_position")
        call add(l:output, {
              \ 'filename': l:filename,
              \ 'lnum': get(l:location, "line_number") + 0,
              \ 'col':  get(l:location, "column_number") + 0,
              \ 'type': 'E',
              \ 'text': get(l:problem, "message") . ' [rule: ' . get(l:problem, "rule_id") . '](' . get(l:problem, "rule_doc_uri") . ')',
              \ 'valid': v:true,
              \})
              "\   get(l:problem, "suggestion", '')
      endfor
    endif
  endif
  
  return l:output
endfunction

call ale#linter#Define('proto', {
      \ 'name': 'api-linter',
      \ 'output_stream': 'both',
      \ 'executable': {b -> ale#Var(b, 'proto_api_linter_executable')},
      \ 'command': function('ale_linters#proto#api_linter#GetCommand'),
      \ 'callback': 'ale_linters#proto#api_linter#Handler',
      \ 'lint_file': 1,
      \})
