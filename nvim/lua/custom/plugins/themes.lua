return {
  -- Nord Theme
  { 'shaunsingh/nord.nvim' },

  -- Catppuccin Theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },

  -- Rose Pine Theme (Default)
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    lazy = false,
    config = function()
      local function set_blink_cmp_highlights()
        local set_hl = vim.api.nvim_set_hl

        set_hl(0, 'BlinkCmpMenu', { fg = '#e0def4', bg = '#191724' })
        set_hl(0, 'BlinkCmpMenuBorder', { fg = '#31748f', bg = '#191724' })
        set_hl(0, 'BlinkCmpMenuSelection', { fg = '#e0def4', bg = '#403d52', bold = true })

        set_hl(0, 'BlinkCmpLabel', { fg = '#e0def4', bg = 'NONE' })
        set_hl(0, 'BlinkCmpLabelDeprecated', { fg = '#6e6a86', strikethrough = true })
        set_hl(0, 'BlinkCmpLabelMatch', { fg = '#ebbcba', bold = true })
        set_hl(0, 'BlinkCmpLabelDetail', { fg = '#908caa' })
        set_hl(0, 'BlinkCmpLabelDescription', { fg = '#908caa' })
        set_hl(0, 'BlinkCmpSource', { fg = '#6e6a86', italic = true })

        set_hl(0, 'BlinkCmpKind', { fg = '#9ccfd8' })
        set_hl(0, 'BlinkCmpKindText', { fg = '#e0def4' })
        set_hl(0, 'BlinkCmpKindMethod', { fg = '#c4a7e7' })
        set_hl(0, 'BlinkCmpKindFunction', { fg = '#c4a7e7' })
        set_hl(0, 'BlinkCmpKindConstructor', { fg = '#f6c177' })
        set_hl(0, 'BlinkCmpKindField', { fg = '#9ccfd8' })
        set_hl(0, 'BlinkCmpKindVariable', { fg = '#9ccfd8' })
        set_hl(0, 'BlinkCmpKindClass', { fg = '#f6c177' })
        set_hl(0, 'BlinkCmpKindInterface', { fg = '#f6c177' })
        set_hl(0, 'BlinkCmpKindModule', { fg = '#ebbcba' })
        set_hl(0, 'BlinkCmpKindProperty', { fg = '#9ccfd8' })
        set_hl(0, 'BlinkCmpKindUnit', { fg = '#eb6f92' })
        set_hl(0, 'BlinkCmpKindValue', { fg = '#eb6f92' })
        set_hl(0, 'BlinkCmpKindEnum', { fg = '#f6c177' })
        set_hl(0, 'BlinkCmpKindKeyword', { fg = '#ebbcba' })
        set_hl(0, 'BlinkCmpKindSnippet', { fg = '#ebbcba' })
        set_hl(0, 'BlinkCmpKindColor', { fg = '#eb6f92' })
        set_hl(0, 'BlinkCmpKindFile', { fg = '#9ccfd8' })
        set_hl(0, 'BlinkCmpKindReference', { fg = '#eb6f92' })
        set_hl(0, 'BlinkCmpKindFolder', { fg = '#9ccfd8' })
        set_hl(0, 'BlinkCmpKindEnumMember', { fg = '#eb6f92' })
        set_hl(0, 'BlinkCmpKindConstant', { fg = '#eb6f92' })
        set_hl(0, 'BlinkCmpKindStruct', { fg = '#f6c177' })
        set_hl(0, 'BlinkCmpKindEvent', { fg = '#f6c177' })
        set_hl(0, 'BlinkCmpKindOperator', { fg = '#ebbcba' })
        set_hl(0, 'BlinkCmpKindTypeParameter', { fg = '#f6c177' })

        set_hl(0, 'BlinkCmpGhostText', { fg = '#6e6a86', italic = true })
        set_hl(0, 'BlinkCmpDoc', { fg = '#e0def4', bg = '#191724' })
        set_hl(0, 'BlinkCmpDocBorder', { fg = '#31748f', bg = '#191724' })
        set_hl(0, 'BlinkCmpDocSeparator', { fg = '#403d52', bg = '#191724' })
        set_hl(0, 'BlinkCmpDocCursorLine', { bg = '#403d52' })
        set_hl(0, 'BlinkCmpSignatureHelp', { fg = '#e0def4', bg = '#191724' })
        set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = '#31748f', bg = '#191724' })
        set_hl(0, 'BlinkCmpSignatureHelpActiveParameter', { fg = '#f6c177', bold = true })
      end

      require('rose-pine').setup({
        variant = 'main',
        dark_variant = 'main',
      })
      vim.cmd.colorscheme 'rose-pine'
      set_blink_cmp_highlights()

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = set_blink_cmp_highlights,
      })
    end,
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

  -- Horizon Theme
  { 'lunarvim/horizon.nvim' },
}
