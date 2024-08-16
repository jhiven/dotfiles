return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		require("catppuccin").setup({
			background = {
				dark = "mocha",
			},
			integration = {
				indent_blankline = {
					enabled = true,
					scope_color = "mocha",
					colored_indent_levels = false,
				},
				fidget = true,
				neotree = true,
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
