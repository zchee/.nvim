vim.api.nvim_create_user_command("Help", function(opts)
  local help_cmd
  if vim.fn.winwidth(0) > vim.fn.winheight(0) * 2 then
    help_cmd = "vertical rightbelow help " .. opts.args
  else
    help_cmd = "rightbelow help " .. opts.args
  end

  vim.cmd(help_cmd)
end, {
  nargs = "*",
  complete = "help",
})

-- function! s:get_syn_id(transparent)
--   let s:synid = synID(line("."), col("."), 1)
--   if a:transparent
--     return synIDtrans(s:synid)
--   else
--     return s:synid
--   endif
-- endfunction
-- " for syntax attributes
-- function! s:get_syn_attr(synid)
--   let s:name = synIDattr(a:synid, "name")
--   let s:bold  = synIDattr(a:synid, "bold", "gui")
--   let s:guifg = synIDattr(a:synid, "fg", "gui")
--   let s:guibg = synIDattr(a:synid, "bg", "gui")
--   let s:guisp = synIDattr(a:synid, "sp")
--   let s:attr = {
--         \ "name": s:name,
--         \ "bold": s:bold,
--         \ "guifg": s:guifg,
--         \ "guibg": s:guibg,
--         \ "guisp": s:guisp,
--         \ }
--   return s:attr
-- endfunction
--
-- function! s:get_syn_info(cword)
--   let s:baseSyn = s:get_syn_attr(s:get_syn_id(0))
--   let s:baseSynInfo = "name: " . s:baseSyn.name .
--        \ " bold=" . (s:baseSyn.bold == 1 ? 'true' : 'false' ) .
--        \ " guifg=" . ((s:baseSyn.guifg != '') ? s:baseSyn.guifg . "," : "NONE" ) .
--        \ " guibg=" . ((s:baseSyn.guibg != '') ? s:baseSyn.guibg . "," : "NONE" ) .
--        \ " guisp=" . ((s:baseSyn.guisp != '') ? s:baseSyn.guisp . "," : "NONE" )
--   let s:linkedSyn = s:get_syn_attr(s:get_syn_id(1))
--   let s:linkedSynInfo =  "name: " . s:linkedSyn.name .
--        \ " bold=" .  (s:linkedSyn.bold == 1 ? 'true' : 'false' ) .
--        \ " guifg=" . ((s:linkedSyn.guifg != '') ? s:linkedSyn.guifg : "NONE" ) .
--        \ " guibg=" . ((s:linkedSyn.guibg != '') ? s:linkedSyn.guibg : "NONE" ) .
--        \ " guisp=" . ((s:linkedSyn.guisp != '') ? s:linkedSyn.guisp : "NONE" )
--   echomsg a:cword . ':'
--   echomsg s:baseSynInfo
--   echomsg '  ' . "link to"
--   echomsg s:linkedSynInfo
-- endfunction
-- command! SyntaxInfo call s:get_syn_info(expand('<cword>'))

