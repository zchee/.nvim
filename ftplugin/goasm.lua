-- Plan 9 assembly as Go's assembler accepts it. lua/filetypes/goasm.lua
-- detects the filetype with a function, which
-- vim.filetype._get_known_filetypes cannot see, so this runtime file is also
-- what keeps `:checkhealth vim.lsp` from reporting goasm (in
-- lsp/asm_lsp.lua's filetypes) as an unknown filetype.
--
-- Go's assembler takes Go's comment syntax; the inherited 'comments' value
-- already covers // and /* */.
vim.opt_local.commentstring = "// %s"
