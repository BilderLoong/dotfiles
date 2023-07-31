local BufEnterLike = { "BufReadPost", "BufAdd", "BufNewFile" }

---
local plugins = {
	{
		"unblevable/quick-scope",
		event = BufEnterLike,
		config = function()
			-- Make quick scope highlight in vscode.
			vim.cmd([[
			  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]])
		end,
	},
	{
		"ggandor/lightspeed.nvim",
		event = "VeryLazy",
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
		event = BufEnterLike,
	},
	{
		"elijahmanor/export-to-vscode.nvim",
	},

	{
		"RRethy/nvim-treesitter-textsubjects",
		opt = true,
		event = BufEnterLike,
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				textsubjects = {
					enable = true,
					prev_selection = ",", -- (Optional) keymap to select the previous selection
					keymaps = {
						["."] = "textsubjects-smart",
						[";"] = "textsubjects-container-outer",
						["i;"] = "textsubjects-container-inner",
					},
				},
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup()
		end,
	},
	{
		"nvim-treesitter/playground",
		event = BufEnterLike,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				-- defaults
				"vim",
				"lua",
				-- web dev
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"json",
				-- "vue", "svelte",

				-- low level
				"c",
				"zig",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"jose-elias-alvarez/null-ls.nvim",
			config = function()
				require("custom.configs.null-ls")
			end,
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end,
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle" },
	},

	{
		"Pocco81/auto-save.nvim",
		event = "VeryLazy",
		config = function()
			require("auto-save").setup({})
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- Lua
				"lua-language-server",
				"stylua",
				"luacheck",

				-- Web
				"html-lsp",
				"typescript-language-server",
				"prettierd",
				"eslint_d",

				-- MP
				"yaml-language-server",

				-- Shell
				"shellcheck",

				-- Misc
				"cspell",
			},
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"romgrk/nvim-treesitter-context",
		event = BufEnterLike,
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = {
					-- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = { "class", "function", "method" },
				},
			})
		end,
	},
	{
		"nanotee/zoxide.vim",
		cmd = { "Z", "Tzi", "Lzi", "Zi", "Lz" },
		dependencies = {
			{
				"junegunn/fzf.vim",
			},
		},
	},
	{
		"junegunn/fzf.vim",
		dependencies = { { "junegunn/fzf", run = ":call fzf#install()<CR>" } },
	},
}

return plugins
