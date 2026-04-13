
-- plugins
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim" },
})

require("catppuccin").setup({
	flavour = "mocha",
})
vim.cmd("colorscheme catppuccin")
vim.cmd.hi("statusline guibg=NONE")
vim.cmd.hi("Comment gui=none")
