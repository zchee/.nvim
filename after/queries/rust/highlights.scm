;; extends

; tree-sitter parses a macro invocation body as a flat token_tree, so nothing
; inside `invocations!` carries Rust semantics: every name arrives as a bare
; identifier and lands on @variable, which is a shade off Normal and reads as
; unhighlighted. The DSL's own grammar survives in the token shape though, and
; `field: kind "flag";` is the only statement form it has (the flag is absent
; for the positional and trailing kinds), so match on that.
((macro_invocation
   macro: (identifier) @_macro
   (token_tree
     (token_tree
       (identifier) @property
       .
       ":"
       .
       (identifier) @keyword
       .
       [
         (string_literal)
         ";"
       ])))
 (#eq? @_macro "invocations")
 ; the base query also captures these identifiers as @variable; equal priority
 ; leaves the winner up to match order, so claim it outright.
 (#set! priority 110))
