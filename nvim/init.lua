if vim.g.vscode then
	-- VSCode extension

	vim.keymap.set("n", "<esc>", ":noh<CR>", { noremap = true, silent = true })
	vim.keymap.set("v", "Y", '"+y', { noremap = true })
	vim.keymap.set("n", "YY", '"+yy', { noremap = true })

	vim.keymap.set("n", "q:", "<Nop>", { noremap = true, silent = true })
	vim.keymap.set("n", "q/", "<Nop>", { noremap = true, silent = true })

	vim.opt.ignorecase = true
else
	-- ordinary Neovim
	require("jhivens")
end
