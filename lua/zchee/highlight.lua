--- Expands env path and reads symbolic link.
--- It's equivalent to readlink(2) syscall.
---
---@param name string
--- keys:
---   sp (or special): color name or "#RRGGBB"
---   blend: integer between 0 and 100
---   bold: boolean
---   standout: boolean
---   underline: boolean
---   underlineline: boolean
---   undercurl: boolean
---   underdot: boolean
---   underdash: boolean
---   strikethrough: boolean
---   italic: boolean
---   reverse: boolean
---   nocombine: boolean
---   link: name of another highlight group to link to, see |:hi-link|. default: Don't override existing definition |:hi-default|
---   ctermfg: Sets foreground of cterm color |highlight-ctermfg|
---   ctermbg: Sets background of cterm color |highlight-ctermbg|
---   cterm: cterm attribute map, like |highlight-args|. If not set, cterm attributes will match those from the attribute map documented above.
---
---@param fg string
---@param bg string
---@param keys table|nil
---@return string|nil
local set_hl = function(name, fg, bg, keys)
  local val = { fg = fg, bg = bg }
  if keys then
    val = vim.tbl_deep_extend("force", val, keys)
  end
  vim.api.nvim_set_hl(0, name, val)
end

local set_hl_link = function(name, to)
  vim.api.nvim_set_hl(0, name, { link = to })
end

-- general
set_hl("lCursor", "", "", { reverse = true })
set_hl("PmenuThumb", "#545454", "#f2f3f3")
set_hl("manOptionDesc", "#bae57d", "NONE", { bold = true })

-- hidden highlight names
set_hl("RedrawDebugClear", "black", "yellow")
set_hl("NvimInternalError", "white", "red")


-- man.lua
set_hl("manSectionHeading", "#ffcb6b", "NONE", { bold = false })

