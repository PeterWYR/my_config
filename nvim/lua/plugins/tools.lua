return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerBuild",
      "OverseerClearCache",
      "OverseerClose",
      "OverseerDeleteBundle",
      "OverseerInfo",
      "OverseerLoadBundle",
      "OverseerOpen",
      "OverseerQuickAction",
      "OverseerRun",
      "OverseerRunCmd",
      "OverseerSaveBundle",
      "OverseerTaskAction",
      "OverseerToggle",
    },
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = {
      "TermExec",
      "TermNew",
      "TermSelect",
      "ToggleTerm",
      "ToggleTermToggleAll",
    },
    opts = {
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    cond = function()
      return vim.fn.executable("lazygit") == 1
    end,
  },
}
