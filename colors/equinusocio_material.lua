-- based by https://github.com/yunlingz/equinusocio-material.vim
--
-- Lua port of colors/equinusocio_material.vim (round-2 plan R3.1) with the
-- former lua/config/highlight.lua overrides folded in after the base paint,
-- so a runtime :colorscheme re-apply repaints everything in one pass
-- (round 1 lost the overrides on re-apply). Parity with the VimL + override
-- pipeline is pinned byte-for-byte by tests/perf/fixtures/hl_baseline.txt
-- via script/hl-dump.lua.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
if vim.o.background ~= "dark" then
  vim.o.background = "dark"
end
vim.g.colors_name = "equinusocio_material"

local api = vim.api

-- Base paint replicates the VimL s:hl() shape exactly: every group carries
-- an explicit blend (0 unless stated) and cleared cterm attributes --
-- nvim_set_hl otherwise mirrors gui attributes into cterm, which the VimL
-- `cterm=None` never did.
local cterm_none = {}

--- @param name string
--- @param val table highlight definition map (:help nvim_set_hl)
local function hl(name, val)
  val.cterm = cterm_none
  if val.blend == nil then
    val.blend = 0
  end
  api.nvim_set_hl(0, name, val)
end

-- Overrides (the former config.highlight repaint) replace the whole group
-- definition like the old helper did: force, no implicit blend, mirrored
-- cterm left as nvim_set_hl produces it.
--- @param name string
--- @param val table highlight definition map (:help nvim_set_hl)
local function ovr(name, val)
  val.force = true
  api.nvim_set_hl(0, name, val)
end

-- Palette:
local cursor = "#111111"
local cursor_bg = "#cccccc"
local hover_float = "#c7c8c8"
local hover_float_bg = "#202122"
local man_bold = "#f0c674"
local man_underline = "#81a2be"
local foreground = "#f2f3f3"
local background = "#010101"
local comment = "#A5ABB0"
local nontext = "#202122"
local black = "#000000"
local red = "#ff5370"
local green = "#bae57d"
local yellow = "#ffcb6b"
local orange = "#f78c6c"
local blue = "#769AE7"
local magenta = "#c792ea"
local cyan = "#75d7ff"
local caret = "#ffcc00"
local cursor_guide = "#343941"
local selection = "#343941"
local gray = "#545454"
local linenr = "#757575"

-- :help group-name
-- ------------------------------------------------------------------------------

hl("ColorColumn", { bg = cursor_guide })
hl("Conceal", { fg = blue })
hl("Cursor", { fg = black, bg = caret })
hl("CursorIM", { fg = black, bg = caret })
hl("CursorColumn", { bg = cursor_guide })
hl("CursorLine", { bg = cursor_guide })

hl("Directory", { fg = cyan })

hl("DiffAdd", { fg = green })
hl("DiffChange", { fg = yellow })
hl("DiffDelete", { fg = red })
hl("DiffText", { fg = magenta })

hl("EndOfBuffer", { fg = background })

hl("ErrorMsg", { fg = red })

hl("VertSplit", { fg = gray })

hl("Folded", { fg = foreground, bg = gray })
hl("FoldColumn", { fg = foreground })

hl("SignColumn", { bg = background })
hl("IncSearch", { fg = black, bg = magenta })
hl("LineNr", { fg = linenr, bold = true })
hl("CursorLineNr", { fg = foreground })
hl("MatchParen", { fg = black, bg = red })

hl("ModeMsg", { fg = foreground })
hl("MoreMsg", { fg = red })
hl("NonText", {})
hl("Normal", { fg = foreground })
hl("TermCursor", { fg = cursor, bg = cursor_bg })
hl("TermCursorNC", { fg = cursor, bg = cursor_bg, reverse = true })
hl("HoverFloat", { fg = hover_float, bg = hover_float_bg, blend = 5 })

hl("manBold", { fg = man_bold, bold = true })
hl("manItalic", { italic = true })
hl("manUnderline", { fg = man_underline, underline = true })

hl("Pmenu", { fg = foreground, bg = nontext, bold = true })
hl("PmenuSel", { fg = cyan, bg = black })
hl("PmenuSbar", { fg = foreground, bg = gray })
hl("PmenuThumb", { fg = foreground, bg = foreground })

hl("Question", { fg = red })
hl("QuickFixLine", { fg = foreground, bg = background })
hl("Search", { bg = selection })
hl("CurSearch", { bg = selection })
hl("SpecialKey", { fg = gray })

-- The VimL `:highlight gui=underline` merged into the existing definition
-- and so inherited the default guisp; nvim_set_hl replaces the whole
-- definition, so the (nightly default) sp colors are pinned explicitly.
hl("SpellBad", { underline = true, sp = "#ffc0b9" })
hl("SpellCap", { underline = true, sp = "#fce094" })
hl("SpellLocal", { underline = true, sp = "#b3f6c0" })
hl("SpellRare", { underline = true, sp = "#8cf8f7" })

