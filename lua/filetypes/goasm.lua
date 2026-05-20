local M = {}

local arches = {
  "amd64",
  "arm64",
  "arm",
  "386",
  "riscv64",
  "loong64",
  "mips64",
  "mips64le",
  "mips",
  "mipsle",
  "ppc64",
  "ppc64le",
  "s390x",
  "wasm",
}

local go_headers = {
  ["textflag.h"] = true,
  ["funcdata.h"] = true,
  ["go_asm.h"] = true,
  ["go_tls.h"] = true,
}

local function has_go_assembly_header(bufnr)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 64, false)) do
    local header = line:match('^%s*#include%s+"(%a[%w_]*%.h)"')
    if header and go_headers[header] then
      return true
    end
  end
  return false
end

local function has_go_assembly_name(path)
  local name = vim.fn.fnamemodify(path, ":t")
  for _, arch in ipairs(arches) do
    if name == arch .. ".s" or name:match("_" .. arch .. "%.s$") then
      return true
    end
  end
  return false
end

local function has_neighbor_go_file(path)
  return vim.fn.glob(vim.fn.fnamemodify(path, ":h") .. "/*.go") ~= ""
end

function M.detect(path, bufnr)
  -- Treat as goasm if any of:
  --   1) the buffer includes a Plan 9 / Go runtime header
  --      (textflag.h, funcdata.h, go_asm.h, go_tls.h)
  --   2) the filename is <arch>.s or *_<arch>.s for a known Go arch
  --   3) the file lives next to a *.go file
  if has_go_assembly_header(bufnr) or has_go_assembly_name(path) or has_neighbor_go_file(path) then
    return "goasm"
  end
  return "asm"
end

return M
