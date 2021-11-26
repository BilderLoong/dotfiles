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
" VSCode plugs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'asvetliakov/vim-easymotion'
" , Cond(exists('g:vscode'))

" Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))

" nord
Plug 'arcticicestudio/nord-vim'

Plug 'morhetz/gruvbox'

Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'wsdjeg/luarefvim'
Plug 'milisims/nvim-luaref'

" Airline
Plug 'vim-airline/vim-airline'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Emmet
Plug 'mattn/emmet-vim'

Plug 'tpope/vim-commentary'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'
Plug '907th/vim-auto-save'

" NERDtree
Plug 'preservim/nerdtree'

Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" If you need Vim help for vim-plug itself (e.g. :help plug-options), register vim-plug as a plugin.
Plug 'junegunn/vim-plug'

" Lua
Plug 'folke/lua-dev.nvim'

" For better spellchecking.
Plug 'kamykn/spelunker.vim'

" Vim git
" Plug "tpope/vim-fugitive"
call plug#end() 
