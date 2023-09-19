" Common Mapping

let mapleader = "\<Space>"

" https://www.reddit.com/r/neovim/comments/g94zrl/solution_neovim_clipboard_with_wsl/
if executable('clip.exe')
  let g:clipboard = {
        \   'name': 'WslClipboard',
        \   'copy': {
        \      '+': 'clip.exe',
        \      '*': 'clip.exe',
        \    },
        \   'paste': {
        \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        \   },
        \   'cache_enabled': 0,
      \ }
endif

" Key mapping	

" Treat long lines as break lines
map j gj
map k gk


" Unbind C-c key
inoremap <C-c> <Nop>

nnoremap <Leader>j J
nnoremap J 5j
nnoremap K 5k

noremap Y y$

" fast insert black line.
nnoremap <Leader>o o<Esc>

" fast system clipboard.
nnoremap <Leader>y "*y
xnoremap <Leader>y "*y
nnoremap <Leader>p "*p
xnoremap <Leader>p "*p

" noremap! jk <C-c>
noremap! jk <Esc>

" Set format option, make format line (gq) work for Chinese. 
set formatoptions+=mM

lua vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })

" Ordinary neovim
if (!exists('g:vscode'))

	" Aesthetics
	" The colorscheme option should be put at the end of the plug#end
	" source: https://stackoverflow.com/a/64178519
	" colorscheme gruvbox
	colorscheme nord

	" Editing
	set tabstop=2
	set shiftwidth=2
	set expandtab
	set number
	set relativenumber
	set scrolloff=4
	set autoindent
	set ruler
	set showcmd
	set nobackup
	set nowrap
  set textwidth=60
	" Support 
	set mouse=a
	set clipboard=unnamedplus
	set fileformats+=mac
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
	set autoread                " detect when a file is changed

	" Support syntax highlight for lua in VimL.
	let g:vimsyn_embed = 'l'

	" fast source current file.
	nnoremap <Leader>s <Cmd>w <Bar> source % <CR>

	" fast source vimrc file.
	nnoremap <Leader>r :source $MYVIMRC<CR>

	" Open the director that contains vimrc file.
	nnoremap <Leader>vm <Cmd>NERDTreeToggle $MYVIMRC<CR>


	" CDC = Change to Directory of Current file, 
	" source: https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file#Mapping_or_command_for_quick_directory_change
	command! CDC cd %:p:h
endif

