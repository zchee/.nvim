-- Minimal incremental selection on top of vim.treesitter, replacing the
-- master-branch nvim-treesitter incremental_selection module (removed in the
-- main-branch rewrite).
local M = {}

---@type table<integer, TSNode[]>
local stacks = {}

---@return TSNode?
local function get_node_at_cursor()
  local ok, parser = pcall(vim.treesitter.get_parser, vim.api.nvim_get_current_buf())
  if not ok or not parser then
    return nil
  end
  -- force a parse: the tree may not exist yet before the first redraw
  parser:parse()
  return vim.treesitter.get_node()
end

---@param node TSNode
local function select_node(node)
  -- the '< '> marks are owned by an active visual selection; leave visual
  -- mode first or the writes below are clobbered
  if vim.api.nvim_get_mode().mode:find("^[vV\022]") then
    vim.cmd("normal! \027")
  end
  local srow, scol, erow, ecol = node:range()
  -- tree-sitter ranges are end-exclusive; visual marks are inclusive
  if ecol == 0 then
    erow = erow - 1
    ecol = #(vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or "")
  end
  vim.api.nvim_buf_set_mark(0, "<", srow + 1, scol, {})
  vim.api.nvim_buf_set_mark(0, ">", erow + 1, math.max(ecol - 1, 0), {})
  vim.cmd("normal! gv")
end

---@return TSNode[]?
local function ensure_stack()
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = stacks[bufnr]
  if stack == nil or #stack == 0 then
    local node = get_node_at_cursor()
    if not node then
      return nil
    end
    stack = { node }
    stacks[bufnr] = stack
  end
  return stack
end

function M.init_selection()
  local node = get_node_at_cursor()
  if not node then
    return
  end
  stacks[vim.api.nvim_get_current_buf()] = { node }
  select_node(node)
end

---@param pred? fun(node: TSNode): boolean
local function expand(pred)
  local stack = ensure_stack()
  if not stack then
    return
  end
  local node = stack[#stack]
  local parent = node:parent()
  while parent do
    local nsr, nsc, ner, nec = node:range()
    local psr, psc, per, pec = parent:range()
    local same = nsr == psr and nsc == psc and ner == per and nec == pec
    if not same and (pred == nil or pred(parent)) then
      table.insert(stack, parent)
      select_node(parent)
      return
    end
    parent = parent:parent()
  end
  select_node(node)
end

function M.node_incremental()
  expand(nil)
end

-- Substring patterns matched against node:type() to approximate the locals
-- @scope captures the master module used for scope_incremental.
local scope_types = {
  "function",
  "method",
  "class",
  "block",
  "body",
  "chunk",
  "source_file",
  "program",
}

function M.scope_incremental()
  expand(function(node)
    local t = node:type()
    for _, pat in ipairs(scope_types) do
      if t:find(pat, 1, true) then
        return true
      end
    end
    return false
  end)
end

function M.node_decremental()
  local stack = stacks[vim.api.nvim_get_current_buf()]
  if not stack or #stack <= 1 then
    return
  end
  table.remove(stack)
  select_node(stack[#stack])
end

---@param keymaps { init_selection: string, node_incremental: string, node_decremental: string, scope_incremental: string }
function M.setup(keymaps)
  vim.keymap.set("n", keymaps.init_selection, M.init_selection, { silent = true, desc = "TS: init selection" })
  vim.keymap.set("x", keymaps.node_incremental, M.node_incremental, { silent = true, desc = "TS: expand to node" })
  vim.keymap.set("x", keymaps.node_decremental, M.node_decremental, { silent = true, desc = "TS: shrink selection" })
  vim.keymap.set("x", keymaps.scope_incremental, M.scope_incremental, { silent = true, desc = "TS: expand to scope" })
end

return M