hl("StatusLine", { fg = foreground })
hl("StatusLineNC", { fg = gray })
hl("StatusLineTerm", { fg = foreground })
hl("StatusLineTermNC", { fg = gray })

hl("TabLine", { fg = foreground })
hl("TabLineFill", {})
hl("TabLineSel", { fg = foreground, bg = gray })
hl("Terminal", { fg = foreground, bg = background })
hl("Title", { fg = red })
hl("Visual", { fg = foreground, bg = selection })
hl("VisualNOS", { fg = foreground, bg = selection })
hl("WarningMsg", { fg = red })
hl("WildMenu", { fg = black, bg = cyan })

-- ------------------------------------------------------------------------------
-- standard syntax

hl("Comment", { fg = comment })

hl("Constant", { fg = green })
hl("String", { fg = green })
hl("Number", { fg = magenta })
hl("Boolean", { fg = magenta })
hl("Float", { fg = orange })

hl("Identifier", { fg = yellow })
hl("Function", { fg = blue })

hl("Statement", { fg = blue })
hl("Conditional", { fg = magenta })
hl("Repeat", { fg = blue })
hl("Operator", { fg = cyan })
hl("Keyword", { fg = magenta })
hl("Exception", { fg = blue })

hl("PreProc", { fg = cyan })
hl("Include", { fg = cyan })
hl("Define", { fg = cyan })
hl("Macro", { fg = cyan })
hl("PreCondit", { fg = cyan })

hl("Type", { fg = yellow })
hl("StorageClass", { fg = yellow })
hl("Structure", { fg = magenta })
hl("Typedef", { fg = cyan })

hl("Special", { fg = magenta })

hl("Underlined", { underline = true })
hl("Ignore", { strikethrough = true })
hl("Error", { fg = red, bold = true, underline = true })
hl("Todo", { fg = caret })

-- ------------------------------------------------------------------------------
-- nvim-lspconfig

hl("LspErrorText", { fg = red })
hl("LspWarningText", { fg = yellow })
hl("LspInformationText", { fg = orange })
hl("LspHintText", { fg = cyan })
hl("LspErrorHighlight", { underline = true })
hl("LspWarningHighlight", { underline = true })
hl("LspInformationHighlight", { underline = true })
hl("LspHintHighlight", { underline = true })

hl("DiagnosticError", { fg = red })
hl("DiagnosticWarn", { fg = yellow })
hl("DiagnosticInfo", { fg = orange })

-- ------------------------------------------------------------------------------
-- Overrides (former lua/config/highlight.lua, applied last so they replace
-- the base definitions above exactly as the VeryLazy repaint used to).

local hi_none = "None"

-- nvim default
ovr("WinBar", { fg = "None", bg = hi_none })
ovr("diffRemoved", { fg = "red", bg = hi_none })
ovr("LspReferenceText", { fg = hi_none, bg = hi_none, underline = true })

