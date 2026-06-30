return {
  -- jump anywhere on screen with labels; also enhances f/t/search
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- NOTE: `s`/`S` are intentionally left to substitute.nvim, so flash jump
  -- lives under <leader>j / <leader>J instead of the usual `s`.
  keys = {
    {
      "<leader>j",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash jump",
    },
    {
      "<leader>J",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter select",
    },
  },
}
