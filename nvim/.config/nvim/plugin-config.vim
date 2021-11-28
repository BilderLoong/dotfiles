" Coc
source <sfile>:h/coc.vim

" Airline
" let g:airline#extensions#tabline#enabled = 1

" Fzf
nnoremap <silent> <C-P> <Cmd>GFiles<CR>
map <leader>/ <Cmd>BLines<CR>
nnoremap <silent><Leader>fl <Cmd>Buffers<CR>
nnoremap <silent><Leader>fh <Cmd>Helptags<CR>
nmap <silent> <leader>fm <Cmd>History<CR>

" NERDtree
let NERDTreeHijackNetrw = 1
let NERDTreeShowHidden=1
nmap <C-n> <Cmd>NERDTreeToggle<CR>
nmap <Leader>n <Cmd>NERDTreeFocus<CR>

" nord
let g:nord_uniform_diff_background = 1
" Improve the comment contrast
" source: https://github.com/arcticicestudio/nord-vim/issues/26#issuecomment-284210428
augroup nord-overrides
	autocmd!
	autocmd ColorScheme nord highlight Comment ctermfg=14
augroup END

" spelunker
" Turn off Vim's spell as it highlights the same words. source: https://github.com/kamykn/spelunker.vim
set nospell

" Highlight type: (default: 1)
" 1: Highlight all types (SpellBad, SpellCap, SpellRare, SpellLocal).
" 2: Highlight only SpellBad.
" FYI: https://vim-jp.org/vimdoc-en/spell.html#spell-quickstart
let g:spelunker_highlight_type = 2
let g:enable_spelunker_vim = 1

" quick-scope
" You should put the following block before you set colorscheme <colorsname>.
" source: https://github.com/unblevable/quick-scope#customize-colors
augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
	autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

" gruvbox
let g:airline_theme = 'gruvbox'

" easymotion
"

" vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
