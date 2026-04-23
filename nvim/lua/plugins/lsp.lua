return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = opts.servers["*"] and opts.servers["*"].keys
      if not keys then
        return
      end

      for i = #keys, 1, -1 do
        if keys[i][1] == "K" then
          table.remove(keys, i)
        end
      end
    end,
  },
}
