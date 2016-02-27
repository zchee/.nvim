" deoplete-clang
let g:deoplete#sources#clang#libclang_path = "/opt/llvm/trunk/lib/libclang.dylib"
let g:deoplete#sources#clang#clang_header = '/opt/llvm/trunk/lib/clang'
let g:deoplete#sources#clang#flags = [
      \ "-cc1",
      \ "-triple",
      \ "x86_64-apple-macosx10.11.0",
      \ "-Wdeprecated-objc-isa-usage",
      \ "-Werror=deprecated-objc-isa-usage",
      \ "-emit-obj",
      \ "-mrelax-all",
      \ "-disable-free",
      \ "-disable-llvm-verifier",
      \ "-mrelocation-model",
      \ "pic",
      \ "-pic-level", "2",
      \ "-mthread-model", "posix",
      \ "-mdisable-fp-elim",
      \ "-masm-verbose",
      \ "-munwind-tables",
      \ "-target-cpu", "core2",
      \ "-target-linker-version", "264.3",
      \ "-v",
      \ "-dwarf-column-info",
      \ "-debugger-tuning=lldb",
      \ "-coverage-file",
      \ "-resource-dir", "/opt/llvm/trunk/lib/clang/3.9.0",
      \ "-isysroot", "/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk",
      \ "-ferror-limit", "19",
      \ "-fmessage-length", "213",
      \ "-stack-protector", "1",
      \ "-fblocks",
      \ "-fobjc-runtime=macosx-10.11.0",
      \ "-fencode-extended-block-signature",
      \ "-fmax-type-align=16",
      \ "-fdiagnostics-show-option",
      \ "-x", "c",
      \ "-std=c11"
      \ ]
" let g:deoplete#sources#clang#flags = ['-x', 'c', '-std=c11']
" let g:deoplete#sources#clang#flags = ['-x', 'c++', '-std=c++11']
" let g:deoplete#sources#clang#flags = ['-ObjC', '-std=c11']
" let g:deoplete#sources#clang#sort_algo = 'priority'
" let g:deoplete#sources#clang#sort_algo = 'alphabetical'
" let g:deoplete#sources#clang#style = 'a'
" let g:deoplete#sources#clang#clang_complete_database = '/Users/zchee/src/github.com/neovim/neovim/build'
let g:deoplete#enable_debug = 1
let g:deoplete#sources#clang#debug#log_file = '~/.log/nvim/python/deoplete-clang.log'
let g:deoplete#sources#jedi#debug#log_file = '~/.log/nvim/python/deoplete-jedi.log'

" Rip-Rip/clang_complete
" let g:clang_auto_select = 1
let g:clang_use_library = 1
let g:clang_library_path = '/opt/llvm/trunk/lib/libclang.dylib'
let g:clang_compilation_database = '/Users/zchee/src/github.com/neovim/neovim/build'
let g:clang_snippets = 0
let g:clang_user_options = '-std=c++11'
