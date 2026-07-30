-- Returned as `opts` for saecki/crates.nvim in lua/plugins/init.lua.

return {
  completion = {
    crates = { enabled = true, max_results = 8, min_chars = 3 },
  },
  lsp = {
    enabled = true,
    on_attach = function(_, bufnr)
      local crates = require("crates")
      local opts = { silent = true, buffer = bufnr }
      local map = vim.keymap.set
      map("n", "<leader>rct", crates.toggle, vim.tbl_extend("force", opts, { desc = "Toggle crates" }))
      map("n", "<leader>rcr", crates.reload, vim.tbl_extend("force", opts, { desc = "Reload crates" }))
      map(
        "n",
        "<leader>rcv",
        crates.show_versions_popup,
        vim.tbl_extend("force", opts, { desc = "Show versions" })
      )
      map(
        "n",
        "<leader>rcf",
        crates.show_features_popup,
        vim.tbl_extend("force", opts, { desc = "Show features" })
      )
      map(
        "n",
        "<leader>rcd",
        crates.show_dependencies_popup,
        vim.tbl_extend("force", opts, { desc = "Show dependencies" })
      )
      map("n", "<leader>rcu", crates.update_crate, vim.tbl_extend("force", opts, { desc = "Update crate" }))
      map("v", "<leader>rcu", crates.update_crates, vim.tbl_extend("force", opts, { desc = "Update crates" }))
      map("n", "<leader>rcU", crates.upgrade_crate, vim.tbl_extend("force", opts, { desc = "Upgrade crate" }))
      map("v", "<leader>rcU", crates.upgrade_crates, vim.tbl_extend("force", opts, { desc = "Upgrade crates" }))
      map(
        "n",
        "<leader>rcA",
        crates.upgrade_all_crates,
        vim.tbl_extend("force", opts, { desc = "Upgrade all crates" })
      )
      map("n", "<leader>rcH", crates.open_homepage, vim.tbl_extend("force", opts, { desc = "Open homepage" }))
      map("n", "<leader>rcR", crates.open_repository, vim.tbl_extend("force", opts, { desc = "Open repository" }))
      map("n", "<leader>rcD", crates.open_documentation, vim.tbl_extend("force", opts, { desc = "Open docs.rs" }))
      map("n", "<leader>rcC", crates.open_crates_io, vim.tbl_extend("force", opts, { desc = "Open crates.io" }))
    end,
    actions = true,
    completion = true,
    hover = true,
  },
  popup = { border = "rounded", show_version_date = true, max_height = 30, min_width = 20 },
}
