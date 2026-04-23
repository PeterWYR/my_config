return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = opts.picker.sources.explorer or {}
      opts.picker.sources.explorer.win = opts.picker.sources.explorer.win or {}
      opts.picker.sources.explorer.win.list = opts.picker.sources.explorer.win.list or {}
      opts.picker.sources.explorer.win.list.keys = opts.picker.sources.explorer.win.list.keys or {}

      local keys = opts.picker.sources.explorer.win.list.keys
      keys["k"] = "list_up"
      keys["h"] = "explorer_close"
      keys["j"] = "list_down"
      keys["l"] = "confirm"
    end,
  },
}
