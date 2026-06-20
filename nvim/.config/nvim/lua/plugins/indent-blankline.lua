return {
  "lukas-reineke/indent-blankline.nvim",
  opts = function(plugin, opts)
    return vim.tbl_deep_extend("force", opts, {
      show_current_context = false,
      show_current_context_start = false,
    })
  end,
}