-- plugins
-- blink.cmp defaults link BlinkCmpMenu/Border to Pmenu (#202122). The
-- nvim-cmp era popup rendered on the editor Normal background (#010101)
-- because its winhighlight pointed at these then-undefined groups, so pin
-- them to Normal to keep that look (blink sets its links with default=true,
-- which never overrides these).
ovr("BlinkCmpMenu", { link = "Normal" })
ovr("BlinkCmpSource", { link = "Normal" })
ovr("BlinkCmpMenuBorder", { link = "Normal" })
ovr("BlinkCmpMenuSelection", { link = "WildMenu" })
-- The item-level groups blink draws inside the menu still resolve to Pmenu's
-- #202122 background. A bare bg = "None" collapses to an empty definition,
-- which blink's default=true links then win over, so blank them with a link.
ovr("BlinkCmpLabelDetail", { link = hi_none })
ovr("BlinkCmpLabelDescription", { link = hi_none })
ovr("BlinkCmpLabelDeprecated", { link = hi_none })
ovr("BlinkCmpKind", { link = hi_none })
ovr("@comment.note.comment", { link = "comment" })

-- Go
--- Literals
ovr("@spell.go", { fg = "#92999f", bg = hi_none, blend = 70 })
ovr("@string.go", { link = hi_none })
ovr("@rune_literal.go", { link = "String" })

--- Keywords
ovr("@type.builtin.go", { fg = "#ffbf6b", bg = hi_none, bold = false })
ovr("@keyword.return.go", { link = "Statement" })
ovr("@keyword.defer.go", { link = "Keyword" })
ovr("@keyword.function.go", { link = "Keyword" })
ovr("@number.go", { link = "Number" })

--- Comment
ovr("@comment.documentation.go", { fg = "#9ba3a8", bg = hi_none, bold = false, italic = true })
ovr("@comment.documentation.pragma.go", { link = "@attribute" })
ovr("@comment.documentation.nolint.go", { fg = "#a6dbff", bg = hi_none })

--- Conditional
ovr("@conditional.case.go", { link = "Statement" })
ovr("@conditional.default.go", { link = "Statement" })

--- Builtin types
ovr("@type.builtin.error.go", { fg = "#ff5370", bg = hi_none, bold = true })
ovr("@type.builtin.any", { link = "Keyword" })
ovr("@type.go", { link = hi_none })

--- Import decl
ovr("@namespace.go", { link = "Statement" })
ovr("@namespace.package.go", { fg = "#92999f", bg = hi_none })
ovr("@module.go", { fg = "#769ae7", bg = hi_none, italic = true })

--- Type decl
ovr("@type.definition.go", { link = "Normal" })
ovr("@field.go", { link = "Normal" })
ovr("@property.go", { fg = "#ffbf6b", bg = "None" })
ovr("@variable.member.go", { link = "Normal" })
ovr("@function.call.builtin_type.go", { link = "Type" })
ovr("@function.call.builtin_type.any.go", { link = "Keyword" })
ovr("@function.method.call.go", { link = "None" })

--- Constant decl
ovr("@constant.go", { fg = "#c7c8c8", bg = "None" })

--- Function decl
ovr("@constructor.go", { fg = "#ffbf6b", bg = "None" })
ovr("@method.go", { fg = "#82aaff", bg = "None" })
ovr("@method.call.go", { fg = "#ffbf6b", bg = "None", bold = false })
ovr("@parameter.go", { link = "None" })

--- Variable
ovr("@variable.parameter.go", { link = "Normal" })
ovr("@variable.err.go", { fg = "#ff005f", bg = "None", bold = true, force = true })
ovr("@variable.go", { blend = 10 })
ovr("goImportedPkg", { fg = "#769ae7", bg = "None", italic = true, blend = 10 })

--- fmt verb
ovr("@format_verb.go", { link = "PreProc" })

ovr("@lsp.type.function.go", { link = "Type" })
ovr("@lsp.type.namespace.go", { fg = "#769ae7", bg = "None", italic = true })
ovr("@lsp.type.number.go", { link = "Number" })
ovr("@lsp.type.parameter.go", { link = "None" })
ovr("@lsp.type.property.go", { link = "None" })
ovr("@lsp.type.string.go", { fg = "#f2f3f3", bg = hi_none, blend = 50 })
ovr("@lsp.type.type.go", { link = "Normal" })
ovr("@lsp.type.typeParameter.go", { link = "Typedef" })
ovr("@lsp.type.variable.go", { link = "None" })
ovr("@lsp.typemod.type.definition.go", { link = "Normal" })

ovr("@keyword.directive.goasm", { link = "Macro" })

-- printf
ovr("@character.printf", { link = "PreProc" })

-- gomod
ovr("@string.special.gomod", { link = "String" })

-- Rust
ovr("@constant.rust", { fg = "#bae57d", bg = hi_none, bold = true })

-- Lua
ovr("@namespace.builtin.lua", { link = "@type.builtin" })
ovr("@string.regexp.lua", { link = "String" })

-- TypeScript
ovr("@keyword.modifier.typescript", { fg = "#c792ea", bg = "None", bold = true })
ovr("@variable.member.typescript", { link = "NonText" })

-- Python
ovr("@comment.python", { fg = "#9ba3a8", bg = "None", bold = false, italic = true })
ovr("@constant.python", { fg = "#f2f3f3", bg = "None", blend = 50 })
ovr("@lsp.type.namespace.python", { fg = "#769ae7", bg = "None", italic = true })
ovr("@lsp.type.variable.python", { link = "None" })
ovr("@spell.python", { link = "Commment" })
ovr("@string.documentation.python", { link = "String" })
ovr("@variable.python", { link = "None" })
ovr("pythonDelimiter", { link = "Special" })
ovr("pythonNONE", { link = "pythonFunction" })
ovr("pythonSelf", { link = "pythonOperator" })
ovr("pythonSpaceError", { fg = "#787f86", bg = "#787f86" })

-- YAML
ovr("@property.yaml", { fg = "#81a2be", bg = "NONE", bold = false })

-- GraphQL
ovr("@spell.graphql", { link = "Comment" })
ovr("@attribute.graphql", { link = "Macro" })

-- Diff
ovr("@diff.plus", { fg = "#bae57d", bg = "None" })
ovr("@diff.minus", { fg = "#ff5370", bg = "None" })

-- C
ovr("@label.c", { link = "@lsp.type.label.c" })
ovr("@lsp.type.label.c", { fg = "#7EE787", bg = "None" })

-- CPP
ovr("doxygenBrief", { fg = "#81a2be", bg = "NONE" })
ovr("doxygenSpecialMultilineDesc", { fg = "#81a2be", bg = "NONE" })
ovr("doxygenSpecialOnelineDesc", { fg = "#81a2be", bg = "NONE" })

--- third-party
ovr("LspSignatureActiveParameter", { fg = "None", bg = "#343941", blend = 10 })
ovr("LspInlayHint", { fg = "#787f86", bg = "None", bold = false, italic = true, blend = 50 })

--- VimIlluminate:
ovr("illuminatedWord", { fg = "NONE", bg = "NONE", underline = true })

--- MatchUp
ovr("MatchParen", { fg = "NONE", bg = "#343941" })
ovr("MatchWord", { fg = "NONE", bg = "#343941" })
