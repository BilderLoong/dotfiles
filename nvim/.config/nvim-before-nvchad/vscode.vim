" All config expect plug relate to vscode is stored in this file

" Vim editor setting.
 set textwidth=60

" Make quick scope highlight in vscode.
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline

" Mapping
" Fold
nnoremap zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nnoremap zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nnoremap zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
nnoremap zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>

" Workbench action
" Toggle Primary Sidebar.
nnoremap <M-b> <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
xnoremap <M-b> <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

" Toggle Second Sidebar.
nnoremap <M-n> <Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>
xnoremap <M-n> <Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>

nnoremap <M-j> <Cmd>call VSCodeNotify('workbench.action.togglePanel')<CR>
xnoremap <M-j> <Cmd>call VSCodeNotify('workbench.action.togglePanel')<CR>

" Move cursor between windows in a tab.
nnoremap <M-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <M-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <M-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <M-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <M-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <M-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <M-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <M-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
xnoremap gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>

nnoremap gY <Cmd>call VSCodeNotify('editor.action.peekTypeDefinition)<CR>
xnoremap gY <Cmd>call VSCodeNotify('editor.action.peekTypeDefinition)<CR>

nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>

nnoremap z= <Cmd>call VSCodeNotify('editor.action.quickFix')<CR> " Replace the default quickfix into code action.
nnoremap <Leader>zo <Cmd>call VSCodeNotify('editor.action.organizeImports')<CR>

nnoremap <Leader>cf <Cmd>call VSCodeNotify('gitlens.copyRemoteFileUrlToClipboard')<CR> 
xnoremap <Leader>cf <Cmd>call VSCodeNotify('gitlens.copyRemoteFileUrlToClipboard')<CR> 

nnoremap <Leader>hc <Cmd>call VSCodeNotify('references-view.showCallHierarchy')<CR> 
xnoremap <Leader>hc <Cmd>call VSCodeNotify('references-view.showCallHierarchy')<CR> 

" Git

" Stage selected range 
" https://github.com/airblade/vim-gitgutter#hunks
nnoremap <Leader>hs <Cmd>call VSCodeNotify('git.stageSelectedRanges')<CR> 
xnoremap <Leader>hs <Cmd>call VSCodeNotify('git.stageSelectedRanges')<CR> 
nnoremap <Leader>hu <Cmd>call VSCodeNotify('git.unstageSelectedRanges')<CR> 
xnoremap <Leader>hu <Cmd>call VSCodeNotify('git.unstageSelectedRanges')<CR> 

" The below paragraph doesn't work.
" Jump between git hunk, https://github.com/airblade/vim-gitgutter#hunks
nnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR> 
xnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR> 
nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR> 
xnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR> 


nnoremap <Leader>f <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR> 
xnoremap <Leader>f <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR> 


" TODO open file explore. use <C-n>
" TODO open git aside. Maybe using :G

" commentary
map gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine


" Stop using easymotion, use ggandor/lightspeed.nvim instead.
" easymotion config
" omap z         <Plug>(easymotion-s2)
" nmap <Leader>s <Plug>(easymotion-sn)
" xmap <Leader>s <Plug>(easymotion-sn)
" omap <Leader>z <Plug>(easymotion-sn)

" nmap <Leader>a <Plug>(easymotion-jumptoanywhere)
" xmap <Leader>a <Plug>(easymotio-jumptoanywhere)
" omap <Leader>a <Plug>(easymotion-jumptoanywhere)

" nmap <Leader>w <Plug>(easymotion-bd-w)
" xmap <Leader>w <Plug>(easymotion-bd-w)
" omap <Leader>w <Plug>(easymotion-bd-w)

" nmap <Leader>e <Plug>(easymotion-bd-e)
" xmap <Leader>e <Plug>(easymotion-bd-e)
" omap <Leader>e <Plug>(easymotion-bd-e)

" nmap <Leader>t <Plug>(easymotion-bd-t)
" xmap <Leader>t <Plug>(easymotion-bd-t)
" omap <Leader>t <Plug>(easymotion-bd-t)
