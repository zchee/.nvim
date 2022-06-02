-- :source $VIMRUNTIME/syntax/hitest.vim
vim.api.nvim_set_hl(0, "lCursor", { reverse = true })
vim.api.nvim_set_hl(0, "PmenuThumb", { fg="#545454", bg="#f2f3f3" })
vim.api.nvim_set_hl(0, "RedrawDebugClear", { fg = "black", bg = "yellow" })
vim.api.nvim_set_hl(0, "NvimInternalError", { fg = "white", bg = "red" })

local set_hl = function(name, fg, bg, ...)
  local args = { fg = fg, bg = bg }
  if ... then
    args = vim.tbl_extend("force", args, ...)
  end
  vim.api.nvim_set_hl(0, name, args)
end

local set_hl_link = function(name, link)
  vim.api.nvim_set_hl(0, name, { link = link })
end

local go_ts_highlight = function()
  set_hl("goTSBoolean", "#c792ea", "NONE")

  set_hl("goTSCharacter", "#92999f", "NONE")
  set_hl("goTSComment", "#838c93", "NONE")

  set_hl("goTSConditional", "#c792ea", "NONE")
  set_hl("goTSConstant", "#c7c8c8", "NONE")
  set_hl("goTSConstBuiltin", "#c792ea", "NONE")
  set_hl("goTSConstBuiltin", "#c792ea", "NONE")

  set_hl("goTSError", "#ff5370", "NONE")

  set_hl_link("goTSError", "Error")
  set_hl("goTSFloat", "#ffcb6b", "NONE")
  set_hl("goTSFuncBuiltin", "#c792ea", "NONE")
  set_hl("goTSFunction", "#82aaff", "NONE")
  set_hl("goTSInclude", "#82aaff", "NONE")
  set_hl("goTSKeyword", "#c792ea", "NONE")
  set_hl("goTSKeywordFunction", "#82aaff", "NONE")
  set_hl_link("goTSKeywordReturn", "Statement")
  set_hl("goTSMethod", "#ffcb6b", "NONE", { bold = true })
  set_hl("goTSNone", "NONE", "NONE")
  set_hl("goTSNote", "#ffcc00", "NONE")
  set_hl("goTSNumber", "#c792ea", "NONE")
  set_hl("goTSOperator", "#75d7ff", "NONE")
  set_hl("goTSParameter", "#f2f3f3", "NONE")
  set_hl("goTSProperty", "#f2f3f3", "NONE")
  set_hl_link("goTSPunctBracket", "NonText")
  set_hl("goTSPunctDelimiter", "#92999f", "NONE")
  set_hl("goTSRepeat", "#c792ea", "NONE")
  set_hl("goTSString", "#92999f", "NONE")
  set_hl("goTSStringEscape", "#bae57d", "NONE")
  set_hl("goTSStringRegex", "#bae57d", "NONE")
  set_hl("goTSText", "#bae57d", "NONE")
  set_hl("goTSType", "#c7c8c8", "NONE")
  set_hl("goTSTypeBuiltin", "#c792ea", "NONE")

  -- set_hl("goTSVariable", "#82aaff", "NONE")

  set_hl("goTSVariableBuiltin", "#75d7ff", "NONE", { underline = true })

  set_hl("goTSAnnotation", "#75d7ff", "NONE")
  set_hl("goTSAttribute", "#75d7ff", "NONE")
  set_hl("goTSConstMacro", "#75d7ff", "NONE")
  set_hl("goTSConstructor", "#75d7ff", "NONE")
  set_hl("goTSDanger", "#75d7ff", "NONE")
  set_hl("goTSEmphasis", "#75d7ff", "NONE")
  set_hl("goTSEnvironment", "#75d7ff", "NONE")
  set_hl("goTSEnvironmentName", "#75d7ff", "NONE")
  set_hl("goTSException", "#75d7ff", "NONE")
  set_hl("goTSField", "#75d7ff", "NONE")
  set_hl("goTSFuncMacro", "#75d7ff", "NONE")
  set_hl("goTSKeywordOperator", "#75d7ff", "NONE")
  set_hl("goTSLabel", "#75d7ff", "NONE")
  set_hl("goTSLiteral", "#75d7ff", "NONE")
  set_hl("goTSMath", "#75d7ff", "NONE")
  set_hl("goTSNamespace", "#82aaff", "NONE", { italic = true })  -- same as goImportedPkg
  set_hl("goTSParameterReference", "#75d7ff", "NONE")
  set_hl("goTSPunctSpecial", "#75d7ff", "NONE")
  set_hl("goTSStrike", "#75d7ff", "NONE")
  set_hl("goTSStrong", "#75d7ff", "NONE")
  set_hl("goTSSymbol", "#75d7ff", "NONE")
  set_hl("goTSTag", "#75d7ff", "NONE")
  set_hl("goTSTagDelimiter", "#75d7ff", "NONE")
  set_hl("goTSTitle", "#75d7ff", "NONE")
  set_hl("goTSUnderline", "#75d7ff", "NONE")
  set_hl("goTSURI", "#75d7ff", "NONE")
  set_hl("goTSWarning", "#75d7ff", "NONE")
  set_hl("goTSStringSpecial", "#75d7ff", "NONE")
  set_hl("goTSTagAttribute", "#75d7ff", "NONE")
  set_hl("goTSTextReference", "#75d7ff", "NONE")
  
  set_hl("goErrorType", "#ff5370", "NONE", { bold = true })
  set_hl("goField", "#d9d9f0", "NONE")
  set_hl("goFunction", "#82aaff", "NONE", { bold = true })
  set_hl("goFunctionCall", "#ffbf6b", "NONE", { bold = true })
  -- set_hl("goImportedPkg", "#82aaff", "NONE", { italic = true })
  set_hl("goPackageComment", "#838c93", "NONE", { italic = true })
  set_hl("goString", "#92999f", "NONE")
  set_hl("goReceiverType", "#81a2be", "NONE", { bold = true })
  set_hl_link("goBuiltins", "Keyword")
  set_hl_link("goFormatSpecifier", "PreProc")
  set_hl_link("goImportedPkg", "Statement")
  set_hl_link("goStdlib", "Statement")
  set_hl_link("goStdlibReturn", "PreProc")

  -- highlight TSBoolean             gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- " highlight TSCharacter           gui=NONE       guifg=#92999f  guibg=NONE  blend=0
  -- " highlight TSComment             gui=NONE       guifg=#838c93  guibg=NONE  blend=0
  -- highlight TSConditional         gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- highlight TSConstant            gui=NONE       guifg=#c7c8c8  guibg=NONE  blend=0
  -- highlight TSConstBuiltin        gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- " highlight! TSError               gui=NONE       guifg=NONE     guibg=NONE
  -- highlight link                  TSError        Error
  -- highlight TSFloat               gui=NONE       guifg=#ffcb6b  guibg=NONE  blend=0
  -- highlight TSFuncBuiltin         gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- highlight TSFunction            gui=NONE       guifg=#82aaff  guibg=NONE  blend=0
  -- highlight TSInclude             gui=NONE       guifg=#82aaff  guibg=NONE  blend=0
  -- highlight TSKeyword             gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- highlight TSKeywordFunction     gui=NONE       guifg=#82aaff  guibg=NONE  blend=0
  -- highlight link                  TSKeywordReturn               Statement
  -- highlight TSMethod              gui=bold       guifg=#ffcb6b  guibg=NONE  blend=0
  -- highlight TSNone                gui=NONE       guifg=NONE     guibg=NONE  blend=0
  -- highlight TSNote                gui=NONE       guifg=#ffcc00  guibg=NONE  blend=0
  -- highlight TSNumber              gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- highlight TSOperator            gui=NONE       guifg=#75d7ff  guibg=NONE  blend=0
  -- highlight TSParameter           gui=NONE       guifg=#f2f3f3  guibg=NONE  blend=0
  -- highlight TSProperty            gui=NONE       guifg=#f2f3f3  guibg=NONE  blend=0
  -- highlight link                  TSPunctBracket                NonText
  -- highlight TSPunctDelimiter      gui=NONE       guifg=#92999f  guibg=NONE  blend=0
  -- highlight TSRepeat              gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- highlight TSString              gui=NONE       guifg=#92999f  guibg=NONE  blend=0
  -- highlight TSStringEscape        gui=NONE       guifg=#bae57d  guibg=NONE  blend=0
  -- highlight TSStringRegex         gui=NONE       guifg=#bae57d  guibg=NONE  blend=0
  -- highlight TSText                gui=NONE       guifg=#bae57d  guibg=NONE  blend=0
  -- highlight TSType                gui=bold       guifg=#c7c8c8  guibg=NONE  blend=0
  -- highlight TSTypeBuiltin         gui=NONE       guifg=#c792ea  guibg=NONE  blend=0
  -- " highlight TSVariable            gui=NONE       guifg=#f2f3f3  guibg=NONE  blend=0
  -- highlight TSVariableBuiltin     gui=NONE       guifg=#75d7ff  guibg=NONE  blend=0
  --
  -- highlight TSAnnotation          gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSAttribute           gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSConstMacro          gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSConstructor         gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSDanger              gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSEmphasis            gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSEnvironment         gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSEnvironmentName     gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSException           gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSField               gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSFuncMacro           gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSKeywordOperator     gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSLabel               gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSLiteral             gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSMath                gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSNamespace           gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSParameterReference  gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSPunctSpecial        gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSStrike              gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSStrong              gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSSymbol              gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSTag                 gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSTagDelimiter        gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSTitle               gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSUnderline           gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSURI                 gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSWarning             gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSStringSpecial       gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSTagAttribute        gui=underline  guifg=#ff5370  guibg=NONE
  -- highlight TSTextReference       gui=underline  guifg=#ff5370  guibg=NONE
  --
  -- highlight  link                 TSKeywordReturn  Statement
  -- highlight! goImportedPkg        gui=NONE       guifg=#82aaff  guibg=None blend=10
  --
  -- " highlight! goPackageComment      gui=italic     guifg=#838c93  guibg=NONE
  -- " highlight! goString              gui=NONE       guifg=#92999f  guibg=NONE
  -- " highlight link                   goImportedPkg  Statement
  --
  --
  -- " highlight! goErrorType           gui=bold       guifg=#ff5370  guibg=NONE
  -- " highlight! goImportedPkg         gui=NONE       guifg=#82aaff  guibg=NONE
  --
  -- " syn keyword     goTodo              contained TODO FIXME XXX BUG
  -- " syn match       goTodo              display contained "Deprecated:"
  -- " syn cluster     goCommentGroup      contains=goTodo
  -- " hi def link     goComment           Comment
  -- " hi def link     goTodo              Todo
-- Gautocmdft go call s:go_highlight()
end

local go_highlight = function()
  set_hl("goErrorType", "#ff5370", "NONE", { bold = true })
  set_hl("goField", "#d9d9f0", "NONE")
  set_hl("goFunction", "#82aaff", "NONE", { bold = true })
  set_hl("goFunctionCall", "#ffbf6b", "NONE", { bold = true })
  set_hl("goPackageComment", "#838c93", "NONE", { italic = true })
  set_hl("goString", "#92999f", "NONE")
  set_hl("goReceiverType", "#81a2be", "NONE", { bold = true })
  set_hl_link("goBuiltins", "Keyword")
  set_hl_link("goFormatSpecifier", "PreProc")
  set_hl_link("goImportedPkg", "Statement")
  set_hl_link("goStdlib", "Statement")
  set_hl_link("goStdlibReturn", "PreProc")
end
go_highlight()
