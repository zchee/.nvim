-- lua/config/autocmd.lua -- the auto-hlsearch vim.on_key handler. It runs on
-- every physical keystroke, so it must never cross the vim.fn VimL bridge:
-- this spec replaces vim.fn with a proxy that errors on any access, then
-- drives the handler through the search-key truth table and the typed==""
-- (mapping expansion) and non-normal-mode early returns.
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
      on_key(nil, key)
      assert_equal(vim.o.hlsearch, true, ("search key %s must enable hlsearch"):format(vim.inspect(key)))
    end
  end

  do -- normal-mode <CR> is the "open file" key in neo-tree/quickfix/help:
    -- it must CLEAR, not enable (a cmdline search confirm arrives in mode
    -- "c" and never reaches the handler, so a <CR> enable entry could only
    -- ever paint stale shada matches onto freshly opened buffers)
    vim.o.hlsearch = true
    on_key(nil, cr)
    assert_equal(vim.o.hlsearch, false, "normal-mode <CR> must clear hlsearch")
  end

  do -- any other typed key turns hlsearch off
    for _, key in ipairs({ "j", "x", "G", "a" }) do
      vim.o.hlsearch = true
      on_key(nil, key)
      assert_equal(vim.o.hlsearch, false, ("non-search key %s must clear hlsearch"):format(vim.inspect(key)))
    end
  end

  do -- keys produced by mapping expansion (typed == "") never toggle
    vim.o.hlsearch = true
    on_key("n", "")
    assert_equal(vim.o.hlsearch, true, "mapped-key expansion (typed=='') must not toggle hlsearch")
  end

  do -- no redundant option writes: value already matching stays untouched
    vim.o.hlsearch = true
    on_key(nil, "/")
    assert_equal(vim.o.hlsearch, true, "search key with hlsearch already on must keep it on")
    vim.o.hlsearch = false
    on_key(nil, "j")
    assert_equal(vim.o.hlsearch, false, "non-search key with hlsearch already off must keep it off")
  end

  do -- non-normal mode is ignored
    vim.api.nvim_feedkeys("i", "nx!", false)
    assert_equal(vim.api.nvim_get_mode().mode:sub(1, 1), "i", "spec precondition: feedkeys must enter insert mode")
    vim.o.hlsearch = false
    on_key(nil, "/")
    assert_equal(vim.o.hlsearch, false, "insert-mode '/' must not enable hlsearch")
    vim.o.hlsearch = true
    on_key(nil, "j")
    assert_equal(vim.o.hlsearch, true, "insert-mode 'j' must not clear hlsearch")
  end
end)

vim.fn = real_fn
if not ok then
  error(err, 0)
end

vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
