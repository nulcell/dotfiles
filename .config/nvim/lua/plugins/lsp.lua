return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- basedpyright's default "recommended" mode is far noisier than pylance.
        basedpyright = { settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } } },
        -- ruff formats Python via LSP; a project pyproject.toml/ruff.toml still wins.
        ruff = { init_options = { settings = { lineLength = 120 } } },
        -- Plain gofmt style if gopls ever formats (LSP fallback), same as conform below.
        gopls = { settings = { gopls = { gofumpt = false } } },
        yamlls = {
          settings = {
            yaml = {
              -- Bundled k8s schema, scoped to manifest-shaped paths only.
              schemas = {
                kubernetes = {
                  "k8s/**/*.{yml,yaml}",
                  "kube/**/*.{yml,yaml}",
                  "kubernetes/**/*.{yml,yaml}",
                  "manifests/**/*.{yml,yaml}",
                  "deploy/**/*.{yml,yaml}",
                  "*.k8s.{yml,yaml}",
                },
              },
            },
          },
        },
      },
    },
  },
  -- mypy is what CI runs; overlaps basedpyright, drop if too noisy.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft.python = { "mypy" }
      -- golangci-lint must run from the go.mod dir; nvim's cwd may be a monorepo root.
      opts.linters.golangcilint = function()
        local base = require("lint.linters.golangcilint")
        local file = vim.api.nvim_buf_get_name(0)
        local root = vim.fs.root(file, "go.mod")
        if not root then
          return base
        end
        local args = vim.list_slice(base.args, 1, #base.args - 1)
        table.insert(args, vim.fn.fnamemodify(file, ":h"))
        return vim.tbl_extend("force", base, { cwd = root, args = args })
      end
    end,
  },
  { "mason-org/mason.nvim", opts = { ensure_installed = { "mypy" } } },
  {
    "stevearc/conform.nvim",
    opts = {
      -- goimports = gofmt + imports, matching golangci-lint's formatters; LazyVim adds stricter gofumpt.
      formatters_by_ft = { go = { "goimports" } },
      formatters = { prettier = { prepend_args = { "--print-width", "120" } } },
    },
  },
}
