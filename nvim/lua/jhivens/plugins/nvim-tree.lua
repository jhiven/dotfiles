return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    diagnostics = {
      enable = true,
      show_on_dirs = true,
    },
  },
}
