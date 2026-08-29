return {
  "elijahmanor/export-to-vscode.nvim",
  keys = {
    {
      "<Leader>vs",
      function() require("export-to-vscode").launch() end,
      desc = "Export project to VS Code",
    },
  },
}
