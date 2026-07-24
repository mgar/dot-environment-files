return {
  "folke/snacks.nvim",
  lazy = true,
  -- Added only as a dependency for claudecode.nvim's split terminal + picker.
  -- No feature modules enabled, so it won't touch alpha (dashboard),
  -- indent-blankline, or fidget (notifications) — snacks modules are opt-in.
  opts = {},
}
