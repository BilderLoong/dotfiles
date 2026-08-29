return {
  -- Disable none-ls (user uses conform.nvim instead)
  { "nvimtools/none-ls.nvim", enabled = false },
  -- Disable mason-null-ls (not needed without none-ls)
  { "jay-babu/mason-null-ls.nvim", enabled = false },
  -- Disable resession.nvim (user uses auto-session)
  { "stevearc/resession.nvim", enabled = false },
  -- Disabled: incompatible with nvim-treesitter's main branch.
  -- Revisit after https://github.com/RRethy/nvim-treesitter-textsubjects/issues/52
  { "RRethy/nvim-treesitter-textsubjects", enabled = false },
}