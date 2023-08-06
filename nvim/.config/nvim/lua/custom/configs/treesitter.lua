local options = {

	highlight = {
		disable = function(lang, bufnr)
			local big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and 

--
local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
		end,
	},
}

return options
