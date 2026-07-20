return {
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
      "fredrikaverpil/neotest-golang",
      "hoxbro/neotest-rust",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-jest")({}),
          require("neotest-vitest")({}),
          require("neotest-python")({ runner = "pytest" }),
          require("neotest-golang")({}),
          require("neotest-rust")({ dap_adapter = "codelldb" }),
        },
      })
    end,
  },
}
