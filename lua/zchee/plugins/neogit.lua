local neogit = require("neogit")
neogit.setup({
  disable_commit_confirmation = true,
  disable_signs = false,
  signs = {
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = true,
  },
  -- mappings = {
  --   status = {
  --     ["c"] = "CommitPopup -s",
  --   }
  -- }
})
