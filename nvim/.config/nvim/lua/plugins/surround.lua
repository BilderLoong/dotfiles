return {
  "kylechui/nvim-surround",
  version = "*",
  init = function() vim.g.nvim_surround_no_visual_mappings = true end,
  keys = {
    "c",
    "y",
    "d",
    { "gs", mode = "x" },
    { "gS", mode = "x" },
  },
  config = function()
    require("nvim-surround").setup {}
    vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual)", {
      desc = "Add a surrounding pair around a visual selection",
    })
    vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
      desc = "Add a surrounding pair around a visual selection, on new lines",
    })
  end,
}
