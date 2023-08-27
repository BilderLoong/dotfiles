-- Auto save all buffer when buffer losing focus.
local api = vim.api
api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	pattern = "*",
	callback = function(ctx)
		api.nvim_command("silent! wall")

		if vim.log.levels.TRACE then
			-- vim.print("Save all buffers on blur.")
		end
	end,
})

function disableAS()
	local cwd = vim.loop.cmd()
	local config_dir = vim.fn.stdpath("config")

	if cwd == config_dir then
		vim.g.auto_save = 0
	end
end

if vim.g.vim_did_enter then
	disableAS()
else
	api.nvim_create_autocmd({
		"Dirchanged",
		"VimEnter",
	}, {
		callback = disableAS,
	})
end
