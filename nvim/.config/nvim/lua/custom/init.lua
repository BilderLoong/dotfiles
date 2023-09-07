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
vim.cmd([[ set nofoldenable ]])


-- local function _start_tsserver()
-- 	--local cwd = vim.loop.cmd()
-- 	local root_dir =
-- 		vim.fs.dirname(vim.fs.find({ "tsconfig.json", "package.json", "jsconfig.json", ".git" }, { upward = true })[1])
--
-- 	vim.print("root_dir", root_dir)
--
-- 	local client = vim.lsp.start({
-- 		name = "tsserver",
-- 		cmd = { "typescript-language-server", "--stdio" },
-- 		root_dir = root_dir,
-- 	})
-- end

-- if vim.g.vim_did_enter then
-- 	_start_tsserver()
-- else
-- 	vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
-- 		--pattern = "*",
-- 		callback = function()
-- 			_start_tsserver()
-- 		end,
-- 	})
-- end


  vim.api.nvim_set_hl(0, 'DiffviewDiffAddAsDelete', { bg = "#431313" })
  vim.api.nvim_set_hl(0, 'DiffDelete', { bg = "none", fg = colors.dark2 })
  vim.api.nvim_set_hl(0, 'DiffviewDiffDelete', { bg = "none", fg = colors.dark2 })
  vim.api.nvim_set_hl(0, 'DiffAdd', { bg = "#142a03" })
  vim.api.nvim_set_hl(0, 'DiffChange', { bg = "#3B3307" })
  vim.api.nvim_set_hl(0, 'DiffText', { bg = "#4D520D" })

require("custom.autocmds")
require("custom.custom_cmds")