-- local go_ts_highlight = function()
--   set_hl("goTSBoolean", "#c792ea", "NONE")
--   set_hl("goTSCharacter", "#92999f", "NONE")
--   set_hl("goTSComment", "#838c93", "NONE")
--   set_hl("goTSConditional", "#c792ea", "NONE")
--   set_hl("goTSConstant", "#c7c8c8", "NONE")
--   set_hl("goTSConstBuiltin", "#c792ea", "NONE")
--   set_hl("goTSConstBuiltin", "#c792ea", "NONE")
--   set_hl("goTSError", "#ff5370", "NONE")
--   set_hl_link("goTSError", "Error")
--   set_hl("goTSFloat", "#ffcb6b", "NONE")
--   set_hl("goTSFuncBuiltin", "#c792ea", "NONE")
--   set_hl("goTSFunction", "#82aaff", "NONE")
--   set_hl("goTSInclude", "#82aaff", "NONE")
--   set_hl("goTSKeyword", "#c792ea", "NONE")
--   set_hl("goTSKeywordFunction", "#82aaff", "NONE")
--   set_hl_link("goTSKeywordReturn", "Statement")
--   set_hl("goTSMethod", "#ffcb6b", "NONE", { bold = true })
--   set_hl("goTSNone", "NONE", "NONE")
--   set_hl("goTSNote", "#ffcc00", "NONE")
--   set_hl("goTSNumber", "#c792ea", "NONE")
--   set_hl("goTSOperator", "#75d7ff", "NONE")
--   set_hl("goTSParameter", "#f2f3f3", "NONE")
--   set_hl("goTSProperty", "#f2f3f3", "NONE")
--   set_hl_link("goTSPunctBracket", "NonText")
--   set_hl("goTSPunctDelimiter", "#92999f", "NONE")
--   set_hl("goTSRepeat", "#c792ea", "NONE")
--   set_hl("goTSString", "#92999f", "NONE")
--   set_hl("goTSStringEscape", "#bae57d", "NONE")
--   set_hl("goTSStringRegex", "#bae57d", "NONE")
--   set_hl("goTSText", "#bae57d", "NONE")
--   set_hl("goTSType", "#c7c8c8", "NONE")
--   set_hl("goTSTypeBuiltin", "#c792ea", "NONE")
--   set_hl("goTSVariable", "#82aaff", "NONE")
--   set_hl("goTSVariableBuiltin", "#75d7ff", "NONE", { underline = true })
--   set_hl("goTSAnnotation", "#75d7ff", "NONE")
--   set_hl("goTSAttribute", "#75d7ff", "NONE")
--   set_hl("goTSConstMacro", "#75d7ff", "NONE")
--   set_hl("goTSConstructor", "#75d7ff", "NONE")
--   set_hl("goTSDanger", "#75d7ff", "NONE")
--   set_hl("goTSEmphasis", "#75d7ff", "NONE")
--   set_hl("goTSEnvironment", "#75d7ff", "NONE")
--   set_hl("goTSEnvironmentName", "#75d7ff", "NONE")
--   set_hl("goTSException", "#75d7ff", "NONE")
--   set_hl("goTSField", "#75d7ff", "NONE")
--   set_hl("goTSFuncMacro", "#75d7ff", "NONE")
--   set_hl("goTSKeywordOperator", "#75d7ff", "NONE")
--   set_hl("goTSLabel", "#75d7ff", "NONE")
--   set_hl("goTSLiteral", "#75d7ff", "NONE")
--   set_hl("goTSMath", "#75d7ff", "NONE")
--   set_hl("goTSNamespace", "#82aaff", "NONE", { italic = true })
--   set_hl("goTSParameterReference", "#75d7ff", "NONE")
--   set_hl("goTSPunctSpecial", "#75d7ff", "NONE")
--   set_hl("goTSStrike", "#75d7ff", "NONE")
--   set_hl("goTSStrong", "#75d7ff", "NONE")
--   set_hl("goTSSymbol", "#75d7ff", "NONE")
--   set_hl("goTSTag", "#75d7ff", "NONE")
--   set_hl("goTSTagDelimiter", "#75d7ff", "NONE")
--   set_hl("goTSTitle", "#75d7ff", "NONE")
--   set_hl("goTSUnderline", "#75d7ff", "NONE")
--   set_hl("goTSURI", "#75d7ff", "NONE")
--   set_hl("goTSWarning", "#75d7ff", "NONE")
--   set_hl("goTSStringSpecial", "#75d7ff", "NONE")
--   set_hl("goTSTagAttribute", "#75d7ff", "NONE")
--   set_hl("goTSTextReference", "#75d7ff", "NONE")
--   set_hl("goErrorType", "#ff5370", "NONE", { bold = true })
--   set_hl("goField", "#d9d9f0", "NONE")
--   set_hl("goFunction", "#82aaff", "NONE", { bold = true })
--   set_hl("goFunctionCall", "#ffbf6b", "NONE", { bold = true })
--   set_hl("goPackageComment", "#838c93", "NONE", { italic = true })
--   set_hl("goString", "#92999f", "NONE")
--   set_hl("goReceiverType", "#81a2be", "NONE", { bold = true })
-- end
-- go_ts_highlight()
-- vim.api.nvim_set_hl(0, "@foo.bar.lua", { link = "Identifier" })

local go_highlight = function()
  set_hl("goComment", "#9ba3a8", "NONE", {})
  set_hl("goErrorType", "#ff5370", "NONE", { bold = true })
  set_hl("goField", "#d9d9f0", "NONE")
  set_hl("goFunction", "#82aaff", "NONE", { bold = true })
  set_hl("goFunctionCall", "#ffbf6b", "NONE", { bold = true })
  set_hl("goPackageComment", "#9ba3a8", "NONE", { italic = true })
  set_hl("goReceiverType", "#81a2be", "NONE", { bold = true })
  set_hl("goString", "#92999f", "NONE")

  set_hl_link("goBuiltins", "Keyword")
  set_hl_link("goFormatSpecifier", "PreProc")
  set_hl_link("goImportedPkg", "Statement")
  set_hl_link("goStdlib", "Statement")
  set_hl_link("goStdlibReturn", "PreProc")
end
go_highlight()

-- test highlight
-- vim.cmd("source $VIMRUNTIME/syntax/hitest.vim")
