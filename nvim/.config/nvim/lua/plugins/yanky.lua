return {
  "gbprod/yanky.nvim",
  event = { "TextYankPost" },
  keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after with Yanky" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before with Yanky" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put after and move cursor" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put before and move cursor" },
    { "<A-k>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank history entry" },
    { "<A-j>", "<Plug>(YankyNextEntry)", desc = "Next yank history entry" },
  },
  opts = {},
  config = function(_, opts)
    require("yanky").setup(opts)
  end,
}
