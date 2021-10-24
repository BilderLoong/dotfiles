"	highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
"	highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline

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
