vim.keymap.set("i", "jj", "<esc>", { noremap = true })

vim.keymap.set("n", "<esc>", ":noh<CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { noremap = true })

vim.keymap.set("n", "gz", ":set wrap!<CR>", { noremap = true })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true }) -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true }) -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- move line down(v)

vim.keymap.set("v", "Y", '"+y', { noremap = true })
vim.keymap.set("n", "YY", '"+yy', { noremap = true })

vim.keymap.set("n", "q:", "<Nop>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
