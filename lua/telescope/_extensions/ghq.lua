local actions = require("telescope.actions")
local actions_set = require("telescope.actions.set")
local actions_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local from_entry = require("telescope.from_entry")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local utils = require("telescope.utils")
local Path = require("plenary.path")

local os_home = vim.loop.os_homedir()

local M = {}

local function search_readme(dir)
  for _, name in pairs{
    'README', 'README.md', 'README.markdown', 'README.mkd',
  } do
    local file = dir / name
    if file:is_file() then return file end
  end
  return nil
end

local function search_doc(dir)
  local doc_path = Path:new(dir, 'doc', '**', '*.txt')
  local maybe_doc = vim.split(vim.fn.glob(doc_path.filename), '\n')
  for _, filepath in pairs(maybe_doc) do
    local file = Path:new(filepath)
    if file:is_file() then return file end
  end
  return nil
end

local function gen_from_ghq(opts)
  local displayer = entry_display.create{
    items = {{}},
  }

  local function make_display(entry)
    local dir = (function(path)
      if path == Path.path.root() then return path end

      local p = Path:new(path)
      if opts.tail_path then
        local parts = p:_split()
        return parts[#parts]
      end

      if opts.shorten_path then return p:shorten() end

      if vim.startswith(path, opts.cwd) and path ~= opts.cwd then
        return Path:new(p):make_relative(opts.cwd)
      end

      if vim.startswith(path, os_home) then
        return (Path:new'~' / p:make_relative(os_home)).filename
      end
      return path
    end)(entry.path)

    return displayer{dir}
  end

  return function(line)
    return {
      value = line,
      ordinal = line,
      path = line,
      display = make_display,
    }
  end
end

M.list = function(opts)
  opts = opts or {}
  opts.bin = opts.bin and vim.fn.expand(opts.bin) or 'ghq'
  opts.cwd = utils.get_lazy_default(opts.cwd, vim.loop.cwd)
  opts.entry_maker = utils.get_lazy_default(opts.entry_maker, gen_from_ghq, opts)

  local bin = vim.fn.expand(opts.bin)
  pickers.new(opts, {
    prompt_title = 'Repositories managed by ghq',
    finder = finders.new_oneshot_job(
      {bin, 'list', '--full-path'},
      opts
    ),
    previewer = previewers.new_termopen_previewer{
      get_command = function(entry)
        local dir = Path:new(from_entry.path(entry))
        local doc = search_readme(dir)
        local is_mardown
        if doc then
          is_mardown = true
        else
          -- TODO: doc may be previewed in a plain text. Can I use syntax highlight?
          doc = search_doc(dir)
        end
        if doc then
          if is_mardown and vim.fn.executable'glow' == 1 then
            return {'glow', doc.filename}
          elseif vim.fn.executable'bat' == 1 then
            return {'bat', '--style', 'header,grid', doc.filename}
          end
          return {'cat', doc.filename}
        end
        return {'echo', ''}
      end,
    },
    sorter = conf.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions_set.select:replace(function(_, type)
        local entry = actions_state.get_selected_entry()
        local dir = from_entry.path(entry)
        if type == 'default' then
          require'telescope.builtin'.git_files{cwd = dir}
          return
        end
        actions.close(prompt_bufnr)
        if type == 'horizontal' then
          vim.cmd('cd '..dir)
          print('chdir to '..dir)
        elseif type == 'vertical' then
          vim.cmd('lcd '..dir)
          print('lchdir to '..dir)
        elseif type == 'tab' then
          vim.cmd('tcd '..dir)
          print('tchdir to '..dir)
        end
      end)
      return true
    end,
  }):find()
end

return require("telescope").register_extension{
  exports = {
    list = M.list
  },
}
