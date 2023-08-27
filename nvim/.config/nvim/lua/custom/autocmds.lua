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

api.nvim_create_autocmd({""})
