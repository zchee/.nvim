local util = require("util")

---@type avante.Config
return {
  debug = false,
  mode = "agentic",
  tokenizer = "tiktoken",
  provider = "claude",
  auto_suggestions_provider = "claude",
  behaviour = {
    auto_focus_sidebar = true,
    auto_suggestions = true, -- Experimental stage
    auto_suggestions_respect_ignore = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    jump_result_buffer_on_finish = false,
    support_paste_from_clipboard = true,
    minimize_diff = true,
    enable_token_counting = true,
    enable_cursor_planning_mode = true,
    enable_claude_text_editor_tool_mode = true,
    use_cwd_as_project_root = false,
  },
  dual_boost = {
    enabled = true,
    first_provider = "claude",
    second_provider = "gemini",
    prompt =
    "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000,
  },
  mappings = {
    ---@class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    cancel = {
      normal = { "<C-c>", "<Esc>", "q" },
      insert = { "<C-c>" },
    },
    ask = "<Space>aa",
    edit = "<Space>ae",
    refresh = "<Space>af",
    focus = "<Space>af",
    stop = "<leader>aS",
    toggle = {
      default = "<leader>at",
      debug = "<leader>ad",
      hint = "<leader>ah",
      suggestion = "<leader>as",
      repomap = "<leader>aR",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      retry_user_request = "r",
      edit_user_request = "e",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
      remove_file = "d",
      add_file = "@",
      close = { "<Esc>", "q" },
      ---@type AvanteCloseFromInput | nil
      close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
    },
    files = {
      add_current = "<leader>ac",     -- Add current buffer to selected files
      add_all_buffers = "<leader>aB", -- Add all buffer files to selected files
    },
    select_model = "<leader>a?",      -- Select model command
    select_history = "<leader>ah",    -- Select history command
  },
  windows = {
    position = "right",
    width = 50,
    sidebar_header = {
      align = "center",
      rounded = false,
    },
    ask = {
      floating = true,
      start_insert = true,
      border = "rounded"
    }
  },
  ---@type AvanteSupportedProvider
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-sonnet-4-20250514",
      timeout = 30000,
      extra_headers = {
        ["anthropic-beta"] =
        "files-api-2025-04-14,mcp-client-2025-04-04,interleaved-thinking-2025-05-14,code-execution-2025-05-22,extended-cache-ttl-2025-04-11",
      },
      extra_request_body = {
        temperature = 0,
        max_tokens = 64000,
        -- max_completion_tokens = 0,
      },
      use_ReAct_prompt = true,
    },
    vertex_claude = nil,
    bedrock = nil,
    ---@type AvanteSupportedProvider
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "o4-mini-2025-04-16",
      timeout = 30000,
      extra_request_body = {
        options = {
          temperature = 0,
          max_tokens = 32768,
          reasoning_effort = "high",
        },
      },
    },
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.5-pro-preview-05-06",
      timeout = 30000,
      extra_request_body = {
        options = {
          temperature = 0,
          max_tokens = 8192,
        },
      },
    },
    vertex = nil,
    ---@type AvanteSupportedProvider
    copilot = {
      endpoint = "https://api.githubcopilot.com",
      model = "gpt-4o-2024-08-06",
      allow_insecure = false,
      timeout = 30000,
      extra_request_body = {
        options = {
          temperature = 0,
          max_tokens = 20480,
        },
      },
    },
    ollama = {
      endpoint = "http://127.0.0.1:11434",
      timeout = 30000,
      extra_request_body = {
        options = {
          temperature = 0,
          num_ctx = 20480,
        },
      },
    },
    azure = nil,
    cohere = nil,
    ---@type {[string]: AvanteProvider}
    -- groq = {
    --   __inherited_from = "openai",
    --   api_key_name = "GROQ_API_KEY",
    --   endpoint = "https://api.groq.com/openai/v1/",
    --   model = "llama-3.3-70b-versatile",
    --   max_tokens = 32768,
    -- },
    -- perplexity = {
    --   __inherited_from = "openai",
    --   api_key_name = "PERPLEXITY_API_KEY",
    --   endpoint =
    --   "https://gateway.ai.cloudflare.com/v1/d6207debc3c9dc44111f2df701702a4a/gaudiy/perplexity-ai/chat/completions",
    --   model = "sonar-reasoning-pro",
    --   max_tokens = 32768,
    -- },
  },
  rag_service = {
    enabled = false,
    host_mount = vim.fs.joinpath(util.xdg_state_home(), "nvim", "avante-rag"),
    provider = "openai",
    llm_model = "o3-2025-04-16",
    embed_model = "text-embedding-3-large",
    endpoint = "https://api.openai.com/v1",
  },
  history = {
    max_tokens = 4096,
    carried_entry_count = nil,
    storage_path = vim.fn.stdpath("state") .. "/avante",
    paste = {
      extension = "png",
      filename = "pasted-%Y-%m-%d-%H-%M-%S",
    },
  },
  highlights = {
    diff = {
      current = nil,
      incoming = nil,
    },
  },
  img_paste = {
    url_encode_path = true,
    template = "\nimage: $FILE_PATH\n",
  },
  web_search_engine = {
    provider = "brave", -- tavily, serpapi, searchapi, google kagi, or brave
  },
  --- @class AvanteConflictConfig
  diff = {
    autojump = true,
    --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
    --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
    --- Disable by setting to -1.
    override_timeoutlen = 500,
  },
  --- @type AvanteHintsConfig
  hints = {
    enabled = true,
  },
  --- @type AvanteRepoMapConfig
  repo_map = {
    ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules" }, -- ignore files matching these
    negate_patterns = {},                                                       -- negate ignore files matching these.
  },
  --- @type AvanteFileSelectorConfig
  file_selector = {
    provider = nil,
    -- Options override for custom providers
    provider_opts = {},
  },
  selector = {
    provider = "snacks",
    provider_opts = {},
  },
  input = {
    provider = "snacks",
    provider_opts = {
      -- Additional snacks.input options
      title = "Avante Input",
      icon = " ",
    },
  },
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
  -- other config
  -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    if hub == nil then
      return
    end
    return hub:get_active_servers_prompt()
  end,
  ---@type string[]
  disabled_tools = {},
  -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
  ---@type AvanteLLMToolPublic[] | fun(): AvanteLLMToolPublic[]
  custom_tools = function()
    return {
      require("mcphub.extensions.avante").mcp_tool(),
    }
  end,
  ---@type AvanteSlashCommand[]
  slash_commands = {},
}
