local api = vim.api
local vim_home = vim.fn.stdpath('config')

api.nvim_create_user_command("Config", function()
	vim.cmd([[tabnew]])
	vim.cmd("tcd " .. vim_home)
  vim.cmd('e lua/custom/init.lua')
end, {})
