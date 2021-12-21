vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = {
      { "╭", "NormalFloat" },
      { "─", "NormalFloat" },
      { "╮", "NormalFloat" },
      { "│", "NormalFloat" },
      { "╯", "NormalFloat" },
      { "─", "NormalFloat" },
      { "╰", "NormalFloat" },
      { "│", "NormalFloat" },
    },
  }
)
