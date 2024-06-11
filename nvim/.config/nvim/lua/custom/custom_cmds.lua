local M = {}
local api = vim.api

---@param cwd string
---@return integer `-1`: - no opened config tab.
local function find_tab_by_cwd(cwd)
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local tab_path = vim.fn.getcwd(-1, tab)

    if tab_path == cwd then
      return tab
    end
  end

  return -1
end


function M.open_config()
  local notify = require("notify")

  local vim_config_dir = vim.fn.stdpath("config")
  if type(vim_config_dir) ~= 'string' then
    notify('Wrong `vim_config_dir` type.\n Expect string but got: ' .. type(vim_config_dir), vim.log.levels.WARN)
    return
  end

  local existing_tab = find_tab_by_cwd(vim_config_dir)
  if existing_tab ~= -1 then
    -- Switch to the existing tab
    vim.api.nvim_set_current_tabpage(existing_tab)
    vim.cmd("e lua/custom/init.lua")
    vim.cmd("e lua/custom/plugins.lua")


    notify('Find already opened config tab, switched to it.')
    return
  end

  vim.cmd([[tabnew]])
  vim.cmd("tcd " .. vim_config_dir)
  vim.cmd("e lua/custom/init.lua")
  vim.cmd("e lua/custom/plugins.lua")
end

api.nvim_create_user_command("OpenConfig", M.open_config, {})


return M
