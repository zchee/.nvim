local api = vim.api

local M = {}

local quickfile_defaults = {
  exclude = { "latex" },
}

---@param err any
---@return boolean
function M.is_treesitter_quickfile_range_error(err)
  if type(err) ~= "string" then
    return false
  end

  local has_range_error = err:find("attempt to call method 'range' %(a nil value%)", 1, false) ~= nil
  local has_decoration_provider = err:find('Decoration provider "start"', 1, true) ~= nil
  local has_highlighter_namespace = err:find("nvim%.treesitter%.highlighter", 1, false) ~= nil
  local has_treesitter_path = err:find("vim/treesitter%.lua:", 1, false) ~= nil
  local has_languagetree_path = err:find("vim/treesitter/languagetree%.lua:", 1, false) ~= nil

  return has_range_error
    and (has_decoration_provider or has_highlighter_namespace or (has_treesitter_path and has_languagetree_path))
end

---@class SnacksQuickfileCompatOps
---@field start_treesitter? fun(buf: integer, lang: string)
---@field stop_treesitter? fun(buf: integer)
---@field redraw? fun()
---@field set_syntax? fun(buf: integer, syntax: string)

---@param buf integer
---@param ft string
---@param lang string|nil
---@param ops? SnacksQuickfileCompatOps
---@return boolean
function M.render_quickfile(buf, ft, lang, ops)
  ops = ops or {}

  local start_treesitter = ops.start_treesitter or vim.treesitter.start
  local stop_treesitter = ops.stop_treesitter or vim.treesitter.stop
  local redraw = ops.redraw or function()
    vim.cmd.redraw()
  end
  local set_syntax = ops.set_syntax or function(target_buf, syntax)
    vim.bo[target_buf].syntax = syntax
  end

  ---@param redraw_now boolean?
  local function syntax_fallback(redraw_now)
    set_syntax(buf, ft)
    if redraw_now ~= false then
      redraw()
    end
    return false
  end

  if not lang then
    return syntax_fallback(true)
  end

  if not pcall(start_treesitter, buf, lang) then
    return syntax_fallback(true)
  end

  local ok, err = xpcall(redraw, debug.traceback)
  if ok then
    return true
  end

  pcall(stop_treesitter, buf)

  if not M.is_treesitter_quickfile_range_error(err) then
    error(err, 0)
  end

  return syntax_fallback(false)
end

---@class SnacksQuickfilePatchDeps
---@field config_get? fun(name: string, defaults: table): table
---@field did_vim_enter? fun(): boolean
---@field get_current_filetype? fun(): string
---@field get_current_buf? fun(): integer
---@field match_filetype? fun(args: table): string|nil
---@field get_lang? fun(ft: string): string|nil
---@field contains? fun(list: table, value: any): boolean
---@field render_quickfile? fun(buf: integer, ft: string, lang: string|nil)

---@param quickfile table
---@param deps? SnacksQuickfilePatchDeps
function M.patch_quickfile_module(quickfile, deps)
  if quickfile._zchee_quickfile_patched then
    return
  end

  deps = deps or {}

  local config_get = deps.config_get or Snacks.config.get
  local did_vim_enter = deps.did_vim_enter or function()
    return vim.v.vim_did_enter == 1
  end
  local get_current_filetype = deps.get_current_filetype or function()
    return vim.bo.filetype
  end
  local get_current_buf = deps.get_current_buf or api.nvim_get_current_buf
  local match_filetype = deps.match_filetype or vim.filetype.match
  local get_lang = deps.get_lang or vim.treesitter.language.get_lang
  local contains = deps.contains or vim.tbl_contains
  local render_quickfile = deps.render_quickfile or M.render_quickfile

  quickfile.setup = function()
    local opts = config_get("quickfile", quickfile_defaults)

    if did_vim_enter() then
      return
    end

    if get_current_filetype() == "bigfile" then
      return
    end

    local buf = get_current_buf()
    local ft = match_filetype({ buf = buf })
    if not ft then
      return
    end

    local lang = get_lang(ft)
    local exclude = opts.exclude or quickfile_defaults.exclude
    if contains(exclude, lang) then
      return
    end

    render_quickfile(buf, ft, lang)
  end

  quickfile._zchee_quickfile_patched = true
end

return M
