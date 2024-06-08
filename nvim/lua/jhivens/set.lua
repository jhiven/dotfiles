vim.opt.number = true
vim.opt.cursorline = true

vim.opt.ignorecase = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = "/home/jhivens/.config/.undodir"
vim.opt.undofile = true

vim.o.encoding = "UTF-8"

-- vim.opt.clipboard = "unnamedplus"

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.opt.scrolloff = 10

-- save folds on save
vim.cmd("augroup remember_folds")
vim.cmd("autocmd!")
vim.cmd("autocmd BufWinLeave ?* silent! mkview")
vim.cmd("autocmd BufWinEnter ?* silent! loadview")
vim.cmd("augroup END")

vim.opt.modifiable = true

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.g.user.event,
	callback = function(args)
		local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line("$")
		local not_commit = vim.b[args.buf].filetype ~= "commit"

		if valid_line and not_commit then
			vim.cmd([[normal! g`"]])
		end
	end,
})
