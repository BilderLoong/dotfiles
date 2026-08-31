return {
  "lewis6991/hover.nvim",
  event = "LspAttach",
  config = function()
    require("hover").config {
      providers = {
        "hover.providers.diagnostic",
        "hover.providers.lsp",
        "hover.providers.dap",
        "hover.providers.man",
        "hover.providers.dictionary",
      },
      preview_opts = {
        border = "rounded",
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        "hover.providers.lsp",
      },
      mouse_delay = 1000,
    }
  end,
}
