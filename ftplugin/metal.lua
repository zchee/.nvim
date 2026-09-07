-- Metal Shading Language. filetype.lua maps the extension; highlighting comes
-- from the cpp parser that lua/plugins/tree-sitter.lua registers for this
-- filetype, and clangd attaches through lsp/clangd.lua's filetypes.
--
-- Only the comment syntax needs stating: the language is C++14-derived, and
-- nothing sets 'commentstring' for a filetype no runtime ships files for.
vim.opt_local.commentstring = "// %s"
