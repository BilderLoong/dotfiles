--- @type MappingsTable
local M = {}

M.general = {
  i = { ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } } },
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find workspace symbols" },
    ["<leader>fr"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
    ["<C-O>"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find document symbols" },
    ["<C-P>"] = { "<cmd> Telescope <CR>", "Telescope" },
    ["<C-M>"] = { "<cmd> Telescope keymaps <CR>", "Telescope keymaps" },
    ["<C-C>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
  },
}

return M
