" The common init of both vscode neovim and native neovim
source ./common.vim

if exists('g:vscode')
	source ./vscode.vim    " VSCode extension
else
    " ordinary neovim
	" Editing
	set ts=2
	set sw=0
	set number
	set relativenumber
	set scrolloff=4
	set autoindent
	set ruler
	set showcmd
	set backup
	set nowrap
	set clipboard=unnamedplus
	set fileformats+=mac


	" Plugin Selection
	call plug#begin('~/.vim/plugged')

	" THEME
	" nord
	Plug 'arcticicestudio/nord-vim'

	" Airline
	Plug 'vim-airline/vim-airline'

	" CoC
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" Extension
	let g:coc_global_extensions = ['coc-sumneko-lua','coc-markdownlint', 'coc-tsserver', 'coc-git', 'coc-json', 'coc-eslint', 'coc-json', 'coc-prettier', 'coc-css']

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

	" fzf
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	nnoremap <silent> <c-p> :Files<CR>
	nnoremap <silent><leader>l :Buffers<CR>

	Plug 'jiangmiao/auto-pairs'
	Plug '907th/vim-auto-save'
	" Nerdtree
	Plug 'preservim/nerdtree'
	" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	" Plug 'Xuyuanp/nerdtree-git-plugin'

	" If you need Vim help for vim-plug itself (e.g. :help plug-options), register vim-plug as a plugin.
	Plug 'junegunn/vim-plug'

	" Lua
	Plug 'folke/lua-dev.nvim'

	call plug#end() 

	" The colorscheme option need be put at the end of the plug#end
	" source: https://stackoverflow.com/a/64178519
	colorscheme nord
endif
