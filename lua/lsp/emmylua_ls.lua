local util = require("util")

local lazydev = require("lazydev")

---@type lazydev.Config
lazydev.setup({
  runtime = vim.env.VIMRUNTIME,
  ---@type lazydev.Library.spec[]
  library = {
    "lazy.nvim",
    {
      path = "${3rd}/luv/library",
      words = { "vim%.uv" }
    },
    {
      "plenary.nvim",
      "nvim-treesitter"
    }
  },
  integrations = {
    lspconfig = true,
    cmp = true
  },
  enabled = true,
  debug = false
})

-- https://github.com/EmmyLuaLs/emmylua-analyzer-rust/blob/main/docs/config/emmyrc_json_EN.md
--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("emmylua_ls", "emmylua_ls") },
  root_markers = {
    ".emmyrc.json",
    ".luarc.json",
    ".stylua.toml",
    "init.vim",
    ".git"
  },
  workspace_required = false,
  settings = {
    Lua = {
      completion = {
        enable = true,
        autoRequire = true,
        autoRequireFunction = "require",
        autoRequireNamingConvention = "keep",
        autoRequireSeparator = ".",
        callSnippet = false,
        postfix = "@",
        baseFunctionIncludesName = true
      },
      diagnostics = {
        enable = true,
        globals = {
          "vim",     -- neovim builtin
          "vim.uv",  -- neovim builtin
          "package", -- neovim builtin
          "describe",
          "it",
          "before_each",
          "after_each",
          "teardown",
          "pending",
          "clear"    -- Busted
        },
        disable = {
          "redundant-parameter",
          "duplicate-set-field"
        }
      },
      format = {
        externalTool = {
          program = "stylua",
          args = {
            "-",
            "--stdin-filepath",
            "${file}"
          },
          timeout = 5000
        },
        externalToolRangeFormat = {
          program = "stylua",
          args = {
            "-",
            "--stdin-filepath",
            "${file}",
            "--indent-width=${indent_size}",
            "--indent-type",
            "${use_tabs?Tabs:Spaces}",
            "--range-start=${start_offset}",
            "--range-end=${end_offset}"
          },
          timeout = 5000
        },
        enable = true
      },
      hint = {
        enable = true,
        paramHint = true,
        indexHint = true,
        localHint = true,
        overrideHint = true,
        metaCallHint = true,
        enumParamHint = false
      },
      codeLens = {
        enable = true
      },
      hover = {
        enable = true
      },
      runtime = {
        version = "LuaJIT"
      },
      semanticTokens = {
        enabled = true,
        renderDocumentationMarkup = true
      },
      signatureHelp = {
        detailSignatureHelper = false
      },
      telemetry = {
        enable = false
      },
      workspace = {
        ignoreDir = {
          ".*_tmp/.*"
        },
        library = {
          vim.fs.joinpath(vim.fn.stdpath("config"), "lua"),
          vim.env.VIMRUNTIME,
          vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/busted/library"),
          vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/luassert/library"),
          vim.fs.joinpath(util.src_path("github.com/LuaLS/LLS-Addons"), "addons/luvit/library")
        }
      }
    }
  },
  on_init = function(client)
    ---@diagnostic disable-next-line
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      workspace = { library = vim.api.nvim_get_runtime_file("", true) }
    })
  end
}
