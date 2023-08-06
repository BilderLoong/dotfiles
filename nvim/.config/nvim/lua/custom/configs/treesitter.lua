local options = {

	highlight = {
		disable = function(lang, bufnr)
			vim.api.nvim_buf_line_count(bufnr) == 1

		end,
	},
}

return options
