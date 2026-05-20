--- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs
--- https://rust-analyzer.github.io/book/configuration.html

---@return string?
local default_toolchain = function()
  local ok, result = pcall(function()
    return vim.system({ "rustup", "default" }, { text = true }):wait()
  end)

  if not ok or not result or result.code ~= 0 then
    return nil
  end

  return (result.stdout or ""):match("^(%S+)")
end

---@return string[]
local rust_analyzer_cmd = function()
  local toolchain = default_toolchain()
  if not toolchain then
    return { "rust-analyzer" }
  end

  return { "rustup", "run", toolchain, "rust-analyzer" }
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = rust_analyzer_cmd(),
  root_markers = { "rust-toolchain.toml", "Cargo.toml", ".git" },
  settings = {
    cachePriming = {
      enabled = true,
      numThreads = 8,
    },
    cargo = {
      allTargets = false,
      buildScripts = {
        enable = true,
        seRustcWrapper = true,
        invocationStrategy = "once",
      },
      -- extraArgs = {
      --   "--release",
      -- },
      extraEnv = {
        RUSTC_WRAPPER = "/opt/homebrew/opt/sccache/bin/sccache",
        RUSTFLAGS = os.getenv("RUSTFLAGS"),
        CARGO_TARGET_DIR = "target/rust-analyzer",
        SKIP_WASM_BUILD = "1",
      },
      loadOutDirsFromCheck = true,
    },
    procMacro = {
      enable = true,
    },
    numThreads = 8,
    ["rust-analyzer"] = {
      check = {},
      completion = {
        fullFunctionSignatures = {
          enable = true,
        },
        hideDeprecated = true,
      },
      diagnostics = {
        experimental = "enable",
      },
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      inlayHints = {
        bindingModeHints = {
          enable = true,
        },
        closureCaptureHints = {
          enable = true,
        },
        genericParameterHints = {
          lifetime = {
            enable = true,
          },
          type = {
            enable = true,
          },
        },
        implicitSizedBoundHints = {
          enable = true,
        },
        lifetimeElisionHints = {
          useParameterNames = true,
        },
      },
      rustfmt = {
        -- extraArgs = { "+nightly-2023-11-01" },
      },
      runnables = {},
    },
  },
}
