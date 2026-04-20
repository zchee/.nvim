local parser_compat = require("plugins.ts_context_commentstring_compat")

local M = {}

---@class CommentCompatDeps
---@field get_parser? fun(bufnr: integer): vim.treesitter.LanguageTree|nil

---@param ft table
---@param deps? CommentCompatDeps
function M.patch_ft(ft, deps)
  if ft._zchee_nil_parser_guard_patched then
    return
  end

  local contains = ft.contains
  local get = ft.get

  ---@param ctx CommentCtx
  ---@return string|nil
  ft.calculate = function(ctx)
    local parser = parser_compat.resolve_parser(vim.api.nvim_get_current_buf(), deps)
    if parser == nil then
      return get(vim.bo.filetype, ctx.ctype)
    end

    local lang = contains(parser, {
      ctx.range.srow - 1,
      ctx.range.scol,
      ctx.range.erow - 1,
      ctx.range.ecol,
    }):lang()

    return get(lang, ctx.ctype) or get(vim.bo.filetype, ctx.ctype)
  end

  ft._zchee_nil_parser_guard_patched = true
end

return M
