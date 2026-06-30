return {
  "saghen/blink.cmp",
  -- stay on the stable v1 line (v2 has breaking changes still in flux)
  version = "1.*",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = {
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
    },
    "folke/lazydev.nvim",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    snippets = { preset = "luasnip" },
    -- function signature hints while typing call arguments.
    -- treesitter_highlighting disabled: blink v1's highlighter is incompatible
    -- with Neovim 0.12's treesitter iterator and throws a nil-node error.
    signature = { enabled = true, window = { treesitter_highlighting = false } },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200, treesitter_highlighting = false },
      ghost_text = { enabled = true },
      -- auto-insert () for functions/methods on accept
      accept = { auto_brackets = { enabled = true } },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
      },
    },
    -- Rust fuzzy matcher (prebuilt binary downloaded for tagged releases);
    -- falls back to the Lua implementation with a warning if unavailable
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}
