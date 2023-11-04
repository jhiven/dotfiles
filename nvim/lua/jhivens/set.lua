vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = "/home/jhivens/.config/nvim/.undodir"
vim.opt.undofile = true

vim.o.encoding = "UTF-8"

vim.opt.clipboard = "unnamedplus"

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- save folds on save
vim.cmd('augroup remember_folds')
vim.cmd('autocmd!')
vim.cmd('autocmd BufWinLeave * mkview')
vim.cmd('autocmd BufWinEnter * silent! loadview')
vim.cmd('augroup END')

-- format on save
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]

vim.opt.modifiable = true
