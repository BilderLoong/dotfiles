return {
  "kylechui/nvim-surround",
  version = "*",
  keys = {
    { "<C-g>s", mode = "i" },
    { "<C-g>S", mode = "i" },
    { "ys", mode = "n" },
    { "yS", mode = "n" },
    { "ds", mode = "n" },
    { "cs", mode = "n" },
    { "cS", mode = "n" },
    { "gs", mode = "x" },
    { "gS", mode = "x" },
  },
  opts = {
    keymaps = {
      visual = "gs",
      visual_line = "gS",
    },
  },
  config = function(_, opts)
    require("nvim-surround").setup(opts)
  end,
}
