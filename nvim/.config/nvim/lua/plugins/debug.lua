return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<F21>", function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end, desc = "Conditional breakpoint (S-F9)" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step into" },
      { "<F23>", function() require("dap").step_out() end, desc = "Step out (S-F11)" },
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F17>", function() require("dap").terminate() end, desc = "Terminate (S-F5)" },
      { "<Leader>dp", function() require("dap.ui.widgets").preview() end, desc = "DAP Preview", silent = true },
      { "<Leader>dk", function() require("dap.ui.widgets").hover() end, desc = "DAP Hover", silent = true },
      { "<Leader>ds", function() require("dap").run_to_cursor() end, desc = "Run to cursor", silent = true },
      { "<Leader>du", function() require("dapui").toggle() end, desc = "Toggle Debugger UI" },
    },
    config = function()
      local dap = require "dap"

      -- nlua adapter for debugging Neovim Lua
      dap.adapters.nlua = function(callback, config)
        callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
    end,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dapui = require "dapui"
      dapui.setup(opts)

      local dap = require "dap"
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open {} end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close {} end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close {} end
    end,
  },
  { "theHamsta/nvim-dap-virtual-text", config = true },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      debugger_path = "/Users/birudo/Project/vscode-js-debug",
      adapters = {
        "pwa-node", "pwa-chrome", "pwa-msedge",
        "node-terminal", "pwa-extensionHost", "node", "chrome",
      },
    },
    config = function(_, opts)
      require("dap-vscode-js").setup(opts)

      for _, language in ipairs { "typescript", "javascript" } do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file in new node process (" .. language .. ")",
            program = "${file}",
            smartStep = true,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = { "mfussenegger/nvim-dap" },
    keys = {
      { "<Leader>osv", function() require("osv").launch { port = 8086 } end, desc = "Start neovim lua debug server" },
    },
  },
}
