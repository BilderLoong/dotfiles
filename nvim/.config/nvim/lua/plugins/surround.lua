return {
  "kylechui/nvim-surround",
  version = "*",
  keys = { "c", "y", "d" },
  config = function()
    require("nvim-surround").setup {}
  end,
}
