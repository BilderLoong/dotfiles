vim.g.mapleader = " "

function plugins()
	
end

plugins()

vim.keymap.set("n", "gr", function()
	require("vscode-neovim").notify("editor.action.goToReferences")
end)
