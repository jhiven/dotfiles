if vim.g.vscode then
  -- NOTE: VSCode extension

  vim.keymap.set('n', '<esc>', ':noh<CR>', { noremap = true, silent = true })
  vim.keymap.set('v', 'Y', '"+y', { noremap = true })
  vim.keymap.set('n', 'YY', '"+yy', { noremap = true })

  vim.keymap.set('n', 'q:', '<Nop>', { noremap = true, silent = true })
  vim.keymap.set('n', 'q/', '<Nop>', { noremap = true, silent = true })

  vim.opt.ignorecase = true
else
  --  NOTE: Normal Neovim
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.g.have_nerd_font = true

  require 'options'
  require 'keymaps'
  require 'lazy-bootstrap'
  require 'lazy-plugins'
end
