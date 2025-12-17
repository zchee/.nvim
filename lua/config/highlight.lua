-- :Help group-name
-- :Help highlight-groups
-- :Help treesitter-highlight-groups
-- :Help lsp-semantic-highlight

-- :help vim.highlight.priorities
vim.hl.priorities.syntax = 50
vim.hl.priorities.treesitter = 130
vim.hl.priorities.semantic_tokens = 125
vim.hl.priorities.diagnostics = 150
vim.hl.priorities.user = 200

--- @param name string
--- @param val vim.api.keyset.highlight
local hi = function(name, val)
  val = vim.tbl_extend("force", val, { force = true })
  vim.api.nvim_set_hl(0, name, val)
end

local hi_none = "None"

-- nvim default
hi("WinBar", { fg = "None", bg = hi_none })
hi("diffRemoved", { fg = "red", bg = hi_none })

-- plugins
hi("BlinkCmpMenuSelection", { link = "WildMenu" })

-- Go
--- Literals
hi("@spell.go", { fg = "#92999f", bg = hi_none, blend = 70 })
hi("@string.go", { link = hi_none }) -- { fg = "#f2f3f3", bg = hi_none, blend = 50 }, { fg = "#92999f", bg = "None" }
hi("@rune_literal.go", { link = "String" })
-- Treesitter
--   - @string.go priority: 130   language: go
--
-- Semantic Tokens
--   - @lsp.type.number.go links to Number   priority: 125

--- Keywords
hi("@type.builtin.go", { fg = "#ffbf6b", bg = hi_none, bold = false })
-- hi("@lsp.mod.defaultLibrary.go", { fg = "#ffbf6b", bg = hi_none, bold = false })
hi("@keyword.return.go", { link = "Statement" }) -- TODO(zchee): consider to use "Keyword" or "Statement"
hi("@keyword.defer.go", { link = "Keyword" })    -- TODO(zchee): consider to use "Keyword" or "Statement"
hi("@keyword.function.go", { link = "Keyword" }) -- TODO(zchee): consider to use "Keyword" or "Statement"
hi("@number.go", { link = "Number" })            -- TODO(zchee): consider to use "Keyword" or "Statement"

--- Comment
hi("@comment.documentation.go", { fg = "#9ba3a8", bg = hi_none, bold = false, italic = true })
hi("@comment.documentation.pragma.go", { link = "@attribute" })

--- Conditional
hi("@conditional.case.go", { link = "Statement" })
hi("@conditional.default.go", { link = "Statement" })

--- Builtin types
hi("@type.builtin.error.go", { fg = "#ff5370", bg = hi_none, bold = true })
hi("@type.builtin.any", { link = "Keyword" })
hi("@type.go", { link = hi_none })

--- Import decl
hi("@namespace.go", { link = "Statement" })
hi("@namespace.package.go", { fg = "#92999f", bg = hi_none })
hi("@module.go", { fg = "#769ae7", bg = hi_none, italic = true })

--- Type decl
hi("@type.definition.go", { link = "Normal" })
hi("@field.go", { link = "Normal" })
hi("@property.go", { fg = "#ffbf6b", bg = "None" }) -- TODO(zchee): link = "Statement", "Normal"
hi("@variable.member.go", { link = "Normal" })
hi("@function.call.builtin_type.go", { link = "Type" })
hi("@function.call.builtin_type.any.go", { link = "Keyword" })
-- hi("@lsp.mod.interface.go", { link = "Keyword" })
hi("@function.method.call.go", { link = "None" }) -- remove
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

hi("@lsp.type.function.go", { link = "Type" })
hi("@lsp.type.namespace.go", { fg = "#769ae7", bg = "None", italic = true })
hi("@lsp.type.number.go", { link = "Number" })
hi("@lsp.type.parameter.go", { link = "None" })
hi("@lsp.type.string.go", { fg = "#f2f3f3", bg = hi_none, blend = 50 }) -- link = "None"
hi("@lsp.type.type.go", { link = "Normal" })
hi("@lsp.type.typeParameter.go", { link = "Typedef" })
hi("@lsp.type.variable.go", { link = "None" })
hi("@lsp.typemod.type.definition.go", { link = "Normal" })

-- printf
hi("@character.printf", { link = "PreProc" })

-- gomod
hi("@string.special.gomod", { link = "String" })

-- Lua
hi("@namespace.builtin.lua", { link = "@type.builtin" })

-- TypeScript
hi("@keyword.modifier.typescript", { fg = "#c792ea", bg = "None", bold = true })

-- Dockerfile
-- hi("@keyword.dockerfile", { blend = 100 })

-- Python
hi("@comment.python", { fg = "#9ba3a8", bg = "None", bold = false, italic = true })
hi("@constant.python", { fg = "#f2f3f3", bg = "None", blend = 50 })
hi("@lsp.type.namespace.python", { fg = "#769ae7", bg = "None", italic = true })
hi("@lsp.type.variable.python", { link = "None" })
hi("@spell.python", { link = "Commment" })
hi("@string.documentation.python", { link = "String" })
hi("@variable.python", { link = "None" })
hi("pythonDelimiter", { link = "Special" })
hi("pythonNONE", { link = "pythonFunction" })
hi("pythonSelf", { link = "pythonOperator" })
hi("pythonSpaceError", { fg = "#787f86", bg = "#787f86" })

-- YAML
hi("@property.yaml", { fg = "#81a2be", bg = "NONE", bold = false })

-- GraphQL
hi("@spell.graphql", { link = "Comment" })
hi("@attribute.graphql", { link = "Macro" })

-- Diff
hi("@diff.plus", { fg = "#bae57d", bg = "None" })
hi("@diff.minus", { fg = "#ff5370", bg = "None" })

-- C
hi("@label.c", { link = "@lsp.type.label.c" })
hi("@lsp.type.label.c", { fg = "#7EE787", bg = "None" })

-- CPP
hi("doxygenBrief", { fg = "#81a2be", bg = "NONE" })
hi("doxygenSpecialMultilineDesc", { fg = "#81a2be", bg = "NONE" })
hi("doxygenSpecialOnelineDesc", { fg = "#81a2be", bg = "NONE" })

--- third-party
hi("LspSignatureActiveParameter", { fg = "None", bg = "#343941", blend = 10 })
hi("LspInlayHint", { fg = "#9ba3a8", bg = "None", bold = false, italic = true, blend = 50 })

--- VimIlluminate:
hi("illuminatedWord", { fg = "NONE", bg = "NONE", underline = true })
-- hi("LspReferenceText", { fg = "NONE", bg = "NONE", underline = true })

--- MatchUp
hi("MatchParen", { fg = "NONE", bg = "#343941" })
hi("MatchWord", { fg = "NONE", bg = "#343941" })
