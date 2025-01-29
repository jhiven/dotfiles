require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  require 'jhivens/plugins/gitsigns',
  require 'jhivens/plugins/telescope',
  require 'jhivens/plugins/lspconfig',
  require 'jhivens/plugins/conform',
  require 'jhivens/plugins/cmp',
  require 'jhivens/plugins/catppuccin',
  require 'jhivens/plugins/lualine',
  require 'jhivens/plugins/bufferline',
  require 'jhivens/plugins/tmux',
  require 'jhivens/plugins/copilot',
  require 'jhivens/plugins/comments',
  require 'jhivens/plugins/mini',
  require 'jhivens/plugins/treesitter',
  require 'jhivens/plugins/autotag',
  require 'jhivens/plugins/inline-diagnostics',
  require 'jhivens/plugins/trouble',

  -- require 'jhivens.plugins.debug',
  require 'jhivens.plugins.indent_line',
  require 'jhivens.plugins.lint',
  require 'jhivens.plugins.autopairs',
  require 'jhivens.plugins.neo-tree',
}, {
  ui = {
    border = 'rounded',
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
