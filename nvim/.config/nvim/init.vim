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

" Treat long lines as break lines
map j gj
map k gk

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

" Theme
Plug 'morhetz/gruvbox'
colorscheme gruvbox

" Airline
Plug 'vim-airline/vim-airline'

" use vscode easymotion when in vscode mode
Plug 'asvetliakov/vim-easymotion'
    nnoremap s         <Plug>(easymotion-s2)
    xmap s         <Plug>(easymotion-s2)
    omap z         <Plug>(easymotion-s2)
    nnoremap <Leader>s <Plug>(easymotion-sn)
    xmap <Leader>s <Plug>(easymotion-sn)
    omap <Leader>z <Plug>(easymotion-sn)

nnoremap <Leader>a <Plug>(easymotion-jumptoanywhere)
xmap <Leader>a <Plug>(easymotion-jumptoanywhere)
omap <Leader>a <Plug>(easymotion-jumptoanywhere)

nnoremap <Leader>w <Plug>(easymotion-bd-w)
xmap <Leader>w <Plug>(easymotion-bd-w)
omap <Leader>w <Plug>(easymotion-bd-w)

nnoremap <Leader>e <Plug>(easymotion-bd-e)
xmap <Leader>e <Plug>(easymotion-bd-e)
omap <Leader>e <Plug>(easymotion-bd-e)

nnoremap <Leader>t <Plug>(easymotion-bd-t)
xmap <Leader>t <Plug>(easymotion-bd-t)
omap <Leader>t <Plug>(easymotion-bd-t)

"Plug 'unblevable/quick-scope'
xmap gc  <Plug>VSCodeCommentary
nnoremap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nnoremap gcc <Plug>VSCodeCommentaryLine

Plug 'tpope/vim-surround'

Plug 'unblevable/quick-scope'
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Extension
let g:coc_global_extensions = ['coc-markdownlint', 'coc-tsserver', 'coc-git', 'coc-json', 'coc-eslint', 'coc-json', 'coc-prettier', 'coc-css']

" Use `[g` and `]g` to navigate diagnostics
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Remap keys for applying codeAction to the current line.
nnoremap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nnoremap <leader>qf  <Plug>(coc-fix-current)

" Remap for rename current word
nnoremap <F2> <Plug>(coc-rename)

" Format
nnoremap <leader>f   :CocCommand prettier.formatFile<CR>

" coc-git
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" navigate conflicts of current buffer
nmap [c <Plug>(coc-git-prevconflict)
nmap ]c <Plug>(coc-git-nextconflict)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
" nmap gc <Plug>(coc-git-commit) " Confilcting with vim-commentary.
" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" Emmet
Plug 'mattn/emmet-vim'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <silent> <c-p> :Files<CR>
nnoremap <silent><leader>l :Buffers<CR>

Plug 'jiangmiao/auto-pairs'

" Nerdtree
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end() 
