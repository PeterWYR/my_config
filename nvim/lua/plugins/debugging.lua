local languages = require("config.languages")

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    cmd = {
      "DapContinue",
      "DapDisconnect",
      "DapEval",
      "DapNew",
      "DapPause",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        module = false,
        dependencies = { "mason-org/mason.nvim" },
        opts = {
          ensure_installed = languages.dap_adapters(),
          automatic_installation = false,
          handlers = {},
        },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dap.listeners.before.attach.workflow_dapui = function()
        dapui.open()
      end
      dap.listeners.before.launch.workflow_dapui = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.workflow_dapui = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.workflow_dapui = function()
        dapui.close()
      end
    end,
  },
}
