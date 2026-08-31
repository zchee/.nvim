-- Static snapshot of require("blink.cmp").get_lsp_capabilities({}, false).
--
-- lua/lsp/init.lua merges this into every server's capabilities. Requiring
-- blink.cmp directly here would load blink (and its LuaSnip/blink-copilot/
-- copilot.lua dependency tree) the moment the LSP stack initializes, defeating
-- blink's InsertEnter trigger; the snapshot keeps the merge free.
--
-- Drift guard: tests/lsp_capabilities_snapshot_spec.lua asserts this table is
-- deep-equal to blink's live output, so a blink.cmp update that changes its
-- advertised capabilities fails the spec instead of silently downgrading
-- completion. Regenerate after `:Lazy update blink.cmp` with:
--
--   nvim --headless -u NONE -l - <<'GEN'
--   local lazy = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
--   vim.opt.runtimepath:append(vim.fs.joinpath(lazy, "blink.cmp"))
--   vim.opt.runtimepath:append(vim.fs.joinpath(lazy, "blink.lib"))
--   print("return " .. vim.inspect(require("blink.cmp").get_lsp_capabilities({}, false)))
--   GEN
--
---@type lsp.ClientCapabilities
return {
  textDocument = {
    completion = {
      completionItem = {
        commitCharactersSupport = false,
        deprecatedSupport = true,
        documentationFormat = { "markdown", "plaintext" },
        insertReplaceSupport = true,
        insertTextModeSupport = {
          valueSet = { 1 },
        },
        labelDetailsSupport = true,
        preselectSupport = false,
        resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits", "command", "data" },
        },
        snippetSupport = true,
        tagSupport = {
          valueSet = { 1 },
        },
      },
      completionList = {
        itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" },
      },
      contextSupport = true,
      insertTextMode = 1,
    },
  },
}
