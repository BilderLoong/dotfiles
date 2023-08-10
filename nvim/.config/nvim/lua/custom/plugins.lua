local BufEnterLike = { "BufReadPost", "BufAdd", "BufNewFile" }

---
local plugins = {
	{
		"unblevable/quick-scope",
		event = BufEnterLike,
		config = function()
			vim.cmd([[
			  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]])
		end,
	},

	{
		"ggandor/lightspeed.nvim",
		event = BufEnterLike,
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
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = BufEnterLike,
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	{
		"RRethy/nvim-treesitter-textsubjects",
		event = BufEnterLike,
		dependencies = "nvim-treesitter/nvim-treesitter",
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
		dependencies = {},
		opts = function()
			return require("custom.configs.treesitter")
		end,
	},

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
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
		event = BufEnterLike,
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
				"prettier",
				"eslint_d",

				-- MP
				"yaml-language-server",

				-- Shell
				"shellcheck",
				"shfmt",
				"bash-language-server",

				-- Python
				"ruff", -- linter
				"black", -- formater

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
		dependencies = {
			{
				"junegunn/fzf",
				build = ":call fzf#install()<CR>",
			},
		},
	},

	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	},

	{
		"lewis6991/gitsigns.nvim",
		ft = { "gitcommit", "diff" },
		opts = function()
      return require("plugins.configs.others").gitsigns
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		config = function(_, opt)
			require("cmp").setup(opt)
			vim.print("opt int config", opt)
		end,
		opts = function()
			local cmp = require("cmp")
			local opts = vim.tbl_deep_extend("force", require("plugins.configs.cmp"), {
				mapping = {
					["<A-Space>"] = cmp.mapping.complete(),
				},
			})

			vim.print(opts)
			return opts
		end,
	},

	{

		"nvim-telescope/telescope-fzf-native.nvim", -- dependency for better sorting performance
		build = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},

	{
		"rmagatti/auto-session",
		-- event = "VeryLazy",
		lazy = false,
		opts = {
			log_level = vim.log.levels.ERROR,
			-- auto_session_enable_last_session = true,

			-- ⚠️ This will only work if Telescope.nvim is installed
			-- The following are already the default values, no need to provide them if these are already the settings you want.
			session_lens = {
				-- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = true,
			},
		},
		config = function(_, opts)
			require("auto-session").setup(opts)
			--[For a better experience with the plugin overall using this config for sessionoptions is recommended.](https://github.com/rmagatti/auto-session#recommended-sessionoptions-config)
			--
			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		end,
	},
	{

		"nvim-tree/nvim-tree.lua",
		opts = function()
			return vim.tbl_deep_extend("force", require("plugins.configs.nvimtree"), {
				filesystem_watchers = {
					enable = false,
				},
			})
		end,
	},

	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
		init = function()
			-- Write all buffers before navigating from Vim to tmux pane
			vim.g.tmux_navigator_save_on_switch = 2
		end,
	},

	-- {
	-- 	"numToStr/Comment.nvim",
	-- },
}

return plugins
