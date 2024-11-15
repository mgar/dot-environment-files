return {
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local onedark = require("onedark")

      -- Set custom colors to match your current preferences (optional)
      onedark.setup({
        style = 'warm', -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'
      })

      -- Load the color scheme
      onedark.load()
    end,
  },
}
