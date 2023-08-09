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
  set nofoldenable
]])

