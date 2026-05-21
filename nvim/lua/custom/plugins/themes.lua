return {
  -- Nord Theme
  { 'shaunsingh/nord.nvim' },

  -- Catppuccin Theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },

  -- Tokyo Night Theme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
  },

  -- Everforest Theme
  {
    'sainnhe/everforest',
    priority = 1000,
  },

  -- Horizon Theme (Default)
  {
    'lunarvim/horizon.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme 'horizon'
    end,
  },

  -- Theme Switcher via Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      -- Kickstart adds Telescope config in init.lua, 
      -- here we just add a specific keymap for the switcher.
      vim.keymap.set('n', '<leader>st', function()
        require('telescope.builtin').colorscheme({ enable_preview = true })
      end, { desc = '[S]earch [T]heme (with preview)' })
    end,
  },
}
