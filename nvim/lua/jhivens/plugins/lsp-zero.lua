return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      -- Here is where you configure the autocompletion settings.
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()

      -- And you can configure cmp even more, if you want to.
      local cmp = require("cmp")
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format(),

        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
        }),

        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = { "LspInfo", "LspInstall", "LspStart" },
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })
        local opts = { buffer = bufnr }

        opts.desc = "Code formatting"
        vim.keymap.set({ "n", "x" }, "<M-S-f>", function()
          vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        end, opts)

        opts.desc = "See available code actions"
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Go to declaration"
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Smart rename"
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Hover"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      end)

      require("mason-lspconfig").setup({
        -- ensure_installed = { "lua_ls", "pyright", "tsserver", "bashls", "black", "isort", "stylua", "shellcheck" },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })
    end,
  },
}
