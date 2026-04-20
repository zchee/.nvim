local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("zizmor", "zizmor"), "--lsp" },
  filetypes = { "yaml" },

  root_dir = function(bufnr, on_dir)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local parent = vim.fs.dirname(bufname)
    if
        vim.endswith(parent, '/.github/workflows')
        or vim.endswith(parent, '/.forgejo/workflows')
        or vim.endswith(parent, '/.gitea/workflows')
        or (vim.endswith(bufname, '/.github/dependabot.yml') or vim.endswith(bufname, '/.github/dependabot.yaml'))
        or vim.endswith(bufname, 'action.yml') -- Composite actions can live in any repository subdirectory
    then
      on_dir(parent)
    end
  end,

  init_options = {}, -- needs to be present https://github.com/neovim/nvim-lspconfig/pull/3713#issuecomment-2857394868

  capabilities = {
    workspace = {
      didChangeWorkspaceFolders = {
        dynamicRegistration = true,
      },
    },
  },
}
