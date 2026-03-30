local M = {}

---@class TsContextCommentstringCompatDeps
---@field get_parser? fun(bufnr: integer): vim.treesitter.LanguageTree|nil

---@param bufnr integer
---@param deps? TsContextCommentstringCompatDeps
---@return vim.treesitter.LanguageTree|nil
function M.resolve_parser(bufnr, deps)
  local get_parser = deps and deps.get_parser or vim.treesitter.get_parser
  local ok, parser = pcall(get_parser, bufnr)
  if not ok then
    return nil
  end

  return parser
end

---@param utils table
---@param deps? TsContextCommentstringCompatDeps
function M.patch_utils(utils, deps)
  if utils._zchee_nil_parser_guard_patched then
    return
  end

  utils.is_treesitter_active = function(bufnr)
    return M.resolve_parser(bufnr or 0, deps) ~= nil
  end

  utils._zchee_nil_parser_guard_patched = true
end

return M
