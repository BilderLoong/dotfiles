local M = {}

---Blend RGB colors without changing the theme's source highlights.
---@param foreground integer
---@param background integer
---@param opacity number
---@return integer
function M.blend(foreground, background, opacity)
  local function channel(shift)
    local fg = math.floor(foreground / 2 ^ shift) % 256
    local bg = math.floor(background / 2 ^ shift) % 256
    return math.floor(fg * opacity + bg * (1 - opacity) + 0.5)
  end
  return channel(16) * 65536 + channel(8) * 256 + channel(0)
end

---@param opts? {opacity?: number}
function M.setup(opts)
  local opacity = opts and opts.opacity or 2 / 3
  assert(type(opacity) == "number" and opacity >= 0 and opacity <= 1, "opacity must be between 0 and 1")
  local function apply()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    -- A transparent terminal background cannot be read from Normal.
    if not normal.fg or not normal.bg then return end
    vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", {
      fg = M.blend(normal.fg, normal.bg, opacity),
      italic = false,
    })
  end
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("unused_highlight", { clear = true }),
    desc = "Fade unused code using the active theme's Normal colors",
    callback = apply,
  })
  apply()
end

return M
