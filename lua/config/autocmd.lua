local autocmd_user = vim.api.nvim_create_augroup("AutocmdUser", { clear = false })

-- FileType
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = autocmd_user,
  pattern = {
    "man",
    "qf",
    "quickrun",
    "ref",
    "startuptime",
  },
  callback = function()
    vim.opt_local.colorcolumn = ""

    vim.api.nvim_buf_set_keymap(0, "n", "u", "<C-u>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "d", "<C-d>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { silent = true })
  end,
})

-- BufNewFile, BufReadPost
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = autocmd_user,
  pattern = {
    "json",
  },
  callback = function()
    local bufname = tostring(vim.fn.bufname())

    if bufname == "package.json" or string.find(bufname, ".*%.schema%.json$") then
      vim.opt_local.expandtab = true
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.tabstop = 2
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  group = autocmd_user,
  pattern = {
    "/System/Library/*",
    "/Applications/Xcode%.*",
    "/usr/include/*",
    "/usr/lib/*",
  },
  callback = function()
    vim.opt_local.readonly = true
    vim.opt_local.modified = false
  end,
})

-- BufEnter
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = autocmd_user,
  pattern = {
    "COMMIT_EDITMSG",
    "option-window",
  },
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = autocmd_user,
  pattern = {
    "**/colors/*",
    "**/highlight.lua",
    "**/kitty/color.conf",
  },
  callback = function()
    vim.cmd.ColorizerToggle()
  end,
})

-- BufWinEnter
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = autocmd_user,
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then --  and not vim.bo.filetype == "gitcommit" and not vim.bo.filetype == "gitrebase"
      vim.cmd([[
        execute "silent! keepjumps normal! g`\"zz\""
      ]])
    end
  end,
})

-- WinEnter
vim.api.nvim_create_autocmd({ "WinEnter" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    -- http://stackoverflow.com/questions/7476126/how-to-automatically-close-the-quick-fix-window-when-leaving-a-file
    local only_one_window = vim.fn.winnr("$") == 1
    if only_one_window then
      local is_ft = function(ft)
        return vim.o.filetype == ft
      end

      local is_nvimtree = vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr()
      if is_nvimtree or is_ft("qt") or is_ft("git") or is_ft("vista_kind") then
        vim.fn.quit()
      end
    end
  end,
})

-- BufWritePre
-- local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormat", { clear = true })
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   group = lsp_format_augroup,
--   pattern = {
--     "*.lua",
--     "*.tf",
--     "*.tfvars",
--     "*.ts",
--   },
--   callback = function()
--     vim.lsp.buf.format({
--       async = false,
--       trimTrailingWhitespace = true,
--       insertFinalNewline = true,
--       trimFinalNewlines = true,
--     })
--   end,
-- })

local tableContains = function(tbl, value)
  for i = 1, #tbl do
    if (tbl[i] == value) then
      return true
    end
  end
  return false
end

-- Codelenses:
-- AddDependency           Command = "add_dependency"
-- AddImport               Command = "add_import"
-- AddTelemetryCounters    Command = "add_telemetry_counters"
-- ApplyFix                Command = "apply_fix"
-- ChangeSignature         Command = "change_signature"
-- CheckUpgrades           Command = "check_upgrades"
-- DiagnoseFiles           Command = "diagnose_files"
-- EditGoDirective         Command = "edit_go_directive"
-- FetchVulncheckResult    Command = "fetch_vulncheck_result"
-- GCDetails               Command = "gc_details"
-- Generate                Command = "generate"
-- GoGetPackage            Command = "go_get_package"
-- ListImports             Command = "list_imports"
-- ListKnownPackages       Command = "list_known_packages"
-- MaybePromptForTelemetry Command = "maybe_prompt_for_telemetry"
-- MemStats                Command = "mem_stats"
-- RegenerateCgo           Command = "regenerate_cgo"
-- RemoveDependency        Command = "remove_dependency"
-- ResetGoModDiagnostics   Command = "reset_go_mod_diagnostics"
-- RunGoWorkCommand        Command = "run_go_work_command"
-- RunGovulncheck          Command = "run_govulncheck"
-- RunTests                Command = "run_tests"
-- StartDebugging          Command = "start_debugging"
-- StartProfile            Command = "start_profile"
-- StopProfile             Command = "stop_profile"
-- Test                    Command = "test"
-- Tidy                    Command = "tidy"
-- ToggleGCDetails         Command = "toggle_gc_details"
-- UpdateGoSum             Command = "update_go_sum"
-- UpgradeDependency       Command = "upgrade_dependency"
-- Vendor                  Command = "vendor"
-- Views                   Command = "views"
-- WorkspaceStats          Command = "workspace_stats"
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("LspOrganizeImports", { clear = false }),
  pattern = {
    "*",
  },
  callback = function(e)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
    local ft_list = {
      "go",
    }
    if not tableContains(ft_list, ft) then
      return
    end

    if
        string.find(tostring(vim.uv.fs_realpath(vim.api.nvim_buf_get_name(e.buf))), "bytedance/sonic") -- ignore bytedance/sonic
    then
      return
    end

    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end

    vim.lsp.buf.format({
      -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#formattingOptions
      formatting_options = {
        trimTrailingWhitespace = true,
        insertFinalNewline = true,
        trimFinalNewlines = true,
      },
      async = false,
    })
  end,
})

-- FocusGained
-- github.com/vovkasm/input-source-switcher
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    if vim.fn.executable("issw") then
      vim.fn.jobstart("issw com.apple.keylayout.ABC", { detach = true })
    end
  end,
})

-- InsertLeave
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  group = autocmd_user,
  pattern = { "*" },
  callback = function()
    vim.opt.paste = false
  end,
})

-- TermOpen
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = autocmd_user,
  callback = function()
    vim.opt_local.number = false
    vim.cmd.startinsert()
  end,
})

-- Go
--- gomod
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "go.mod",
  callback = function()
    vim.api.nvim_buf_create_user_command(0, "GomodPinReplace",
      function()
        vim.cmd("'<,'>s/^\\t\\(.*\\)\\s\\(.*\\)/\\t\\1 => \\1 \\2/g | nohlsearch")
      end,
      {
        range = true,
        desc = "substitutes gomod replace packages",
      }
    )
    vim.api.nvim_buf_create_user_command(0, "GomodLatest",
      function()
        vim.cmd("'<,'>s/ v[a-z0-9.-]*/ latest/g | nohlsearch")
      end,
      {
        range = true,
        desc = "substitutes module version to latest",
      }
    )
  end,
})

-- kitty
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
  end,
})

-- Debug:
-- vim.api.nvim_create_autocmd(
--   {
--     "BufReadPre",
--     "BufReadPost",
--     "BufWinEnter",
--   },
--   {
--     group = autocmd_user,
--     pattern = { "*" },
--     callback = function(args)
--       local ev = vim.inspect("event: " .. args.event)
--       vim.cmd.echomsg(ev)
--     end,
--   }
-- )
