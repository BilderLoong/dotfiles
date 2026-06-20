return {
  "gbprod/yanky.nvim",
  event = { "TextYankPost" },
  opts = {},
  config = function(_, opts)
    require("yanky").setup(opts)
  end,
}
