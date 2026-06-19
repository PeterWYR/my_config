return {
  -- ── Browser Live Preview ──────────────────────────────────────────────
  -- Opens a browser tab with beautifully rendered Markdown, live-synced
  -- with your edits and scroll position.
  --   <leader>mp  → toggle browser preview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      -- Install the mini-server that powers the browser preview
      require('lazy').load { plugins = { 'markdown-preview.nvim' } }
      vim.fn['mkdp#util#install']()
    end,
    init = function()
      -- ── Appearance ──
      -- Use a dark theme for the preview page
      vim.g.mkdp_theme = 'dark'
      -- Auto-scroll the preview to match cursor position
      vim.g.mkdp_preview_options = {
        sync_scroll_type = 'middle',
      }
      -- Open preview in a new browser tab (not a new window)
      vim.g.mkdp_open_to_the_world = 0
      -- Refresh on save only (lighter on resources) – set to 0 for live
      vim.g.mkdp_refresh_slow = 0
      -- Do NOT auto-close the preview when switching buffers
      vim.g.mkdp_auto_close = 0

      -- ── Keymap ──
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', {
            buffer = true,
            desc = '[M]arkdown browser [P]review',
          })
        end,
      })
    end,
  },

  -- ── In-Editor Rendering ───────────────────────────────────────────────
  -- Renders Markdown directly inside the Neovim buffer using Treesitter
  -- highlights, concealed characters, and pretty icons.
  --   <leader>mr  → toggle in-buffer rendering
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- Start with rendering enabled when opening Markdown files
      enabled = true,

      -- Keep rendered view even at cursor position (don't reveal raw markdown)
      anti_conceal = { enabled = false },

      -- ── Headings ──
      heading = {
        enabled = true,
        -- Render full-width background highlight for headings
        width = 'full',
        -- Icons prepended to each heading level
        icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
      },

      -- ── Code blocks ──
      code = {
        enabled = true,
        -- Show language label on fenced code blocks
        sign = true,
        width = 'full',
        -- Render a border around code blocks
        border = 'thin',
      },

      -- ── Bullet lists ──
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇' },
      },

      -- ── Checkboxes ──
      checkbox = {
        enabled = true,
        unchecked = { icon = '󰄱 ' },
        checked = { icon = '󰄵 ' },
      },

      -- ── Tables ──
      pipe_table = {
        enabled = true,
        style = 'full',
      },

      -- ── Links ──
      link = {
        enabled = true,
        hyperlink = '󰌹 ',
        image = '󰥶 ',
      },

      -- ── Horizontal rules ──
      dash = {
        enabled = true,
        icon = '─',
        width = 'full',
      },

      -- ── Block quotes ──
      quote = {
        enabled = true,
        icon = '▎',
      },
    },
    config = function(_, opts)
      require('render-markdown').setup(opts)

      -- Toggle keymap
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<CR>', {
            buffer = true,
            desc = '[M]arkdown in-editor [R]ender toggle',
          })
        end,
      })
    end,
  },
}
