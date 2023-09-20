vim.g.mapleader = " "

function lazy_nvim()
  
end

-- vim.cmd([[
--   nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
--   xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
--   nnoremap <Leader>ca <Cmd>call VSCodeNotify('editor.action.quickFix')<CR> " Replace the default quickfix into code action.
-- ]])

vim.keymap.set("n", "gr", function()
	require("vscode-neovim").notify("editor.action.goToReferences")
end)
