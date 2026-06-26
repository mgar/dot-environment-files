return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- install + auto-configure debug adapters via mason
    -- "python" -> debugpy, "js" -> js-debug-adapter
    require("mason-nvim-dap").setup({
      ensure_installed = { "python", "js" },
      automatic_installation = true,
      handlers = {
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    })

    -- mason-nvim-dap doesn't ship a config for js-debug-adapter, so wire the
    -- pwa-node adapter + js/ts launch configs manually (binary is on PATH via mason)
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "js-debug-adapter",
        args = { "${port}" },
      },
    }

    for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
      dap.configurations[lang] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end

    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    -- automatically open/close the debug UI around a session
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- gutter signs
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticWarn", linehl = "Visual", numhl = "" })

    -- keymaps (function keys for stepping, <leader>b for breakpoints to avoid
    -- clashing with the buffer-local <leader>d diagnostic mappings)
    local keymap = vim.keymap
    keymap.set("n", "<F5>", function()
      dap.continue()
    end, { desc = "Debug: Start/Continue" })
    keymap.set("n", "<F10>", function()
      dap.step_over()
    end, { desc = "Debug: Step Over" })
    keymap.set("n", "<F11>", function()
      dap.step_into()
    end, { desc = "Debug: Step Into" })
    keymap.set("n", "<F12>", function()
      dap.step_out()
    end, { desc = "Debug: Step Out" })
    keymap.set("n", "<F9>", function()
      dap.toggle_breakpoint()
    end, { desc = "Debug: Toggle Breakpoint" })
    keymap.set("n", "<F7>", function()
      dapui.toggle()
    end, { desc = "Debug: Toggle UI" })
    keymap.set("n", "<leader>b", function()
      dap.toggle_breakpoint()
    end, { desc = "Debug: Toggle Breakpoint" })
    keymap.set("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })
  end,
}
