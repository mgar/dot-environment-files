return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot", -- Lazy-load on Copilot command
    event = "InsertEnter", -- Load when entering Insert mode
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true, -- Automatically trigger suggestions as you type
          debounce = 100, -- Delay in milliseconds for suggestions
          keymap = {
            accept = "<C-l>", -- Keybinding to accept a suggestion
            next = "<C-j>", -- Keybinding to show next suggestion
            prev = "<C-k>", -- Keybinding to show previous suggestion
            dismiss = "<C-h>", -- Keybinding to dismiss the suggestion
          },
        },
        panel = {
          enabled = true,
          layout = {
            position = "bottom", -- Panel position: "top", "bottom", "left", "right"
            ratio = 0.4, -- Ratio of the panel size relative to the window
          },
          keymap = {
            jump_prev = "[[", -- Keybinding to jump to the previous panel section
            jump_next = "]]", -- Keybinding to jump to the next panel section
            accept = "<CR>", -- Keybinding to accept a panel suggestion
            refresh = "gr", -- Keybinding to refresh the panel
            open = "<C-o>", -- Keybinding to open the Copilot panel
          },
        },
        filetypes = {
          -- Enable Copilot for specific filetypes
          javascript = true,
          typescript = true,
          lua = true,
          python = true,
          c = true,
          cpp = true,
          java = true,
          markdown = true,
          terraform = true, -- Enable for Terraform files
          jenkinsfile = true, -- Enable for Jenkinsfiles
          -- Disable for specific filetypes
          ["*"] = false, -- Disable for all other filetypes by default
        },
        copilot_node_command = "node", -- Path to Node.js executable, if not in $PATH
        server_opts_overrides = {}, -- Override server options if needed
      })
    end,
  },
}
