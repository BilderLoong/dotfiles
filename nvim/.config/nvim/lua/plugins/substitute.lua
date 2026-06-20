return {
  "gbprod/substitute.nvim",
  keys = {
    { "<leader>mm", mode = { "n", "o", "x" }, "m", desc = "Default m key.", { noremap = true } },
    { "mx", mode = { "n" }, function() require("substitute.exchange").operator() end, desc = "Substitute Exchange Operator", { noremap = true } },
    { "mxx", mode = { "n" }, function() require("substitute.exchange").line() end, desc = "Substitute Exchange Line", { noremap = true } },
    { "X", mode = { "x" }, function() require("substitute.exchange").visual() end, desc = "Substitute Exchange Visual", { noremap = true } },
    { "mxc", mode = { "n" }, function() require("substitute.exchange").cancel() end, desc = "Substitute Exchange Cancel", { noremap = true } },
    { "m", mode = { "n" }, function() require("substitute").operator() end, desc = "Substitute Operator", { noremap = true } },
    { "mm", mode = { "n" }, function() require("substitute").line() end, desc = "Substitute Line", { noremap = true } },
    { "M", mode = { "n" }, function() require("substitute").eol() end, desc = "Substitute EOL", { noremap = true } },
    { "m", mode = { "x" }, function() require("substitute").visual() end, desc = "Substitute Visual", { noremap = true } },
  },
  opts = {},
  config = function(_, opts)
    require("substitute").setup {
      on_substitute = require("yanky.integration").substitute(),
    }
  end,
}
