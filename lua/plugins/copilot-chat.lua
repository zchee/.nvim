-- Returned as `opts` for CopilotC-Nvim/CopilotChat.nvim in lua/plugins/init.lua.

return {
  model = "claude-opus-4.6",
  debug = false,
  instruction_files = {
    ".github/copilot-instructions.md",
    "AGENTS.md",
    "CLAUDE.md",
  },
  window = {
    layout = "vertical",
    width = 0.35,
  },
  mappings = {
    close = {
      normal = "q",
      insert = "<C-c>",
    },
  },
  prompts = {
    ReviewStaged = {
      prompt = "Review the staged diff. Lead with bugs, security issues, regressions, and missing tests. Cite file paths and keep the response terse.",
      system_prompt = "COPILOT_REVIEW",
      resources = { "gitdiff:staged" },
    },
    ReviewUnstaged = {
      prompt = "Review the unstaged diff. Lead with bugs, security issues, regressions, and missing tests. Cite file paths and keep the response terse.",
      system_prompt = "COPILOT_REVIEW",
      resources = { "gitdiff:unstaged" },
    },
    Workspace = {
      prompt = "Use the available workspace tools to answer. Inspect files before making claims, prefer ripgrep-style search, and do not guess about file contents.",
      tools = "copilot",
      sticky = {
        "#buffer:visible",
        "@copilot",
      },
    },
  },
}
