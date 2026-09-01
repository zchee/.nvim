-- Embed UI latency client (round-3.5 plan item 3).
--
-- Spawns `nvim --embed` as a child process, attaches a msgpack-RPC UI over
-- the child's stdio pipes (vim.uv.spawn + vim.mpack), and measures:
--   - attach -> first "redraw" batch ending in "flush" (first paint)
--   - nvim_input keystroke -> next "flush" (median of 10, one per 50 ms)
-- No pty sits between client and server, so the numbers are free of the
-- ~100 ms DSR/termresponse artifact that inflates `script -q` pty runs.
--
-- Usage: nvim -l script/ui-latency.lua [--clean|--full] [--socket-free]
--        [--json <path>] [--edit <file>] [--settle-ms <n>] [--keys <n>]
--        [--pre-keys-lua <code>] [--post-keys-lua <code>] [--key <seq>]
--        [--pre-wait <lua expr>]
--   --clean        child runs with -u NONE -i NONE (config floor)
--   --full         child runs the real config (default)
--   --socket-free  strip NVIM / NVIM_LISTEN_ADDRESS from the child env so a
--                  parent nvim server never leaks into the measurement
--   --json <path>  also write the measurements as JSON, with each event's
--                  REAL offset from spawn (sent_ms, relative to t0), so
--                  script/perf-trace.lua --ui-latency can place keystroke
--                  slices at true positions on its own trace track
--   --edit <file>  open a real file in the child (typing then exercises
--                  treesitter/LSP/chrome instead of an empty [No Name])
--   --settle-ms    idle gap between first flush and typing (default 300;
--                  raise it so warmup/LSP attach finish first)
--   --keys <n>     keystroke sample count (default 10)
--   --pre-keys-lua / --post-keys-lua
--                  Lua run in the CHILD via nvim_exec_lua right before /
--                  after the key phase: the round-4 V4 attribution hooks
--                  (jit.p start/stop, runtime A/B toggles, an in-child
--                  stall probe). The post code's return value lands in
--                  the output as post_keys_result (JSON-encoded line and
--                  --json field); errors in either fail the run.
--
-- Output (machine-parseable, one per line):
--   mode=<clean|full>
--   attach_to_first_flush_ms=<float>
--   input_to_flush_ms_median=<float>
--   input_to_flush_ms_samples=<comma-separated floats>
-- Every phase is bounded by a deadline; the script never hangs (overall
-- timeout 30 s) and exits non-zero on any failure or timeout.

local uv = vim.uv

local KEY_INTERVAL_MS = 50

local mode = "full"
local socket_free = false
local json_path, edit_file, pre_keys_lua, post_keys_lua
local key_seq = "x" -- per-sample key (nvim_input notation; --key overrides)
local pre_wait_expr -- --pre-wait: Lua expr polled in the child (200ms grid,
-- 15s cap) after the "i" flush and before the key phase, so an arrangement
-- driven by input queues (completion menu + docs window) can finish opening
local settle_ms = 300 -- drain stray startup flushes before feeding input
local keystrokes = 10
do
  local i = 1
  while i <= #arg do
    local a = arg[i]
    if a == "--clean" then
      mode = "clean"
    elseif a == "--full" then
      mode = "full"
    elseif a == "--socket-free" then
      socket_free = true
    elseif a == "--json" and arg[i + 1] then
      json_path = arg[i + 1]
      i = i + 1
    elseif a == "--edit" and arg[i + 1] then
      edit_file = arg[i + 1]
      i = i + 1
    elseif a == "--settle-ms" and tonumber(arg[i + 1]) then
      settle_ms = assert(tonumber(arg[i + 1]))
      i = i + 1
    elseif a == "--pre-wait" and arg[i + 1] then
      pre_wait_expr = arg[i + 1]
      i = i + 1
    elseif a == "--key" and arg[i + 1] then
      key_seq = arg[i + 1]
      i = i + 1
    elseif a == "--keys" and tonumber(arg[i + 1]) then
      keystrokes = assert(tonumber(arg[i + 1]))
      i = i + 1
    elseif a == "--pre-keys-lua" and arg[i + 1] then
      pre_keys_lua = arg[i + 1]
      i = i + 1
    elseif a == "--post-keys-lua" and arg[i + 1] then
      post_keys_lua = arg[i + 1]
      i = i + 1
    else
      io.stderr:write(("ui-latency: unknown argument %q\n"):format(a))
      os.exit(64)
    end
    i = i + 1
  end
