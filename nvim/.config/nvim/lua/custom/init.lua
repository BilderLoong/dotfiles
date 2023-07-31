local opt = vim.opt
local g = vim.g

-- Editor
vim.opt.relativenumber = true

-- Folding
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitgre#sbydexpr()"
vim.opt.foldenable = true

-- opt.autochdir = true
