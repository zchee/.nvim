-- Loaded from the rustaceanvim spec's `init` in lua/plugins/init.lua, so it
-- runs before rustaceanvim's own ftplugin reads `vim.g.rustaceanvim`.

-- Keymaps live on LspAttach rather than in `server.on_attach`: rustaceanvim
-- merges `vim.lsp.config["rust-analyzer"]` over its own `server` table with
-- "force", so the global `vim.lsp.config("*")` on_attach set in lua/lsp/init.lua
-- would silently replace ours.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("rustaceanvim_keymaps", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "rust-analyzer" then
      return
    end

    local kopts = { silent = true, buffer = args.buf }
    local map = vim.keymap.set

    map("n", "<leader>ra", function()
      vim.cmd.RustLsp("codeAction")
    end, vim.tbl_extend("force", kopts, { desc = "Rust code action" }))
    map("n", "<leader>rd", function()
      vim.cmd.RustLsp("debuggables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust debuggables" }))
    map("n", "<leader>rr", function()
      vim.cmd.RustLsp("runnables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust runnables" }))
    map("n", "<leader>rR", function()
      vim.cmd.RustLsp({ "runnables", bang = true })
    end, vim.tbl_extend("force", kopts, { desc = "Rerun last runnable" }))
    map("n", "<leader>rt", function()
      vim.cmd.RustLsp("testables")
    end, vim.tbl_extend("force", kopts, { desc = "Rust testables" }))
    map("n", "<leader>rT", function()
      vim.cmd.RustLsp({ "testables", bang = true })
    end, vim.tbl_extend("force", kopts, { desc = "Rerun last test" }))
    map("n", "<leader>rm", function()
      vim.cmd.RustLsp("expandMacro")
    end, vim.tbl_extend("force", kopts, { desc = "Expand macro" }))
    map("n", "<leader>rc", function()
      vim.cmd.RustLsp("openCargo")
    end, vim.tbl_extend("force", kopts, { desc = "Open Cargo.toml" }))
    map("n", "<leader>rp", function()
      vim.cmd.RustLsp("parentModule")
    end, vim.tbl_extend("force", kopts, { desc = "Parent module" }))
    map("n", "<leader>rj", function()
      vim.cmd.RustLsp("joinLines")
    end, vim.tbl_extend("force", kopts, { desc = "Join lines" }))
    map("n", "<leader>rs", function()
      vim.cmd.RustLsp("ssr")
    end, vim.tbl_extend("force", kopts, { desc = "Structural search replace" }))
    map("n", "<leader>re", function()
      vim.cmd.RustLsp("explainError")
    end, vim.tbl_extend("force", kopts, { desc = "Explain error" }))
    map("n", "<leader>rD", function()
      vim.cmd.RustLsp("renderDiagnostic")
    end, vim.tbl_extend("force", kopts, { desc = "Render diagnostic" }))
    map("n", "<leader>rv", function()
      vim.cmd.RustLsp({ "view", "hir" })
    end, vim.tbl_extend("force", kopts, { desc = "View HIR" }))
    map("n", "<leader>rV", function()
      vim.cmd.RustLsp({ "view", "mir" })
    end, vim.tbl_extend("force", kopts, { desc = "View MIR" }))
    map("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, vim.tbl_extend("force", kopts, { desc = "Rust hover actions" }))
  end,
})

---@class rustaceanvim.Opts
local opts = {}
opts.tools = {
  -- auto_focus is what makes `K` jump the cursor into the hover window
  -- (hover_actions.lua calls nvim_set_current_win only when it is set). Left
  -- at the upstream default so the cursor stays in the buffer; the float is
  -- still focusable, so a second `K` enters it to pick an action -- that is
  -- vim.lsp.util.open_floating_preview's focus_id path, not rustaceanvim's.
  float_win_config = { border = "rounded", auto_focus = false },
  code_actions = { ui_select_fallback = true },
  rustc = { default_edition = "2024" },
}
opts.server = {}
-- Resolve rust-analyzer through rustup, not PATH: mason.nvim prepends its
-- bin dir, so a bare "rust-analyzer" picks up Mason's stale standalone
-- binary, which cannot load nightly-toolchain crate graphs (E0432
-- "unresolved import" on every external crate).
opts.server.cmd = { "rustup", "run", "nightly", "rust-analyzer" }
opts.server.default_settings = {
  ["rust-analyzer"] = {
    cargo = {
      features = "all",
      allTargets = false,
      buildScripts = {
        enable = true,
        invocationStrategy = "once",
      },
      extraEnv = {
        RUSTFLAGS = os.getenv("RUSTFLAGS"),
        CARGO_TARGET_DIR = "target/rust-analyzer",
        SKIP_WASM_BUILD = "1",
      },
    },
    check = {
      command = "clippy",
      extraArgs = { "--all", "--", "-W", "clippy::all" },
      extraEnv = {
        CC = "clang",
        CXX = "clang++",
        VIRTUAL_ENV = vim.fn.getcwd() .. "/.venv",
      },
    },
    procMacro = {
      enable = true,
      attributes = { enable = true },
    },
    checkOnSave = true,
    diagnostics = {
      enable = true,
      experimental = { enable = true },
      styleLints = { enable = true },
    },
    inlayHints = {
      chainingHints = { enable = true },
      typeHints = { enable = true, hideClosureInitialization = true },
      parameterHints = { enable = true },
      closureReturnTypeHints = { enable = "with_block" },
      lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
      maxLength = 25,
      bindingModeHints = { enable = true },
      closureCaptureHints = { enable = true },
      discriminantHints = { enable = "fieldless" },
      expressionAdjustmentHints = { enable = "reborrow" },
      rangeExclusiveHints = { enable = true },
    },
    completion = {
      autoimport = { enable = true },
      postfix = { enable = true },
      callable = { snippets = "fill_arguments" },
      fullFunctionSignatures = { enable = true },
      privateEditable = { enable = true },
      hideDeprecated = true,
    },
    imports = {
      granularity = { group = "module" },
      prefix = "self",
      preferNoStd = false,
    },
    lens = {
      enable = true,
      references = {
        adt = { enable = true },
        enumVariant = { enable = true },
        method = { enable = true },
        trait = { enable = true },
      },
      implementations = { enable = true },
      run = { enable = true },
      debug = { enable = true },
    },
    semanticHighlighting = {
      operator = {
        specialization = { enable = true },
      },
      punctuation = {
        enable = true,
        specialization = { enable = true },
      },
      strings = { enable = true },
    },
    hover = {
      actions = {
        enable = true,
        references = { enable = true },
        run = { enable = true },
        debug = { enable = true },
        gotoTypeDef = { enable = true },
        implementations = { enable = true },
      },
      documentation = {
        enable = true,
        keywords = { enable = true },
      },
      links = { enable = true },
    },
    workspace = {
      symbol = {
        search = { kind = "all_symbols" },
      },
    },
    files = {
      exclude = { ".git", "node_modules", ".direnv", "target/debug/build" },
    },
  },
}
opts.dap = { autoload_configurations = true }
vim.g.rustaceanvim = opts
