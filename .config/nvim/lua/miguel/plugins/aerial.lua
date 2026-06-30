return {
  -- code outline / symbol navigation
  "stevearc/aerial.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    on_attach = function(bufnr)
      vim.keymap.set("n", "[s", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Previous symbol" })
      vim.keymap.set("n", "]s", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
    end,
  },
  keys = {
    { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle symbol outline" },
  },
}
