; extends

; ((identifier) @conditional.case (#eq? @conditional.case "case"))
; ((identifier) @conditional.default (#eq? @conditional.default "default"))
[ "case" ] @keyword.case
[ "default" ] @keyword.defer
[ "defer" ] @keyword.defer

((identifier) @variable.err (#eq? @variable.err "err"))
((type_identifier) @type.builtin.error (#eq? @type.builtin.error "error"))
((type_identifier) @type.builtin.any (#eq? @type.builtin.any "any"))
; (format_verb) @format_verb.go (#lua-match? @format_verb.go "\%[a-x,A-X,\%]")
((type_identifier) @conditional.type (#eq? @conditional.type "type"))

(raw_string_literal) @string.raw_string_literal

((call_expression (identifier) @function.call.builtin_type)
 ((#any-of? @function.call.builtin_type
           "any"
           "bool"
           "byte"
           "comparable"
           "complex128"
           "complex64"
           "error"
           "float32"
           "float64"
           "int"
           "int16"
           "int32"
           "int64"
           "int8"
           "rune"
           "string"
           "uint"
           "uint16"
           "uint32"
           "uint64"
           "uint8"
           "uintptr")))

((call_expression (identifier) @function.call.builtin_type.any)
 ((#any-of? @function.call.builtin_type.any "any")))

((import_spec (interpreted_string_literal) @namespace.package)
 (#lua-match? @namespace.package "[a-z,A-Z-\/]"))

((comment) @comment.documentation.pragma
 (#lua-match? @comment.documentation.pragma "^\/\/go\:.*"))

((const_spec (expression_list) @spell.const_string_literal)
 (#lua-match? @spell.const_string_literal "[a-z,A-Z-\/]"))

((call_expression (rune_literal) @string.rune_literal)
 (#lua-match? @string.rune_literal "[a-z,A-Z-\/]"))
          ; (expression_statement ; [39, 2] - [39, 20]
          ;   (call_expression ; [39, 2] - [39, 20]
          ;     function: (selector_expression ; [39, 2] - [39, 15]
          ;       operand: (identifier) ; [39, 2] - [39, 5]
          ;       field: (field_identifier)) ; [39, 6] - [39, 15]
          ;     arguments: (argument_list ; [39, 15] - [39, 20]
          ;       (rune_literal)))))) ; [39, 16] - [39, 19]
