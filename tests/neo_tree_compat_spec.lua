---@diagnostic disable: undefined-global
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local compat = require("plugins.neo_tree_compat")

local function assert_eq(actual, expected, message)
  assert(actual == expected, string.format("%s\nexpected: %s\nactual: %s", message, vim.inspect(expected), vim.inspect(actual)))
end

do
  assert(compat.is_invalid_win_error("Invalid 'win': Expected Lua number"), "should match the known invalid window error")
  assert(not compat.is_invalid_win_error("some other error"), "should reject unrelated errors")
end

do
  local node = { name = "alpha" }
  local actual = compat.get_node_safely({
    tree = {
      get_node = function()
        return node
      end,
    },
  })
  assert_eq(actual, node, "get_node_safely should return the node when get_node succeeds")
end

do
  local actual = compat.get_node_safely({
    tree = {
      get_node = function()
        error(".../nui/tree/init.lua:261: Invalid 'win': Expected Lua number")
      end,
    },
  })
  assert(actual == nil, "get_node_safely should suppress the known stale window failure")
end

do
  local ok, err = pcall(function()
    compat.get_node_safely({
      tree = {
        get_node = function()
          error("boom")
        end,
      },
    })
  end)
  assert(not ok, "get_node_safely should rethrow unrelated failures")
  assert(type(err) == "string" and err:find("boom", 1, true) ~= nil, "unexpected error while rethrowing unrelated failures")
end

do
  local set_cursor_calls = 0
  local debug_logs = {}
  local api = {
    nvim_buf_get_var = function(_, key)
      if key == "neo_tree_source" then
        return "filesystem"
      end
      if key == "neo_tree_position" then
        return "current"
      end
      error("unexpected key: " .. tostring(key))
    end,
    nvim_get_current_win = function()
      return 17
    end,
    nvim_win_get_cursor = function()
      return { 4, 0 }
    end,
    nvim_get_current_line = function()
      return "prefix target suffix"
    end,
    nvim_win_set_cursor = function(_, pos)
      set_cursor_calls = set_cursor_calls + 1
      assert_eq(pos[1], 4, "handler should preserve the row")
      assert_eq(pos[2], 7, "handler should move the cursor to the filename start")
    end,
  }

  compat.hijack_cursor_handler({
    api = api,
    log = {
      debug = function(message)
        debug_logs[#debug_logs + 1] = message
      end,
    },
    manager = {
      get_state = function(source, _, winid)
        assert_eq(source, "filesystem", "handler should forward the neo-tree source to the manager")
        assert_eq(winid, 17, "handler should use the current window for neo-tree current-position buffers")
        return {
          tree = {
            get_node = function()
              return { name = "target" }
            end,
          },
        }
      end,
    },
    inspect = vim.inspect,
    filetype = function()
      return "neo-tree"
    end,
  })

  assert_eq(set_cursor_calls, 1, "handler should move the cursor when the node is available")
  assert_eq(#debug_logs, 1, "handler should emit the hijack debug log once")
end

do
  local set_cursor_calls = 0
  local manager_calls = 0

  local ok, err = pcall(function()
    compat.hijack_cursor_handler({
      api = {
        nvim_buf_get_var = function(_, key)
          if key == "neo_tree_source" then
            return "filesystem"
          end
          if key == "neo_tree_position" then
            return "current"
          end
        end,
        nvim_get_current_win = function()
          return 9
        end,
        nvim_win_get_cursor = function()
          return { 1, 0 }
        end,
        nvim_get_current_line = function()
          return "target"
        end,
        nvim_win_set_cursor = function()
          set_cursor_calls = set_cursor_calls + 1
        end,
      },
      log = { debug = function() end },
      manager = {
        get_state = function()
          manager_calls = manager_calls + 1
          return {
            tree = {
              get_node = function()
                error(".../nui/tree/init.lua:261: Invalid 'win': Expected Lua number")
              end,
            },
          }
        end,
      },
      inspect = vim.inspect,
      filetype = function()
        return "neo-tree"
      end,
    })
  end)

  assert(ok, string.format("handler should suppress stale window failures, got: %s", tostring(err)))
  assert_eq(manager_calls, 1, "handler should still query neo-tree state once")
  assert_eq(set_cursor_calls, 0, "handler should not move the cursor after a stale window failure")
end

do
  local ok, err = pcall(function()
    compat.hijack_cursor_handler({
      api = {
        nvim_buf_get_var = function()
          error("missing neo_tree_source")
        end,
      },
      log = { debug = function() end },
      manager = {
        get_state = function()
          error("manager should not be reached when neo_tree_source is unavailable")
        end,
      },
      inspect = function(value)
        return tostring(value)
      end,
      filetype = function()
        return "neo-tree"
      end,
    })
  end)

  assert(ok, string.format("handler should no-op when neo_tree_source is unavailable, got: %s", tostring(err)))
end

do
  local subscriptions = {}
  local events = {
    VIM_CURSOR_MOVED = "vim_cursor_moved",
    subscribe = function(spec)
      subscriptions[#subscriptions + 1] = spec
    end,
  }
  local hijack_cursor = {}

  compat.patch_hijack_cursor_module({
    events = events,
    hijack_cursor = hijack_cursor,
  })
  local first_setup = hijack_cursor.setup

  compat.patch_hijack_cursor_module({
    events = events,
    hijack_cursor = hijack_cursor,
  })

  assert_eq(hijack_cursor.setup, first_setup, "patch_hijack_cursor_module should be idempotent")
  assert(hijack_cursor._zchee_hijack_cursor_patched, "patch_hijack_cursor_module should mark the module as patched")

  hijack_cursor.setup()
  assert_eq(#subscriptions, 1, "patched setup should subscribe exactly one handler")
  assert_eq(subscriptions[1].event, "vim_cursor_moved", "patched setup should subscribe to the cursor-moved event")
  assert_eq(subscriptions[1].id, "neo-tree-hijack-cursor", "patched setup should preserve the upstream subscription id")
end
