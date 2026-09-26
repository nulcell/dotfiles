-- Base markdownlint config; a project's own .markdownlint* still applies on top.
local mdl_config = vim.fn.stdpath("config") .. "/.markdownlint-cli2.yaml"

return {
  -- No latex parser/tools installed; stops the healthcheck warnings.
  { "MeanderingProgrammer/render-markdown.nvim", opts = { latex = { enabled = false } } },
  {
    "mfussenegger/nvim-lint",
    opts = { linters = { ["markdownlint-cli2"] = { args = { "--config", mdl_config, "-" } } } },
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters = { ["markdownlint-cli2"] = { prepend_args = { "--config", mdl_config } } } },
  },
}
