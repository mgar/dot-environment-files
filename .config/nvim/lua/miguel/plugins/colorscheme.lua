return {
  {
    "catppuccin/nvim",
    name = "catppuccin", -- Ensures compatibility with lazy.nvim
    priority = 1000, -- Make sure it loads before other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- Choose your preferred flavour: latte, frappe, macchiato, mocha
        transparent_background = false, -- Set to true if you want a transparent background
        term_colors = false, -- Use terminal colors
        integrations = {
          treesitter = true, -- Enable Treesitter integration
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          cmp = true, -- Integrate with nvim-cmp
          gitsigns = true, -- Enable Git signs
          nvimtree = true, -- Enable for nvim-tree
          telescope = true, -- Enable Telescope styling
          which_key = true, -- Integrate with which-key
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          dashboard = true, -- Enable for dashboard-nvim
          markdown = true, -- Enable Markdown styling
        },
      })

      -- Load the colorscheme
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}

