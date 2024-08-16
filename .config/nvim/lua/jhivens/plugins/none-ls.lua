return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		require("none-ls.diagnostics.eslint_d")
		local lsp = require("lsp-zero")
		local null_ls = require("null-ls")
		local null_opts = lsp.build_options("null-ls", {})

		null_ls.setup({
			on_attach = function(client, bufnr)
				null_opts.on_attach(client, bufnr)
			end,
			sources = {
				-- lua
				null_ls.builtins.formatting.stylua,

				-- typescript, javascript, tsx, jsx
				null_ls.builtins.formatting.prettierd,

				-- bash
				-- null_ls.builtins.code_actions.shellcheck,

				-- python
				-- null_ls.builtins.formatting.isort,
				-- null_ls.builtins.formatting.black,

				-- php
				-- null_ls.builtins.formatting.phpcsfixer,

				-- Go
				null_ls.builtins.code_actions.gomodifytags,
				null_ls.builtins.code_actions.impl,
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.formatting.gofmt,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.golines,
			},
		})
	end,
}
