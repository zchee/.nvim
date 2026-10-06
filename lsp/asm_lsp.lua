local util = require("util")

-- asm-lsp refuses to start ("Unable to detect project root directory") when
-- its config has a [[project]] table and the client sends no root, which is
-- what a nil root_dir does. GOROOT and the module cache carry no .git, so
-- go.mod roots their assembly, and a file with no marker at all is rooted at
-- its own directory.
local root_markers = { ".asm-lsp.toml", ".git", "go.mod" }

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("asm-lsp", "asm-lsp") },
  filetypes = {
    "asm",
    "vmasm",
    "goasm",
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
      return
    end
    on_dir(vim.fs.root(fname, root_markers) or vim.fs.dirname(fname))
  end,
}
