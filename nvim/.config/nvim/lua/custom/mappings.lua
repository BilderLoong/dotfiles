---@type MappingsTable
local M = { }

M.general = {
  i = {['jk']={"<ESC>", "escape insert mode", opts = {nowait=true}}}
}

M.telescope = {
  n = {
    ["<leader>fs"] = { "<cmd> Telescope <CR>", "Find Workspace symbols" },
  }
}

return M
