local go = require("go")

go.setup({
  gisable_defaults = false, -- either true when true disable all default settings
  go = "go",                -- set to go1.18beta1 if necessary
  goimport = "gopls",       -- if set to 'gopls' will use gopls format, also goimport
  fillstruct = "gopls",
  gofmt = "gofumpt",        -- if set to gopls will use gopls format
  max_line_len = 128,
  tag_transform = false,
  tag_options = "json=omitempty",

  gotests_template = "",     -- sets gotests -template parameter (check gotests for details)
  gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)

  comment_placeholder = "",
  icons = {
    breakpoint = "🧘",
    currentpos = "🏃",
  },                 -- set to false to disable icons setup

  sign_priority = 7, -- set priority of signs used by go.nevim
  verbose = false,

  -- log_path = vfn.expand('$HOME') .. '/tmp/gonvim.log',
  lsp_cfg = true, -- false: do nothing
  -- true: apply non-default gopls setup defined in go/lsp.lua
  -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
  lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua for gopls,
  --      when lsp_cfg is true
  -- if lsp_on_attach is a function: use this function as on_attach function for gopls,
  --                                 when lsp_cfg is true
  lsp_on_client_start = nil, -- it is a function with same signature as on_attach, will be called at end of
  -- on_attach and allows you override some setup
  lsp_document_formatting = true,
  -- set to true: use gopls to format
  -- false if you want to use other formatter tool(e.g. efm, nulls)

  null_ls_document_formatting_disable = false, -- true: disable null-ls formatting
  -- if enable gopls to format the code and you also installed and enabled null-ls, you may
  -- want to disable null-ls by setting this to true
  -- it can be a nulls source name e.g. `golines` or a nulls query table
  lsp_keymaps = false,  -- true: use default keymaps defined in go/lsp.lua
  lsp_codelens = true,
  diagnostici = {
    hdlr = true, -- hook lsp diag handler
    underline = true,
    virtual_text = { space = 0, prefix = '■' },
    signs = true,
  },
  -- virtual text setup
  lsp_inlay_hints = {
    enable = true,

    -- Only show inlay hints for the current line
    only_current_line = false,

    -- Event which triggers a refresh of the inlay hints.
    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
    -- not that this may cause higher CPU usage.
    -- This option is only respected when only_current_line and
    -- autoSetHints both are true.
    only_current_line_autocmd = "CursorMoved,CursorMovedI",

    -- whether to show variable name before type hints with the inlay hints or not
    -- default: false
    show_variable_name = true,

    -- prefix for parameter hints
    parameter_hints_prefix = "󰊕",
    show_parameter_hints = true,

    -- prefix for all the other hints (type, chaining)
    -- default: "=>"
    other_hints_prefix = "=>",

    -- whether to align to the length of the longest line in the file
    max_len_align = false,

    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,

    -- whether to align to the extreme right or not
    right_align = false,

    -- padding from the right if right_align is true
    right_align_padding = 6,

    -- The color of the hints
    highlight = "Comment",
  },

  lsp_diag_update_in_insert = false,
  lsp_fmt_async = false, -- async lsp.buf.format
  -- go_boilplater_url = "https://github.com/thockin/go-build-template.git",
  gopls_cmd = nil,       --- you can provide gopls path and cmd if it not in PATH, e.g. cmd = {  "/home/ray/.local/nvim/data/lspinstall/go/gopls" }
  gopls_remote_auto = false,
  gocoverage_sign = '█',
  gocoverage_skip_covered = false,
  sign_covered_hl = "String",     --- highlight group for test covered sign
  sign_partial_hl = "WarningMsg", --- highlight group for test partially covered sign
  sign_uncovered_hl = "Error",    -- highlight group for uncovered code
  launch_json = nil,              -- the launch.json file path, default to .vscode/launch.json -- launch_json = vim.fn.getcwd() .. "/.vscode/launch.json",
  dap_debug = true,
  dap_debug_gui = {},             -- bool|table put your dap-ui setup here set to false to disable
  dap_debug_keymap = true,        -- true: use keymap for debugger defined in go/dap.lua. false: do not use keymap in go/dap.lua.  you must define your own.
  dap_debug_vt = {                -- bool|table put your dap-virtual-text setup here set to false to disable
    enabled_commands = true,
    all_frames = true,
  },
  dap_port = 38697,          -- can be set to a number or -1 so go.nvim will pickup a random port
  dap_timeout = 15,          --  see dap option initialize_timeout_sec = 15,
  dap_retries = 20,          -- see dap option max_retries
  build_tags = "",           --- you can provide extra build tags for tests or debugger
  textobjects = true,        -- treesitter binding for text objects
  test_runner = "gotestsum", -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
  verbose_tests = true,      -- set to add verbose flag to tests deprecated see '-v'
  run_in_floaterm = false,   -- set to true to run in float window.
  floaterm = {
    posititon = "auto",      -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
    width = 0.45,            -- width of float window if not auto
    height = 0.98,           -- height of float window if not auto
  },
  trouble = false,           -- true: use trouble to open quickfix
  test_efm = false,          -- errorfomat for quickfix, default mix mode, set to true will be efm only

  luasnip = false,           -- enable included luasnip
  username = "zchee",
  useremail = "zchee.io@gmail.com",
  disable_per_project_cfg = false,                                             -- set to true to disable load script from .gonvim/init.lua
  on_jobstart = function(cmd) _ = cmd end,                                     -- callback for stdout
  on_stdout = function(err, data) _, _ = err, data end,                        -- callback when job started
  on_stderr = function(err, data) _, _ = err, data end,                        -- callback for stderr
  on_exit = function(code, signal, output) _, _, _ = code, signal, output end, -- callback for jobexit, output : string
  iferr_vertical_shift = 4                                                     -- defines where the cursor will end up vertically from the begining of if err statement after GoIfErr command

  -- disable_defaults = true,                        -- true|false when true set false to all boolean settings and replace all table
  -- go = "go",                                      -- go command, can be go[default] or go1.18beta1
  -- goimport = "gopls",                             -- goimport command, can be gopls[default] or goimport
  -- fillstruct = "gopls",                           -- can be nil (use fillstruct, slower) and gopls
  -- gofmt = "gofumpt",                              --gofmt cmd,
  -- max_line_len = 200,                             -- max line length in golines format, Target maximum line length for golines
  -- tag_transform = false,                          -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
  -- tag_options = "json=omitempty",                 -- sets options sent to gomodifytags, i.e., json=omitempty
  -- gotests_template = "",                          -- sets gotests -template parameter (check gotests for details)
  -- gotests_template_dir = "",                      -- sets gotests -template_dir parameter (check gotests for details)
  -- comment_placeholder = " ",                      -- comment_placeholder your cool placeholder e.g. ﳑ       
  -- icons = { breakpoint = "🧘", currentpos = "🏃" }, -- setup to `false` to disable icons setup
  -- verbose = false,                                -- output loginf in messages
  -- lsp_cfg = false,                                -- true: use non-default gopls setup specified in go/lsp.lua
  -- -- false: do nothing
  -- -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
  -- --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
  -- lsp_gofumpt = false,   -- true: set default gofmt in gopls format to gofumpt
  -- lsp_on_attach = false, -- nil: use on_attach function defined in go/lsp.lua,
  -- --      when lsp_cfg is true
  -- -- if lsp_on_attach is a function: use this function as on_attach function for gopls
  -- lsp_keymaps = true,  -- set to false to disable gopls/lsp keymap
  -- lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
  -- -- function(bufnr)
  -- --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
  -- -- end
  -- -- to setup a table of codelens
  -- lsp_diag_hdlr = true, -- hook lsp diag handler
  -- lsp_diag_underline = true,
  -- -- virtual text setup
  -- lsp_diag_virtual_text = { space = 0, prefix = "" },
  -- lsp_diag_signs = true,
  -- lsp_diag_update_in_insert = false,
  -- lsp_document_formatting = true,
  -- -- set to true: use gopls to format
  -- -- false if you want to use other formatter tool(e.g. efm, nulls)
  -- lsp_inlay_hints = {
  --   enable = false,
  --   -- Only show inlay hints for the current line
  --   -- only_current_line = false,
  --   -- -- Event which triggers a refersh of the inlay hints.
  --   -- -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
  --   -- -- not that this may cause higher CPU usage.
  --   -- -- This option is only respected when only_current_line and
  --   -- -- autoSetHints both are true.
  --   -- only_current_line_autocmd = "CursorHold",
  --   -- -- whether to show variable name before type hints with the inlay hints or not
  --   -- -- default: false
  --   -- show_variable_name = true,
  --   -- -- prefix for parameter hints
  --   -- parameter_hints_prefix = " ",
  --   -- show_parameter_hints = true,
  --   -- -- prefix for all the other hints (type, chaining)
  --   -- other_hints_prefix = "=> ",
  --   -- -- whether to align to the lenght of the longest line in the file
  --   -- max_len_align = false,
  --   -- -- padding from the left if max_len_align is true
  --   -- max_len_align_padding = 1,
  --   -- -- whether to align to the extreme right or not
  --   -- right_align = false,
  --   -- -- padding from the right if right_align is true
  --   -- right_align_padding = 6,
  --   -- -- The color of the hints
  --   -- highlight = "Comment",
  -- },
  -- gopls_cmd = { "/Users/zchee/go/bin/gopls", "-remote=unix;/tmp/gopls.sock" },
  -- gopls_remote_auto = false, -- add -remote=auto to gopls
  -- gocoverage_sign = "█",
  -- sign_priority = 5,         -- change to a higher number to override other signs
  -- dap_debug = true,          -- set to false to disable dap
  -- dap_debug_keymap = true,   -- true: use keymap for debugger defined in go/dap.lua
  -- -- false: do not use keymap in go/dap.lua.  you must define your own.
  -- -- windows: use visual studio keymap
  -- dap_debug_gui = {},                                            -- bool|table put your dap-ui setup here set to false to disable
  -- dap_debug_vt = { enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable
  -- dap_port = 38697,                                              -- can be set to a number, if set to -1 go.nvim will pickup a random port
  -- dap_timeout = 15,                                              --  see dap option initialize_timeout_sec = 15,
  -- dap_retries = 20,                                              -- see dap option max_retries
  -- build_tags = nil,                                              -- set default build tags
  -- textobjects = true,                                            -- enable default text jobects through treesittter-text-objects
  -- test_runner = "gotestsum",                                     -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
  -- verbose_tests = true,                                          -- set to add verbose flag to tests deprecated, see '-v' option
  -- run_in_floaterm = false,                                       -- set to true to run in float window. :GoTermClose closes the floatterm
  -- -- float term recommend if you use richgo/ginkgo with terminal color
  --
  -- trouble = false,  -- true: use trouble to open quickfix
  -- test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
  -- luasnip = true,
})
