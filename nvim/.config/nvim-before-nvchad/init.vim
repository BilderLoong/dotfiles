source <sfile>:h/plugin-config.vim
source <sfile>:h/plugs.vim
source <sfile>:h/autocmds.vim
source <sfile>:h/native.vim

" Hack to fix https://github.com/ggandor/leap.nvim/issues/70 for lightspeed.vim
lua vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })

if exists('g:vscode')
	source <sfile>:h/vscode.vim
endif


