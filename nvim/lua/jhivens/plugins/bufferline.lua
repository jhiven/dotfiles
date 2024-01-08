return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    vim.opt.termguicolors = true
    require("bufferline").setup({
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "Nvim Tree",
            separator = true,
            text_align = "center",
          },
        },
        mode = "tabs",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
      },
    })
  end,
}
