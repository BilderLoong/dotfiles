return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  enabled = false,
  config = function()
    require("lspsaga").setup {
      finder = {
        max_height = 0.6,
        left_width = 0.45,
        right_width = 0.50,
        keys = { vsplit = "v", split = "s" },
        methods = { tyd = "textDocument/typeDefinition" },
      },
      lightbulb = { enable = false },
      code_action = { extend_gitsigns = true },
    }
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
