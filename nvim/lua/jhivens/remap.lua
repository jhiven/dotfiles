vim.g.mapleader = ","

vim.keymap.set('n', '<space>', ':', { noremap = true })
vim.keymap.set('i', 'jj', '<esc>', { noremap = true })

vim.keymap.set('n', '<leader>b', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<esc>', ':noh<CR>', {noremap = true, silent = true})

vim.keymap.set('i', '<C-BS>', '<C-X><C-W>', {noremap = true, silent = true})

vim.keymap.set('n', '<C-l>', 'w', {noremap = true})
vim.keymap.set('n', '<C-l>', 'w', {noremap = true})
