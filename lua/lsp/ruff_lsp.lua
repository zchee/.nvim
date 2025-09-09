--- @class lspconfig.Config : vim.lsp.ClientConfig
return {
  on_attach = function(client, _)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    autostart = false,
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    },
  },
}
