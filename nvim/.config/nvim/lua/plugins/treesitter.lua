return {
	"MeanderingProgrammer/treesitter-modules.nvim",
	lazy = false,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "\\",
				node_incremental = "\\",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
	},
}
