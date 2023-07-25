" File description: this file is the index for my personal autocommand.

if(!exists('g:vscode'))
	" autocmd
	" Make it easier for sourcing playground vim script
	autocmd BufRead *_playground.vim nnoremap <Leader>r <Cmd>source %<CR> 
"	autocmd BufRead * call v:lua.checkEden()
endif
