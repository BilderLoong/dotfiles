return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  config = function()
    require("hover").config {
      providers = {
        "hover.providers.diagnostic",
        "hover.providers.lsp",
      },
      preview_opts = {
        border = "rounded",
      },
      preview_window = false,
      title = true,
      mouse_providers = {},
    }
  end,
}
