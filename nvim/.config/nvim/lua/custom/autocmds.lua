-- Auto save all buffer when buffer losing focus.
local api = vim.api
api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
	pattern = "*",
	command = "silent! wall",
  callback = function (ctx)
   vim.print('Save all buffer on blur.') 
  end
})
