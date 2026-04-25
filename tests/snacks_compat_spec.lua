---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local compat = require("plugins.snacks_compat")

local function assert_equal(expected, actual, message)
  if expected ~= actual then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

local function assert_truthy(value, message)
  if not value then
    error(message)
  end
end

local function assert_falsy(value, message)
  if value then
    error(message)
  end
end

local function assert_deep_equal(expected, actual, message)
  if vim.inspect(expected) ~= vim.inspect(actual) then
    error(string.format("%s: expected %s, got %s", message, vim.inspect(expected), vim.inspect(actual)))
  end
end

do
  assert_truthy(
    compat.is_treesitter_quickfile_range_error(
      ".../vim/treesitter/languagetree.lua:215: .../vim/treesitter.lua:196: attempt to call method 'range' (a nil value)"
    ),
    "matcher should detect the quickfile redraw Treesitter range failure"
  )

  assert_falsy(compat.is_treesitter_quickfile_range_error("plain error"), "matcher should ignore unrelated errors")

  assert_truthy(
    compat.is_treesitter_quickfile_range_error(table.concat({
      "Error in command line:",
      'Decoration provider "start" (ns=nvim.treesitter.highlighter):',
      "Lua: .../vim/treesitter/languagetree.lua:215: .../vim/treesitter.lua:196: attempt to call method 'range' (a nil value)",
    }, "\n")),
    "matcher should detect the startup decoration-provider variant of the same failure"
  )
end

do
  local started
  local redraw_calls = 0
  local syntax

  assert_truthy(
    compat.render_quickfile(3, "go", "go", {
      start_treesitter = function(buf, lang)
        started = { buf, lang }
      end,
      redraw = function()
        redraw_calls = redraw_calls + 1
      end,
      set_syntax = function(buf, ft)
        syntax = { buf, ft }
      end,
    }),
    "render should keep treesitter when redraw succeeds"
  )

  assert_deep_equal({ 3, "go" }, started, "render should start treesitter with the current buffer and language")
  assert_equal(1, redraw_calls, "render should redraw once on the fast path")
  assert_equal(nil, syntax, "render should not fall back to syntax on success")
end

do
  local redraw_calls = 0
  local syntax

  assert_falsy(
    compat.render_quickfile(5, "lua", "lua", {
      start_treesitter = function()
        error("parser missing")
      end,
      redraw = function()
        redraw_calls = redraw_calls + 1
      end,
      set_syntax = function(buf, ft)
        syntax = { buf, ft }
      end,
    }),
    "render should fall back to syntax when treesitter start fails"
  )

  assert_equal(1, redraw_calls, "syntax fallback should still redraw once")
  assert_deep_equal({ 5, "lua" }, syntax, "syntax fallback should target the current buffer and filetype")
end

do
  local redraw_calls = 0
  local syntax
  local stopped

  assert_falsy(
    compat.render_quickfile(7, "json", "json", {
      start_treesitter = function() end,
      stop_treesitter = function(buf)
        stopped = buf
      end,
      redraw = function()
        redraw_calls = redraw_calls + 1
        if redraw_calls == 1 then
          error(
            ".../vim/treesitter/languagetree.lua:215: .../vim/treesitter.lua:196: attempt to call method 'range' (a nil value)"
          )
        end
      end,
      set_syntax = function(buf, ft)
        syntax = { buf, ft }
      end,
    }),
    "render should fall back to syntax for the known quickfile redraw failure"
  )

  assert_equal(1, redraw_calls, "known redraw failure should not redraw again in the same failing call stack")
  assert_equal(7, stopped, "known redraw failure should stop treesitter for the buffer")
  assert_deep_equal({ 7, "json" }, syntax, "known redraw failure should switch back to syntax highlighting")
end

do
  local stopped
  local ok, err = pcall(compat.render_quickfile, 11, "python", "python", {
    start_treesitter = function() end,
    stop_treesitter = function(buf)
      stopped = buf
    end,
    redraw = function()
      error("unexpected redraw failure")
    end,
  })

  assert_falsy(ok, "unknown redraw failures must still propagate")
  assert_equal(11, stopped, "unknown redraw failures should still stop treesitter before propagating")
  assert_truthy(
    type(err) == "string" and err:find("unexpected redraw failure", 1, true) ~= nil,
    "error should be preserved"
  )
end

do
  local rendered
  local quickfile = {}

  compat.patch_quickfile_module(quickfile, {
    config_get = function(_name, defaults)
      return defaults
    end,
    did_vim_enter = function()
      return false
    end,
    get_current_filetype = function()
      return ""
    end,
    get_current_buf = function()
      return 17
    end,
    match_filetype = function(args)
      assert_equal(17, args.buf, "setup should query the current buffer")
      return "go"
    end,
    get_lang = function(ft)
      return ft
    end,
    contains = function(_list, _value)
      return false
    end,
    render_quickfile = function(buf, ft, lang)
      rendered = { buf, ft, lang }
    end,
  })

  quickfile.setup()

  assert_truthy(quickfile._zchee_quickfile_patched, "patch should mark the module as patched")
  assert_deep_equal({ 17, "go", "go" }, rendered, "patched setup should forward the inferred quickfile context")
end

do
  local rendered = false
  local quickfile = {}

  compat.patch_quickfile_module(quickfile, {
    config_get = function()
      return { exclude = { "json" } }
    end,
    did_vim_enter = function()
      return false
    end,
    get_current_filetype = function()
      return ""
    end,
    get_current_buf = function()
      return 19
    end,
    match_filetype = function()
      return "json"
    end,
    get_lang = function(ft)
      return ft
    end,
    contains = function(list, value)
      return list[1] == value
    end,
    render_quickfile = function(_buf, _ft, lang)
      rendered = lang or true
    end,
  })

  quickfile.setup()

  assert_falsy(rendered, "excluded treesitter languages should skip quickfile entirely")
end

do
  local rendered = false
  local quickfile = {}

  compat.patch_quickfile_module(quickfile, {
    config_get = function(_name, defaults)
      return defaults
    end,
    did_vim_enter = function()
      return false
    end,
    get_current_filetype = function()
      return "bigfile"
    end,
    render_quickfile = function()
      rendered = true
    end,
  })

  quickfile.setup()

  assert_falsy(rendered, "patched setup should skip bigfile buffers")
end
