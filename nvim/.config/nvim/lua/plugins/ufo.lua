return {
  "kevinhwang91/nvim-ufo",
  event = "User AstroFile",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    require("ufo").setup()
  end,
}
