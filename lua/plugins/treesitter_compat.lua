---@diagnostic disable: undefined-global
local M = {}

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  ts = "typescript",
  uxn = "uxntal",
}

local list_unpack = table.unpack or unpack

local function default_add_opts()
  if vim.fn.has("nvim-0.10") == 1 then
    return { force = true, all = false }
  end

  return true
end

local function default_notify_error(message)
  vim.api.nvim_err_writeln(message)
end

local function default_find_definition(node, bufnr)
  return require("nvim-treesitter.locals").find_definition(node, bufnr)
end

local function valid_args(name, pred, count, strict_count, notify_error)
  local arg_count = #pred - 1

  if strict_count then
    if arg_count ~= count then
      notify_error(string.format("%s must have exactly %d arguments", name, count))
      return false
    end
  elseif arg_count < count then
    notify_error(string.format("%s must have at least %d arguments", name, count))
    return false
  end

  return true
end

---@param match table<integer, any>
---@param capture_id integer
---@return any
function M.capture_node(match, capture_id)
  local capture = match[capture_id]
  if capture == nil then
    return nil
  end

  if vim.islist(capture) then
    return capture[1]
  end

  return capture
end

---@param injection_alias string
---@param match_filetype? fun(args: { filename: string }): string|nil
---@return string
function M.get_parser_from_markdown_info_string(injection_alias, match_filetype)
  match_filetype = match_filetype or vim.filetype.match

  local match = match_filetype({ filename = "a." .. injection_alias })
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

---@param query_mod? table
---@param deps? table
function M.patch_query_predicates(query_mod, deps)
  query_mod = query_mod or vim.treesitter.query
  if query_mod._zchee_query_predicates_patched then
    return
  end

  deps = deps or {}

  local add_opts = deps.add_opts or default_add_opts()
  local notify_error = deps.notify_error or default_notify_error
  local get_node_text = deps.get_node_text or vim.treesitter.get_node_text
  local match_filetype = deps.match_filetype or vim.filetype.match
  local tbl_contains = deps.tbl_contains or vim.tbl_contains
  local find_definition = deps.find_definition or default_find_definition

  query_mod.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
    if not valid_args("nth?", pred, 2, true, notify_error) then
      return
    end

    local node = M.capture_node(match, pred[2])
    local n = tonumber(pred[3])
    if node and n and node:parent() and node:parent():named_child_count() > n then
      return node:parent():named_child(n) == node
    end

    return false
  end, add_opts)

  query_mod.add_predicate("is?", function(match, _pattern, bufnr, pred)
    if not valid_args("is?", pred, 2, false, notify_error) then
      return
    end

    local node = M.capture_node(match, pred[2])
    if not node then
      return true
    end

    local types = { list_unpack(pred, 3) }
    local _, _, kind = find_definition(node, bufnr)
    return tbl_contains(types, kind)
  end, add_opts)

  query_mod.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
    if not valid_args(pred[1], pred, 2, false, notify_error) then
      return
    end

    local node = M.capture_node(match, pred[2])
    if not node then
      return true
    end

    local types = { list_unpack(pred, 3) }
    return tbl_contains(types, node:type())
  end, add_opts)

  query_mod.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = M.capture_node(match, pred[2])
    if not node then
      return
    end

    local type_attr_value = get_node_text(node, bufnr)
    if type(type_attr_value) ~= "string" or type_attr_value == "" then
      return
    end

    local configured = html_script_type_languages[type_attr_value]
    if configured then
      metadata["injection.language"] = configured
      return
    end

    local parts = vim.split(type_attr_value, "/", {})
    metadata["injection.language"] = parts[#parts]
  end, add_opts)

  query_mod.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = M.capture_node(match, pred[2])
    if not node then
      return
    end

    local type_attr_value = get_node_text(node, bufnr)
    if type(type_attr_value) ~= "string" or type_attr_value == "" then
      return
    end

    local injection_alias = type_attr_value:lower()
    metadata["injection.language"] = M.get_parser_from_markdown_info_string(injection_alias, match_filetype)
  end, add_opts)

  query_mod.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = M.capture_node(match, id)
    if not node then
      return
    end

    local text = get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    metadata[id] = metadata[id] or {}
    metadata[id].text = string.lower(text)
  end, add_opts)

  query_mod._zchee_query_predicates_patched = true
end

return M
