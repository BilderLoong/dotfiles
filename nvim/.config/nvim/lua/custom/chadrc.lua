---@type ChadrcConfig
local M = {
  mappings = require "custom.mappings",
  plugins = "custom.plugins",
  ui = {
    theme = "tokyonight", -- default theme
    nvdash = {
      load_on_startup = false
    }
  }
}

-- check core.mappings for table structure

return M