vim.api.nvim_create_user_command("TrimSpace", function()
  local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  local is_binary = vim.api.nvim_get_option_value("binary", { buf = 0 })
  if not is_binary and not (ft == "diff" or ft == "markdown") then
    vim.cmd([[
      normal mz
      normal Hmy
      %s/\s\+$//e
      normal 'yz<CR>
      normal `z
    ]])
  end
end, {
  nargs = "*",
})

vim.api.nvim_create_user_command("LuaVimInspect", function(opts)
  vim.print(vim.inspect(opts.args))
end, {
  nargs = "*",
  desc = "Gets a human-readable representation of the given object.",
  complete = "lua",
})

vim.api.nvim_create_user_command("LuaSnipEdit", function()
  -- requiring a lazy-loaded plugin module loads the plugin on demand
  require("luasnip.loaders").edit_snippet_files()
end, {
  desc = "Edit LuaSnip source.",
})

vim.api.nvim_create_user_command("ManV", function(opts)
  vim.cmd("vertical Man " .. opts.args)
end, {
  desc = "Man with vertical split.",
  complete = function(...)
    return require("man").man_complete(...)
  end,
  nargs = "*",
  bang = true,
  bar = true,
})

-- "" CheckColor:
-- function s:check_colorscheme() abort
--   call nvim_command("edit ~/.nvim/colors/".g:colors_name.".vim | source $VIMRUNTIME/tools/check_colors.vim")
--   wincmd x
--   setlocal filetype=vim
-- endfunction
-- command! CheckColorScheme call s:check_colorscheme()
-- vim.api.nvim_create_user_command("ManV",
--   function(opts)
--     vim.cmd("vertical Man" .. opts.args)
--   end,
--   {
--     desc = "Man with vertical split.",
--     -- complete = "customlist,man#complete",
--     complete = "man#complete",
--     nargs = "*",
--     bang = true,
--     bar = true,
--     range = -1,
--   }
-- )

vim.api.nvim_create_user_command("TerminalV", function(opts)
  vim.cmd("vsplit | terminal " .. opts.args)
end, {
  desc = "Open terminal with vertical split.",
  nargs = "*",
})

vim.api.nvim_create_user_command("LspServerInfo", function(opts)
  local filter = {
    bufnr = 0,
    -- name = opts.args,
  }
  print(vim.inspect(vim.lsp.get_clients(filter)))
end, {
  desc = "Get active clients.",
  nargs = "?",
})

vim.api.nvim_create_user_command("TSInspectTree", function(opts)
  if opts.mods ~= "" or opts.count ~= 0 then
    local count = opts.count ~= 0 and opts.count or ""
    local new = opts.mods ~= "" and "new" or "vnew"

    vim.treesitter.inspect_tree({
      command = ("%s %s%s"):format(opts.mods, count, new),
    })
  else
    vim.treesitter.inspect_tree()
  end

  vim.api.nvim_win_set_width(0, 250)
  vim.opt_local.number = false
  vim.keymap.set("n", "q", "<Cmd>q<CR>", {
    buffer = true,
    desc = "Quick quit the current window",
  })
end, {
  desc = "Inspect treesitter language tree for buffer",
  count = true,
})

vim.api.nvim_create_user_command("DiagramToggle", function()
  vim.cmd("Lazy load diagram.nvim")
end, {
  desc = "Toggle diagram.nvim.",
})

-- Swap the statusline/tabline renderer without restarting; no argument
-- toggles. The choice is written to stdpath("state")/ui-mode and picked up
-- by every later session.
vim.api.nvim_create_user_command("UiMode", function(opts)
  local ui_mode = require("config.ui_mode")
  local want = opts.args ~= "" and opts.args or (ui_mode.uses_plugins() and "chrome" or "plugins")
  local ok, err = ui_mode.set(want)
  if not ok then
    vim.notify("UiMode: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  vim.notify("UiMode: " .. want, vim.log.levels.INFO)
end, {
  nargs = "?",
  complete = function()
    return { "chrome", "plugins" }
  end,
  desc = "Switch the statusline/tabline between config.chrome and lualine+bufferline.",
})

-- Transrator
-- vim.api.nvim_create_user_command("Trans", function()
--   local vstart = vim.fn.getpos("'<")
--   local vend = vim.fn.getpos("'>")
--
--   if not vstart or not vend then
--     return
--   end
--
--   --- @diagnostic disable-next-line
--   local lines = table.concat(vim.fn.getline(vstart[2], vend[2]))
--   lines = lines:gsub("\t", "")
--
--   if not lines:find("// ") then
--     return vim.cmd.TranslateW(lines)
--   end
--   lines = lines:gsub("// ", "")
--
--   return vim.cmd.TranslateW(lines)
-- end, {
--   desc = "ranslate the text from the source language source_lang to the target language target_lang",
--   range = true,
-- })

-- local function get_lenses(bufnr)
--   return {
--     "gc_details",
--     "generate",
--     "regenerate_cgo",
--     "run_govulncheck",
--     "tidy",
--     "upgrade_dependency",
--     "vendor",
--   }
-- end
--
-- local function code_lens() local lenses = get_lenses()
--   vim.ui.select(lenses, {
--     prompt = 'Code lenses:',
--     format_item = function(lens)
--       return lens.command.title
--     end,
--   }, function(lens)
--     if lens then
--       execute_lens(lens)
--     end
--   end)
-- end
--
-- function execute_lens(lens)
--   -- do your thing
-- end

-- Treesitter
-- vim.api.nvim_create_user_command('Inspect', function(cmd)
--   if cmd.bang then
--     vim.print(vim.inspect_pos())
--   else
--     vim.show_pos()
--   end
-- end, { desc = 'Inspect highlights and extmarks at the cursor', bang = true })
--
-- vim.api.nvim_create_user_command('InspectTree', function(cmd)
--   if cmd.mods ~= '' or cmd.count ~= 0 then
--     local count = cmd.count ~= 0 and cmd.count or ''
--     local new = cmd.mods ~= '' and 'new' or 'vnew'
--
--     vim.treesitter.inspect_tree({
--       command = ('%s %s%s'):format(cmd.mods, count, new),
--     })
--   else
--     vim.treesitter.inspect_tree()
--   end
-- end, { desc = 'Inspect treesitter language tree for buffer', count = true })
--
-- vim.api.nvim_create_user_command('EditQuery', function(cmd)
--   vim.treesitter.query.edit(cmd.fargs[1])
-- end, { desc = 'Edit treesitter query', nargs = '?' })
