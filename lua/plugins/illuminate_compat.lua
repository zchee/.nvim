---@diagnostic disable-next-line: undefined-global
local api = vim.api

local M = {}

---@class IlluminateCompatFailure
---@field changedtick integer
---@field cursor integer[]

---@class IlluminateCompatOptions
---@field get_changedtick? fun(bufnr: integer): integer
---@field get_cursor_pos? fun(): integer[]
---@field get_line_count? fun(bufnr: integer): integer
---@field get_lines? fun(bufnr: integer, start: integer, finish: integer, strict: boolean): string[]

---@param left integer[]|nil
---@param right integer[]|nil
---@return boolean
function M.same_cursor(left, right)
  return left ~= nil and right ~= nil and left[1] == right[1] and left[2] == right[2]
end

---@param left integer[]
---@param right integer[]
---@return boolean
function M.is_position_before(left, right)
  if left[1] ~= right[1] then
    return left[1] < right[1]
  end

  return left[2] < right[2]
end

---@param err any
---@return boolean
function M.is_invalid_line_error(err)
  return type(err) == "string" and err:find("Invalid line number", 1, true) ~= nil
end

---@param err any
---@return boolean
function M.is_treesitter_locals_error(err)
  if type(err) ~= "string" then
    return false
  end

  local has_nil_method = err:find("attempt to call method '%w+' %(a nil value%)", 1, false) ~= nil
  local has_treesitter_path = err:find("treesitter", 1, false) ~= nil

  return has_nil_method and has_treesitter_path
end

---@param err any
---@return boolean
function M.is_transient_treesitter_error(err)
  return M.is_treesitter_locals_error(err) or M.is_invalid_line_error(err)
end

---@param bufnr integer
---@param opts? IlluminateCompatOptions
---@return integer
function M.get_line_count(bufnr, opts)
  local get_line_count = opts and opts.get_line_count or api.nvim_buf_line_count
  local ok, line_count = pcall(get_line_count, bufnr)
  if not ok then
    return 1
  end

  return math.max(line_count, 1)
end

---@param bufnr integer
---@param line integer
---@param opts? IlluminateCompatOptions
---@return integer
function M.get_line_length(bufnr, line, opts)
  local get_lines = opts and opts.get_lines or api.nvim_buf_get_lines
  local ok, lines = pcall(get_lines, bufnr, line, line + 1, false)
  if not ok or type(lines) ~= "table" then
    return 0
  end

  return #(lines[1] or "")
end

---@param bufnr integer
---@param position integer[]|nil
---@param opts? IlluminateCompatOptions
---@return integer[]
function M.normalize_position(bufnr, position, opts)
  local line_count = M.get_line_count(bufnr, opts)
  local line = math.max(0, math.min((position and position[1]) or 0, line_count - 1))
  local max_col = M.get_line_length(bufnr, line, opts)
  local col = math.max(0, math.min((position and position[2]) or 0, max_col))

  return { line, col }
end

---@param bufnr integer
---@param cursor integer[]|nil
---@param opts? IlluminateCompatOptions
---@return integer[]
function M.normalize_cursor(bufnr, cursor, opts)
  return M.normalize_position(bufnr, cursor, opts)
end

---@param bufnr integer
---@param reference table|nil
---@param opts? IlluminateCompatOptions
---@return table|nil
function M.normalize_reference(bufnr, reference, opts)
  if type(reference) ~= "table" or type(reference[1]) ~= "table" or type(reference[2]) ~= "table" then
    return nil
  end

  local start = M.normalize_position(bufnr, reference[1], opts)
  local finish = M.normalize_position(bufnr, reference[2], opts)
  if M.is_position_before(finish, start) then
    finish = { start[1], start[2] }
  end

  return { start, finish, reference[3] }
end

---@param bufnr integer
---@param references table|nil
---@param opts? IlluminateCompatOptions
---@return table|nil
function M.sanitize_references(bufnr, references, opts)
  if references == nil then
    return nil
  end

  local sanitized = {}
  for _, reference in ipairs(references) do
    local normalized = M.normalize_reference(bufnr, reference, opts)
    if normalized ~= nil then
      sanitized[#sanitized + 1] = normalized
    end
  end

  return sanitized
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

---@param reference_module table
---@param opts? IlluminateCompatOptions
function M.patch_reference_module(reference_module, opts)
  if reference_module._zchee_reference_module_patched then
    return
  end

  local original_buf_set_references = reference_module.buf_set_references
  reference_module.buf_set_references = function(bufnr, references)
    return original_buf_set_references(bufnr, M.sanitize_references(bufnr, references, opts))
  end

  reference_module._zchee_reference_module_patched = true
end

---@param provider table
---@param opts? IlluminateCompatOptions
function M.patch_treesitter_provider(provider, opts)
  if provider._zchee_treesitter_provider_patched then
    return
  end

  local failures = {}
  local get_changedtick = opts and opts.get_changedtick or api.nvim_buf_get_changedtick
  local get_cursor_pos = opts and opts.get_cursor_pos
    or function()
      local cursor = api.nvim_win_get_cursor(0)
      return { cursor[1] - 1, cursor[2] }
    end

  local original_is_ready = provider.is_ready
  provider.is_ready = function(bufnr)
    local cursor = M.normalize_cursor(bufnr, get_cursor_pos(), opts)
    if M.should_skip_treesitter_provider(failures, bufnr, get_changedtick(bufnr), cursor) then
      return false
    end

    return original_is_ready(bufnr)
  end

  local original_get_references = provider.get_references
  provider.get_references = function(bufnr, cursor, ...)
    cursor = M.normalize_cursor(bufnr, cursor or get_cursor_pos(), opts)
    local ok, refs = pcall(original_get_references, bufnr, cursor, ...)
    if ok then
      failures[bufnr] = nil
      return M.sanitize_references(bufnr, refs, opts)
    end

    if not M.is_transient_treesitter_error(refs) then
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

---@param provider table
---@param opts? IlluminateCompatOptions
function M.patch_regex_provider(provider, opts)
  if provider._zchee_regex_provider_patched then
    return
  end

  local get_cursor_pos = opts and opts.get_cursor_pos
    or function()
      local cursor = api.nvim_win_get_cursor(0)
      return { cursor[1] - 1, cursor[2] }
    end

  local original_is_ready = provider.is_ready
  provider.is_ready = function(bufnr)
    local ok, ready = pcall(original_is_ready, bufnr)
    if ok then
      return ready
    end

    if M.is_invalid_line_error(ready) then
      return false
    end

    error(ready, 0)
  end

  local original_get_references = provider.get_references
  provider.get_references = function(bufnr, cursor, ...)
    cursor = M.normalize_cursor(bufnr, cursor or get_cursor_pos(), opts)
    local ok, refs = pcall(original_get_references, bufnr, cursor, ...)
    if ok then
      return M.sanitize_references(bufnr, refs, opts)
    end

    if M.is_invalid_line_error(refs) then
      return nil
    end

    error(refs, 0)
  end

  provider._zchee_regex_provider_patched = true
end

return M
