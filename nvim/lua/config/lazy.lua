local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { output, "WarningMsg" },
    }, true, {})
    os.exit(1)
  end
end

vim.opt.runtimepath:prepend(lazypath)

local plugins_path = vim.fn.stdpath("config") .. "/lua/plugins"
local plugins_import = vim.uv.fs_stat(plugins_path) and "plugins" or function()
  return {}
end

require("lazy").setup({
  spec = {
    { name = "plugins", import = plugins_import },
  },
  install = { colorscheme = { "rose-pine", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
