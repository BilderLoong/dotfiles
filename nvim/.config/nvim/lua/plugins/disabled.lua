return {
  -- Disable none-ls (user uses conform.nvim instead)
  { "nvimtools/none-ls.nvim", enabled = false },
  -- Disable mason-null-ls (not needed without none-ls)
  { "jay-babu/mason-null-ls.nvim", enabled = false },
  -- Disable resession.nvim (user uses auto-session)
  { "stevearc/resession.nvim", enabled = false },
}