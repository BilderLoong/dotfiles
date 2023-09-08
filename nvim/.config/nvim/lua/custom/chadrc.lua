 --


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
      DiffAdd
    }
  }
}

-- check core.mappings for table structure

return M