end

local OVERALL_TIMEOUT_MS = math.max(30000, settle_ms + keystrokes * KEY_INTERVAL_MS * 3 + 20000)

local done = false
local failure = nil
local child_exited = false

local stdin_pipe = assert(uv.new_pipe(false))
local stdout_pipe = assert(uv.new_pipe(false))
local stderr_pipe = assert(uv.new_pipe(false))
local timers = {}
local process

local function fail(message)
  if not failure then
    failure = message
  end
  done = true
end

--- One-shot uv timer kept in `timers` so cleanup can cancel it.
local function after(ms, fn)
  local t = assert(uv.new_timer())
  timers[#timers + 1] = t
  t:start(ms, 0, function()
    t:stop()
    fn()
  end)
  return t
end

local spawn_args = { "--embed" }
if mode == "clean" then
  vim.list_extend(spawn_args, { "-u", "NONE", "-i", "NONE" })
end
if edit_file then
  spawn_args[#spawn_args + 1] = edit_file
end

local spawn_env = nil
if socket_free then
  spawn_env = {}
  for name, value in pairs(uv.os_environ()) do
    if name ~= "NVIM" and name ~= "NVIM_LISTEN_ADDRESS" then
      spawn_env[#spawn_env + 1] = name .. "=" .. value
    end
  end
end

local t0 = uv.hrtime()
local spawn_err
process, spawn_err = uv.spawn(vim.v.progpath, {
  args = spawn_args,
  env = spawn_env,
  stdio = { stdin_pipe, stdout_pipe, stderr_pipe },
}, function()
  child_exited = true
  done = true
end)
if not process then
  io.stderr:write(("ui-latency: spawn failed: %s\n"):format(tostring(spawn_err)))
  os.exit(1)
end

-- Minimal msgpack-RPC framing: [0,msgid,method,args] request out,
-- [1,msgid,err,result] response / [2,method,args] notification in.
local msgid = 0
local pending = {}
local function request(method, params, cb)
  msgid = msgid + 1
  pending[msgid] = cb or false
  stdin_pipe:write(vim.mpack.encode({ 0, msgid, method, params }))
end

-- Measurement state machine, driven entirely by "flush" redraw events.
-- Phases: attach (first paint) -> settle [-> pre-keys-lua] -> insert
-- ("i" fed) -> keys (keystrokes x "x", latency = send -> next flush)
-- [-> post-keys-lua] -> quit.
local phase = "attach"
local attach_ms = nil
local samples = {}
local t_sent = nil
local post_keys_result = vim.NIL
-- Timeline events for --json: name + real send offset from t0 + latency,
-- so a trace consumer can place slices at true positions.
local timeline = {}

local function record(name, sent_hr, now)
  timeline[#timeline + 1] = {
    name = name,
    sent_ms = (sent_hr - t0) / 1e6,
    latency_ms = (now - sent_hr) / 1e6,
  }
end

local function send_key()
  t_sent = uv.hrtime()
  request("nvim_input", { key_seq })
end

local function on_flush(now)
  if phase == "attach" then
    attach_ms = (now - t0) / 1e6
    record("attach->first-flush", t0, now)
    phase = "settle"
    after(settle_ms, function()
      local function start_insert()
        phase = "insert"
        t_sent = uv.hrtime()
        request("nvim_input", { "i" })
      end
      if pre_keys_lua then
        request("nvim_exec_lua", { pre_keys_lua, {} }, start_insert)
      else
        start_insert()
      end
    end)
  elseif phase == "insert" and t_sent then
    record("insert (i)", t_sent, now)
    t_sent = nil
    if pre_wait_expr then
      phase = "prewait"
      local deadline = uv.hrtime() + 15e9
      local function poll()
        request("nvim_exec_lua", { "return (" .. pre_wait_expr .. ") == true", {} }, function(ready)
          if ready == true then
            phase = "keys"
            after(KEY_INTERVAL_MS, send_key)
          elseif uv.hrtime() > deadline then
            fail("--pre-wait expression never became true: " .. pre_wait_expr)
          else
            after(200, poll)
          end
        end)
      end
      poll()
    else
      phase = "keys"
      after(KEY_INTERVAL_MS, send_key)
    end
  elseif phase == "keys" and t_sent then
    samples[#samples + 1] = (now - t_sent) / 1e6
    record(("key %d (x)"):format(#samples), t_sent, now)
    t_sent = nil
    if #samples >= keystrokes then
      local function quit()
        phase = "quit"
        request("nvim_command", { "qa!" })
      end
      if post_keys_lua then
        phase = "post" -- exec_lua errors here must still fail the run
        request("nvim_exec_lua", { post_keys_lua, {} }, function(result)
          post_keys_result = result
          quit()
        end)
      else
        quit()
      end
    else
      after(KEY_INTERVAL_MS, send_key)
    end
  end
end

local function handle_message(msg)
  if type(msg) ~= "table" then
    return fail("unexpected non-array msgpack-RPC message")
  end
  if msg[1] == 1 then
    local cb = pending[msg[2]]
    pending[msg[2]] = nil
    if msg[3] ~= nil and msg[3] ~= vim.NIL and phase ~= "quit" then
      return fail(("RPC error: %s"):format(vim.inspect(msg[3])))
    end
    if cb then
      cb(msg[4])
    end
  elseif msg[1] == 2 and msg[2] == "redraw" then
    local now = uv.hrtime()
    for _, event in ipairs(msg[3]) do
      if event[1] == "flush" then
        on_flush(now)
        break
      end
    end
  end
end

-- vim.mpack.Unpacker retains partial-message state across calls: feed each
-- chunk once, pull complete messages out with the returned position, and a
-- nil result means the chunk's tail is buffered inside the unpacker.
local unpacker = vim.mpack.Unpacker()
stdout_pipe:read_start(function(err, chunk)
  if err then
    return fail("stdout read error: " .. tostring(err))
  end
  if not chunk then
    if phase ~= "quit" then
      fail("child closed stdout before the measurement finished")
    end
    return
  end
  local pos = 1
  while pos <= #chunk do
    local ok, msg, next_pos = pcall(unpacker, chunk, pos)
    if not ok then
      return fail("msgpack decode error: " .. tostring(msg))
    end
    if msg == nil then
      return
    end
    handle_message(msg)
    if done then
      return
    end
    pos = next_pos
  end
end)
stderr_pipe:read_start(function(_, _) end) -- drain; full config may chatter

request("nvim_ui_attach", { 120, 40, { ext_linegrid = true } })

vim.wait(OVERALL_TIMEOUT_MS, function()
  return done
end, 10)

if not done then
  failure = ("timed out after %d ms in phase %q (%d/%d samples)"):format(
    OVERALL_TIMEOUT_MS,
    phase,
    #samples,
    keystrokes
  )
end

for _, t in ipairs(timers) do
  if not t:is_closing() then
    t:stop()
    t:close()
  end
end
for _, pipe in ipairs({ stdin_pipe, stdout_pipe, stderr_pipe }) do
  if not pipe:is_closing() then
    pipe:close()
  end
end
if process and not child_exited then
  process:kill("sigkill")
end
vim.wait(1000, function()
  return child_exited
end, 10)
if process and not process:is_closing() then
  process:close()
end

if failure then
  io.stderr:write("ui-latency: " .. failure .. "\n")
  os.exit(1)
end

table.sort(samples)
local median = samples[math.ceil(#samples / 2)]
local formatted = {}
for _, s in ipairs(samples) do
  formatted[#formatted + 1] = ("%.3f"):format(s)
end
io.stdout:write(("mode=%s\n"):format(mode))
io.stdout:write(("attach_to_first_flush_ms=%.3f\n"):format(attach_ms))
io.stdout:write(("input_to_flush_ms_median=%.3f\n"):format(median))
io.stdout:write(("input_to_flush_ms_samples=%s\n"):format(table.concat(formatted, ",")))
if post_keys_lua then
  io.stdout:write(("post_keys_result=%s\n"):format(vim.json.encode(post_keys_result)))
end

if json_path then
  local f = assert(io.open(json_path, "w"), "ui-latency: cannot write " .. json_path)
  f:write(vim.json.encode({
    mode = mode,
    attach_to_first_flush_ms = attach_ms,
    input_to_flush_ms_median = median,
    events = timeline,
    post_keys_result = post_keys_result,
  }))
  f:close()
end
