vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

local vscode_neovim = require("vscode-neovim")
local keymap = vim.keymap

vim.cmd([[
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')]])

vim.keymap.set("", "<Space>", "<Nop>")
vim.keymap.set(
	{ "n", "v", "x" },
	"j",
	'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
	{ expr = true, desc = "Move up" }
)
vim.keymap.set(
	{ "n", "v", "x" },
	"k",
	'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
	{ expr = true, desc = "Move down" }
)

local function notify(method)
	return function()
		-- vscode_neovim.notify(...)
		vscode_neovim.notify(method)
	end
end

local function plugins()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	---@type NvPluginSpec[]
	require("lazy").setup({
		{
			"unblevable/quick-scope",
			event = "BufReadPost",
			config = function()
				vim.cmd([[
			  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
			  highlight QuickScopeSecondary guifg='#6fffff' gui=underline ctermfg=81 cterm=underline
   ]])
			end,
		},

		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			keys = { "c", "y", "d" },
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		},

		{
			"wellle/targets.vim",
			event = "BufReadPost",
		},

		-- In favor of flash.nvim.
		-- {
		-- 	"ggandor/lightspeed.nvim",
		-- 	event = "BufReadPost",
		-- },

		{
			"nvim-treesitter/nvim-treesitter",
			opts = function()
				return {
					highlight = {
						enable = false,
						additional_vim_regex_highlighting = false,
					},
					-- https://github.com/AstroNvim/AstroNvim/blob/ffaa3877f0dd3a7468f29e81cf4ebf534a5ad891/lua/plugins/treesitter.lua#L35
					-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
					textobjects = {
						select = {
							enable = true,
							lookahead = true,
							keymaps = {
								["ak"] = { query = "@block.outer", desc = "around block" },
								["ik"] = { query = "@block.inner", desc = "inside block" },
								["ac"] = { query = "@class.outer", desc = "around class" },
								["ic"] = { query = "@class.inner", desc = "inside class" },
								["a?"] = { query = "@conditional.outer", desc = "around conditional" },
								["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
								["af"] = { query = "@function.outer", desc = "around function " },
								["if"] = { query = "@function.inner", desc = "inside function " },
								["al"] = { query = "@loop.outer", desc = "around loop" },
								["il"] = { query = "@loop.inner", desc = "inside loop" },
								["aa"] = { query = "@parameter.outer", desc = "around argument" },
								["ia"] = { query = "@parameter.inner", desc = "inside argument" },
							},
						},
						move = {
							enable = true,
							set_jumps = true,
							goto_next_start = {
								["]k"] = { query = "@block.outer", desc = "Next block start" },
								["]f"] = { query = "@function.outer", desc = "Next function start" },
								["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
							},
							goto_next_end = {
								["]K"] = { query = "@block.outer", desc = "Next block end" },
								["]F"] = { query = "@function.outer", desc = "Next function end" },
								["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
							},
							goto_previous_start = {
								["[k"] = { query = "@block.outer", desc = "Previous block start" },
								["[f"] = { query = "@function.outer", desc = "Previous function start" },
								["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
							},
							goto_previous_end = {
								["[K"] = { query = "@block.outer", desc = "Previous block end" },
								["[F"] = { query = "@function.outer", desc = "Previous function end" },
								["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
							},
						},
						swap = {
							enable = true,
							swap_next = {
								[">K"] = { query = "@block.outer", desc = "Swap next block" },
								[">F"] = { query = "@function.outer", desc = "Swap next function" },
								[">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
							},
							swap_previous = {
								["<K"] = { query = "@block.outer", desc = "Swap previous block" },
								["<F"] = { query = "@function.outer", desc = "Swap previous function" },
								["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
							},
						},
					},

					-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#plugins-with-a-pre-comment-hook
					context_commentstring = {
						enable = false,
						enable_autocmd = false,
					},

					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "gnn",
							node_incremental = "grn",
							scope_incremental = "grc",
							node_decremental = "grm",
						},
					},

					-- Automatically install missing parsers when entering buffer
					-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
					auto_install = true,
					ensure_installed = {
						-- defaults
						"vim",
						"lua",

						-- web dev
						"html",
						"css",
						"javascript",
						"typescript",
						"tsx",
						"json",
						"vue",
						"go",

						-- low level
						"c",
						"zig",
					},
				}
			end,
			config = function(_, opts)
				require("nvim-treesitter.configs").setup(opts)
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			event = "BufReadPost",
			dependencies = "nvim-treesitter/nvim-treesitter",
		},

		{
			"folke/flash.nvim",
			event = "BufReadPost",
			---@type Flash.Config
			opts = {},
       -- stylua: ignore
      keys = {
        { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
        { "m", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
		},
		-- Doesn't in VSCodeNeovim due to dependencies of LSP: https://github.com/mfussenegger/nvim-treehopper/blob/5a28bff46c05d28bdb4bcaef67e046eb915a9390/lua/tsht.lua#L96
		--[[ {
			"mfussenegger/nvim-treehopper",
			dependencies = "nvim-treesitter/nvim-treesitter",
			event = "BufReadPost",
			-- keys = { "v", "y", "d", "c" },
			config = function(_, opts)
				vim.keymap.set({ "o", "x" }, "m", ":<C-U>lua require('tsht').nodes()<CR>")
			end,
		}, ]]
	}, {
		performance = {

			defaults = {
				lazy = true, -- should plugins be lazy-loaded?
			},

			rtp = {
				disabled_plugins = {
					"2html_plugin",
					"tohtml",
					"getscript",
					"getscriptPlugin",
					"gzip",
					"logipat",
					"netrw",
					"netrwPlugin",
					"netrwSettings",
					"netrwFileHandlers",
					"matchit",
					"tar",
					"tarPlugin",
					"rrhelper",
					"spellfile_plugin",
					"vimball",
					"vimballPlugin",
					"zip",
					"zipPlugin",
					"tutor",
					"rplugin",
					"syntax",
					"synmenu",
					"optwin",
					"compiler",
					"bugreport",
					"ftplugin",
				},
			},
		},
	})
end
plugins()

-- LSP stuffs
local function LSP()
	vim.cmd([[
    nnoremap gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>
    xnoremap gy <Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>

    map gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

  ]])

	keymap.set({ "n", "x" }, "<Leader>ca", notify("editor.action.quickFix"), { desc = "Code Action" })
	keymap.set({ "n", "x" }, "<Leader>cf", notify("editor.action.organizeImports"), { desc = "Organize Imports" })
	keymap.set({ "n", "x" }, "<Leader>cf", notify("gitlens.copyRemoteFileUrlToClipboard"), { desc = "Copy remote URL" })

	vim.keymap.set("n", "gr", function()
		vscode_neovim.notify("editor.action.goToReferences")
	end)

	vim.keymap.set("n", "<Leader>fm", function()
		vscode_neovim.notify("editor.action.formatDocument")
	end)
end
LSP()

-- Folder
local function folder()
	vim.cmd([[
    nnoremap zc <Cmd>call VSCodeNotify('editor.fold')<CR>
    nnoremap zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
    nnoremap zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
    nnoremap zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>

  ]])
end
folder()

-- Control VSCode native ui.
local function vscode_ui()
	-- To make the below take effect, need to add thoese keys in VSCode's keymap config: https://github.com/vscode-neovim/vscode-neovim#adding-keybindings
	vim.cmd([[
    " Move cursor between windows in a tab.
    nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
    xnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
    nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
    xnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
    nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
    xnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
    nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>
    xnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>

    " Toggle Second Sidebar.
    nnoremap <M-n> <Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>
    xnoremap <M-n> <Cmd>call VSCodeNotify('workbench.action.toggleAuxiliaryBar')<CR>
]])

	--  Toggle Primary Sidebar.
	keymap.set({ "n", "x", "i" }, "<C-n>", function()
		vscode_neovim.notify("workbench.action.toggleSidebarVisibility")
		-- vscode_neovim.notify("workbench.action.focusSideBar")
	end)

	keymap.set("n", "<Leader>e", function()
		vscode_neovim.notify("workbench.action.focusSideBar")
	end)
end
vscode_ui()

local function vscode_editor()
	keymap.set("n", "]c", function()
		vscode_neovim.notify("workbench.action.editor.nextChange")
	end)
	keymap.set("n", "[c", function()
		vscode_neovim.notify("workbench.action.editor.previousChange")
	end)
end
vscode_editor()
