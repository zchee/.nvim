-- lua/config/autocmd.lua -- the auto-hlsearch vim.on_key handler. It runs on
-- every physical keystroke, so it must never cross the vim.fn VimL bridge:
-- this spec replaces vim.fn with a proxy that errors on any access, then
-- drives the handler through the search-key truth table, argument keys
-- ("*p, f*, ...), and the typed=="" (mapping expansion) and non-normal-mode
-- early returns.
--
-- Exits 0 only after printing "ALL PASS": a VimLeavePre guard turns any
-- earlier exit into exit 1.
vim.opt.runtimepath:append(vim.fn.getcwd())
package.path = table.concat({
  vim.fn.getcwd() .. "/lua/?.lua",
  vim.fn.getcwd() .. "/lua/?/init.lua",
  package.path,
}, ";")

local autocmd = require("config.autocmd")
local on_key = autocmd.auto_hlsearch_on_key

local function assert_equal(got, want, msg)
  if got ~= want then
    error(("%s: got %s, want %s"):format(msg, vim.inspect(got), vim.inspect(want)), 2)
  end
end

local finished = false
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if not finished then
      io.stderr:write("FAIL: auto_hlsearch_on_key_spec exited before its last assertion\n")
      os.exit(1)
    end
  end,
})

--- Run `fn` while Neovim is really in Insert mode, then leave it. An -l
--- script cannot enter Insert mode and carry on: startinsert and nvim_input
--- take effect only once the script yields to the main loop, and feedkeys
--- "x!" returns only when Insert mode ends. So `fn` runs from a callback
--- scheduled onto the Insert-mode input loop, and feeds the <Esc> itself.
--- Errors are re-raised after Insert mode ends.
---@param fn fun()
local function in_insert_mode(fn)
  local err
  vim.schedule(function()
    local ok, e = pcall(fn)
    if not ok then
      err = e
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end)
  vim.api.nvim_feedkeys("i", "x!", false)
  if err then
    error(err, 0)
  end
end

local cr = vim.keycode("<CR>")

assert_equal(vim.api.nvim_get_mode().mode:sub(1, 1), "n", "spec precondition: headless -l must start in normal mode")

-- Poison vim.fn: any access from here on is a per-keystroke VimL bridge
-- crossing, which the handler must not perform.
local real_fn = vim.fn
vim.fn = setmetatable({}, {
  __index = function(_, key)
    error(("on_key handler reached vim.fn.%s -- the handler must be VimL-bridge free"):format(key), 2)
  end,
})

