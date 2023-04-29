require'nvim-treesitter.configs'.setup {
    ensure_installed = { "javascript", "html", "css", "vim", "lua"},
    sync_install = false,
    autisadio_install = true,
    highlight = {
	enable = true
    }
}
