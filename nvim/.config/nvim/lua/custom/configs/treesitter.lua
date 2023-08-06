local options = {

	highlight = {
		disable = function(lang, bufnr)
			local big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and 

		end,
	},
}

return options
