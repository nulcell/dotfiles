return {
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-macchiato" } },
  -- LazyVim lists integrations explicitly; auto-detection calls vim.pack.get(),
  -- which creates an empty site/pack/core that lazy's healthcheck warns about.
  { "catppuccin/nvim", name = "catppuccin", opts = { auto_integrations = false } },
}
