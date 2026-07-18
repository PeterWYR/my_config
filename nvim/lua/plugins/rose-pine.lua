-- lua/plugins/rose-pine.lua
return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			styles = { italic = false },
			highlight_groups = {
				["@type"] = { fg = "pine" },
				["@type.builtin"] = { fg = "pine", bold = false },
				["@keyword.directive"] = { fg = "pine" },
				["@keyword.directive.define"] = { fg = "pine" },
				["@keyword.import"] = { fg = "pine" },
			},
		})
		vim.cmd("colorscheme rose-pine")
	end
}
