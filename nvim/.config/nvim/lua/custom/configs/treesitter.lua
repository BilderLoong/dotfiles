local options = {

	highlight = {
		disable = function(lang, bufnr)
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
			local buf_size = stats.size
			-- Disable big oneline file.
			-- :h uv.fs_stat()
			local is_big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and buf_size > 100 * 1024
			return is_big_oneliner or size > 100 * 1024
		end,
	},
}

return options
