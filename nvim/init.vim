" NEOVIM CONFIGURATION ---------------------------------------------------------------

"  autocmd VimEnter * NERDTree
set number relativenumber
syntax on
set cursorline
set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
filetype plugin on
set autochdir
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let b:ale_fixers = {'javascript': ['prettier', 'eslint']}


" MAPPINGS --------------------------------------------------------------------

" Set the backslash as the leader key.
let mapleader = ","
" Type jj to exit insert mode quickly.
inoremap jj <Esc>
vnoremap mm <Esc>
" Press the space bar to type the : character in command mode.
nnoremap <space> :
nnoremap <silent> <C-p> :Files<CR>
inoremap <silent> <C-p> <Esc>:Files<CR>
" Refresh Neovim Configuration File
nnoremap <silent> <leader>r :so %<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
inoremap <C-BS> <C-o>db
inoremap <C-CR> <C-o>o
inoremap <C-S-l> <C-o>v
inoremap <C-S-h> <C-o>v
inoremap <C-S-k> <C-o><S-v>
inoremap <C-S-j> <C-o><S-v>
nnoremap <M-o> o<esc>
nnoremap <M-O> O<esc>
"ToggleTerm Keymapping
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><C-`> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <silent><C-`> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><C-`> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>


" COC Configuration------------------------------------------------------------

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <cr> coc#pum#visible() && coc#pum#info()['index'] != -1 ? coc#pum#confirm() : "\<C-g>u\<CR>"

 
" PLUGIN ---------------------------------------------------------------------
call plug#begin()
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'nvim-treesitter/nvim-treesitter',
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'mxw/vim-jsx'
Plug 'airblade/vim-gitgutter'
Plug 'RRethy/vim-illuminate'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'farmergreg/vim-lastplace'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'mxw/vim-jsx'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
call plug#end()

lua require("toggleterm").setup()
lua require("treesitter")
 
colorscheme catppuccin-mocha
