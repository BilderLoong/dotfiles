-- TODO: learn from https://docs.astronvim.com/recipes/vscode/

local vscode = require('vscode')

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

-- Set `vim.notify` to VS Code notifications
vim.notify = vscode.notify

vim.keymap.set("", "<Space>", "<Nop>", { desc = "Leader key" })

-- The below doesn't work, I don't why.
vim.keymap.set(
	{ "n", "v", "x" },
	"j",
	[[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]],
	-- set `remap` to `true` to use the vscode neovim's `gj` keymap: https://github.com/vscode-neovim/vscode-neovim/blob/4d7a9be9be95ea5e8da793fd810345171a865cd2/vim/vscode-motion.vim#L15-L16
	{ expr = true, silent = true, desc = "Move up", remap = true }
)

vim.keymap.set(
	{ "n", "v", "x" },
	"k",
	[[ v:count || mode(1)[0:1] == "no" ? "k" : "gk" ]],
	{ expr = true, silent = true, desc = "Move down", remap = true }
)


local function deferred_action(method)
	return function()
		vscode.action(method)
	end
end

local notify = vscode.notify

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
			"gbprod/substitute.nvim",
			keys = {
				{ "m",          mode = { "n" },           function() require("substitute").operator() end,          desc = "Substitute Operator",          { noremap = true } },
				{ "mm",         mode = { "n" },           function() require("substitute").line() end,              desc = "Substitute Line",              { noremap = true } },
				{ "M",          mode = { "n" },           function() require("substitute").eol() end,               desc = "Substitute EOL",               { noremap = true } },
				{ "m",          mode = { "x" },           function() require("substitute").visual() end,            desc = "Substitute Visual",            { noremap = true } },
				{ "<leader>mm", mode = { "n", "o", "x" }, "m",                                                      desc = "Default m key.",               { noremap = true } },
				{ "mx",         mode = { "n" },           function() require("substitute.exchange").operator() end, desc = "Substitute Exchange Operator", { noremap = true } },
				{ "mxx",        mode = { "n" },           function() require("substitute.exchange").line() end,     desc = "Substitute Exchange Line",     { noremap = true } },
				{ "X",          mode = { "x" },           function() require("substitute.exchange").visual() end,   desc = "Substitute Exchange Visual",   { noremap = true } },
				{ "mxc",        mode = { "n" },           function() require("substitute.exchange").cancel() end,   desc = "Substitute Exchange Cancel",   { noremap = true } },
			},
			opts = {},
			config = function(_, opts)
				require("substitute").setup {
					on_substitute = require("yanky.integration").substitute(),
				}
			end,
			dependencies = {
				{
					"gbprod/yanky.nvim",
					event = { "TextYankPost" },
					opts = {},
					config = function(_, opts)
						require("yanky").setup(opts)
					end,
				}
			}
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

		{
			"nvim-treesitter/nvim-treesitter",
			opts = function()
				return {
				highlight = {
					enable = false,
					additional_vim_regex_highlighting = false,
				},
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
							init_selection = "\\",
							node_incremental = "\\",
							scope_incremental = false, -- https://github.com/tjdevries/nvim-treesitter/blob/3c7528a29458a94dff3730f08356b7505a9bbda1/doc/nvim-treesitter.txt#L46
							node_decremental = "<bs>",
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
						"rust",

						-- low level
						"c",
						"zig",

						-- other
						"python"
					},
				}
			end,
			config = function(_, opts)
				require("nvim-treesitter.configs").setup(opts)
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- VeryLazy instead of BufReadPost: VS Code session restore opens buffers
			-- before the plugin's FileType autocmd is registered. If this plugin loads
			-- on BufReadPost, the initial buffers miss the textobject keymap attachment
			-- and treesitter textobjects (daf, vif, etc.) silently do nothing.
			event = "VeryLazy",
			dependencies = "nvim-treesitter/nvim-treesitter",
		},

		{
			"folke/flash.nvim",
			event = "BufReadPost",
			---@type Flash.Config
			opts = {},
			-- stylua: ignore
			keys = {
				{ "s",     mode = { "n", "o", "x" }, function() require("flash").jump() end,              desc = "Flash" },
				{ "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
				-- { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" }, // doesn't work in vscode
				{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
				{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
			},
		},
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

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false

-- LSP stuffs
local function LSP()
	vim.keymap.set({ "n", "x" }, "gy", function() vscode.action("editor.action.goToTypeDefinition") end,
		{ desc = "Go to type definition" })
	vim.keymap.set({ "n", "x" }, "gc", "<Plug>VSCodeCommentary", { desc = "Comment" })
	vim.keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine", { desc = "Comment line" })

	vim.keymap.set({ "n", "x" }, "<Leader>ca", deferred_action("editor.action.quickFix"), { desc = "Code Action" })
	vim.keymap.set(
		{ "n", "x" },
		"<Leader>cf",
		deferred_action("editor.action.organizeImports"),
		{ desc = "Organize Imports" }
	)
	vim.keymap.set(
		{ "n", "x" },
		"<Leader>cgr",
		function()
			vscode.action("gitlens.copyRemoteFileUrlToClipboard")
			vscode.notify("gitlens.copyRemoteFileUrlToClipboard done!")
		end,
		{ desc = "Copy remote URL" }
	)

	local function mappingGoToReference()
		-- Fix: goToReferences selects text in current buffer, which vscode-neovim syncs as visual mode. https://github.com/vscode-neovim/vscode-neovim/issues/1738
		-- Use a flag + ModeChanged autocmd to auto-escape after jumping to a reference.
		local gr_pending = false
		vim.keymap.set("n", "gr", function()
			gr_pending = true
			vscode.action("editor.action.goToReferences")
			vim.defer_fn(function()
				gr_pending = false
			end, 10000)
		end, { desc = "Go to references" })

		vim.api.nvim_create_autocmd("ModeChanged", {
			pattern = "n:[vV\x16]",
			callback = function()
				if gr_pending then
					gr_pending = false
					-- Clear VS Code selection to prevent re-sync, then exit visual mode
					vscode.eval([[
					const editor = vscode.window.activeTextEditor;
					if (editor) {
						const pos = editor.selection.active;
						editor.selection = new vscode.Selection(pos, pos);
					}
				]])
					vim.api.nvim_input("<Esc>")
				end
			end,
		})
	end
	mappingGoToReference()


	vim.keymap.set("n", "<Leader>fs", function()
		vscode.action("workbench.action.showAllSymbols")
	end, { desc = "Show all symbols" })

	vim.keymap.set("n", "<Leader>fm", function()
		vscode.action("editor.action.formatDocument")
	end, { desc = "Format document" })
end
LSP()

-- Folder
local function folder()
	vim.keymap.set("n", "zc", function() vscode.action("editor.fold") end, { desc = "Fold" })
	vim.keymap.set("n", "zo", function() vscode.action("editor.unfold") end, { desc = "Unfold" })
	vim.keymap.set("n", "zC", function() vscode.action("editor.foldRecursively") end, { desc = "Fold recursively" })
	vim.keymap.set("n", "zO", function() vscode.action("editor.unfoldRecursively") end, { desc = "Unfold recursively" })
end
folder()

-- Control VSCode native ui.
local function vscode_ui()
	vim.keymap.set({ "n", "x" }, "<C-j>", function() vscode.action("workbench.action.navigateDown") end,
		{ desc = "Navigate down" })
	vim.keymap.set({ "n", "x" }, "<C-k>", function() vscode.action("workbench.action.navigateUp") end,
		{ desc = "Navigate up" })
	vim.keymap.set({ "n", "x" }, "<C-h>", function() vscode.action("workbench.action.navigateLeft") end,
		{ desc = "Navigate left" })
	vim.keymap.set({ "n", "x" }, "<C-l>", function() vscode.action("workbench.action.navigateRight") end,
		{ desc = "Navigate right" })

	--  Toggle Primary Sidebar.
	vim.keymap.set({ "n", "x", "i" }, "<C-n>", function()
		vscode.action("workbench.action.toggleSidebarVisibility")
	end, { desc = "Toggle sidebar" })

	--  Toggle auxiliary bar.
	vim.keymap.set({ "n", "x", "i" }, "<C-m>", function()
		vscode.action("workbench.action.toggleAuxiliaryBar")
	end, { desc = "Toggle auxiliary bar" })

	-- vim.keymap.set({ "i" }, "<M-Space>", function()
	-- 	vscode.action("editor.action.triggerSuggest")
	-- end, { desc = "Trigger suggest" })

	-- vim.keymap.set({ "n", "x", "i" }, "<Leader>d", function()
	-- 	vscode.action("editor.action.marker.nextInFiles")
	-- end, { desc = "Next diagnostic" })

	-- vim.keymap.set("n", "<Leader>e", function()
	-- 	vscode.action("workbench.action.focusSideBar")
	-- end, { desc = "Focus sidebar" })
end

vscode_ui()

local function vscode_editor()
	vim.keymap.set("n", "]c", function()
		vscode.action("workbench.action.editor.nextChange")
	end, { desc = "Next editor change" })
	vim.keymap.set("n", "[c", function()
		vscode.action("workbench.action.editor.previousChange")
	end, { desc = "Previous editor change" })
end
vscode_editor()

local function editing()
	vim.keymap.set({ "n", "x" }, ">>", function()
		vscode.action("editor.action.indentLines")
	end, { desc = "Indent lines" })

	vim.keymap.set({ "n", "x" }, "<<", function()
		vscode.action("editor.action.outdentLines")
	end, { desc = "Outdent lines" })
end

editing()

-- Override ALL vscode-neovim default keybindings from runtime/vscode/overrides/ with explicit desc.
-- Without this, those defaults are invisible in the <Leader>? cheatsheet.
local function vscode_neovim_overrides()
	-- vscode-code-actions.vim overrides
	vim.keymap.set({ "n", "x" }, "K", function() vscode.action("editor.action.showHover") end, { desc = "Hover" })
	vim.keymap.set({ "n", "x" }, "gh", function() vscode.action("editor.action.showHover") end, { desc = "Hover" })
	vim.keymap.set({ "n", "x" }, "gd", function() vscode.action("editor.action.revealDefinition") end,
		{ desc = "Go to definition" })
	vim.keymap.set({ "n", "x" }, "gf", function() vscode.action("editor.action.revealDeclaration") end,
		{ desc = "Go to declaration" })
	-- vim.keymap.set({ "n", "x" }, "<C-]>", function() vscode.action("editor.action.revealDefinition") end, { desc = "Go to definition" })
	vim.keymap.set({ "n", "x" }, "gO", function() vscode.action("workbench.action.gotoSymbol") end,
		{ desc = "Go to symbol" })
	vim.keymap.set({ "n", "x" }, "gF", function() vscode.action("editor.action.peekDeclaration") end,
		{ desc = "Peek declaration" })
	vim.keymap.set({ "n", "x" }, "gD", function() vscode.action("editor.action.peekDefinition") end,
		{ desc = "Peek definition" })
	vim.keymap.set({ "n", "x" }, "gH", function() vscode.action("editor.action.referenceSearch.trigger") end,
		{ desc = "References" })
	vim.keymap.set({ "n", "x" }, "<C-w>gd", function() vscode.action("editor.action.revealDefinitionAside") end,
		{ desc = "Definition aside" })
	vim.keymap.set({ "n", "x" }, "<C-w>gf", function() vscode.action("editor.action.revealDefinitionAside") end,
		{ desc = "Declaration aside" })
	-- vim.keymap.set("n", "z=", function() vscode.action("editor.action.quickFix") end, { desc = "Quick fix / Spelling" })

	-- vscode-file-commands.vim overrides
	vim.keymap.set("n", "ZZ", function()
		vscode.call("workbench.action.files.save")
		vscode.action("workbench.action.closeActiveEditor")
	end, { desc = "Save and close" })
	vim.keymap.set("n", "ZQ", function() vscode.action("workbench.action.revertAndCloseActiveEditor") end,
		{ desc = "Quit without saving" })

	-- vscode-jumplist.vim overrides
	vim.keymap.set("n", "<C-o>", function() vscode.action("workbench.action.navigateBack") end, { desc = "Jump back" })
	vim.keymap.set("n", "<C-t>", function() vscode.action("workbench.action.navigateBack") end, { desc = "Jump back" })
	vim.keymap.set("n", "<C-i>", function() vscode.action("workbench.action.navigateForward") end,
		{ desc = "Jump forward" })
	vim.keymap.set("n", "Tab", function() vscode.action("workbench.action.navigateForward") end,
		{ desc = "Jump forward" })

	-- vscode-motion.vim overrides
	vim.keymap.set("n", "g0", function()
		vscode.action("cursorMove", { args = { to = "wrappedLineFirstNonWhitespaceCharacter" } })
	end, { desc = "Screen line start" })
	vim.keymap.set("n", "g$", function()
		vscode.action("cursorMove", { args = { to = "wrappedLineLastNonWhitespaceCharacter" } })
		vscode.action("cursorLeft")
	end, { desc = "Screen line end" })
	vim.keymap.set("n", "gk", function()
		vscode.action("cursorMove", { args = { to = "up", by = "wrappedLine", value = vim.v.count1 } })
	end, { desc = "Screen line up" })
	vim.keymap.set("n", "gj", function()
		vscode.action("cursorMove", { args = { to = "down", by = "wrappedLine", value = vim.v.count1 } })
	end, { desc = "Screen line down" })

	-- vscode-scrolling.vim overrides
	-- These use VSCodeExtensionNotify (extension internal events), NOT vscode.action().
	-- The "reveal" and "move-cursor" events are handled by vscode-neovim's eventBus,
	-- not registered as VS Code commands. vscode.action() would fall back to
	-- commands.executeCommand() which fails for internal events.
	-- Wrapping in vim.cmd("call VSCodeExtensionNotify(...)") lets us use vim.keymap.set
	-- with desc while still calling the correct extension API.
	vim.keymap.set({ "n", "x" }, "z<CR>", function() vim.cmd("call VSCodeExtensionNotify('reveal', 'top', 1)") end,
		{ desc = "Top + cursor" })

	vim.keymap.set({ "n", "x" }, "zt", function() vim.cmd("call VSCodeExtensionNotify('reveal', 'top', 0)") end,
		{ desc = "Scroll top" })

	vim.keymap.set({ "n", "x" }, "z.", function() vim.cmd("call VSCodeExtensionNotify('reveal', 'center', 1)") end,
		{ desc = "Center + cursor" })

	vim.keymap.set({ "n", "x" }, "zz", function() vim.cmd("call VSCodeExtensionNotify('reveal', 'center', 0)") end,
		{ desc = "Scroll center" })

	vim.keymap.set({ "n", "x" }, "z-", function() vim.cmd("call VSCodeExtensionNotify('reveal', 'bottom', 1)") end,
		{ desc = "Bottom + cursor" })

	vim.keymap.set({ "n", "x" }, "zb", function() vim.cmd("call VSCodeExtensionNotify('reveal', 'bottom', 0)") end,
		{ desc = "Scroll bottom" })

	vim.keymap.set({ "n", "x" }, "H", function()
		vim.cmd("normal! m'")
		vim.cmd("call VSCodeExtensionNotify('move-cursor', 'top')")
	end, { desc = "Cursor top" })

	vim.keymap.set({ "n", "x" }, "M", function()
		vim.cmd("normal! m'")
		vim.cmd("call VSCodeExtensionNotify('move-cursor', 'middle')")
	end, { desc = "Cursor middle" })

	vim.keymap.set({ "n", "x" }, "L", function()
		vim.cmd("normal! m'")
		vim.cmd("call VSCodeExtensionNotify('move-cursor', 'bottom')")
	end, { desc = "Cursor bottom" })

	-- vscode-tab-commands.vim overrides
	vim.keymap.set({ "n", "x" }, "gt", function()
		local count = vim.v.count
		if count > 0 then
			vscode.call("workbench.action.openEditorAtIndex" .. count)
		else
			vscode.action("workbench.action.nextEditorInGroup")
		end
	end, { desc = "Next tab" })
	vim.keymap.set({ "n", "x" }, "gT", function() vscode.action("workbench.action.previousEditorInGroup") end,
		{ desc = "Previous tab" })

	-- vscode-window-commands.vim overrides
	-- Splits
	vim.keymap.set({ "n", "x" }, "<C-w>s", function() vscode.action("workbench.action.splitEditorDown") end,
		{ desc = "Split horizontal" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-s>", function() vscode.action("workbench.action.splitEditorDown") end, { desc = "Split horizontal" })
	vim.keymap.set({ "n", "x" }, "<C-w>v", function() vscode.action("workbench.action.splitEditorRight") end,
		{ desc = "Split vertical" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-v>", function() vscode.action("workbench.action.splitEditorRight") end, { desc = "Split vertical" })
	vim.keymap.set({ "n", "x" }, "<C-w>n", function() vscode.action("workbench.action.splitEditorDown") end,
		{ desc = "New split" })

	-- Close
	vim.keymap.set({ "n", "x" }, "<C-w>c", function() vscode.action("workbench.action.closeActiveEditor") end,
		{ desc = "Close window" })
	-- vim.keymap.set({ "n", "x" }, "<C-w>q", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close window" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-c>", function() vscode.action("workbench.action.closeActiveEditor") end, { desc = "Close window" })

	-- Only / Join
	vim.keymap.set({ "n", "x" }, "<C-w>o", function() vscode.action("workbench.action.joinAllGroups") end,
		{ desc = "Only window" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-o>", function() vscode.action("workbench.action.joinAllGroups") end, { desc = "Only window" })

	-- Size
	vim.keymap.set({ "n", "x" }, "<C-w>=", function() vscode.action("workbench.action.evenEditorWidths") end,
		{ desc = "Equalize splits" })
	vim.keymap.set({ "n", "x" }, "<C-w>_", function() vscode.action("workbench.action.toggleEditorWidths") end,
		{ desc = "Maximize height" })
	vim.keymap.set({ "n", "x" }, "<C-w>+", function() vscode.action("workbench.action.increaseViewHeight") end,
		{ desc = "Increase height" })
	vim.keymap.set({ "n", "x" }, "<C-w>-", function() vscode.action("workbench.action.decreaseViewHeight") end,
		{ desc = "Decrease height" })
	vim.keymap.set({ "n", "x" }, "<C-w>>", function() vscode.action("workbench.action.increaseViewWidth") end,
		{ desc = "Increase width" })
	vim.keymap.set({ "n", "x" }, "<C-w><", function() vscode.action("workbench.action.decreaseViewWidth") end,
		{ desc = "Decrease width" })

	-- Navigate between splits
	vim.keymap.set({ "n", "x" }, "<C-w>w", function() vscode.action("workbench.action.focusNextGroup") end,
		{ desc = "Next window" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-w>", function() vscode.action("workbench.action.focusNextGroup") end, { desc = "Next window" })
	-- vim.keymap.set({ "n", "x" }, "<C-w>W", function() vscode.action("workbench.action.focusPreviousGroup") end, { desc = "Previous window" })
	vim.keymap.set({ "n", "x" }, "<C-w>p", function() vscode.action("workbench.action.focusPreviousGroup") end,
		{ desc = "Previous window" })
	vim.keymap.set({ "n", "x" }, "<C-w>t", function() vscode.action("workbench.action.focusFirstEditorGroup") end,
		{ desc = "First window" })
	vim.keymap.set({ "n", "x" }, "<C-w>b", function() vscode.action("workbench.action.focusLastEditorGroup") end,
		{ desc = "Last window" })
	vim.keymap.set({ "n", "x" }, "<C-w>j", function() vscode.action("workbench.action.navigateDown") end,
		{ desc = "Window down" })
	vim.keymap.set({ "n", "x" }, "<C-w>k", function() vscode.action("workbench.action.navigateUp") end,
		{ desc = "Window up" })
	vim.keymap.set({ "n", "x" }, "<C-w>h", function() vscode.action("workbench.action.navigateLeft") end,
		{ desc = "Window left" })
	vim.keymap.set({ "n", "x" }, "<C-w>l", function() vscode.action("workbench.action.navigateRight") end,
		{ desc = "Window right" })

	-- Move editor to split
	vim.keymap.set({ "n", "x" }, "<C-w><C-j>", function() vscode.action("workbench.action.moveEditorToBelowGroup") end,
		{ desc = "Move to split below" })
	vim.keymap.set({ "n", "x" }, "<C-w><C-k>", function() vscode.action("workbench.action.moveEditorToAboveGroup") end,
		{ desc = "Move to split above" })
	vim.keymap.set({ "n", "x" }, "<C-w><C-h>", function() vscode.action("workbench.action.moveEditorToLeftGroup") end,
		{ desc = "Move to split left" })
	vim.keymap.set({ "n", "x" }, "<C-w><C-l>", function() vscode.action("workbench.action.moveEditorToRightGroup") end,
		{ desc = "Move to split right" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-Down>", function() vscode.action("workbench.action.moveEditorToBelowGroup") end, { desc = "Move to split below" })
	vim.keymap.set({ "n", "x" }, "<C-w><C-Up>", function() vscode.action("workbench.action.moveEditorToAboveGroup") end,
		{ desc = "Move to split above" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-Left>", function() vscode.action("workbench.action.moveEditorToLeftGroup") end, { desc = "Move to split left" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><C-Right>", function() vscode.action("workbench.action.moveEditorToRightGroup") end, { desc = "Move to split right" })

	-- Navigate with arrow keys
	vim.keymap.set({ "n", "x" }, "<C-w><Down>", function() vscode.action("workbench.action.navigateDown") end,
		{ desc = "Window down" })
	vim.keymap.set({ "n", "x" }, "<C-w><Up>", function() vscode.action("workbench.action.navigateUp") end,
		{ desc = "Window up" })
	vim.keymap.set({ "n", "x" }, "<C-w><Left>", function() vscode.action("workbench.action.navigateLeft") end,
		{ desc = "Window left" })
	vim.keymap.set({ "n", "x" }, "<C-w><Right>", function() vscode.action("workbench.action.navigateRight") end,
		{ desc = "Window right" })

	-- Move active editor group
	vim.keymap.set({ "n", "x" }, "<C-w>J", function() vscode.action("workbench.action.moveActiveEditorGroupDown") end,
		{ desc = "Move group down" })
	vim.keymap.set({ "n", "x" }, "<C-w>K", function() vscode.action("workbench.action.moveActiveEditorGroupUp") end,
		{ desc = "Move group up" })
	vim.keymap.set({ "n", "x" }, "<C-w>H", function() vscode.action("workbench.action.moveActiveEditorGroupLeft") end,
		{ desc = "Move group left" })
	vim.keymap.set({ "n", "x" }, "<C-w>L", function() vscode.action("workbench.action.moveActiveEditorGroupRight") end,
		{ desc = "Move group right" })

	-- Move active editor group with shift+arrow
	-- vim.keymap.set({ "n", "x" }, "<C-w><S-Down>",
	-- 	function() vscode.action("workbench.action.moveActiveEditorGroupDown") end, { desc = "Move group down" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><S-Up>", function() vscode.action("workbench.action.moveActiveEditorGroupUp") end,
	-- 	{ desc = "Move group up" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><S-Left>",
	-- 	function() vscode.action("workbench.action.moveActiveEditorGroupLeft") end, { desc = "Move group left" })
	-- vim.keymap.set({ "n", "x" }, "<C-w><S-Right>",
	-- 	function() vscode.action("workbench.action.moveActiveEditorGroupRight") end, { desc = "Move group right" })
end
vscode_neovim_overrides()


local function show_mapping()
	local function get_content()
		local maps = vim.api.nvim_get_keymap("")
		local lines = { "# Keymaps Cheatsheet", "" }

		local mode_names = { n = "Normal", v = "Visual", x = "Visual", i = "Insert", o = "Operator", c = "Command" }
		local grouped = {}
		local order = { "n", "v", "x", "i", "o", "c" }

		for _, m in ipairs(maps) do
			local mode = m.mode or "n"
			if not grouped[mode] then grouped[mode] = {} end
			table.insert(grouped[mode], m)
		end

		for _, mode in ipairs(order) do
			if grouped[mode] and #grouped[mode] > 0 then
				table.insert(lines, "## " .. (mode_names[mode] or mode))
				table.insert(lines, "")
				table.insert(lines, "| Key | Description |")
				table.insert(lines, "|-----|-------------|")
				for _, m in ipairs(grouped[mode]) do
					local lhs = m.lhs or ""
					local desc = m.desc or (m.callback and "[function]") or ""
					table.insert(lines, string.format("| `%s` | %s |", lhs, desc))
				end
				table.insert(lines, "")
			end
		end
		return table.concat(lines, "\n")
	end

	local content = get_content()
	local uniqueId = "keymaps-" .. os.time() .. ".md"

	vscode.eval([[
		if (!globalThis.__keymap_provider) {
			const contents = new Map();
			globalThis.__keymap_provider = { contents };
			try {
				vscode.workspace.registerTextDocumentContentProvider("nvim-keymaps", {
					provideTextDocumentContent(uri) {
						return contents.get(uri.path) || "";
					}
				});
			} catch (e) {}
		}
		globalThis.__keymap_provider.contents.set(args.id, args.content);
		const uri = vscode.Uri.parse("nvim-keymaps:" + args.id);
		const doc = await vscode.workspace.openTextDocument(uri);
		await vscode.window.showTextDocument(doc, vscode.ViewColumn.Beside);
	]], { args = { content = content, id = uniqueId } })
end

vim.keymap.set("n", "<Leader>?", show_mapping, { desc = "Show all keymaps" })
