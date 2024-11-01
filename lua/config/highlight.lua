-- :help group-name
-- :help highlight-groups
-- :help treesitter-highlight-groups
-- :help lsp-semantic-highlight

-- :help vim.highlight.priorities
vim.highlight.priorities.syntax = 50
vim.highlight.priorities.treesitter = 130
vim.highlight.priorities.semantic_tokens = 125
vim.highlight.priorities.diagnostics = 150
vim.highlight.priorities.user = 200

--- @param name string Highlight group name
--- @param val vim.api.keyset.highlight Highlight definition map
local hi = function(name, val)
  val.force = true
  vim.api.nvim_set_hl(0, name, val)
end

hi("WinBar", { fg = "None", bg = "None" })
-- hi("diffRemoved", { fg = "red", bg = "None" })

hi("@namespace.builtin.lua", { link = "@type.builtin" })

-- Go
--- Literals
hi("@spell.go", { fg = "#92999f", bg = "None", blend = 70 })
hi("@string.go", { fg = "#f2f3f3", bg = "None", blend = 50 }) -- { fg = "#92999f", bg = "None" }
hi("@rune_literal.go", { link = "String" })

--- Keywords
hi("@type.builtin.go", { fg = "#ffbf6b", bg = "None", bold = false })
hi("@keyword.return.go", { link = "Statement" }) -- TODO(zchee): consider to use "Keyword" or "Statement"
hi("@keyword.defer.go", { link = "Keyword" })    -- TODO(zchee): consider to use "Keyword" or "Statement"
hi("@keyword.function.go", { link = "Keyword" }) -- TODO(zchee): consider to use "Keyword" or "Statement"

--- Comment
hi("@comment.documentation.go", { fg = "#9ba3a8", bg = "None", bold = false, italic = true })
hi("@comment.documentation.pragma.go", { link = "@attribute" })

--- Conditional
hi("@conditional.case.go", { link = "Statement" })
hi("@conditional.default.go", { link = "Statement" })

--- Builtin types
hi("@type.builtin.error.go", { fg = "#ff5370", bg = "None", bold = true })
hi("@type.builtin.any", { link = "Keyword" })
hi("@type.go", { link = "None" })

--- Import decl
hi("@namespace.go", { link = "Statement" })
hi("@namespace.package.go", { fg = "#92999f", bg = "None" })
hi("@module.go", { fg = "#769ae7", bg = "None", italic = true })

--- Type decl
hi("@type.definition.go", { link = "Normal" })
hi("@field.go", { link = "Normal" })
hi("@property.go", { fg = "#ffbf6b", bg = "None" }) -- TODO(zchee): link = "Statement", "Normal"
hi("@variable.member.go", { link = "Normal" })
hi("@function.call.builtin_type.go", { link = "Type" })
hi("@function.call.builtin_type.any.go", { link = "Keyword" })
hi("@function.method.call.go", { link = "Type" })
-- hi("@spell.const_string_literal.go", { link = "String" })

--- Constant decl
hi("@constant.go", { fg = "#c7c8c8", bg = "None" })

--- Function decl
hi("@constructor.go", { fg = "#ffbf6b", bg = "None" })
hi("@method.go", { fg = "#82aaff", bg = "None" })
hi("@method.call.go", { fg = "#ffbf6b", bg = "None", bold = false })
hi("@parameter.go", { link = "None" })

--- Variable
hi("@variable.parameter.go", { link = "Normal" })
hi("@variable.err.go", { fg = "#ff005f", bg = "None", bold = true, force = true })
hi("@variable.go", { blend = 10 })
hi("goImportedPkg", { fg = "#769ae7", bg = "None", italic = true, blend = 10 })

--- fmt verb
hi("@format_verb.go", { link = "PreProc" })

hi("@lsp.type.namespace.go", { fg = "#769ae7", bg = "None", italic = true })
-- hi("@lsp.type.type.go", { link = "Normal" })
hi("@lsp.type.function.go", { link = "Type" })
hi("@lsp.type.variable.go", { link = "None" })
hi("@lsp.type.string.go", { link = "None" })
hi("@lsp.typemod.type.definition.go", { link = "Normal" })
hi("@lsp.type.parameter.go", { link = "None" })

-- Python
hi("@constant.python", { fg = "#f2f3f3", bg = "None", blend = 50 })
hi("@comment.python", { fg = "#9ba3a8", bg = "None", bold = false, italic = true })
hi("@spell.python", { link = "Commment" })
hi("@string.documentation.python", { link = "SpecialComment" })

--- third-party
hi("LspSignatureActiveParameter", { fg = "None", bg = "#343941", blend = 10 })
hi("LspInlayHint", { fg = "#d8d8d8", bg = "#3a3a3a" })

-- printf
hi("@character.printf", { link = "PreProc" })

-- GraphQL
hi("@spell.graphql", { link = "Comment" })
hi("@attribute.graphql", { link = "Macro" })

-- Diff
hi("@diff.plus", { fg = "#bae57d", bg = "None" })
hi("@diff.minus", { fg = "#ff5370", bg = "None" })
