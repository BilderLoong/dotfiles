local options = {

	highlight = {
		--- Disable syntax highlight for big file.
		--- @param lang string
		--- @param bufnr number
		--- @return boolean
		-- disable = function(lang, bufnr)
		-- 	-- :h uv.fs_stat()
		-- 	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
		--
		-- 	if not ok or not stats then
		-- 		return true
		-- 	end
		--
		-- 	local buf_size = stats.size
		-- 	-- Disable big oneline file.
		-- 	local is_big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and buf_size > 100 * 1024
		-- 	return is_big_oneliner or buf_size > 1000 * 1024 -- 1MB
		-- end,

		enable = true,
		additional_vim_regex_highlighting = false,
	},
	-- https://github.com/AstroNvim/AstroNvim/blob/ffaa3877f0dd3a7468f29e81cf4ebf534a5ad891/lua/plugins/treesitter.lua#L35
	-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["ak"] = { query = "@block.outer", desc = "around block" },
				["ik"] = { query = "@block.inner", desc = "inside block" },
				["ac"] = { query = "@class.outer", desc = "around class" },
				["ic"] = { query = "@class.inner", desc = "inside class" },
				["a?"] = { query = "@conditional.outer", desc = "around conditional" },
				["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
				["af"] = { query = "@function.outer", desc = "around function " },
				["if"] = { query = "@function.inner", desc = "inside function " },
				["al"] = { query = "@loop.outer", desc = "around loop" },
				["il"] = { query = "@loop.inner", desc = "inside loop" },
				["aa"] = { query = "@parameter.outer", desc = "around argument" },
				["ia"] = { query = "@parameter.inner", desc = "inside argument" },
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]k"] = { query = "@block.outer", desc = "Next block start" },
				["]f"] = { query = "@function.outer", desc = "Next function start" },
				["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
			},
			goto_next_end = {
				["]K"] = { query = "@block.outer", desc = "Next block end" },
				["]F"] = { query = "@function.outer", desc = "Next function end" },
				["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
			},
			goto_previous_start = {
				["[k"] = { query = "@block.outer", desc = "Previous block start" },
				["[f"] = { query = "@function.outer", desc = "Previous function start" },
				["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
			},
			goto_previous_end = {
				["[K"] = { query = "@block.outer", desc = "Previous block end" },
				["[F"] = { query = "@function.outer", desc = "Previous function end" },
				["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
			},
		},
		swap = {
			enable = true,
			swap_next = {
				[">K"] = { query = "@block.outer", desc = "Swap next block" },
				[">F"] = { query = "@function.outer", desc = "Swap next function" },
				[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
			},
			swap_previous = {
				["<K"] = { query = "@block.outer", desc = "Swap previous block" },
				["<F"] = { query = "@function.outer", desc = "Swap previous function" },
				["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
			},
		},
	},

	-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#plugins-with-a-pre-comment-hook
	-- context_commentstring = {
	--   enable = true,
	--   enable_autocmd = false,
	-- },

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,
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
		"vue",
		"go",

		-- low level
		"c",
		"zig",

		-- misc
		"markdown",
		"markdown_inline",
	},
}

return options
