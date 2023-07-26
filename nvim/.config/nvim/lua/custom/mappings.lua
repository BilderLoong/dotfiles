---@type MappingsTable
local M = { }

M.general = {
  i = {['jk']={"<ESC>", "escape insert mode", opts = {nowait=true}}}
}

local builtin = require('telescope.builtin')
M.telescope = {
  n = {
    ["<leader>fs"] = { builtin.find_files, "Find Workspace symbols" },
  }
}

return M
