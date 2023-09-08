
-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

-- local theme = require("base46").get_theme_tb "base_16"
-- local colors = require("base46").get_theme_tb "base_30"

---@type ChadrcConfig
local M = {
  mappings = require "custom.mappings",
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

      DiffChange = {
        bg = "yellow",
        fg = "NONE",
      },
    },
  },
}

-- lua require("base46").load_all_highlights()

-- check core.mappings for table structure

return M
