---@type MappingsTable
local M = { }

M.general = {
  i = {['jk']={"<ESC>", "escape insert mode", opts = {nowait=true}}}
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "Find Workspace symbols" },
    ["<C-P>"] = { "<cmd> Telescope commands <CR>", "Telescope commands" },
  }
}

return M
