vim.g.mapleader = " "

local function plugins()
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

		{
			"ggandor/lightspeed.nvim",
			event = "BufReadPost",
		},

		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			event = "BufReadPost",
			dependencies = "nvim-treesitter/nvim-treesitter",
		},

		{
			"mfussenegger/nvim-treehopper",
			dependencies = "nvim-treesitter/nvim-treesitter",
			event = "BufReadPost",
			-- keys = { "v", "y", "d", "c" },
			config = function(_, opts)
				vim.keymap.set("n", "m", ":<C-U>lua require('tsht').nodes()<CR>")
			end,
		},
	}, {
		performance = {

			defaults = {
				lazy = true, -- should plugins be lazy-loaded?
			},

			rtp = {
				disabled_plugins = {
					"2html_plugin",
					"tohtml",
					"getscript",
					"getscriptPlugin",
					"gzip",
					"logipat",
					"netrw",
					"netrwPlugin",
					"netrwSettings",
					"netrwFileHandlers",
					"matchit",
					"tar",
					"tarPlugin",
					"rrhelper",
					"spellfile_plugin",
					"vimball",
					"vimballPlugin",
					"zip",
					"zipPlugin",
					"tutor",
					"rplugin",
					"syntax",
					"synmenu",
					"optwin",
					"compiler",
					"bugreport",
					"ftplugin",
				},
			},
		},
	})
end
plugins()

-- LSP stuff
vim.keymap.set("n", "gr", function()
	require("vscode-neovim").notify("editor.action.goToReferences")
end)
