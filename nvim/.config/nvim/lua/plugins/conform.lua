return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>lm",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		default_format_opts = {
			lsp_format = "fallback",
		},

		-- format_on_save = {
		-- 	timeout_ms = 1000,
		-- },

		formatters_by_ft = {
			go = { "gofmt" },
			lua = { "stylua" },
			python = { "ruff_organize_imports", "black" },
			json = { "prettierd", "prettier", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			rust = { "rustfmt" },
			haskell = { "fourmolu" },
			sh = { "shfmt" },
			["_"] = { "trim_whitespace" },
		},

		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
