
-- plugins
vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
})

require("tokyonight").setup({
	style = "night", -- "storm", "moon", "night" or "day"
	light_style = "day", -- "day" or "moon"
	transparent = false, -- Enable this to disable setting the background color
	terminal_colors = true, -- Configure the colors used when opening a :terminal in [Neovim](https://github.com/neovim/neovim)
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		-- Background styles. Can be "dark", "transparent" or "normal"
		sidebars = "dark", -- style for sidebars, see below
		floats = "dark", -- style for floating windows
	},
})

vim.cmd("colorscheme tokyonight")
