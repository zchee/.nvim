--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  cmd = { vim.fs.joinpath(os.getenv("RUST_HOME"), "cargo", "bin", "rust-analyzer") },
  settings = {
    server = {
      extraEnv = {
        ["RUSTUP_TOOLCHAIN"] = "nightly",
        ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
        ["CHALK_OVERFLOW_DEPTH"] = "100000000",
        ["CHALK_SOLVER_MAX_SIZE"] = "100000000",
      },
    },
    rust = {
      analyzerTargetDir = "target/rust-analyzer",
      extraEnv = {
        ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
      },
    },
    cargo = {
      features = "all",
      extraEnv = {
        ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
        ["SKIP_WASM_BUILD"] = "1",
      },
      loadOutDirsFromCheck = true,
      -- buildScripts = {
      --   enable = true,
      -- },
    },
    rustfmt = {
      -- extraArgs = { "+nightly-2023-11-01" },
    },
    -- imports = {
    --   granularity = {
    --     group = "module",
    --   },
    --   prefix = "self",
    -- },
    procMacro = {
      enable = true,
    },
    diagnostics = {
      experimental = {
        enable = true
      }
    }
  }
}
