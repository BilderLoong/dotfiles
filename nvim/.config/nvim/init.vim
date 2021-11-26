lua << EOF
	require 'eden'
EOF

" The common init of both vscode neovim and native neovim
source <sfile>:h/common.vim

source <sfile>:h/plugs.vim

if exists('g:vscode')
	source <sfile>:h/vscode.vim
else
	" Support syntax highlight for lua in VimL.
	let g:vimsyn_embed = 'l'

endif

" Improve the comment contrast
" source: https://github.com/arcticicestudio/nord-vim/issues/26#issuecomment-284210428
augroup nord-overrides
	autocmd!
	autocmd ColorScheme nord highlight Comment ctermfg=14
augroup END

" The colorscheme option should be put at the end of the plug#end
" source: https://stackoverflow.com/a/64178519
colorscheme nord
