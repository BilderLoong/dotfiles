return {
  "numToStr/Comment.nvim",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      opts = {
        -- The pre-hook calculates the comment string only when you comment code.
        -- Disable the expensive CursorHold calculation, which can delay cursor movement.
        enable_autocmd = false,
      },
    },
  },
  opts = function()
    return {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
}
