local M = {}

---@class NeoTreeCompatDeps
---@field api? table
---@field log? table
---@field manager? table
---@field inspect? fun(value: any): string
---@field filetype? fun(): string
---@field get_current_line? fun(): string
---@field find? fun(haystack: string, needle: string, init?: integer, plain?: boolean): integer|nil, integer|nil

---@param err any
---@return boolean
function M.is_invalid_win_error(err)
  return type(err) == "string" and err:find("Invalid 'win': Expected Lua number", 1, true) ~= nil
end

---@param state table|nil
---@return table|nil
function M.get_node_safely(state)
  if type(state) ~= "table" or state.tree == nil then
    return nil
  end

  local ok, node = pcall(function()
    return state.tree:get_node()
  end)
  if ok then
    return node
  end

  if M.is_invalid_win_error(node) then
    return nil
  end

  error(node, 0)
end

---@param deps? NeoTreeCompatDeps
function M.hijack_cursor_handler(deps)
  deps = deps or {}

  local api = deps.api or vim.api
  local log = deps.log or require("neo-tree.log")
  local manager = deps.manager or require("neo-tree.sources.manager")
  local inspect = deps.inspect or vim.inspect
  local filetype = deps.filetype or function() return vim.o.filetype end
  local get_current_line = deps.get_current_line or api.nvim_get_current_line
  local find = deps.find or string.find

  if filetype() ~= "neo-tree" then
    return
  end

  local ok, source = pcall(api.nvim_buf_get_var, 0, "neo_tree_source")
  if not ok then
    log.debug("Cursor hijack failure: " .. inspect(source))
    return
  end

  local winid
  local _, position = pcall(api.nvim_buf_get_var, 0, "neo_tree_position")
  if position == "current" then
    winid = api.nvim_get_current_win()
  end

  local state = manager.get_state(source, nil, winid)
  local node = M.get_node_safely(state)
  if not node then
    return
  end

  log.debug("Cursor moved in tree window, hijacking cursor position")

  local cursor = api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local current_line = get_current_line()
  local start_index = find(current_line, node.name, nil, true)
  if start_index then
    api.nvim_win_set_cursor(0, { row, start_index - 1 })
  end
end

---@param opts? { events?: table, hijack_cursor?: table, deps?: NeoTreeCompatDeps }
function M.patch_hijack_cursor_module(opts)
  opts = opts or {}

  local hijack_cursor = opts.hijack_cursor or require("neo-tree.sources.common.hijack_cursor")
  if hijack_cursor._zchee_hijack_cursor_patched then
    return
  end

  local events = opts.events or require("neo-tree.events")
  local deps = opts.deps

  hijack_cursor.setup = function()
    events.subscribe({
      event = events.VIM_CURSOR_MOVED,
      handler = function()
        M.hijack_cursor_handler(deps)
      end,
      id = "neo-tree-hijack-cursor",
    })
  end

  hijack_cursor._zchee_hijack_cursor_patched = true
end

return M
