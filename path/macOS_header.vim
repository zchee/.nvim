" define Xcode directory path
if isdirectory('/Applications/Xcode-beta.app')
  let s:developer_dir  = '/Applications/Xcode-beta.app/Contents/Developer'
  let s:symlink_dir = expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks/Xcode-beta'
else 
  let s:developer_dir  = '/Applications/Xcode.app/Contents/Developer'
  let s:symlink_dir = expand($XDG_CONFIG_HOME) . '/nvim/path/Frameworks/Xcode'
endif

let s:sdk_dir        = s:developer_dir . '/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk'
let s:framework_dir  = s:sdk_dir . '/System/Library/Frameworks'
let s:toolchains_dir = s:developer_dir . '/Toolchains/XcodeDefault.xctoolchain'

" Xcode Frameworks headers
" set path=.,/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk

let s:osx_frameworks = s:sdk_dir . '/usr/include'
      \ . ',' . expand($HOME) . '/.local/include/Frameworks'
      \ . ',' . s:symlink_dir
      \ . ',/usr/local/include'
      \ . ',/usr/include'
      \ . ',' . s:toolchains_dir . '/usr/include'
      \ . ',' . s:toolchains_dir . '/usr/include/c++/v1'
      \ . ',' . s:toolchains_dir . '/usr/lib/clang/8.0.0/include'

execute 'set path+=' . s:osx_frameworks
