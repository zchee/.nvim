" -------------------------------------------------------------------------------------------------
" Vim default mapping
"
" -------------------------------------------------------------------------------------------------
" 1. Insert mode            *insert-index*
"
" <CTRL-@>: insert previously inserted text and stop insert
" <CTRL-A>: insert previously inserted text
" <CTRL-C>: quit insert mode, without checking for abbreviation, unless 'insertmode' set.
" <CTRL-D>: delete one shiftwidth of indent in the current line
" <CTRL-E>: insert the character which is below the cursor
" <CTRL-F>: NOT_USED (but by default it's in 'cinkeys' to re-indent the current line)
" <CTRL-G><CTRL-J>: line down, to column where inserting started
" <CTRL-G> j: line down, to column where inserting started
" <CTRL-G> <<Down>: line down, to column where inserting started
" <CTRL-G><CTRL-K>: line up, to column where inserting started
" <CTRL-G> k: line up, to column where inserting started
" <CTRL-G><<Up>: line up, to column where inserting started
" <CTRL-G> u: start new undoable edit
" <CTRL-G> U: don't break undo with next cursor movement
" <BS>: delete character before the cursor
" {char1}<BS>{char2}: enter digraph (only when 'digraph' option set)
" <CTRL-H>: same as <BS>
" <Tab>: insert a <Tab> character
" <CTRL-I>: same as <Tab>
" <NL>: same as <CR>
" <CTRL-J>: same as <CR>
" <CTRL-K>: {char1} {char2} enter digraph
" <CTRL-L>: when 'insertmode' set: Leave Insert mode
" <<CR>: begin new line
" <CTRL-M>: same as <CR>
" <CTRL-N>: find next match for keyword in front of the cursor
" <CTRL-O>: execute a single command and return to insert mode
" <CTRL-P>: find previous match for keyword in front of the cursor
" <CTRL-Q>: same as CTRL-V, unless used for terminal control flow
" <CTRL-R> {0-9a-z"%#*:=}: insert the contents of a register
" <CTRL-R> <CTRL-R> {0-9a-z"%#*:=}: insert the contents of a register literally
" <CTRL-R> <CTRL-O> {0-9a-z"%#*:=}: insert the contents of a register literally and don't auto-indent
" <CTRL-R> <CTRL-P> {0-9a-z"%#*:=}: insert the contents of a register literally and fix indent.
" <CTRL-S>: (used for terminal control flow)
" <CTRL-T>: insert one shiftwidth of indent in current line
" <CTRL-U>: delete all entered characters in the current line
" <CTRL-V>{char}: insert next non-digit literally
" <CTRL-V>{number}: insert three digit decimal number as a single byte.
" <CTRL-W>: delete word before the cursor
" <CTRL-X>{mode}: enter CTRL-X sub mode, see |i_CTRL-X_index|
" <CTRL-Y>: insert the character which is above the cursor
" <CTRL-Z>: when 'insertmode' set: suspend Vim
" <Esc>: end insert mode (unless 'insertmode' set)
" <CTRL-[>: same as <Esc>
" <CTRL-\> <CTRL-N>: go to Normal mode
" <CTRL-\> <CTRL-G>: go to mode specified with 'insertmode'
" <CTRL-\> [a-z]: reserved for extensions
" <CTRL-\> [others]: NOT_USED
" <CTRL-]>: trigger abbreviation
" <CTRL-^>: toggle use of |:lmap| mappings
" <CTRL-_>: When 'allowrevins' set: change language (Hebrew, Farsi)
" NOTE: <Space> to '~'  NOT_USED, except '0' and '^' followed by CTRL-D
" 0 <CTRL-D>: delete all indent in the current line
" ^ <CTRL-D>: delete all indent in the current line, restore it in the next line
" <Del>: delete character under the cursor
" NOTE: Meta characters (0x80 to 0xff, 128 to 255) NOT_USED
" <Left>: cursor one character left
" <S-Left>: cursor one word left
" <C-Left>: cursor one word left
" <Right>: cursor one character right
" <S-Right>: cursor one word right
" <C-Right>: cursor one word right
" <Up>: cursor one line up
" <S-Up>: same as <PageUp>
" <Down>: cursor one line down
" <S-Down>: same as <PageDown>
" <Home>: cursor to start of line
" <C-Home>: cursor to start of file
" <End>: cursor past end of line
" <C-End>: cursor past end of file
" <PageUp>: one screenful backward
" <PageDown>: one screenful forward
" <F1>: same as <Help>
" <Help>: stop insert mode and display help window
" <Insert>: toggle Insert/Replace mode
" <LeftMouse>: cursor at mouse click
" <ScrollWheelDown>: move window three lines down
" <S-ScrollWheelDown>: move window one page down
" <ScrollWheelUp>: move window three lines up
" <S-ScrollWheelUp>: move window one page up
" <ScrollWheelLeft>: move window six columns left
" <S-ScrollWheelLeft>: move window one page left
" <ScrollWheelRight>: move window six columns right
" <S-ScrollWheelRight>: move window one page right
"
" commands in CTRL-X submode        *i_CTRL-X_index*
"
" <CTRL-X> <CTRL-D> complete defined identifiers
" <CTRL-X> <CTRL-E> scroll up
" <CTRL-X> <CTRL-F> complete file names
" <CTRL-X> <CTRL-I> complete identifiers
" <CTRL-X> <CTRL-K> complete identifiers from dictionary
" <CTRL-X> <CTRL-L> complete whole lines
" <CTRL-X> <CTRL-N> next completion
" <CTRL-X> <CTRL-O> omni completion
" <CTRL-X> <CTRL-P> previous completion
" <CTRL-X> <CTRL-S> spelling suggestions
" <CTRL-X> <CTRL-T> complete identifiers from thesaurus
" <CTRL-X> <CTRL-Y> scroll down
" <CTRL-X> <CTRL-U> complete with 'completefunc'
" <CTRL-X> <CTRL-V> complete like in : command line
" <CTRL-X> <CTRL-]> complete tags
" <CTRL-X> s        spelling suggestions
"
" -------------------------------------------------------------------------------------------------
" 2. Normal mode            *normal-index*
"
" CHAR   any non-blank character
" WORD   a sequence of non-blank characters
" N  a number entered before the command
" {motion} a cursor movement command
" Nmove  the text that is moved over with a {motion}
" SECTION  a section that possibly starts with '}' instead of '{'
"
" note: 1 = cursor movement command; 2 = can be undone/redone
"
" <CTRL-@>: NOT_USED
" <CTRL-A>: add N to number at/after cursor : 2
" <CTRL-B>: scroll N screens Backwards : 1
" <CTRL-C>: interrupt current (search) command
" <CTRL-D>: scroll Down N lines (default: half a screen)
" <CTRL-E>: scroll N lines upwards (N lines Extra)
" <CTRL-F>: scroll N screens Forward : 1
" <CTRL-G>: display current file name and position
" <BS>: same as "h" : 1
" <CTRL-H>: same as "h" : 1
" <Tab>: go to N newer entry in jump list : 1
" <CTRL-I>: same as <Tab> : 1
" <<NL>: same as "j" : 1
" <CTRL-J>: same as "j" : 1
" <CTRL-K>: NOT_USED
" <CTRL-L>: redraw screen
" <CR>: cursor to the first CHAR N lines lower : 1
" <CTRL-M>: same as <CR> : 1
" <CTRL-N>: same as "j" : 1
" <CTRL-O>: go to N older entry in jump list : 1
" <CTRL-P>: same as "k" : 1
" <CTRL-Q>: (used for terminal control flow)
" <CTRL-R>: redo changes which were undone with 'u' : 2
" <CTRL-S>: (used for terminal control flow)
" <CTRL-T>: jump to N older Tag in tag list
" <CTRL-U>: scroll N lines Upwards (default: half a screen)
" <CTRL-V>: start blockwise Visual mode
" <CTRL-W> {char}: window commands, see |CTRL-W|
" <CTRL-X>: subtract N from number at/after cursor : 2
" <CTRL-Y>: scroll N lines downwards
" <CTRL-Z>: suspend program (or start new shell)
" <CTRL-[> <Esc>: NOT_USED
" <CTRL-\> <CTRL-N>: go to Normal mode (no-op)
" <CTRL-\> <CTRL-G>: go to mode specified with 'insertmode'
" <CTRL-\> [a-z]: reserved for extensions
" <CTRL-\> [others]: NOT_USED
" <CTRL-]>: :ta to ident under cursor
" <CTRL-^>: edit Nth alternate file (equivalent to ":e #N")
" <CTRL-_>: NOT_USED
" <Space>>: same as "l" : 1
" !{motion}{filter}: filter Nmove text through the {filter} command : 2
" !!{filter}: filter N lines through the {filter} command
" "{a-zA-Z0-9.%#:-"}: use register {a-zA-Z0-9.%#:-"} for next delete, yank or put (uppercase to append) ({.%#:} only work with put)
" #: search backward for the Nth occurrence of the ident under the cursor : 1
" $: cursor to the end of Nth next line : 1
" %: find the next (curly/square) bracket on this line and go to its match, or go to matching comment bracket, or go to matching preprocessor directive. : 1
" {count}%: go to N percentage in the file
" &: repeat last :s : 2
" '{a-zA-Z0-9}: cursor to the first CHAR on the line with mark {a-zA-Z0-9}
" '': cursor to the first CHAR of the line where the cursor was before the latest jump. : 1
" '(: cursor to the first CHAR on the line of thestart of the current sentence : 1
" '): cursor to the first CHAR on the line of the end of the current sentence : 1
" '<: cursor to the first CHAR of the line where highlighted area starts/started in the current buffer.
" '>: cursor to the first CHAR of the line where highlighted area ends/ended in the current buffer. : 1
" '[: cursor to the first CHAR on the line of the start of last operated text or start of put text : 1
" ']: cursor to the first CHAR on the line of the end of last operated text or end of put text
" '{: cursor to the first CHAR on the line of the start of the current paragraph : 1
" '}: cursor to the first CHAR on the line of the end of the current paragraph
" (: cursor N sentences backward : 1
" ): cursor N sentences forward : 1
" *: search forward for the Nth occurrence of the ident under the cursor : 1
" +: same as <CR> : 1
" ,: repeat latest f, t, F or T in opposite direction N times : 1
" -: cursor to the first CHAR N lines higher : 1
" .: repeat last change with count replaced with N : 2
" /{pattern}<CR>  1  search forward for the Nth occurrence of {pattern} : 1
" /<CR>: search forward for {pattern} of last search : 1
" 0: cursor to the first char of the line : 1
" 1: prepend to command to give a count
" 2: "
" 3: "
" 4: "
" 5: "
" 6: "
" 7: "
" 8: "
" 9: "
" : start entering an Ex command : 1
" {count}: start entering an Ex command with range from current line to N-1 lines down
" ;: repeat latest f, t, F or T N times : 1
" <{motion}: shift Nmove lines one 'shiftwidth' leftwards : 2
" <<: shift N lines one 'shiftwidth' leftwards : 2
" ={motion}: filter Nmove lines through "indent" : 2
"  ==: filter N lines through "indent" : 2
" >{motion}: shift Nmove lines one 'shiftwidth' rightwards : 2
" >>: shift N lines one 'shiftwidth' rightwards
" ?{pattern}<CR>: search backward for the Nth previous occurrence of {pattern} : 1
" ?<CR>: search backward for {pattern} of last search
" @{a-z}: execute the contents of register {a-z} N times : 3
" @:: repeat the previous ":" command N times
" @@: repeat the previous @{a-z} N times : 2
" A: append text after the end of the line N times : 2
" B: cursor N WORDS backward : 1
" ["x]C: change from the cursor position to the end of the line, and N-1 more lines [into register x]; synonym for "c$" : 2
" ["x]D: delete the characters under the cursor until the end of the line and N-1 more lines [into register x]; synonym for "d$" : 2
" E: cursor forward to the end of WORD N : 1
" F{char}: cursor to the Nth occurrence of {char} to the left : 2
" G: cursor to line N, default last line : 2
" H: cursor to line N from top of screen : 2
" I: insert text before the first CHAR on the line N times : 2
" J: Join N lines; default is 2 : 2
" K: lookup Keyword under the cursor with 'keywordprg'
" L: cursor to line N from bottom of screen : 1
" M: cursor to middle line of screen : 1
" N: repeat the latest '/' or '?' N times in opposite direction : 1
" O: begin a new line above the cursor and insert text, repeat N times : 2
" ["x]P: put the text [from register x] before the cursor N times : 2
" Q: switch to "Ex" mode
" R: enter replace mode: overtype existing characters, repeat the entered text N-1 times : 2
" ["x]S: delete N lines [into register x] and start insert; synonym for "cc".
" T{char}: cursor till after Nth occurrence of {char} to the left : 2
" U: undo all latest changes on one line : 2
" V: start linewise Visual mode
" W: cursor N WORDS forward : 1
" ["x]X: delete N characters before the cursor [into register x] : 2
" ["x]Y: yank N lines [into register x]; synonym for "yy"
" ZZ: store current file if modified, and exit
" ZQ: exit current file always
" [{char}: square bracket command (see |[| below)
" \: NOT_USED
" ]{char}: square bracket command (see |]| below)
" ^: cursor to the first CHAR of the line : 1
" _: cursor to the first CHAR N - 1 lines lower : 1
" `{a-zA-Z0-9}: cursor to the mark {a-zA-Z0-9} : 1
" `(: cursor to the start of the current sentence : 1
" `): cursor to the end of the current sentence : 1
" `<: cursor to the start of the highlighted area : 1
" `>: cursor to the end of the highlighted area : 1
" `[: cursor to the start of last operated text or start of putted text : 1
" `]: cursor to the end of last operated text or end of putted text : 1
" ``: cursor to the position before latest jump : 1
" `{: cursor to the start of the current paragraph : 1
" `}: cursor to the end of the current paragraph : 1
" a: append text after the cursor N times : 2
" b: cursor N words backward : 1
" ["x]c{motion}: delete Nmove text [into register x] and start insert : 2
" ["x]cc: delete N lines [into register x] and start insert : 2
" ["x]d{motion}: delete Nmove text [into register x]
" ["x]dd: delete N lines [into register x] : 2
" do: same as ":diffget" : 2
" dp: same as ":diffput" : 2
" e: cursor forward to the end of word N : 1
" f{char}: cursor to Nth occurrence of {char} to the right : 1
" g{char}: extended commands, see |g| below
" h: cursor N chars to the left : 1
" i: insert text before the cursor N times : 2
" j: cursor N lines downward : 1
" k: cursor N lines upward : 1
" l: cursor N chars to the right : 1
" m{A-Za-z}    set mark {A-Za-z} at cursor position
" n: repeat the latest '/' or '?' N times : 1
" o: begin a new line below the cursor and insert text, repeat N times : 2
" ["x]p: put the text [from register x] after the cursor N times : 1
" q{0-9a-zA-Z"}: record typed characters into named register {0-9a-zA-Z"} (uppercase to append)
" q: (while recording) stops recording
" q:: edit : command-line in command-line window
" q/: edit / command-line in command-line window
" q?: edit ? command-line in command-line window
" r{char}: replace N chars with {char} : 2
" ["x]s: (substitute) delete N characters [into register x] and start insert : 2
" t{char}: cursor till before Nth occurrence of {char} to the right : 1
" u: undo changes : 2
" v: start characterwise Visual mode
" w: cursor N words forward : 1
" ["x]x: delete N characters under and after the cursor [into register x] : 2
" ["x]y{motion}: yank Nmove text [into register x]
" ["x]yy: yank N lines [into register x]
" z{char}: commands starting with 'z', see |z| below
" {: cursor N paragraphs backward : 1
" |: cursor to column N : 1
" }: cursor N paragraphs forward : 1
" ~: 'tildeop' off: switch case of N characters under cursor and move the cursor N characters to the right : 2
" ~{motion}: 'tildeop' on: switch case of Nmove text
" <C-End>: same as "G" : 1
" <C-Home>: same as "gg" : 1
" <C-Left>: same as "b" : 1
" <C-LeftMouse>: ":ta" to the keyword at the mouse click
" <C-Right>: same as "w" : 1
" <C-RightMouse>: same as "CTRL-T"
" ["x]<Del>: 1same as "x" : 2
" {count}<Del>: remove the last digit from {count}
" <Down>: same as "j" : 1
" <End>: same as "$" : 1
" <F1>: same as <Help>
" <Help>: open a help window
" <Home>: same as "0" : 1
" <Insert>: same as "i" : 2
" <Left>: same as "h" : 1
" <LeftMouse>: move cursor to the mouse click position : 1
" <MiddleMouse>: same as "gP" at the mouse click position : 2
" <PageDown>: same as CTRL-F
" <PageUp>: same as CTRL-B
" <Right>: same as "l" : 1
" <RightMouse>: start Visual mode, move cursor to the mouse click position
" <S-Down>: same as CTRL-F : 1
" <S-Left>: same as "b" : 1
" <S-LeftMouse>: same as "*" at the mouse click position
" <S-Right>: same as "w" : 1
" <S-RightMouse>: same as "#" at the mouse click position
" <S-Up>: same as CTRL-B : 1
" <Undo>: same as "u" : 2
" <Up>: same as "k" : 1
" <ScrollWheelDown>: move window three lines down
" <S-ScrollWheelDown>: move window one page down
" <ScrollWheelUp>: move window three lines up
" <S-ScrollWheelUp>: move window one page up
" <ScrollWheelLeft>: move window six columns left
" <S-ScrollWheelLeft>: move window one page left
" <ScrollWheelRight>: move window six columns right
" <S-ScrollWheelRight>: move window one page right
"
" -------------------------------------------------------------------------------------------------
" 2.1 Text objects            *objects*
"
" These can be used after an operator or in Visual mode to select an object.
"
" a": double quoted string
" a': single quoted string
" a(: same as ab
" a): same as ab
" a<: "a <>" from '<' to the matching '>'
" a>: same as a<
" aB: "a Block" from "[{" to "]}" (with brackets)
" aW: "a WORD" (with white space)
" a[: "a []" from '[' to the matching ']'
" a]: same as a[
" a`: string in backticks
" ab: "a block" from "[(" to "])" (with braces)
" ap: "a paragraph" (with white space)
" as: "a sentence" (with white space)
" at: "a tag block" (with white space)
" aw: "a word" (with white space)
" a{: same as aB
" a}: same as aB
" i": double quoted string without the quotes
" i': single quoted string without the quotes
" i(: same as ib
" i): same as ib
" i<: "inner <>" from '<' to the matching '>'
" i>: same as i<
" iB: "inner Block" from "[{" and "]}"
" iW: "inner WORD"
" i[: "inner []" from '[' to the matching ']'
" i]: same as i[
" i`: string in backticks without the backticks
" ib: "inner block" from "[(" to "])"
" ip: "inner paragraph"
" is: "inner sentence"
" it: "inner tag block"
" iw: "inner word"
" i{: same as iB
" i}: same as iB
"
" -------------------------------------------------------------------------------------------------
" 2.2 Window commands           *CTRL-W*
"
" <CTRL-W> <CTRL-B>: same as "CTRL-W b"
" <CTRL-W> <CTRL-C>: same as "CTRL-W c"
" <CTRL-W> <CTRL-D>: same as "CTRL-W d"
" <CTRL-W> <CTRL-F>: same as "CTRL-W f"
" <CTRL-W> <CTRL-G>: same as "CTRL-W g .."
" <CTRL-W> <CTRL-H>: same as "CTRL-W h"
" <CTRL-W> <CTRL-I>: same as "CTRL-W i"
" <CTRL-W> <CTRL-J>: same as "CTRL-W j"
" <CTRL-W> <CTRL-K>: same as "CTRL-W k"
" <CTRL-W> <CTRL-L>: same as "CTRL-W l"
" <CTRL-W> <CTRL-N>: same as "CTRL-W n"
" <CTRL-W> <CTRL-O>: same as "CTRL-W o"
" <CTRL-W> <CTRL-P>: same as "CTRL-W p"
" <CTRL-W> <CTRL-Q>: same as "CTRL-W q"
" <CTRL-W> <CTRL-R>: same as "CTRL-W r"
" <CTRL-W> <CTRL-S>: same as "CTRL-W s"
" <CTRL-W> <CTRL-T>: same as "CTRL-W t"
" <CTRL-W> <CTRL-V>: same as "CTRL-W v"
" <CTRL-W> <CTRL-W>: same as "CTRL-W w"
" <CTRL-W> <CTRL-X>: same as "CTRL-W x"
" <CTRL-W> <CTRL-Z>: same as "CTRL-W z"
" <CTRL-W> <CTRL-]>: same as "CTRL-W ]"
" <CTRL-W> <CTRL-^>: same as "CTRL-W ^"
" <CTRL-W> <CTRL-_>: same as "CTRL-W _"
" <CTRL-W> +: increase current window height N lines
" <CTRL-W> -: decrease current window height N lines
" <CTRL-W> <: decrease current window width N columns
" <CTRL-W> =: make all windows the same height & width
" <CTRL-W> >: increase current window width N columns
" <CTRL-W> H: move current window to the far left
" <CTRL-W> J: move current window to the very bottom
" <CTRL-W> K: move current window to the very top
" <CTRL-W> L: move current window to the far right
" <CTRL-W> P: go to preview window
" <CTRL-W> R: rotate windows upwards N times
" <CTRL-W> S: same as "CTRL-W s"
" <CTRL-W> T: move current window to a new tab page
" <CTRL-W> W: go to N previous window (wrap around)
" <CTRL-W> ]: split window and jump to tag under cursor
" <CTRL-W> ^: split current window and edit alternate file N
" <CTRL-W> _: set current window height to N (default: very high)
" <CTRL-W> b: go to bottom window
" <CTRL-W> c: close current window (like |:close|)
" <CTRL-W> d: split window and jump to definition under the cursor
" <CTRL-W> f: split window and edit file name under the cursor
" <CTRL-W> F: split window and edit file name under the cursor and jump to the line number following the file name.
" <CTRL-W> g <CTRL-]>: split window and do |:tjump| to tag under cursor
" <CTRL-W> g ]: split window and do |:tselect| for tag under cursor
" <CTRL-W> g }: do a |:ptjump| to the tag under the cursor
" <CTRL-W> g f: edit file name under the cursor in a new tab page
" <CTRL-W> g F: edit file name under the cursor in a new tab page and jump to the line number following the file name.
" <CTRL-W> h: go to Nth left window (stop at first window)
" <CTRL-W> i: split window and jump to declaration of identifier under the cursor
" <CTRL-W> j: go N windows down (stop at last window)
" <CTRL-W> k: go N windows up (stop at first window)
" <CTRL-W> l: go to Nth right window (stop at last window)
" <CTRL-W> n: open new window, N lines high
" <CTRL-W> o: close all but current window (like |:only|)
" <CTRL-W> p: go to previous (last accessed) window
" <CTRL-W> q: quit current window (like |:quit|)
" <CTRL-W> r: rotate windows downwards N times
" <CTRL-W> s: split current window in two parts, new window N lines high
" <CTRL-W> t: go to top window
" <CTRL-W> v: split current window vertically, new window N columns wide
" <CTRL-W> w: go to N next window (wrap around)
" <CTRL-W> x: exchange current window with window N (default: next window)
" <CTRL-W> z: close preview window
" <CTRL-W> |: set window width to N columns
" <CTRL-W> }: show tag under cursor in preview window
" <CTRL-W> <Down>: same as "CTRL-W j"
" <CTRL-W> <Up>: same as "CTRL-W k"
" <CTRL-W> <Left>: same as "CTRL-W h"
" <CTRL-W> <Right>: same as "CTRL-W l"
"
" -------------------------------------------------------------------------------------------------
" 2.3 Square bracket commands         *[* *]*
"
" |[_CTRL-D|  [ CTRL-D     jump to first #define found in current and
"            included files matching the word under the
"            cursor, start searching at beginning of
"            current file
" |[_CTRL-I|  [ CTRL-I     jump to first line in current and included
"            files that contains the word under the
"            cursor, start searching at beginning of
"            current file
" |[#|    [#    1  cursor to N previous unmatched #if, #else
"            or #ifdef
" |['|    ['    1  cursor to previous lowercase mark, on first
"            non-blank
" |[(|    [(    1  cursor N times back to unmatched '('
" |[star|   [*    1  same as "[/"
" |[`|    [`    1  cursor to previous lowercase mark
" |[/|    [/    1  cursor to N previous start of a C comment
" |[D|    [D       list all defines found in current and
"            included files matching the word under the
"            cursor, start searching at beginning of
"            current file
" |[I|    [I       list all lines found in current and
"            included files that contain the word under
"            the cursor, start searching at beginning of
"            current file
" |[P|    [P    2  same as "[p"
" |[[|    [[    1  cursor N sections backward
" |[]|    []    1  cursor N SECTIONS backward
" |[c|    [c    1  cursor N times backwards to start of change
" |[d|    [d       show first #define found in current and
"            included files matching the word under the
"            cursor, start searching at beginning of
"            current file
" |[f|    [f       same as "gf"
" |[i|    [i       show first line found in current and
"            included files that contains the word under
"            the cursor, start searching at beginning of
"            current file
" |[m|    [m    1  cursor N times back to start of member
"            function
" |[p|    [p    2  like "P", but adjust indent to current line
" |[s|    [s    1  move to the previous misspelled word
" |[z|    [z    1  move to start of open fold
" |[{|    [{    1  cursor N times back to unmatched '{'
" |[<MiddleMouse>| [<MiddleMouse> 2  same as "[p"
"
" |]_CTRL-D|  ] CTRL-D     jump to first #define found in current and
"            included files matching the word under the
"            cursor, start searching at cursor position
" |]_CTRL-I|  ] CTRL-I     jump to first line in current and included
"            files that contains the word under the
"            cursor, start searching at cursor position
" |]#|    ]#    1  cursor to N next unmatched #endif or #else
" |]'|    ]'    1  cursor to next lowercase mark, on first
"            non-blank
" |])|    ])    1  cursor N times forward to unmatched ')'
" |]star|   ]*    1  same as "]/"
" |]`|    ]`    1  cursor to next lowercase mark
" |]/|    ]/    1  cursor to N next end of a C comment
" |]D|    ]D       list all #defines found in current and
"            included files matching the word under the
"            cursor, start searching at cursor position
" |]I|    ]I       list all lines found in current and
"            included files that contain the word under
"            the cursor, start searching at cursor
"            position
" |]P|    ]P    2  same as "[p"
" |][|    ][    1  cursor N SECTIONS forward
" |]]|    ]]    1  cursor N sections forward
" |]c|    ]c    1  cursor N times forward to start of change
" |]d|    ]d       show first #define found in current and
"            included files matching the word under the
"            cursor, start searching at cursor position
" |]f|    ]f       same as "gf"
" |]i|    ]i       show first line found in current and
"            included files that contains the word under
"            the cursor, start searching at cursor
"            position
" |]m|    ]m    1  cursor N times forward to end of member
"            function
" |]p|    ]p    2  like "p", but adjust indent to current line
" |]s|    ]s    1  move to next misspelled word
" |]z|    ]z    1  move to end of open fold
" |]}|    ]}    1  cursor N times forward to unmatched '}'
" |]<MiddleMouse>| ]<MiddleMouse> 2  same as "]p"
"
" ==============================================================================
" 2.4 Commands starting with 'g'            *g*
"
" tag   char        note action in Normal mode  ~
" ------------------------------------------------------------------------------
" |g_CTRL-A|  g CTRL-A     only when compiled with MEM_PROFILE
"            defined: dump a memory profile
" |g_CTRL-G|  g CTRL-G     show information about current cursor
"            position
" |g_CTRL-H|  g CTRL-H     start Select block mode
" |g_CTRL-]|  g CTRL-]     |:tjump| to the tag under the cursor
" |g#|    g#    1  like "#", but without using "\<" and "\>"
" |g$|    g$    1  when 'wrap' off go to rightmost character of
"            the current line that is on the screen;
"            when 'wrap' on go to the rightmost character
"            of the current screen line
" |g&|    g&    2  repeat last ":s" on all lines
" |g'|    g'{mark}  1  like |'| but without changing the jumplist
" |g`|    g`{mark}  1  like |`| but without changing the jumplist
" |gstar|   g*    1  like "*", but without using "\<" and "\>"
" |g+|    g+       go to newer text state N times
" |g,|    g,    1  go to N newer position in change list
" |g-|    g-       go to older text state N times
" |g0|    g0    1  when 'wrap' off go to leftmost character of
"            the current line that is on the screen;
"            when 'wrap' on go to the leftmost character
"            of the current screen line
" |g8|    g8       print hex value of bytes used in UTF-8
"            character under the cursor
" |g;|    g;    1  go to N older position in change list
" |g<|    g<       display previous command output
" |g?|    g?    2  Rot13 encoding operator
" |g?g?|    g??   2  Rot13 encode current line
" |g?g?|    g?g?    2  Rot13 encode current line
" |gD|    gD    1  go to definition of word under the cursor
"            in current file
" |gE|    gE    1  go backwards to the end of the previous
"            WORD
" |gH|    gH       start Select line mode
" |gI|    gI    2  like "I", but always start in column 1
" |gJ|    gJ    2  join lines without inserting space
" |gN|    gN        1,2  find the previous match with the last used
"            search pattern and Visually select it
" |gP|    ["x]gP    2  put the text [from register x] before the
"            cursor N times, leave the cursor after it
" |gQ|    gQ        switch to "Ex" mode with Vim editing
" |gR|    gR    2  enter Virtual Replace mode
" |gT|    gT       go to the previous tab page
" |gU|    gU{motion}  2  make Nmove text uppercase
" |gV|    gV       don't reselect the previous Visual area
"            when executing a mapping or menu in Select
"            mode
" |g]|    g]       :tselect on the tag under the cursor
" |g^|    g^    1  when 'wrap' off go to leftmost non-white
"            character of the current line that is on
"            the screen; when 'wrap' on go to the
"            leftmost non-white character of the current
"            screen line
" |g_|    g_    1  cursor to the last CHAR N - 1 lines lower
" |ga|    ga       print ascii value of character under the
"            cursor
" |gd|    gd    1  go to definition of word under the cursor
"            in current function
" |ge|    ge    1  go backwards to the end of the previous
"            word
" |gf|    gf       start editing the file whose name is under
"            the cursor
" |gF|    gF       start editing the file whose name is under
"            the cursor and jump to the line number
"            following the filename.
" |gg|    gg    1  cursor to line N, default first line
" |gh|    gh       start Select mode
" |gi|    gi    2  like "i", but first move to the |'^| mark
" |gj|    gj    1  like "j", but when 'wrap' on go N screen
"            lines down
" |gk|    gk    1  like "k", but when 'wrap' on go N screen
"            lines up
" |gn|    gn        1,2  find the next match with the last used
"            search pattern and Visually select it
" |gm|    gm    1  go to character at middle of the screenline
" |go|    go    1  cursor to byte N in the buffer
" |gp|    ["x]gp    2  put the text [from register x] after the
"            cursor N times, leave the cursor after it
" |gq|    gq{motion}  2  format Nmove text
" |gr|    gr{char}  2  virtual replace N chars with {char}
" |gs|    gs       go to sleep for N seconds (default 1)
" |gt|    gt       go to the next tab page
" |gu|    gu{motion}  2  make Nmove text lowercase
" |gv|    gv       reselect the previous Visual area
" |gw|    gw{motion}  2  format Nmove text and keep cursor
" |netrw-gx|  gx       execute application for file name under the
"            cursor (only with |netrw| plugin)
" |g@|    g@{motion}     call 'operatorfunc'
" |g~|    g~{motion}  2  swap case for Nmove text
" |g<Down>| g<Down>   1  same as "gj"
" |g<End>|  g<End>    1  same as "g$"
" |g<Home>| g<Home>   1  same as "g0"
" |g<LeftMouse>|  g<LeftMouse>     same as <C-LeftMouse>
"     g<MiddleMouse>     same as <C-MiddleMouse>
" |g<RightMouse>| g<RightMouse>    same as <C-RightMouse>
" |g<Up>|   g<Up>   1  same as "gk"
"
" ==============================================================================
" 2.5 Commands starting with 'z'            *z*
"
" tag   char        note action in Normal mode  ~
" ------------------------------------------------------------------------------
" |z<CR>|   z<CR>      redraw, cursor line to top of window,
"            cursor on first non-blank
" |zN<CR>|  z{height}<CR>    redraw, make window {height} lines high
" |z+|    z+       cursor on line N (default line below
"            window), otherwise like "z<CR>"
" |z-|    z-       redraw, cursor line at bottom of window,
"            cursor on first non-blank
" |z.|    z.       redraw, cursor line to center of window,
"            cursor on first non-blank
" |z=|    z=       give spelling suggestions
" |zA|    zA       open a closed fold or close an open fold
"            recursively
" |zC|    zC       close folds recursively
" |zD|    zD       delete folds recursively
" |zE|    zE       eliminate all folds
" |zF|    zF       create a fold for N lines
" |zG|    zG       mark word as good spelled word
" |zH|    zH       when 'wrap' off scroll half a screenwidth
"            to the right
" |zL|    zL       when 'wrap' off scroll half a screenwidth
"            to the left
" |zM|    zM       set 'foldlevel' to zero
" |zN|    zN       set 'foldenable'
" |zO|    zO       open folds recursively
" |zR|    zR       set 'foldlevel' to the deepest fold
" |zW|    zW       mark word as wrong (bad) spelled word
" |zX|    zX       re-apply 'foldlevel'
" |z^|    z^       cursor on line N (default line above
"            window), otherwise like "z-"
" |za|    za       open a closed fold, close an open fold
" |zb|    zb       redraw, cursor line at bottom of window
" |zc|    zc       close a fold
" |zd|    zd       delete a fold
" |ze|    ze       when 'wrap' off scroll horizontally to
"            position the cursor at the end (right side)
"            of the screen
" |zf|    zf{motion}     create a fold for Nmove text
" |zg|    zg       mark word as good spelled word
" |zh|    zh       when 'wrap' off scroll screen N characters
"            to the right
" |zi|    zi       toggle 'foldenable'
" |zj|    zj    1  move to the start of the next fold
" |zk|    zk    1  move to the end of the previous fold
" |zl|    zl       when 'wrap' off scroll screen N characters
"            to the left
" |zm|    zm       subtract one from 'foldlevel'
" |zn|    zn       reset 'foldenable'
" |zo|    zo       open fold
" |zr|    zr       add one to 'foldlevel'
" |zs|    zs       when 'wrap' off scroll horizontally to
"            position the cursor at the start (left
"            side) of the screen
" |zt|    zt       redraw, cursor line at top of window
" |zv|    zv       open enough folds to view the cursor line
" |zw|    zw       mark word as wrong (bad) spelled word
" |zx|    zx       re-apply 'foldlevel' and do "zv"
" |zz|    zz       redraw, cursor line at center of window
" |z<Left>| z<Left>      same as "zh"
" |z<Right>|  z<Right>     same as "zl"
"
" ==============================================================================
" 3. Visual mode            *visual-index*
"
" Most commands in Visual mode are the same as in Normal mode.  The ones listed
" here are those that are different.
"
" tag   command       note action in Visual mode  ~
" ------------------------------------------------------------------------------
" |v_CTRL-\_CTRL-N| CTRL-\ CTRL-N    stop Visual mode
" |v_CTRL-\_CTRL-G| CTRL-\ CTRL-G    go to mode specified with 'insertmode'
" |v_CTRL-A|  CTRL-A    2  add N to number in highlighted text
" |v_CTRL-C|  CTRL-C       stop Visual mode
" |v_CTRL-G|  CTRL-G       toggle between Visual mode and Select mode
" |v_<BS>|  <BS>    2  Select mode: delete highlighted area
" |v_CTRL-H|  CTRL-H    2  same as <BS>
" |v_CTRL-O|  CTRL-O       switch from Select to Visual mode for one
"            command
" |v_CTRL-V|  CTRL-V       make Visual mode blockwise or stop Visual
"            mode
" |v_CTRL-X|  CTRL-X    2  subtract N from number in highlighted text
" |v_<Esc>| <Esc>      stop Visual mode
" |v_CTRL-]|  CTRL-]       jump to highlighted tag
" |v_!|   !{filter} 2  filter the highlighted lines through the
"            external command {filter}
" |v_:|   :      start a command-line with the highlighted
"            lines as a range
" |v_<|   <   2  shift the highlighted lines one
"            'shiftwidth' left
" |v_=|   =   2  filter the highlighted lines through the
"            external program given with the 'equalprg'
"            option
" |v_>|   >   2  shift the highlighted lines one
"            'shiftwidth' right
" |v_b_A|   A   2  block mode: append same text in all lines,
"            after the highlighted area
" |v_C|   C   2  delete the highlighted lines and start
"            insert
" |v_D|   D   2  delete the highlighted lines
" |v_b_I|   I   2  block mode: insert same text in all lines,
"            before the highlighted area
" |v_J|   J   2  join the highlighted lines
" |v_K|   K      run 'keywordprg' on the highlighted area
" |v_O|   O      Move horizontally to other corner of area.
"     Q      does not start Ex mode
" |v_R|   R   2  delete the highlighted lines and start
"            insert
" |v_S|   S   2  delete the highlighted lines and start
"            insert
" |v_U|   U   2  make highlighted area uppercase
" |v_V|   V      make Visual mode linewise or stop Visual
"            mode
" |v_X|   X   2  delete the highlighted lines
" |v_Y|   Y      yank the highlighted lines
" |v_aquote|  a"       extend highlighted area with a double
"            quoted string
" |v_a'|    a'       extend highlighted area with a single
"            quoted string
" |v_a(|    a(       same as ab
" |v_a)|    a)       same as ab
" |v_a<|    a<       extend highlighted area with a <> block
" |v_a>|    a>       same as a<
" |v_aB|    aB       extend highlighted area with a {} block
" |v_aW|    aW       extend highlighted area with "a WORD"
" |v_a[|    a[       extend highlighted area with a [] block
" |v_a]|    a]       same as a[
" |v_a`|    a`       extend highlighted area with a backtick
"            quoted string
" |v_ab|    ab       extend highlighted area with a () block
" |v_ap|    ap       extend highlighted area with a paragraph
" |v_as|    as       extend highlighted area with a sentence
" |v_at|    at       extend highlighted area with a tag block
" |v_aw|    aw       extend highlighted area with "a word"
" |v_a{|    a{       same as aB
" |v_a}|    a}       same as aB
" |v_c|   c   2  delete highlighted area and start insert
" |v_d|   d   2  delete highlighted area
" |v_g_CTRL-A|  g CTRL-A  2  add N to number in highlighted text
" |v_g_CTRL-X|  g CTRL-X  2  subtract N from number in highlighted text
" |v_gJ|    gJ    2  join the highlighted lines without
"            inserting spaces
" |v_gq|    gq    2  format the highlighted lines
" |v_gv|    gv       exchange current and previous highlighted
"            area
" |v_iquote|  i"       extend highlighted area with a double
"            quoted string (without quotes)
" |v_i'|    i'       extend highlighted area with a single
"            quoted string (without quotes)
" |v_i(|    i(       same as ib
" |v_i)|    i)       same as ib
" |v_i<|    i<       extend highlighted area with inner <> block
" |v_i>|    i>       same as i<
" |v_iB|    iB       extend highlighted area with inner {} block
" |v_iW|    iW       extend highlighted area with "inner WORD"
" |v_i[|    i[       extend highlighted area with inner [] block
" |v_i]|    i]       same as i[
" |v_i`|    i`       extend highlighted area with a backtick
"            quoted string (without the backticks)
" |v_ib|    ib       extend highlighted area with inner () block
" |v_ip|    ip       extend highlighted area with inner paragraph
" |v_is|    is       extend highlighted area with inner sentence
" |v_it|    it       extend highlighted area with inner tag block
" |v_iw|    iw       extend highlighted area with "inner word"
" |v_i{|    i{       same as iB
" |v_i}|    i}       same as iB
" |v_o|   o      move cursor to other corner of area
" |v_r|   r   2  delete highlighted area and start insert
" |v_s|   s   2  delete highlighted area and start insert
" |v_u|   u   2  make highlighted area lowercase
" |v_v|   v      make Visual mode characterwise or stop
"            Visual mode
" |v_x|   x   2  delete the highlighted area
" |v_y|   y      yank the highlighted area
" |v_~|   ~   2  swap case for the highlighted area
"
" ==============================================================================
" 4. Command-line editing         *ex-edit-index*
"
" Get to the command-line with the ':', '!', '/' or '?' commands.
" Normal characters are inserted at the current cursor position.
" "Completion" below refers to context-sensitive completion.  It will complete
" file names, tags, commands etc. as appropriate.
"
" tag   command       action in Command-line editing mode ~
" ------------------------------------------------------------------------------
"     CTRL-@    not used
" |c_CTRL-A|  CTRL-A    do completion on the pattern in front of the
"         cursor and insert all matches
" |c_CTRL-B|  CTRL-B    cursor to begin of command-line
" |c_CTRL-C|  CTRL-C    same as <Esc>
" |c_CTRL-D|  CTRL-D    list completions that match the pattern in
"         front of the cursor
" |c_CTRL-E|  CTRL-E    cursor to end of command-line
" |'cedit'| CTRL-F    default value for 'cedit': opens the
"         command-line window; otherwise not used
" |c_CTRL-G|  CTRL-G    next match when 'incsearch' is active
" |c_<BS>|  <BS>    delete the character in front of the cursor
" |c_digraph| {char1} <BS> {char2}
"         enter digraph when 'digraph' is on
" |c_CTRL-H|  CTRL-H    same as <BS>
" |c_<Tab>| <Tab>   if 'wildchar' is <Tab>: Do completion on
"         the pattern in front of the cursor
" |c_<S-Tab>| <S-Tab>   same as CTRL-P
" |c_wildchar|  'wildchar'  Do completion on the pattern in front of the
"         cursor (default: <Tab>)
" |c_CTRL-I|  CTRL-I    same as <Tab>
" |c_<NL>|  <NL>    same as <CR>
" |c_CTRL-J|  CTRL-J    same as <CR>
" |c_CTRL-K|  CTRL-K {char1} {char2}
"         enter digraph
" |c_CTRL-L|  CTRL-L    do completion on the pattern in front of the
"         cursor and insert the longest common part
" |c_<CR>|  <CR>    execute entered command
" |c_CTRL-M|  CTRL-M    same as <CR>
" |c_CTRL-N|  CTRL-N    after using 'wildchar' with multiple matches:
"         go to next match, otherwise: recall older
"         command-line from history.
"     CTRL-O    not used
" |c_CTRL-P|  CTRL-P    after using 'wildchar' with multiple matches:
"         go to previous match, otherwise: recall older
"         command-line from history.
" |c_CTRL-Q|  CTRL-Q    same as CTRL-V, unless it's used for terminal
"         control flow
" |c_CTRL-R|  CTRL-R {0-9a-z"%#*:= CTRL-F CTRL-P CTRL-W CTRL-A}
"         insert the contents of a register or object
"         under the cursor as if typed
" |c_CTRL-R_CTRL-R| CTRL-R CTRL-R {0-9a-z"%#*:= CTRL-F CTRL-P CTRL-W CTRL-A}
"         insert the contents of a register or object
"         under the cursor literally
"     CTRL-S    (used for terminal control flow)
" |c_CTRL-T|  CTRL-T    previous match when 'incsearch' is active
" |c_CTRL-U|  CTRL-U    remove all characters
" |c_CTRL-V|  CTRL-V    insert next non-digit literally, insert three
"         digit decimal number as a single byte.
" |c_CTRL-W|  CTRL-W    delete the word in front of the cursor
"     CTRL-X    not used (reserved for completion)
"     CTRL-Y    copy (yank) modeless selection
"     CTRL-Z    not used (reserved for suspend)
" |c_<Esc>| <Esc>   abandon command-line without executing it
" |c_CTRL-[|  CTRL-[    same as <Esc>
" |c_CTRL-\_CTRL-N| CTRL-\ CTRL-N go to Normal mode, abandon command-line
" |c_CTRL-\_CTRL-G| CTRL-\ CTRL-G go to mode specified with 'insertmode',
"         abandon command-line
"     CTRL-\ a - d  reserved for extensions
" |c_CTRL-\_e|  CTRL-\ e {expr} replace the command line with the result of
"         {expr}
"     CTRL-\ f - z  reserved for extensions
"     CTRL-\ others not used
" |c_CTRL-]|  CTRL-]    trigger abbreviation
" |c_CTRL-^|  CTRL-^    toggle use of |:lmap| mappings
" |c_CTRL-_|  CTRL-_    when 'allowrevins' set: change language
"         (Hebrew, Farsi)
" |c_<Del>| <Del>   delete the character under the cursor
"
" |c_<Left>|  <Left>    cursor left
" |c_<S-Left>|  <S-Left>  cursor one word left
" |c_<C-Left>|  <C-Left>  cursor one word left
" |c_<Right>| <Right>   cursor right
" |c_<S-Right>| <S-Right> cursor one word right
" |c_<C-Right>| <C-Right> cursor one word right
" |c_<Up>|  <Up>    recall previous command-line from history that
"         matches pattern in front of the cursor
" |c_<S-Up>|  <S-Up>    recall previous command-line from history
" |c_<Down>|  <Down>    recall next command-line from history that
"         matches pattern in front of the cursor
" |c_<S-Down>|  <S-Down>  recall next command-line from history
" |c_<Home>|  <Home>    cursor to start of command-line
" |c_<End>| <End>   cursor to end of command-line
" |c_<PageDown>|  <PageDown>  same as <S-Down>
" |c_<PageUp>|  <PageUp>  same as <S-Up>
" |c_<Insert>|  <Insert>  toggle insert/overstrike mode
" |c_<LeftMouse>| <LeftMouse> cursor at mouse click

" -------------------------------------------------------------------------------------------------
" vim: cc=120
