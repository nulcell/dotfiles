-- Claude Code comes from the ai.claudecode extra (lua/config/lazy.lua).
--
-- Local ghost-text completion via Ollama (free, offline). One-time setup:
--   brew install ollama && brew services start ollama
--   ollama pull qwen2.5-coder:3b   -- or :1.5b (faster) / :7b (better)
-- Manual: <M-]> requests a suggestion, <M-y> accepts. Setup and keys: README.md.
-- Flip AUTO_TRIGGER for Copilot-style automatic suggestions.
local AUTO_TRIGGER = false

return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      context_window = 2048,
      request_timeout = 3,
      throttle = 1000,
      debounce = 400,
      notify = "warn",
      virtualtext = {
        auto_trigger_ft = AUTO_TRIGGER and { "*" } or {},
        auto_trigger_ignore_ft = { "markdown", "text", "gitcommit", "help" },
        keymap = {
          accept = "<M-y>",
          accept_line = "<M-Y>",
          prev = "<M-[>",
          next = "<M-]>",
          dismiss = "<M-e>",
        },
      },
      provider_options = {
        openai_fim_compatible = {
          api_key = "TERM", -- Ollama needs no key; minuet just wants a set env var
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = "qwen2.5-coder:3b",
          optional = { max_tokens = 128, top_p = 0.9 },
        },
      },
    },
    keys = {
      { "<leader>am", "<cmd>Minuet virtualtext toggle<cr>", desc = "Toggle inline AI completion" },
    },
  },
}
