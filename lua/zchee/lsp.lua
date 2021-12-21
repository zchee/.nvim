local bashls_config = {}
local clangd_config = {}

local cmake_config = {
  on_init = function(client)
    client.config.settings = {
      cmake = {
        buildDirectory = 'build',
      }
    }

    client.notify('workspace/didChangeConfiguration')
    return true
  end
}

local dockerls_config = {
  root_dir = require('lspconfig.util').root_pattern('Dockerfile', '*.dockerfile', 'Dockerfile.*'),
  on_init = function(client)
    client.config.settings = {
      docker = {
        languageserver = {
          diagnostics = {
            -- string values must be equal to "ignore", "warning", or "error"
            deprecatedMaintainer = 'error',
            directiveCasing = 'warning',
            emptyContinuationLine = 'ignore',
            instructionCasing = 'error',
            instructionCmdMultiple = 'error',
            instructionEntrypointMultiple = 'error',
            instructionHealthcheckMultiple = 'error',
            instructionJSONInSingleQuotes = 'error',
          },
          formatter = {
            ignoreMultilineInstructions = true,
          }
        }
      }
    }

    client.notify('workspace/didChangeConfiguration')
    return true
  end
}

local jsonls_config = {}

local gopls_config = {
  filetypes = { 'go', 'gomod', 'gotexttmpl' },
  on_init = function(client)
    local cwd = vim.fn.getcwd()

    local update_env = function()
      local envs = {
        [ 'GOPRIVATE' ] = { 'github.com/kouzoh' },
      }
      if string.find(cwd, 'moby/buildkit') then
        envs = vim.tbl_deep_extend('keep', envs, {
          [ 'GOOS' ] = { 'linux' },
        })
      end
      if string.find(cwd, 'go%-clang/gen') then
        envs = vim.tbl_deep_extend('keep', envs, {
          [ 'CGO_CFLAGS' ] = { '-Wno-deprecated-declarations' },
          [ 'CGO_LDFLAGS' ] = { '-L/opt/llvm/13/lib -Wl,%-rpath,/opt/llvm/13/lib' },
        })
      end
      return envs
    end

    local update_buildFlags = function()
      local flags = {}
      if string.find(cwd, 'buildkit') then
        flags = vim.tbl_deep_extend('keep', flags, { '%-tags=linux' })
      end
      return flags
    end

    client.config.settings.env = update_env()
    client.config.settings.buildFlags = update_buildFlags()

    client.notify('workspace/didChangeConfiguration')
    return true
  end
}

-- https://github.com/microsoft/pyright/blob/main/packages/vscode-pyright/package.json
local pyright_config = {
  on_init = function(client)
    client.config.settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          autoSearchPaths = true,
          extraPaths = {
            '/usr/local/google-cloud-sdk/lib',
            '/usr/local/google-cloud-sdk/lib/third_party',
            vim.fn.getcwd()..'/third_party',
          },
          diagnosticMode = 'workspace',
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
        },
        pythonPath = '/usr/local/opt/python@3.10/bin/python3.10',
      }
    }

    client.notify('workspace/didChangeConfiguration')
    return true
  end
}

local solargraph_config = {}
local rust_analyzer_config = {}
local tsserver_config = {}
local sourcekit_config = {}
local terraformls_config = {}
local yamlls_config = {}

local on_attach = function(client, bufnr)
  _ = client

  -- mappings
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=false }

  buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', '<Leader>e', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- if vim.fn.eval('&filetype') ~= 'go' then
  --   -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  --   buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  --   buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  --   buf_set_keymap('n', '<LocalLeader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --   buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --   -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --   -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --   -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  --   buf_set_keymap('n', '<LocalLeader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  --   buf_set_keymap('n', '<LocalLeader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  --   buf_set_keymap('n', '<LocalLeader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  --   -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  --   -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  --   -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --   -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  --   buf_set_keymap('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- else
  --   buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- end
end

-- config that activates keymaps and enables snippet support
local function make_config()
  local coq = require("coq")
  local capabilities = coq.lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = false

  return {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

local function setup_servers()
  local lsp_installer = require('nvim-lsp-installer')
  lsp_installer.on_server_ready(function(server)
    local path = require('nvim-lsp-installer.path')
    local servers = require('nvim-lsp-installer.servers')

    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    table.insert(runtime_path, vim.fn.stdpath('data')..'/site/pack/packer/start/?/lua/?.lua')
    table.insert(runtime_path, vim.fn.stdpath('data')..'/site/pack/packer/opt/?/lua/?.lua')

    local config = make_config()
    local luadev = require("lua-dev").setup({
      library = {
        vimruntime = true,
        types = true,
        plugins = true,
      },
      lspconfig = {
        cmd = {
          path.concat { servers.get_server_install_path('sumneko_lua'), 'lua-language-server', 'bin', 'macOS', 'lua-language-server' },
          '-E',
          path.concat { servers.get_server_install_path('sumneko_lua'), 'lua-language-server', 'main.lua' },
        },
        -- https://github.com/sumneko/lua-language-server/blob/master/script/config/config.lua
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
              path = runtime_path,
              unicodeName = true,
            },
            diagnostics = {
              enable = true,
              disable = {
                'trailing-space',
              },
              globals = {
                'vim',  -- Neovim
                'describe', 'it', 'before_each', 'after_each', 'teardown', 'pending', 'clear',  -- Busted
              }
            },
            workspace = {
              maxPreload = 10000,
              preloadFileSize = 10000,
              library = vim.api.nvim_get_runtime_file('', true),
            },
            completion = {
              enable = true,
            },
            hint = {
              enable = true,
            },
            telemetry = {
              enable = true,
            },
          },
          editor = {
            semanticHighlighting = {
              enabled = true,
            },
          },
        }
      },
    })

    -- if server.name == "bashls" then
    --   config.cmd = bash_config.cmd
    -- end
    -- if server.name == "clangd" then
    --   config.cmd = clangd_config.cmd
    -- end
    if server.name == 'cmake' then
      config.on_init = cmake_config.on_init
    end
    if server.name == 'dockerls' then
      config.root_dir = dockerls_config.root_dir
      config.on_init = dockerls_config.on_init
    end
    if server.name == 'gopls' then
      config.filetypes = gopls_config.filetypes
      config.on_init = gopls_config.on_init
    end
    -- if server.name == "jsonls" then
    --   config.on_init = jsonls_config.on_init
    -- end
    if server.name == 'sumneko_lua' then
      luadev.capabilities = config.capabilities
      luadev.on_attach = config.on_attach
      config = luadev
    end
    if server.name == 'pyright' then
      config.on_init = pyright_config.on_init
    end
    -- if name == "solargraph" then config.settings = ruby_setup end
    -- if server.name == "rust_analyzer" then
    --   config.cmd = rust_analyzer_config.cmd
    -- end
    -- if server.name == "sourcekit" then
    --   config.root_dir = sourcekit_config.root_dir
    -- end
    -- if server.name == "terraformls" then
    --   config.cmd = terraformls_config.cmd
    --   end
    -- if server.name == "tsserver" then
    --   config.cmd = tsserver_config.cmd
    -- end
    -- if server.name == "yamlls" then
    --   config.on_init = yamlls_config.on_init
    -- end

    server:setup(config)
    server:on_ready(config.on_attach)
  end)
end

setup_servers()

-- vim.cmd([[ autocmd User LspAttachBuffers doautoall FileType ]])
