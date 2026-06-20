return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      signs = {
        add = { hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "NONE", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "NONE", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      word_diff = false,
      current_line_blame = true,
      numhl = false,
      linehl = false,
      current_line_blame_opts = {
        delay = 500,
        ignore_whitespace = true,
      },
    })
  end,
}