local ok, err = pcall(function()
  do -- search keys turn hlsearch on
    for _, key in ipairs({ "/", "?", "n", "N", "*", "#" }) do
      vim.o.hlsearch = false
      on_key(key, key)
      assert_equal(vim.o.hlsearch, true, ("search key %s must enable hlsearch"):format(vim.inspect(key)))
    end
  end

  do -- normal-mode <CR> is the "open file" key in neo-tree/quickfix/help:
    -- it must CLEAR, not enable (a cmdline search confirm arrives in mode
    -- "c" and never reaches the handler, so a <CR> enable entry could only
    -- ever paint stale shada matches onto freshly opened buffers)
    vim.o.hlsearch = true
    on_key(cr, cr)
    assert_equal(vim.o.hlsearch, false, "normal-mode <CR> must clear hlsearch")
  end

  do -- any other typed key turns hlsearch off
    for _, key in ipairs({ "j", "x", "G", "a" }) do
      vim.o.hlsearch = true
      on_key(key, key)
      assert_equal(vim.o.hlsearch, false, ("non-search key %s must clear hlsearch"):format(vim.inspect(key)))
    end
  end

  do -- keys produced by mapping expansion (typed == "") never toggle
    vim.o.hlsearch = true
    on_key("n", "")
    assert_equal(vim.o.hlsearch, true, "mapped-key expansion (typed=='') must not toggle hlsearch")
  end

  do -- the key after an argument-taking prefix is that argument, not a
    -- search: "*p pastes register *, f* jumps to a '*', m/ sets mark /
    for _, seq in ipairs({
      { '"', "*", "p" },
      { "f", "*" },
      { "t", "/" },
      { "F", "#" },
      { "T", "?" },
      { "r", "*" },
      { "q", "/" },
      { "m", "n" },
      { "'", "N" },
      { "`", "*" },
      { "@", "/" },
    }) do
      vim.o.hlsearch = false
      for _, key in ipairs(seq) do
        on_key(key, key)
      end
      assert_equal(vim.o.hlsearch, false, ("%s must leave hlsearch off"):format(table.concat(seq)))
    end
    -- the argument is consumed: a search key after it counts again
    vim.o.hlsearch = false
    for _, key in ipairs({ "f", "x", "n" }) do
      on_key(key, key)
    end
    assert_equal(vim.o.hlsearch, true, "fx then n must enable hlsearch")
    -- a prefix that is itself an argument does not arm another: ff then *
    vim.o.hlsearch = false
    for _, key in ipairs({ "f", "f", "*" }) do
      on_key(key, key)
    end
    assert_equal(vim.o.hlsearch, true, "ff then * must enable hlsearch")
    -- a mapped prefix is a command (help's q is :q): the next key is not its
    -- argument, so on_key's key differs from typed and nothing is armed
    vim.o.hlsearch = false
    on_key("\128\253h", "q")
    on_key("n", "n")
    assert_equal(vim.o.hlsearch, true, "n after a mapped q must enable hlsearch")
  end

  do -- the q that stops a recording takes no register: after qa...q the
    -- first n is a search. Real typed keys, so vim.on_key calls the handler
    -- and RecordingEnter/RecordingLeave fire as they do interactively.
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "x y x y x" })
    vim.cmd("let @/ = 'x'")
    vim.o.hlsearch = false
    vim.api.nvim_feedkeys("qajq", "xt", false)
    assert_equal(vim.o.hlsearch, false, "qajq leaves hlsearch off")
    vim.api.nvim_feedkeys("n", "xt", false)
    assert_equal(vim.o.hlsearch, true, "the first n after qajq must enable hlsearch")
    vim.api.nvim_feedkeys("j", "xt", false)
    assert_equal(vim.o.hlsearch, false, "j after it clears hlsearch again")
  end

  do -- no redundant option writes: value already matching stays untouched
    vim.o.hlsearch = true
    on_key("/", "/")
    assert_equal(vim.o.hlsearch, true, "search key with hlsearch already on must keep it on")
    vim.o.hlsearch = false
    on_key("j", "j")
    assert_equal(vim.o.hlsearch, false, "non-search key with hlsearch already off must keep it off")
  end

  do -- non-normal mode is ignored
    local insert_ran = false
    in_insert_mode(function()
      assert_equal(vim.api.nvim_get_mode().mode:sub(1, 1), "i", "spec precondition: the body runs in insert mode")
      vim.o.hlsearch = false
      on_key("/", "/")
      assert_equal(vim.o.hlsearch, false, "insert-mode '/' must not enable hlsearch")
      vim.o.hlsearch = true
      on_key("j", "j")
      assert_equal(vim.o.hlsearch, true, "insert-mode 'j' must not clear hlsearch")
      insert_ran = true
    end)
    assert_equal(insert_ran, true, "the insert-mode checks ran")
    assert_equal(vim.api.nvim_get_mode().mode:sub(1, 1), "n", "back in normal mode")
  end
end)

vim.fn = real_fn
if not ok then
  io.stderr:write("FAIL: " .. tostring(err) .. "\n")
  finished = true -- reported here; the VimLeavePre guard need not repeat it
  os.exit(1)
end

finished = true
print("ALL PASS: auto_hlsearch_on_key_spec")
os.exit(0)
