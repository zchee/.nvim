;; extends
;
; Code token from: https://github.com/ray-x/go.nvim/blob/master/after/queries/go/injections.scm

; inject sql in single line strings
; e.g. db.GetContext(ctx, "SELECT * FROM users WHERE name = 'John'")
; following no longer works after https://github.com/tree-sitter/tree-sitter-go/commit/47e8b1fae7541f6e01cead97201be19321ec362a
; ((call_expression
;   (selector_expression
;     field: (field_identifier) @_field)
;   (argument_list
;     (interpreted_string_literal) @sql))
;   (#any-of? @_field "Exec" "GetContext" "ExecContext" "SelectContext" "In"
; 				            "RebindNamed" "Rebind" "Query" "QueryRow" "QueryRowxContext" "NamedExec" "MustExec" "Get" "Queryx")
;   (#offset! @sql 0 1 0 -1))
;
; ; still buggy for nvim 0.10
; ((call_expression
;   (selector_expression
;     field: (field_identifier) @_field (#any-of? @_field "Exec" "GetContext" "ExecContext" "SelectContext" "In" "RebindNamed" "Rebind" "Query" "QueryRow" "QueryRowxContext" "NamedExec" "MustExec" "Get" "Queryx"))
;   (argument_list
;     (interpreted_string_literal) @injection.content))
;   (#offset! @injection.content 0 1 0 -1)
;   (#set! injection.language "sql"))

; One pattern, anchored at the start of the string's content, so an
; import path or a sentence that merely mentions SQL stays plain: the
; content opens with an upper-case statement keyword followed by more
; text, with a lower-case select/insert/update/delete that later reaches
; from/into/set/values, or with a "-- sql" marker. Any leading SQL
; comments are skipped first, whole "--" lines and /* */ blocks with
; whitespace between them, since sqlc writes "-- name: GetUser :one"
; above every query; a string holding only comments stays plain unless
; one of them is the "-- sql" marker. A "--"
; comment runs to a line break and a block ends at its first */, so a
; text splits into comments one way only and a string that is not SQL
; fails fast even on the backtracking engine. #match? compiles a vim
; regex and matches the whole text as one string, where \s, \_s and \n
; never match a newline character and [^\n] does not exclude one;
; [[:space:]], . and [\d10] match it and [^\d10] excludes it. An
; interpreted string has one content node per run between escape
; sequences and each run is matched on its own, so a "--" comment there
; never ends but "-- c\nSELECT 1" still injects its "SELECT 1" run. The
; *_string_literal_content nodes already exclude the quotes, so no
; #offset! here.
([
  (interpreted_string_literal_content)
  (raw_string_literal_content)
  ] @injection.content
 (#match? @injection.content "\\v^%([[:space:]]*%(--[^\\d10]*[\\d10]|/\\*%([^*]|\\*+[^*/])*\\*+/))*[[:space:]]*(--[[:space:]]*sql>|(SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER|DROP|WITH|TRUNCATE|REPLACE|MERGE|GRANT|REVOKE|EXPLAIN|BEGIN|COMMIT|ROLLBACK)[[:space:]]+\\S|(select|insert|update|delete)[[:space:]].{-}<(from|into|set|values)>)")
 (#set! injection.language "sql"))

; should I use a more exhaustive list of keywords?
;  "ADD" "ADD CONSTRAINT" "ALL" "ALTER" "AND" "ASC" "COLUMN" "CONSTRAINT" "CREATE" "DATABASE" "DELETE" "DESC" "DISTINCT" "DROP" "EXISTS" "FOREIGN KEY" "FROM" "JOIN" "GROUP BY" "HAVING" "IN" "INDEX" "INSERT INTO" "LIKE" "LIMIT" "NOT" "NOT NULL" "OR" "ORDER BY" "PRIMARY KEY" "SELECT" "SET" "TABLE" "TRUNCATE TABLE" "UNION" "UNIQUE" "UPDATE" "VALUES" "WHERE"

; json
;
; Capture the content child: an injection drops the ranges of the
; captured node's children, so capturing raw_string_literal itself
; leaves nothing to inject.

(const_spec
  name: (identifier)
  value: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)
   (#lua-match? @injection.content "^[\n|\t| ]*\{.*\}[\n|\t| ]*$")
   (#set! injection.language "json")))

(short_var_declaration
    left: (expression_list (identifier))
    right: (expression_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content))
  (#lua-match? @injection.content "^[\n|\t| ]*\{.*\}[\n|\t| ]*$")
  (#set! injection.language "json"))

(var_spec
  name: (identifier)
  value: (expression_list
    (raw_string_literal
      (raw_string_literal_content) @injection.content)
   (#lua-match? @injection.content "^[\n|\t| ]*\{.*\}[\n|\t| ]*$")
   (#set! injection.language "json")))

; ----------------------------------------------------------------
; printf format verbs inside raw string literals
;
; Upstream nvim-treesitter only injects the printf parser into
; (interpreted_string_literal), so `fmt.Fprintf(&req, `GET %s%s`, ...)`
; loses the @character.printf highlight that the quoted form gets.

((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    .
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
 (#any-of? @_method "Printf" "Sprintf" "Fatalf" "Scanf" "Errorf" "Skipf" "Logf")
 (#set! injection.language "printf"))

((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    (_)
    .
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
 (#any-of? @_method "Fprintf" "Fscanf" "Appendf" "Sscanf")
 (#set! injection.language "printf"))
