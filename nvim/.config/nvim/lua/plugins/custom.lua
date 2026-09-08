return {
  dir = vim.fn.stdpath "config" .. "/custom",
  name = "user-custom",
  lazy = true,
  cmd = { "CopyLocation", "CopyRelativeLocation" },
  config = function() require("user_custom.commands").setup() end,
}
