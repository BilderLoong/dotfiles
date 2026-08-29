return {
  "folke/ts-comments.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    -- ponytail: `x` is a temporary placeholder; use a Lua mapping if a comment delimiter contains `x`.
    {
      "gco",
      "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
      desc = "Add commented line below",
    },
    {
      "gcO",
      "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>",
      desc = "Add commented line above",
    },
    {
      "gcA",
      "o<esc>Vcx<esc><cmd>normal gcc<cr>kJfxa<bs>",
      desc = "Add comment at end of line",
    },
  },
}
