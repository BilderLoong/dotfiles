--- @type MappingsTable
local M = {}

M.general = {
  i = { ["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } } },
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find Workspace symbols" },
    ["<leader>fr"] = { "<cmd> Telescope resume <CR>", "Resume last Telescope picker" },
    ["<C-S-O>"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find document symbols" },
    ["<C-S-P>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
  },
}

return M
