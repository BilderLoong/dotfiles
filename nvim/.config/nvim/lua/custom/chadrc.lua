local theme = require("base46").get_theme_tb "base_16"
local colors = require("base46").get_theme_tb "base_30"

---@type ChadrcConfig
local M = {
  mappings = require "custom.mappings",
  plugins = "custom.plugins",
  ui = {
    theme = "nord", -- default theme
    nvdash = {
      load_on_startup = false
    },

    hl_override = {
      DiffAdd=colors.green.
    }
  }
}

-- check core.mappings for table structure

return M
