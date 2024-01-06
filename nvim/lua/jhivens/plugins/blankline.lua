return
{
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require("ibl").setup {
      scope = {
        enabled = false
      },
    }
  end
}
