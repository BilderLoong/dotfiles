-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors--- @type ChadrcConfig
local M = {
	mappings = require("custom.mappings"),
	plugins = "custom.plugins",

	ui = {
		theme = "nord", -- default theme
		nvdash = {
			load_on_startup = false,
		},

		hl_override = {
			DiffAdd = {
				bg = { "green", -25 },
				fg = "NONE",
			},

			DiffDelete = {
				bg = { "red", -2 },
				fg = "NONE",
			},

			DiffText = {
				bg = { "yellow", -30 },
				fg = "NONE",
			},

			DiffChange = {
				bg = { "yellow", -40 },
				fg = "NONE",
			},
		},

		statusline = {
			overriden_modules = function(modules)
        -- Disable LSP progress message: https://github.com/NvChad/ui/blob/6c22f52568c4ab080a6676f7bb6515f0076e6567/lua/nvchad/statusline/default.lua#L105C1-L105C15
				modules[5] = (function()
					return ""
				end)()
			end,
		},
	},
}

-- lua require("base46").load_all_highlights()

-- check core.mappings for table structure

return M
