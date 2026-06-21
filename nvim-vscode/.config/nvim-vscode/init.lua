local vscode = require('vscode')

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

-- Set `vim.notify` to VS Code notifications
vim.notify = vscode.notify

vim.keymap.set("", "<Space>", "<Nop>")

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
				{ "<leader>mm", mode = { "n", "o", "x" }, "m",                                                      desc = "Default m key.",               { noremap = true } },
				{ "mx",         mode = { "n" },           function() require("substitute.exchange").operator() end, desc = "Substitute Exchange Operator", { noremap = true } },
				{ "mxx",        mode = { "n" },           function() require("substitute.exchange").line() end,     desc = "Substitute Exchange Line",     { noremap = true } },
				{ "X",          mode = { "x" },           function() require("substitute.exchange").visual() end,   desc = "Substitute Exchange Visual",   { noremap = true } },
				{ "mxc",        mode = { "n" },           function() require("substitute.exchange").cancel() end,   desc = "Substitute Exchange Cancel",   { noremap = true } },
				{ "m",          mode = { "n" },           function() require("substitute").operator() end,          desc = "Substitute Operator",          { noremap = true } },
				{ "mm",         mode = { "n" },           function() require("substitute").line() end,              desc = "Substitute Line",              { noremap = true } },
				{ "M",          mode = { "n" },           function() require("substitute").eol() end,               desc = "Substitute EOL",               { noremap = true } },
				{ "m",          mode = { "x" },           function() require("substitute").visual() end,            desc = "Substitute Visual",            { noremap = true } },
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
						enable = true,
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

-- LSP stuffs
local function LSP()
	vim.keymap.set({ "n", "x" }, "gy", function() vscode.action("editor.action.goToTypeDefinition") end, { desc = "Go to type definition" })
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
		end)

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
	end)

	vim.keymap.set("n", "<Leader>fm", function()
		vscode.action("editor.action.formatDocument")
	end)
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
]])

	--  Toggle Primary Sidebar.
	vim.keymap.set({ "n", "x", "i" }, "<C-n>", function()
		vscode.action("workbench.action.toggleSidebarVisibility")
		-- vscode_neovim.notify("workbench.action.focusSideBar")
	end)

	--  Toggle auxiliary bar.
	vim.keymap.set({ "n", "x", "i" }, "<C-m>", function()
		vscode.action("workbench.action.toggleAuxiliaryBar")
		-- vscode_neovim.notify("workbench.action.focusSideBar")
	end)

	vim.keymap.set({ "i" }, "<M-Space>", function()
		vscode.action("editor.action.triggerSuggest")
	end)

	vim.keymap.set({ "n", "x", "i" }, "<Leader>d", function()
		vscode.action("editor.action.marker.nextInFiles")
	end)

	vim.keymap.set("n", "<Leader>e", function()
		vscode.action("workbench.action.focusSideBar")
	end)
end

vscode_ui()

local function vscode_editor()
	vim.keymap.set("n", "]c", function()
		vscode.action("workbench.action.editor.nextChange")
	end)
	vim.keymap.set("n", "[c", function()
		vscode.action("workbench.action.editor.previousChange")
	end)
end
vscode_editor()

local function editing()
	vim.keymap.set({ "n", "x" }, ">>", function()
		vscode.action("editor.action.indentLines")
	end)

	vim.keymap.set({ "n", "x" }, "<<", function()
		vscode.action("editor.action.outdentLines")
	end)
end

editing()

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
