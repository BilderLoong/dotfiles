--- @type MappingsTable
local M = {}

M.disabled = {
	n = {
		["<leader>D"] = "",
	},
}

M.general = {
	i = {
		["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
	},
	n = {
		["<leader>cd"] = {
			function()
				require("export-to-vscode").launch()
			end,
			"Export to VSCode",
			opts = { noremap = true, silent = true },
		},
	},
}

local telescope_i_n = {
	["<A-d>"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find document symbols" },
	["<A-b>"] = { "<cmd> Telescope <CR>", "Telescope builtins" },
	["<A-k>"] = { "<cmd> Telescope keymaps <CR>", "Telescope keymaps" },
	["<A-p>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
	["<A-r>"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
}

M.telescope = {
	n = vim.tbl_deep_extend("force", telescope_i_n, {
		["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find workspace symbols" },
	}),
	i = vim.tbl_deep_extend("force", telescope_i_n, {}),
}

M.lspconfig = {
	n = {
		["gd"] = {
			"<cmd> Telescope lsp_definitions  <CR>",
			"Telescope LSP definitions",
		},
		["gr"] = {
			"<cmd> Telescope lsp_references <CR>",
			"Telescope LSP references",
		},
		["gy"] = {
			"<cmd> Telescope lsp_type_definitions <CR>",
			"Telescope LSP type definitions",
		},
		["gi"] = {
			"<cmd> Telescope lsp_implementations <CR>",
			"Telescope LSP type implementations",
		},
	},
}

M.gitsigns = {
	v = {
		["<leader>ghu"] = {
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			"Unstage Git hunk",
		},
		["<leader>ghr"] = {
			function()
				require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			"Reset Hunk",
		},

		["<leader>ghs"] = {
			function()
				require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end,
			"Stage Hunk",
		},
	},
	n = {
		["<leader>ghu"] = {
			function()
				require("gitsigns").undo_stage_hunk()
			end,
			"Unstage Git hunk",
		},
		["<leader>ghr"] = {
			function()
				require("gitsigns").reset_hunk()
			end,
			"Reset Hunk",
		},

		["<leader>ghs"] = {
			function()
				require("gitsigns").stage_hunk()
			end,
			"Stage Hunk",
		},
	},

	-- Text object
	x = {
		["ih"] = {
			":<C-U>Gitsigns select_hunk <CR>",
			"Select Hunk",
		},
	},
	o = {
		["ih"] = {
			"<cmd> <C-U>Gitsigns select_hunk <CR>",
			"Select Hunk",
		},
	},
}

return M
