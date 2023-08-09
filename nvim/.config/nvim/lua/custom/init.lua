local opt = vim.opt
local g = vim.g

-- Editor
opt.relativenumber = true
-- opt.wrap = false

-- Folding

-- opt.autochdir = true
--
g.toggle_theme_icon = ""

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.cmd([[
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
  " set nofoldenable                     " Disable folding at startup.
]])
