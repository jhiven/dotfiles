return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_cmp()

			local cmp = require("cmp")
			local cmp_action = lsp_zero.cmp_action()

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				formatting = lsp_zero.cmp_format(),

				window = {
					documentation = cmp.config.window.bordered(),
					completion = cmp.config.window.bordered(),
				},

				preselect = "item",

				{ name = "path" },
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "luasnip", keyword_length = 2 },
				},

				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					-- ["<C-f>"] = cmp_action.luasnip_jump_forward(),
					-- ["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<Tab>"] = cmp_action.luasnip_supertab(),
					["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
				}),

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(_, bufnr)
				lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = true })
				local opts = { buffer = bufnr }

				opts.desc = "Code formatting"
				vim.keymap.set({ "n", "x" }, "<leader>cf", function()
					vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
				end, opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action)

				opts.desc = "Renames all references"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			end)

			lsp_zero.format_on_save({
				format_opts = {
					async = false,
					timeout_ms = 10000,
				},
				servers = {
					["dartls"] = { "dart" },
					["null-ls"] = {
						"javascript",
						"typescript",
						"typescriptreact",
						"javascriptreact",
						"python",
						"lua",
						"go",
						"json",
					},
				},
			})

			require("lspconfig").dartls.setup({
				cmd = { "dart", "language-server", "--protocol=lsp" },
			})

			require("mason-lspconfig").setup({
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						-- (Optional) Configure lua language server for neovim
						local lua_optss = lsp_zero.nvim_lua_ls()
						require("lspconfig").lua_ls.setup(lua_optss)
					end,
				},
			})
		end,
	},

	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("nvim-ts-autotag").setup()

			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					underline = true,
					virtual_text = {
						spacing = 5,
					},
					update_in_insert = true,
				})
		end,
	},

	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					y_padding = 1,
					winblend = 0,
				},
			},
		},
	},
}
