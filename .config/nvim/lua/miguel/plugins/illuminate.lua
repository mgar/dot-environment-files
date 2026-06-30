return {
  -- highlight other references of the word under the cursor
  "RRethy/vim-illuminate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("illuminate").configure({
      -- "treesitter" provider omitted: it relies on nvim-treesitter's locals
      -- module which is broken on Neovim 0.11+ (Query:iter_matches now returns
      -- a list of nodes per capture). lsp + regex cover reference highlighting.
      providers = { "lsp", "regex" },
      delay = 120,
    })
  end,
}
