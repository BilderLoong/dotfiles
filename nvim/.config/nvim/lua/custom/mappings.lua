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
		-- ["<leader>fr"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
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
			"<cmd> Telescope lsp_type_definitions  <CR>",
			"Telescope LSP type definitions",
		},
		["gi"] = {
			"<cmd> Telescope lsp_implementations   <CR>",
			"Telescope LSP type implementations",
		},
	},
}

M.gitsigns = {
n = {
  ["<leader>hs"] = {
    
  }
}
}

return M
