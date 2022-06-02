local handlers = require("zchee.plugins.lsp.handler")
local opts = {
  on_attach = handlers.on_attach,
  capabilities = handlers.capabilities,
}

local function setup_servers()
  local lsp_installer = require("nvim-lsp-installer")
  lsp_installer.on_server_ready(function(server)
    require("zchee.plugins.lsp.servers.gopls").setup(server, opts)
    require("zchee.plugins.lsp.servers.sumneko_lua").setup(server, opts)

    server:on_ready(handlers.on_attach)
  end)
end

setup_servers()
