return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  lazy = false,
  config = function()
    require('catppuccin').setup {
      background = {
        dark = 'mocha',
      },
      integrations = {
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        fidget = true,
        -- blink_cmp = true,
        neotree = true,
      },
    }
    vim.cmd.colorscheme 'catppuccin'
    vim.cmd.hi 'Comment gui=none'
  end,
}
