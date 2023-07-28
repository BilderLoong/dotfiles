--- @type MappingsTable
local M = {}

M.general = {
	i = { ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } } },
}

M.telescope = {
	n = {
		["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find workspace symbols" },
		["<leader>fr"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
		["<A-d>"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find document symbols" },
		["<A-p>"] = { "<cmd> Telescope <CR>", "Telescope" },
		["<A-m>"] = { "<cmd> Telescope keymaps <CR>", "Telescope keymaps" },
		["<A-c>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
	},
	i = {},
}

return M
