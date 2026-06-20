return {
  "LunarVim/bigfile.nvim",
  event = "BufReadPre",
  opts = function(_, opts)
    return {
      pattern = function(bufnr, filesize_mib)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
        if not ok or not stats then return true end
        local buf_size = stats.size
        local is_big_oneliner = vim.api.nvim_buf_line_count(bufnr) == 1 and buf_size > 100 * 1024
        return is_big_oneliner or buf_size > 2000 * 1024
      end,
    }
  end,
}
