	" Turn off Vim's spell as it highlights the same words. source: https://github.com/kamykn/spelunker.vim
	set nospell
	" Highlight type: (default: 1)
	" 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
	" 2: Highlight only SpellBad.
	" FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
	let g:spelunker_highlight_type = 2

" Plugin Selection
call plug#begin('~/.vim/plugged')

" The common init of both vscode neovim and native neovim
source <sfile>:h/common.vim

if exists('g:vscode')
	source <sfile>:h/vscode.vim
else
	" Support syntax highlight for lua in VimL.
	let g:vimsyn_embed = 'l'

	" Ordinary neovim
	" Editing
	set ts=2
	set sw=0
	set number
	set relativenumber
	set scrolloff=4
	set autoindent
	set ruler
	set showcmd
	set nobackup
	set nowrap
	set clipboard=unnamedplus
	set fileformats+=mac
	" Switch on the spell checking
	set spell
	" When the 'spell' option is on spellchecking will be done for these languages.
	set spelllang+=en
	set hidden

	" The below setting aim to improve Coc experience.
	" Some coc languages servers have issues with backup files, see #649.
	set nobackup
	set nowritebackup

	" Give more space for displaying messages.
	set cmdheight=2
	" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
	" delays and poor user experience.
	set updatetime=300

	" autocmd
	" Make it easier for sourcing playground vim script
	autocmd BufRead *_playground.vim nnoremap <Leader>r <Cmd>source %<CR> 

	" THEME
	" nord
	Plug 'arcticicestudio/nord-vim'
	let g:nord_uniform_diff_background = 1

	" Airline
	Plug 'vim-airline/vim-airline'

	" CoC
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	source <sfile>:h/coc.vim

	" Emmet
	Plug 'mattn/emmet-vim'

	Plug 'tpope/vim-commentary'

	" fzf
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	nnoremap <silent> <C-P> <Cmd>GFiles<CR>
	map <leader>/ <Cmd>BLines<CR>
	nnoremap <silent><Leader>fl <Cmd>Buffers<CR>
	nnoremap <silent><Leader>fh <Cmd>Helptags<CR>
	nmap <silent> <leader>fm <Cmd>History<CR>

	Plug 'jiangmiao/auto-pairs'
	Plug '907th/vim-auto-save'

	" NERDtree
	let NERDTreeHijackNetrw = 1
	Plug 'preservim/nerdtree'
	nmap <C-n> <Cmd>NERDTreeToggle<CR>
	nmap <Leader>n <Cmd>NERDTreeFocus<CR>

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
endif
call plug#end() 

" Improve the comment contrast
" source: https://github.com/arcticicestudio/nord-vim/issues/26#issuecomment-284210428
augroup nord-overrides
	autocmd!
	autocmd ColorScheme nord highlight Comment ctermfg=14
augroup END

" The colorscheme option should be put at the end of the plug#end
" source: https://stackoverflow.com/a/64178519
colorscheme nord
