local util = require("util")

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = { util.homebrew_binary("terraform-ls-head", "terraform-ls"), "serve", "-req-concurrency=16" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform.lock.hcl", ".terraform", ".git" },
  capabilities = {
    experimental = {
      showReferencesCommandId = "client.showReferences",
    },
  },
  -- The capability above turns on terraform-ls's reference-count code lens,
  -- whose command is a client-side one: the server hands back
  -- { position, referenceContext } and expects the client to ask
  -- textDocument/references with them (docs/language-clients.md). Kept on
  -- this client, which Client:exec_cmd consults before vim.lsp.commands.
  commands = {
    ["client.showReferences"] = function(command, ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
      local arguments = command.arguments or {}
      client:request("textDocument/references", {
        textDocument = { uri = vim.uri_from_bufnr(ctx.bufnr) },
        position = arguments[1],
        context = arguments[2] or { includeDeclaration = false },
      }, function(err, result)
        if err ~= nil or type(result) ~= "table" or vim.tbl_isempty(result) then
          vim.notify("terraform-ls: no references", vim.log.levels.INFO)
          return
        end
        vim.fn.setqflist({}, " ", {
          title = command.title,
          items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
        })
        vim.cmd("botright copen")
      end, ctx.bufnr)
    end,
  },
  -- The code lenses are switched on per buffer in lua/lsp/on_attach.lua.
  -- root_dir = require("lspconfig").util.root_pattern(
  --   ".terraform",
  --   ".terraform.lock.hcl",
  --   "providers.tf",
  --   "version.tf",
  --   ".git"
  -- ),
  -- terraform-ls takes its options as initializationOptions, unwrapped
  -- (docs/SETTINGS.md "How to pass settings"); it never requests
  -- workspace/configuration, so a `settings` table would reach nothing.
  init_options = {
    indexing = {
      ignoreDirectoryNames = {
        ".git",
        ".idea",
        ".vscode",
        "terraform.tfstate.d",
      },
      ignorePaths = {
        ".terragrunt-cache",
      },
    },
    experimentalFeatures = {
      validateOnSave = true,
      prefillRequiredFields = true,
    },
    validation = {
      enableEnhancedValidation = true,
    },
  },
}
