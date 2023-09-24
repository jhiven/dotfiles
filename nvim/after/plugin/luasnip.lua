local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_format = require('lsp-zero').cmp_format()

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
    formatting = cmp_format,

    sources = {
        {name = 'luasnip'},
        {name = 'nvim_lsp'},
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({select = false}),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),

    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})
