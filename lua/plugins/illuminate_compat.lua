---@diagnostic disable-next-line: undefined-global
local api = vim.api

local M = {}

---@class IlluminateCompatFailure
---@field changedtick integer
---@field cursor integer[]

---@class IlluminateCompatOptions
---@field get_changedtick? fun(bufnr: integer): integer
---@field get_cursor_pos? fun(): integer[]

---@param left integer[]|nil
---@param right integer[]|nil
---@return boolean
function M.same_cursor(left, right)
  return left ~= nil and right ~= nil and left[1] == right[1] and left[2] == right[2]
end

---@param err any
---@return boolean
function M.is_treesitter_locals_parent_error(err)
  if type(err) ~= "string" then
    return false
  end

  local has_parent_error = err:find("attempt to call method 'parent' %(a nil value%)", 1, false) ~= nil
  local has_locals_path = err:find("locals%.lua:", 1, false) ~= nil
  local has_treesitter_path = err:find("nvim%-treesitter", 1, false) ~= nil

  return has_parent_error and has_locals_path and has_treesitter_path
end

---@param failures table<integer, IlluminateCompatFailure>
---@param bufnr integer
---@param changedtick integer
---@param cursor integer[]
---@return boolean
function M.should_skip_treesitter_provider(failures, bufnr, changedtick, cursor)
  local failure = failures[bufnr]
  if failure == nil then
    return false
  end

  if failure.changedtick == changedtick and M.same_cursor(failure.cursor, cursor) then
    return true
  end

  failures[bufnr] = nil
  return false
end

---@param provider table
---@param opts? IlluminateCompatOptions
function M.patch_treesitter_provider(provider, opts)
  if provider._zchee_treesitter_provider_patched then
    return
  end

  local failures = {}
  local get_changedtick = opts and opts.get_changedtick or api.nvim_buf_get_changedtick
  local get_cursor_pos = opts and opts.get_cursor_pos or function()
    local cursor = api.nvim_win_get_cursor(0)
    return { cursor[1] - 1, cursor[2] }
  end

  local original_is_ready = provider.is_ready
  provider.is_ready = function(bufnr)
    if M.should_skip_treesitter_provider(failures, bufnr, get_changedtick(bufnr), get_cursor_pos()) then
      return false
    end

    return original_is_ready(bufnr)
  end

  local original_get_references = provider.get_references
  provider.get_references = function(bufnr, cursor, ...)
    cursor = cursor or get_cursor_pos()
    local ok, refs = pcall(original_get_references, bufnr, cursor, ...)
    if ok then
      failures[bufnr] = nil
      return refs
    end

    if not M.is_treesitter_locals_parent_error(refs) then
      error(refs, 0)
    end

    failures[bufnr] = {
      changedtick = get_changedtick(bufnr),
      cursor = { cursor[1], cursor[2] },
    }
    return nil
  end

  provider._zchee_treesitter_provider_patched = true
end

return M
