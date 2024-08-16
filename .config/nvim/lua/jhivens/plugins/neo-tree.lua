return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<C-b>",
			function()
				require("neo-tree.command").execute({
					toggle = true,
					position = "left",
				})
			end,
			desc = "Neotree Toggle",
		},
		{
			"<leader>b",
			function()
				require("neo-tree.command").execute({
					action = "focus",
				})
			end,
			desc = "Neotree focus",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("RemoteFileInit", { clear = true }),
			callback = function()
				local f = vim.fn.expand("%:p")
				for _, v in ipairs({ "dav", "fetch", "ftp", "http", "rcp", "rsync", "scp", "sftp" }) do
					local p = v .. "://"
					if f:sub(1, #p) == p then
						vim.cmd([[
              unlet g:loaded_netrw
              unlet g:loaded_netrwPlugin
              runtime! plugin/netrwPlugin.vim
              silent Explore %
            ]])
						break
					end
				end
				vim.api.nvim_clear_autocmds({ group = "RemoteFileInit" })
			end,
		})
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
			callback = function()
				local f = vim.fn.expand("%:p")
				if vim.fn.isdirectory(f) ~= 0 then
					vim.cmd("Neotree current dir=" .. f)
					vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
				end
			end,
		})
		-- keymaps
	end,
	opts = {
		popup_border_style = "rounded",
		hide_root_node = true,
		retain_hidden_root_indent = true,
		filesystem = {
			hijack_netrw_behavior = "open_current",
			filtered_items = {
				show_hidden_count = false,
				never_show = {
					".DS_Store",
				},
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
			},
		},
		event_handlers = {
			{
				event = "after_render",
				handler = function(state)
					if state.current_position == "left" or state.current_position == "right" then
						vim.api.nvim_win_call(state.winid, function()
							local str = require("neo-tree.ui.selector").get()
							if str then
								_G.__cached_neo_tree_selector = str
							end
						end)
					end
				end,
			},
		},
		window = {
			mappings = {
				["h"] = function(state)
					local node = state.tree:get_node()
					if node.type == "directory" and node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					else
						require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
					end
				end,
				["l"] = function(state)
					local node = state.tree:get_node()
					if node.type == "directory" then
						if not node:is_expanded() then
							require("neo-tree.sources.filesystem").toggle_directory(state, node)
						elseif node:has_children() then
							require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
						end
					end
				end,
			},
		},
		source_selector = {
			winbar = false,
			statusline = false,
		},
	},
}
