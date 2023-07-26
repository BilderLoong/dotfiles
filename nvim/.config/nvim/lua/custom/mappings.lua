---@type MappingsTable
local M = { }

M.general = {
  i = {['jk']={"<ESC>", "escape insert mode", opts = {nowait=true}}}
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope lsp_workspace_symbols <CR>", "Find Workspace symbols" },
  }ku
}

return M
