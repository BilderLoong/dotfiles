local options = {

	highlight = {
		disable = function(lang, bufnr)
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
      -- Disable big oneline file.
			local big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and stats.size > 100 * 1024
			-- :h uv.fs_stat()
		end,
	},
}

return options
