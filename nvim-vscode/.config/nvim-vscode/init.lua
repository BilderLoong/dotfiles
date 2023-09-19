
vim.opt.mapleader = "<Space>"

vim.api.nvim_set_keymap(

)
nnoremap <Leader>o o<Esc>

vim.cmd([[
  nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  nnoremap <Leader>ca <Cmd>call VSCodeNotify('editor.action.quickFix')<CR> " Replace the default quickfix into code action.
]])
