"Automatic install vim-plug.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
		endif

" Editing
set ts=2
set sw=0
set number
set relativenumber
set scrolloff=4
set scrolloff=4
set autoindent
set ruler
set showcmd
set backup
set nowrap
set clipboard=unnamedplus
set fileformats+=mac

" Key Mapping
let mapleader = "\<Space>"

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

" Plugin Selection
call plug#begin('~/.vim/plugged')

" use vscode easymotion when in vscode mode
Plug 'asvetliakov/vim-easymotion'
    nmap s         <Plug>(easymotion-s2)
    xmap s         <Plug>(easymotion-s2)
    omap z         <Plug>(easymotion-s2)
    nmap <Leader>s <Plug>(easymotion-sn)
    xmap <Leader>s <Plug>(easymotion-sn)
    omap <Leader>z <Plug>(easymotion-sn)

nmap <Leader>a <Plug>(easymotion-jumptoanywhere)
xmap <Leader>a <Plug>(easymotion-jumptoanywhere)
omap <Leader>a <Plug>(easymotion-jumptoanywhere)

nmap <Leader>w <Plug>(easymotion-bd-w)
xmap <Leader>w <Plug>(easymotion-bd-w)
omap <Leader>w <Plug>(easymotion-bd-w)

nmap <Leader>e <Plug>(easymotion-bd-e)
xmap <Leader>e <Plug>(easymotion-bd-e)
omap <Leader>e <Plug>(easymotion-bd-e)

nmap <Leader>t <Plug>(easymotion-bd-t)
xmap <Leader>t <Plug>(easymotion-bd-t)
omap <Leader>t <Plug>(easymotion-bd-t)

"Plug 'unblevable/quick-scope'
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

Plug 'tpope/vim-surround'

Plug 'unblevable/quick-scope'
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Extension
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-json']

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Emmet
Plug 'mattn/emmet-vim'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'jiangmiao/auto-pairs'
call plug#end() 
