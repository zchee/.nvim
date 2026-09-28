-- Metal Shading Language. filetype.lua maps the extension; highlighting comes
-- from the cpp parser that lua/plugins/tree-sitter.lua registers for this
-- filetype. clangd does not attach: lsp/clangd.lua leaves metal out of its
-- filetypes, since upstream clangd parses a shader as C.
--
-- Only the comment syntax needs stating: the language is C++14-derived, and
-- nothing sets 'commentstring' for a filetype no runtime ships files for.
vim.opt_local.commentstring = "// %s"
