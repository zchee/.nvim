-- Metal Shading Language: C++14-derived, and nothing sets 'commentstring'
-- for a filetype no runtime ships files for. Why clangd stays off these
-- buffers is in lsp/clangd.lua.
vim.opt_local.commentstring = "// %s"
