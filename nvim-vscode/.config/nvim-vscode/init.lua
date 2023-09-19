vim.cmd([[
  nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>

nnoremap z= <Cmd>call VSCodeNotify('editor.action.quickFix')<CR> " Replace the default quickfix into code action.
]])
