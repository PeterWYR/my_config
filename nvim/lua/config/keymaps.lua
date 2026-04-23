-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "
local map = vim.keymap.set

-- Use s to enter insert mode and replace the default substitute behavior.
map("n", "s", "i", { desc = "Enter insert mode" })

map("n", "<C-c>p", "mzYP`z", { desc = "Duplicate line below (keep cursor)" })
map("n", "<C-c>P", "mzYp`z", { desc = "Duplicate line above (keep cursor)" })

map({ "n", "v" }, "n", "0", { desc = "Go to beginning of line" })

map({ "n", "v" }, "m", "$", { desc = "Go to end of line" })

map({ "n", "v" }, "t", "%", { desc = "Jump between matching brackets" })

map("n", "=", "nzz", { desc = "Next search result and center" })

map("n", "-", "Nzz", { desc = "Prev search result and center" })

map("n", "<leader><CR>", "<cmd>noh<cr>", { desc = "Clear search highlights" })

-- Window movement with hjkl.
map("n", "<C-w>k", "<C-w>k", { desc = "Go to window above" })
map("n", "<C-w>h", "<C-w>h", { desc = "Go to window left" })
map("n", "<C-w>j", "<C-w>j", { desc = "Go to window below" })
map("n", "<C-w>l", "<C-w>l", { desc = "Go to window right" })

-- Split windows with leader + w + hjkl.
map("n", "<leader>wk", "<cmd>aboveleft split<cr>", { desc = "Split window above" })
map("n", "<leader>wh", "<cmd>aboveleft vsplit<cr>", { desc = "Split window left" })
map("n", "<leader>wj", "<cmd>belowright split<cr>", { desc = "Split window below" })
map("n", "<leader>wl", "<cmd>belowright vsplit<cr>", { desc = "Split window right" })

-- Resize windows with leader + r + hjkl.
map("n", "<leader>rk", "<cmd>resize +5<cr>", { desc = "Increase window height" })
map("n", "<leader>rh", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })
map("n", "<leader>rj", "<cmd>resize -5<cr>", { desc = "Decrease window height" })
map("n", "<leader>rl", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
