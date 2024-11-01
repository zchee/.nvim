vim.api.nvim_create_user_command("LuaVimInspect",
  function(opts)
    print(vim.inspect(opts.args))
  end,
  {
    nargs = "*",
    desc = "Gets a human-readable representation of the given object.",
    complete = "lua",
  }
)

vim.api.nvim_create_user_command("ManV",
  function(opts)
    vim.cmd("vertical Man " .. opts.args)
  end,
  {
    desc = "Man with vertical split.",
    complete = function(...)
      return require('man').man_complete(...)
    end,
    nargs = "*",
    bang = true,
    bar = true,
  }
)

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

vim.api.nvim_create_user_command("TerminalV",
  function(opts)
    vim.cmd("vsplit | terminal " .. opts.args)
  end,
  {
    desc = "Open terminal with vertical split.",
    nargs = "*",
  }
)

vim.api.nvim_create_user_command("LspServerInfo",
  function(opts)
    local filter = {
      bufnr = 0,
      -- name = opts.args,
    }
    print(vim.inspect(vim.lsp.get_clients(filter)))
  end,
  {
    desc = "Get active clients.",
    nargs = "?",
  }
)

vim.api.nvim_create_user_command("TSInspectTree",
  function(opts)
    if opts.mods ~= '' or opts.count ~= 0 then
      local count = opts.count ~= 0 and opts.count or ''
      local new = opts.mods ~= '' and 'new' or 'vnew'

      vim.treesitter.inspect_tree({
        command = ('%s %s%s'):format(opts.mods, count, new),
      })
    else
      vim.treesitter.inspect_tree()
    end

    vim.api.nvim_win_set_width(0, 250)
    vim.opt_local.number = false
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<Cmd>q<CR>",
      {
        noremap = true,
        script = true,
        desc = "Quick quit the current window",
      }
    )
  end,
  {
    desc = 'Inspect treesitter language tree for buffer',
    count = true,
  }
)

-- Transrator
vim.api.nvim_create_user_command("Trans",
  function()
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")

    if not vstart or not vend then
      return
    end

    --- @diagnostic disable-next-line
    local lines = table.concat(vim.fn.getline(vstart[2], vend[2]))
    lines = lines:gsub("\t", "")

    if not lines:find("// ") then
      return vim.cmd.TranslateW(lines)
    end
    lines = lines:gsub("// ", "")

    return vim.cmd.TranslateW(lines)
  end,
  {
    desc = 'ranslate the text from the source language source_lang to the target language target_lang',
    range = true,
  }
)

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
