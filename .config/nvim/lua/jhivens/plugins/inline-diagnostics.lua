return {
  'rachartier/tiny-inline-diagnostic.nvim',
  event = 'LspAttach',
  priority = 1000,
  init = function()
    vim.diagnostic.config {
      virtual_text = false,
      float = { border = 'rounded' },
    }
  end,
  opts = {
    options = {
      multilines = {
        enabled = true,
        always_show = true,
      },
      overflow = {
        mode = 'wrap',
      },
    },
  },
}
