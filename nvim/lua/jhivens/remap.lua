vim.g.mapleader = ","

vim.keymap.set('n', '<space>', ':', { noremap = true })
vim.keymap.set('i', 'jj', '<esc>', { noremap = true })

-- NERDTree Keymaps
vim.keymap.set('n', '<leader>b', ':NERDTreeFocus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<esc>', ':noh<CR>', {noremap = true, silent = true})

vim.opt.clipboard = "unnamedplus"
