local util = require("util")

local function add_ruby_deps_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
      local params = vim.lsp.util.make_text_document_params()
      local showAll = opts.args == "all"

      client.request("rubyLsp/workspace/dependencies", params, function(error, result)
        if error then
          print("Error showing deps: " .. error)
          return
        end

        local qf_list = {}
        for _, item in ipairs(result) do
          if showAll or item.dependency then
            table.insert(qf_list, {
              text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
              filename = item.path
            })
          end
        end

        vim.fn.setqflist(qf_list)
        vim.cmd('copen')
      end, bufnr)
    end,
    { nargs = "?", complete = function() return { "all" } end })
end

--- @class vim.lsp.Config : vim.lsp.ClientConfig
return {
  cmd = {
    util.homebrew_portable_ruby("ruby-lsp"), "--use-launcher",
  },
  filetypes = { "ruby", "eruby" },
  -- root_dir = lspconfig_util.root_pattern("Gemfile", ".git"),
  root_markers = { "Gemfile", ".git" },
  init_options = {
    enabledFeatures = {
      codeActions = true,
      codeLens = true,
      completion = true,
      definition = true,
      diagnostics = true,
      documentHighlights = true,
      documentLink = true,
      documentSymbols = true,
      foldingRanges = true,
      formatting = true,
      hover = true,
      inlayHint = true,
      onTypeFormatting = true,
      selectionRanges = true,
      semanticHighlighting = true,
      signatureHelp = true,
      typeHierarchy = true,
      workspaceSymbol = true
    },
    featuresConfiguration = {
      inlayHint = {
        enableAll = true,
      },
    },
    indexing = {
      -- excludedPatterns = {"path/to/excluded/file.rb"},
      includedPatterns = { util.homebrew_prefix() .. "Homebrew/Library/Homebrew/**" },
      -- excludedGems = {"gem1", "gem2", "etc."},
      -- excludedMagicComments = {"compiled:true"},
    },
    formatter = 'auto',
    experimentalFeaturesEnabled = true,
    bundleGemfile = vim.fs.joinpath(util.homebrew_prefix(), "Homebrew/Library/Homebrew/Gemfile"),
    rubyExecutablePath = vim.fs.joinpath(util.homebrew_prefix(),
      "Homebrew/Library/Homebrew/vendor/portable-ruby/current/bin/ruby"),
  },
  on_attach = function(client, buffer)
    add_ruby_deps_command(client, buffer)
  end,
}
