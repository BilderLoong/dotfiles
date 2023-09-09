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
--
--  DiffChange = { fg = "none", bg = "#272D43" },
  -- DiffText = { fg = "none", bg = "#394b70" },
  -- DiffDelete = { fg = "none", bg = "#3F2D3D" },
  -- DiffviewDiffAddAsDelete = { fg = "none", bg = "#3f2d3d" },
  -- DiffviewDiffDelete = { fg = "none", bg = "#3B4252" },
  -- -- Left pannel
  -- DiffAddAsDelete = { fg = "none", bg = "#3F2D3D" },
--
--
-- GitSignsAddNr                          { GitSignsAdd }, -- GitSignsAddNr  
--     GitSignsDelete                         { fg="#ee5396", }, -- GitSignsDelete 
--     GitSignsDeleteNr                       { GitSignsDelete }, -- GitSignsDeleteNr 
--     DiffviewDiffAddAsDelete                { bg="#311d26", }, -- DiffviewDiffAddAsDelete 
--     DiffviewPrimary                        { fg="#8cb6ff", }, -- DiffviewPrimary 
--     DiffviewSecondary                      { fg="#25be6a", }, -- DiffviewSecondary 
--     DiffviewFilePanelTitle                 { gui="bold", fg="#c8a5ff", }, -- DiffviewFilePanelTitle 

-- function FixGruvbox()
-- 	vim.api.nvim_set_hl(0, "DiffviewDiffAddAsDelete", { bg = "#431313" })
-- 	vim.api.nvim_set_hl(0, "DiffDelete", { bg = "none", fg = colors.dark2 })
-- 	vim.api.nvim_set_hl(0, "DiffviewDiffDelete", { bg = "none", fg = colors.dark2 })
-- 	vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#142a03" })
-- 	vim.api.nvim_set_hl(0, "DiffChange", { bg = "#3B3307" })
-- 	vim.api.nvim_set_hl(0, "DiffText", { bg = "#4D520D" })
-- end
-- FixGruvbox()
--
-- vim.api.nvim_create_autocmd("ColorScheme", { pattern = { "nord" }, callback = FixGruvbox })

require("custom.autocmds")
require("custom.custom_cmds")
-- -- Key:         Ctrl-e
-- -- Action:      Show treesitter capture group for textobject under cursor.
-- bindkey("n",    "<C-e>",
--     function()
--         local result = vim.treesitter.get_captures_at_cursor(0)
--         print(vim.inspect(result))
--     end,
--     { noremap = true, silent = false }
-- )
--
-- -- TSPlayground provided command. (Need to install the plugin.)
-- -- bindkey("n",    "<C-e>",  ":TSHighlightCapturesUnderCursor<CR>",   opts)
-- -- This was misbehaving a lot.
-- -- Might be more stable now in recent treesitter versions.
