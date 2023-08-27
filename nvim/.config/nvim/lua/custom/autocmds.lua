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

if vim.g.vim_did_enter then 
  vim.g.au

api.nvim_create_autocmd({"Dirchanged","VimEnter"},{

})
