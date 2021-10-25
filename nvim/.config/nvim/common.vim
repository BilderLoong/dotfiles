"Automatic install vim-plug.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Key mapping	" Treat long lines as break lines
map j gj
map k gk

" Key Mapping
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

inoremap jk <Esc>

" Open my vimrc file.
nnoremap <Leader>vm :e $MYVIMRC<CR>
" source vimrc file.
nnoremap <Leader>r :source $MYVIMRC<CR>

Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
