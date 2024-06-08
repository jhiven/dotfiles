return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(client, bufnr)
			lsp_zero.default_keymaps({ buffer = bufnr })
		end)

		require("flutter-tools").setup({
			debugger = {
				enabled = true,
				run_via_dap = true,
			},
			dev_log = {
				enabled = true,
				open_cmd = "edit", -- command to use to open the log buffer
			},
			lsp = {
				capabilities = lsp_zero.get_capabilities(),
			},
		})
	end,
}
