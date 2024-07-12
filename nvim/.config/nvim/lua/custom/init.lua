local opt = vim.opt
local g = vim.g

--Editor
opt.relativenumber = true
--opt.wrap = false

--Folding

--opt.autochdir = true
--
g.toggle_theme_icon = ""

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd [[ set nofoldenable ]]

require "custom.autocmds"
require "custom.custom_cmds"

vim.api.nvim_create_autocmd({ "UIEnter" }, {
  callback = function(args)
    _G.debug_log = require "custom.log"
  end,
})
