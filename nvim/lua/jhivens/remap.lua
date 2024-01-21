vim.g.mapleader = ","

vim.keymap.set({ "n", "v" }, "<space>", ":", { noremap = true })
vim.keymap.set("i", "jj", "<esc>", { noremap = true })

vim.keymap.set("n", "<leader>b", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<esc>", ":noh<CR>", { noremap = true, silent = true })

vim.keymap.set("i", "<C-BS>", "<C-X><C-W>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<C-h>", "b", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-l>", "w", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { noremap = true })

vim.keymap.set("n", "gq", ":set wrap!<CR>", { noremap = true })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })     -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })     -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true }) -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true }) -- move line down(v)

vim.keymap.set("v", "Y", '"+y', { noremap = true })
vim.keymap.set("n", "YY", '"+yy', { noremap = true })
