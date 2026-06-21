return {
  "github/copilot.vim",
  event = "User AstroFile",
  enabled=false,
  cmd = "Copilot",
  config = function()
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_proxy = "localhost:7890"
  end,
}
