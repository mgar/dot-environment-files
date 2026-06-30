return {
  -- enhanced a/i text objects (multiline, next/last, treesitter functions/classes)
  "echasnovski/mini.ai",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  config = function()
    local ai = require("mini.ai")
    ai.setup({
      n_lines = 500,
      custom_textobjects = {
        -- function and class objects backed by treesitter queries
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      },
    })
  end,
}
