return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    lazy = false,
    config = function()
      require('rose-pine').setup({
        variant = 'main',
        dark_variant = 'main',
      })

      vim.cmd.colorscheme 'rose-pine'
      require('custom.highlights.blink').setup()
    end,
  },
}
