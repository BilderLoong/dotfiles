"Automatic install vim-plug.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Key mapping	" Treat long lines as break lines
map j gj
map k gk

let mapleader = "\<Space>"

" Unbind C-c key
inoremap <C-c> <Nop>

nnoremap <Leader>j J
nnoremap J 5j
nnoremap K 5k
nnoremap <Leader>o o<Esc>

nnoremap <Leader>y "*y
xnoremap <Leader>y "*y

nnoremap <Leader>p "*p
xnoremap <Leader>p "*p

noremap! jk <C-c>

nnoremap <Leader>s <Cmd>w <Bar> source % <CR>

" Open the director that contains vimrc file.
nnoremap <Leader>vm <Cmd>NERDTreeToggle $MYVIMRC<CR>

" source vimrc file.
nnoremap <Leader>r :source $MYVIMRC<CR>

" CDC = Change to Directory of Current file, 
" source: https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file#Mapping_or_command_for_quick_directory_change
command CDC cd %:p:h

Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'wsdjeg/luarefvim'

Plug 'milisims/nvim-luaref'
