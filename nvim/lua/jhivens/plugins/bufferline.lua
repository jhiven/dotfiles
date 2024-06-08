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
        diagnostics = "nvim_lsp",
        separator_style = "slant",
      },
    })

    vim.keymap.set({ "n", "v" }, "<C-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<C-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>w", ":bdelete %<CR>", { noremap = true, silent = true })
  end,
}
