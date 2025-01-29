return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'catppuccin/nvim',
  },
  config = function()
    _G.__cached_neo_tree_selector = nil
    _G.__get_selector = function()
      return _G.__cached_neo_tree_selector
    end
    vim.opt.termguicolors = true
    local bufferline = require 'bufferline'
    bufferline.setup {
      highlights = require('catppuccin.groups.integrations.bufferline').get(),
      options = {
        offsets = {
          {
            filetype = 'neo-tree',
            raw = ' %{%v:lua.__get_selector()%} ',
            highlight = { sep = { link = 'WinSeparator' } },
            separator = '┃',
          },
        },
        mode = 'tabs',
        diagnostics = 'nvim_lsp',
        separator_style = 'slant',
      },
    }
    vim.keymap.set('n', '<A-n>', '<Cmd>BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<A-p>', '<Cmd>BufferLineCyclePrev<CR>')
  end,
}
