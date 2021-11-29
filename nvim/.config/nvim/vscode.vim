" All config expect plug relate to vscode is stored in this file

" Make qucik scope highlight in vscode.
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline

" Mappling
" Fold
nnoremap zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nnoremap zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nnoremap zt <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
nnoremap zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
nnoremap zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>


" Move between windows in a tab
nnoremap <M-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <M-j> :call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <M-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <M-k> :call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <M-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <M-h> :call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <M-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <M-l> :call VSCodeNotify('workbench.action.navigateRight')<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CoC
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
xnoremap gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>

nnoremap gY <Cmd>call VSCodeNotify('editor.action.peekTypeDefinition)<CR>
xnoremap gY <Cmd>call VSCodeNotify('editor.action.peekTypeDefinition)<CR>

nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>

nnoremap <Leader>f <Plug>VSCodeNotify('eden-develop-environment.lint.format')<CR>

" TODO add move to next git chunk. same to git gutter: https://github.com/airblade/vim-gitgutter#hunks
" TODO open file explore. use <C-n>
" TODO open git aside. Maybe using :G

" commentary
map gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine


" easymotion config
nmap s         <Plug>(easymotion-s2)
xmap s         <Plug>(easymotion-s2)
omap z         <Plug>(easymotion-s2)
nmap <Leader>s <Plug>(easymotion-sn)
xmap <Leader>s <Plug>(easymotion-sn)
omap <Leader>z <Plug>(easymotion-sn)

nmap <Leader>a <Plug>(easymotion-jumptoanywhere)
xmap <Leader>a <Plug>(easymotio-jumptoanywhere)
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
