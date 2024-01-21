return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  opts = {
    debugger = {
      enabled = true,
      run_via_dap = true,
    },
    dev_log = {
      enabled = true,
      open_cmd = "edit", -- command to use to open the log buffer
    },
  },
}
