return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		-- ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "html", "javascript", "css" },
		-- ignore_install = { "dart" },
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
			disable = { "dart" },
		},
		-- ensure_installed = {
		-- 	"html",
		-- 	"php",
		-- },
	},
	config = function(_, opts)
		vim.filetype.add({
			pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
		})

		vim.filetype.add({
			extension = {
				rasi = "rasi",
			},
		})

		-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		-- parser_config.blade = {
		-- 	install_info = {
		-- 		url = "https://github.com/EmranMR/tree-sitter-blade",
		-- 		files = { "src/parser.c" },
		-- 		branch = "main",
		-- 	},
		-- 	filetype = "blade",
		-- }
		--
		-- vim.filetype.add({
		-- 	pattern = {
		-- 		[".*%.blade%.php"] = "blade",
		-- 	},
		-- })

		require("nvim-treesitter.configs").setup(opts)
	end,
}
