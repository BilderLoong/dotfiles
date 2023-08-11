local opt = vim.opt
local g = vim.g

-- Editor
opt.relativenumber = true
-- opt.wrap = false

-- Folding

-- opt.autochdir = true
--
g.toggle_theme_icon = ""

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd([[
  set nofoldenable
]])


-- function start_tsserver()
-- 	vim.print("start")
-- end
--
-- if vim.g.vim_did_enter then
-- 	start_tsserver()
-- else
-- 	vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
-- 		pattern = "*",
-- 		callback = function()
-- 			vim.print("VimEnter")
-- 		end,
-- 	})
-- end
