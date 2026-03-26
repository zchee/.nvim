--- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs
--- https://rust-analyzer.github.io/book/configuration.html

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml", ".git" },
  init_options = {
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
      extraArgs = {
        "--release",
      },
      extraEnv = {
        RUSTC_WRAPPER = "/opt/homebrew/opt/sccache/bin/sccache",
        RUSTFLAGS = os.getenv("RUSTFLAGS"),
        SKIP_WASM_BUILD = "1",
      },
      loadOutDirsFromCheck = true,
    },
    procMacro = {
      enable = true,
    },
    numThreads = 8,
    ["rust-analyzer"] = {
      check = {
        extraArgs = { "--release" },
      },
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
      runnables = {
        extraArgs = { "--release" },
      },
    },
  },
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
      extraArgs = {
        "--release",
      },
      extraEnv = {
        RUSTC_WRAPPER = "/opt/homebrew/opt/sccache/bin/sccache",
        RUSTFLAGS = os.getenv("RUSTFLAGS"),
        SKIP_WASM_BUILD = "1",
      },
      loadOutDirsFromCheck = true,
    },
    procMacro = {
      enable = true,
    },
    numThreads = 8,
    ["rust-analyzer"] = {
      check = {
        extraArgs = { "--release" },
      },
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
      runnables = {
        extraArgs = { "--release" },
      },
    },
  },
}
