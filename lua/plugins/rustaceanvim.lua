local util = require("util")

---@type rustaceanvim.Opts
vim.g.rustaceanvim = {
  tools = {
    rustc = {
      default_edition = "2024",
    },
  },
  ---@type rustaceanvim.lsp.ClientOpts
  server = {
    auto_attach = true,
    -- auto_attach = function(bufnr)
    --   if #vim.bo[bufnr].buftype > 0 then
    --     return false
    --   end
    --   local path = vim.api.nvim_buf_get_name(bufnr)
    --   if not require('rustaceanvim.os').is_valid_file_path(path) then
    --     return false
    --   end
    --   local cmd = require('rustaceanvim.types.internal').evaluate(RustaceanConfig.server.cmd)
    --   if type(cmd) == 'function' then
    --     -- This could be a function that connects via a TCP socket, so we don't want to evaluate it.
    --     return true
    --   end
    --   ---@cast cmd string[]
    --   local rs_bin = cmd[1]
    --   return vim.fn.executable(rs_bin) == 1
    -- end,
    cmd = { "rustup", "run", "nightly", "rust-analyzer" },
    --- Defaults to `nil`, which means rustaceanvim will use the built-in async root directory detection
    ---@type nil | string | fun(filename: string, default: fun(filename: string):string|nil):string|nil
    root_dir = nil,
    ra_multiplex = {
      ---@type boolean
      enable = true,
      ---@type string
      host = '127.0.0.1', -- default
      ---@type integer
      port = 27631,       -- default
    },
    -- settings = {
    --   server = {
    --     extraEnv = {
    --       ["RUSTUP_TOOLCHAIN"] = "nightly",
    --       ["RUSTFLAGS"] = os.getenv("RUSTFLAGS"),
    --       ["CHALK_OVERFLOW_DEPTH"] = "100000000",
    --       ["CHALK_SOLVER_MAX_SIZE"] = "100000000",
    --     },
    --   },
    --   ["rust-analyzer"] = {
    --     completion = {
    --       fullFunctionSignatures = {
    --         enable = true,
    --       },
    --       hideDeprecated = true,
    --     },
    --     diagnostics = {
    --       experimental = "enable",
    --     },
    --     inlayHints = {
    --       bindingModeHints = {
    --         enable = true,
    --       },
    --       closureCaptureHints = {
    --         enable = true,
    --       },
    --       genericParameterHints = {
    --         lifetime = {
    --           enable = true,
    --         },
    --         type = {
    --           enable = true,
    --         },
    --       },
    --       implicitSizedBoundHints = {
    --         enable = true,
    --       },
    --       lifetimeElisionHints = {
    --         useParameterNames = true,
    --       },
    --     },
    --     runnables = {
    --       extraArgs = { "--release" },
    --     },
    --   }
    -- },
    default_settings = {
      ["rust-analyzer"] = {
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
      }
    },
    standalone = true,
    status_notify_level = false,
    capabilities = require('rustaceanvim.config.server').create_client_capabilities(),
  },
  dap = {
    adapter = {
      type = 'executable',
      command = '/opt/homebrew/opt/llvm/bin/lldb-dap',
      name = 'lldb',
    },
    autoload_configurations = true,
  },
}
