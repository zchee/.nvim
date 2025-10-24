local codecompanion = require("codecompanion")

-- https://codecompanion.olimorris.dev/configuration/introduction.html
codecompanion.setup({
  strategies = {
    chat = {
      adapter = "anthropic",
    },
    inline = {
      adapter = "anthropic",
    },
    cmd = {
      adapter = "anthropic",
    }
  },
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        make_vars = true,
        make_slash_commands = true,
        show_result_in_chat = true
      }
    },
    history = {
      enabled = true,
      opts = {
        keymap = "gh",                                                    -- Keymap to open history from chat buffer (default: gh)
        auto_generate_title = true,                                       -- Automatically generate titles for new chats
        continue_last_chat = false,                                       ---On exiting and entering neovim, loads the last chat on opening chat
        delete_on_clearing_chat = false,                                  ---When chat is cleared with `gx` delete the chat from history
        picker = "snacks",                                                -- Picker interface ("telescope" or "snacks" or "default")
        enable_logging = false,                                           ---Enable detailed logging for history extension
        dir_to_save = vim.fn.stdpath("data") .. "/codecompanion/history", ---Directory path to save the chats
        auto_save = true,                                                 -- Save all chats by default
        save_chat_keymap = "sc",                                          -- Keymap to save the current chat manually
      }
    },
    vectorcode = {
      opts = {
        add_tool = true,
        add_slash_command = true,
        tool_opts = {},
      }
    },
  },
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "NEOVIM_ANTHROPIC_API_KEY",
        },
        headers = {
          ["anthropic-version"] = "2023-06-01",
          ["anthropic-beta"] =
          "prompt-caching-2024-07-31,pdfs-2024-09-25,output-128k-2025-02-19,token-efficient-tools-2025-02-19,prompt-tools-2025-04-02",   -- ,computer-use-2025-01-24
        },
        schema = {
          model = {
            default = "claude-3-7-sonnet-20250219",
            choices = {
              ["claude-3-7-sonnet-20250219"] = {
                opts = {
                  can_reason = true,
                  has_token_efficient_tools = true,
                },
              },
              "claude-3-5-haiku-20241022",
            },
          },
          extended_output = {
            default = true,
          },
          thinking_budget = {
            default = 32000,
          },
          max_tokens = {
            default = function(self)
              local default_max_tokens = 4096
              local sonnet_thought_max_tokens = 64000
              local model = self.schema.model.default
              if
                  self.schema.model.choices[model]
                  and self.schema.model.choices[model].opts
                  and self.schema.model.choices[model].opts.can_reason
              then
                return sonnet_thought_max_tokens
              end
              return default_max_tokens
            end,
          },
          temperature = {
            default = 0,
          },
          top_p = {
            default = nil, -- n >= 0 and n <= 1
          },
          top_k = {
            default = nil, -- n >= 0
          },
          -- stop_sequences = {
          --   order = 9,
          --   mapping = "parameters",
          --   type = "list",
          --   optional = true,
          --   default = nil,
          --   subtype = {
          --     type = "string",
          --   },
          --   desc = "Sequences where the API will stop generating further tokens",
          --   validate = function(l)
          --     return #l >= 1, "Must have more than 1 element"
          --   end,
          -- },
        },
      })
    end,
  },
  display = {
    action_palette = {
      width = 95,
      height = 10,
      prompt = "Prompt ",                   -- Prompt used for interactive LLM calls
      provider = "snacks",                  -- "default", "telescope", "mini_pick" "snacks"
      opts = {
        show_default_actions = true,        -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
  },
  opts = {
    log_level = "DEBUG",
    ---@class CodeCompanion.SystemPromptOpts
    ---@field adapter CodeCompanion.Adapter The adapter to use for the chat
    ---@field language string The language used for LLM responses
    ---@param opts CodeCompanion.SystemPromptOpts
    ---@return string
    system_prompt = function(opts)
      local language = opts.language or "English"
      ---This is the default prompt which is sent with every request in the chat
      ---strategy. It is primarily based on the GitHub Copilot Chat's prompt
      ---but with some modifications. You can choose to remove this via
      ---your own config but note that LLM results may not be as good
      return string.format(
        [[You are an AI programming assistant named "CodeCompanion". You are currently plugged into the Neovim text editor on a user's machine.

        Your core tasks include:
        - Answering general programming questions.
        - Explaining how the code in a Neovim buffer works.
        - Reviewing the selected code from a Neovim buffer.
        - Generating unit tests for the selected code.
        - Proposing fixes for problems in the selected code.
        - Scaffolding code for a new workspace.
        - Finding relevant code to the user's query.
        - Proposing fixes for test failures.
        - Answering questions about Neovim.
        - Running tools.

        You must:
        - Follow the user's requirements carefully and to the letter.
        - Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
        - Minimize additional prose unless clarification is needed.
        - Use Markdown formatting in your answers.
        - Include the programming language name at the start of each Markdown code block.
        - Avoid including line numbers in code blocks.
        - Avoid wrapping the whole response in triple backticks.
        - Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.
        - Avoid using H1, H2 or H3 headers in your responses as these are reserved for the user.
        - Use actual line breaks in your responses; only use "\n" when you want a literal backslash followed by 'n'.
        - All non-code text responses must be written in the %s language indicated.
        - Multiple, different tools can be called as part of the same response.

        When given a task:
        1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.
        2. Output the final code in a single code block, ensuring that only relevant code is included.
        3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.
        4. Provide exactly one complete reply per conversation turn.
        5. If necessary, execute multiple tools in a single turn.]],
        language
      )
    end,
  }
})
