;; extends

; nvim-treesitter ships its own markdown_inline highlights.scm without the
; ";; extends" modeline, so it replaces the $VIMRUNTIME query as the base and
; drops the runtime's backslash-escape conceal rules. Restore them here so
; escaped Markdown punctuation in LSP hover responses (e.g. basedpyright's
; "\.") renders as "." in conceal-enabled windows such as the hover.nvim
; float, which sets conceallevel=2. The #offset! trims the conceal range to
; the backslash only, keeping the escaped character visible.
((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))

; Conceal backslash in hard line breaks
((hard_line_break
  "\\" @conceal)
  (#set! conceal ""))
