-- jk/kj for escape in insert mode
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('i', 'kj', '<Esc>', { noremap = true, silent = true })

-- n for line start (instead of 0)
vim.keymap.set('n', 'n', '0', { noremap = true, silent = true })

-- m for line end (instead of $)
vim.keymap.set('n', 'm', '$', { noremap = true, silent = true })
