" Objective-C syntax
" https://github.com/ap4y/dotfiles/blob/master/vim/.vim/after/syntax/objc.vim

" ARC type modifiers
syn keyword objcTypeModifier __bridge __bridge_retained __bridge_transfer __autoreleasing __strong __weak __unsafe_unretained

" Block modifiers
syn keyword objcTypeModifier __block

" Remote messaging modifiers
syn keyword objcTypeModifier byref

" Property keywords - these are only highlighted inside '@property (...)'
syn keyword objcPropertyAttribute contained getter setter readwrite readonly strong weak copy assign retain nonatomic
syn match objcProperty display "^\s*@property\>\s*([^)]*)" contains=objcPropertyAttribute

" The @property directive must be defined after objcProperty or it won't be
" highlighted
syn match objcDirective "@property\|@synthesize\|@dynamic\|@package"

syn match objcPointerClass "\h\+\(\s*[*]\)\@="
syn match objcDotProperty "\(\.\)\@<=\h\+"
syn match objcInstanceVariable "\(*\|\[\| \)\@<=_\h\+"

syn match objcCFunction "\w\+[(]\@="
syn match objcPrimitives "NSInteger\|NSUInteger\|CGFloat\|NSTimeInterval"

syn region objc2Hash transparent matchgroup=objc2HashBraces start="@{" end="}"
syn region objc2Array transparent matchgroup=objc2ArrayBraces start="@\[" end="]"
syn region objc2Number transparent matchgroup=objc2NumberBraces start="@(" end=")"
syn region objc2Block transparent matchgroup=objc2BlockBraces start="\(\^.*\)\@<={" end="}"

syn match objcMessageName "\s\@<=\w*\(]\|:\)\@=" contained
syn match objcMessageClass "\(\[\s*\)\@<=\u\w*" contained
syn region objcCorrectMessage transparent matchgroup=objCorrectMessage start="\[" end="\]" contains=objc.*,cConditional,cStatement,cComment.*,cNumber,cFloat

syn keyword objcWrappedConstant YES NO nil NULL
syn keyword objcIBRWords IBAction IBOutlet

" link to the standard
hi def link objcTypeModifier                         Statement
hi def link objcProperty                             Statement
hi def link objcDirective                            Statement
hi def link objcPropertyAttribute                    Statement
hi def link objcPointerClass                         objcPointer
hi def link objcMessageClass                         objcPointer
hi def link objcDotProperty                          Identifier
hi def link objcInstanceVariable                     Identifier
hi def link objc2HashBraces                          Constant
hi def link objc2ArrayBraces                         Constant
hi def link objc2NumberBraces                        Constant
hi def link objcMessageName                          Function
hi def link objcCFunction                            Operator
hi def link objcSpecial                              String
hi def link objcWrappedConstant                      Statement
hi def link objcIBRWords                             Statement
hi def link objcPointer                              Type
hi def link objcPrimitives                           cType
