-- nvim-treesitter-textobjects `main` branch. Provides the textobjects query
-- files (used by mini.ai for af/if/ac/ic selection) and the move module used
-- for the ]f/[f style motions below. Selection keymaps are intentionally left
-- to mini.ai to avoid duplicate mappings.
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      move = { set_jumps = true }, -- add motions to the jumplist
    })

    local move = require("nvim-treesitter-textobjects.move")
    local motions = {
      ["]f"] = { fn = move.goto_next_start, q = "@function.outer", desc = "Next function start" },
      ["[f"] = { fn = move.goto_previous_start, q = "@function.outer", desc = "Previous function start" },
      ["]c"] = { fn = move.goto_next_start, q = "@class.outer", desc = "Next class start" },
      ["[c"] = { fn = move.goto_previous_start, q = "@class.outer", desc = "Previous class start" },
      ["]a"] = { fn = move.goto_next_start, q = "@parameter.inner", desc = "Next parameter" },
      ["[a"] = { fn = move.goto_previous_start, q = "@parameter.inner", desc = "Previous parameter" },
    }
    for lhs, m in pairs(motions) do
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        m.fn(m.q, "textobjects")
      end, { desc = m.desc })
    end
  end,
}
