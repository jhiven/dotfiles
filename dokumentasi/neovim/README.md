# Dokumentasi Neovim
## Setup Neovim

 1. Download packer melalui panduan di [sini](https://github.com/wbthomason/packer.nvim)
 2. Buka `nvim/lua/jhivens/packer.lua`, ketik `:so` kemudian `:PackerSync`
 3. Pergi ke `nvim/after/plugin/treesitter.lua`, ketik `:so`
 4. Download LSP dengan command `:Mason`

## Command-command Penting
1. Download LSP untuk eksetensi file yang sedang dibuka, `:LspInstall`
2. GUI LSP package manager, `:Mason`
3. Membuka file eksplorer bawaan neovim, `:Ex`

## Keyboard Shortcut
Leader: `,`

- `:` menjadi `space`
- `esc` menjadi `jj`
- `:NERDTreeFocus` menjadi `Leader` `b`
- `:NERDTreeToggle` menjadi `Ctrl` `b`
- `:UndotreeToggle` menjadi `Leader` `u`
- Membuka `Telescope` menjadi `Leader` `ff`
