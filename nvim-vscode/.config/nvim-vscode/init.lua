vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- nnoremap <Leader>o o<Esc>

vim.cmd([[
  nnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  xnoremap gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  nnoremap <Leader>ca <Cmd>call VSCodeNotify('editor.action.quickFix')<CR> " Replace the default quickfix into code action.
]])

---@type NvPluginSpec[]
require("lazy").setup({
	{
		"unblevable/quick-scope",
		event = "BufReadPost",
		config = function()
			vim.cmd([[
			  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]])
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		keys = { "c", "y", "d" },
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
  {
    "wellle/targets.vim",
    event = "BufReadPost",
  },
}, {})
