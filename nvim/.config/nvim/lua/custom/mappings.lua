---@type MappingsTable
local M = { }

M.general = {
  i = {['jk']={"<ESC>", "escape insert mode", opts = {nowait=true}}}
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope lsp_dynamic_workspace_symbol <CR>", "Find Workspace symbols" },
  }
}

return M
