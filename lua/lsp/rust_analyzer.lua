--- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs
--- https://rust-analyzer.github.io/book/configuration.html

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cachePriming = {
        enabled = true,
        numThreads = "physical",
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
      runnables = {
        extraArgs = { "--release" },
      },
    },
  },
}
