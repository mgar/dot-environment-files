return {
  -- faster Lua LSP setup for Neovim config + plugin development
  -- (modern replacement for the now-archived neodev.nvim)
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- load luvit (vim.uv) types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
