return {
  "folke/lazydev.nvim",
  ft = "lua",
  enable=false,
  opts = {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  },
}
