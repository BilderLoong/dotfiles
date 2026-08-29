return {
  "kevinhwang91/nvim-ufo",
  event = "User AstroFile",
  dependencies = "kevinhwang91/promise-async",
  keys = {
    {
      "zM",
      function() require("ufo").closeAllFolds() end,
      desc = "Close all folds",
    },
    {
      "zR",
      function() require("ufo").openAllFolds() end,
      desc = "Open all folds",
    },
  },
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    require("ufo").setup()
  end,
}
