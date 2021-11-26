"Automatic install vim-plug.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Helper function for contional load plug-ins
" source: https://github.com/junegunn/vim-plug/wiki/tips#conditional-activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Plugin Selection
call plug#begin('~/.vim/plugged')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Common plugs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'unblevable/quick-scope'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VSCode plugs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Neovim plugs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))

" nord
Plug 'arcticicestudio/nord-vim', Cond(!exists('g:vscode'))

Plug 'morhetz/gruvbox', Cond(!exists('g:vscode'))

Plug 'tpope/vim-surround', Cond(!exists('g:vscode'))
Plug 'wsdjeg/luarefvim', Cond(!exists('g:vscode'))
Plug 'milisims/nvim-luaref', Cond(!exists('g:vscode'))

" Airline
Plug 'vim-airline/vim-airline', Cond(!exists('g:vscode'))
Plug 'vim-airline/vim-airline-themes', Cond(!exists('g:vscode'))
" CoC
Plug 'neoclide/coc.nvim', Cond(!exists('g:vscode'), {'branch': 'release'})

" Emmet
Plug 'mattn/emmet-vim', Cond(!exists('g:vscode'))

Plug 'tpope/vim-commentary', Cond(!exists('g:vscode'))

" fzf
Plug 'junegunn/fzf',  Cond(!exists('g:vscode'),{ 'do': { -> fzf#install() } })
Plug 'junegunn/fzf.vim', Cond(!exists('g:vscode'))

Plug 'jiangmiao/auto-pairs', Cond(!exists('g:vscode'))
Plug '907th/vim-auto-save', Cond(!exists('g:vscode'))

" NERDtree
Plug 'preservim/nerdtree', Cond(!exists('g:vscode'))

Plug 'Xuyuanp/nerdtree-git-plugin', Cond(!exists('g:vscode'))
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" If you need Vim help for vim-plug itself (e.g. :help plug-options), register vim-plug as a plugin.
Plug 'junegunn/vim-plug', Cond(!exists('g:vscode'))

" Lua
Plug 'folke/lua-dev.nvim', Cond(!exists('g:vscode'))

" For better spellchecking.
Plug 'kamykn/spelunker.vim', Cond(!exists('g:vscode'))

" Vim git
" Plug "tpope/vim-fugitive"
call plug#end() 
