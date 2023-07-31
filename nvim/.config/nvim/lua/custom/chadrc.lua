---@type ChadrcConfig
local M = {
  la
  mappings = require "custom.mappings",
  plugins = "custom.plugins",
  ui = {
    theme = "nord", -- default theme
    nvdash = {
      load_on_startup = true
    }
  }
}

-- check core.mappings for table structure

return M
