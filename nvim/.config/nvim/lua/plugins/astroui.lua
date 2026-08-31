-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
	{
		"gbprod/nord.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function(_, opts)
			require("nord").setup(opts)
		end,
	},
	{
		"AstroNvim/astroui",
		---@type AstroUIOpts
		opts = {
			-- change colorscheme
			colorscheme = "nord",
			-- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
			highlights = {
				init = { -- this table overrides highlights in all themes
					-- Normal = { bg = "#000000" },
				},
				nord = { -- a table of overrides/changes when applying the Nord theme
					Comment = { fg = "#75809C", italic = true },
					["@comment"] = { fg = "#75809C", italic = true },
					-- VS Code-style diffs: tinted lines with stronger changed-text highlights.
					DiffAdd = { bg = "#404E47" },
					DiffDelete = { bg = "#642F37" },
					DiffChange = { bg = "#2E3440" },
					DiffText = { bg = "#3C5362" },
					DiffviewDiffOldLine = { bg = "#642F37" },
					DiffviewDiffOldText = { bg = "#642F37" },
					DiffviewDiffNewLine = { bg = "#404E47" },
					DiffviewDiffNewText = { bg = "#404E47" },
					SnacksDiffAdd = { bg = "#404E47" },
					SnacksDiffDelete = { bg = "#642F37" },
					SnacksDiffContext = { bg = "#2E3440" },
					SnacksDiffAddLineNr = { fg = "#758E68", bg = "#2E3440" },
					SnacksDiffDeleteLineNr = { fg = "#9F6462", bg = "#2E3440" },
					SnacksDiffContextLineNr = { fg = "#75809C", bg = "#2E3440" },
				},
			},
			-- Icons can be configured throughout the interface
			icons = {
				-- configure the loading of the lsp in the status line
				LSPLoading1 = "⠋",
				LSPLoading2 = "⠙",
				LSPLoading3 = "⠹",
				LSPLoading4 = "⠸",
				LSPLoading5 = "⠼",
				LSPLoading6 = "⠴",
				LSPLoading7 = "⠦",
				LSPLoading8 = "⠧",
				LSPLoading9 = "⠇",
				LSPLoading10 = "⠏",
			},
		},
	},
}
