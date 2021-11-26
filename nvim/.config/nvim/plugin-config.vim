" Coc
source <sfile>:h/coc.vim

" Airline
let g:airline#extensions#tabline#enabled = 1

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
