return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sections = {
			lualine_c = { "filename", "harpoon2" },
		},
	},
	config = true,
}
