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
					Comment = { fg = "#707C96", italic = true },
					["@comment"] = { fg = "#646E86", italic = true },
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
