local header = {
  " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
}

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = header
      dashboard.section.header.opts.hl = "Type"
      dashboard.section.buttons.val = {
        dashboard.button("f", "󰱼  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("g", "󰺮  Live grep", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", "󰄉  Recent files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("s", "󰁯  Restore session", "<cmd>lua require('persistence').load()<CR>"),
        dashboard.button("q", "󰅚  Quit", "<cmd>qa<CR>"),
      }
      dashboard.section.footer.val = "Enjoy your editing"

      alpha.setup(dashboard.config)
      if vim.fn.argc() == 0 then
        alpha.start(false, dashboard.config)
      end
    end,
  },
}
