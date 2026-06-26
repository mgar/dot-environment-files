return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    -- toggle a terminal with <C-\> from normal or terminal mode
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
      border = "curved",
    },
    -- when the terminal is open, start in insert mode
    start_in_insert = true,
    -- map <Esc> / jk to leave terminal mode inside toggleterm windows
    on_open = function(term)
      local opts = { buffer = term.bufnr, silent = true }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    end,
  },
}
