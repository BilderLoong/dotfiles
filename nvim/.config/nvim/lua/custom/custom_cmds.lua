local M = {}
local api = vim.api

function M.open_config()
	local vim_home = vim.fn.stdpath("config")
	vim.cmd([[tabnew]])
	vim.cmd("tcd " .. vim_home)
	vim.cmd("e lua/custom/init.lua")
	vim.cmd("e lua/custom/plugins.lua")
end

api.nvim_create_user_command("Config", M.open_config, {})

return M
