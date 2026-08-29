return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    local upstream_on_attach = opts.on_attach
    local merged_opts = vim.tbl_deep_extend("force", opts, {
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

    merged_opts.on_attach = function(bufnr)
      if upstream_on_attach then upstream_on_attach(bufnr) end
      vim.keymap.set("n", "<Leader>gu", require("gitsigns").undo_stage_hunk, {
        buffer = bufnr,
        desc = "Undo stage hunk",
      })
    end

    return merged_opts
  end,
}
