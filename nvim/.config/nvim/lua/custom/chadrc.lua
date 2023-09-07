---@type ChadrcConfig
local M = {
	mappings = require("custom.mappings"),
	plugins = "custom.plugins",
	ui = {
		theme = "nord", -- default theme
		nvdash = {
			load_on_startup = false,
		},
		changed_themes = {
			onedark = {
				base_16 = {
					base00 = "#mycol",
				},
				base_30 = {
					red = "#mycol",
					white = "#mycol",
				},
			},

			nord = {
				-- and so on!
			},
		},
	},
}

-- check core.mappings for table structure

return M
