" vim-marching
let g:marching_clang_command = "/usr/bin/clang"
let g:marching#clang_command#options = {
\   "cpp" : "-std=c++11"
\}
let g:marching_include_paths = [
      \ "Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1",
      \ "usr/local/include",
      \ "Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/7.3.0/include",
      \ "Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include",
      \ "usr/include",
\]
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

" Rip-Rip/clang_complete
let g:clang_auto_select = 1
let g:clang_use_library = 1
let g:clang_library_path = '/opt/llvm/lib/libclang.dylib'

