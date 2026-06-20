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
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "<leader>ghs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>ghr", gitsigns.reset_hunk, "Reset hunk")
        map("n", "<leader>ghu", gitsigns.undo_stage_hunk, "Undo stage hunk")
        map("v", "<leader>ghs", function() gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Stage hunk")
        map("v", "<leader>ghr", function() gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Reset hunk")
        map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
        map("o", "ih", "<cmd>C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    })
  end,
}
