local options = {

	highlight = {
		disable = function(lang, bufnr)
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
local sizebuf = stats.size
      -- Disable big oneline file.
			-- :h uv.fs_stat()
			local is_big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and sizebuf > 100 * 1024
      local is_file = 
		end,
	},
}

return options
