return {
  "nvim-java/nvim-java",
  ft = { "java" },
  dependencies = {
    "nvim-java/lua-async-await",
    "nvim-java/nvim-java-core",
    "nvim-java/nvim-java-test",
    "nvim-java/nvim-java-dap",
    "MunifTanjim/nui.nvim",
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "nvim-java/nvim-java-refactor",
  },
  config = function()
    require("java").setup()
  end,
}
