---@type AstroLSPOpts
local opts = { features = { codelens = "wrong" } }
---@param value string
local function takes_string(value) return value end
takes_string(42)
return opts
