local options = {

	-- ensure_installed = {
	-- 	-- defaults
	-- 	"vim",
	-- 	"lua",
	-- 	-- web dev
	-- 	"html",
	-- 	"css",
	-- 	"javascript",
	-- 	"typescript",
	-- 	"tsx",
	-- 	"json",
	-- 	"go",
	-- 	-- "vue", "svelte"
	--
	-- 	-- low level
	-- 	"c",
	-- 	"zig",
	-- },
	highlight = {
		-- Disable syntax highlight for big file.
		-- bufnr: buffer number.
		disable = function(lang, bufnr)
			-- :h uv.fs_stat()
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))

			if ok and stats then
				return true
			end

			local buf_size = stats.size
			-- Disable big oneline file.
			local is_big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and buf_size > 100 * 1024
			return is_big_oneliner or buf_size > 100 * 1024 -- 100 KB
		end,
	},
}

return options
