-- Render Markdown in Neovim buffer (MeanderingProgrammer/render-markdown.nvim)
-- Renders headings, code blocks, checkboxes, tables, etc. directly in the terminal.

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'MeanderingProgrammer/render-markdown.nvim' }

require('render-markdown').setup {
  -- Render in normal mode, disable in insert mode for editing
  render_modes = { 'n', 'c', 't' },
  -- Don't reveal raw markdown when cursor is on the line, only in insert mode
  anti_conceal = { enabled = false },
  heading = {
    enabled = true,
    sign = true,
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
  },
  code = {
    enabled = true,
    sign = true,
    style = 'full',
    width = 'block',
    min_width = 60,
  },
  checkbox = {
    enabled = true,
    unchecked = { icon = '󰄱 ' },
    checked = { icon = '󰱒 ' },
  },
  bullet = {
    enabled = true,
    icons = { '●', '○', '◆', '◇' },
  },
  pipe_table = {
    enabled = true,
    style = 'full',
  },
}

-- Toggle render-markdown on/off
vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<CR>', { desc = '[M]arkdown [R]ender toggle' })
