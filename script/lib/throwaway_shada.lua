-- Throwaway ShaDa for full-config child sessions.
--
--   local throwaway_shada = dofile("<repo>/script/lib/throwaway_shada.lua")
--   cmd = { "nvim", "-i", throwaway_shada(), ... }
--
-- Full-config child sessions write ShaDa on exit, and a round runs dozens of
-- them: they race for the main.shada.tmp.a-z namespace and any child killed
-- mid-write strands a temp file, until all 26 are taken and every later write
-- fails with E138 (the user's interactive nvim included). Point each child at a
-- throwaway copy instead -- seeded from the real file so its read cost stays
-- representative, "NONE" (for `-i NONE`) when there is nothing to copy.
--
-- The copy lives under the calling process's tempname() directory, which
-- Neovim deletes when that process exits.

--- Copies the real main.shada to a temp path and returns the value for `-i`.
--- @return string path of the copy, or "NONE" when there is no file to copy
return function()
  local real = vim.fs.joinpath(tostring(vim.fn.stdpath("state")), "shada", "main.shada")
  if not vim.uv.fs_stat(real) then
    return "NONE"
  end
  local copy = vim.fn.tempname() .. ".shada"
  local ok = vim.uv.fs_copyfile(real, copy)
  return ok and copy or "NONE"
end
