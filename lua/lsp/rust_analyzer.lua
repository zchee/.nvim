--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  root_markers = { "Cargo.toml", ".git" },
  init_options = {
    server = {
      extraEnv = {
        ["RUSTUP_TOOLCHAIN"] = "nightly",
        ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
        ["CHALK_OVERFLOW_DEPTH"] = "100000000",
        ["CHALK_SOLVER_MAX_SIZE"] = "100000000",
      },
    },
    ["rust-analyzer"] = {
      completion = {
        fullFunctionSignatures = {
          enable = true,
        },
        hideDeprecated = true,
      },
      -- diagnostics = {
      --   experimental = "enable",
      -- },
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
    }
  },
  settings = {
    server = {
      extraEnv = {
        ["RUSTUP_TOOLCHAIN"] = "nightly",
        ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
        ["CHALK_OVERFLOW_DEPTH"] = "100000000",
        ["CHALK_SOLVER_MAX_SIZE"] = "100000000",
      },
    },
    ["rust-analyzer"] = {
      completion = {
        fullFunctionSignatures = {
          enable = true,
        },
        hideDeprecated = true,
      },
      -- diagnostics = {
      --   experimental = "enable",
      -- },
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
    }
  },
  --   cachePriming = {
  --     numThreads = "physical",
  --   },
  --   completion = {
  --     privateEditable = {
  --       enable = true,
  --     },
  --   },
  --   diagnostics = {
  --     experimental = {
  --       enable = true,
  --     },
  --   },
  --   files = {
  --     watcher = "server",
  --   },
  --   hover = {
  --     actions = {
  --       references = {
  --         enable = true,
  --       },
  --     },
  --     memoryLayout = {
  --       niches = true,
  --       offset = "both",
  --       padding = "both",
  --     },
  --   },
  --   numThreads = "physical",
  --   workspace = {
  --     symbol = {
  --       search = {
  --         kind = "all_symbols",
  --         scope = "workspace_and_dependencies",
  --       },
  --     },
  --   },
  -- },

  -- rust = {
  --   analyzerTargetDir = "target/rust-analyzer",
  --   extraEnv = {
  --     ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
  --   },
  -- },
  -- cargo = {
  --   features = "all",
  --   extraEnv = {
  --     ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
  --     ["SKIP_WASM_BUILD"] = "1",
  --   },
  --   loadOutDirsFromCheck = true,
  --   buildScripts = {
  --     enable = true,
  --   },
  -- },
  -- rustfmt = {
  --   -- extraArgs = { "+nightly-2023-11-01" },
  -- },
  -- -- imports = {
  -- --   granularity = {
  -- --     group = "module",
  -- --   },
  -- --   prefix = "self",
  -- -- },
  -- procMacro = {
  --   enable = true,
  -- },
}
