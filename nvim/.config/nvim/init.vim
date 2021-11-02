" Plugin Selection
call plug#begin('~/.vim/plugged')

" The common init of both vscode neovim and native neovim
source <sfile>:h/common.vim

if exists('g:vscode')
	source <sfile>:h/vscode.vim
else

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

	" THEME
	" nord
	Plug 'arcticicestudio/nord-vim'
	let g:nord_uniform_diff_background = 1

	" Airline
	Plug 'vim-airline/vim-airline'

	" CoC
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	" Extension
	let g:coc_global_extensions = [ 
				\'coc-sumneko-lua',
				\ 'coc-markdownlint',
				\ 'coc-tsserver',
				\ 'coc-git',
				\ 'coc-json',
				\ 'coc-eslint',
				\ 'coc-json',
				\ 'coc-prettier',
				\ 'coc-css']

	" Use `[g` and `]g` to navigate diagnostics
	nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
	nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nnoremap <silent> gd <Plug>(coc-definition)
	nnoremap <silent> gy <Plug>(coc-type-definition)
	nnoremap <silent> gi <Plug>(coc-implementation)
	nnoremap <silent> gr <Plug>(coc-references)

	" Remap keys for applying codeAction to the current line.
	nnoremap <Leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nnoremap <Leader>qf  <Plug>(coc-fix-current)

	" Remap for rename current word
	nnoremap <F2> <Plug>(coc-rename)

	" Format
	nnoremap <Leader>f   :CocCommand prettier.formatFile<CR>

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

	" Symbol renaming.
	nmap <F2> <Plug>(coc-rename)

	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	" Use <Leader> K to show documentation in preview window.
	nnoremap <silent> <Leader>K <Cmd>call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		elseif (coc#rpc#ready())
			call CocActionAsync('doHover')
		else
			execute '!' . &keywordprg . " " . expand('<cword>')
		endif
	endfunction

	" Emmet
	Plug 'mattn/emmet-vim'

	Plug 'tpope/vim-commentary'

	" fzf
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	nnoremap <silent> <C-P> <Cmd>Files<CR>
	nnoremap <silent><Leader>l <Cmd>Buffers<CR>

	Plug 'jiangmiao/auto-pairs'
	Plug '907th/vim-auto-save'

	" NERDtree
	Plug 'preservim/nerdtree'
	nmap <C-N> <Cmd>NERDTreeToggle<CR>
	nmap <Leader>n <Cmd>NERDTreeFocus<CR>

	Plug 'Xuyuanp/nerdtree-git-plugin'
	" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

	" If you need Vim help for vim-plug itself (e.g. :help plug-options), register vim-plug as a plugin.
	Plug 'junegunn/vim-plug'

	" Lua
	Plug 'folke/lua-dev.nvim'

	" For better spellchecking.
	Plug 'kamykn/spelunker.vim'
	" Turn off Vim's spell as it highlights the same words. source: https://github.com/kamykn/spelunker.vim
	set nospell
	" Highlight type: (default: 1)
	" 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
	" 2: Highlight only SpellBad.
	" FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
	let g:spelunker_highlight_type = 2

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
