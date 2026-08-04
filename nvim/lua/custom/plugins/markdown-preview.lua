-- Markdown Preview in Browser (iamcco/markdown-preview.nvim)
-- Live preview with synchronized scrolling, supports Mermaid, KaTeX, etc.
--
-- Build step: after install/update, run `npx --yes yarn install` in the `app` directory.
-- This is handled by the PackChanged autocommand in init.lua.

local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'iamcco/markdown-preview.nvim' }

-- Settings
vim.g.mkdp_auto_close = 1 -- Auto close preview when switching buffer
vim.g.mkdp_refresh_slow = 0 -- Real-time refresh
vim.g.mkdp_open_to_the_world = 0 -- Only listen on localhost
vim.g.mkdp_filetypes = { 'markdown' }

-- Keymaps
vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', { desc = '[M]arkdown [P]review (browser)' })
